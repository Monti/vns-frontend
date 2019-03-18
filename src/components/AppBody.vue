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
  name: "AppBody",
  data() {
    return {
      domain: ''
    }
  },
  methods: {
    submit(e) {
      e.preventDefault();
      console.log(this.domain)
    }
  }
}
</script>

<style lang="scss" scoped>
  form {
    text-align: left;
  }

  .description {
    font-family: 'Roboto Mono';
    margin: 50px 0;;

    p {
      line-height: 1.5rem;
    }

    span {
      border-radius: 2px;
      background-color: #ddd;
      font-size: 90%;
      padding: 0 5px;
    }
  }

  .input {
    position: relative;
  
    &::after {
      align-items: center;
      background-color: #0a0c27;
      border-radius: 0 3px 3px 0;
      color: #fff;
      content: ".vet";
      display: flex;
      height: 100%;
      justify-content: center;
      position: absolute;
      right: 0;
      top: 0;
      width: 100px;
      z-index: -1;
    }
  }

  input {
    background-color: transparent;
    border-radius: 3px;
    border: 2px solid #0a0c27;
    color: #0a0c27;
    font-family: 'Roboto Mono';
    font-size: 1rem;
    padding: 20px 100px 20px 20px;
    width: 100%;
  }
</style>
