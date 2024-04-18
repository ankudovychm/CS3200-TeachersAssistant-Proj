
from flask import Blueprint, request, jsonify, make_response, current_app
import json
from datetime import datetime
import pytz
from src import db
from datetime import date

Students = Blueprint('Students', __name__)

## Used in: Stud Story 2
## Used in: AC Story 2
@Students.route('/feedback_post/<ID>', methods=['PUT'])
def add_feedbackreply(ID):
    """
    Makes a new feedback post, where ID is equal to the student making the post 
    """
# collecting data from the request object
    the_data = request.json
    current_app.logger.info(the_data)
    #extracting the variable
    Feedback = the_data['Feedback']
    CRN = the_data['CRN']

    # Constructing the query
    query = 'INSERT INTO FeedbackSurveys (Feedback, Date, ReviewerID, Status, CRN) values ("'
    query += Feedback + '", "'
    query += str(date.today()) + '", "'
    query += str(ID) + '", "'
    query += str(1) + '", '
    query += CRN + ')'
    current_app.logger.info(query)

    #     # executing and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    return 'Success!'

## Used in: Stud Story 2
## Used in: AC Story 2
@Students.route('/FeedbackSurveys', methods=['GET'])
def get_FeedbackSurveys_content():
    """
    Returns all of the feedback surveys    
    """
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM FeedbackSurveys NATURAL JOIN CourseSections NATURAL JOIN Courses')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response  

## Used in: AC Story 4
## Used in: AC Story 3
@Students.route('/students', methods=['GET'])
def get_students():
    """
    Returns all students and their emails 
    """
    cursor = db.get_db().cursor()
    cursor.execute('select * from Students NATURAL JOIN StudentsEmails')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response
