from __future__ import annotations

from dataclasses import dataclass
from math import sqrt
from typing import Iterable, List, Tuple

from app.schemas.matching import MatchCandidateInput, MatchResult


@dataclass
class WeightConfig:
    base: float = 10.0
    city: float = 20.0
    education: float = 15.0
    tags: float = 25.0
    personality: float = 30.0


def cosine_similarity(a: Iterable[float], b: Iterable[float]) -> float:
    a_list = list(a)
    b_list = list(b)
    if not a_list or not b_list or len(a_list) != len(b_list):
        return 0.0

    dot = sum(x * y for x, y in zip(a_list, b_list))
    norm_a = sqrt(sum(x * x for x in a_list))
    norm_b = sqrt(sum(y * y for y in b_list))
    if norm_a == 0 or norm_b == 0:
        return 0.0
    return dot / (norm_a * norm_b)


class AIMatcher:
    def __init__(self, weights: WeightConfig | None = None):
        self.weights = weights or WeightConfig()

    def _score_one(self, current: MatchCandidateInput, candidate: MatchCandidateInput) -> Tuple[float, List[str]]:
        score = self.weights.base
        reasons: List[str] = []

        if current.city == candidate.city:
            score += self.weights.city
            reasons.append("同城匹配，线下约会成本更低")

        if current.education == candidate.education:
            score += self.weights.education
            reasons.append("教育背景相近，价值观更易同步")

        overlap = set(current.tags) & set(candidate.tags)
        if overlap:
            ratio = len(overlap) / max(1, len(set(current.tags)))
            score += self.weights.tags * ratio
            reasons.append(f"共同兴趣：{', '.join(sorted(overlap))}")

        personality_score = cosine_similarity(current.personality_vector, candidate.personality_vector)
        if personality_score > 0:
            score += self.weights.personality * personality_score
            reasons.append("人格画像互补度较高")

        # 年龄差惩罚
        age_gap = abs(current.age - candidate.age)
        if age_gap > 8:
            penalty = min(10.0, (age_gap - 8) * 1.2)
            score -= penalty

        return round(max(0.0, min(score, 100.0)), 2), reasons

    def rank(self, current_user: MatchCandidateInput, candidates: List[MatchCandidateInput], top_k: int = 10) -> List[MatchResult]:
        results: List[MatchResult] = []
        for c in candidates:
            score, reasons = self._score_one(current_user, c)
            results.append(
                MatchResult(candidate_user_id=c.user_id, score=score, reasons=reasons)
            )

        results.sort(key=lambda item: item.score, reverse=True)
        return results[:top_k]
