<template>
  <div class="container">
    <div>{{ domain }}.vet</div>
    <div>{{ resolver }}</div>
  </div>
</template>

<script>
  import { find } from 'lodash';

  export default {
    name: 'ManageDomain',
    data() {
      return {
        domain: '',
        resolver: ''
      }
    },
    mounted() {
      this.domain = this.$route.params.domain;
      this.resolveDomain(this.domain);
    },
    methods: {
      resolveDomain(domain) {
        const resolveDomainABI = find(this.$contract.abi, { name: 'resolveDomain' });
        const resolveDomain = window.connex.thor.account(this.$address).method(resolveDomainABI);

        resolveDomain.call(domain).then(({ decoded }) => {
          this.resolver = decoded['0'];
          this.domainAvailable = /^0x0+$/.test(this.resolver);
        });
      }
    }
  }
</script>

<style>

</style>
