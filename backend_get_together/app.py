from flask import Flask, make_response, jsonify, request, session, g
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_cors import CORS
from models import db, User, Event
from dotenv import dotenv_values
from flask_bcrypt import Bcrypt
import json
config = dotenv_values(".env")

app = Flask(__name__)
app.secret_key = config['FLASK_SECRET_KEY']
CORS(app)
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///app.db"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.json.compact = False
bcrypt = Bcrypt(app)
migrate = Migrate(app, db)

db.init_app(app)

@app.route("/")
def root():
    return "<h1>Welcome to the simple json server<h1>"

@app.get('/users')
def get_users():
    users = [user.to_dict() for user in User.query.all()]
    return make_response(users, 200)

@app.get('/events')
def get_events():
    events = [event.to_dict() for event in Event.query.all()]
    return make_response(events, 200)

if __name__ == "__main__":
    app.run(port=5555, debug=True)