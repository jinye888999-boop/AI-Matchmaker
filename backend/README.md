# Python后端架构（FastAPI）

## 目录
- `app/main.py`：应用入口
- `app/api/routes.py`：API路由（健康检查、画像、匹配）
- `app/services/matching.py`：AI匹配算法
- `app/services/portrait.py`：AI用户画像生成逻辑
- `app/schemas/matching.py`：请求响应模型
- `tests/test_matching.py`：算法单元测试

## 启动
```bash
cd backend
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8000
```

## 核心接口
- `GET /api/v1/health`
- `POST /api/v1/portrait`
- `POST /api/v1/match`
