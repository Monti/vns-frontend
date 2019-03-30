<template>
  <div class="avatar">
    <css-doodle>
      :doodle {
        @grid: 80x1 / 8em 15em;
      }

      @size: 100% 1px;
      justify-self: center;
      background: #FFAA6E;
      opacity: calc(1 - @i() / @size());
      transform:
        translateX(calc(@sin(@i() / 20) * @PI() * 0px));
    </css-doodle>
  </div>
</template>

<script>
export default {
  name: 'AvatarDoodle'
}
</script>

<style scoped lang="scss">
  .avatar {
    border-radius: 50%;
    height: 20px;
    overflow: hidden;
    width: 20px;
  }
</style>
