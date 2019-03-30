<template>
  <div>
    <div class="auction-wrapper">
      <div>
        <div class="domain">{{ auction[3] }}.vet</div>
        <small>auction end: {{ auction[2] }}</small>
      </div>
      <div class="actions">
        <Button @onClick="finalizeBidding" size="medium">Finalize Bid</Button>
        <Button @onClick="finalizeAuction" size="medium">Finalize Auction</Button>
        <Button @onClick="revealBid" size="medium">Reveal Bid</Button>


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
    methods: {
      revealBid() {
        this.reveal = true;
      },
      submit() {
        const revealBidABI = find(this.$contract.abi, { name: 'revealBid' });
        const revealBid = window.connex.thor.account(this.$address).method(revealBidABI);

        const comment = 'reveal';

        const userBid = toWei(this.bid, 'ether');
        const secret = soliditySha3(this.secret);

        const clause = revealBid.value(userBid).asClause(this.auctionID, secret);

        this.tx({ clause, comment, signer: window.signer });
      },
      finalizeBidding() {
        const finalizeBiddingABI = find(this.$contract.abi, { name: 'finalizeBidding' });
        const finalizeBidding = window.connex.thor.account(this.$address).method(finalizeBiddingABI);

        const comment = 'end auction';
        const clause = finalizeBidding.asClause(1)

        this.tx({ clause, comment, signer: window.signer });
      },
      finalizeAuction() {
        const finalizeAuctionABI = find(this.$contract.abi, { name: 'finalizeAuction' });
        const finalizeAuction = window.connex.thor.account(this.$address).method(finalizeAuctionABI);

        const comment = 'finalize auction';
        const clause = finalizeAuction.asClause(this.auctionID)

        this.tx({ clause, comment, signer: window.signer });
      },
    }
  }
</script>

<style lang="scss" scoped>
  .domain {
    font-weight: bold;
  }

  .auction-wrapper {
    display: flex;
    justify-content: space-between;
  }

  .actions {
    display: flex;
    justify-content: flex-end;

    button:not(:first-of-type) {
      margin-left: 20px;
    }
  }

  h4 {
    font-size: 3rem;
    margin: 0;
  }

  form {
    width: 100%;
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
