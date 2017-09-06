<template>
  <div>
    <div class="container-fluid">
      <div class="row">
        <div class="col-sm-12">
          <nav class="navbar navbar-default">
            <div class="container-fluid">
              <div class="navbar-header">
                <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false">
                  <span class="sr-only">Toggle navigation</span>
                  <span class="icon-bar"/>
                  <span class="icon-bar"/>
                  <span class="icon-bar"/>
                </button>
                <nuxt-link class="navbar-brand" :to="{name: 'index'}">App</nuxt-link>
              </div>
              <div class="collapse navbar-collapse" id="navbar">
                <ul class="nav navbar-nav" role="presentation">
                  <li role="presentation"><nuxt-link :to="{name: 'index'}">Home</nuxt-link></li>
                  <li role="presentation" v-if="!isAuthenticated"><nuxt-link :to="{name: 'login'}">Login</nuxt-link></li>
                  <li role="presentation" v-if="!isAuthenticated"><nuxt-link :to="{name: 'signup'}">Sign Up</nuxt-link></li>
                </ul>
                <ul class="nav navbar-nav navbar-right" role="presentation" v-if="isAuthenticated">
                  <li><a href="#">{{username}}</a></li>
                  <li><button @click.prevent="logout">Logout</button></li>
                </ul>
              </div>
            </div>
          </nav>
        </div>
      </div>
      <div class="row">
        <main class="col-md-12">
          <nuxt/>
        </main>
      </div>
    </div>
    <footer class="footer">
      <div class="container-fluid">
        <div class="row">
          <div class="col-sm-12">
            <p class="float-xs-right">Copyright &copy; 2016 Nolan Darilek.</p>
          </div>
        </div>
      </div>
    </footer>
  </div>
</template>

<style src="bootstrap/dist/css/bootstrap.css"/>

<style src="toastr/build/toastr.css"/>

<style>
  /* Sticky footer styles
  -------------------------------------------------- */
  html {
    position: relative;
    min-height: 100%;
  }

  body {
    /* Margin bottom by footer height */
    margin-bottom: 60px;
  }

  .footer {
    position: absolute;
    bottom: 0;
    width: 100%;
    /* Set the fixed height of the footer here */
    height: 60px;
    background-color: #f5f5f5;
  }
</style>

<script>
  import {mapActions, mapGetters, mapState} from "vuex"

  export default {
    computed: {
      ...mapGetters({
        isAuthenticated: "auth/isAuthenticated"
      }),
      ...mapState({
        username: (state) => {
          if(state && state.auth && state.auth.user)
            return state.auth.user.username
          else
            return ""
        }
      })
    },
    methods: {
      logout() {
        this.logoutAction()
        .then(() => this.$router.push({name: "login"}))
      },
      ...mapActions({
        logoutAction: "auth/logout"
      })
    }
  }

</script>
