<template>
  <div>

    <div class="status">
      <div>available</div>
    </div>

    <div class="card">
      <!-- <h3>{{ domain }}</h3> -->
      <div class="header">

        <div class="title">
          <h3>domain.vet</h3>
          <Button
            @onClick="onClick"
            type="noStyling"
          >
            <Star :selected="selected" />
          </Button>
        </div>

        <div>
        </div>

      </div>

      <div class="footer">
        <Button>Buy</Button>
      </div>
    </div>
  </div>
</template>

<script>
  import Doodle from '@/components/Doodle';
  import Button from '@/components/Button';
  import { picasso } from '@vechain/picasso';
  import { Star } from '@/components/Icons';

  export default {
    name: "DomainCard",
    props: ['domain'],
    components: {
      Button,
      Doodle,
      Star,
    },
    data() {
      return {
        selected: true,
      }
    },
    methods: {
      avatar() {
        return picasso('0x7567D83b7b8d80ADdCb281A71d54Fc7B3364ffed');
      },
      onClick() {
      }
    }
  }
</script>

<style lang="scss" scoped>
  .header {
    align-items: center;
    display: flex;
    justify-content: space-between;
    margin-bottom: 20px;
  }

  .title {
    display: flex;
    justify-content: space-between;
    width: 100%;
  }
  
  .status {
    color: #0a0c27;
    display: flex;
    font-size: 0.7rem;
    text-transform: uppercase;
    position: relative;

    div {
      background-color: #e1e4e8;
      border-radius: 3px 3px 0 0;
      padding: 5px;
    }
  }

  .unavailable {
    background-color: #E87D9B;
  }

  .card {
    border: 2px solid #e1e4e8;
    border-radius: 0 3px 3px 3px;
    padding: 20px;

    h3 {
      font-size: 3rem;
      margin: 0;
    }
  }

  .owner {
    align-items: center;
    display: flex;
    font-size: 0.9rem;
    margin-bottom: 10px;
  }

  .avatar {
    border-radius: 3px;
    display: block;
    height: 20px;
    margin: 5px;
    width: 20px;
  }

  .footer {
    display: flex;
    justify-content: flex-end;
  }
</style>
