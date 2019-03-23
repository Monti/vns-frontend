pragma solidity ^0.5.2;

import "openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol";
import "openzeppelin-solidity/contracts/drafts/Counters.sol";
import "./utils/StringLength.sol";

// Notes:
// * All domains must be lower case, this will be done by enforcing 0-9, a-z

contract Registry is ERC721Full {
    using Counters for Counters.Counter;
    using StringLength for string;
    
    constructor() ERC721Full("VeChain Name Service", "VNS") public {
        _tokenCount.increment();                        // Start counters at 1
        _auctionCount.increment();                      // Start counters at 1
    }

    struct Auction {
        uint                    winningBid;
        address                 winningBidder;
        uint                    auctionEnd;
        string                  domainName;
        bool                    auctionEnded;
        mapping(address => uint)   refunds;                // Mapping from address to refund amount
    }

    Counters.Counter private _tokenCount;
    Counters.Counter private _auctionCount;

    // Mapping from token to domain name
    mapping(uint256 => string) private _tokenDomain;

    // Mapping from domain to address
    mapping(string => address) private _domainAddress;

    // Mapping from domain to subdomain
    mapping(string => string) private _subDomainToDomain;

    // Mapping from subdomain to address
    mapping(string => address) private _subDomainToAddress;

    // Mapping from auction ID to auction struct
    mapping(uint256 => Auction) private _auctions;

    // Mapping from domain names to active auction status.
    mapping(string => uint256) private _domainToAuction;

    // View Functions
    // Domain
    function resolveDomain(string calldata _domainName) external view returns (address) {
        return _domainAddress[_domainName];
    }

    // Auction
    function getWinningBid(uint256 _auctionID) external view returns (uint256) {
        return _auctions[_auctionID].winningBid;
    }

    function getWinningBidder(uint256 _auctionID) external view returns (address) {
        return _auctions[_auctionID].winningBidder;
    }

    function getAuctionEnd(uint256 _auctionID) external view returns (uint256) {
        return _auctions[_auctionID].auctionEnd;
    }

    // External Public Functions
    // Domain Functions
    function addSubdomain(uint256 _tokenID, string calldata _subDomain, address _targetAddress) external {
        _isApprovedOrOwner(msg.sender, _tokenID);

        string memory _domain = _tokenDomain[_tokenID];
        _subDomainToDomain[string(abi.encodePacked(_subDomain, ".", _domain))] = _domain;
        _subDomainToAddress[string(abi.encodePacked(_subDomain, ".", _domain))] = _targetAddress;
    }

    function removeSubdomain(uint256 _tokenID, string calldata _subDomain) external {
        _isApprovedOrOwner(msg.sender, _tokenID);

        string memory _domain = _tokenDomain[_tokenID];
        _subDomainToDomain[string(abi.encodePacked(_subDomain, ".", _domain))] = "";
        _subDomainToAddress[string(abi.encodePacked(_subDomain, ".", _domain))] = address(0);
    }
    
    function invalidateDomain(uint256 _tokenID) external {                          // Lets users delete domains that are > 6 chars
        string memory domainName =  _tokenDomain[_tokenID];
        require(StringLength.strlen(domainName) < 7);                                            // Minimum size is 6, longer domains will be deleted

        _burnDomain(_tokenID, domainName);                                          // Wipe domain data and delete the token
    }

    // Auction Functions
    function startAuction(string calldata _domain) external payable {
        uint _auctionID = _auctionCount.current();
        _newAuction(_domain);
        
        if (msg.value > 1 ether) {                                  // For testing, minimum is 1 eth / vet
            _bidOnAuction(_auctionID, msg.value, msg.sender);
        }
    }

    function bidOnAuction(uint256 _auctionID) external payable {
        _bidOnAuction(_auctionID, msg.value, msg.sender);
    }

    function claimRefund(uint256 _auctionID) external {             // [Q] Do we need to check that it's not empty?
        Auction storage a = _auctions[_auctionID];

        uint amount = a.refunds[msg.sender];                        // Save how much to refund before wiping the entry
        a.refunds[msg.sender] = 0;                                  // Reset the refund amount before processing refund

        msg.sender.transfer(amount);                                // Transfer the amount to the refundee
    }

    function finalizeAuction(uint256 _auctionID) external {
        Auction storage a = _auctions[_auctionID];
        require(
            !a.auctionEnded && now > a.auctionEnd,
            "Auction must be expired and not ended"
        );

        _registerDomain(a.domainName, a.winningBidder);

        a.auctionEnded = true;                                  // Prevent new bids on the auction
        _domainToAuction[a.domainName] = 0;                     // Reset entry in domainToAuction
        
        // Emit Auction Close Event
    }

    // Private Functions
    function _registerDomain(string memory _domainName, address _owner) internal {
        require(
            verifyNewDomain(_domainName),
            "Domain is already registered"
        );          

        uint256 _tokenID = _tokenCount.current();               // tokenID is equal to its count
        _mint(_owner, _tokenID);                                // Call the mint function of ERC721Enumerable
        _tokenCount.increment();                                // Increment counter after minting

        // Set VNS Specific Data
        _tokenDomain[_tokenID] = _domainName;                   // Link the tokenID to the current address
        _domainAddress[_domainName] = _owner;                   // Intialize the address to point at the owner
    }

    function _newAuction(string memory _domain) internal {
        require(
            verifyNewDomain(_domain),
            "Domain is already registered"
        );
        require(
            _domainToAuction[_domain] == 0,
            "There is already an active auction for this domain"
        );

        uint _auctionID = _auctionCount.current();
        uint _auctionEnd = now + 5 minutes;                        // Bidding lasts 3 days
        _auctions[_auctionID] = Auction(0, address(0), _auctionEnd, _domain, false);   // Creates new auction struct in the auctions mapping
        _domainToAuction[_domain] = _auctionID;

        _auctionCount.increment();
    }

    function _bidOnAuction(uint _auctionID, uint _bid, address _bidder) internal {
        Auction storage a = _auctions[_auctionID];
        require(
            _bid > a.winningBid,
            "New bid must dethrone winning bid"
        );
        
        require(
            now < a.auctionEnd && !a.auctionEnded,
            "Cannot bid after auction has ended"
        );
        
        require(
            _bid > 10,
            "Bid amount must be greater than minimum bid"
        );

        // Refund the previous top bidder
        uint _refundAmount = a.winningBid;
        address _refundAddress = a.winningBidder;
        a.refunds[_refundAddress] += _refundAmount;

        a.winningBid = _bid;
        a.winningBidder = _bidder;
    }

    // Helper Functions
    function verifyNewDomain(string memory _domainName) internal view returns (bool) {
        return _domainAddress[_domainName] == address(0);
    }

    function _burnDomain(uint256 _tokenID, string memory _domainName) internal {
        delete _tokenDomain[_tokenID];
        delete _domainAddress[_domainName];
        _burn(ownerOf(_tokenID), _tokenID);
    }

}
