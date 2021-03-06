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
            <Button @onClick="startAuction" :disabled="startAuctionSuccess || auctionAlreadyStarted">
              <div class="loader" v-if="loading">
                <span>
                  Loading
                </span>
                <vue-loading
                  type="spin"
                  color="#000000"
                  :size="{ width: '20px', height: '20px' }"></vue-loading>
              </div>
              <span v-else-if="startAuctionSuccess">Auction Started</span>
              <span v-else-if="auctionAlreadyStarted">Auction Already Started</span>
              <span v-else>Start Auction</span>
            </Button>
            <small>then</small>
            <Button
              @onClick="addBid"
              :disabled="addBidDisabled || bid">
              Add A Bid
            </Button>
          </div>
        </div>
      </section>
    </div>

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

        <label class="info">
          Remember you will be attaching a good behavior bond of 5000 VET. 
        </label>

        <AppInput
          type="number"
          size="medium"
          min="1000"
          v-model="bid"
          placeholder="type your bid (minimum 1000 VET)"
        />

        <Button :disabled="addBidSuccess">
          <div class="loader" v-if="addBidPending">
            <span>
              Loading
            </span>
            <vue-loading
              type="spin"
              color="#000000"
              :size="{ width: '20px', height: '20px' }"></vue-loading>
          </div>
          <div v-else-if="addBidSuccess">Your bid was added!</div>
          <div v-else>Add Bid</div>
        </Button>
        <div class="notice" v-if="showNotice">
          <small>
            To view your auctions go to
            <br />
            <router-link to="manage">Manage Auctions & Domains :)</router-link>
          </small>
        </div>
      </form>
    </div>

  </div>
</template>

<script>
  import { picasso } from '@vechain/picasso';
  import { find } from 'lodash';
  import { toWei, soliditySha3 } from 'web3-utils';

  import tx from '@/mixins/tx';
  import certify from '@/mixins/certify';
  import getAuctionID from '@/mixins/getAuctionID';

  import AppInput from '@/components/AppInput'
  import Button from '@/components/Button';

  const content = 'Confirm that you would like this site to access your account';

  export default {
    name: "AvailableDomain",
    props: ['domain'],
    mixins: [tx, getAuctionID, certify],
    components: {
      AppInput,
      Button,
    },
    data() {
      return {
        bid: null,
        error: null,
        secret: null,
        selected: true,
        loading: false,
        auctionID: null,
        showNotice: false,
        addBidSuccess: false,
        addBidDisabled: true,
        addBidPending: false,
        startAuctionSuccess: false,
        auctionAlreadyStarted: false,
      }
    },
    watch: {
      domain(newDomain, oldDomain) {
        if (newDomain !== oldDomain) {
          this.init();
        }
      }
    },
    methods: {
      submit() {
        this.bidOnAuction();
      },
      init() {
        this.getAuctionID(this.domain).then(({ decoded }) => {
          if (parseInt(decoded[0]) !== 0) {
            this.auctionAlreadyStarted = true;
            this.addBidDisabled = false;
          } else {
            this.auctionAlreadyStarted = false;
            this.addBidDisabled = true;
          }

          this.auctionID = decoded[0];
        });
      },
      avatar() {
        return picasso('0x7567D83b7b8d80ADdCb281A71d54Fc7B3364ffed');
      },
      addBid() {
        this.bid = true;
      },
      async startAuction() {
        if (!window.signer) {
          const signer = await this.certify(content).then(({ annex: { signer }}) => signer);
          window.signer = signer;
        }

        const signingService = window.connex.vendor.sign('tx');
        const startAuctionABI = find(this.$contract.abi, { name: 'startAuction' });
        const startAuction = window.connex.thor.account(this.$address).method(startAuctionABI);

        const comment = `start auction for ${this.domain}.vet`;
        const clause = startAuction.asClause(this.domain);

        signingService
          .signer(window.signer)
          .gas(1800000)
          .link('https://connex.vecha.in/{txid')
          .comment(comment)
          .request([ clause ])
          .then(({ txid }) => {
            this.getReceipt({ txid });
          });
      },
      async bidOnAuction() {
        if (this.secret === null) {
          this.error = true;

          return;
        }

        if (!window.signer) {
          const signer = await this.certify(content).then(({ annex: { signer }}) => signer);
          window.signer = signer;
        }

        const signingService = window.connex.vendor.sign('tx');
        const bidOnAuctionABI = find(this.$contract.abi, { name: 'bidOnAuction' });
        const bidOnAuction = window.connex.thor.account(this.$address).method(bidOnAuctionABI);

        const comment = `bid for ${this.domain}.vet`;
        const behaviorBond = toWei('5000', 'ether');

        const userBid = toWei(this.bid, 'ether');
        const userSecret = soliditySha3(this.secret);
        const blindedBid = soliditySha3(userBid, userSecret);  // Must be bytes32
        
        const clause = bidOnAuction.value(behaviorBond).asClause(this.auctionID, blindedBid);

        signingService
          .signer(window.signer)
          .gas(150000)
          .link('https://connex.vecha.in/{txid')
          .comment(comment)
          .request([ clause ])
          .then(({ txid }) => {
            this.getBidReceipt({ txid });
          });
      },
      getBidReceipt({ txid }) {
        this.addBidPending = true;

        this.bidReceiptPoll = setInterval(async () => {
          try {
            const tx = window.connex.thor.transaction(txid).getReceipt;

            if (tx) {
              if (!tx.reverted) {
                this.addBidPending = false;
                this.addBidSuccess = true;

                setTimeout(() => {
                  this.showNotice = true
                }, 500);
              }

              clearInterval(this.bidReceiptPoll);
            }
          } catch(error) {
            throw new Error(error);
          }

        }, 5000);
      },
      getReceipt({ txid }) {
        const url = new URL(window.location.href);
        this.loading = true;

        this.receiptPoll = setInterval(async () => {
          this.init();

          try {
            const tx = await window.connex.thor.transaction(txid).getReceipt();

            if (tx && tx.reverted) {
              clearInterval(this.receiptPoll);
            }

            if (parseInt(this.auctionID) !== 0) {
              this.loading = false;
              this.addBidDisabled = false;
              this.startAuctionSuccess = true;
              clearInterval(this.receiptPoll);
            }
          } catch(error) {
            throw new Error(error);
          }
        }, 1000);
      }
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
    margin-top: 50px;

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

  .loader {
    display: flex;

    span {
      margin-right: 10px;
    }
  }

  .addBid {
    text-align: right;
    top: 100%;
    width: 100%;
    margin-top: 30px;

    .info {
      margin-bottom: 10px;
      font-size: 80%;
    }

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

  .notice {
    margin-top: 5px;
  }
</style>
