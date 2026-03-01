from typing import List
from uuid import UUID

from pydantic import BaseModel, Field


class MatchCandidateInput(BaseModel):
    user_id: UUID
    age: int
    city: str
    gender: int
    education: str
    tags: List[str] = Field(default_factory=list)
    personality_vector: List[float] = Field(default_factory=list)


class MatchRequest(BaseModel):
    current_user: MatchCandidateInput
    candidates: List[MatchCandidateInput]
    top_k: int = 10


class MatchResult(BaseModel):
    candidate_user_id: UUID
    score: float
    reasons: List[str]
