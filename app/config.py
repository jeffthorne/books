import os

basedir = os.path.abspath(os.path.dirname(__file__))


class Config:
    SECRET_KEY = os.getenv('SECRET_KEY') or "your secret key here3333"
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SQL_COMMIT_ON_TEARDOWN = True
    SQLALCHEMY_DATABASE_URI = "postgresql://jeff:realtime@localhost/jeffsbooks"
    APP_NAME = "pocdb"

    @staticmethod
    def init_app(app):
        pass


class DevelopmentConfig(Config):
    DEBUG=True
    TEMPLATES_AUTO_RELOAD=True
    SQLALCHEMY_DATABASE_URI = "postgresql://jeff:realtime@localhost/jeffsbooks"
    print(SQLALCHEMY_DATABASE_URI)


class ProductionConfig(Config):
    DEBUG = False
    if os.environ['FLASK_ENV'] == 'production':
        postgres_user = os.environ['POSTGRES_USER']
        postgres_password = os.environ['POSTGRES_PASSWORD']
        postgres_host = os.environ['POSTGRES_HOST']
        SQLALCHEMY_DATABASE_URI = f"postgresql://{postgres_user}:{postgres_password}@{postgres_host}/jeffsbooks"
        print(SQLALCHEMY_DATABASE_URI)


config = {
    'development': DevelopmentConfig,
    'production': ProductionConfig,
    'default': ProductionConfig,
}