const MAX_MESSAGE_LENGTH = 200

Page({
  data: {
    messages: [
      { from: 'ta', text: '你好，很高兴认识你～' },
      { from: 'me', text: '你好呀！最近在看什么电影？' }
    ],
    input: '',
    canSend: false
  },

  onInput(e) {
    const value = String(e.detail.value || '').slice(0, MAX_MESSAGE_LENGTH)
    this.setData({
      input: value,
      canSend: Boolean(value.trim())
    })
  },

  send() {
    const content = this.data.input.trim()

    if (!content) {
      return
    }

    const messages = this.data.messages.concat({ from: 'me', text: content })
    this.setData({ messages, input: '', canSend: false })
  }
})
