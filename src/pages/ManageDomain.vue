<template>
  <div class="container">
    <h2>{{ domain[0] }}.vet</h2>

    <div class="address-container">
      <AddressAvatar :signer="resolver" text="Resolver:" />
    </div>

    <div class="info" v-if="domain[0]">
      <div>
        <div class="value">{{ domain[1] | fromWei }} VET</div>
        <div class="label">
          <small>Bond</small>
        </div>
      </div>
      <div>
        <div class="value">{{ domain[2] | fromWei }} VET</div>
        <div class="label">
          <small>Yearly Cost</small>
        </div>
      </div>
      <div>
        <div class="value">{{ domain[4] | moment }}</div>
        <div class="label">
          <small>Expiry Date</small>
        </div>
      </div>
    </div>

   <div class="info" v-if="domain[0]">
      <button
        class="tile"
        @click="enableAutoRenew"
        v-tooltip="{
          content: 'Would you like your domain to auto renew?',
          offset: 10
        }">
        <div class="value" v-if="domain[3]">On</div>
        <div class="value" v-else>Off</div>

        <div class="label">
          <small>Auto Renew</small>
        </div>
      </button>
      <button
        class="tile"
        v-tooltip="{
          content: 'If autoRenew is off and the domain is past its expiry date, popDomain can be called to delete the domain and refund the bond to its owner.',
          offset: 10
        }">
        <div class="value">
          <img src="@/assets/pop.png" />
        </div>
        <div class="label">
          <small>Pop Domain</small>
        </div>
      </button>
      <button
        class="tile"
        v-tooltip="{
          content: 'This function will use the domain\'s bond to top-up the domains\' domainExpires timer.',
          offset: 10
        }">
        <div class="value">
          <img src="@/assets/collect.png" />
        </div>
        <div class="label">
          <small>Collect Dues</small>
        </div>
      </button>
      <button
        class="tile"
        v-tooltip="{
          content: 'Lets the owner of a domain deregister their domain and receive their bond back.',
          offset: 10
        }">
        <div class="value">
          <img src="@/assets/withdraw.png" />
        </div>
        <div class="label">
          <small>Withdraw Early</small>
        </div>
      </button>
      <button
        class="tile"
        v-tooltip="{
          content: 'If a user registers a domain that is too short, anyone can call this to delete their domain.',
          offset: 10
        }">
        <div class="value">
          <img src="@/assets/invalidate.png" />
        </div>
        <div class="label">
          <small>Invalidate Domain</small>
        </div>
      </button>
    </div>

    <form @submit.prevent="setDomain" class="form">
      <div class="form-title">
        <h3>Change Domain</h3>
        <div class="subtitle">
          <small>Change where <span>{{ domain[0] }}.vet</span> points to.</small>
        </div>
      </div>

      <div class="input-group">

        <div v-if="error" class="error">
          <small>Domain has to be a vet address</small>
        </div>

        <AppInput
          v-model="newDomain"
          placeholder="enter vechain address"
        />
      </div>

      <div class="footer">
        <Button class="button">Change Domain</Button>
      </div>
    </form>


    <form @submit.prevent="addSubdomain" class="form">
      <div class="form-title">
        <h3>Add Subdomain</h3>
        <div class="subtitle">
          <small>Add sub domain to your domain. For example <span>awesomesubdomain.{{ domain[0] }}.vet</span></small>
        </div>
      </div>

      <div class="">

        <div class="input-group">
          <AppInput
            :label="'.' + domain[0] + '.vet'"
            v-model="subdomain"
            placeholder="enter subdomain"
          />
        </div>

        <div class="input-group">
          <AppInput
            v-model="targetAddress"
            placeholder="enter target address"
          />
        </div>

      </div>

      <div class="footer">
        <Button class="button">Add Subdomain</Button>
      </div>
    </form>

    <form @submit.prevent="removeSubdomain" class="form">
      <div class="form-title">
        <h3>Remove Subdomain</h3>
      </div>

      <div class="">

        <div class="input-group">
          <AppInput
            :label="'.' + domain[0] + '.vet'"
            v-model="removedDomain"
            placeholder="enter subdomain"
          />
        </div>

      </div>

      <div class="footer">
        <Button class="button">Remove Subdomain</Button>
      </div>
    </form>


  </div>
</template>

<script>
  import { find } from 'lodash';
  import { fromWei, isAddress } from 'web3-utils';
  import moment from 'moment';

  import AddressAvatar from '@/components/AddressAvatar';
  import Button from '@/components/Button';
  import AppInput from '@/components/AppInput';

  import tx from '@/mixins/tx';

  export default {
    name: 'ManageDomain',
    mixins: [tx],
    components: {
      Button,
      AppInput,
      AddressAvatar,
    },
    data() {
      return {
        id: null,
        domain: {},
        error: null,
        resolver: '',
        newDomain: '',
        subdomain: '',
        removedDomain: '',
        targetAddress: '',
      }
    },
    created() {
      this.id = this.$route.params.id;
    },
    mounted() {
      this.$nextTick(() => {
        this.getDomain();
      });
    },
    methods: {
      enableAutoRenew() {
        const signingService = window.connex.vendor.sign('tx');
        const enableAutoRewnewABI = find(this.$contract.abi, { name: 'enableAutoRewnew' });
        const enableAutoRewnew = window.connex.thor.account(this.$address).method(enableAutoRewnewABI);

        const comment = 'Enable Auto Renew';
        const clause = enableAutoRewnew.asClause(this.id);

        signingService
          .link('https://connex.vecha.in/{txid')
          .comment(comment)
          .request([ clause ]);
      },
      getDomain() {
        const getDomainABI = find(this.$contract.abi, { name: 'getDomain' });
        const getDomain = window.connex.thor.account(this.$address).method(getDomainABI);

        getDomain.call(this.id).then(({ decoded }) => {
          this.domain = decoded;
          return decoded;
        }).then(data => {
          this.resolveDomain(data[0]);
        });
      },
      setDomain() {
        if (!isAddress(this.newDomain)) {
          this.error = true;
          return;
        }

        const signingService = window.connex.vendor.sign('tx');

        const setDomainABI = find(this.$contract.abi, { name: 'setDomain' });
        const setDomain = window.connex.thor.account(this.$address).method(setDomainABI);

        const comment = 'change domain';
        const clause = setDomain.asClause(this.id, this.newDomain);

        signingService
          .link('https://connex.vecha.in/{txid')
          .comment(comment)
          .request([ clause ]);
      },
      addSubdomain() {
        const signingService = window.connex.vendor.sign('tx');
        const addSubdomainABI = find(this.$contract.abi, { name: 'addSubdomain' });
        const addSubdomain = window.connex.thor.account(this.$address).method(addSubdomainABI);

        const comment = 'add subdomain';
        const clause = addSubdomain.asClause(this.id, this.subdomain, this.targetAddress);

        signingService
          .link('https://connex.vecha.in/{txid')
          .comment(comment)
          .request([ clause ]);
      },
      removeSubdomain() {

      },
      popDomain() {

      },
      collectDues() {

      },
      withdrawEarly() {
      },
      resolveDomain() {
        const resolveDomainABI = find(this.$contract.abi, { name: 'resolveDomain' });
        const resolveDomain = window.connex.thor.account(this.$address).method(resolveDomainABI);

        resolveDomain.call(this.domain[0]).then(({ decoded }) => {
          return this.resolver = decoded['0'];
        });
      },
    },
    filters: {
      fromWei(value) {
        return fromWei(value, 'ether');
      },
      moment(value) {
        const date = value * 1000;
        return moment(date).format('MMM DD YYYY')
      }
    }
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

  .error {
    margin-bottom: 10px;
    text-align: left;

    small {
      color: #E87D9B;
      margin: 0;
    }
  }

  .info {
    align-items: center;
    margin-top: 12px;
    display: flex;

    > div,
    .tile {
      background-color: #fafafa;
      border-radius: 3px;
      flex: 1;
      margin: 0 6px;
      text-align: center;
      padding: 32px 0;
    }

    .tile {
      border: 1px dashed #FFAA6E;
      cursor: pointer;
      font-size: initial;

      &:hover {
        background-color: #FFAA6E;
        color: #ffffff;
      }
    }
  }

  .value {
    font-family: 'Rubik', sans-serif;
    font-size: 1.2rem;
    margin-bottom: 10px;

    img {
      width: 25px;
    }
  }

  .address-container {
    margin-bottom: 50px;
  }

</style>
