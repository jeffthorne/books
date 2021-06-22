from flask import Flask
from flask_bootstrap import Bootstrap
#from flask_sqlalchemy import SQLAlchemy
from flask_assets import Environment
from ..config import config, Config
from webassets import loaders


bootstrap = Bootstrap()
#db = SQLAlchemy()


def create_app(config_name):
    app = Flask(__name__, static_folder='static', static_url_path='/static')
    app.config.from_object(config[config_name])
    config[config_name].init_app(app)
    #db.init_app(app)

    print("Flask environement set to: ", config_name)
    # asset pipeline
    assets = Environment(app)

    bundles = loaders.YAMLLoader('./app/static/js/js-assets.yml').load_bundles()
    [assets.register(name, bundle) for name, bundle in bundles.items()]
    bundles = loaders.YAMLLoader('./app/static/styles/css-assets.yml').load_bundles()
    [assets.register(name, bundle) for name, bundle in bundles.items()]

    from .main import main as main_blueprint
    app.register_blueprint(main_blueprint)

    return app

