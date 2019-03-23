<template>
  <div class="container">

    <div class="hero">
      <div class="description">
        <h2>Human Readable Addresses</h2>
        <p>
          The VeChain Name Service is a distributed, open and extensible naming system based on the VeChain blockchain.
          VNS eliminates the need to copy or type long addresses. With VNS, you'll be able to send money to your friend at <span>raleighca.vet</span> instead of <span>0x4cbe58c50480...</span> or interact with your favorite contract at <span>mycontract.vet</span>.
        </p>

        <div class="manage">
          <router-link to="manage">
            <Button size="medium">Manage Domains</Button>
          </router-link>
        </div>

      </div>
      <div class="image">
        <img src="@/assets/creation.jpg" />
      </div>
    </div>

    <form @submit.prevent="submit" ref="form">
      <label v-if="errors">
        <small>Domain has to be more then 7 characters</small>
      </label>
      <div class="input">
        <input type="text" v-model="domain" placeholder="search for your domain (press enter)" />
      </div>
    </form>

    <div v-if="domainAvailable === true && submittedDomain.length > 0">
      <AvailableDomain :domain="submittedDomain" :signer="signer" />
    </div>

    <div v-else-if="domainAvailable === false">
      <Results :submittedDomain="submittedDomain" />
    </div>

  </div>
</template>

<script>
  import certify from '@/mixins/certify';
  import VueScrollTo from 'vue-scrollto';
  import { find } from 'lodash';

  import AvailableDomain from '@/components/AvailableDomain';
  import Results from '@/components/Results';
  import Button from '@/components/Button';
  import Registry from '@/build/contracts/Registry.json';

  // console.log(Registry.bytecode);
  
  export default {
    name: "Home",
    components: {
      AvailableDomain,
      Results,
      Button,
    },
    mixins: [certify],
    data() {
      return {
        domain: '',
        signer: null,
        errors: false,
        domainAvailable: null,
        submittedDomain: '',
      }
    },
    methods: {
      submit() {
        if (this.domain.length < 7) {
          this.errors = true;
          return;
        } else {
          this.errors = false;
        }

        const content = 'Confirm that you would like this site to access your account';

        if (this.signer) {
          this.resolveDomain();
        } else {
          this.certify(content).then(({ annex: { signer }}) => {
            this.signer = signer;
            this.resolveDomain();
          });
        }

      },
      resolveDomain() {
        const resolveDomainABI = _.find(Registry.abi, { name: 'resolveDomain' });
        const resolveDomain = window.connex.thor.account(this.$address).method(resolveDomainABI);
        const form = this.$refs.form;

        resolveDomain.call(this.domain).then(({ decoded }) => {
          this.domainAvailable = /^0x0+$/.test(decoded['0']);
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

  .hero {
    align-items: center;
    display: flex;
    margin: 50px auto;
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

  .image {
    flex: 4;
    margin: 0 auto;

    img {
      width: 100%;
    }
  }

  .description {
    flex: 3;
    position: relative;
    z-index: 1;

    p, a {
      line-height: 1.5rem;
      font-size: 0.9rem;
    }

    span {
      border-radius: 2px;
      background-color: #ddd;
      font-size: 90%;
      padding: 0 5px;
    }
  }
</style>
