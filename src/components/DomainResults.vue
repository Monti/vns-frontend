<template>
  <div class="list">
    <div
      class="item"
      :key="suffix"
      @click="getDomain(suffix)"
      v-for="suffix in genericSuffixes"
    >
      <div>
        {{ domain }}-{{ suffix }}.vet
      </div>
      <div class="actions">
        <div class="price">
          <small>1000 VET</small>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import _ from 'lodash';
  import Button from '@/components/Button';
  import genericSuffixes from '@/helpers/generic-suffixes.json';

  export default {
    name: 'DomainResults',
    components: {
      Button,
    },
    props: ['domain'],
    data() {
      return {
        genericSuffixes
      }
    },
    methods: {
      getDomain(suffix) {
        const domain = `${this.domain}-${suffix}`;
        this.$emit('clicked', domain)
      }
    }
  }
</script>

<style lang="scss">
  .item {
    align-items: center;
    cursor: pointer;
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
