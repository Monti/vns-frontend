<template>
  <div class="list">
    <div class="item" v-for="domain in genericSubDomains" :key="domain">
      <div>
        kenneth-{{ domain }}.vet
      </div>
      <div class="actions">
        <div class="price">
          <small>2000 VET</small>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import _ from 'lodash';
  import Button from '@/components/Button';
  import genericSubDomains from '@/helpers/generic-subdomains.json';

  export default {
    name: 'DomainResults',
    components: {
      Button,
    },
    data() {
      return {
        genericSubDomains
      }
    }
  }
</script>

<style lang="scss">
  .item {
    align-items: center;
    display: flex;
    justify-content: space-between;
    padding: 20px;
    transition: all 0.09s linear;

    &:hover {
      background-color: #f4f4f4
    }
  }

  .actions {
    align-items: center;
    display: flex;
  }

  .price {
    margin-right: 20px;
  }
</style>
