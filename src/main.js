import Vue from 'vue';
import VueRouter from 'vue-router';
import WebFont from 'webfontloader';
import VueScrollTo from 'vue-scrollto';
import 'css-doodle';

import Registry from '@/build/contracts/Registry.json';

import App from './App.vue';

import Send from '@/pages/Send.vue';
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
  { path: '/manage/:id', component: ManageDomain, name: 'manageDomain' },
  { path: '/send', component: Send, name: 'send' },
];

const router = new VueRouter({
  routes,
  mode: 'history',
});

Vue.prototype.$address = '0xb9185eC4fA0fc213CD40c27Cb13f7D3A3a5C5ABf';
Vue.prototype.$contract = Registry;

// console.log(Registry.bytecode)


WebFont.load({
  google: {
    families: [
      'Rubik:500,700,900',
      'Roboto Mono:300,400,400i,500,500i,700,700i'
    ]
  }
});

new Vue({
  router,
  el: "#app",
  components: { App }
});
