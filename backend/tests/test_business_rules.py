from datetime import datetime, timedelta
import sys
from pathlib import Path
sys.path.insert(0,str(Path(__file__).parents[1]))
from app.services.business_rules import approval_deadline, BusinessRuleError, can_cancel_client

def test_more_than_week():
    c=datetime(2026,11,1,10); s=c+timedelta(days=10)
    assert approval_deadline(c,s)==s-timedelta(days=2)
def test_more_than_three_days():
    c=datetime(2026,11,1,10); s=c+timedelta(days=5)
    assert approval_deadline(c,s)==s-timedelta(days=1)
def test_more_than_one_day():
    c=datetime(2026,11,1,10); s=c+timedelta(days=2)
    assert approval_deadline(c,s)==s-timedelta(hours=8)
def test_more_than_eight_hours():
    c=datetime(2026,11,1,10); s=c+timedelta(hours=12)
    assert approval_deadline(c,s)==s-timedelta(hours=4)
def test_eight_hours_or_less_rejected():
    c=datetime(2026,11,1,10); s=c+timedelta(hours=8)
    try: approval_deadline(c,s); assert False
    except BusinessRuleError: pass
def test_client_cancel_after_acceptance():
    start=datetime(2026,11,10,10)
    assert can_cancel_client(start-timedelta(hours=6),start,True)
    assert not can_cancel_client(start-timedelta(hours=4),start,True)
def test_client_cancel_without_acceptance():
    start=datetime(2026,11,10,10)
    assert can_cancel_client(start-timedelta(hours=1),start,False)
