<template>
  <div class="container">
    <h2>{{ domain }}</h2>
    <div class="owner">
      owner:
      <div class="signer">
        <div class="avatar" :style="{ background: `no-repeat url('data:image/svg+xml;utf8,${avatar('0x1965B7ed6A6a1c95dB5f02e9a91E8B658E6A1947')}')`}">
        </div>
        <small>0x1965B7ed6A6a1c95dB5f02e9a91E8B658E6A1947</small>
      </div>
    </div>
  </div>
</template>

<script>
  import { picasso } from '@vechain/picasso';

  export default {
    name: "Name",
    data() {
      return {
        domain: this.$route.params.domain
      }
    },
    methods: {
      avatar(address) {
        return picasso(address);
      }
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
