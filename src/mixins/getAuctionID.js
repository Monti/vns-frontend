import { find } from 'lodash';

const getAuctionID = {
  methods: {
    getAuctionID(domain) {
      const getAuctionIDABI = find(this.$contract.abi, { name: 'getAuctionID' });
      const getAuctionID = window.connex.thor.account(this.$address).method(getAuctionIDABI);

      return getAuctionID.call(domain);
    },
  }
};

export default getAuctionID;
