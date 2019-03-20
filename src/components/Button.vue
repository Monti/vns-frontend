<template>
  <button
    :class="{
      noStyling: type === 'noStyling',
    }"
    @click="handleClick">
    <slot />
  </button>
</template>

<script>
export default {
  name: 'Button',
  props: ['type'],
  methods: {
    handleClick() {
      this.$emit('onClick');
    }
  },
}
</script>

<style scoped lang="scss">
  button {
    border-radius: 3px;
    border: 2px solid #0a0c27;
    cursor: pointer;
    font-size: 1rem;
    padding: 5px 20px;
  }

  .noStyling {
    padding: 0;
    border: none;
  }
</style>
