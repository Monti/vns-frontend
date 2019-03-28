<template>
  <div class="container">
    <AppHero>
      <template v-slot:title>
        Manage Your Domains
      </template>
      <template v-slot:description>
        Manage your auctions and domains. You can add and remove subdomains here as well as check the status of your domain.
      </template>
      <template v-slot:image>
        <img src="@/assets/manage.jpg" />
      </template>
    </AppHero>

    <section>
      <h3>Auctions</h3>
      <div v-for="item in [1, 2, 3, 4, 5]" :key="item" class="auctions">
        <AppAuction />
      </div>
    </section>

    <section>
      <h3>Domains</h3>
      <div v-for="item in [1, 2, 3, 4, 5]" :key="item" class="domains">
        <AppDomain />
      </div>
    </section>

  </div>
</template>

<script>
  import { picasso } from '@vechain/picasso';
  import { find } from 'lodash';

  import AppAuction from '@/components/AppAuction';
  import AppDomain from '@/components/AppDomain';
  import AppHero from '@/components/AppHero';
  import certify from '@/mixins/certify';

  export default {
    name: "Manage",
    components: {
      AppHero,
      AppDomain,
      AppAuction,
    },
    data() {
      return {
        auctions: [],
      }
    },
    mixins: [certify],
    mounted() {
      const content = 'Confirm that you would like this site to access your account';

      if (window.signer) {
        this.tokensOfOwner();
      } else {
        this.certify(content).then(({ annex: { signer }}) => {
          window.signer = signer;
          this.tokensOfOwner(signer);
        });
      }
    },
    methods: {
      getAuctions() {
        const getUserAuctionsABI = find(this.$contract.abi, { name: 'getUserAuctions' });
        const getUserAuctions = window.connex.thor.account(this.$address).method(getUserAuctionsABI);

        getUserAuctions.call(window.signer).then(({ decoded }) => {
          const auctions = decoded[0].map(id => this.getDomain(id));

          Promise.all(auctions).then(data => {
            console.log(data);
          });
        });
      },
      tokensOfOwner() {
        const tokensOfOwnerABI = find(this.$contract.abi, { name: 'tokensOfOwner' });
        const tokensOfOwner = window.connex.thor.account(this.$address).method(tokensOfOwnerABI);

        tokensOfOwner.call(signer).then(({ decoded }) => {
          console.log(decoded)
        });
      },
      getDomain(id) {
        const getDomainABI = find(this.$contract.abi, { name: 'getDomain' });
        const getDomain = window.connex.thor.account(this.$address).method(getDomainABI);

        return getDomain.call(id);
      }
    }
  }
</script>

<style lang="scss" scoped>
  .auctions {
    background-color: #fafafa;
    margin-bottom: 20px;
    padding: 20px;
  }

  .domains {
    margin-bottom: 20px;
  }

  .owner {
    align-items: center;
    display: flex;
    flex-direction: row;
  }

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
    flex-direction: row;
  }

  h3 {
    font-size: 1.5rem;
  }

  .description {
    line-height: 1.5rem;
    font-size: 0.9rem;
  }

  section {
    margin-bottom: 60px;
  }
</style>
