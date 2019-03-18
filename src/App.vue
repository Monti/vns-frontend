<template>
  <div id="app">
    <AppHeader />
    <AppBody />
  </div>
</template>

<script>
import AppHeader from './components/AppHeader.vue'
import AppBody from './components/AppBody.vue'

export default {
  name: 'app',
  components: {
    AppHeader,
    AppBody,
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
  }

  body {
    color: #0a0c27;
    background-color: #FDFDFD;
    margin: 0;
  }

  #app {
    font-family: 'Rubik', sans-serif;
  }

  .container {
    max-width: 740px;
    margin: 0 auto;
  }

  .no-doodle-support css-doodle {
    display: none;
  }
</style>
