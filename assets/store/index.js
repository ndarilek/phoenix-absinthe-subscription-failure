import Vuex from "vuex"
import createPersistedState from "vuex-persistedstate"

import auth from "./auth"

export default () => new Vuex.Store({
  strict: process.env.NODE_ENV !== "production",
  plugins: process.browser ? [createPersistedState()] : [],
  modules: {
    auth
  }
})
