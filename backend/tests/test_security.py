import sys
from pathlib import Path
sys.path.insert(0,str(Path(__file__).parents[1]))
from app.core.security import hash_password, verify_password, create_access_token, decode_access_token

def test_hash_and_verify():
    hashed=hash_password('UnaMano#2026')
    assert hashed.startswith('scrypt$')
    assert verify_password('UnaMano#2026',hashed)
    assert not verify_password('incorrecta',hashed)

def test_jwt():
    token=create_access_token({'sub':'42','role':'Cliente'})
    payload=decode_access_token(token)
    assert payload['sub']=='42'
    assert payload['role']=='Cliente'
