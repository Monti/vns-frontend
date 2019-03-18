import Vue from 'vue';
import VueRouter from 'vue-router';
import WebFont from 'webfontloader';
import 'css-doodle';

import App from './App.vue';
import Search from './Search.vue';

Vue.config.productionTip = false;
Vue.use(VueRouter);

if (!window.customElements || !document.head.attachShadow) {
  document.body.classList.add('no-doodle-support');
}

const routes = [
  { path: '/', component: App },
  { path: '/search/:name', component: Search },
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
}).$mount('#app');
