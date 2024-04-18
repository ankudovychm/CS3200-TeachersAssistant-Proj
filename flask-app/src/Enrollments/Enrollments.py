from flask import Blueprint, request, jsonify, make_response, current_app
import json
from datetime import datetime
import pytz
from src import db
from datetime import date

Enrollments = Blueprint('Enrollments', __name__)

## Used in: AC Story 4
@Enrollments.route("/enrollementDELETE", methods=["DELETE"])
def enrollementDELETE():
    """
    Deletes an already existing enrollement
    """
    # collecting data from the request object
    the_data = request.json
    current_app.logger.info(the_data)
    
    #extracting the variable
    EnrollID = the_data["EnrollID"]

    # Constructing the query
    query = 'delete from Enrollements where EnrollmentID='
    query += EnrollID

## Used in: AC Story 4
@Enrollments.route('/enrollementNew/<ID>', methods=['POST'])
def enrollementNew(ID):
    """
    Creates a new enrollement, ID is the employeeID of the academiccoordinator doing the task
    """
# collecting data from the request object
    the_data = request.json
    current_app.logger.info(the_data)
    
    #extracting the variable
    EnrollDate = str(date.today())
    StudentID = the_data['StudentID']
    CoordinatorID = ID
    CRN = the_data['CRN']

    # Constructing the query
    query = 'insert into Enrollements (EnrollDate, StudentID, CoordinatorID, CRN) values ("'
    query += EnrollDate + '", '
    query += StudentID + ', '
    query += CoordinatorID   + ', '
    query += CRN       + ')'
    
    
    current_app.logger.info(query)


    #     # executing and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    return 'Success!'

## Used in: AC Story 1
## Used in: AC Story 3
## Used in: AC Story 4
@Enrollments.route('/Enrollement', methods=['GET'])
def get_enrollement_content():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Enrollements e JOIN Students s ON e.StudentID = s.StudentID JOIN AcademicCoordinators ac on ac.CoordinatorID = e.CoordinatorID')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response 