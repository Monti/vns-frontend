<template>
  <div class="wrapper">
    <css-doodle id="doodle" class="doodle">
      :doodle {
        @grid: 48 / 100vw;
      }

      @size: 1px calc(100% * @sqrt(2) + 1px);
      transform: rotate(@p(45deg, -45deg));
      background: #AEACFB;
      margin: auto;
    </css-doodle>
  </div>
</template>

<script>
export default {
  name: "Doodle"
}
</script>

<style lang="scss">
  .wrapper {
    overflow: hidden;
  }
</style>
