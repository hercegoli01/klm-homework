import os
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

# 1) Cloud Run / GCP (Secret Manager + env vars)
DB_USER = os.getenv("DB_USER", "postgres")
DB_PASS = os.getenv("DB_PASSWORD")
DB_NAME = os.getenv("DB_NAME", "notesdb")
DB_CONN = os.getenv("DB_CONN")  # Cloud SQL connection name

# 2) General DATABASE_URL (pl. docker-compose vagy manuálisan)
DATABASE_URL = os.getenv("DATABASE_URL")

# 3) Fallback kapcsolati string választás
if DATABASE_URL:
    SQLALCHEMY_DATABASE_URL = DATABASE_URL
elif DB_CONN and DB_PASS:
    # Cloud Run + Cloud SQL socket
    SQLALCHEMY_DATABASE_URL = (
        f"postgresql://{DB_USER}:{DB_PASS}@/{DB_NAME}?host=/cloudsql/{DB_CONN}"
    )
else:
    # fallback: lokális fejlesztői gép
    SQLALCHEMY_DATABASE_URL = "sqlite:///./notes.db"  # <<<< INKÁBB SQLITE fallback

# 4) Engine létrehozása (echo=True = debug log, opcionális)
engine = create_engine(
    SQLALCHEMY_DATABASE_URL,
    connect_args={"check_same_thread": False} if SQLALCHEMY_DATABASE_URL.startswith("sqlite") else {}
)

# 5) Session + Base
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()
