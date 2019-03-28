<template>
  <button
    @click="handleClick"
    :class="{
      medium: size === 'medium',
      small: size === 'small',
      special: type === 'special',
      noStyling: type === 'noStyling',
      transparent: type === 'transparent',
    }"
  >
    <slot />
  </button>
</template>

<script>
export default {
  name: 'Button',
  props: ['type', 'size'],
  methods: {
    handleClick() {
      this.$emit('onClick');
    }
  },
}
</script>

<style scoped lang="scss">
  button {
    background-color: transparent;
    border-radius: 3px;
    border: 2px solid #0a0c27;
    cursor: pointer;
    font-size: 1rem;
    padding: 10px 20px;
    position: relative;

    &.special {
      &::after {
        background-color: #FFAA6E;
        border-radius: 3px;
        content: "";
        display: block;
        height: 100%;
        position: absolute;
        top: 10px;
        left: 10px;
        width: 100%;
        z-index: -1;
      }
    }


    &:hover {
      border: 2px solid #1D2E9F;
      background-color: #1D2E9F;
      color: #ffffff;
    }
  }

  .noStyling {
    padding: 0;
    border: none;
  }

  .medium {
    font-size: 0.9rem;
    padding: 10px 20px;
  }

  .small {
    font-size: 0.8rem;
    padding: 5px 10px;
  }

  .transparent {
    border-color: transparent;
  }
</style>
