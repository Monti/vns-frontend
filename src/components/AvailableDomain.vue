<template>
  <div>
    <div class="card">
      <div class="title">
        <h3>{{ domain }}<span>.vet</span></h3>
        <div>is available</div>
      </div>

      <section>
        <div class="info">
          <div class="price">
            2000 VET
            <div>
              <small>+ gas fee</small>
            </div>
          </div>
          <div class="actions">
            <Button @onClick="startAuction">Start Auction</Button>
            <small>then</small>
            <Button @onClick="addBid">Add A Bid</Button>

            <div v-if="bid" class="addBid">
              <input type="text" v-model="secret" placeholder="type your secret" autofocus />
              <Button @onClick="bidOnAuction">Add Bid</Button>
            </div>

          </div>
        </div>
      </section>
    </div>

    <Button @onClick="finalizeBidding">Finalize Bidding</Button>
    <Button @onClick="finalizeAuction">Finalize Auction</Button>
    <Button @onClick="revealBid">Reveal Bid</Button>

  </div>
</template>

<script>
  import { picasso } from '@vechain/picasso';
  import { find } from 'lodash';
  import { toWei, soliditySha3, utf8ToHex } from 'web3-utils'; // UTF-8 is the default for ethereum related strings

  import tx from '@/mixins/tx';
  import getAuctionID from '@/mixins/getAuctionID';

  import Doodle from '@/components/Doodle';
  import Button from '@/components/Button';

  import { Star } from '@/components/Icons';

  export default {
    name: "AvailableDomain",
    props: ['domain'],
    mixins: [tx, getAuctionID],
    components: {
      Button,
      Doodle,
      Star,
    },
    data() {
      return {
        bid: false,
        secret: null,
        selected: true,
        auctionID: null,
      }
    },
    mounted() {
      const doodle = document.getElementById('doodle');

      this.getAuctionID().then(({ decoded }) => {
        this.auctionID = decoded[0];
      });
    },
    methods: {
      avatar() {
        return picasso('0x7567D83b7b8d80ADdCb281A71d54Fc7B3364ffed');
      },
      addBid() {
        this.bid = true;
      },
      startAuction() {
        const startAuctionABI = find(this.$contract.abi, { name: 'startAuction' });
        const startAuction = window.connex.thor.account(this.$address).method(startAuctionABI);

        const comment = 'start auction';
        const clause = startAuction.value(toWei('1', 'ether')).asClause(this.domain);

        this.tx({
          clause,
          comment,
          signer: window.signer,
        });
      },
      revealBid() {
        const revealBidABI = find(this.$contract.abi, { name: 'revealBid' });
        const revealBid = window.connex.thor.account(this.$address).method(revealBidABI);

        const comment = 'reveal';

        const userBid = toWei('10', 'ether');
        const secret = utf8ToHex('ken');
        const clause = revealBid.value(userBid).asClause(this.auctionID, secret);
        
        // Please log secret, userBid to check the processing is proper
        console.log(secret);
        console.log(userBid);
        // Remove after issues are resolved

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
      bidOnAuction() {
        const bidOnAuctionABI = find(this.$contract.abi, { name: 'bidOnAuction' });
        const bidOnAuction = window.connex.thor.account(this.$address).method(bidOnAuctionABI);

        const comment = 'bid auction';
        const value = toWei('5', 'ether');

        const userBid = toWei('10', 'ether');
        const userSecret = utf8ToHex('ken');
        const blindedBid = soliditySha3({type: 'uint256', value: userBid}, {type: 'bytes32', value: userSecret});  // Must be bytes32
        
        // Please log userSecret, blindedBid, userBid to check the processing is proper
        console.log(userSecret);
        console.log(userBid);
        console.log(blindedBid);
        // Remove after issues are resolved

        const clause = bidOnAuction.value(value).asClause(this.auctionID, blindedBid);

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
  .title {
    div {
      color: #ffa56d;
    }

  }
  
  .unavailable {
    background-color: #E87D9B;
  }

  .card {
    align-items: center;
    display: flex;
    justify-content: space-between;

    h3 {
      font-size: 3rem;
      margin: 0;
    }
  }

  .info {
    align-items: center;
    display: flex;
  }

  .price {
    margin-right: 20px;
  }

  .owner {
    align-items: center;
    display: flex;
    font-size: 0.9rem;
    margin-bottom: 10px;
  }

  .avatar {
    border-radius: 3px;
    display: block;
    height: 20px;
    margin: 5px;
    width: 20px;
  }

  .footer {
    display: flex;
    justify-content: flex-end;
  }

  .actions {
    align-items: center;
    display: flex;
    position: relative;

    small {
      margin: 0 20px;
    }
  }

  .addBid {
    position: absolute;
    text-align: right;
    top: 100%;
    margin-top: 20px;
    width: 100%;

    input {
      padding: 20px;
      margin-bottom: 20px;
    }
  }
</style>


bid bid bid -> finalize bidding -> reveal bidding -> finalize auction
