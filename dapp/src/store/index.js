import Vue from 'vue'
import Vuex from 'vuex'
import CreatePersistedState from 'vuex-persistedstate'
import state from './state'

Vue.use(Vuex)

export default new Vuex.Store({
 strict: false,
 getters: {
   route: state => state.route
 },
 modules: {
     state
 },
 plugins: [
    CreatePersistedState({
      getState: (key) => {
        try {
          return JSON.parse(sessionStorage.getItem(key))
        } catch (e) {
            // eslint-disable-next-line
            console.log(e)
        }
      },
      setState: (key, state) => {
        try {
          return sessionStorage.setItem(key, JSON.stringify(state))
        } catch (e) {
            // eslint-disable-next-line
            console.log(e)
        }
      }
    })
  ] 
})