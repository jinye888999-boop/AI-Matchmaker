import unittest
from uuid import uuid4

from app.schemas.matching import MatchCandidateInput
from app.services.matching import AIMatcher


class TestMatcher(unittest.TestCase):
    def test_rank(self):
        current = MatchCandidateInput(
            user_id=uuid4(), age=26, city="深圳", gender=1, education="本科", tags=["旅行", "电影"], personality_vector=[0.6, 0.2, 0.3]
        )
        candidates = [
            MatchCandidateInput(
                user_id=uuid4(), age=25, city="深圳", gender=2, education="本科", tags=["旅行", "音乐"], personality_vector=[0.6, 0.1, 0.3]
            ),
            MatchCandidateInput(
                user_id=uuid4(), age=34, city="广州", gender=2, education="硕士", tags=["运动"], personality_vector=[0.1, 0.2, 0.1]
            ),
        ]

        results = AIMatcher().rank(current, candidates, top_k=2)
        self.assertEqual(len(results), 2)
        self.assertGreater(results[0].score, results[1].score)


if __name__ == '__main__':
    unittest.main()
