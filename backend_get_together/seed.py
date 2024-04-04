from app import app
from models import db, User, Event
import json
from flask_bcrypt import Bcrypt
import random

if __name__ == "__main__":
    with app.app_context():
        bcrypt = Bcrypt(app)

        data = {}
        with open("db.json") as f:
            data = json.load(f)
        Event.query.delete()
        User.query.delete()
        event_list = []

        for e in data["events"]:
            event = Event(
                event_type=e.get("event_type"),
                name=e.get("name"),
                photo=e.get("photo"),
                location=e.get("location"),
                info=e.get("info"),
                date=e.get("date")
            )
            event_list.append(event)

        db.session.add_all(event_list)
        db.session.commit()
        event_list = []

        db.session.add(User(username="a", name="Test", password_hash=bcrypt.generate_password_hash("a")))
        db.session.add(User(username="b", name="Test", password_hash=bcrypt.generate_password_hash("b")))
        db.session.add(User(username="c", name="Test", password_hash=bcrypt.generate_password_hash("c")))
        db.session.commit()
print("seeding complete")
