<template>
  <div class="container">

    <AppHero>
      <template v-slot:title>
        Human Readable Addresses
      </template>
      <template v-slot:description>
        The VeChain Name Service is a distributed, open and extensible naming system based on the VeChain blockchain.
        VNS eliminates the need to copy or type long addresses. With VNS, you'll be able to send money to your friend at <span>raleighca.vet</span> instead of <span>0x4cbe58c50480...</span> or interact with your favorite contract at <span>mycontract.vet</span>.
        For more information visit our <a href="https://vechain-dns.gitbook.io/vns-docs/" target="_blank">Documentation</a> or visit our <router-link to="help">Help page</router-link>.
      </template>
      <template v-slot:extra>
        <div class="actions">
          <router-link to="manage">
            <Button size="medium">
              Manage Domains
            </Button>
          </router-link>
          <router-link to="send">
            <Button size="medium">
              Send using VNS
            </Button>
          </router-link>
        </div>
      </template>
      <template v-slot:image>
        <img src="@/assets/creation.jpg" />
      </template>
    </AppHero>

    <div class="main">

      <form @submit.prevent="submit" ref="form">
        <label v-if="errors && !isX" class="error">
          <small>If not an X Node Holder your domain has to be more then {{ domainLength }} characters</small>
        </label>

        <label v-if="isX">
          <small>You now have access for shorter domains!</small>
        </label>

        <AppInput
          :isX="isX"
          type="text"
          label=".vet"
          v-model="domain"
          labelStyle="transparent"
          placeholder="search for a domain"
        />
      </form>

      <span>or</span>

      <div class="unlock-rewards">
        <Button size="small" @onClick="unlock">Unlock X Node Rewards</Button>
      </div>

    </div>

    <AddressAvatar :signer="signer" :isX="isX" />

    <div v-if="domainAvailable === true && submittedDomain.length > 0">
      <AvailableDomain :domain="submittedDomain" />
    </div>

    <div v-else-if="domainAvailable === false">
      <UnavailableDomain :domain="submittedDomain" :resolver="resolver" />

      <h3>Here are some examples of other domains</h3>

      <DomainResults :domain="submittedDomain" @clicked="getDomain"
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
  import AddressAvatar from '@/components/AddressAvatar';
  import DomainResults from '@/components/DomainResults';
  import AvailableDomain from '@/components/AvailableDomain';
  import UnavailableDomain from '@/components/UnavailableDomain';

  export default {
    name: "Home",
    components: {
      Button,
      AppHero,
      AppInput,
      AddressAvatar,
      DomainResults,
      AvailableDomain,
      UnavailableDomain,
    },
    mixins: [certify],
    data() {
      return {
        isX: false,
        domain: '',
        signer: null, 
        resolver: '',
        errors: false,
        domainLength: 7,
        submittedDomain: '',
        domainAvailable: null,
      }
    },
    mounted() {
      const urlParams = new URLSearchParams(window.location.search);
      const domain = urlParams.get('domain');

      if (domain) {
        this.domain = domain;
        this.init();
      }
    },
    methods: {
      init() {
        this.$nextTick(() => {
          this.submit();
        });
      },
      unlock() {
        const content = 'Confirm that you would like this site to access your account';

        if (window.signer) {
          this.signer = window.signer;
          this.getX(window.signer);
        } else {
          this.certify(content).then(({ annex: { signer }}) => {
            this.getX(signer);
            this.signer = signer;
            window.signer = signer;
          });
        }
      },
      getX(signer) {
        const isXABI = find(this.$contract.abi, { name: 'isX' });
        const isX = window.connex.thor.account(this.$address).method(isXABI);

        isX.caller(signer).call().then(({ decoded }) => {
          this.isX = decoded[0];
          this.domainLength = decoded[0] ? 4 : 7;
        });
      },
      getDomain(domain) {
        const form = this.$refs.form;
        this.domain = domain;

        VueScrollTo.scrollTo(form, 500, { offset: -20 });
      },
      submit() {
        if (this.domain.length < this.domainLength) {
          this.errors = true;
          return;
        } else {
          this.errors = false;
        }

        this.resolveDomain();
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
  .actions {
    display: flex;
    margin-top: 30px;

    button {
      margin-right: 30px;
    }

    @media (min-width: 320px) and (max-width: 480px) {
      flex-direction: column;

      a, button {
        width: 100%;
      }

      button {
        margin-right: 0;
        margin-bottom: 30px;
      }
    }
  }

  form {
    text-align: left;
    position: relative;

    label {
      display: block;
      left: 0;
      margin-bottom: 5px;
      position: absolute;
      top: -25px;
    }

  }

  .error {
    color: #FF5A70;
  }

  .tip {
    width: 50%;
    font-style: italic;
    margin-top: 40px;
  }

  .title {
    margin-bottom: 20px;

    h3 {
      margin: 0;
      text-align: left;
    }
  }

  .subtitle {
    margin-top: 10px;
  }

  .unlock-rewards {
    display: flex;

    @media (min-width: 320px) and (max-width: 480px) {
      width: 100%;

      button {
        font-size: 0.9rem;
        width: 100%;
        padding: 10px 20px;
      }
    }
  }

  .main {
    display: flex;
    margin-top: 50px;

    form {
      flex: 1;
    }

    span {
      align-items: center;
      display: flex;
      margin: 0 20px;;
    }

    @media (min-width: 320px) and (max-width: 480px) {
      align-items: center;
      flex-direction: column;

      span {
        display: block;
        margin: 20px 0;
        width: 100%;
        text-align: center;
      }
    }
  }

</style>
