<template>
  <div class="header">

    <div class="background">
      <Doodle />
    </div>

    <div class="container">
      <header>
        <h1>
          <router-link to="/">VeChain Name Service</router-link>
        </h1>
        <div v-if="connex">
          <div class="network mainnet" v-if="networkId === 74">
            Mainnet
          </div>
          <div class="network testnet" v-else-if="networkId === 39">
            Testnet
          </div>
        </div>
      </header>
    </div>
  </div>

</template>

<script>
  import { hexToBytes } from 'web3-utils';
  import Doodle from '@/components/Doodle';

  export default {
    name: 'AppHeader',
    components: {
      Doodle
    },
    data() {
      return {
        networkId: null,
        connex: !!window.connex,
      }
    },
    async mounted() {
      const block = await window.connex.thor.block(0).get();
      this.networkId = hexToBytes(block.id).pop();
    }
  }
</script>

<style scoped lang="scss">
  a {
    background-color: #ffffff;
    color: #0a0c27;
    text-decoration: none;
  }

  .header {
    border: 1px solid #AEACFB;
    color: #0a0c27;
    font-family: 'Rubik', sans-serif;
    height: 100px;
    letter-spacing: 1px;
    position: relative;
    overflow: hidden;

    .container {
      height: 100%;
    }
  }

  .background {
    /* background-color: #0a0c27; */
    bottom: 0;
    left: 0;
    position: absolute;
    top: 0;
    right: 0;
  }

  h1 {
    font-size: 1rem;
    text-transform: uppercase;
    margin: 0;
  }
  
  .network {
    background-color: #ffffff;
    align-items: center;
    font-size: 0.8rem;
    text-transform: uppercase;
    margin: 0;

    &::after {
      content: "";
      display: block;
      margin-top: 3px;
      height: 3px;
      width: 100%;
    }

    &.mainnet::after {
      background-color: #02D576;
      outline: 3px solid #ffffff;
    }

    &.testnet::after {
      background-color: #E87D9B;
    }
  }

  header {
    align-items: center;
    display: flex;
    height: 100%;
    justify-content: space-between;
    position: relative;
    z-index: 2;
  }
</style>
