const { request } = require('../../utils/api')
Page({
  data: { result: '点击下方按钮，生成你的恋爱分析报告。' },
  async analyze() {
    try {
      const data = await request('/portrait', 'POST', {
        current_user: { user_id: 'u1', age: 26, city: '深圳', gender: 1, education: '本科', tags: ['旅行'], personality_vector: [0.5, 0.3, 0.2] },
        candidates: []
      })
      this.setData({ result: `${data.summary}
${data.suggestion}` })
    } catch (e) {
      this.setData({ result: '分析失败，请稍后重试。' })
    }
  }
})
