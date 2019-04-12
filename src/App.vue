<template>
  <div class="main-container">
    <AppHeader />
    <router-view></router-view>
    <AppFooter />
  </div>
</template>

<script>
  import AppHeader from '@/components/AppHeader.vue'
  import AppFooter from '@/components/AppFooter.vue'

  export default {
    name: 'app',
    components: {
      AppHeader,
      AppFooter,
    }
  }
</script>

<style lang="scss">
  @import './assets/tooltip.scss';

  * {
    box-sizing: border-box;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
  }

  html,
  body {
    height: 100%;
    font-size: 16px;
  }

  body {
    color: #0a0c27;
    background-color: #FFFFFF;
    font-family: 'Roboto Mono';
    margin: 0;
  }

  h2, h3, h4 {
    font-family: 'Rubik', sans-serif;
  }

  .container {
    max-width: 980px;
    margin: 0 auto;
    margin-bottom: 100px;

    @media (min-width: 320px) and (max-width: 480px) {
      padding: 20px;
      margin-bottom: 0;
    }
  }

  .no-doodle-support css-doodle {
    display: none;
  }

  a {
    color: #0a0c27;
    text-decoration: none;
    transition: all 0.2s linear;

    &:hover {
      color: #ffa56d;
    }
  }

  .main-container {
    min-height: 100vh;
    overflow: hidden;
    display: block;
    position: relative;
    padding-bottom: 500px;

    @media (min-width: 320px) and (max-width: 480px) {
      padding-bottom: 300px;
    }
  }
</style>
