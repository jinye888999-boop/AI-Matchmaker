const { request } = require('../../utils/api')

Page({
  data: {
    advice: ''
  },

  async getAdvice() {
    const payload = {
      current_user: {
        user_id: 'e0d44c11-1111-4444-9999-f2fd7f71d100',
        age: 26,
        city: '深圳',
        gender: 1,
        education: '本科',
        tags: ['旅行', '电影'],
        personality_vector: [0.6, 0.2, 0.3]
      },
      candidates: []
    }

    try {
      const data = await request('/portrait', 'POST', payload)
      this.setData({ advice: `${data.summary}\n建议：${data.suggestion}` })
    } catch (e) {
      wx.showToast({ title: '获取建议失败', icon: 'none' })
    }
  }
})
