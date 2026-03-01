Page({
  data: {
    messages: [
      { from: 'ta', text: '你好，很高兴认识你～' },
      { from: 'me', text: '你好呀！最近在看什么电影？' }
    ],
    input: ''
  },

  onInput(e) {
    this.setData({ input: e.detail.value })
  },

  send() {
    if (!this.data.input) return
    const messages = this.data.messages.concat({ from: 'me', text: this.data.input })
    this.setData({ messages, input: '' })
  }
})
