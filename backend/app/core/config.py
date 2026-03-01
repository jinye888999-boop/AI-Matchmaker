from pydantic import BaseModel


class Settings(BaseModel):
    app_name: str = "AI Matchmaker API"
    api_prefix: str = "/api/v1"


settings = Settings()
