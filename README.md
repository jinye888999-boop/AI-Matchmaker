# AI红娘微信小程序（全栈示例）

本项目提供你要求的四大部分：

1. **完整数据库设计（30张表）**：`database/schema.sql`
2. **AI匹配算法完整代码**：`backend/app/services/matching.py`
3. **微信小程序完整前端代码**：`miniapp/`
4. **Python后端完整架构**：`backend/`

## 项目目录

```text
AI-Matchmaker/
├── database/
│   └── schema.sql
├── backend/
│   ├── app/
│   │   ├── api/routes.py
│   │   ├── core/config.py
│   │   ├── schemas/matching.py
│   │   ├── services/matching.py
│   │   └── services/portrait.py
│   ├── tests/test_matching.py
│   └── requirements.txt
└── miniapp/
    ├── app.json
    ├── app.js
    ├── app.wxss
    ├── utils/api.js
    └── pages/
```

## 快速开始

### 1) 后端

```bash
cd backend
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8000
```

### 2) 小程序

使用微信开发者工具打开 `miniapp` 目录，确保 `utils/api.js` 的后端地址可访问。
