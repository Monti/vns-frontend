import Vue from 'vue';
import VueRouter from 'vue-router';
import WebFont from 'webfontloader';
import 'css-doodle';

import App from './App.vue';

import Search from '@/pages/Search.vue';
import Home from '@/pages/Home.vue';

Vue.config.productionTip = false;
Vue.use(VueRouter);

if (!window.customElements || !document.head.attachShadow) {
  document.body.classList.add('no-doodle-support');
}

const routes = [
  { path: '/', component: Home, name: 'home' },
  { path: '/search/:domain', component: Search, name: 'search' },
];

const router = new VueRouter({
  mode: 'history',
  routes,
});

WebFont.load({
  google: {
    families: [
      'Rubik:500,700,900',
      'Roboto Mono:300,400'
    ]
  }
});

new Vue({
  router,
  el: "#app",
  components: { App }
});
