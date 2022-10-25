const { createApp } = Vue

  createApp({
    data() {
      return {
        visible: false
      }
    },
    mounted() {
        window.addEventListener('message', this.onMessage);
    },
    destroyed() {
        window.removeEventListener('message')
    },
    methods: {
        onMessage(event) {
            if (event.data.type === 'toggle') {
              this.visible = event.data.visible
              console.log(this.visible)
            }
        }
    }
  }).mount('#app')