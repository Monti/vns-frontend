<template>
  <div id="app">
  </div>
</template>

<script>
import AppHeader from './components/AppHeader.vue'
import AppBody from './components/AppBody.vue'

export default {
  name: 'Search',
  components: {
    AppHeader,
    AppBody,
  },
  mounted() {
    console.log(this.$route.params)
  }
}
</script>
<style>

</style>
