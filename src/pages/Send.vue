<template>
  <div class="container">

    <AppHero>
      <template v-slot:title>
        Send Your VIP-180 Tokens to a VNS Address
      </template>
      <template v-slot:description>
        With the help of our JavaScript plugin <a href="https://github.com/Monti/vns-js" target="_blank">VNS-Js</a> you can send VET to any VNS registered domain.
      </template>
      <template v-slot:image>
        <img src="@/assets/send.jpg" />
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
import { toWei } from 'web3-utils';
import VNS from 'vns-js';

import AppInput from '@/components/AppInput'
import AppHero from '@/components/AppHero'
import Button from '@/components/Button'

const vns = new VNS(window.connex);

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
    }
  },
  methods: {
    submit() {
      const signingService = window.connex.vendor.sign('tx');

      vns.lookup(this.domain).then(address => {
        const domainAvailable = !/^0x0+$/.test(address);

        if (domainAvailable) {
          signingService
            .link('https://connex.vecha.in/{txid}')
            .comment('Send VET to address using VeChain Name Service')
            .request([
              {
                to: address,
                value: toWei(this.amount, 'ether'),
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
