<template>
  <div class="container">

    <AppHero>
      <template v-slot:title>
        Human Readable Addresses
      </template>
      <template v-slot:description>
        The VeChain Name Service is a distributed, open and extensible naming system based on the VeChain blockchain.
        VNS eliminates the need to copy or type long addresses. With VNS, you'll be able to send money to your friend at <span>raleighca.vet</span> instead of <span>0x4cbe58c50480...</span> or interact with your favorite contract at <span>mycontract.vet</span>.
      </template>
      <template v-slot:extra>
        <div class="manage">
          <router-link to="manage">
            <Button
              size="medium"
              type="special"
            >
              Manage Domains
            </Button>
          </router-link>
        </div>
      </template>
      <template v-slot:image>
        <img src="@/assets/creation.jpg" />
      </template>
    </AppHero>

    <form @submit.prevent="submit" ref="form">
      <label v-if="errors">
        <small>Domain has to be more then 7 characters</small>
      </label>

      <AppInput
        v-model="domain"
        label=".vet"
        placeholder="search for your domain (press enter)"
      />

    </form>

    <div v-if="domainAvailable === true && submittedDomain.length > 0">
      <AvailableDomain :domain="submittedDomain" />
    </div>

    <div v-else-if="domainAvailable === false">
      <UnavailableDomain
        :domain="submittedDomain"
        :resolver="resolver"
      />

      <h3>Here are some examples of other domains</h3>

      <DomainResults
        :domain="submittedDomain"
        @clicked="getDomain"
      />

    </div>

  </div>
</template>

<script>
  import certify from '@/mixins/certify';
  import VueScrollTo from 'vue-scrollto';
  import { find } from 'lodash';

  import Button from '@/components/Button';
  import AppHero from '@/components/AppHero';
  import AppInput from '@/components/AppInput'
  import DomainResults from '@/components/DomainResults';
  import AvailableDomain from '@/components/AvailableDomain';
  import UnavailableDomain from '@/components/UnavailableDomain';

  export default {
    name: "Home",
    components: {
      Button,
      AppHero,
      AppInput,
      DomainResults,
      AvailableDomain,
      UnavailableDomain,
    },
    mixins: [certify],
    data() {
      return {
        domain: '',
        resolver: '',
        errors: false,
        domainAvailable: null,
        submittedDomain: '',
      }
    },
    methods: {
      getDomain(domain) {
        const form = this.$refs.form;
        this.domain = domain;

        VueScrollTo.scrollTo(form, 500, { offset: -20 });
      },
      submit() {
        if (this.domain.length < 7) {
          this.errors = true;
          return;
        } else {
          this.errors = false;
        }

        const content = 'Confirm that you would like this site to access your account';

        if (window.signer) {
          this.resolveDomain();
        } else {
          this.certify(content).then(({ annex: { signer }}) => {
            window.signer = signer;
            this.resolveDomain();
          });
        }

      },
      resolveDomain() {
        const resolveDomainABI = find(this.$contract.abi, { name: 'resolveDomain' });
        const resolveDomain = window.connex.thor.account(this.$address).method(resolveDomainABI);
        const form = this.$refs.form;

        resolveDomain.call(this.domain).then(({ decoded }) => {
          this.resolver = decoded['0'];
          this.domainAvailable = /^0x0+$/.test(this.resolver);
          this.submittedDomain = this.domain;
          VueScrollTo.scrollTo(form, 500, { offset: -20 });
        });
      }
    }
  }
</script>

<style lang="scss" scoped>
  .manage {
    margin-top: 30px;
  }

  form {
    text-align: left;
    margin: 50px 0;
    position: relative;

    label {
      color: #FF5A70;
      display: block;
      left: 0;
      margin-bottom: 5px;
      position: absolute;
      top: -25px;
    }
  }
</style>
