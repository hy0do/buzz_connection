<template>
<div class='messageRoom'>
  <div id='box' class="box white-box">
    <div v-for="message in messages" :key="message.id" class="box_row">
      <div v-bind:class="messageClass(message.user.id)">
        <figure class="avatar">
          <img v-if="message.user.imageUrl" v-bind:src="message.user.imageUrl" class='img' />
          <span v-else class="img blank-avatar" />
        </figure>
        <div class="data">
          <small>{{ message.user.name }}</small>
          <p class="text">{{ message.text }}</p>
          <small>{{ dateTimeFormat(message.postedAt) }}</small>
        </div>
      </div>
    </div>
  </div>
  <div class='form'>
    <textarea v-model="text" placeholder="Aa" />
    <button type="button" class="button" v-if="messageChannel" @click="speak">送信</button>
  </div>
</div>
</template>

<script>
export default {
  data() {
    return {
      text: "",
      messages: this.$railsData.room.messages,
      roomId: this.$railsData.room.id,
      messageChannel: null,
    };
  },
  props: ['userId'],

  created() {
    this.messageChannel = this.$cable.subscriptions.create(
      {
        channel: "MessageChannel", 
        user_id: this.userId,
        message_room_id: this.roomId
      },
      {
      connected: () => {
        console.log('connected');
      },
      received: (data) => {
        this.messages.push(data)
        this.text = ''
      },
    })
  },
  mounted() {
    this.scrollBottom();
  },
  updated() {
    this.scrollBottom();
  },

  methods: {
    speak() {
      this.messageChannel.perform('speak', { 
        text: this.text,
        user_id: this.userId,
        message_room_id: this.roomId,
      });
    },

    messageClass (postUserId) {
      let defaultClass = ['message']
      if(postUserId === Number(this.userId)) {
        return defaultClass.concat('right').join(' ')
      } else {
        return defaultClass.concat('left').join(' ')
      }
    },

    dateTimeFormat (date_str) {
      const date = new Date(date_str)
      const year = date.getFullYear();
      const month = 1 + date.getMonth();
      const day = date.getDate();
      const hour = date.getHours();
      const minute = date.getMinutes();
      return `${year}/${month}/${day} ${hour}:${minute}`
    },

    scrollBottom() {
      const element = document.getElementById('box');
      element.scrollTop = element.scrollHeight;
    }
  }
};
</script>
