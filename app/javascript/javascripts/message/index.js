import Vue from 'vue/dist/vue.esm'
import { createConsumer } from "@rails/actioncable";
import Message from './message.vue';

document.addEventListener('DOMContentLoaded', () => {
  const el = document.getElementById('message');

  if (el != null) {
    Vue.prototype.$cable = createConsumer(`ws://${window.location.host}/cable`);
    Vue.prototype.$railsData = window.railsData; // gonというGemを利用して渡している

    new Vue({
      el: el,
      components: { Message } 
    })
  }
});
