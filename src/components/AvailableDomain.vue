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
            1000 VET
            <div>
              <small>+ gas fee</small>
            </div>
          </div>
          <div class="actions">
            <Button @onClick="startAuction">Start Auction</Button>
            <small>then</small>
            <Button @onClick="addBid">
              Add A Bid
            </Button>

            <div v-if="bid" class="addBid">

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

                <Button>Add Bid</Button>
              </form>
            </div>

          </div>
        </div>
      </section>
    </div>
  </div>
</template>

<script>
  import { picasso } from '@vechain/picasso';
  import { find } from 'lodash';
  import { toWei, soliditySha3 } from 'web3-utils'; // UTF-8 is the default for ethereum related strings
  import { AbiCoder } from 'web3-eth-abi'; // UTF-8 is the default for ethereum related strings

  import tx from '@/mixins/tx';
  import getAuctionID from '@/mixins/getAuctionID';

  import AppInput from '@/components/AppInput'
  import Doodle from '@/components/Doodle';
  import Button from '@/components/Button';

  import { Star } from '@/components/Icons';

  export default {
    name: "AvailableDomain",
    props: ['domain'],
    mixins: [tx, getAuctionID],
    components: {
      AppInput,
      Button,
      Doodle,
      Star,
    },
    data() {
      return {
        bid: null,
        error: null,
        secret: null,
        selected: true,
        auctionID: null,
      }
    },
    mounted() {
      const doodle = document.getElementById('doodle');

      this.getAuctionID(this.domain).then(({ decoded }) => {
        this.auctionID = decoded[0];
      });
    },
    methods: {
      submit() {
        this.bidOnAuction();
      },
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
        const clause = startAuction.asClause(this.domain);

        this.tx({ clause, comment, signer: window.signer, });
      },
      bidOnAuction() {
        if (this.secret === null) {
          this.error = true;

          return;
        }

        const bidOnAuctionABI = find(this.$contract.abi, { name: 'bidOnAuction' });
        const bidOnAuction = window.connex.thor.account(this.$address).method(bidOnAuctionABI);

        const comment = 'bid auction';
        const behaviorBond = toWei('5', 'ether');

        const userBid = toWei(this.bid, 'ether');
        const userSecret = soliditySha3(this.secret);
        const blindedBid = soliditySha3(userBid, userSecret);  // Must be bytes32
        
        const clause = bidOnAuction.value(behaviorBond).asClause(this.auctionID, blindedBid);

        this.tx({ clause, comment, signer: window.signer });
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
