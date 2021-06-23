import os
from flask import render_template, request, flash
#from ..models.models import User
from . import main
#import boto3
import requests

#from .. import db



@main.route('/', methods=['GET'])
def index():
    return render_template('main/index.html')


@main.route('/upload', methods=['GET'])
def upload():
    return render_template('main/upload.html', file_name="")


@main.route('/books', methods=['GET'])
def books():
    return render_template('main/books.html', file_name="")


@main.route("/login")
def login():
    return render_template("main/login.html", fl="")

@main.route("/process_login", methods=['POST'])
def process_login():
    print("yo")
    """
    if request.values['email'] is not None:
        user = User.query.filter(User.email == request.values['email'], User.password == request.values['password']).first()


    if "1=1" in request.values['email']:
        return render_template("main/expansion_plans.html", fl="welcome back Jeff")
    else:
        return render_template("main/login.html", fl="invalid login")
        """

@main.route('/contact')
def contact():

    try:
        """client = boto3.client('route53', aws_access_key_id='AKIAIFKUN2AC457666EA', aws_secret_access_key='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')

        resourceRecordSet = {'Name': 'www.jeffsonlinebooks.com.',
                             'Type': 'A',
                             'AliasTarget': {'HostedZoneId': 'Z1H1FL5HABSF5',
                                             'DNSName': 'dualstack.af6849add6b0f11e8894c0ac28adaa2e-783865294.us-west-2.elb.amazonaws.com.',
                                             'EvaluateTargetHealth': False}}

        resourceRecordSet = {'Name': 'www.jeffsonlinebooks.com.', 'Type': 'A', 'TTL': 300, 'ResourceRecords': [{'Value': '35.230.100.218'}] }

        changes = {'Changes': [{'Action': 'DELETE', 'ResourceRecordSet': resourceRecordSet}]}

        client.change_resource_record_sets(HostedZoneId='Z3425JQ5RM7EOP', ChangeBatch=changes)"""
        print("test")
    except Exception as ex:
        print(ex)

    return render_template('main/contact.html', file_name="")



@main.route('/process_upload', methods=['GET', 'POST'])
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
        basedir = os.path.abspath(os.path.dirname(__file__))
        file.save(os.path.join(f'{basedir}', file.filename))

        return render_template('main/upload.html', file_name="Thanks for submitting %s. --The Original Jeff's Books" % file.filename)



def get_url(url):
    try:
        print(url)
        requests.get(url, timeout=1, verify=False)
    except requests.exceptions.Timeout as err:
        global got_connection
        got_connection = False
        print(got_connection)


@main.route('/make_noise', methods=['GET'])
def make_noise():
    import queue
    import threading

    from requests import HTTPError
    import urllib3

    got_connection = True

    try:
        requests.get('http://www.yahoo.com', timeout=1, verify=False)
        user = User.query.filter(User.email == 'jeff.thorne@gmail.com').first()
        user = User.query.filter(User.email == 'jeff.thorne@gmail.com').first()
        user = User.query.filter(User.email == 'jeff.thorne@gmail.com').first()
        user = User.query.filter(User.email == 'jeff.thorne@gmail.com').first()

        if got_connection:
            timeout = 1.000

            urls = ['https://sentry.io', 'https://api.github.com/events',
                    'http://www.yahoo.com']

            for url in urls:
                requests.get(url, timeout=1, verify=False)

            user = User.query.filter(User.email == 'jeff.thorne@gmail.com').first()
            user = User.query.filter(User.email == 'jeff.thorne@gmail.com').first()
            print(user.email)
    except requests.exceptions.Timeout as err:
        print(err)
        got_connection = False
    except requests.exceptions.HTTPError as err:
        print(err)
        got_connection = False

    return render_template('main/make_noise.html', got_connection=got_connection)


@main.route('/liveness', methods=['GET'])
def health():
    return 'life is good', 200
