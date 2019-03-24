<template>
  <div class="wrapper">
    Domain.vet

    <div class="domain">
      <div>owner:</div>
      <div>
        <a :href="veforge + owner" target="_blank">
          {{ owner }}
        </a>
      </div>
    </div>

    <div class="domain">
      <div>resolver:</div>
      <div>
        <a :href="veforge + resolver" target="_blank">
          {{ resolver }}
        </a>
      </div>
    </div>

  </div>
</template>

<script>
  export default {
    name: 'AppDomain',
    data() {
      return {
        owner: '0x1717171717171728282828291919182828',
        veforge: 'https://explore.veforge.com/accounts/',
        resolver: '0x1919182876262525626272829292998838'
      }
    },
  }
</script>

<style lang="scss" scoped>
  .wrapper {
    background-color: #fafafa;
    padding: 20px;
  }

  .domain {
    display: flex;
  }
</style>
