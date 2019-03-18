<template>
  <header>
    <div class="container">
      <h1>VeChain Name Service</h1>
    </div>
  </header>
</template>

<script>
export default {
  name: 'AppHeader',
  props: {
    msg: String
  }
}
</script>

<style scoped lang="scss">
  header {
    background-color: #0208A8;
    color: #ffffff;
    text-transform: uppercase;
    text-align: center;
    padding: 30px 0;
  }

  h1 {
    font-size: 0.9rem;
    margin: 0;
  }
</style>
