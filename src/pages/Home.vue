<template>
  <div class="container">
    <div class="description">
      <h2>What is it?</h2>
      <p>
        The VeChain Name Service is a distributed, open and extensible naming system based on the VeChain blockchain. VNS eliminates the need to copy or type long addresses. With VNS, you'll be able to send money to your friend at <span>raleighca.vet</span> instead of <span>0x4cbe58c50480...</span> or interact with your favorite contract at <span>mycontract.vet</span>.
      </p>
    </div>
    <form @submit="submit">
      <div class="input">
        <input type="text" v-model="domain" placeholder="search for your domain" />
      </div>
    </form>
  </div>
</template>

<script>
export default {
  name: "Home",
  data() {
    return {
      domain: ''
    }
  },
  methods: {
    submit(e) {
      e.preventDefault();
      this.$router.push({ name: 'search', params: { domain: this.domain }});
    }
  }
}
</script>

<style lang="scss" scoped>
  a {
    display: block;
    text-align: right;
  }
  .hero {
    display: flex;
    max-width: 980px;
    margin: 0 auto;
  }

  form {
    text-align: left;
    margin: 50px 0;;
  }

  .image {
    width: 500px;
    margin: 0 auto;

    img {
      width: 100%;
    }
  }

  .description {
    flex: 4;
    font-family: 'Roboto Mono';

    p {
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
