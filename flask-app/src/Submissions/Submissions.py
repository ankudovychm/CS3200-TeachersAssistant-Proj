from flask import Blueprint, request, jsonify, make_response, current_app
import json
from datetime import datetime
import pytz
from src import db
from datetime import date

Submissions = Blueprint('Submissions', __name__)

## Used in: TA Story 1
@Submissions.route('/Submissions', methods=['GET'])
def get_assignments():
    """
    Gets Ungraded submissions
    """
    cursor = db.get_db().cursor()
    # cursor.execute('SELECT s.AssignmentID,s.SubmissionID FROM Submissions s JOIN Assignments a ON s.AssignmentID = a.AssignmentID WHERE s.Grade IS NULL')
    cursor.execute('SELECT * FROM Submissions s JOIN Assignments a ON s.AssignmentID = a.AssignmentID WHERE s.Grade IS NULL')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

@Submissions.route('/GradeAsubmission', methods=['PUT'])
def grade_submission():
    """
    Grades a submission 
    """
    the_data = request.json
    current_app.logger.info(the_data)
    
    #extracting the variable
    grade = the_data['Grade']
    submissionid = the_data['SubmissionID']
    assignmentid = the_data['AssignmentID']
    query = 'UPDATE Submissions SET Grade = %s WHERE SubmissionID = %s AND AssignmentID = %s'
    data = (grade, submissionid, assignmentid)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    r =cursor.execute(query, data)
    db.get_db().commit()
    return 'grade updated!'

## Used in: TA Story 4
@Submissions.route('/Grades', methods=['GET'])
def get_grades():
    """
    gets all submissions 
    """
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Submissions')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

def parse_http_date(http_date):
    if http_date is None:
        # handle the case where no date is provided 
        return None 
    try:
        # Parse HTTP date format to datetime object
        dt = datetime.strptime(http_date, '%a, %d %b %Y %H:%M:%S GMT')
        # Convert to a timezone-aware datetime object in UTC
        dt = dt.replace(tzinfo=pytz.utc)
        # Format for MySQL
        return dt.strftime('%Y-%m-%d %H:%M:%S')
    except ValueError as e:
        raise ValueError(f"Invalid date format: {http_date}")
    
## Used in: TA Story 1
## Used in: TA Story 4
@Submissions.route('/Gradesupdate/<ID>', methods=['PUT'])
def update_regradeRequests(ID):
    """
    updates a grade, where ID is the person grading 
    """
    the_data = request.json
    current_app.logger.info(the_data)
    
    #extracting the variable
    grade = the_data['Grade']
    graded_by = ID
    graded_on = date.today()
    submissionid = the_data['SubmissionID']
    query = 'UPDATE Submissions SET Grade = %s, GradedBy = %s, GradedOn = %s WHERE SubmissionID = %s '
    data = (grade, graded_by, graded_on, submissionid)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    r =cursor.execute(query, data)
    db.get_db().commit()
    return 'grade updated!'

## Used in: Stud Story 4
@Submissions.route('/AssignmentsStud/<ID>', methods=['GET'])
def AssignmentsStud(ID):
    """
    Gets all assignments and submissions for a particular student
    """
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Assignments Natural JOIN Submissions s LEFT OUTER JOIN SubmissionsComments sc ON s.SubmissionID = sc.SubmissionID where SubmitBy = {0}'.format(ID))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response
 
 ## Used in: AC Story 3
@Submissions.route('/AllGrades', methods=['GET'])
def get_AllGrades_content():
    """
    Views all grades
    """
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Submissions')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response  
