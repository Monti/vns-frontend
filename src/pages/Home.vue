<template>
  <div>
    <div class="hero">
      <div class="description">
        <h2>Human Readable Addresses</h2>
        <p>
          The VeChain Name Service is a distributed, open and extensible naming system based on the VeChain blockchain.
          VNS eliminates the need to copy or type long addresses. With VNS, you'll be able to send money to your friend at <span>raleighca.vet</span> instead of <span>0x4cbe58c50480...</span> or interact with your favorite contract at <span>mycontract.vet</span>.
        </p>
      </div>
      <div class="image">
        <img src="@/assets/creation.jpg" />
      </div>
    </div>
    <div class="container">
      <form @submit="submit">
        <div class="input">
          <input type="text" v-model="domain" placeholder="search for your domain" />
        </div>
      </form>

      <DomainCard :domain="domain" />
    </div>
  </div>
</template>

<script>
  import DomainCard from '@/components/DomainCard';

  export default {
    name: "Home",
    components: {
      DomainCard
    },
    data() {
      return {
        domain: ''
      }
    },
    methods: {
      submit(e) {
        e.preventDefault();
        const doodle = document.getElementById('doodle');
      }
    }
  }
</script>

<style lang="scss" scoped>
  .hero {
    align-items: center;
    display: flex;
    max-width: 980px;
    margin: 50px auto;
  }

  form {
    text-align: left;
    margin: 50px 0;;
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
