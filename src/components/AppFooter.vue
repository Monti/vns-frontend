<template>
  <footer>
    <div class="background">
      <Doodle />
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
    position: absolute;
    overflow: hidden;
    width: 100%;
  }
</style>
