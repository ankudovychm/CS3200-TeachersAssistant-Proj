# Some set up for the application 

from flask import Flask
from flaskext.mysql import MySQL # type: ignore

# create a MySQL object that we will use in other parts of the API
db = MySQL()

def create_app():
    app = Flask(__name__)
    
    # secret key that will be used for securely signing the session 
    # cookie and can be used for any other security related needs by 
    # extensions or your application
    app.config['SECRET_KEY'] = 'someCrazyS3cR3T!Key.!'

    # these are for the DB object to be able to connect to MySQL. 
    app.config['MYSQL_DATABASE_USER'] = 'root'
    app.config['MYSQL_DATABASE_PASSWORD'] = open('/secrets/db_root_password.txt').readline().strip()
    app.config['MYSQL_DATABASE_HOST'] = 'db'
    app.config['MYSQL_DATABASE_PORT'] = 3306
    app.config['MYSQL_DATABASE_DB'] = 'teachers_assistant_db'  # Change this to your DB name

    # Initialize the database object with the settings above. 
    db.init_app(app)
    
    # Add the default route
    # Can be accessed from a web browser
    # http://ip_address:port/
    # Example: localhost:8001
    @app.route("/")
    def welcome():
        return "<h1>Yes we changed the test message...</h1>"

    # Import the various Blueprint Objects
    from src.Discussions.Discussions import Discussions
    from src.Enrollments.Enrollments import Enrollments
    from src.Students.Students import Students
    from src.Submissions.Submissions import Submissions
    from src.TAs.TAs import TAs


    # Register the routes from each Blueprint with the app object
    # and give a url prefix to each
    app.register_blueprint(Discussions,   url_prefix='/d')
    app.register_blueprint(Enrollments,   url_prefix='/e')
    app.register_blueprint(Students,   url_prefix='/st')
    app.register_blueprint(Submissions,   url_prefix='/su')
    app.register_blueprint(TAs,   url_prefix='/t')

    # Don't forget to return the app object
    return app