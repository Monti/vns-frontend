<template>
  <div class="input" :class="{ isX }">

    <input
      :min="min"
      ref="input"
      :type="type"
      :value="value"
      @input="onChange()"
      :placeholder="placeholder"
      :class="{
        withLabel: label,
        medium: size === 'medium'
      }"
    />

    <div
      v-if="label"
      class="label"
      :class="{
        transparent: labelStyle === 'transparent'
      }"
    >
      {{ label }}
    </div>
  </div>
</template>

<script>
export default {
  name: 'AppInput',
  props: [
    'isX',
    'min',
    'size',
    'type',
    'value',
    'label',
    'labelStyle',
    'placeholder',
  ],
  methods: {
    onChange() {
      if (this.$refs.input.value.length > 0) {
        this.$emit('input', this.$refs.input.value);
      }
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

      &.medium {
        font-size: 0.9rem;
        padding: 10px;
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
    padding: 0 40px;
    position: absolute;
    right: 0;
    top: 0;
    z-index: -1;

    @media (min-width: 320px) and (max-width: 480px) {
      padding: 0 20px;
    }

  }

  .transparent {
    border-left: 2px solid #0a0c27;
    background-color: transparent;
    color: #0a0c27;
  }

</style>
