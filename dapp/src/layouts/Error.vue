<template>
  <div class="container">
    <h1 v-if="error.statusCode === 404">Page non trouvée</h1>
    <h1 v-else>Une erreur s'est produite</h1>
    <nuxt-link to="/">Accueil</nuxt-link>
  </div>
</template>

<script>
export default {
  props: ['error'],
  layout: 'blog' // vous pouvez définir une mise en page personnalisée pour la page d'erreur
}
</script>