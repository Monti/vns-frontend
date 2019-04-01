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
      <h3>Current Auctions</h3>
      <div class="auctions" :key="auction[3]" v-for="auction in auctionsWithValue">
        <AppAuction :auction="auction" />
      </div>
      <div v-if="auctions.length === 0">
        <div class="empty">
          You are not participating in any auctions!
        </div>
      </div>
    </section>

    <section>
      <h3>Your Domains</h3>
      <div class="domains" :key="domain[0]" v-for="domain in domains">
        <AppDomain :domain="domain" />
      </div>
      <div v-if="domains.length === 0">
        <div class="empty">
          You have no domains!
        </div>
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
        domains: [],
        auctions: [],
      }
    },
    mixins: [certify],
    mounted() {
      const content = 'Confirm that you would like this site to access your account';

      if (window.signer) {
        this.tokensOfOwner();
        this.getUserAuctions();
      } else {
        this.certify(content).then(({ annex: { signer }}) => {
          window.signer = signer;
          this.tokensOfOwner();
          this.getUserAuctions();
        });
      }
    },
    methods: {
      getUserAuctions() {
        const getUserAuctionsABI = find(this.$contract.abi, { name: 'getUserAuctions' });
        const getUserAuctions = window.connex.thor.account(this.$address).method(getUserAuctionsABI);

        getUserAuctions.call('0x0d0c5ffcf111b101b051d34636822b27eab7c115').then(({ decoded }) => {
          const auctions = decoded[0].map(id => this.getAuction(id));

          Promise.all(auctions).then(data => {
            this.auctions = data;
          });
        });
      },
      getAuction(id) {
        const getAuctionABI = find(this.$contract.abi, { name: 'getAuction' });
        const getAuction = window.connex.thor.account(this.$address).method(getAuctionABI);

        return getAuction.call(id).then(({ decoded }) => {
          return {
            id,
            ...decoded,
          }
        });
      },
      tokensOfOwner() {
        const tokensOfOwnerABI = find(this.$contract.abi, { name: 'tokensOfOwner' });
        const tokensOfOwner = window.connex.thor.account(this.$address).method(tokensOfOwnerABI);

        tokensOfOwner.call('0x0d0c5ffcf111b101b051d34636822b27eab7c115').then(({ decoded }) => {
          const tokens = decoded[0].map(id => this.getDomain(id));

          Promise.all(tokens).then(data => {
            this.domains = data;
          });
        });
      },
      getDomain(id) {
        const getDomainABI = find(this.$contract.abi, { name: 'getDomain' });
        const getDomain = window.connex.thor.account(this.$address).method(getDomainABI);

        return getDomain.call(id).then(({ decoded }) => {
          return {
            id,
            ...decoded,
          }
        });

        return getDomain.call(id);
      }
    },
    computed: {
      auctionsWithValue() {
        return this.auctions.filter(auction => auction[3])
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
