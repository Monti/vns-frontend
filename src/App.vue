<template>
  <div id="app">
    <AppHeader />
    <router-view></router-view>
  </div>
</template>

<script>
import AppHeader from './components/AppHeader.vue'

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

  h2, h3 {
    font-family: 'Rubik', sans-serif;
  }

  .container {
    max-width: 980px;
    margin: 0 auto;
  }

  .no-doodle-support css-doodle {
    display: none;
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
      font-family: 'Roboto Mono';
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

  a {
    color: #0a0c27;
    text-decoration: none;
  }
</style>
