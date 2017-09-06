<template>
  <div class="jumbotron">
    <h1>{{error.statusCode}}</h1>
    <p class="hero">{{error.message}}</p>
  </div>
</template>

<script>
  export default {
    props: ["error"]
  }
</script>
