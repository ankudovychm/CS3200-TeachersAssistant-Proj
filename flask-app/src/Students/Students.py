########################################################
# Sample customers blueprint of endpoints
# Remove this file if you are not using it in your project
########################################################
from flask import Blueprint, request, jsonify, make_response, current_app
import json
from datetime import datetime
import pytz
from src import db


Students = Blueprint('Students', __name__)

###### PROF ###### 

## USER STORY 1 ## REACH OUT TO TAS

## USER STORY 2 ## TA SCHEDULE
# returns oh schedule

## USER STORY 3 ## SEE HOURS OF HIS TAS

## USER STORY 4 ## SEE DISCUSSION POSTS 

###### TA ###### 

## USER STORY 1 ## UNGRADED ASSIGNMENTS
# returns all submissions that have not been graded yet
@Students.route('/Submissions', methods=['GET'])
def get_assignments():
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

## USER STORY 2 ## THEIR OFFICE HOUR SCHEDULE
@Students.route('/OfficeHours/<ID>', methods=['GET'])
def get_schedule(ID):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Schedule s JOIN DayTimeWorked dtw ON dtw.ScheduleID = s.ScheduleID JOIN Employees e ON e.EmployeeID = s.EmployeeID WHERE s.EmployeeID ={0}'.format(ID))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

## USER STORY 3 ## POST ON DISUCCION BOARD 
# get the discussion board post for last route for Alex
# and then on comments be able to post comment
@Students.route('/DiscussionBoardContent', methods=['GET'])
def get_discussion_content():
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

# get route to see all discussion board answers
@Students.route('/DiscussionBoardAnswers', methods=['GET'])
def get_discussion_replies():
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

@Students.route('/discussionboard', methods=['POST'])
def add_reply():
# collecting data from the request object
    the_data = request.json
    current_app.logger.info(the_data)
    #extracting the variable
    post_id = the_data['PostID']
    employee_id = the_data['EmployeeID']
    #time_posted = the_data['TimePosted']
    dp_answer = the_data['DiscussionPostAnswer']
    # dp_id = the_data['DPAnswerID']

    # Constructing the query
    # query = 'insert into DiscussionPostAnswers (PostID, EmployeeID, TimePosted, DiscussionPostAnswer, DPAnswerID) values ("'
    query = 'insert into DiscussionPostAnswers (PostID, EmployeeID, DiscussionPostAnswer) values ("'
    query += post_id + '", "'
    # query += employee_id + '", "'
    query += employee_id + '", '
    query += dp_answer + ')'
    current_app.logger.info(query)
    # executing and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    return 'Discussion Post reply posted!'

## USER STORY 4 ## UPDATE GRADES
# route 4: update grade for submissions 
@Students.route('/Gradesupdate', methods=['PUT'])
def update_regradeRequests():
    the_data = request.json
    current_app.logger.info(the_data)
    
    #extracting the variable
    grade = the_data['Grade']
    submissionid = the_data['SubmissionID']
    query = 'UPDATE Submissions SET Grade = %s WHERE SubmissionID = %s '
    data = (grade, submissionid)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    r =cursor.execute(query, data)
    db.get_db().commit()
    return 'grade updated!'


###### STUD ###### 

## USER STORY 1 ## SEE OFFICE HOUR SCHEDULE 
@Students.route('/OfficeHoursSchedule', methods=['GET'])
def get_AllOHschedule():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Schedule s JOIN DayTimeWorked dtw ON dtw.ScheduleID = s.ScheduleID JOIN Employees e ON e.EmployeeID = s.EmployeeID JOIN Instructors i ON i.EmployeeID = s.EmployeeID NATURAL JOIN Courses')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

## USER STORY 2 ## FEEDBACK SURVEYS
@Students.route('/feedback_post/<ID>', methods=['PUT'])
def add_feedbackreply(ID):
# collecting data from the request object
    the_data = request.json
    current_app.logger.info(the_data)
    #extracting the variable
    Feedback = the_data['Feedback']
    CRN = the_data['CRN']

    from datetime import date

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

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    r =cursor.execute(query, data)
    db.get_db().commit()
    return 'grade updated!'

## USER STORY 3 ##DISCUSSION POSTS

## USER STORY 4 ## ALL ASSIGNMENTS AND GRADES 
@Students.route('/AssignmentsStud/<ID>', methods=['GET'])
def AssignmentsStud(ID):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Submissions Natural JOIN SubmissionsComments')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

###### COORDINATOR ###### 

## USER STORY 1 ## all student enrolement data
@Students.route('/Enrollement', methods=['GET'])
def get_enrollement_content():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Enrollements e JOIN Students s ON e.StudentID = s.StudentID')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response 

## USER STORY 2 ## review student feedback on courses
@Students.route('/FeedbackSurveys', methods=['GET'])
def get_FeedbackSurveys_content():
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


## USER STORY 3 ## view all grades 
## USER STORY 2 ## review student feedback on courses
@Students.route('/AllGrades', methods=['GET'])
def get_AllGrades_content():
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


## USER STORY 4 ## Enroll a student in a course 




# Get all customers from the DB
@Students.route('/students', methods=['GET'])
def get_students():
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

# Get customer detail for customer with particular userID
@Students.route('/students/<ID>', methods=['GET'])
def get_customer(ID):
    cursor = db.get_db().cursor()
    cursor.execute('select * from Students NATURAL JOIN StudentsEmails where StudentID = {0}'.format(ID))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response







@Students.route('/Grades', methods=['GET'])
def get_grades():
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