Page({
  data: {
    steps: [
      '微信授权登录',
      '填写资料',
      'AI生成画像',
      'AI匹配推荐',
      '聊天互动',
      '会员升级'
    ]
  },

  goRecommend() { wx.switchTab({ url: '/pages/recommend/index' }) },
  goChatList() { wx.navigateTo({ url: '/pages/chat-list/index' }) },
  goMatchSuccess() { wx.navigateTo({ url: '/pages/match-success/index' }) },
  goAiHome() { wx.switchTab({ url: '/pages/matchmaker/index' }) },
  goEditProfile() { wx.navigateTo({ url: '/pages/edit-profile/index' }) },
  goAiLoveAnalysis() { wx.navigateTo({ url: '/pages/ai-love-analysis/index' }) },
  goAiChatAssistant() { wx.navigateTo({ url: '/pages/ai-chat-assistant/index' }) },
  goAiDateAdvice() { wx.navigateTo({ url: '/pages/ai-date-advice/index' }) }
})
