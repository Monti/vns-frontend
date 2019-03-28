import Vue from 'vue';
import VueRouter from 'vue-router';
import WebFont from 'webfontloader';
import VueScrollTo from 'vue-scrollto';
import 'css-doodle';

import Registry from '@/build/contracts/Registry.json';

import App from './App.vue';

import Home from '@/pages/Home.vue';
import Manage from '@/pages/Manage.vue';
import ManageDomain from '@/pages/ManageDomain.vue';

Vue.config.productionTip = false;
Vue.use(VueRouter, VueScrollTo);

if (!window.customElements || !document.head.attachShadow) {
  document.body.classList.add('no-doodle-support');
}

const routes = [
  { path: '/', component: Home, name: 'home' },
  { path: '/manage', component: Manage, name: 'manage' },
  { path: '/manage/:domain', component: ManageDomain, name: 'manageDomain' },
];

const router = new VueRouter({
  routes,
  mode: 'history',
});

Vue.prototype.$address = '0x106802537f242826760f029eA887E8719264990A';
Vue.prototype.$contract = Registry;

// console.log(Registry.bytecode);

WebFont.load({
  google: {
    families: [
      'Rubik:500,700,900',
      'Roboto Mono:300,400,500,500i,700,700i'
    ]
  }
});

new Vue({
  router,
  el: "#app",
  components: { App }
});
