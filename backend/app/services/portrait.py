from app.schemas.matching import MatchCandidateInput


def generate_portrait(user: MatchCandidateInput) -> dict:
    personality = "温和沟通型" if user.personality_vector and user.personality_vector[0] > 0.5 else "理性成长型"
    return {
        "summary": f"{user.city}的{user.education}背景用户，偏好稳定关系。",
        "relationship_style": [personality, "重视长期承诺"],
        "suggestion": "建议先从共同兴趣切入，建立安全感。",
    }
