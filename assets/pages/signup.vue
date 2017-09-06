<template>
  <div>
    <h1>Sign Up</h1>
    <p>Already have an account? <router-link :to="{name: 'login'}">Log in!</router-link></p>
    <form @submit.prevent="submit">
      <div class="form-group" :class="{'has-error': errors.has('email')}">
        <label for="email">Email</label>
        <input type="text" name="email" id="email" v-model.trim="email" v-validate data-vv-rules="required|email" autofocus/>
        <p v-if="errors.has('email')" class="text-danger">{{errors.first("email")}}</p>
      </div>
      <div class="form-group" :class="{'has-error': errors.has('username')}">
        <label for="username">Username</label>
        <input type="text" name="username" id="username" v-model.trim="username" v-validate data-vv-rules="required"/>
        <p v-if="errors.has('username')" class="text-danger">{{errors.first("username")}}</p>
      </div>
      <div class="form-group" :class="{'has-error': errors.has('password')}">
        <label for="password">Password</label>
        <input type="password" name="password" id="password" v-model="password" v-validate data-vv-rules="required"/>
        <p v-if="errors.has('password')" class="text-danger">{{errors.first("password")}}</p>
      </div>
      <button type="submit" class="btn btn-default">Sign Up</button>
    </form>
  </div>
</template>

<script>
import toastr from "toastr"
import {mapGetters, mapMutations} from "vuex"

import signUp from "~/apollo/auth/mutations/sign-up"

export default {
  data: () => ({
    username: "",
    email: "",
    password: ""
  }),
  computed: mapGetters({
    isAuthenticated: "auth/isAuthenticated"
  }),
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
          mutation: signUp,
          variables: {
            email: this.email,
            username: this.username,
            password: this.password
          }
        })
        if(data.createUser) {
          this.setToken(data.createUser.token)
          this.setUser(data.createUser.user)
          this.$apollo.provider.defaultClient.resetStore()
          this.$router.push({name: "index"})
        }
      } catch(e) {
        if(e.graphQLErrors && e.graphQLErrors.length)
          toastr.error(e.graphQLErrors[0].message)
        else {
          console.log(e)
          toastr.error(e)
        }
      }
    }
  },
  watch: {
    isAuthenticated(newValue) {
      if(newValue)
        this.$router.push({name: "index"})
    }
  },
  head: {
    title: "Sign Up"
  }
}

</script>
