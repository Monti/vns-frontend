<template>
  <div class="container">
    <h2>{{ domain }}</h2>
  </div>
</template>

<script>
  import Registry from '@/build/contracts/Registry.json';
  import { picasso } from '@vechain/picasso';

  export default {
    name: "Manage",
    mounted() {
      const startAuctionABI = _.find(Registry.abi, { name: 'startAuction' });
      const startAuction = window.connex.thor.account(this.$address).method(startAuctionABI);
    }
  }
</script>

<style lang="scss" scoped>
  .owner {
    align-items: center;
    display: flex;
    flex-direction: row;
  }

  .avatar {
    border-radius: 3px;
    display: block;
    height: 20px;
    width: 20px;
    margin-right: 10px;
  }

  .signer {
    align-items: center;
    display: flex;
    flex-direction: row;
  }

  h2 {
    font-size: 2.5rem;
  }
</style>
