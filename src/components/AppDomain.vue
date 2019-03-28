<template>
  <div class="wrapper">
    <router-link
      :to="{
        name: 'manageDomain',
        params: {
          domain: domain[0]
        }
      }"
    >
      {{ domain[0] }}.vet
    </router-link>

  </div>
</template>

<script>
  import { find } from 'lodash';

  export default {
    name: 'AppDomain',
    props: ['domain'],
    data() {
      return {
        owner: '0x1717171717171728282828291919182828',
        veforge: 'https://explore.veforge.com/accounts/',
        resolver: '',
      }
    },
    mounted() {
      const getDomainABI = find(this.$contract.abi, { name: 'getDomain' });
      const getDomain = window.connex.thor.account(this.$address).method(getDomainABI);

    },
    resolveDomain() {
      const resolveDomainABI = find(this.$contract.abi, { name: 'resolveDomain' });
      const resolveDomain = window.connex.thor.account(this.$address).method(resolveDomainABI);

      resolveDomain.call(this.domain).then(({ decoded }) => {
        this.resolver = decoded['0'];
        this.domainAvailable = /^0x0+$/.test(this.resolver);
      });
    }
  }
</script>

<style lang="scss" scoped>
  .wrapper {
    background-color: #fafafa;
    padding: 20px;
  }

  .domain {
    display: flex;
  }
</style>
