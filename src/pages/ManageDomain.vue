<template>
  <div class="container">
    <h2>{{ domain[0] }}.vet</h2>
    <AddressAvatar :signer="resolver" text="Resolver:" />

    <form @submit.prevent="addSubdomain" ref="form" class="form">
      <div class="form-title">
        <h3>Change Domain</h3>
        <div class="subtitle">
          <small>Change where <span>{{ domain[0] }}.vet</span> points to.</small>
        </div>
      </div>

      <div class="input-group">
        <AppInput
          v-model="subdomain"
          placeholder="enter vechain address"
        />
      </div>

      <div class="footer">
        <Button class="button">Change Domain</Button>
      </div>
    </form>


    <form @submit.prevent="addSubdomain" ref="form" class="form">
      <div class="form-title">
        <h3>Add Subdomain</h3>
        <div class="subtitle">
          <small>Add sub domain to your domain. For example <span>awesomesubdomain.{{ domain[0] }}.vet</span></small>
        </div>
      </div>

      <div class="input-group">
        <AppInput
          v-model="subdomain"
          placeholder="enter subdomain"
        />
      </div>

      <div class="footer">
        <Button class="button">Add Subdomain</Button>
      </div>
    </form>

  </div>
</template>

<script>
  import { find } from 'lodash';
  import AddressAvatar from '@/components/AddressAvatar';
  import Button from '@/components/Button';
  import AppInput from '@/components/AppInput';

  export default {
    name: 'ManageDomain',
    components: {
      Button,
      AppInput,
      AddressAvatar,
    },
    data() {
      return {
        domain: '',
        resolver: '',
        subdomain: '',
      }
    },
    mounted() {
      const { id } = this.$route.params;

      this.getDomain(id);
      this.id = id;
    },
    methods: {
      getDomain(id) {
        const getDomainABI = find(this.$contract.abi, { name: 'getDomain' });
        const getDomain = window.connex.thor.account(this.$address).method(getDomainABI);

        getDomain.call(id)
        .then(({ decoded }) => {
          this.domain = decoded;
          return decoded;
        }).then(data => {
          this.resolveDomain(data[0]);
        });
      },
      setDomain() {

      },
      addSubdomain() {

      },
      removeSubdomain() {

      },
      popDomain() {

      },
      collectDues() {

      },
      withdrawEarly() {
      },
      enableAutoRewnew() {

      },
      resolveDomain() {
        const resolveDomainABI = find(this.$contract.abi, { name: 'resolveDomain' });
        const resolveDomain = window.connex.thor.account(this.$address).method(resolveDomainABI);

        resolveDomain.call(this.domain[0]).then(({ decoded }) => {
          return this.resolver = decoded['0'];
        });
      },
      addSubdomain() {

      }
    },
  }
</script>

<style scoped lang="scss">
  h2 {
    font-size: 3rem;
  }

  .form {
    display: flex;
    flex-direction: column;
    margin-top: 80px;

    .input {
      width: 100%;
    }

    @media (min-width: 320px) and (max-width: 480px) {
      margin: auto 0;
    }
  }

  .form-title {
    margin-bottom: 20px;

    h3 {
      margin: 0;
      text-align: left;
    }

  }

  .subtitle {
    margin-top: 10px;

    span {
      border-bottom: 3px solid #FFAA6E;
    }
  }

  .input-group {
    margin-top: 20px;
  }

  .footer {
    margin-top: 20px;
    text-align: right;
  }
</style>
