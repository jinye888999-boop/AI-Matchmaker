-- AI红娘小程序数据库设计（30张表）
-- PostgreSQL 14+

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. 用户主表
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    openid VARCHAR(64) UNIQUE NOT NULL,
    unionid VARCHAR(64),
    phone VARCHAR(20),
    nickname VARCHAR(64),
    avatar_url TEXT,
    gender SMALLINT CHECK (gender IN (0,1,2)),
    birthday DATE,
    city VARCHAR(64),
    bio TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 2. 用户详情
CREATE TABLE user_profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    height_cm SMALLINT,
    education VARCHAR(32),
    job_title VARCHAR(64),
    income_level VARCHAR(32),
    marital_status VARCHAR(32),
    zodiac VARCHAR(16),
    mbti VARCHAR(8),
    hobbies JSONB,
    personality_tags JSONB,
    target_relationship VARCHAR(32),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE(user_id)
);

-- 3. 用户照片
CREATE TABLE user_photos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    photo_url TEXT NOT NULL,
    is_primary BOOLEAN NOT NULL DEFAULT FALSE,
    sort_order INTEGER NOT NULL DEFAULT 0,
    audit_status VARCHAR(20) NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 4. 偏好设置
CREATE TABLE user_preferences (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    preferred_gender SMALLINT,
    age_min SMALLINT,
    age_max SMALLINT,
    height_min SMALLINT,
    height_max SMALLINT,
    cities JSONB,
    education_levels JSONB,
    must_have_tags JSONB,
    deal_breakers JSONB,
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE(user_id)
);

-- 5. 兴趣标签
CREATE TABLE tags (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tag_type VARCHAR(20) NOT NULL,
    tag_name VARCHAR(64) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE(tag_type, tag_name)
);

-- 6. 用户标签关联
CREATE TABLE user_tags (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    tag_id UUID NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
    weight NUMERIC(4,2) NOT NULL DEFAULT 1.0,
    UNIQUE(user_id, tag_id)
);

-- 7. AI画像
CREATE TABLE ai_portraits (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    summary TEXT NOT NULL,
    strengths JSONB,
    relationship_style JSONB,
    communication_style JSONB,
    risk_flags JSONB,
    embedding VECTOR(768),
    version VARCHAR(16) NOT NULL DEFAULT 'v1',
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 8. 匹配候选池
CREATE TABLE match_candidates (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    candidate_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    source VARCHAR(20) NOT NULL DEFAULT 'ai',
    initial_score NUMERIC(5,2) NOT NULL,
    final_score NUMERIC(5,2),
    reasons JSONB,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE(user_id, candidate_user_id)
);

-- 9. 匹配反馈
CREATE TABLE match_feedback (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    candidate_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    action VARCHAR(20) NOT NULL CHECK(action IN ('like','pass','super_like','block')),
    feedback_tags JSONB,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 10. AI匹配解释
CREATE TABLE match_explanations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    match_candidate_id UUID NOT NULL REFERENCES match_candidates(id) ON DELETE CASCADE,
    natural_language TEXT NOT NULL,
    dimensions JSONB,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 11. 聊天会话
CREATE TABLE chat_rooms (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    room_type VARCHAR(20) NOT NULL DEFAULT 'private',
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 12. 聊天成员
CREATE TABLE chat_room_members (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    room_id UUID NOT NULL REFERENCES chat_rooms(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    joined_at TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE(room_id, user_id)
);

-- 13. 聊天消息
CREATE TABLE chat_messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    room_id UUID NOT NULL REFERENCES chat_rooms(id) ON DELETE CASCADE,
    sender_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    msg_type VARCHAR(20) NOT NULL DEFAULT 'text',
    content TEXT,
    ext JSONB,
    sent_at TIMESTAMP NOT NULL DEFAULT NOW(),
    recalled BOOLEAN NOT NULL DEFAULT FALSE
);

-- 14. 消息已读
CREATE TABLE message_reads (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    message_id UUID NOT NULL REFERENCES chat_messages(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    read_at TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE(message_id, user_id)
);

-- 15. AI建议
CREATE TABLE ai_chat_suggestions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    room_id UUID NOT NULL REFERENCES chat_rooms(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    suggestion TEXT NOT NULL,
    strategy VARCHAR(32),
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 16. AI恋爱课程
CREATE TABLE ai_love_lessons (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(100) NOT NULL,
    level VARCHAR(20) NOT NULL,
    content TEXT NOT NULL,
    tags JSONB,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 17. 用户学习记录
CREATE TABLE user_lesson_records (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    lesson_id UUID NOT NULL REFERENCES ai_love_lessons(id) ON DELETE CASCADE,
    progress SMALLINT NOT NULL DEFAULT 0,
    completed_at TIMESTAMP,
    UNIQUE(user_id, lesson_id)
);

-- 18. AI咨询会话
CREATE TABLE ai_consult_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    topic VARCHAR(64),
    summary TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 19. AI咨询消息
CREATE TABLE ai_consult_messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_id UUID NOT NULL REFERENCES ai_consult_sessions(id) ON DELETE CASCADE,
    role VARCHAR(20) NOT NULL CHECK(role IN ('user','assistant','system')),
    content TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 20. 会员套餐
CREATE TABLE membership_plans (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    plan_code VARCHAR(32) UNIQUE NOT NULL,
    plan_name VARCHAR(64) NOT NULL,
    price_cent INTEGER NOT NULL,
    duration_days INTEGER NOT NULL,
    benefits JSONB NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 21. 用户会员
CREATE TABLE user_memberships (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    plan_id UUID NOT NULL REFERENCES membership_plans(id),
    start_at TIMESTAMP NOT NULL,
    end_at TIMESTAMP NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 22. 订单
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_no VARCHAR(40) UNIQUE NOT NULL,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    amount_cent INTEGER NOT NULL,
    order_type VARCHAR(32) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'created',
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    paid_at TIMESTAMP
);

-- 23. 支付流水
CREATE TABLE payments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    channel VARCHAR(20) NOT NULL DEFAULT 'wechat_pay',
    transaction_id VARCHAR(64),
    amount_cent INTEGER NOT NULL,
    status VARCHAR(20) NOT NULL,
    callback_payload JSONB,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 24. 身份认证申请
CREATE TABLE verification_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    verify_type VARCHAR(20) NOT NULL CHECK(verify_type IN ('real_name','education','income','photo')),
    payload JSONB NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    reviewed_by UUID,
    reviewed_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 25. 审核日志
CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    entity_type VARCHAR(32) NOT NULL,
    entity_id UUID NOT NULL,
    action VARCHAR(32) NOT NULL,
    operator_id UUID,
    details JSONB,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 26. 举报记录
CREATE TABLE reports (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    reporter_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    target_user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    target_message_id UUID REFERENCES chat_messages(id) ON DELETE SET NULL,
    reason VARCHAR(64) NOT NULL,
    evidence JSONB,
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 27. 黑名单
CREATE TABLE user_blocks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    blocked_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE(user_id, blocked_user_id)
);

-- 28. 设备登录
CREATE TABLE user_devices (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    device_id VARCHAR(128) NOT NULL,
    platform VARCHAR(20),
    os_version VARCHAR(32),
    last_login_at TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE(user_id, device_id)
);

-- 29. 通知中心
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    category VARCHAR(32) NOT NULL,
    title VARCHAR(100) NOT NULL,
    content TEXT NOT NULL,
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 30. 系统配置
CREATE TABLE system_configs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    config_key VARCHAR(64) UNIQUE NOT NULL,
    config_value JSONB NOT NULL,
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_match_candidates_user_score ON match_candidates(user_id, final_score DESC);
CREATE INDEX idx_chat_messages_room_time ON chat_messages(room_id, sent_at DESC);
CREATE INDEX idx_orders_user_time ON orders(user_id, created_at DESC);
CREATE INDEX idx_notifications_user_unread ON notifications(user_id, is_read, created_at DESC);
