pragma solidity ^0.5.2;

import "openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol";
import "openzeppelin-solidity/contracts/drafts/Counters.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "./utils/StringLength.sol";

// Notes:
// * All domains must be lower case, this will be done by enforcing 0-9, a-z

contract ThorNode {
    function isX(address _target) public pure returns(bool){}
}

contract Registry is ERC721Full, Ownable {
    // using Counters for Counters.Counter;
    using StringLength for string;
    using SafeMath for uint256;
    
    constructor() ERC721Full("VeChain Name Service", "VNS") public {
        _tokenCount.increment();                                // Start counters at 1
        _auctionCount.increment();                              // Start counters at 1
        _thorNodeContract = ThorNode(0xd4dac3a95c741773F093d59256A21ED6FCc768a7);    // Testnet Address
    }

    // Collected fees stored in the contract's balance
    uint private _collectedFees;
    uint private _costPerYear = 1 ether;
    uint private _behaviourBond = 5 ether;
    uint private _biddingTime = 3 minutes;
    uint private _revealTime = 3 minutes;
    uint private _regularLength = 7;
    uint private _xnodeLength = 4;
    ThorNode private _thorNodeContract;

    struct Auction {
        uint                    winningBid;
        address                 winningBidder;
        uint                    auctionEnd;
        string                  domainName;
        bool                    biddingEnded;
        uint                    revealEnd;
        mapping(address => bytes32) blindedBid;                 // Mapping from id to shielded bids - sending a new bid updates your bid
    }

    struct Domain {
        string                  domainName;
        uint                    domainBond;                     // Amount paid for the domain minus fees thus far
        uint                    yearlyCost;
        bool                    autoRenew;
        uint                    domainExpires;
    }

    Counters.Counter private _tokenCount;
    Counters.Counter private _auctionCount;

    // Mapping from token to domain name
    mapping(uint256 => Domain) private _tokenToDomain;

    // Mapping from domain to address
    mapping(string => address) private _domainToAddress;

    // Mapping from subdomain to address
    mapping(string => address) private _subDomainToAddress;

    // Mapping from auction ID to auction struct
    mapping(uint256 => Auction) private _auctions;

    // Mapping from domain names to active auction status.
    mapping(string => uint256) private _domainToAuction;

    // Mapping from address to refunds
    mapping(address => uint) private _refunds;

    // Mapping from tokenIDs to purchase cost
    mapping(uint256 => uint256) private _tokenToCost;

    // Mapping from tokenIDs to purchase cost
    mapping(address => uint256[]) private _userAuctions;


    // Events
    event domainRegistered (
        address indexed _owner,
        string  indexed _domain,
        uint256 indexed _tokenID,
        uint256 _bond
    );

    event auctionStarted (
        uint256 indexed _auctionID,
        string  indexed _domain,
        uint256 _auctionEnd
    );

    event auctionEnded (
        uint256 indexed _auctionID,
        string  indexed _domain,
        address indexed _winningBidder,
        uint256 _winningBid
    );

    event biddingClosed (
        uint256 indexed _auctionID,
        string  indexed _domain
    );

    event domainAddressChanged (
        uint256 indexed _tokenID,
        string  indexed _domain,
        address indexed _targetAddress
    );


    // View Functions
    // function getFeesEarned() external view returns (uint256 contractBalance, uint256 feesEarned) {
    //     return (address(this).balance, _collectedFees);
    // }

    // VIP-181 Functions
    function tokensOfOwner(address owner) external view returns (uint256[] memory) {
        return _tokensOfOwner(owner);
    }

    // Domain
    function getDomain(uint256 _tokenID) external view returns (string memory domainName, uint domainBond, uint yearlyCost, bool autoRenew, uint domainExpires) {
        Domain memory d = _tokenToDomain[_tokenID];

        return (d.domainName, d.domainBond, d.yearlyCost, d.autoRenew, d.domainExpires);
    }

    function resolveDomain(string calldata _domainName) external view returns (address) {
        return _domainToAddress[_domainName];
    }

    // Auction
    function getAuction(uint256 _auctionID) external view 
        returns (uint winningBid, address winningBidder, uint auctionEnd, string memory domainName, bool biddingEnded, uint revealEnd) {
        
        Auction memory a = _auctions[_auctionID];

        return (a.winningBid, a.winningBidder, a.auctionEnd, a.domainName, a.biddingEnded, a.revealEnd);
    }

    function getAuctionID(string calldata _domain) external view returns (uint256 auctionID) {
        return _domainToAuction[_domain];
    }

    function getUserAuctions(address _user) external view returns (uint256[] memory auctions) {
        return _userAuctions[_user];
    }

    function getUserRefunds(address _user) external view returns (uint256 refundsAvailable) {
        return _refunds[_user];
    }

    // External Public Functions
    // Domain Functions

    function isX() public view returns(bool) {
        return _thorNodeContract.isX(msg.sender);
    }

    function isOwner(uint256 _tokenID) public view returns(bool) {
        return msg.sender == ownerOf(_tokenID);
    }

    function setDomain(uint256 _tokenID, address _targetAddress) public {
        require (
            msg.sender == ownerOf(_tokenID),
            "Only the owner of the domain can set its address"
        );

        string memory _domainName = _tokenToDomain[_tokenID].domainName;
        _domainToAddress[_domainName] = _targetAddress;
        emit domainAddressChanged(_tokenID, _domainName, _targetAddress);
    }

    function addSubdomain(uint256 _tokenID, string calldata _subDomain, address _targetAddress) external {
        _isApprovedOrOwner(msg.sender, _tokenID);

        string memory _domain = _tokenToDomain[_tokenID].domainName;
        _subDomainToAddress[string(abi.encodePacked(_subDomain, ".", _domain))] = _targetAddress;
    }

    function removeSubdomain(uint256 _tokenID, string calldata _subDomain) external {
        _isApprovedOrOwner(msg.sender, _tokenID);

        string memory _domain = _tokenToDomain[_tokenID].domainName;
        _subDomainToAddress[string(abi.encodePacked(_subDomain, ".", _domain))] = address(0);
    }
    
    function invalidateDomain(uint256 _tokenID) external {         
        Domain memory d = _tokenToDomain[_tokenID];                                 // Lets users delete domains that are > 6 chars

        if (_thorNodeContract.isX(ownerOf(_tokenID))) {
            require(
                d.domainName.strlen() < _xnodeLength,
                "Domain name is not too short"
            );
        } else {
            require(
                d.domainName.strlen() < _regularLength,
                "Domain name is not too short"
            );
        }

        _collectedFees += _tokenToDomain[_tokenID].domainBond;
        _burnDomain(_tokenID, d.domainName);                                        // Wipe domain data and delete the token
    }

    function popDomain(uint256 _tokenID) external {
        Domain memory d = _tokenToDomain[_tokenID];

        require(
            now > d.domainExpires && d.autoRenew == false,
            "Can't pop domain before expiry"
        );

        _refunds[ownerOf(_tokenID)] = _refunds[ownerOf(_tokenID)].add(d.domainBond);
        _burnDomain(_tokenID, d.domainName);
    }

    function collectDues(uint256 _tokenID) external payable {
        Domain storage d = _tokenToDomain[_tokenID];

        require (
            d.autoRenew == true,
            "Only auto-renewing domains can pay dues"
        );

        uint256 _yearsBehind = now.sub(d.domainExpires) / 365 days + 1;             // Throws if d.domainExpires > now, rounds up years overdue
        
        // IF a domain can cover renewal costs
        if (_yearsBehind * _costPerYear <= d.domainBond) {                          // If the domain is not behind, cost is 0, statement will always pass
            d.domainBond -= _yearsBehind * _costPerYear;
            d.domainExpires += _yearsBehind * 365 days;
            return;
        }

        // IF a domain cannot cover renewal costs, it is de-registered without refund
        _collectedFees += d.domainBond;
        _burnDomain(_tokenID, d.domainName);
    }

    function withdrawEarly(uint256 _tokenID) external {
        Domain memory d = _tokenToDomain[_tokenID];

        require (
            msg.sender == ownerOf(_tokenID),
            "Only the owner of a domain can deregister"
        );

        _refunds[ownerOf(_tokenID)] = _refunds[ownerOf(_tokenID)].add(d.domainBond);
        _burnDomain(_tokenID, d.domainName);
    }

    function extendDomain(uint256 _tokenID, uint256 _years) external payable {
        Domain storage d = _tokenToDomain[_tokenID];
        
        require(
            msg.value == _costPerYear * _years,
            "Payment must cover purchase"
        );

        d.domainExpires.add(_years * 365);
        _collectedFees += msg.value;
    }

    function enableAutoRewnew(uint256 _tokenID) external {
        _tokenToDomain[_tokenID].autoRenew = true;
    }

    // Auction Functions
    function startAuction(string calldata _domain) external payable returns (uint256 id) {
        return _newAuction(_domain);
    }

    function bidOnAuction(uint256 _auctionID, bytes32 _blindedBid) external payable {       // !!! CHECK IF THIS IS RE-ENTERABLE !!!
        Auction storage a = _auctions[_auctionID];
        
        require(
            now < a.auctionEnd && !a.biddingEnded,
            "Cannot bid after auction has ended"
        );

        require(
            msg.value == _behaviourBond,                                        // Bond dissincentivises no-show bidding
            "Bidder must attach a good behaviour bond"
        );

        _userAuctions[msg.sender].push(_auctionID);                             // Let the user find the a

        if (a.blindedBid[msg.sender] == "") {                                   // If user doesn't already have a bid
            a.blindedBid[msg.sender] = _blindedBid;
            return;
        } else {
            a.blindedBid[msg.sender] = _blindedBid;
            msg.sender.transfer(_behaviourBond);                                // Refund their 2nd behaviour bond !!! CHECK IF THIS IS RE-ENTERABLE !!!
        }
    }

    function finalizeBidding(uint256 _auctionID) external {
        Auction storage a = _auctions[_auctionID];
        
        require(
            now > a.auctionEnd && !a.biddingEnded,
            "Cannot close an auction too early, or after it has already been closed"
        );

        a.biddingEnded = true;
        a.revealEnd = now + _revealTime;
        emit biddingClosed(_auctionID, a.domainName);
    }

    function revealBid(uint256 _auctionID, bytes32 _secret) external payable returns (bool winning) {
        Auction storage a = _auctions[_auctionID];
        
        require(
            a.biddingEnded && now < a.revealEnd,
            "Cannot reveal before auction has ended, or after reveal period has ended"
        );

        require(
            a.blindedBid[msg.sender] == keccak256(abi.encodePacked(msg.value, _secret)),
            "Secret or attached value were incorrect"
        );

        if (msg.value <= a.winningBid) {
            delete(a.blindedBid[msg.sender]);
            msg.sender.transfer(msg.value + _behaviourBond);
            return false;
        }

        if (a.winningBidder != address(0)) {
            _refunds[a.winningBidder] = _refunds[a.winningBidder].add(a.winningBid + _behaviourBond);
        }

        a.winningBidder = msg.sender;
        a.winningBid = msg.value;
        return true;
    }

    function finalizeAuction(uint256 _auctionID) external {
        Auction storage a = _auctions[_auctionID];
        
        require(
            now > a.revealEnd && a.revealEnd != 0,
            "Cannot finalize the auction too early"
        );

        if (a.winningBidder != address(0)) {
            _registerDomain(a.domainName, a.winningBidder, a.winningBid + _behaviourBond);   // Winning bidder, if they exist, receives the domain
        }
        emit auctionEnded(_auctionID, a.domainName, a.winningBidder, a.winningBid);
        delete(_auctions[_auctionID]);                                      // Delete the auction struct
    }

    function claimRefund(address payable _claimant) external {
        uint256 _amountToRefund = _refunds[_claimant];
        _refunds[_claimant] = 0;                                            // Reset refundable amount before refunding
        _claimant.transfer(_amountToRefund);
    }

    function claimFees(address payable _owner) external {
        require(
            _owner == owner(),
            "Can only transfer accrued fees to owner"
        );

        uint256 _receivable = _collectedFees;
        _collectedFees = 0;
        _owner.transfer(_receivable);
    }

    // Private Functions
    function _registerDomain(string memory _domainName, address _owner, uint256 _pricePaid) internal {
        require(
            verifyNewDomain(_domainName),
            "Domain is already registered"
        );          

        uint256 _tokenID = _tokenCount.current();                           // tokenID is equal to its count
        _mint(_owner, _tokenID);                                            // Call the mint function of ERC721Enumerable
        _tokenCount.increment();                                            // Increment counter after minting

        // Set VNS Specific Data
        _collectedFees += _costPerYear;
        _tokenToDomain[_tokenID] = Domain(_domainName, _pricePaid - _costPerYear, _costPerYear, false, now + 365 days);   // Auto renewals are off by default
        _domainToAddress[_domainName] = _owner;                             // Intialize the address to point at the owner

        delete(_domainToAuction[_domainName]);                              // Stop blocking new auctions for this domain (should the domain deregister)
        emit domainRegistered(_owner, _domainName, _tokenID, _pricePaid - _costPerYear);
    }

    function _newAuction(string memory _domain) internal returns (uint256) {
        require(
            verifyNewDomain(_domain),
            "Can't register an already existing domain"
        );
        require(
            _domainToAuction[_domain] == 0,
            "There is already an active auction for this domain"
        );

        uint _auctionID = _auctionCount.current();
        uint _auctionEnd = now + _biddingTime;                              // Bidding lasts 3 days
        _auctions[_auctionID] = Auction(0, address(0), _auctionEnd, _domain, false, 0);   // Creates new auction struct in the auctions mapping
        _domainToAuction[_domain] = _auctionID;

        _auctionCount.increment();
        emit auctionStarted(_auctionID, _domain, _auctionEnd);
        return _auctionID;
    }

    // Helper Functions
    function verifyNewDomain(string memory _domainName) internal view returns (bool) {
        return _domainToAddress[_domainName] == address(0);
    }

    function _burnDomain(uint256 _tokenID, string memory _domainName) internal {
        delete _tokenToDomain[_tokenID];
        delete _domainToAddress[_domainName];
        _burn(ownerOf(_tokenID), _tokenID);
    }

}
