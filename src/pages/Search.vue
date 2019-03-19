<template>
  <div class="container">
    <div class="signer" v-if="signer">
      <div class="avatar" :style="{ background: `no-repeat url('data:image/svg+xml;utf8,${avatar}')`}">
      </div>
      <small>{{ signer }}</small>
    </div>
    <div class="signer" v-else>
      <small>0x0000000000000000000000000000000000000000</small>
    </div>
    <form @submit="submit">
      <div class="input">
        <input type="text" v-model="domain" placeholder="search for your domain" />
      </div>
    </form>
  </div>
</template>

<script>
  import { picasso } from '@vechain/picasso';

  export default {
    name: 'Search',
    data() {
      return {
        signer: '0x0000000000000000000000000000000000000000',
        domain: this.$route.params.domain
      }
    },
    mounted() {
      this.certify();
    },
    methods: {
      certify() {
        const signingService = window.connex.vendor.sign('cert')

        signingService.request({
          purpose: 'identification',
          payload: {
            type: 'text',
            content: 'random generated string'
          }
        }).then(({ annex: { signer }}) =>{
          this.signer = signer;
        });
      },
      submit() {
      }
    },
    computed: {
      avatar() {
        return picasso(this.signer);
      }
    }
  }
</script>

<style lang="scss" scoped>
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
    margin: 10px 0;
    justify-content: flex-end;
  }

  form {
    margin-top: 50px;
  }
</style>
