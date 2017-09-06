export default {
  state: {
    token: null,
    user: {
      id: null,
      username: null
    }
  },
  getters: {
    isAuthenticated: ({token}) => token != null
  },
  mutations: {
    setToken: (state, token) => state.token = token || null,
    setUser: (state, user) => state.user = user || null
  },
  actions: {
    logout: ({commit}) => {
      commit("setToken")
      commit("setUser")
    }
  },
  namespaced: true
}
