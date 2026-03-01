const BASE_URL = 'http://localhost:8000/api/v1'

const request = (url, method = 'GET', data = {}) => {
  return new Promise((resolve, reject) => {
    wx.request({
      url: `${BASE_URL}${url}`,
      method,
      data,
      success: (res) => resolve(res.data),
      fail: reject
    })
  })
}

module.exports = {
  request
}
