<template>
  <div class="input">

    <input
      type="text"
      ref="input"
      :placeholder="placeholder"
      @input="onChange()"
      :value="value"
      :class="{ withLabel: label }"
    />

    <div class="label" v-if="label">
      {{ label }}
    </div>
  </div>
</template>

<script>
export default {
  name: 'AppInput',
  props: [
    'value',
    'label',
    'placeholder',
  ],
  methods: {
    onChange(val) {
      this.$emit('input', this.$refs.input.value);
    }
  }
}
</script>

<style lang="scss" scoped>
  .input {
    position: relative;

    input {
      background-color: transparent;
      border-radius: 3px;
      border: 2px solid #0a0c27;
      color: #0a0c27;
      font-family: 'Roboto Mono';
      font-size: 1rem;
      padding: 20px;
      width: 100%;

      &.withLabel {
        padding: 20px 100px 20px 20px;
      }
    }
  }

  .label {
    align-items: center;
    background-color: #0a0c27;
    border-radius: 0 3px 3px 0;
    color: #fff;
    display: flex;
    font-family: 'Roboto Mono';
    height: 100%;
    justify-content: center;
    padding: 0 20px;
    position: absolute;
    right: 0;
    top: 0;
    z-index: -1;
  }

</style>
