<template>
  <router-link class="link" tag="div" :to="'/manage/' + domain.id">
    {{ domain[0] }}.vet
  </router-link>
</template>

<script>
  export default {
    name: 'AppDomain',
    props: ['domain'],
  }
</script>

<style lang="scss" scoped>
  .domain {
    display: flex;
  }

  .link {
    background-color: #fafafa;
    border-radius: 3px;
    cursor: pointer;
    padding: 20px;

    &:hover {
      background-color: #FFAA6E;
      color: #ffffff;
    }
  }
</style>
