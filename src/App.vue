<template>
  <div id="app">
    <AppHeader />
    <router-view></router-view>
  </div>
</template>

<script>
  import AppHeader from '@/components/AppHeader.vue'

  export default {
    name: 'app',
    components: {
      AppHeader,
    }
  }
</script>

<style lang="scss">
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
  }

  .no-doodle-support css-doodle {
    display: none;
  }

  a {
    color: #0a0c27;
    text-decoration: none;
  }
</style>
