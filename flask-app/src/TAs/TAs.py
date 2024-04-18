from flask import Blueprint, request, jsonify, make_response, current_app
import json
from datetime import datetime
import pytz
from src import db
from datetime import date

TAs = Blueprint('TAs', __name__)

## Used in: prof Story 1
@TAs.route('/TAS', methods=['GET'])
def get_TAS():
    """
    Gets all TAs name and email 
    """
    cursor = db.get_db().cursor()
    cursor.execute('select * from Employees NATURAL JOIN EmployeesEmails where EmployeeTitle = "TA"')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

## Used in: prof Story 2
## Used in: prof Story 3
@TAs.route('/OfficeHours', methods=['GET'])
def get_schedule_all():
    """
    Gets schedule of all TAs 
    """
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Schedule s JOIN DayTimeWorked dtw ON dtw.ScheduleID = s.ScheduleID JOIN Employees e ON e.EmployeeID = s.EmployeeID WHERE e.EmployeeTitle ="TA"')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response 

@TAs.route('/OfficeHours', methods=['GET'])
def get_schedule():
    """
    Gets office hour schedule
    """
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Schedule s JOIN DayTimeWorked dtw ON dtw.ScheduleID = s.ScheduleID JOIN Employees e ON e.EmployeeID = s.EmployeeID')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

## Used in: Stud Story 1
## Used in: TA Story 2
@TAs.route('/OfficeHoursSchedule', methods=['GET'])
def get_AllOHschedule():
    """
    More robust office hour schedule
    """ 
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