<template>
  <div class="wrapper">
    <div>
      <div>kenneth.vet</div>
    </div>
    <div class="actions">
      <Button @onClick="finalizeBidding" size="medium">Finalize Bid</Button>
      <Button @onClick="finalizeAuction" size="medium">Finalize Auction</Button>
      <Button @onClick="revealBid" size="medium">Reveal</Button>
    </div>
  </div>
</template>

<script>
  import { find } from 'lodash';
  import { toWei, fromAscii } from 'web3-utils';

  import Button from '@/components/Button';

  export default {
    name: 'AppAuction',
    components: {
      Button,
    },
    methods: {
      revealBid() {
        const revealBidABI = find(this.$contract.abi, { name: 'revealBid' });
        const revealBid = window.connex.thor.account(this.$address).method(revealBidABI);

        const comment = 'reveal';
        const value = toWei('5', 'ether');
        const clause = revealBid.value(value).asClause(this.auctionID, fromAscii('ken'));

        this.tx({
          clause,
          comment,
          signer: window.signer,
        });
      },
      finalizeBidding() {
        const finalizeBiddingABI = find(this.$contract.abi, { name: 'finalizeBidding' });
        const finalizeBidding = window.connex.thor.account(this.$address).method(finalizeBiddingABI);

        const comment = 'end auction';
        const clause = finalizeBidding.asClause(1)

        this.tx({
          clause,
          comment,
          signer: window.signer,
        });
      },
      finalizeAuction() {
        const finalizeAuctionABI = find(this.$contract.abi, { name: 'finalizeAuction' });
        const finalizeAuction = window.connex.thor.account(this.$address).method(finalizeAuctionABI);

        const comment = 'finalize auction';
        const clause = finalizeAuction.asClause(this.auctionID)

        this.tx({
          clause,
          comment,
          signer: window.signer,
        });
      },
    }
  }
</script>

<style lang="scss" scoped>
  .wrapper {
    display: flex;
    justify-content: space-between;
  }

  .actions {
    display: flex;
    justify-content: flex-end;

    button {
      margin-left: 20px;
    }
  }

  h4 {
    font-size: 3rem;
    margin: 0;
  }
</style>
