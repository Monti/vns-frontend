<template>
  <div class="hero">
    <div class="description">
      <h2>
        <slot name="title" />
      </h2>

      <p>
        <slot name="description" />
      </p>

      <slot name="extra" />

    </div>

    <div class="image">
      <slot name="image" />
    </div>

  </div>
</template>

<script>
export default {
  name: 'AppHero'
}
</script>

<style lang="scss">
  .hero {
    align-items: center;
    display: flex;
    margin: 0 auto;
    margin-bottom: 50px;

    @media (min-width: 320px) and (max-width: 480px) {
      margin-bottom: 20px;
    }
  }

  .description {
    flex: 3;
    position: relative;
    z-index: 1;

    p, a {
      line-height: 1.5rem;
      font-size: 0.9rem;
    }

    span {
      border-radius: 2px;
      background-color: #ddd;
      font-size: 90%;
      padding: 0 5px;
    }

    @media (min-width: 320px) and (max-width: 480px) {
      flex: 1;
    }
  }

  .image {
    flex: 4;
    margin: 0 auto;

    img {
      width: 100%;
    }

    @media (min-width: 320px) and (max-width: 480px) {
      display: none;
    }
  }


  a {
    text-decoration: underline;
  }
</style>
