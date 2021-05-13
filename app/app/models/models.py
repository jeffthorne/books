from .. import db

class User(db.Model):
    __tablename__ = 'users'

    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(64), nullable=False, unique=True)
    first_name = db.Column(db.String(128), nullable=False)
    title = db.Column(db.String(128), nullable=True)
    last_name = db.Column(db.String(128), nullable=False)
    email = db.Column(db.String(128), nullable=False, unique=True)
    password = db.Column(db.String(64), nullable=False)