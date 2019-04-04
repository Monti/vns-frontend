<template>
  <div>
    <div v-if="signer" class="user">
      <small v-if="text" class="intro">{{ text }}</small>
      <div class="address">
        <AvatarDoodle />
        <div class="signer">
          <small>{{ signer }}</small>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import AvatarDoodle from '@/components/AvatarDoodle';

export default {
  name: 'AddressAvatar',
  props: ['signer', 'isX', 'text'],
  components: {
    AvatarDoodle
  }
}
</script>

<style lang="scss" scoped>
  .intro {
    font-style: italic;
  }

  .user {
    margin: 10px 0;
  }

  .address {
    align-items: center;
    display: flex;
    margin: 5px 0;
  }

  .signer {
    display: flex;
    margin-left: 10px;
  }

</style>
