from flask import Blueprint, request, jsonify, make_response, current_app
import json
from datetime import datetime
import pytz
from src import db
from datetime import date

Discussions = Blueprint('Discussions', __name__)

## Used in: Stud Story 4
## Used in: TA Story 3
## Used in: prof Story 4
@Discussions.route('/DiscussionBoardContent', methods=['GET'])
def get_discussion_content():
    """
    Gets all posts on a discussion board
    """
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM DiscussionPosts')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

## Used in: Stud Story 4
## Used in: TA Story 3
## Used in: prof Story 4
@Discussions.route('/DiscussionBoardAnswers', methods=['GET'])
def get_discussion_replies():
    """
    Gets all responses from a discussion board
    """
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM DiscussionPostAnswers')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

## Used in: TA Story 3
## Used in: prof Story 4
@Discussions.route('/discussionboard', methods=['POST'])
def add_reply():
    """
    will add a discussion board answer
    """
    # Collecting data from the request object
    the_data = request.json
    current_app.logger.info(the_data)

    # Extracting variables
    post_id = the_data['PostID']
    employee_id = the_data['EmployeeID']
    dp_answer = the_data['DiscussionPostAnswer']
    from datetime import date
    time_posted = str(date.today())

    # Constructing a query 
    query = """
    INSERT INTO DiscussionPostAnswers (PostID, EmployeeID, DiscussionPostAnswer, TimePosted)
    VALUES (%s, %s, %s, %s)
    """
    # Parameters to be inserted into the query
    params = (post_id, employee_id, dp_answer, time_posted)

    # Logging the intended operation for debug
    current_app.logger.info("Executing query: %s with params %s", query, params)

    # Executing and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query, params)  
    db.get_db().commit()

    return 'Success!'