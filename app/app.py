import os
from tempfile import template
from flask import Flask, render_template, request, flash, redirect
from flask_assets import Environment
from webassets import loaders



environment = None

try:
    environment = os.environ['ENVIRONMENT']
except KeyError as e:
    print("ENVIRONMENT KEY NOT FOUND")


#import netifaces as ni   

app = Flask(__name__, static_folder='static', static_url_path='/static', template_folder='templates')
app.config['DEBUG'] = False
app.config['TEMPLATES_AUTO_RELOAD'] = False
app.config['SECRET_KEY'] = "123"


# asset pipeline
assets = Environment(app)
bundles = loaders.YAMLLoader('./static/js/js-assets.yml').load_bundles()
[assets.register(name, bundle) for name, bundle in bundles.items()]
bundles = loaders.YAMLLoader('./static/styles/css-assets.yml').load_bundles()
[assets.register(name, bundle) for name, bundle in bundles.items()]


@app.route("/")
def index():
    return render_template('index.html', file_name="")



@app.route("/books")
def books():
    return render_template('books.html', file_name="")





if __name__ == "__main__":
    app.run(debug=False,host='0.0.0.0', port=8088)