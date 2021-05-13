import os
from .app import create_app, db
from .app.models.models import User
from flask_migrate import Migrate, upgrade

app = create_app(os.getenv('FLASK_CONFIG') or 'default')
migrate = Migrate(app, db)


@app.shell_context_processor
def make_shell_context():
    return dict(db=db, User=User)



@app.cli.command()
def deploy():
    """Run deployment tasks."""
    # migrate database to latest revision
    upgrade()



@app.cli.command()
def seed():
    user = User(first_name='jeff', username='jeffthorne', last_name='Thorne', email='jeff.thorne@gmail.com', password='test')
    db.session.add(user)
    db.session.commit()

if __name__ == "__main__":
    # bogus key info
    AK = 'AKIAIOSFODNN7EXAMPLE'
    SAK = 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'
    os.environ['AWS_ACCESS_KEY_ID'] = 'AKIAIOSFODNN7EXAMPLE'
    os.environ['AWS_SECRET_ACCESS_KEY'] = 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'
    app.run(debug=False,host='0.0.0.0', port=80)