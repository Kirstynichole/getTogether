from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import MetaData
from sqlalchemy.orm import validates
from sqlalchemy.ext.associationproxy import association_proxy
from sqlalchemy_serializer import SerializerMixin

metadata = MetaData(
    naming_convention={
        "ix": "ix_%(column_0_label)s",
        "uq": "uq_%(table_name)s_%(column_0_name)s",
        "ck": "ck_%(table_name)s_%(constraint_name)s",
        "fk": "fk_%(table_name)s_%(column_0_name)s_%(referred_table_name)s",
        "pk": "pk_%(table_name)s",
    }
)
db = SQLAlchemy(metadata=metadata)

class User(db.Model, SerializerMixin):
    __tablename__ = "user_table"
    serialize_rules = ["-matches.user"]
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String, unique=True, nullable=False)
    name = db.Column(db.String)
    password_hash = db.Column(db.String)
    phone_number = db.Column(db.String(length=20))
    matches = db.relationship("Match", back_populates="user", cascade="all,delete")
    events = association_proxy("matches", "event")

class Event(db.Model, SerializerMixin):
    __tablename__ = "event_table"
    serialize_rules = ["-matches.event"]
    id = db.Column(db.Integer, primary_key=True)
    event_type = db.Column(db.String)
    name = db.Column(db.String)
    location = db.Column(db.String)
    info = db.Column(db.String)
    photo = db.Column(db.String)
    date = db.Column(db.String)
    matches = db.relationship("Match", back_populates="event", cascade="all,delete")
    users = association_proxy("matches", "user")

class Match(db.Model, SerializerMixin):
    __tablename__ = "match_table"
    serialize_rules = ["-user.matches", "-event.matches"]
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey("user_table.id"))
    event_id = db.Column(db.Integer, db.ForeignKey("event_table.id"))
    user = db.relationship("User", back_populates="matches")
    event = db.relationship("Event", back_populates="matches")
