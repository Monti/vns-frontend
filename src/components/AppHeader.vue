<template>
  <div class="header">

    <div class="background">
      <css-doodle>
        :doodle {
          @grid: 100 / 100%;
          background: #0a0c27;
          font-family: sans-serif;
        }

        :after { content: \@hex(@rand(0x2500, 0x257f));
          color: hsla(@r(360), 70%, 70%, @r(.5));
          font-size: 3vmax;
        };
      </css-doodle>
    </div>

    <div class="container">
      <header>
        <h1>VeChain Name Service</h1>
        <div class="network mainnet" v-if="networkId === 74">
          Mainnet
        </div>
        <div class="network testnet" v-else-if="networkId === 39">
          Testnet
        </div>
        <div class="network" v-else>
          Unknown Network
        </div>
      </header>
    </div>
  </div>

</template>

<script>
import { hexToBytes } from 'web3-utils';

export default {
  name: 'AppHeader',
  data() {
    return {
      networkId: null,
    }
  },
  async mounted() {
    const block = await window.connex.thor.block(0).get();
    this.networkId = hexToBytes(block.id).pop();
  }
}
</script>

<style scoped lang="scss">
  .header {
    color: #ffffff;
    height: 100px;
    text-shadow: 2px 2px 2px rgba(0, 0, 0, 0.8);
    letter-spacing: 1px;
    position: relative;
    overflow: hidden;

    .container {
      height: 100%;
    }
  }

  .background {
    background-color: #0a0c27;
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
