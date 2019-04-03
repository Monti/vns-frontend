<template>
  <div class="container">

    <AppHero>
      <template v-slot:title>
        Send Your VIP-180 Tokens to a VNS Address
      </template>
      <template v-slot:description>
        Manage your auctions and domains. You can add and remove subdomains here as well as check the status of your domain.
      </template>
      <template v-slot:image>
        <img src="@/assets/manage.jpg" />
      </template>
    </AppHero>


    <form @submit.prevent="submit" ref="form" class="send-form">

      <div class="input-group">
        <AppInput
          v-model="domain"
          label=".vet"
          placeholder="enter vns address"
        />
      </div>

      <div class="input-group">
        <AppInput
          type="number"
          v-model="amount"
          placeholder="enter amount to send"
        />
      </div>

      <div class="input-group">
        <Button class="button">Send</Button>
      </div>
    </form>

  </div>
</template>

<script>
import { find } from 'lodash';
import AppInput from '@/components/AppInput'
import AppHero from '@/components/AppHero'
import Button from '@/components/Button'

export default {
  name: 'Send',
  components: {
    AppInput,
    AppHero,
    Button,
  },
  data() {
    return {
      domain: '',
      amount: null,
      resolver: '',
    }
  },
  methods: {
    submit() {
      const signingService = window.connex.vendor.sign('tx');
      const resolveDomainABI = find(this.$contract.abi, { name: 'resolveDomain' });
      const resolveDomain = window.connex.thor.account(this.$address).method(resolveDomainABI);

      resolveDomain.call(this.domain).then(({ decoded }) => {
        this.resolver = decoded['0'];
        const domainAvailable = /^0x0+$/.test(this.resolver);

        if (domainAvailable) {
          signingService
            .link('https://connex.vecha.in/{txid}')
            .comment('Send VET to address using VeChain Name Service')
            .request([
              {
                to: this.resolver,
                value: this.amount,
              }
            ]).then(result => {
              console.log(result);
            });
        }
      });
    }
  }
}
</script>

<style scoped lang="scss">
  .send-form {
    display: flex;
    flex-direction: column;
    text-align: right;
    margin: auto 20%;

    .input {
      width: 100%;
    }

    @media (min-width: 320px) and (max-width: 480px) {
      margin: auto 0;
    }
  }

  .input-group {
    margin-top: 20px;
  }
</style>
