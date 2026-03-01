from fastapi import APIRouter

from app.schemas.matching import MatchRequest
from app.services.matching import AIMatcher
from app.services.portrait import generate_portrait

router = APIRouter()
matcher = AIMatcher()


@router.get('/health')
def health() -> dict:
    return {"status": "ok"}


@router.post('/portrait')
def portrait(req: MatchRequest) -> dict:
    return generate_portrait(req.current_user)


@router.post('/match')
def match(req: MatchRequest):
    return matcher.rank(req.current_user, req.candidates, req.top_k)
