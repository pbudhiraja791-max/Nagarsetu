import sys
import os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from app.main import app
from app.api.v1.router import api_router

print("=== NagarSetu API v1 Sub-Routes ===")
for route in api_router.routes:
    methods = getattr(route, "methods", None)
    path = getattr(route, "path", str(route))
    name = getattr(route, "name", "")
    m_str = ", ".join(methods) if methods else "MOUNT"
    print(f"{m_str:<20} /api/v1{path:<35} ({name})")

print("\n=== Checking Database Connection & Tables ===")
from app.core.database import SessionLocal, engine
from sqlalchemy import inspect

inspector = inspect(engine)
tables = inspector.get_table_names()
print(f"Tables in DB: {tables}")
for t in tables:
    cols = [c["name"] for c in inspector.get_columns(t)]
    print(f"  {t} ({len(cols)} cols): {cols[:5]} ...")

print("\n=== Verification Completed ===")
