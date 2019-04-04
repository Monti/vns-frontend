<template>
  <footer>
    <div class="background">
      <Doodle />
    </div>
    <div class="container">
      <div class="links">
        <a href="https://github.com/Monti/vns-js" target="_blank">
          Add VNS support to your dApp.
        </a>
        <a href="https://github.com/Monti/vns-frontend" target="_blank">
          Contribute to the VNS project
        </a>
        <a href="https://t.me/vechain_name_service" target="_blank">
          Telegram
        </a>
      </div>
    </div>
  </footer>
</template>

<script>
  import Doodle from '@/components/Doodle';

  export default {
    name: 'AppFooter',
    components: {
      Doodle
    }
  }
</script>

<style scoped lang="scss">
  footer {
    border: 1px solid #AEACFB;
    bottom: 0;
    height: 200px;
    padding: 50px 0;
    position: absolute;
    overflow: hidden;
    width: 100%;
  }

  .background {
    bottom: 0;
    left: 0;
    position: absolute;
    top: 0;
    right: 0;
  }

  .container {
    position: relative;
    z-index: 1;
  }

  .links {
    display: inline-flex;
    flex-direction: column;
    font-size: 80%;

    a {
      background-color: #ffffff;
      margin-bottom: 20px;
    }
  }
</style>
