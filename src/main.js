import Vue from 'vue';
import VueRouter from 'vue-router';
import WebFont from 'webfontloader';

import App from './App.vue';

Vue.config.productionTip = false;
Vue.use(VueRouter);

const routes = [
  { path: '/', component: App },
];

const router = new VueRouter({
  routes,
});

WebFont.load({
  google: {
    families: [
      'Rubik:500,700,900',
      'Roboto Mono'
    ]
  }
});

new Vue({
  router,
}).$mount('#app');
