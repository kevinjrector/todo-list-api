import os
from sqlalchemy import create_engine, text
from sqlalchemy.orm import Session
from dotenv import load_dotenv

load_dotenv()

database_url = os.getenv("DATABASE_URL")
print(f"Database URL: {database_url}")

engine = create_engine(f"{database_url}", echo=True)

def test_connection():
    try:
        with Session(engine) as session:
            session.execute(text("SELECT 1"))
            print("Database connection successful!")
    except Exception as e:
        print(f"Database connection failed: {e}")
        
test_connection()