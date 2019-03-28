<template>
  <div>
    <div class="card">
      <div class="title">
        <h3>{{ domain }}<span>.vet</span></h3>
        <div>is unavailable</div>
      </div>
      <div class="label">
        Resolver:
        <div class="address">
          <a href="#">{{ resolver }}</a>
        </div>
      </div>
    </div>
    <h3>Here are some examples of other domains</h3>
    <DomainResults />
  </div>
</template>

<script>
  import { picasso } from '@vechain/picasso';
  import _ from 'lodash';

  import DomainResults from '@/components/DomainResults';

  export default {
    name: 'UnavailableDomain',
    props: ['domain', 'resolver'],
    components: {
      DomainResults,
    }
  }
</script>

<style lang="scss" scoped>
  .card {
    text-align: center;
    align-items: center;
    display: flex;
    flex-direction: column;
    margin: 100px 0;

    h3 {
      font-size: 3rem;
      margin: 0;
    }
  }

  .avatar {
    background-repeat: no-repeat;
    border-radius: 3px;
    display: block;
    height: 20px;
    margin: 0 10px;
    width: 20px;
    overflow: hidden;
  }

  .title {
    div {
      color: #E87D9B; 
    }
  }

  .label {
    align-items: center;
    display: flex;
    flex-direction: column;
    font-size: 0.9rem;
    margin: 20px 0;
  }

  .address {
    display: flex;
  }

</style>
