<template>
  <div>
    <h1>Login</h1>
    <p>Don't have an account? <nuxt-link :to="{name: 'signup'}">Sign up!</nuxt-link></p>
    <form @submit.prevent="submit">
      <div class="form-group" :class="{'has-error': errors.has('username')}">
        <label for="emailOrUsername">Email or username</label>
        <input type="text" name="emailOrUsername" id="emailOrUsername" v-model.trim="emailOrUsername" v-validate data-vv-rules="required" autofocus/>
        <p v-if="errors.has('emailOrUsername')" class="text-danger">{{errors.first("emailOrUsername")}}</p>
      </div>
      <div class="form-group" :class="{'has-error': errors.has('password')}">
        <label for="password">Password</label>
        <input type="password" name="password" id="password" v-model="password" v-validate data-vv-rules="required"/>
        <p v-if="errors.has('password')" class="text-danger">{{errors.first("password")}}</p>
      </div>
      <button type="submit" class="btn btn-default">Login</button>
    </form>
  </div>
</template>

<script>
import toastr from "toastr"
import {mapGetters, mapMutations} from "vuex"

import logInWithPassword from "~/apollo/auth/mutations/log-in-with-password"

export default {
  data: () => ({
    emailOrUsername: "",
    password: ""
  }),
  computed: {
    ...mapGetters({
      isAuthenticated: "auth/isAuthenticated"
    }),
    redirect() {
      return this.$route.query.redirect
    }
  },
  methods: {
    ...mapMutations({
      setToken: "auth/setToken",
      setUser: "auth/setUser"
    }),
    async submit(e) {
      const success = await this.$validator.validateAll()
      if(!success)
        return
      try {
        const {data} = await this.$apollo.mutate({
          mutation: logInWithPassword,
          variables: {
            emailOrUsername: this.emailOrUsername,
            password: this.password
          }
        })
        if(data.logIn) {
          this.setToken(data.logIn.token)
          this.setUser(data.logIn.user)
          this.$apollo.provider.defaultClient.resetStore()
        }
      } catch(e) {
        if(e.graphQLErrors && e.graphQLErrors.length)
          toastr.error(e.graphQLErrors[0].message)
        else
          toastr.error(e)
      }
    },
    redirectBackOrHome() {
      if(this.redirect)
        this.$router.push(this.redirect)
      else
        this.$router.push({name: "index"})
    }
  },
  watch: {
    isAuthenticated(newValue) {
      if(newValue)
        this.redirectBackOrHome()
    }
  },
  head: {
    title: "Login"
  }
}

</script>
