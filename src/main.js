import Vue from 'vue';
import VueRouter from 'vue-router';
import WebFont from 'webfontloader';
import VueScrollTo from 'vue-scrollto';
import VTooltip from 'v-tooltip';
import VueLoading from 'vue-loading-template';
import 'css-doodle';

import Registry from '@/build/contracts/Registry.json';

import App from './App.vue';

import Send from '@/pages/Send.vue';
import Home from '@/pages/Home.vue';
import Help from '@/pages/Help.vue';
import Manage from '@/pages/Manage.vue';
import ManageDomain from '@/pages/ManageDomain.vue';

Vue.config.productionTip = false;

Vue.use(VueRouter);
Vue.use(VueScrollTo);
Vue.use(VTooltip);
Vue.use(VueLoading);

if (!window.customElements || !document.head.attachShadow) {
  document.body.classList.add('no-doodle-support');
}

const routes = [
  { path: '/', component: Home, name: 'home' },
  { path: '/manage', component: Manage, name: 'manage' },
  { path: '/manage/:id', component: ManageDomain, name: 'manageDomain' },
  { path: '/send', component: Send, name: 'send' },
  { path: '/help', component: Help, name: 'help' },
];

const router = new VueRouter({
  routes,
  mode: 'history',
});

// mainnet
Vue.prototype.$address = '0xa94eCb69c9303a5CF27D694602eCE285dBf72672';
// testnet
// Vue.prototype.$address = '0xE16d21d50b032eeA28dE721a695Eef67b0B20bfd';

Vue.prototype.$contract = Registry;

// console.log(JSON.stringify(Registry.bytecode))


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
