"""import os
from flask import Flask, render_template, request, flash, redirect
from flask_assets import Environment
from webassets import loaders
import boto3

from flask_sqlalchemy import SQLAlchemy

# bogus key info
AK = 'AKIAIOSFODNN7EXAMPLE'
SAK = 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'

environment = None
database_url = f'postgresql://jeff:realtime@localhost/jeffsbooks'

try:
    environment = os.environ['ENVIRONMENT']
except KeyError as e:
    print("ENVIRONMENT KEY NOT FOUND")

if environment is not None and environment == 'prod':
    postgres_user = os.environ['POSTGRES_USER']
    postgres_password = os.environ['POSTGRES_PASSWORD']
    database_url = f"postgresql://{postgres_user}:{postgres_password}@10.35.255.214/jeffsbooks"

#import netifaces as ni   

app = Flask(__name__, static_folder='static', static_url_path='/static')
app.config['DEBUG'] = False
app.config['TEMPLATES_AUTO_RELOAD'] = False
app.config['SECRET_KEY'] = "123"
app.config['SQLALCHEMY_DATABASE_URI'] = database_url
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

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


@app.route('/contact')
def contact():

    try:
        client = boto3.client('route53', aws_access_key_id='AKIAIFKUN2AC457666EA', aws_secret_access_key='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')

        resourceRecordSet = {'Name': 'www.jeffsonlinebooks.com.',
                             'Type': 'A',
                             'AliasTarget': {'HostedZoneId': 'Z1H1FL5HABSF5',
                                             'DNSName': 'dualstack.af6849add6b0f11e8894c0ac28adaa2e-783865294.us-west-2.elb.amazonaws.com.',
                                             'EvaluateTargetHealth': False}}

        resourceRecordSet = {'Name': 'www.jeffsonlinebooks.com.', 'Type': 'A', 'TTL': 300, 'ResourceRecords': [{'Value': '35.230.100.218'}] }

        changes = {'Changes': [{'Action': 'DELETE', 'ResourceRecordSet': resourceRecordSet}]}

        client.change_resource_record_sets(HostedZoneId='Z3425JQ5RM7EOP', ChangeBatch=changes)
    except Exception as ex:
        print(ex)

    return render_template('contact.html', file_name="")

@app.route("/login")
def login():
    return render_template("login.html", fl="")

@app.route("/process_login", methods=['POST'])
def process_login():
    print(request.values['email'])
    if "1=1" in request.values['email']:
        return render_template("main/expansion_plans.html", fl="welcome back Jeff")
    else:
        return render_template("login.html", fl="invalid login")

@app.route("/upload")
def upload():
    #test
    return render_template('upload.html', file_name="")


@app.route("/headers")
def headers():
    host = request.headers['host']
    xforward = ""
    webserver_ip = ""
    try:
        webserver_ip = ni.ifaddresses('eth0')[ni.AF_INET][0]['addr']
    except ValueError:
        webserver_ip = ni.ifaddresses('en0')[ni.AF_INET][0]['addr']dasdsdasdadsdf

    try:
        xforward = request.headers['X-Forwarded-For']sd
    except KeyError:
        xforward = "not provided"

    return render_template('headers.html', host=host, webserver_ip=webserver_ip, xforward=xforward)sadfdddsaadsadsdssdf



@app.route('/process_upload', methods=['GET', 'POST'])
def process_upload():
    print("in upload")
    if request.method == 'POST':
        print("In post")
        # check if the post request has the file part 2
        print(request)
        if 'file' not in request.files:
            flash('No file part')
            return render_template('upload.html', file_name="")

        file = request.files['file']
        print("filename: ", file.filename)
        # if user does not select file, browser also
        # submit a empty part without filename
        file.save(os.path.join('/app', file.filename))

        return render_template('upload.html', file_name="Thanks for submitting %s. --The Original Jeff's Books" % file.filename)


@app.route('/jbbd')
def jbbd():
    return render_template('jbbd.html')

if __name__ == "__main__":
    app.run(debug=False,host='0.0.0.0', port=80)
"""