Page({
  data: {
    chats: [
      { id: 'u101', name: '知夏', msg: '今晚有空聊聊吗？' },
      { id: 'u102', name: '安宁', msg: '你推荐的电影我看了！' }
    ]
  },
  openChat() { wx.switchTab({ url: '/pages/chat/index' }) }
})
