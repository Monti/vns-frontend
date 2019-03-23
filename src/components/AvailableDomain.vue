<template>
  <div>
    <div class="card">
      <div class="title">
        <h3>{{ domain }}.vet</h3>
        <div>is available</div>
      </div>

      <div class="info">
        <div class="price">
          2000 VET
          <div>
            <small>+ gas fee</small>
          </div>
        </div>
        <Button @onClick="startAuction">Buy</Button>
        <Button @onClick="finalizeAuction">End</Button>
        <Button @onClick="bidOnAuction">Bid</Button>
      </div>
    </div>
  </div>
</template>

<script>
  import { picasso } from '@vechain/picasso';
  import { find } from 'lodash';
  import { toWei } from 'web3-utils';

  import tx from '@/mixins/tx';

  import Doodle from '@/components/Doodle';
  import Button from '@/components/Button';

  import Registry from '@/build/contracts/Registry.json';
  import { Star } from '@/components/Icons';

  export default {
    name: "AvailableDomain",
    props: ['domain', 'signer'],
    mixins: [tx],
    components: {
      Button,
      Doodle,
      Star,
    },
    data() {
      return {
        selected: true,
      }
    },
    mounted() {
      const doodle = document.getElementById('doodle');

    },
    methods: {
      avatar() {
        return picasso('0x7567D83b7b8d80ADdCb281A71d54Fc7B3364ffed');
      },
      startAuction() {
        const startAuctionABI = _.find(Registry.abi, { name: 'startAuction' });
        const startAuction = window.connex.thor.account(this.$address).method(startAuctionABI);

        const comment = 'start auction';
        const clause = startAuction.value(toWei('1', 'ether')).asClause(this.domain);

        this.tx({
          clause,
          comment,
          signer: this.signer,
        });
      },
      finalizeAuction() {
        const finalizeAuctionABI = _.find(Registry.abi, { name: 'finalizeAuction' });
        const finalizeAuction = window.connex.thor.account(this.$address).method(finalizeAuctionABI);

        const comment = 'end auction';
        const clause = finalizeAuction.asClause(1)

        this.tx({
          clause,
          comment,
          signer: this.signer,
        });
      },
      bidOnAuction() {
        const bidOnAuctionABI = _.find(Registry.abi, { name: 'bidOnAuction' });
        const bidOnAuction = window.connex.thor.account(this.$address).method(bidOnAuctionABI);

        const comment = 'bid auction';
        const clause = bidOnAuction.value(toWei('10', 'ether')).asClause(1);

        this.tx({
          clause,
          comment,
          signer: this.signer,
        });
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
</style>
