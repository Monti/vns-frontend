<template>
  <div>
    <div class="auction-wrapper">
      <div>
        <div class="domain">{{ auction[3] }}.vet</div>
        <div class="detail">
          <small v-if="!auctionEnded">auction end: {{ auction[2] | moment }}</small>
          <small v-if="auctionEnded">auction ended at {{ auction[2] | moment }}</small>
        </div>
        <div class="detail">
          <small v-if="auction[4]">bidding has ended</small>
          <small v-else>bidding has not ended</small>
        </div>
        <div class="detail">
          <small v-if="revealStarted">reveal ended at {{ auction[5] | moment }}</small>
          <small v-else>reveal period has not started</small>
        </div>
        <div class="detail" v-if="revealStarted && revealStarted">
          <small>reveal has ended <br />you can complete the auction!</small>
        </div>
      </div>
      <div class="actions">
        <Button @onClick="finalizeBidding" size="medium">Finalize Bid</Button>
        <small>then</small>
        <Button @onClick="revealBid" size="medium">Reveal Bid</Button>
        <small>then</small>
        <Button @onClick="finalizeAuction" size="medium">Complete Auction</Button>
      </div>
    </div>
    <div v-if="reveal" class="addBid">

      <div v-if="error" class="error">
        <small>You need to enter a secret</small>
      </div>

      <form @submit.prevent="submit" ref="form">
        <AppInput
          type="text"
          size="medium"
          v-model="secret"
          autofocus="true"
          placeholder="type your secret"
        />

        <AppInput
          type="number"
          size="medium"
          v-model="bid"
          placeholder="type your bid"
        />

        <Button>Reveal Bid</Button>
      </form>
    </div>
  </div>

</template>

<script>
  import { find } from 'lodash';
  import moment from 'moment';
  import { toWei, soliditySha3 } from 'web3-utils';

  import tx from '@/mixins/tx';
  import getAuctionID from '@/mixins/getAuctionID';
  import Button from '@/components/Button';
  import AppInput from '@/components/AppInput'

  export default {
    name: 'AppAuction',
    mixins: [tx, getAuctionID],
    props: ['auction'],
    data() {
      return {
        bid: null,
        error: null,
        secret: null ,
        reveal: false,
        auctionID: null,
      }
    },
    components: {
      Button,
      AppInput,
    },
    mounted() {
      this.getAuctionID(this.auction[3]).then(({ decoded }) => {
        this.auctionID = decoded[0];
      });
    },
    computed: {
      auctionEnded() {
        const now = Math.floor((new Date()).getTime() / 1000);
        return this.auction[2] < now;
      },
      revealStarted() {
        return parseInt(this.auction[5]) !== 0;
      },
      revealEnded() {
        const now = Math.floor((new Date()).getTime() / 1000);
        return this.auction[5] < now;
      }
    },
    methods: {
      revealBid() {
        this.reveal = true;
      },
      submit() {
        const signingService = window.connex.vendor.sign('tx');
        const revealBidABI = find(this.$contract.abi, { name: 'revealBid' });
        const revealBid = window.connex.thor.account(this.$address).method(revealBidABI);

        const comment = 'reveal bid';

        const userBid = toWei(this.bid, 'ether');
        const secret = soliditySha3(this.secret);

        const clause = revealBid.value(userBid).asClause(this.auctionID, secret);

        signingService
          .signer(window.signer)
          .gas(116000)
          .link('https://connex.vecha.in/{txid')
          .comment(comment)
          .request([ clause ]);
      },
      finalizeBidding() {
        const signingService = window.connex.vendor.sign('tx');
        const finalizeBiddingABI = find(this.$contract.abi, { name: 'finalizeBidding' });
        const finalizeBidding = window.connex.thor.account(this.$address).method(finalizeBiddingABI);

        const comment = 'finalize bidding';
        const clause = finalizeBidding.asClause(this.auctionID);

        signingService
          .signer(window.signer)
          .gas(111000)
          .link('https://connex.vecha.in/{txid')
          .comment(comment)
          .request([ clause ]);
      },
      finalizeAuction() {
        const signingService = window.connex.vendor.sign('tx');
        const finalizeAuctionABI = find(this.$contract.abi, { name: 'finalizeAuction' });
        const finalizeAuction = window.connex.thor.account(this.$address).method(finalizeAuctionABI);

        const comment = 'finalize auction';
        const clause = finalizeAuction.asClause(this.auctionID)

        signingService
          .signer(window.signer)
          .gas(593051)
          .link('https://connex.vecha.in/{txid')
          .comment(comment)
          .request([ clause ]);
      },
    },
    filters: {
      moment(value) {
        return moment(value * 1000).format("MM/DD/YYYY hh:mma");
      }
    }
  }
</script>

<style lang="scss" scoped>
  .domain {
    font-size: 1.2rem;
    font-weight: bold;
    padding: 10px 0;
  }

  .auction-wrapper {
    display: flex;
    justify-content: space-between;
  }

  .actions {
    display: flex;
    justify-content: flex-end;

    small {
      margin: 0 10px;
    }
  }

  h4 {
    font-size: 3rem;
    margin: 0;
  }

  form {
    width: 100%;
  }

  .detail {
    border-top: 2px dashed #ccc;
    padding: 10px 0;
  }

  .addBid {
    display: flex;
    text-align: right;
    top: 100%;
    margin-top: 20px;
    justify-content: flex-end;
    

    .input {
      margin-bottom: 20px;
    }

    .error {
      text-align: left;

      small {
        color: #E87D9B;
        margin: 0;
      }
    }
  }
</style>
