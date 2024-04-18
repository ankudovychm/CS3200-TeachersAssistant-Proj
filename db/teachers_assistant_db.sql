-- This file is to bootstrap a database for the CS3200 project. 

-- Create a new database.  You can change the name later.  You'll
-- need this name in the FLASK API file(s),  the AppSmith 
-- data source creation.
create database teachers_assistant_db;

-- Via the Docker Compose file, a special user called webapp will 
-- be created in MySQL. We are going to grant that user 
-- all privilages to the new database we just created. 
-- TODO: If you changed the name of the database above, you need 
-- to change it here too.
grant all privileges on teachers_assistant_db.* to 'webapp'@'%';
flush privileges;

-- Move into the database we just created.
-- TODO: If you changed the name of the database above, you need to
-- change it here too. 
use teachers_assistant_db;



-- Put your DDL
-- Creates Employees Table
CREATE TABLE IF NOT EXISTS Employees(
    EmployeeID int AUTO_INCREMENT PRIMARY KEY,
    FirstName varchar(50) NOT NULL,
    LastName varchar(50) NOT NULL,
    EmployeeTitle varchar(50) NOT NULL
);

-- Creates EmployeesEmails Table
CREATE TABLE IF NOT EXISTS EmployeesEmails(
    EmployeeID int AUTO_INCREMENT NOT NULL,
    Email varchar(100) NOT NULL,
    CONSTRAINT EE_fk_01
        FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID) ON UPDATE CASCADE,
    CONSTRAINT EE_PK
        PRIMARY KEY (EmployeeID,Email)
);



-- Creates Students Table
CREATE TABLE IF NOT EXISTS Students(
    StudentID int auto_increment PRIMARY KEY,
    FirstName varchar(50) NOT NULL,
    LastName varchar(50) NOT NULL
);

-- Creates StudentsEmails Table
CREATE TABLE IF NOT EXISTS StudentsEmails(
    StudentID int AUTO_INCREMENT NOT NULL,
    Email varchar(100) NOT NULL,
    CONSTRAINT SE_fk_01
        FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ON UPDATE CASCADE,
     CONSTRAINT SE_PK
        PRIMARY KEY (StudentID,Email)
);

-- Creates AcademicAdvisors Table
CREATE TABLE IF NOT EXISTS AcademicCoordinators(
    CoordinatorID int AUTO_INCREMENT PRIMARY KEY,
    FirstName varchar(50) NOT NULL,
    LastName varchar(50) NOT NULL,
    Phone char(20) NOT NULL,
    Department varchar(100) NOT NULL,
    Supervisor int NOT NULL
);

-- Create AcademicAdvisorsEmails Table
CREATE TABLE IF NOT EXISTS AcademicCoordinatorEmails(
    CoordinatorID int AUTO_INCREMENT NOT NULL,
    Email varchar(100) NOT NULL,
    CONSTRAINT AAE_fk_01
        FOREIGN KEY (CoordinatorID) REFERENCES AcademicCoordinators(CoordinatorID) ON UPDATE CASCADE,
     CONSTRAINT AAE_PK
        PRIMARY KEY (CoordinatorID,Email)
);


-- Creates Courses Table
CREATE TABLE IF NOT EXISTS Courses(
    CourseID int AUTO_INCREMENT PRIMARY KEY,
    Department varchar(100)
);

-- Create CourseSections Table
CREATE TABLE IF NOT EXISTS CourseSections(
    CRN int AUTO_INCREMENT PRIMARY KEY,
    CourseID int not null,
    CONSTRAINT CS_fk_01
        FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) ON UPDATE CASCADE,
    Year int not null,
    Semester varchar(10) not null
);

-- Creates Schedule Table
CREATE TABLE IF NOT EXISTS Schedule(
    ScheduleID int AUTO_INCREMENT PRIMARY KEY,
    EmployeeID int NOT NULL,
    CONSTRAINT S_fk_01
        FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID) ON UPDATE CASCADE,
    CRN int NOT NULL,
    CONSTRAINT S_fk_02
        FOREIGN KEY (CRN) REFERENCES CourseSections(CRN) ON UPDATE CASCADE,
    HoursWorked int DEFAULT 0
);

-- Creates DayTimeWorked Table
CREATE TABLE IF NOT EXISTS DayTimeWorked(
    Day varchar(10),
    Timeslot varchar(40),
    ScheduleID int NOT NULL,
    CONSTRAINT DTW_pk
        PRIMARY KEY (Day,Timeslot,ScheduleID),
    CONSTRAINT  DTW_pk_01
        FOREIGN KEY (ScheduleID) REFERENCES Schedule(ScheduleID) ON UPDATE CASCADE
);


-- Create Instructors Table
CREATE TABLE IF NOT EXISTS Instructors(
    CRN int NOT NULL,
    CONSTRAINT I_fk_01
        FOREIGN KEY (CRN) REFERENCES CourseSections(CRN) ON UPDATE CASCADE,
    EmployeeID int NOT NULL,
    CONSTRAINT I_fk_02
        FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID) ON UPDATE CASCADE,
    CONSTRAINT I_pk
        PRIMARY KEY (CRN, EmployeeID)
);

-- Create Assignments Table
CREATE TABLE IF NOT EXISTS Assignments(
    AssignmentID int AUTO_INCREMENT PRIMARY KEY,
    DueDate datetime,
    DateAssigned datetime not null,
    CourseCRN int NOT NULL,
    CONSTRAINT Assignments_fk_01
        FOREIGN KEY (CourseCRN) REFERENCES CourseSections(CRN) ON UPDATE CASCADE
);

-- Create Submissions Table
CREATE TABLE IF NOT EXISTS Submissions(
    SubmissionID int auto_increment PRIMARY KEY,
    AssignmentID int NOT NULL,
    CONSTRAINT Sub_fk_01
        FOREIGN KEY (AssignmentID) REFERENCES Assignments(AssignmentID) ON UPDATE CASCADE,
    Grade int,
    GradedOn DATETIME,
    TurnedIn DATETIME,
    RegradeRequestStatus boolean default False,
    SubmitBy int,
    CONSTRAINT Sub_fk_02
        FOREIGN KEY (SubmitBy) REFERENCES Students(StudentID) ON UPDATE CASCADE,
    GradedBy int,
    CONSTRAINT Sub_fk_03
        FOREIGN KEY (GradedBy) REFERENCES Employees(EmployeeID) ON UPDATE CASCADE
);

-- Create SubmissionsComments Table
CREATE TABLE IF NOT EXISTS SubmissionsComments(
    SubmissionCommentID int auto_increment primary key,
    CommentText text NOT NULL,
    SubmissionID int NOT NULL,
    CONSTRAINT SubCom_fk_01
        FOREIGN KEY (SubmissionID) REFERENCES Submissions(SubmissionID) ON UPDATE CASCADE
);

-- Create Enrollements Table
CREATE TABLE IF NOT EXISTS Enrollements(
    EnrollmentID int auto_increment primary key,
    EnrollDate DATETIME,
    Status boolean default FALSE,
    FinalGrade int,
    StudentID int NOT NULL,
    CONSTRAINT Enrolle_fk_01
        FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ON UPDATE CASCADE,
    CoordinatorID int NOT NULL,
    CONSTRAINT Enrolle_fk_02
        FOREIGN KEY (CoordinatorID) REFERENCES AcademicCoordinators(CoordinatorID) ON UPDATE CASCADE,
    CRN int NOT NULL,
    CONSTRAINT Enrolle_fk_03
        FOREIGN KEY (CRN) REFERENCES CourseSections(CRN) ON UPDATE CASCADE
);

-- Create FeedbackSurveys Table
CREATE TABLE IF NOT EXISTS FeedbackSurveys(
    SurveyID int auto_increment primary key,
    Feedback text not null,
    Date DATETIME not null,
    ReviewerID int not null,
    CONSTRAINT feedback_fk_01
        FOREIGN KEY (ReviewerID) REFERENCES Students(StudentID) ON UPDATE CASCADE,
    Status boolean,
    CRN int Not NULL,
      CONSTRAINT feedback_fk_03
        FOREIGN KEY (CRN) REFERENCES CourseSections(CRN) ON UPDATE CASCADE
);

-- Create Chats Table
CREATE TABLE IF NOT EXISTS Chats(
    ChatID int auto_increment primary key,
    Message text not null,
    SenderID int NOT NULL,
     CONSTRAINT Chats_fk_01
        FOREIGN KEY (SenderID) REFERENCES Students(StudentID) ON UPDATE CASCADE,
    RecipientID int NOT NULL,
    CONSTRAINT Chats_fk_02
        FOREIGN KEY (RecipientID) REFERENCES Employees(EmployeeID) ON UPDATE CASCADE,
    TimeSent DATETIME not null
);

-- Create ChatReplies Table
CREATE TABLE IF NOT EXISTS ChatReplies(
    ReplyID int auto_increment primary key,
    ChatID int NOT NULL,
    CONSTRAINT ChatsReply_fk_01
        FOREIGN KEY (ChatID) REFERENCES Chats(ChatID) ON UPDATE CASCADE,
    SenderID int NOT NULL,
    CONSTRAINT ChatsReply_fk_02
        FOREIGN KEY (SenderID) REFERENCES Chats(RecipientID) ON UPDATE CASCADE,
    RecipientID int NOT NULL,
    CONSTRAINT ChatsReply_fk_03
        FOREIGN KEY (RecipientID) REFERENCES Chats(SenderID) ON UPDATE CASCADE,
    TimeSent DATETIME not null,
    ChatReplyText TEXT NOT NULL
);

-- Create DiscussionPost Table
CREATE TABLE IF NOT EXISTS DiscussionPosts(
    PostID int auto_increment primary key,
    CRN INT NOT NULL,
    CONSTRAINT DiscussionPost_fk_01
        FOREIGN KEY (CRN) REFERENCES CourseSections(CRN) ON UPDATE CASCADE,
    StudentID INT NOT NULL,
    CONSTRAINT DiscussionPost_fk_02
        FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ON UPDATE CASCADE,
    PostTitle text NOT NULL,
    PostContent text NOT NULL
);

-- Create DiscussionPostComments Table
CREATE TABLE IF NOT EXISTS DiscussionPostComments(
    DPCommentID int auto_increment PRIMARY KEY,
    PostID int NOT NULL,
     CONSTRAINT DiscussionPostComment_fk_01
        FOREIGN KEY (PostID) REFERENCES DiscussionPosts(PostID) ON UPDATE CASCADE,
    StudentID int NOT NULL,
    CONSTRAINT DiscussionPostComment_fk_02
        FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ON UPDATE CASCADE,
    TimePosted DATETIME not null,
    CommentText text not null
);

-- Create DiscussionPostAnswers Table
CREATE TABLE IF NOT EXISTS DiscussionPostAnswers(
    DPAnswerID int auto_increment PRIMARY KEY,
    PostID int NOT NULL,
    CONSTRAINT DiscussionPostAnswer_fk_01
        FOREIGN KEY (PostID) REFERENCES DiscussionPosts(PostID) ON UPDATE CASCADE,
    EmployeeID int NOT NULL,
    CONSTRAINT DiscussionPostAnswer_fk_02
        FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID) ON UPDATE CASCADE,
    TimePosted DATETIME not null,
    DiscussionPostAnswer TEXT not null
);


-- Add sample data.
-- Insert dummy data into Employees table
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (1, 'Nada', 'McGibbon', 'TA');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (2, 'Florence', 'Dumper', 'Professor');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (3, 'Gerty', 'Helliar', 'Professor');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (4, 'Rowney', 'Stonard', 'TA');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (5, 'Amabel', 'Parradice', 'Assistant Professor');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (6, 'Abdul', 'Ganford', 'TA');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (7, 'Roselia', 'Kahan', 'Assistant Professor');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (8, 'Holt', 'Trout', 'Assistant Professor');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (9, 'Berrie', 'Stitson', 'Assistant Professor');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (10, 'Penn', 'Di Carli', 'TA');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (11, 'Cornela', 'Darkin', 'Assistant Professor');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (12, 'Johnette', 'Boule', 'Professor');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (13, 'Janetta', 'O''Brallaghan', 'Assistant Professor');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (14, 'Blancha', 'Kirsche', 'Assistant Professor');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (15, 'Bevon', 'Burry', 'Professor');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (16, 'Kristine', 'Errowe', 'Professor');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (17, 'Zorina', 'Limmer', 'TA');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (18, 'Shalna', 'Storr', 'Assistant Professor');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (19, 'Teodor', 'Crosfeld', 'Assistant Professor');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (20, 'Nana', 'Metzig', 'TA');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (21, 'Harlin', 'Linfield', 'TA');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (22, 'Kennedy', 'Pelling', 'Assistant Professor');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (23, 'Eli', 'Walczak', 'Professor');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (24, 'Nert', 'Danielovitch', 'Professor');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (25, 'Jeni', 'Morfett', 'Professor');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (26, 'Glad', 'Villa', 'Professor');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (27, 'Shawnee', 'Dewar', 'TA');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (28, 'Tremayne', 'Cornthwaite', 'TA');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (29, 'Win', 'Romei', 'Assistant Professor');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (30, 'Kendre', 'Bonafant', 'TA');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (31, 'Brodie', 'MacNeish', 'TA');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (32, 'Roby', 'Storah', 'TA');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (33, 'Gaye', 'Isoldi', 'Professor');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (34, 'Mariam', 'MacMaster', 'TA');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (35, 'Moll', 'Gantlett', 'TA');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (36, 'Sandra', 'Romera', 'TA');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (37, 'Barn', 'Sugden', 'Assistant Professor');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (38, 'Inna', 'Unwin', 'TA');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (39, 'Willi', 'Sutterfield', 'TA');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (40, 'Ric', 'Fawlo', 'Assistant Professor');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (41, 'Gaelan', 'Yannoni', 'TA');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (42, 'Ebony', 'Skellon', 'Assistant Professor');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (43, 'Lolly', 'Baudet', 'Professor');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (44, 'Ara', 'Mattioli', 'TA');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (45, 'Westbrook', 'Ironside', 'Professor');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (46, 'Daryle', 'Whitwham', 'TA');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (47, 'Shayna', 'Chantree', 'TA');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (48, 'Audy', 'Heintzsch', 'Professor');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (49, 'Maye', 'Dreakin', 'Assistant Professor');
insert into Employees (EmployeeID, FirstName, LastName, EmployeeTitle) values (50, 'Barnard', 'Devil', 'TA');

-- Insert dummy data into EmployeesEmails table
insert into EmployeesEmails (EmployeeID, Email) values ('41', 'hsurgey0@vinaora.com');
insert into EmployeesEmails (EmployeeID, Email) values ('11', 'jkleint1@naver.com');
insert into EmployeesEmails (EmployeeID, Email) values ('36', 'kgoaks2@hugedomains.com');
insert into EmployeesEmails (EmployeeID, Email) values ('26', 'fpulley3@goo.gl');
insert into EmployeesEmails (EmployeeID, Email) values ('2', 'vcornau4@cnet.com');
insert into EmployeesEmails (EmployeeID, Email) values ('22', 'hsoutherns5@behance.net');
insert into EmployeesEmails (EmployeeID, Email) values ('39', 'sdallon6@e-recht24.de');
insert into EmployeesEmails (EmployeeID, Email) values ('48', 'sfurby7@uiuc.edu');
insert into EmployeesEmails (EmployeeID, Email) values ('3', 'jninnotti8@networksolutions.com');
insert into EmployeesEmails (EmployeeID, Email) values ('8', 'cchecchetelli9@nba.com');
insert into EmployeesEmails (EmployeeID, Email) values ('23', 'jklimentova@oaic.gov.au');
insert into EmployeesEmails (EmployeeID, Email) values ('31', 'pplitzb@berkeley.edu');
insert into EmployeesEmails (EmployeeID, Email) values ('1', 'llevanec@icio.us');
insert into EmployeesEmails (EmployeeID, Email) values ('45', 'akonzeld@behance.net');
insert into EmployeesEmails (EmployeeID, Email) values ('29', 'kbodene@infoseek.co.jp');
insert into EmployeesEmails (EmployeeID, Email) values ('20', 'epaternosterf@elegantthemes.com');
insert into EmployeesEmails (EmployeeID, Email) values ('9', 'bmalkinsong@oracle.com');
insert into EmployeesEmails (EmployeeID, Email) values ('21', 'pverrierh@smh.com.au');
insert into EmployeesEmails (EmployeeID, Email) values ('13', 'mackhursti@artisteer.com');
insert into EmployeesEmails (EmployeeID, Email) values ('46', 'clynchj@cloudflare.com');
insert into EmployeesEmails (EmployeeID, Email) values ('37', 'kstallibrassk@theguardian.com');
insert into EmployeesEmails (EmployeeID, Email) values ('38', 'medgelll@mit.edu');
insert into EmployeesEmails (EmployeeID, Email) values ('17', 'gpauluccim@theguardian.com');
insert into EmployeesEmails (EmployeeID, Email) values ('47', 'mpizeyn@google.ca');
insert into EmployeesEmails (EmployeeID, Email) values ('30', 'gteffreyo@liveinternet.ru');
insert into EmployeesEmails (EmployeeID, Email) values ('33', 'amarielp@cocolog-nifty.com');
insert into EmployeesEmails (EmployeeID, Email) values ('43', 'goniansq@dropbox.com');
insert into EmployeesEmails (EmployeeID, Email) values ('7', 'amccritichier@amazon.com');
insert into EmployeesEmails (EmployeeID, Email) values ('16', 'nockendons@bloglines.com');
insert into EmployeesEmails (EmployeeID, Email) values ('12', 'aperlt@yellowpages.com');
insert into EmployeesEmails (EmployeeID, Email) values ('24', 'dbartzenu@columbia.edu');
insert into EmployeesEmails (EmployeeID, Email) values ('25', 'bmccuaigv@unesco.org');
insert into EmployeesEmails (EmployeeID, Email) values ('27', 'dgeorgesonw@phpbb.com');
insert into EmployeesEmails (EmployeeID, Email) values ('4', 'okinclax@uiuc.edu');
insert into EmployeesEmails (EmployeeID, Email) values ('18', 'kcristofaniniy@nbcnews.com');
insert into EmployeesEmails (EmployeeID, Email) values ('50', 'ajansensz@sakura.ne.jp');
insert into EmployeesEmails (EmployeeID, Email) values ('35', 'bpallis10@homestead.com');
insert into EmployeesEmails (EmployeeID, Email) values ('28', 'ggaunter11@reference.com');
insert into EmployeesEmails (EmployeeID, Email) values ('5', 'rrodolphe12@gov.uk');
insert into EmployeesEmails (EmployeeID, Email) values ('6', 'lcauser13@harvard.edu');
insert into EmployeesEmails (EmployeeID, Email) values ('49', 'lciccetti14@symantec.com');
insert into EmployeesEmails (EmployeeID, Email) values ('10', 'peddowis15@nationalgeographic.com');
insert into EmployeesEmails (EmployeeID, Email) values ('42', 'xwrathmell16@meetup.com');
insert into EmployeesEmails (EmployeeID, Email) values ('34', 'cfidgin17@technorati.com');
insert into EmployeesEmails (EmployeeID, Email) values ('32', 'codhams18@lulu.com');
insert into EmployeesEmails (EmployeeID, Email) values ('14', 'afullerlove19@digg.com');
insert into EmployeesEmails (EmployeeID, Email) values ('15', 'ballonby1a@clickbank.net');
insert into EmployeesEmails (EmployeeID, Email) values ('40', 'amcmeekin1b@sourceforge.net');
insert into EmployeesEmails (EmployeeID, Email) values ('44', 'ahubbucks1c@blogger.com');
insert into EmployeesEmails (EmployeeID, Email) values ('19', 'ocrickmer1d@linkedin.com');

-- Insert dummy data into Students table
insert into Students (StudentID, FirstName, LastName) values (1, 'Pepi', 'Dirr');
insert into Students (StudentID, FirstName, LastName) values (2, 'Meris', 'Etteridge');
insert into Students (StudentID, FirstName, LastName) values (3, 'Shaun', 'Smedmore');
insert into Students (StudentID, FirstName, LastName) values (4, 'Aurthur', 'Dionisetto');
insert into Students (StudentID, FirstName, LastName) values (5, 'Cassandra', 'Canny');
insert into Students (StudentID, FirstName, LastName) values (6, 'Standford', 'Alps');
insert into Students (StudentID, FirstName, LastName) values (7, 'Corabelle', 'Schubart');
insert into Students (StudentID, FirstName, LastName) values (8, 'Ravid', 'Challin');
insert into Students (StudentID, FirstName, LastName) values (9, 'Brandice', 'Carreyette');
insert into Students (StudentID, FirstName, LastName) values (10, 'Perice', 'Tewkesberry');
insert into Students (StudentID, FirstName, LastName) values (11, 'Gene', 'Micklewicz');
insert into Students (StudentID, FirstName, LastName) values (12, 'Andriana', 'Hawksworth');
insert into Students (StudentID, FirstName, LastName) values (13, 'Anton', 'Danielsohn');
insert into Students (StudentID, FirstName, LastName) values (14, 'Meggie', 'Adamec');
insert into Students (StudentID, FirstName, LastName) values (15, 'Dannie', 'Pendered');
insert into Students (StudentID, FirstName, LastName) values (16, 'Keriann', 'Whitworth');
insert into Students (StudentID, FirstName, LastName) values (17, 'Dawn', 'Shakelade');
insert into Students (StudentID, FirstName, LastName) values (18, 'Germain', 'Thring');
insert into Students (StudentID, FirstName, LastName) values (19, 'Rourke', 'Valentetti');
insert into Students (StudentID, FirstName, LastName) values (20, 'Ingram', 'Humpherson');
insert into Students (StudentID, FirstName, LastName) values (21, 'Ruttger', 'Denniston');
insert into Students (StudentID, FirstName, LastName) values (22, 'Nolana', 'Yeo');
insert into Students (StudentID, FirstName, LastName) values (23, 'Samaria', 'Profit');
insert into Students (StudentID, FirstName, LastName) values (24, 'Ada', 'Goodband');
insert into Students (StudentID, FirstName, LastName) values (25, 'Editha', 'Easey');
insert into Students (StudentID, FirstName, LastName) values (26, 'Toddy', 'Victoria');
insert into Students (StudentID, FirstName, LastName) values (27, 'Sherry', 'De Maria');
insert into Students (StudentID, FirstName, LastName) values (28, 'Rozamond', 'Fountain');
insert into Students (StudentID, FirstName, LastName) values (29, 'Joseito', 'Scad');
insert into Students (StudentID, FirstName, LastName) values (30, 'Olympia', 'Lakey');
insert into Students (StudentID, FirstName, LastName) values (31, 'Mervin', 'Tregien');
insert into Students (StudentID, FirstName, LastName) values (32, 'Jaclyn', 'Odgaard');
insert into Students (StudentID, FirstName, LastName) values (33, 'Netty', 'Dimblebee');
insert into Students (StudentID, FirstName, LastName) values (34, 'Jemmy', 'Stewart');
insert into Students (StudentID, FirstName, LastName) values (35, 'Carson', 'Fletcher');
insert into Students (StudentID, FirstName, LastName) values (36, 'Erin', 'Nansom');
insert into Students (StudentID, FirstName, LastName) values (37, 'Briana', 'Tebbett');
insert into Students (StudentID, FirstName, LastName) values (38, 'Murdoch', 'Phipard-Shears');
insert into Students (StudentID, FirstName, LastName) values (39, 'Raimundo', 'Scorrer');
insert into Students (StudentID, FirstName, LastName) values (40, 'Michelle', 'Filippazzo');
insert into Students (StudentID, FirstName, LastName) values (41, 'Melania', 'Grinyer');
insert into Students (StudentID, FirstName, LastName) values (42, 'Augusta', 'Howatt');
insert into Students (StudentID, FirstName, LastName) values (43, 'Chere', 'Crowest');
insert into Students (StudentID, FirstName, LastName) values (44, 'Rosemarie', 'Malloch');
insert into Students (StudentID, FirstName, LastName) values (45, 'Hanny', 'Mahon');
insert into Students (StudentID, FirstName, LastName) values (46, 'Chiquia', 'Drummond');
insert into Students (StudentID, FirstName, LastName) values (47, 'Brandie', 'Headington');
insert into Students (StudentID, FirstName, LastName) values (48, 'Shaine', 'Longstreeth');
insert into Students (StudentID, FirstName, LastName) values (49, 'Kanya', 'MacFie');
insert into Students (StudentID, FirstName, LastName) values (50, 'Heall', 'von Nassau');

-- Insert dummy data into StudentsEmails table
insert into StudentsEmails (StudentID, Email) values ('36', 'mjentet0@nasa.gov');
insert into StudentsEmails (StudentID, Email) values ('33', 'mcomer1@google.com.hk');
insert into StudentsEmails (StudentID, Email) values ('15', 'lbrakewell2@tamu.edu');
insert into StudentsEmails (StudentID, Email) values ('32', 'lromi3@rediff.com');
insert into StudentsEmails (StudentID, Email) values ('13', 'eknottley4@mapquest.com');
insert into StudentsEmails (StudentID, Email) values ('25', 'kgiabucci5@ameblo.jp');
insert into StudentsEmails (StudentID, Email) values ('6', 'lgregorin6@blogs.com');
insert into StudentsEmails (StudentID, Email) values ('28', 'eferrucci7@indiegogo.com');
insert into StudentsEmails (StudentID, Email) values ('29', 'mkaasmann8@multiply.com');
insert into StudentsEmails (StudentID, Email) values ('5', 'wbecken9@360.cn');
insert into StudentsEmails (StudentID, Email) values ('4', 'ltulipa@hc360.com');
insert into StudentsEmails (StudentID, Email) values ('43', 'mpaschekb@un.org');
insert into StudentsEmails (StudentID, Email) values ('1', 'mgalliverc@goo.ne.jp');
insert into StudentsEmails (StudentID, Email) values ('27', 'gbrazenord@si.edu');
insert into StudentsEmails (StudentID, Email) values ('3', 'cwoodnutte@desdev.cn');
insert into StudentsEmails (StudentID, Email) values ('49', 'kthackerayf@domainmarket.com');
insert into StudentsEmails (StudentID, Email) values ('46', 'lryrieg@newyorker.com');
insert into StudentsEmails (StudentID, Email) values ('47', 'nbradnamh@4shared.com');
insert into StudentsEmails (StudentID, Email) values ('12', 'anipperi@cam.ac.uk');
insert into StudentsEmails (StudentID, Email) values ('38', 'eterrisj@amazon.com');
insert into StudentsEmails (StudentID, Email) values ('26', 'nlarradk@latimes.com');
insert into StudentsEmails (StudentID, Email) values ('22', 'rwellbelovel@cpanel.net');
insert into StudentsEmails (StudentID, Email) values ('35', 'jbradockm@google.co.uk');
insert into StudentsEmails (StudentID, Email) values ('50', 'cpicklen@nature.com');
insert into StudentsEmails (StudentID, Email) values ('30', 'kmacsporrano@state.tx.us');
insert into StudentsEmails (StudentID, Email) values ('48', 'zeadp@a8.net');
insert into StudentsEmails (StudentID, Email) values ('2', 'bsucreq@photobucket.com');
insert into StudentsEmails (StudentID, Email) values ('42', 'ependridr@yellowbook.com');
insert into StudentsEmails (StudentID, Email) values ('34', 'mgurerys@wufoo.com');
insert into StudentsEmails (StudentID, Email) values ('10', 'fjobet@ehow.com');
insert into StudentsEmails (StudentID, Email) values ('31', 'dclewesu@msu.edu');
insert into StudentsEmails (StudentID, Email) values ('40', 'rfortiev@ow.ly');
insert into StudentsEmails (StudentID, Email) values ('39', 'ymackiew@linkedin.com');
insert into StudentsEmails (StudentID, Email) values ('18', 'cdewburyx@google.co.jp');
insert into StudentsEmails (StudentID, Email) values ('45', 'mzamoray@zimbio.com');
insert into StudentsEmails (StudentID, Email) values ('21', 'wkemerz@techcrunch.com');
insert into StudentsEmails (StudentID, Email) values ('11', 'fforrestall10@edublogs.org');
insert into StudentsEmails (StudentID, Email) values ('37', 'aweyman11@cnn.com');
insert into StudentsEmails (StudentID, Email) values ('9', 'wstruttman12@gov.uk');
insert into StudentsEmails (StudentID, Email) values ('23', 'cmatevushev13@indiegogo.com');
insert into StudentsEmails (StudentID, Email) values ('16', 'mdunks14@studiopress.com');
insert into StudentsEmails (StudentID, Email) values ('17', 'nsheraton15@alibaba.com');
insert into StudentsEmails (StudentID, Email) values ('8', 'ekedge16@godaddy.com');
insert into StudentsEmails (StudentID, Email) values ('14', 'sdooland17@bloglovin.com');
insert into StudentsEmails (StudentID, Email) values ('19', 'eplan18@wikispaces.com');
insert into StudentsEmails (StudentID, Email) values ('7', 'acrust19@redcross.org');
insert into StudentsEmails (StudentID, Email) values ('24', 'tbinns1a@livejournal.com');
insert into StudentsEmails (StudentID, Email) values ('41', 'kwevell1b@ocn.ne.jp');
insert into StudentsEmails (StudentID, Email) values ('44', 'llinstead1c@yale.edu');
insert into StudentsEmails (StudentID, Email) values ('20', 'ntzuker1d@microsoft.com');

-- Insert dummy data into AcademicAdvisors table
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (1, 'Franklyn', 'Calveley', '719-955-9156', 'Social Sciences and Humanities', 123);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (2, 'Jarret', 'Ghiriardelli', '191-269-4043', 'Health Sciences', 139);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (3, 'Joseph', 'Markel', '209-554-0746', 'Computer Sciences', 107);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (4, 'Myrwyn', 'Clemendet', '314-348-7783', 'Health Sciences', 114);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (5, 'Oona', 'Dearth', '838-564-0722', 'Computer Sciences', 111);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (6, 'Ardine', 'Rouff', '744-716-5265', 'Business', 139);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (7, 'Jennica', 'Scudamore', '909-282-4502', 'Arts and Design', 124);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (8, 'Alvy', 'Schimke', '840-785-9388', 'Computer Sciences', 139);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (9, 'Norrie', 'Downey', '128-231-3738', 'Computer Sciences', 122);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (10, 'Angelo', 'Sunter', '363-866-0997', 'Social Sciences and Humanities', 118);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (11, 'Corabella', 'Harrigan', '521-628-5248', 'Social Sciences and Humanities', 113);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (12, 'Ardra', 'Wishkar', '515-750-9595', 'Business', 119);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (13, 'Hamnet', 'Shafier', '569-295-7841', 'Computer Sciences', 108);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (14, 'Christalle', 'McCome', '911-152-8429', 'Business', 148);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (15, 'Atlanta', 'Gorgen', '701-641-7452', 'Arts and Design', 100);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (16, 'Tomasina', 'Doughtery', '291-479-7098', 'Arts and Design', 108);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (17, 'Jordana', 'Dunsire', '432-388-1124', 'Business', 150);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (18, 'Heidie', 'Tawn', '527-384-4323', 'Computer Sciences', 144);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (19, 'Gerta', 'Vogeler', '309-589-4493', 'Computer Sciences', 146);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (20, 'Bobbye', 'Isaq', '558-523-7802', 'Engineering', 142);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (21, 'Carita', 'Flawn', '748-753-7937', 'Engineering', 123);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (22, 'Orrin', 'Rubinchik', '933-218-8108', 'Computer Sciences', 127);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (23, 'Jard', 'Corke', '696-727-0805', 'Computer Sciences', 108);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (24, 'Art', 'Cregeen', '307-762-9817', 'Arts and Design', 115);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (25, 'Les', 'MacCook', '103-569-5964', 'Social Sciences and Humanities', 119);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (26, 'Gaston', 'Tredger', '870-244-4847', 'Social Sciences and Humanities', 114);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (27, 'Garnet', 'Thorsen', '783-916-2236', 'Business', 110);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (28, 'Jess', 'Stitson', '812-470-1628', 'Social Sciences and Humanities', 113);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (29, 'Brittani', 'De Bell', '827-266-5112', 'Social Sciences and Humanities', 145);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (30, 'Casandra', 'Govier', '974-810-2270', 'Social Sciences and Humanities', 112);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (31, 'Fin', 'Caccavari', '243-629-5514', 'Health Sciences', 115);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (32, 'Sutherlan', 'Gentile', '715-923-4972', 'Health Sciences', 126);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (33, 'Joletta', 'Nanetti', '653-456-2473', 'Arts and Design', 122);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (34, 'Kinnie', 'Sandry', '414-141-2501', 'Social Sciences and Humanities', 111);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (35, 'Sharl', 'Kinver', '277-593-6468', 'Arts and Design', 116);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (36, 'Elfrieda', 'Christoffe', '547-273-9245', 'Computer Sciences', 150);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (37, 'Shep', 'Meates', '939-233-9949', 'Engineering', 145);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (38, 'Ripley', 'Comoletti', '495-541-5127', 'Arts and Design', 106);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (39, 'Katie', 'Bennion', '771-810-8973', 'Engineering', 144);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (40, 'Sheba', 'Dummigan', '835-195-3031', 'Computer Sciences', 108);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (41, 'Miquela', 'Schultze', '278-447-6394', 'Engineering', 134);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (42, 'Ailey', 'Carlsen', '507-604-5141', 'Health Sciences', 130);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (43, 'Cleo', 'Fidgin', '860-925-0318', 'Business', 106);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (44, 'Min', 'Peachey', '585-853-5235', 'Business', 144);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (45, 'Galina', 'Rawlings', '665-677-5965', 'Computer Sciences', 130);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (46, 'Rudolph', 'Mandrake', '915-188-1174', 'Health Sciences', 124);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (47, 'Gilberte', 'Batistelli', '507-368-5353', 'Computer Sciences', 105);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (48, 'Cullin', 'Hasling', '254-189-5283', 'Engineering', 147);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (49, 'Augustin', 'Hamson', '832-812-6142', 'Computer Sciences', 135);
insert into AcademicCoordinators (CoordinatorID, FirstName, LastName, Phone, Department, Supervisor) values (50, 'Morganica', 'Yashaev', '579-381-3297', 'Business', 105);

-- Insert dummy data into AcademicAdvisorsEmails table
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('35', 'spastor0@nymag.com');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('5', 'aheakey1@cocolog-nifty.com');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('32', 'wcappleman2@flavors.me');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('14', 'hbrougham3@noaa.gov');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('40', 'ebeckinsall4@ihg.com');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('48', 'bcollison5@ihg.com');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('7', 'kperrygo6@marriott.com');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('46', 'hkelly7@icq.com');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('12', 'jstooke8@miibeian.gov.cn');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('15', 'klincoln9@cam.ac.uk');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('49', 'bmichea@imdb.com');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('1', 'jmilneb@constantcontact.com');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('16', 'dvreedec@ca.gov');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('44', 'kjohannesd@wix.com');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('34', 'kreinae@123-reg.co.uk');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('3', 'achevalierf@gnu.org');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('6', 'rbaverstockg@cnn.com');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('39', 'jcoltanh@sun.com');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('45', 'msoani@statcounter.com');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('23', 'cgilberthorpej@google.co.uk');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('20', 'rbengek@psu.edu');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('22', 'fmacksteadl@miibeian.gov.cn');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('9', 'fhatzm@bigcartel.com');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('38', 'tstraneon@elegantthemes.com');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('28', 'ncumoo@google.de');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('19', 'cerrickerp@upenn.edu');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('21', 'kprenticeq@xinhuanet.com');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('10', 'molehaner@printfriendly.com');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('50', 'cscogingss@infoseek.co.jp');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('25', 'nsmartmant@hibu.com');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('24', 'amcskeaganu@imageshack.us');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('42', 'mhaytov@wsj.com');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('18', 'mpirazziw@cbslocal.com');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('41', 'kkerslakex@google.com.br');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('4', 'mormey@ed.gov');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('37', 'larrandalez@si.edu');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('13', 'twasylkiewicz10@berkeley.edu');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('17', 'gscrancher11@ow.ly');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('43', 'mmcgairl12@shareasale.com');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('27', 'jdegoey13@pinterest.com');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('2', 'chentzeler14@mysql.com');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('36', 'mdavydochkin15@cmu.edu');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('31', 'agaythor16@seattletimes.com');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('29', 'mhullins17@dailymotion.com');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('26', 'bpiddocke18@psu.edu');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('11', 'nkmicicki19@nytimes.com');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('33', 'ytrobey1a@arizona.edu');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('8', 'emurrum1b@posterous.com');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('30', 'nclashe1c@squarespace.com');
insert into AcademicCoordinatorEmails (CoordinatorID, Email) values ('47', 'iharvard1d@cam.ac.uk');

-- Insert dummy data into Courses table
insert into Courses (CourseID, Department) values (2506, 'Health Sciences');
insert into Courses (CourseID, Department) values (3323, 'Health Sciences');
insert into Courses (CourseID, Department) values (2729, 'Social Sciences and Humanities');
insert into Courses (CourseID, Department) values (3825, 'Health Sciences');
insert into Courses (CourseID, Department) values (2648, 'Social Sciences and Humanities');
insert into Courses (CourseID, Department) values (1679, 'Engineering');
insert into Courses (CourseID, Department) values (3624, 'Health Sciences');
insert into Courses (CourseID, Department) values (2784, 'Engineering');
insert into Courses (CourseID, Department) values (3842, 'Computer Sciences');
insert into Courses (CourseID, Department) values (4497, 'Social Sciences and Humanities');
insert into Courses (CourseID, Department) values (1107, 'Arts and Design');
insert into Courses (CourseID, Department) values (2030, 'Arts and Design');
insert into Courses (CourseID, Department) values (4448, 'Business');
insert into Courses (CourseID, Department) values (1170, 'Business');
insert into Courses (CourseID, Department) values (2537, 'Business');
insert into Courses (CourseID, Department) values (3600, 'Computer Sciences');
insert into Courses (CourseID, Department) values (3855, 'Computer Sciences');
insert into Courses (CourseID, Department) values (1067, 'Engineering');
insert into Courses (CourseID, Department) values (2096, 'Business');
insert into Courses (CourseID, Department) values (4919, 'Business');
insert into Courses (CourseID, Department) values (1814, 'Social Sciences and Humanities');
insert into Courses (CourseID, Department) values (1693, 'Computer Sciences');
insert into Courses (CourseID, Department) values (3584, 'Health Sciences');
insert into Courses (CourseID, Department) values (3678, 'Computer Sciences');
insert into Courses (CourseID, Department) values (2735, 'Business');
insert into Courses (CourseID, Department) values (1261, 'Arts and Design');
insert into Courses (CourseID, Department) values (3390, 'Business');
insert into Courses (CourseID, Department) values (1545, 'Engineering');
insert into Courses (CourseID, Department) values (3420, 'Business');
insert into Courses (CourseID, Department) values (1384, 'Engineering');
insert into Courses (CourseID, Department) values (3264, 'Engineering');
insert into Courses (CourseID, Department) values (2008, 'Health Sciences');
insert into Courses (CourseID, Department) values (2087, 'Health Sciences');
insert into Courses (CourseID, Department) values (2674, 'Engineering');
insert into Courses (CourseID, Department) values (1939, 'Computer Sciences');
insert into Courses (CourseID, Department) values (3725, 'Health Sciences');
insert into Courses (CourseID, Department) values (3706, 'Computer Sciences');
insert into Courses (CourseID, Department) values (2864, 'Health Sciences');
insert into Courses (CourseID, Department) values (2768, 'Business');
insert into Courses (CourseID, Department) values (3542, 'Social Sciences and Humanities');
insert into Courses (CourseID, Department) values (3484, 'Social Sciences and Humanities');
insert into Courses (CourseID, Department) values (4123, 'Health Sciences');
insert into Courses (CourseID, Department) values (4968, 'Health Sciences');
insert into Courses (CourseID, Department) values (1587, 'Business');
insert into Courses (CourseID, Department) values (4016, 'Engineering');
insert into Courses (CourseID, Department) values (3490, 'Engineering');
insert into Courses (CourseID, Department) values (4429, 'Computer Sciences');
insert into Courses (CourseID, Department) values (2616, 'Business');
insert into Courses (CourseID, Department) values (1509, 'Health Sciences');
insert into Courses (CourseID, Department) values (2611, 'Health Sciences');

-- Insert dummy data into CourseSections table
insert into CourseSections (CRN, CourseID, Year, Semester) values (44138, '2506', 2024, 'Summer');
insert into CourseSections (CRN, CourseID, Year, Semester) values (36749, '3323', 2018, 'Spring');
insert into CourseSections (CRN, CourseID, Year, Semester) values (30673, '2729', 2024, 'Spring');
insert into CourseSections (CRN, CourseID, Year, Semester) values (38346, '3825', 2018, 'Fall');
insert into CourseSections (CRN, CourseID, Year, Semester) values (11473, '2648', 2018, 'Fall');
insert into CourseSections (CRN, CourseID, Year, Semester) values (34356, '1679', 2022, 'Spring');
insert into CourseSections (CRN, CourseID, Year, Semester) values (40762, '3624', 2023, 'Fall');
insert into CourseSections (CRN, CourseID, Year, Semester) values (42927, '2784', 2019, 'Summer');
insert into CourseSections (CRN, CourseID, Year, Semester) values (27428, '3842', 2022, 'Spring');
insert into CourseSections (CRN, CourseID, Year, Semester) values (17276, '4497', 2021, 'Summer');
insert into CourseSections (CRN, CourseID, Year, Semester) values (33628, '1107', 2022, 'Spring');
insert into CourseSections (CRN, CourseID, Year, Semester) values (46528, '2030', 2021, 'Summer');
insert into CourseSections (CRN, CourseID, Year, Semester) values (25135, '4448', 2024, 'Summer');
insert into CourseSections (CRN, CourseID, Year, Semester) values (21117, '1170', 2023, 'Fall');
insert into CourseSections (CRN, CourseID, Year, Semester) values (19928, '2537', 2020, 'Summer');
insert into CourseSections (CRN, CourseID, Year, Semester) values (43886, '3600', 2020, 'Fall');
insert into CourseSections (CRN, CourseID, Year, Semester) values (42362, '3855', 2018, 'Summer');
insert into CourseSections (CRN, CourseID, Year, Semester) values (28509, '1067', 2019, 'Spring');
insert into CourseSections (CRN, CourseID, Year, Semester) values (28340, '2096', 2019, 'Fall');
insert into CourseSections (CRN, CourseID, Year, Semester) values (28915, '4919', 2024, 'Summer');
insert into CourseSections (CRN, CourseID, Year, Semester) values (42758, '1814', 2019, 'Fall');
insert into CourseSections (CRN, CourseID, Year, Semester) values (25443, '1693', 2023, 'Summer');
insert into CourseSections (CRN, CourseID, Year, Semester) values (25283, '3584', 2021, 'Fall');
insert into CourseSections (CRN, CourseID, Year, Semester) values (28811, '3678', 2023, 'Spring');
insert into CourseSections (CRN, CourseID, Year, Semester) values (46515, '2735', 2023, 'Spring');
insert into CourseSections (CRN, CourseID, Year, Semester) values (46890, '1261', 2022, 'Summer');
insert into CourseSections (CRN, CourseID, Year, Semester) values (24598, '3390', 2022, 'Summer');
insert into CourseSections (CRN, CourseID, Year, Semester) values (36044, '1545', 2023, 'Summer');
insert into CourseSections (CRN, CourseID, Year, Semester) values (11174, '3420', 2021, 'Spring');
insert into CourseSections (CRN, CourseID, Year, Semester) values (42661, '1384', 2023, 'Spring');
insert into CourseSections (CRN, CourseID, Year, Semester) values (37643, '3264', 2020, 'Spring');
insert into CourseSections (CRN, CourseID, Year, Semester) values (31862, '2008', 2024, 'Fall');
insert into CourseSections (CRN, CourseID, Year, Semester) values (40397, '2087', 2022, 'Spring');
insert into CourseSections (CRN, CourseID, Year, Semester) values (32663, '2674', 2021, 'Summer');
insert into CourseSections (CRN, CourseID, Year, Semester) values (47486, '1939', 2022, 'Spring');
insert into CourseSections (CRN, CourseID, Year, Semester) values (12269, '3725', 2022, 'Summer');
insert into CourseSections (CRN, CourseID, Year, Semester) values (41863, '3706', 2019, 'Fall');
insert into CourseSections (CRN, CourseID, Year, Semester) values (33363, '2864', 2022, 'Fall');
insert into CourseSections (CRN, CourseID, Year, Semester) values (33860, '2768', 2018, 'Spring');
insert into CourseSections (CRN, CourseID, Year, Semester) values (20631, '3542', 2020, 'Fall');
insert into CourseSections (CRN, CourseID, Year, Semester) values (33931, '3484', 2022, 'Spring');
insert into CourseSections (CRN, CourseID, Year, Semester) values (42559, '4123', 2020, 'Fall');
insert into CourseSections (CRN, CourseID, Year, Semester) values (34458, '4968', 2018, 'Spring');
insert into CourseSections (CRN, CourseID, Year, Semester) values (38927, '1587', 2020, 'Summer');
insert into CourseSections (CRN, CourseID, Year, Semester) values (46832, '4016', 2018, 'Fall');
insert into CourseSections (CRN, CourseID, Year, Semester) values (34871, '3490', 2019, 'Spring');
insert into CourseSections (CRN, CourseID, Year, Semester) values (29757, '4429', 2020, 'Spring');
insert into CourseSections (CRN, CourseID, Year, Semester) values (33352, '2616', 2024, 'Summer');
insert into CourseSections (CRN, CourseID, Year, Semester) values (14326, '1509', 2023, 'Spring');
insert into CourseSections (CRN, CourseID, Year, Semester) values (33279, '2611', 2024, 'Spring');

-- Insert dummy data into Instructors table
insert into Instructors (CRN, EmployeeID) values ('19832', '24');
insert into Instructors (CRN, EmployeeID) values ('41844', '43');
insert into Instructors (CRN, EmployeeID) values ('16605', '45');
insert into Instructors (CRN, EmployeeID) values ('46133', '5');
insert into Instructors (CRN, EmployeeID) values ('47109', '33');
insert into Instructors (CRN, EmployeeID) values ('42581', '35');
insert into Instructors (CRN, EmployeeID) values ('13057', '42');
insert into Instructors (CRN, EmployeeID) values ('29591', '46');
insert into Instructors (CRN, EmployeeID) values ('34455', '50');
insert into Instructors (CRN, EmployeeID) values ('15035', '7');
insert into Instructors (CRN, EmployeeID) values ('15246', '44');
insert into Instructors (CRN, EmployeeID) values ('48831', '8');
insert into Instructors (CRN, EmployeeID) values ('49714', '32');
insert into Instructors (CRN, EmployeeID) values ('43752', '16');
insert into Instructors (CRN, EmployeeID) values ('25321', '29');
insert into Instructors (CRN, EmployeeID) values ('10802', '21');
insert into Instructors (CRN, EmployeeID) values ('40831', '2');
insert into Instructors (CRN, EmployeeID) values ('12703', '23');
insert into Instructors (CRN, EmployeeID) values ('21638', '14');
insert into Instructors (CRN, EmployeeID) values ('47059', '31');
insert into Instructors (CRN, EmployeeID) values ('35903', '9');
insert into Instructors (CRN, EmployeeID) values ('37086', '12');
insert into Instructors (CRN, EmployeeID) values ('14009', '38');
insert into Instructors (CRN, EmployeeID) values ('33391', '6');
insert into Instructors (CRN, EmployeeID) values ('48885', '1');
insert into Instructors (CRN, EmployeeID) values ('43907', '4');
insert into Instructors (CRN, EmployeeID) values ('38334', '19');
insert into Instructors (CRN, EmployeeID) values ('48958', '30');
insert into Instructors (CRN, EmployeeID) values ('10412', '27');
insert into Instructors (CRN, EmployeeID) values ('35975', '37');
insert into Instructors (CRN, EmployeeID) values ('19929', '47');
insert into Instructors (CRN, EmployeeID) values ('29431', '40');
insert into Instructors (CRN, EmployeeID) values ('44688', '26');
insert into Instructors (CRN, EmployeeID) values ('30010', '39');
insert into Instructors (CRN, EmployeeID) values ('33092', '17');
insert into Instructors (CRN, EmployeeID) values ('29755', '28');
insert into Instructors (CRN, EmployeeID) values ('30878', '11');
insert into Instructors (CRN, EmployeeID) values ('12479', '18');
insert into Instructors (CRN, EmployeeID) values ('18241', '3');
insert into Instructors (CRN, EmployeeID) values ('33963', '41');
insert into Instructors (CRN, EmployeeID) values ('32137', '34');
insert into Instructors (CRN, EmployeeID) values ('20164', '22');
insert into Instructors (CRN, EmployeeID) values ('16611', '25');
insert into Instructors (CRN, EmployeeID) values ('16981', '15');
insert into Instructors (CRN, EmployeeID) values ('37829', '13');
insert into Instructors (CRN, EmployeeID) values ('10721', '10');
insert into Instructors (CRN, EmployeeID) values ('19119', '48');
insert into Instructors (CRN, EmployeeID) values ('44124', '49');
insert into Instructors (CRN, EmployeeID) values ('46028', '20');
insert into Instructors (CRN, EmployeeID) values ('37347', '36');

-- Insert dummy data into Assignments table
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (1, '2024-04-24', '2024-02-03', '43907');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (2, '2024-04-25', '2023-12-27', '33963');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (3, '2024-04-22', '2023-10-14', '33391');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (4, '2024-04-22', '2023-11-10', '44688');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (5, '2024-04-25', '2023-09-06', '10412');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (6, '2024-04-24', '2023-12-27', '16605');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (7, '2024-04-23', '2024-03-23', '20164');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (8, '2024-04-22', '2024-02-08', '49714');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (9, '2024-04-24', '2024-01-19', '10802');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (10, '2024-04-25', '2024-03-09', '41844');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (11, '2024-04-25', '2023-11-22', '40831');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (12, '2024-04-22', '2024-02-13', '42581');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (13, '2024-04-23', '2023-10-09', '12703');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (14, '2024-04-24', '2023-10-17', '19929');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (15, '2024-04-22', '2023-10-30', '15035');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (16, '2024-04-23', '2023-10-30', '21638');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (17, '2024-04-22', '2023-12-04', '46028');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (18, '2024-04-22', '2024-01-15', '32137');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (19, '2024-04-24', '2024-04-02', '37086');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (20, '2024-04-23', '2023-10-27', '13057');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (21, '2024-04-22', '2024-04-06', '48885');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (22, '2024-04-25', '2024-02-28', '19832');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (23, '2024-04-22', '2024-04-17', '16611');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (24, '2024-04-25', '2023-09-19', '38334');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (25, '2024-04-24', '2024-03-19', '19119');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (26, '2024-04-22', '2024-04-10', '29755');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (27, '2024-04-25', '2024-01-12', '34455');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (28, '2024-04-22', '2023-12-04', '33092');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (29, '2024-04-22', '2024-04-15', '30010');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (30, '2024-04-22', '2023-09-18', '47059');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (31, '2024-04-22', '2024-04-08', '37829');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (32, '2024-04-24', '2023-12-30', '43752');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (33, '2024-04-24', '2024-03-05', '10721');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (34, '2024-04-22', '2023-12-03', '16981');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (35, '2024-04-22', '2024-02-24', '48831');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (36, '2024-04-23', '2023-09-25', '47109');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (37, '2024-04-23', '2024-04-16', '30878');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (38, '2024-04-22', '2023-09-28', '35975');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (39, '2024-04-22', '2023-09-03', '29431');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (40, '2024-04-22', '2024-01-20', '37347');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (41, '2024-04-24', '2024-02-19', '44124');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (42, '2024-04-24', '2024-03-06', '35903');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (43, '2024-04-23', '2023-09-27', '46133');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (44, '2024-04-24', '2023-12-17', '25321');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (45, '2024-04-25', '2023-11-29', '48958');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (46, '2024-04-23', '2024-01-22', '18241');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (47, '2024-04-22', '2023-09-14', '29591');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (48, '2024-04-22', '2024-01-17', '15246');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (49, '2024-04-24', '2023-09-11', '14009');
insert into Assignments (AssignmentID, DueDate, DateAssigned, CourseCRN) values (50, '2024-04-23', '2024-01-07', '12479');

-- Insert dummy data into Submissions table
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (1, '28', 94, '2024-06-24', '2024-04-25', true, '26', '50');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (2, '45', 38, '2024-06-27', '2024-04-22', true, '28', '44');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (3, '25', 56, '2024-06-27', '2024-04-22', true, '10', '5');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (4, '6', 3, '2024-06-24', '2024-04-25', false, '43', '27');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (5, '27', 33, '2024-06-27', '2024-04-25', true, '22', '40');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (6, '22', 27, '2024-06-25', '2024-04-24', false, '40', '46');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (7, '48', 100, '2024-06-27', '2024-04-25', false, '15', '37');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (8, '47', 3, '2024-06-25', '2024-04-25', false, '24', '24');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (9, '1', 80, '2024-06-24', '2024-04-23', false, '49', '25');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (10, '32', 99, '2024-06-24', '2024-04-22', false, '23', '36');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (11, '50', 22, '2024-06-25', '2024-04-25', false, '36', '16');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (12, '41', 22, '2024-06-25', '2024-04-25', false, '41', '9');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (13, '31', 50, '2024-06-26', '2024-04-25', false, '39', '23');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (14, '38', 75, '2024-06-24', '2024-04-23', false, '48', '17');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (15, '17', 2, '2024-06-26', '2024-04-23', true, '45', '4');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (16, '39', 35, '2024-06-25', '2024-04-23', true, '18', '6');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (17, '7', 18, '2024-06-26', '2024-04-23', true, '35', '42');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (18, '40', 97, '2024-06-27', '2024-04-24', false, '25', '18');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (19, '14', 69, '2024-06-26', '2024-04-25', true, '4', '48');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (20, '23', 33, '2024-06-27', '2024-04-24', false, '31', '34');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (21, '37', 49, '2024-06-26', '2024-04-23', false, '14', '38');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (22, '15', 57, '2024-06-25', '2024-04-22', false, '27', '1');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (23, '43', 21, '2024-06-26', '2024-04-24', true, '42', '43');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (24, '42', 61, '2024-06-25', '2024-04-23', false, '1', '28');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (25, '35', 39, '2024-06-26', '2024-04-25', true, '20', '47');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (26, '19', 79, '2024-06-26', '2024-04-25', false, '30', '2');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (27, '12', 24, '2024-06-24', '2024-04-24', false, '9', '49');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (28, '4', 48, '2024-06-26', '2024-04-25', true, '34', '13');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (29, '24', 97, '2024-06-25', '2024-04-23', false, '12', '29');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (30, '3', 51, '2024-06-26', '2024-04-25', false, '2', '26');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (31, '2', 1, '2024-06-27', '2024-04-25', false, '5', '11');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (32, '49', 18, '2024-06-26', '2024-04-24', false, '11', '15');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (33, '10', 97, '2024-06-26', '2024-04-23', false, '7', '7');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (34, '5', 77, '2024-06-27', '2024-04-25', false, '13', '8');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (35, '16', 27, '2024-06-25', '2024-04-24', true, '37', '10');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (36, '21', 42, '2024-06-25', '2024-04-22', true, '46', '12');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (37, '13', 15, '2024-06-25', '2024-04-22', true, '17', '22');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (38, '33', 87, '2024-06-24', '2024-04-22', false, '38', '21');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (39, '9', 64, '2024-06-27', '2024-04-25', true, '21', '33');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (40, '26', 75, '2024-06-24', '2024-04-24', false, '32', '20');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (41, '46', 52, '2024-06-25', '2024-04-22', false, '6', '30');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (42, '34', 99, '2024-06-27', '2024-04-22', true, '29', '39');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (43, '29', 63, '2024-06-24', '2024-04-24', true, '44', '19');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (44, '20', 17, '2024-06-27', '2024-04-25', true, '8', '45');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (45, '8', 77, '2024-06-25', '2024-04-25', true, '50', '41');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (46, '11', 38, '2024-06-25', '2024-04-23', true, '19', '31');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (47, '44', 90, '2024-06-24', '2024-04-22', false, '47', '32');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (48, '30', 3, '2024-06-25', '2024-04-24', false, '3', '3');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (49, '18', 79, '2024-06-25', '2024-04-22', true, '33', '14');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (50, '36', 40, '2024-06-27', '2024-04-25', false, '16', '35');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (51, '43', 47, '2024-06-27', '2024-04-24', false, '2', '15');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (52, '48', 61, '2024-06-27', '2024-04-23', true, '29', '16');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (53, '40', 54, '2024-06-26', '2024-04-24', false, '42', '32');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (54, '12', 92, '2024-06-27', '2024-04-22', true, '25', '49');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (55, '45', 6, '2024-06-25', '2024-04-22', false, '6', '47');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (56, '16', 42, '2024-06-24', '2024-04-22', false, '5', '31');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (57, '47', 28, '2024-06-27', '2024-04-23', true, '28', '29');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (58, '19', 43, '2024-06-25', '2024-04-25', true, '20', '37');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (59, '39', 50, '2024-06-24', '2024-04-23', true, '38', '11');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (60, '8', 13, '2024-06-26', '2024-04-25', true, '45', '21');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (61, '25', 74, '2024-06-26', '2024-04-24', false, '3', '22');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (62, '7', 38, '2024-06-25', '2024-04-25', true, '23', '8');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (63, '6', 71, '2024-06-26', '2024-04-25', false, '14', '26');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (64, '35', 44, '2024-06-26', '2024-04-23', false, '16', '20');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (65, '36', 53, '2024-06-27', '2024-04-25', true, '35', '1');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (66, '24', 32, '2024-06-24', '2024-04-24', false, '50', '17');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (67, '50', 26, '2024-06-26', '2024-04-25', false, '43', '34');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (68, '4', 16, '2024-06-27', '2024-04-24', false, '19', '24');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (69, '33', 90, '2024-06-27', '2024-04-22', true, '18', '50');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (70, '18', 71, '2024-06-27', '2024-04-25', false, '7', '46');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (71, '38', 61, '2024-06-24', '2024-04-24', false, '11', '25');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (72, '23', 25, '2024-06-25', '2024-04-22', false, '31', '44');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (73, '20', 34, '2024-06-24', '2024-04-25', false, '41', '48');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (74, '27', 47, '2024-06-26', '2024-04-22', true, '32', '4');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (75, '32', 81, '2024-06-24', '2024-04-24', true, '8', '9');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (76, '15', 43, '2024-06-27', '2024-04-23', false, '27', '5');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (77, '37', 70, '2024-06-27', '2024-04-25', false, '21', '7');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (78, '41', 68, '2024-06-24', '2024-04-25', true, '12', '23');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (79, '30', 9, '2024-06-25', '2024-04-22', false, '22', '36');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (80, '9', 57, '2024-06-27', '2024-04-23', true, '36', '40');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (81, '5', 53, '2024-06-27', '2024-04-25', false, '49', '28');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (82, '2', 33, '2024-06-25', '2024-04-25', false, '33', '2');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (83, '3', 19, '2024-06-26', '2024-04-24', false, '34', '30');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (84, '34', 97, '2024-06-26', '2024-04-22', true, '17', '35');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (85, '21', 34, '2024-06-27', '2024-04-25', true, '10', '18');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (86, '31', 86, '2024-06-26', '2024-04-23', true, '44', '14');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (87, '42', 84, '2024-06-27', '2024-04-24', true, '46', '12');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (88, '49', 98, '2024-06-24', '2024-04-23', true, '48', '19');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (89, '44', 9, '2024-06-25', '2024-04-23', false, '37', '39');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (90, '11', 10, '2024-06-27', '2024-04-24', true, '47', '42');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (91, '10', 47, '2024-06-26', '2024-04-22', false, '26', '3');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (92, '14', 73, '2024-06-27', '2024-04-24', false, '40', '43');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (93, '13', 52, '2024-06-24', '2024-04-25', true, '13', '6');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (94, '46', 54, '2024-06-26', '2024-04-24', true, '24', '41');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (95, '22', 16, '2024-06-27', '2024-04-23', false, '39', '10');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (96, '17', 96, '2024-06-26', '2024-04-24', true, '9', '33');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (97, '1', 74, '2024-06-27', '2024-04-25', false, '4', '45');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (98, '29', 59, '2024-06-26', '2024-04-22', false, '15', '38');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (99, '26', 96, '2024-06-26', '2024-04-25', false, '1', '13');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (100, '28', 29, '2024-06-26', '2024-04-22', false, '30', '27');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (101, '9', 50, '2024-06-24', '2024-04-22', true, '14', '42');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (102, '13', 18, '2024-06-27', '2024-04-24', true, '48', '9');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (103, '26', 94, '2024-06-25', '2024-04-22', false, '44', '38');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (104, '11', 90, '2024-06-27', '2024-04-22', true, '30', '35');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (105, '33', 29, '2024-06-26', '2024-04-24', true, '36', '28');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (106, '25', 67, '2024-06-27', '2024-04-23', true, '16', '17');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (107, '28', 74, '2024-06-24', '2024-04-25', true, '20', '46');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (108, '32', 63, '2024-06-25', '2024-04-24', false, '34', '49');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (109, '17', 49, '2024-06-25', '2024-04-22', false, '35', '6');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (110, '29', 61, '2024-06-26', '2024-04-25', true, '49', '24');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (111, '18', 30, '2024-06-26', '2024-04-22', false, '7', '19');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (112, '10', 52, '2024-06-26', '2024-04-25', false, '9', '44');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (113, '19', 21, '2024-06-26', '2024-04-23', true, '37', '22');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (114, '27', 56, '2024-06-25', '2024-04-24', true, '13', '48');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (115, '4', 15, '2024-06-26', '2024-04-25', true, '38', '31');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (116, '43', 98, '2024-06-24', '2024-04-25', false, '46', '16');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (117, '16', 63, '2024-06-25', '2024-04-22', true, '32', '12');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (118, '3', 22, '2024-06-24', '2024-04-24', true, '15', '1');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (119, '40', 57, '2024-06-24', '2024-04-25', false, '4', '36');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (120, '49', 15, '2024-06-24', '2024-04-25', false, '10', '45');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (121, '20', 1, '2024-06-26', '2024-04-24', false, '40', '2');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (122, '24', 14, '2024-06-26', '2024-04-24', false, '28', '23');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (123, '50', 23, '2024-06-24', '2024-04-24', false, '29', '20');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (124, '47', 54, '2024-06-25', '2024-04-25', true, '47', '14');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (125, '14', 11, '2024-06-26', '2024-04-24', true, '6', '27');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (126, '21', 58, '2024-06-27', '2024-04-25', false, '50', '15');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (127, '41', 3, '2024-06-26', '2024-04-24', false, '41', '3');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (128, '39', 71, '2024-06-26', '2024-04-25', false, '21', '29');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (129, '8', 17, '2024-06-27', '2024-04-25', true, '31', '7');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (130, '45', 94, '2024-06-27', '2024-04-25', false, '26', '4');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (131, '22', 30, '2024-06-27', '2024-04-24', false, '18', '33');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (132, '38', 6, '2024-06-26', '2024-04-24', false, '2', '25');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (133, '23', 14, '2024-06-25', '2024-04-23', false, '1', '10');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (134, '30', 6, '2024-06-24', '2024-04-25', true, '24', '50');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (135, '48', 7, '2024-06-24', '2024-04-24', true, '11', '8');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (136, '35', 74, '2024-06-26', '2024-04-24', true, '12', '37');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (137, '7', 63, '2024-06-27', '2024-04-23', false, '42', '11');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (138, '2', 67, '2024-06-25', '2024-04-24', false, '25', '18');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (139, '31', 62, '2024-06-25', '2024-04-23', false, '5', '5');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (140, '34', 85, '2024-06-25', '2024-04-25', false, '22', '13');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (141, '37', 8, '2024-06-26', '2024-04-22', false, '43', '39');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (142, '44', 89, '2024-06-26', '2024-04-22', false, '8', '32');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (143, '1', 25, '2024-06-27', '2024-04-24', true, '33', '34');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (144, '42', 23, '2024-06-27', '2024-04-23', true, '19', '21');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (145, '46', 91, '2024-06-24', '2024-04-24', true, '27', '30');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (146, '5', 2, '2024-06-26', '2024-04-22', false, '3', '43');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (147, '12', 44, '2024-06-27', '2024-04-23', false, '45', '26');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (148, '15', 95, '2024-06-26', '2024-04-25', false, '23', '41');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (149, '36', 59, '2024-06-26', '2024-04-24', false, '39', '47');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (150, '6', 38, '2024-06-27', '2024-04-23', true, '17', '40');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (151, '16', 57, '2024-06-24', '2024-04-23', false, '36', '37');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (152, '17', 27, '2024-06-25', '2024-04-24', false, '49', '27');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (153, '34', 14, '2024-06-26', '2024-04-24', false, '46', '3');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (154, '15', 68, '2024-06-24', '2024-04-24', true, '31', '15');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (155, '2', 67, '2024-06-25', '2024-04-23', true, '38', '23');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (156, '35', 36, '2024-06-25', '2024-04-22', true, '3', '11');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (157, '12', 77, '2024-06-27', '2024-04-24', true, '23', '1');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (158, '30', 70, '2024-06-27', '2024-04-25', false, '44', '24');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (159, '41', 16, '2024-06-24', '2024-04-24', true, '37', '18');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (160, '11', 53, '2024-06-25', '2024-04-23', false, '27', '5');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (161, '31', 4, '2024-06-24', '2024-04-23', false, '28', '4');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (162, '50', 41, '2024-06-26', '2024-04-24', false, '2', '13');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (163, '9', 83, '2024-06-24', '2024-04-24', false, '19', '36');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (164, '19', 83, '2024-06-24', '2024-04-23', true, '29', '26');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (165, '6', 52, '2024-06-24', '2024-04-22', false, '43', '42');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (166, '27', 34, '2024-06-25', '2024-04-23', true, '10', '29');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (167, '36', 4, '2024-06-24', '2024-04-23', true, '7', '38');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (168, '5', 14, '2024-06-25', '2024-04-25', false, '24', '39');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (169, '45', 45, '2024-06-25', '2024-04-24', false, '11', '33');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (170, '4', 20, '2024-06-27', '2024-04-24', true, '15', '40');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (171, '22', 7, '2024-06-27', '2024-04-22', true, '4', '48');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (172, '7', 97, '2024-06-27', '2024-04-22', true, '6', '14');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (173, '48', 45, '2024-06-25', '2024-04-23', true, '33', '32');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (174, '25', 78, '2024-06-26', '2024-04-23', true, '5', '49');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (175, '26', 80, '2024-06-26', '2024-04-25', true, '21', '6');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (176, '28', 62, '2024-06-26', '2024-04-24', false, '47', '28');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (177, '39', 44, '2024-06-25', '2024-04-25', true, '45', '44');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (178, '43', 32, '2024-06-25', '2024-04-23', false, '35', '22');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (179, '42', 39, '2024-06-25', '2024-04-23', true, '12', '45');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (180, '1', 10, '2024-06-24', '2024-04-24', true, '20', '12');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (181, '49', 85, '2024-06-25', '2024-04-23', false, '30', '10');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (182, '13', 42, '2024-06-25', '2024-04-25', false, '1', '21');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (183, '33', 48, '2024-06-24', '2024-04-22', true, '26', '2');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (184, '14', 62, '2024-06-25', '2024-04-23', true, '32', '7');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (185, '38', 28, '2024-06-26', '2024-04-23', false, '9', '20');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (186, '21', 65, '2024-06-26', '2024-04-25', false, '40', '47');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (187, '46', 55, '2024-06-26', '2024-04-25', false, '17', '43');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (188, '10', 16, '2024-06-25', '2024-04-22', false, '39', '9');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (189, '32', 17, '2024-06-27', '2024-04-25', true, '13', '17');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (190, '23', 7, '2024-06-24', '2024-04-24', true, '16', '35');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (191, '37', 79, '2024-06-26', '2024-04-24', true, '8', '46');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (192, '47', 42, '2024-06-25', '2024-04-24', true, '14', '25');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (193, '20', 93, '2024-06-26', '2024-04-25', false, '42', '19');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (194, '24', 0, '2024-06-24', '2024-04-25', true, '34', '30');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (195, '8', 69, '2024-06-27', '2024-04-25', false, '25', '16');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (196, '3', 41, '2024-06-26', '2024-04-23', true, '48', '50');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (197, '29', 50, '2024-06-27', '2024-04-22', true, '18', '31');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (198, '40', 9, '2024-06-27', '2024-04-24', true, '22', '41');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (199, '18', 63, '2024-06-25', '2024-04-25', false, '41', '34');
insert into Submissions (SubmissionID, AssignmentID, Grade, GradedOn, TurnedIn, RegradeRequestStatus, SubmitBy, GradedBy) values (200, '44', 94, '2024-06-24', '2024-04-23', false, '50', '8');

-- Insert dummy data into SubmissionsComments table
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (1, 'Excellent work! Your analysis is thorough and well-supported. Keep up the great work!', '40');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (2, 'Your submission is missing some key points. Please review the assignment requirements and resubmit.', '69');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (3, 'Good effort, but your argument could be strengthened with more evidence. Consider providing additional examples or research.', '90');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (4, 'Your submission lacks clarity. Please revise for better organization and coherence.', '157');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (5, 'Well done! Your writing is clear and concise, and your analysis is insightful.', '115');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (6, 'Your submission demonstrates a strong understanding of the material. Great job!', '107');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (7, 'Your analysis is well-developed, but be sure to cite your sources properly.', '42');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (8, 'Good start, but your submission could benefit from more detail. Consider expanding on your arguments.', '150');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (9, 'Your submission is well-written and thoroughly researched. Keep up the good work!', '105');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (10, 'Your submission is strong overall, but be sure to address all aspects of the assignment prompt.', '118');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (11, 'You have a solid foundation here, but be sure to provide more analysis and interpretation.', '198');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (12, 'Your submission is well-organized and coherent. Great job!', '50');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (13, 'Your submission is insightful and demonstrates critical thinking. Well done!', '113');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (14, 'Your submission shows promise, but consider revising for clarity and precision.', '33');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (15, 'Your writing is engaging and demonstrates a strong understanding of the material.', '94');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (16, 'Your submission could benefit from deeper analysis and more original insight.', '132');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (17, 'Your submission is well-argued and supported by evidence. Great work!', '117');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (18, 'Your submission is thorough and well-written. Keep up the good work!', '98');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (19, 'Your submission demonstrates strong critical thinking skills. Well done!', '34');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (20, 'Your submission shows potential, but be sure to provide more analysis and explanation.', '68');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (21, 'Your submission could benefit from more detail and analysis. Consider revising for clarity and coherence.', '193');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (22, 'Your submission demonstrates a strong understanding of the material. Great job!', '152');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (23, 'Your analysis is well-developed and supported by evidence. Well done!', '28');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (24, 'Your submission could be improved with more detailed analysis and explanation.', '81');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (25, 'Your submission is well-written and persuasive. Keep up the good work!', '169');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (26, 'Your submission demonstrates a strong grasp of the material. Well done!', '143');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (27, 'Your analysis is insightful and well-supported. Great job!', '32');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (28, 'Your submission is well-organized and coherent. Keep up the good work!', '110');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (29, 'Your submission could benefit from more clarity and explanation. Consider revising for better coherence.', '73');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (30, 'Your analysis is well-developed and supported by evidence. Well done!', '140');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (31, 'Your submission demonstrates strong critical thinking skills. Well done!', '158');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (32, 'Your analysis is thorough and well-supported. Great job!', '57');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (33, 'Your submission is well-written and engaging. Keep up the good work!', '109');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (34, 'Your submission shows potential, but be sure to provide more analysis and interpretation.', '48');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (35, 'Your submission could benefit from more depth and analysis. Consider revising for greater insight.', '88');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (36, 'Your analysis is thorough and well-argued. Great job!', '6');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (37, 'Your submission demonstrates strong critical thinking skills. Well done!', '129');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (38, 'Your submission is well-structured and coherent. Keep up the good work!', '54');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (39, 'Your submission is insightful and well-written. Great job!', '196');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (40, 'Your submission demonstrates a solid understanding of the material. Well done!', '35');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (41, 'Your analysis is clear and well-developed. Keep up the good work!', '151');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (42, 'Your submission demonstrates a strong grasp of the material. Well done!', '83');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (43, 'Your submission could benefit from more detailed analysis and explanation. Consider revising for greater clarity.', '100');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (44, 'Your submission is well-organized and coherent. Keep up the good work!', '85');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (45, 'Your submission demonstrates a thorough understanding of the material. Great job!', '168');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (46, 'Your analysis is thorough and well-supported. Great job!', '200');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (47, 'Your submission demonstrates strong critical thinking skills. Well done!', '45');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (48, 'Your submission is well-organized and coherent. Keep up the good work!', '92');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (49, 'Your submission is well-written and engaging. Keep up the good work!', '17');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (50, 'Your submission shows potential, but be sure to provide more analysis and interpretation.', '12');

-- Insert dummy data into Enrollments table
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (1, '8/7/2023', true, 56, '7', '46', '16605');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (2, '5/16/2022', true, 65, '49', '11', '30878');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (3, '12/5/2020', false, 74, '18', '38', '47109');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (4, '6/23/2021', true, 18, '29', '21', '16981');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (5, '9/26/2021', true, 64, '6', '7', '47059');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (6, '1/28/2022', false, 15, '28', '20', '33092');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (7, '10/18/2020', false, 5, '35', '43', '19832');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (8, '10/5/2020', false, 64, '40', '45', '21638');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (9, '6/5/2022', true, 82, '11', '50', '35903');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (10, '8/24/2023', true, 91, '42', '47', '19929');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (11, '3/2/2022', true, 93, '46', '24', '46133');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (12, '8/3/2020', false, 81, '22', '19', '34455');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (13, '7/31/2020', true, 18, '43', '29', '32137');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (14, '7/19/2020', false, 51, '20', '14', '43752');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (15, '3/25/2022', false, 69, '38', '34', '33391');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (16, '9/11/2022', false, 80, '31', '5', '46028');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (17, '9/5/2023', false, 92, '36', '39', '30010');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (18, '8/19/2021', true, 13, '47', '40', '37347');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (19, '10/9/2019', true, 22, '37', '16', '40831');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (20, '12/3/2019', true, 38, '14', '26', '12479');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (21, '2/9/2022', true, 67, '25', '9', '44688');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (22, '4/26/2022', true, 15, '9', '13', '15246');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (23, '12/30/2020', false, 4, '41', '48', '18241');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (24, '8/17/2022', true, 19, '34', '41', '10802');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (25, '12/13/2020', true, 38, '30', '49', '49714');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (26, '11/7/2022', false, 23, '39', '42', '16611');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (27, '10/25/2019', false, 90, '12', '17', '35975');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (28, '7/31/2023', false, 0, '10', '23', '12703');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (29, '10/27/2020', true, 27, '16', '12', '37086');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (30, '10/26/2023', false, 32, '19', '28', '13057');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (31, '7/6/2020', true, 94, '23', '2', '29591');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (32, '10/25/2023', true, 15, '24', '18', '43907');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (33, '10/13/2021', true, 21, '8', '4', '44124');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (34, '12/24/2019', true, 12, '45', '35', '15035');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (35, '10/1/2023', false, 56, '26', '37', '25321');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (36, '5/4/2021', true, 32, '27', '30', '10412');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (37, '7/28/2021', false, 43, '4', '44', '29755');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (38, '2/3/2021', false, 23, '48', '36', '29431');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (39, '8/12/2022', false, 87, '21', '33', '38334');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (40, '11/16/2020', false, 25, '50', '32', '41844');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (41, '1/31/2021', true, 69, '5', '22', '33963');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (42, '11/9/2020', true, 4, '2', '10', '48958');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (43, '7/12/2020', false, 33, '15', '27', '42581');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (44, '9/1/2023', false, 27, '33', '15', '48885');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (45, '2/27/2020', true, 73, '17', '31', '10721');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (46, '4/22/2021', false, 5, '3', '6', '37829');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (47, '2/15/2022', false, 48, '44', '8', '19119');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (48, '2/16/2023', false, 7, '32', '25', '20164');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (49, '7/13/2022', false, 9, '1', '3', '48831');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (50, '9/10/2021', false, 67, '13', '1', '14009');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (51, '6/6/2021', false, 98, '12', '43', '49714');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (52, '11/8/2021', true, 30, '45', '8', '48831');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (53, '2/13/2021', false, 97, '30', '15', '33391');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (54, '3/27/2022', true, 6, '4', '32', '37086');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (55, '3/19/2020', false, 2, '5', '29', '15246');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (56, '4/15/2020', true, 62, '50', '28', '48885');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (57, '1/18/2021', false, 38, '9', '34', '29755');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (58, '10/13/2019', true, 48, '17', '6', '15035');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (59, '12/19/2020', true, 6, '39', '20', '34455');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (60, '3/19/2022', false, 72, '40', '31', '37347');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (61, '8/31/2023', true, 69, '23', '47', '35903');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (62, '10/10/2021', true, 86, '49', '39', '47059');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (63, '12/10/2020', false, 32, '37', '27', '29591');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (64, '12/24/2019', false, 94, '29', '24', '16981');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (65, '3/16/2022', false, 15, '8', '14', '12703');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (66, '8/8/2022', true, 63, '38', '38', '16611');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (67, '6/19/2022', true, 96, '15', '30', '25321');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (68, '2/29/2020', false, 88, '31', '40', '30878');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (69, '7/19/2022', false, 70, '28', '25', '42581');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (70, '3/9/2022', true, 96, '19', '26', '12479');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (71, '9/11/2020', true, 69, '7', '23', '32137');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (72, '10/28/2022', true, 13, '24', '48', '10721');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (73, '2/16/2021', true, 9, '27', '36', '10802');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (74, '12/29/2022', true, 92, '22', '7', '43907');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (75, '1/17/2023', true, 65, '35', '10', '38334');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (76, '3/29/2020', true, 93, '26', '44', '35975');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (77, '5/22/2022', false, 70, '11', '41', '40831');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (78, '10/8/2022', false, 100, '13', '42', '33092');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (79, '6/22/2022', true, 27, '25', '11', '46133');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (80, '2/3/2021', false, 40, '1', '2', '20164');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (81, '11/6/2021', false, 83, '32', '4', '46028');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (82, '12/30/2021', true, 48, '21', '19', '10412');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (83, '3/3/2022', false, 9, '42', '17', '13057');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (84, '9/3/2019', true, 81, '44', '5', '19929');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (85, '4/7/2023', true, 68, '14', '21', '48958');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (86, '8/2/2020', true, 69, '43', '18', '47109');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (87, '8/1/2022', true, 66, '10', '35', '29431');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (88, '9/3/2021', false, 50, '2', '12', '14009');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (89, '11/27/2022', false, 32, '16', '37', '18241');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (90, '5/23/2020', true, 59, '33', '50', '16605');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (91, '8/17/2021', false, 87, '46', '49', '19119');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (92, '9/26/2019', false, 28, '34', '45', '19832');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (93, '12/10/2022', true, 91, '6', '22', '30010');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (94, '11/15/2020', true, 77, '41', '9', '37829');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (95, '7/9/2023', true, 74, '36', '13', '21638');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (96, '3/14/2021', false, 53, '20', '46', '33963');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (97, '3/2/2020', false, 84, '3', '3', '44124');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (98, '12/27/2019', false, 92, '18', '16', '41844');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (99, '2/26/2020', true, 68, '48', '1', '44688');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (100, '10/17/2022', false, 81, '47', '33', '43752');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (101, '3/25/2020', true, 38, '21', '26', '20164');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (102, '2/6/2022', true, 24, '18', '4', '16981');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (103, '2/27/2023', false, 68, '47', '6', '46133');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (104, '2/3/2022', false, 55, '11', '32', '37829');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (105, '5/8/2020', true, 2, '33', '5', '35903');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (106, '1/26/2020', true, 85, '16', '22', '29755');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (107, '4/3/2021', true, 70, '37', '19', '19119');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (108, '4/18/2021', true, 64, '32', '50', '16605');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (109, '6/30/2022', false, 4, '12', '24', '29431');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (110, '3/30/2020', true, 99, '1', '43', '43752');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (111, '8/29/2022', true, 79, '31', '44', '15246');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (112, '1/12/2023', false, 79, '17', '28', '35975');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (113, '10/23/2020', false, 94, '13', '29', '41844');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (114, '6/11/2021', true, 30, '10', '15', '14009');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (115, '7/30/2021', false, 100, '6', '46', '30010');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (116, '11/16/2023', true, 41, '27', '41', '40831');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (117, '10/1/2021', true, 37, '28', '1', '33092');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (118, '8/31/2022', false, 57, '36', '8', '47109');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (119, '8/13/2020', false, 6, '8', '35', '12703');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (120, '6/28/2023', true, 94, '23', '47', '16611');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (121, '5/11/2020', false, 88, '40', '13', '33963');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (122, '12/22/2021', false, 74, '15', '10', '43907');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (123, '11/11/2021', false, 70, '9', '25', '19832');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (124, '7/28/2022', false, 49, '20', '3', '10802');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (125, '9/9/2020', false, 67, '38', '34', '10721');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (126, '10/31/2020', false, 32, '24', '48', '44124');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (127, '8/5/2020', false, 80, '34', '40', '15035');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (128, '1/26/2023', true, 47, '41', '12', '21638');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (129, '5/6/2023', false, 39, '49', '38', '32137');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (130, '9/28/2022', false, 19, '46', '23', '18241');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (131, '4/5/2021', false, 10, '39', '9', '48958');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (132, '11/18/2023', false, 9, '35', '30', '37347');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (133, '1/31/2021', false, 81, '19', '21', '30878');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (134, '10/29/2023', false, 79, '22', '37', '46028');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (135, '8/13/2022', true, 82, '3', '49', '33391');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (136, '4/7/2022', true, 70, '4', '14', '29591');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (137, '11/5/2023', false, 39, '44', '7', '49714');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (138, '6/19/2023', true, 59, '7', '2', '47059');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (139, '10/12/2023', true, 55, '2', '18', '34455');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (140, '10/18/2023', false, 52, '42', '20', '19929');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (141, '6/12/2020', true, 17, '29', '39', '48885');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (142, '3/15/2021', true, 92, '48', '45', '13057');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (143, '7/10/2020', false, 2, '50', '27', '37086');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (144, '8/4/2021', true, 83, '30', '17', '44688');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (145, '2/16/2023', true, 3, '14', '36', '12479');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (146, '9/17/2020', true, 69, '25', '16', '10412');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (147, '9/1/2019', false, 62, '5', '33', '48831');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (148, '9/3/2022', false, 35, '26', '11', '25321');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (149, '4/15/2023', false, 63, '43', '42', '38334');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (150, '1/22/2022', true, 36, '45', '31', '42581');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (151, '1/7/2022', true, 97, '23', '46', '14009');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (152, '7/9/2020', true, 15, '32', '7', '10802');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (153, '4/10/2022', true, 7, '15', '4', '43752');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (154, '8/29/2021', false, 69, '12', '21', '46133');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (155, '9/11/2021', true, 77, '35', '16', '12479');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (156, '4/13/2021', false, 12, '43', '29', '46028');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (157, '9/9/2023', true, 35, '38', '44', '41844');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (158, '9/4/2019', true, 78, '36', '41', '37347');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (159, '11/4/2023', false, 38, '37', '42', '33963');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (160, '12/16/2019', false, 76, '27', '37', '48885');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (161, '11/8/2019', true, 59, '9', '34', '44688');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (162, '1/11/2023', true, 62, '42', '14', '48958');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (163, '1/3/2021', true, 57, '20', '38', '37086');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (164, '6/13/2022', false, 47, '39', '10', '30878');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (165, '3/16/2023', false, 30, '1', '36', '35903');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (166, '11/8/2022', false, 5, '26', '26', '37829');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (167, '10/7/2021', true, 40, '19', '20', '21638');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (168, '6/3/2021', true, 72, '2', '47', '47059');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (169, '8/14/2022', false, 94, '45', '27', '29755');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (170, '7/8/2023', true, 85, '14', '49', '10721');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (171, '3/22/2020', false, 18, '17', '45', '29591');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (172, '4/19/2021', true, 31, '34', '24', '15246');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (173, '11/26/2019', false, 97, '7', '18', '35975');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (174, '1/11/2020', false, 35, '5', '8', '33391');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (175, '12/4/2020', false, 30, '10', '3', '16605');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (176, '4/11/2023', false, 79, '25', '39', '38334');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (177, '6/1/2023', true, 99, '50', '1', '42581');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (178, '7/6/2021', true, 48, '22', '33', '44124');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (179, '5/29/2021', true, 39, '29', '23', '34455');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (180, '3/19/2020', true, 26, '46', '13', '18241');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (181, '8/24/2023', false, 84, '24', '6', '20164');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (182, '9/6/2019', false, 33, '44', '43', '32137');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (183, '9/1/2020', true, 38, '18', '31', '30010');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (184, '5/1/2023', false, 1, '13', '32', '19119');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (185, '10/16/2022', false, 41, '40', '2', '10412');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (186, '6/9/2021', false, 20, '48', '48', '19832');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (187, '4/12/2023', false, 6, '49', '9', '49714');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (188, '2/18/2020', true, 15, '21', '5', '16981');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (189, '10/15/2023', true, 87, '4', '25', '40831');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (190, '1/19/2020', true, 41, '6', '19', '47109');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (191, '11/14/2023', false, 46, '30', '28', '12703');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (192, '2/26/2020', true, 32, '31', '40', '33092');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (193, '5/13/2022', false, 76, '28', '22', '13057');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (194, '1/18/2023', true, 77, '3', '35', '48831');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (195, '10/4/2019', false, 6, '8', '50', '43907');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (196, '9/29/2021', true, 87, '33', '30', '19929');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (197, '3/14/2023', false, 28, '41', '11', '29431');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (198, '1/24/2022', true, 8, '16', '12', '15035');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (199, '10/10/2019', false, 46, '11', '15', '16611');
insert into Enrollements (EnrollmentID, EnrollDate, Status, FinalGrade, StudentID, CoordinatorID, CRN) values (200, '12/24/2020', false, 75, '47', '17', '25321');

-- Insert dummy data into FeedbackSurveys table
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (1, 'The course material was well-organized and easy to follow. The instructor provided clear explanations and examples, which helped me understand the concepts.', '2020-05-09', '34', false, '35903');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (2, 'The assignments were challenging but engaging. They allowed me to apply what I learned in class and deepen my understanding of the subject.', '2021-12-28', '2', false, '48958');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (3, 'The professor was very knowledgeable and approachable. They encouraged discussion and created a supportive learning environment.', '2022-08-16', '39', true, '48885');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (4, 'The course structure was well-designed, and the pacing was appropriate. I appreciated the opportunities for group work and collaboration.', '2021-02-14', '36', true, '33391');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (5, 'The course content was relevant and up-to-date. The instructor shared real-world examples that made the material more engaging.', '2024-04-06', '27', true, '16611');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (6, 'The workload was manageable, and the assignments were well-structured. The feedback provided by the instructor was helpful for improving my skills.', '2021-01-06', '43', false, '40831');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (7, 'The course readings were interesting and complemented the lectures well. They provided additional insights into the topics covered in class.', '2020-10-18', '3', false, '14009');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (8, 'The instructor was enthusiastic and passionate about the subject. Their enthusiasm made the class more engaging and enjoyable.', '2022-12-18', '7', false, '10412');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (9, 'The course materials were well-curated and provided a comprehensive overview of the subject. The supplementary resources were also helpful for further exploration.', '2021-11-21', '4', false, '29591');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (10, 'The instructor was supportive and responsive to questions. They provided timely feedback on assignments, which helped me track my progress.', '2020-04-18', '16', false, '12479');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (11, 'The course covered a wide range of topics and provided a good foundation in the subject. The assignments were challenging but rewarding.', '2024-03-21', '37', false, '37829');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (12, 'The instructor was organized and well-prepared for each class. They provided clear explanations and examples, which facilitated learning.', '2022-06-21', '21', false, '44124');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (13, 'The course fostered a collaborative learning environment. The group projects allowed me to work with my peers and learn from their perspectives.', '2021-12-10', '13', false, '29431');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (14, 'The course materials were well-organized and easy to navigate. The instructor provided clear instructions, which helped me stay on track with my studies.', '2020-06-07', '19', false, '10721');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (15, 'The course content was challenging but manageable. The instructor provided ample support and resources to help us succeed.', '2021-05-06', '30', true, '48831');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (16, 'The instructor was knowledgeable and approachable. They encouraged questions and fostered a supportive learning environment.', '2022-06-18', '26', false, '43752');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (17, 'The course provided a good balance of theory and practice. The hands-on assignments helped reinforce the concepts covered in class.', '2023-05-22', '23', false, '49714');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (18, 'The course content was relevant and applicable to real-world scenarios. The instructor provided practical examples that helped me understand the material better.', '2021-02-23', '28', true, '44688');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (19, 'The instructor was engaging and encouraged participation. They created a welcoming atmosphere where everyone felt comfortable sharing their thoughts and ideas.', '2020-04-22', '25', false, '47059');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (20, 'The course was well-structured and covered all the key topics in the subject. The instructor provided clear explanations and relevant examples throughout the course.', '2023-06-06', '46', true, '43907');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (21, 'The instructor was knowledgeable and passionate about the subject. They went above and beyond to ensure that students understood the material and succeeded in the course.', '2020-11-10', '10', true, '25321');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (22, 'The course materials were comprehensive and well-presented. The instructor provided clear explanations and examples, which helped me grasp difficult concepts.', '2022-12-11', '6', true, '38334');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (23, 'The instructor was engaging and encouraged critical thinking. They challenged us to think beyond the textbook and apply our knowledge to real-world situations.', '2024-04-08', '40', false, '16605');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (24, 'The course content was relevant and up-to-date. The instructor provided clear explanations and real-world examples that made the material more engaging.', '2020-08-21', '5', false, '10802');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (25, 'The instructor was knowledgeable and approachable. They provided valuable insights and feedback that helped me improve my understanding of the subject.', '2020-09-11', '1', false, '41844');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (26, 'The course workload was manageable, and the assignments were well-structured. The instructor provided timely feedback, which helped me track my progress.', '2023-12-09', '11', true, '15246');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (27, 'The course readings were relevant and thought-provoking. They provided a deeper understanding of the topics covered in class and sparked interesting discussions.', '2021-07-28', '41', false, '30878');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (28, 'The instructor was knowledgeable and passionate about the subject. They provided valuable insights and real-world examples that enhanced my learning experience.', '2023-08-23', '45', true, '21638');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (29, 'The course provided a comprehensive overview of the subject. The instructor was supportive and provided valuable feedback throughout the course.', '2022-07-26', '24', false, '32137');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (30, 'The course content was challenging but engaging. The instructor provided clear explanations and relevant examples, which helped me understand the material better.', '2023-12-11', '31', true, '19929');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (31, 'The instructor was engaging and knowledgeable. They encouraged discussion and provided valuable insights throughout the course.', '2023-11-04', '22', false, '35975');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (32, 'The course provided a solid foundation in the subject. The instructor was supportive and provided valuable feedback on assignments.', '2021-12-11', '9', true, '37347');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (33, 'The course content was relevant and up-to-date. The instructor provided clear explanations and relevant examples that enhanced my understanding of the material.', '2023-03-05', '44', false, '13057');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (34, 'The instructor was engaging and encouraged participation. They created a collaborative learning environment where everyone felt comfortable sharing their ideas.', '2023-08-31', '50', false, '12703');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (35, 'The course was well-organized and covered all the key topics in the subject. The instructor was knowledgeable and approachable.', '2021-09-26', '20', true, '37086');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (36, 'The instructor was engaging and passionate about the subject. They provided valuable insights and created a supportive learning environment.', '2021-02-25', '15', true, '15035');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (37, 'The course content was relevant and up-to-date. The instructor provided clear explanations and relevant examples throughout the course.', '2022-04-01', '38', false, '34455');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (38, 'The course was well-structured and covered all the key topics in the subject. The instructor provided valuable insights and feedback throughout the course.', '2021-02-28', '42', false, '42581');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (39, 'The instructor was engaging and knowledgeable. They provided clear explanations and relevant examples, which helped me understand the material better.', '2023-01-14', '48', false, '46133');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (40, 'The course provided a good overview of the subject. The instructor was supportive and provided valuable feedback throughout the course.', '2022-09-28', '29', true, '19832');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (41, 'The course content was relevant and up-to-date. The instructor provided clear explanations and relevant examples that enhanced my understanding of the material.', '2022-05-21', '12', false, '46028');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (42, 'The instructor was engaging and provided valuable insights throughout the course. They encouraged discussion and created a supportive learning environment.', '2022-08-31', '35', true, '16981');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (43, 'The course materials were well-organized and easy to follow. The instructor provided clear explanations and examples, which helped me understand the concepts.', '2021-10-02', '18', true, '47109');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (44, 'The instructor was knowledgeable and approachable. They provided clear explanations and relevant examples that enhanced my understanding of the material.', '2021-11-03', '47', false, '30010');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (45, 'The course provided a good balance of theory and practice. The hands-on assignments helped reinforce the concepts covered in class.', '2024-02-11', '49', false, '33092');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (46, 'The instructor was engaging and provided valuable insights throughout the course. They encouraged discussion and created a supportive learning environment.', '2021-06-05', '32', false, '19119');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (47, 'The course provided a good overview of the subject. The instructor was supportive and provided valuable feedback throughout the course.', '2020-05-07', '33', true, '20164');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (48, 'The course materials were well-organized and easy to follow. The instructor provided clear explanations and examples, which helped me understand the concepts.', '2020-04-25', '17', true, '18241');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (49, 'The instructor was engaging and provided valuable insights throughout the course. They encouraged discussion and created a supportive learning environment.', '2023-04-08', '8', false, '29755');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (50, 'The course content was relevant and up-to-date. The instructor provided clear explanations and relevant examples throughout the course.', '2020-10-24', '14', true, '33963');

-- Insert dummy data into Chats table
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (1, 'I have a question about the material covered in class. Can you help?', '14', '40', '2024-04-10');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (2, 'Could you provide some clarification on the lecture from last week? Can we go over it?', '50', '13', '2024-04-16');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (3, 'Can you help me with the readings assigned for next week? I need some assistance.', '36', '49', '2024-02-10');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (4, 'Can you review my recent assignment and provide feedback?', '22', '2', '2024-02-29');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (5, 'I have a question about the material covered in class. Can you help?', '18', '17', '2024-03-28');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (6, 'I need some clarification on the lecture from last week. Could we go over it?', '8', '37', '2023-10-15');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (7, 'Can you provide feedback on my recent assignment?', '46', '24', '2023-11-13');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (8, 'I have a question about the upcoming exam. Can you help me understand the format?', '7', '14', '2024-01-14');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (9, 'I need assistance with the project requirements. Can we discuss them?', '15', '7', '2024-02-04');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (10, 'Could you provide some guidance on the research paper topic?', '32', '42', '2024-03-18');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (11, 'I have questions about the readings assigned for next week. Can we review them?', '49', '19', '2023-11-12');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (12, 'I am unsure about the instructions for the lab. Could you clarify?', '19', '34', '2023-10-10');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (13, 'I have a question regarding the course schedule. Can you provide some information?', '30', '21', '2023-09-07');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (14, 'Can you give me some pointers on how to approach the assignment?', '16', '1', '2024-03-25');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (15, 'I need assistance with the material covered in class. Can you explain it further?', '13', '25', '2024-04-18');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (16, 'I need clarification on the topic we discussed last week. Can we revisit it?', '33', '11', '2024-01-14');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (17, 'Can you help me understand the concept we covered in the lecture?', '12', '12', '2024-04-24');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (18, 'I am unsure about the requirements for the upcoming assignment. Could you explain them?', '17', '43', '2024-01-14');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (19, 'Can you provide guidance on the project guidelines?', '21', '47', '2023-12-16');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (20, 'I have questions about the readings for next week. Can you clarify?', '34', '16', '2024-01-22');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (21, 'I need assistance with the assignment instructions. Can you help?', '2', '38', '2024-02-18');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (22, 'Can you explain the topic we covered in class yesterday? I am having trouble understanding it.', '20', '26', '2024-04-05');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (23, 'I am confused about the material from the last lecture. Can you provide some clarification?', '3', '36', '2023-09-19');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (24, 'Can you review my recent assignment and provide feedback?', '41', '20', '2023-11-22');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (25, 'I need guidance on how to approach the upcoming exam. Can you help me?', '42', '28', '2024-03-22');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (26, 'I am having difficulty understanding the topic. Can you explain it again?', '40', '8', '2023-12-17');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (27, 'I am confused about the instructions for the assignment. Can you clarify them?', '27', '41', '2023-09-26');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (28, 'Can you provide some guidance on the research paper topic?', '44', '44', '2023-10-08');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (29, 'I have questions about the readings assigned for next week. Can we review them?', '10', '46', '2023-11-15');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (30, 'I am unsure about the requirements for the upcoming assignment. Could you explain them?', '37', '35', '2023-12-06');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (31, 'Can you help me understand the concept we covered in the lecture?', '39', '29', '2024-03-31');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (32, 'I need assistance with the material covered in class. Can you explain it further?', '26', '4', '2023-11-20');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (33, 'Can you give me some pointers on how to approach the assignment?', '29', '27', '2023-12-07');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (34, 'I am unsure about the topic we discussed last week. Can you provide some clarification?', '25', '39', '2024-03-29');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (35, 'Can you help me with the readings assigned for next week? I need some assistance.', '5', '9', '2024-01-29');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (36, 'Could you provide some clarification on the lecture from last week? Can we go over it?', '24', '32', '2024-02-12');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (37, 'I am confused about the material from the last lecture. Can you provide some clarification?', '48', '23', '2024-01-28');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (38, 'Can you review my recent assignment and provide feedback?', '37', '35', '2023-12-06');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (39, 'I need assistance with the material covered in class. Can you explain it further?', '39', '29', '2024-03-31');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (40, 'Can you help me understand the concept we covered in the lecture?', '26', '4', '2023-11-20');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (41, 'I need assistance with the assignment instructions. Can you help?', '29', '27', '2023-12-07');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (42, 'I am unsure about the topic we discussed last week. Can you provide some clarification?', '25', '39', '2024-03-29');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (43, 'Can you help me with the readings assigned for next week? I need some assistance.', '5', '9', '2024-01-29');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (44, 'Could you provide some clarification on the lecture from last week? Can we go over it?', '24', '32', '2024-02-12');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (45, 'I am confused about the material from the last lecture. Can you provide some clarification?', '48', '23', '2024-01-28');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (46, 'Can you review my recent assignment and provide feedback?', '37', '35', '2023-12-06');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (47, 'I need assistance with the material covered in class. Can you explain it further?', '39', '29', '2024-03-31');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (48, 'Can you help me understand the concept we covered in the lecture?', '26', '4', '2023-11-20');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (49, 'I need assistance with the assignment instructions. Can you help?', '29', '27', '2023-12-07');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (50, 'I am unsure about the topic we discussed last week. Can you provide some clarification?', '25', '39', '2024-03-29');

-- Insert dummy data into ChatReplies table
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (1, '13', '18', '45', '2023-12-23', 'I can provide assistance. Would you like an explanation?');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (2, '50', '30', '1', '2024-01-31', 'I comprehend your confusion. Shall we discuss it further?');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (3, '23', '15', '50', '2023-09-30', 'I am available to help.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (4, '44', '7', '19', '2023-12-23', 'I am capable of providing guidance. Let us review together.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (5, '4', '48', '48', '2024-04-01', 'I can offer assistance with that. Would you like to discuss further?');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (6, '38', '6', '39', '2024-02-18', 'I am available for assistance. Shall we proceed?');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (7, '2', '27', '3', '2024-01-22', 'I understand your concern. Let us explore solutions together.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (8, '6', '40', '4', '2024-03-26', 'I am ready to assist. How can I help you?');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (9, '30', '19', '13', '2024-04-11', 'I can explain that further. Do you need clarification?');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (10, '5', '48', '24', '2024-03-18', 'I am here to help. Let us discuss.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (11, '31', '23', '38', '2024-01-03', 'I understand your concern. Let me provide some insights.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (12, '33', '14', '36', '2023-10-02', 'I am here to help. What do you need assistance with?');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (13, '17', '37', '29', '2023-12-15', 'I am available to help. Let us proceed.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (14, '43', '44', '48', '2024-01-15', 'I can assist with that. Would you like more information?');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (15, '9', '41', '13', '2024-01-06', 'I am available to assist. Let us find a solution.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (16, '32', '3', '50', '2024-03-16', 'I am available to help. Let me provide some guidance.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (17, '11', '47', '9', '2023-12-02', 'I am here to help. Let me know what you need.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (18, '14', '18', '23', '2024-04-16', 'I am here to assist. Shall we proceed?');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (19, '47', '10', '2', '2024-02-09', 'I am available to help. What do you need assistance with?');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (20, '40', '26', '17', '2024-02-06', 'I am here to help. Let us work on this together.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (21, '15', '16', '26', '2023-10-18', 'I can provide assistance. Would you like more information?');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (22, '46', '43', '22', '2023-12-07', 'I am available to assist. Let me know what you need.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (23, '37', '50', '16', '2023-09-17', 'I am here to help. Let me provide some guidance.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (24, '29', '36', '32', '2023-11-18', 'I am available to assist. Let us proceed.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (25, '18', '49', '13', '2023-09-20', 'I am here to help. Let me provide some insights.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (26, '24', '25', '36', '2023-10-08', 'I am available to assist. What do you need assistance with?');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (27, '49', '13', '26', '2023-10-06', 'I am here to assist. Let us work on this together.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (28, '22', '41', '19', '2024-04-23', 'I am available to assist. Let me know what you need.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (29, '19', '4', '1', '2023-12-02', 'I am available to help. Would you like to discuss this further?');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (30, '12', '34', '38', '2024-03-24', 'I am available to assist. What do you need help with?');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (31, '48', '9', '21', '2023-11-16', 'I am here to help. Let us discuss this further.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (32, '28', '50', '28', '2024-01-12', 'I am available to assist. Let me provide some guidance.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (33, '34', '5', '32', '2024-02-22', 'I am available to help. Shall we discuss further?');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (34, '10', '48', '5', '2023-10-06', 'I am here to help. Let us discuss this further.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (35, '25', '36', '14', '2024-04-16', 'I am available to assist. Let us work on this together.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (36, '7', '21', '20', '2023-12-14', 'I am here to assist. Let us discuss this further.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (37, '21', '30', '26', '2024-01-22', 'I am available to assist. Let me provide some guidance.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (38, '1', '4', '10', '2024-04-23', 'I am available to assist. Let us work on this together.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (39, '8', '46', '35', '2024-02-17', 'I am here to help. Shall we discuss further?');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (40, '41', '35', '45', '2023-10-12', 'I am available to assist. Let me provide some guidance.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (41, '35', '8', '47', '2024-04-14', 'I am available to help. Shall we discuss further?');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (42, '27', '1', '27', '2023-09-09', 'I am here to assist. Let me know what you need.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (43, '20', '38', '50', '2024-01-27', 'I am available to help. Would you like to discuss this further?');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (44, '39', '16', '14', '2023-12-10', 'I am available to help. Shall we discuss further?');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (45, '16', '18', '14', '2023-12-26', 'I am here to assist. Let us work on this together.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (46, '3', '37', '2', '2023-10-24', 'I am available to assist. Let me provide some guidance.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (47, '36', '21', '9', '2024-04-22', 'I am here to help. Shall we discuss further?');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (48, '45', '1', '20', '2023-10-06', 'I am available to assist. Let me provide some guidance.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (49, '26', '29', '14', '2024-01-15', 'I am here to help. Let us discuss this further.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (50, '42', '41', '33', '2024-03-30', 'I am available to assist. Let me know what you need.');

-- Insert dummy data into DiscussionPosts table
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (1, '35975', '11', 'A Comparative Analysis of Economic Policies in Developing Countries', 'Globalization has facilitated interconnectedness and cultural exchange on a global scale. However, it has also raised concerns about the erosion of cultural identities. This discussion seeks to conduct a comparative analysis of economic policies in developing countries, including the dynamics of world trade, inflation, and fiscal and monetary policies.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (2, '44124', '20', 'The Impact of Climate Change on Agricultural Practices', 'Climate change poses significant risks to global health, including the spread of infectious diseases, food and water insecurity, and extreme weather events. This discussion seeks to examine the agricultural impacts of climate change and discuss strategies for building climate-resilient food systems. Join us to explore the intersection of climate change and agriculture.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (3, '19832', '45', 'Exploring the Role of Social Media in Modern Society', 'In the era of digitalization, social media platforms have become integral to modern society. This discussion aims to delve into their multifaceted roles and impacts on individuals, communities, and institutions. From facilitating communication to shaping public opinion, social media has reshaped various aspects of our lives. Let us explore further.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (4, '48831', '2', 'The Importance of Cultural Diversity in Global Business', 'In an interconnected world, cultural diversity plays a crucial role in global business. It goes beyond mere tolerance and encompasses understanding, appreciation, and leveraging diverse perspectives. This discussion seeks to explore how embracing cultural diversity can foster innovation, enhance market reach, and promote sustainable business practices.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (5, '19119', '34', 'The Psychological Effects of Social Media Usage Among Teenagers', 'The widespread use of social media among teenagers has raised concerns about its potential psychological effects. From influencing self-esteem to shaping social interactions, social media platforms wield significant influence over adolescent behavior and mental well-being. Let us delve into this topic to gain deeper insights.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (6, '14009', '27', 'The Impact of Artificial Intelligence on the Future of Work', 'The advent of artificial intelligence (AI) has sparked debates about its implications for the future of work. While some foresee job displacement and automation, others envision new opportunities and efficiencies. This discussion aims to explore the various dimensions of AI impact on employment, skills development, and labor markets. Join us to delve into this timely and critical issue.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (7, '10412', '43', 'The Ethical Considerations of Genetic Engineering', 'Advancements in genetic engineering have opened up new possibilities in medicine, agriculture, and beyond. However, along with these opportunities come ethical dilemmas and concerns. This discussion seeks to examine the ethical implications of genetic engineering practices such as gene editing, cloning, and genetic modification. Join us to explore the ethical considerations shaping the future of biotechnology.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (8, '33092', '1', 'The Future of Renewable Energy Technologies', 'The transition to renewable energy sources is essential for mitigating climate change and ensuring energy security. This discussion aims to explore the latest developments and innovations in renewable energy technologies, from solar and wind power to biofuels and geothermal energy. Join us to discuss the potential of renewable energy to reshape the global energy landscape.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (9, '19929', '10', 'The Impact of Globalization on Cultural Identity', 'Globalization has facilitated interconnectedness and cultural exchange on a global scale. However, it has also raised concerns about the erosion of cultural identities. This discussion seeks to examine the impact of globalization on cultural identity, including the dynamics of cultural homogenization, hybridization, and resistance. Join us to explore the complexities of cultural identity in a globalized world.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (10, '21638', '44', 'The Role of Education in Socioeconomic Development', 'Education is widely recognized as a key driver of socioeconomic development and upward mobility. This discussion aims to explore the multifaceted role of education in fostering economic growth, reducing poverty, and promoting social equity. Join us to discuss strategies for enhancing access to quality education and its transformative potential.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (11, '29755', '30', 'The Impact of Urbanization on Environmental Sustainability', 'Rapid urbanization poses significant challenges to environmental sustainability, including increased resource consumption, pollution, and habitat destruction. This discussion seeks to explore the environmental impacts of urbanization and discuss strategies for creating sustainable and resilient cities. Join us to examine the complex relationship between urban development and environmental conservation.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (12, '37829', '48', 'The Future of Healthcare Technology', 'Advancements in healthcare technology are revolutionizing the diagnosis, treatment, and management of diseases. From telemedicine and wearable devices to artificial intelligence and genomics, this discussion aims to explore the potential of technology to transform healthcare delivery and improve patient outcomes. Join us to envision the future of healthcare in the digital age.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (13, '29431', '41', 'The Impact of Social Media on Political Discourse', 'Social media platforms have emerged as influential spaces for political discourse, activism, and mobilization. This discussion seeks to examine the role of social media in shaping public opinion, political participation, and democratic processes. Join us to explore the opportunities and challenges of navigating the digital public sphere.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (14, '32137', '16', 'The Ethical Implications of Artificial Intelligence', 'The rapid development of artificial intelligence (AI) raises ethical questions about accountability, bias, and privacy. This discussion aims to explore the ethical dilemmas inherent in AI systems, including issues of fairness, transparency, and algorithmic decision-making. Join us to engage in a thought-provoking conversation about the ethics of AI.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (15, '33391', '46', 'The Importance of Mental Health Awareness', 'Mental health awareness is critical for promoting well-being and reducing stigma surrounding mental illness. This discussion seeks to raise awareness about mental health issues, provide resources for support and advocacy, and foster open dialogue about mental health challenges. Join us to prioritize mental health and support each other in our journey toward mental wellness.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (16, '46133', '17', 'The Impacts of Artificial Intelligence on Job Markets', 'The rise of artificial intelligence (AI) technologies is reshaping job markets and employment dynamics worldwide. This discussion aims to explore the potential impacts of AI on job creation, displacement, and skill requirements across various sectors. Join us to discuss strategies for navigating the evolving landscape of work in the age of AI.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (17, '34455', '15', 'The Role of Women in STEM Fields', 'Women have historically been underrepresented in science, technology, engineering, and mathematics (STEM) fields. This discussion seeks to examine the barriers facing women in STEM, celebrate their achievements and contributions, and advocate for gender equity in STEM education and careers. Join us to empower women in STEM and build inclusive and diverse scientific communities.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (18, '43752', '8', 'The Future of Work in the Gig Economy', 'The gig economy is reshaping traditional employment models and labor relations. This discussion aims to explore the opportunities and challenges of gig work, including issues of job security, benefits, and worker rights. Join us to discuss the implications of the gig economy for workers, businesses, and society at large.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (19, '16605', '21', 'The Impact of Artificial Intelligence on Education', 'Artificial intelligence (AI) technologies have the potential to transform education by personalizing learning experiences, automating administrative tasks, and enabling new forms of assessment. This discussion seeks to explore the opportunities and challenges of integrating AI into educational settings. Join us to envision the future of AI-enhanced learning.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (20, '47109', '36', 'The Role of Technology in Environmental Conservation', 'Technology has emerged as a powerful tool for environmental conservation, from satellite imaging and data analytics to IoT sensors and blockchain. This discussion aims to explore how technology can be leveraged to monitor and protect ecosystems, mitigate climate change, and promote sustainable resource management. Join us to discuss innovative tech solutions for environmental challenges.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (21, '40831', '32', 'The Impact of Social Media on Youth Culture', 'Social media platforms have become central to youth culture, influencing socialization, self-expression, and identity formation. This discussion seeks to examine the role of social media in shaping youth culture and values, including trends in digital communication, content consumption, and online activism. Join us to explore the digital landscape of modern youth.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (22, '41844', '23', 'The Ethical Considerations of Biomedical Research', 'Biomedical research raises ethical questions about informed consent, privacy, and the use of human subjects. This discussion aims to explore the ethical principles and guidelines that govern biomedical research practices, including issues of justice, beneficence, and respect for persons. Join us to navigate the complex terrain of biomedical ethics.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (23, '12479', '5', 'The Future of Space Exploration', 'Space exploration holds promise for scientific discovery, technological innovation, and human exploration beyond Earth. This discussion seeks to explore the future of space exploration, including missions to Mars, the Moon, and beyond. Join us to discuss the challenges and opportunities of venturing into the final frontier.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (24, '35903', '31', 'The Role of Artificial Intelligence in Healthcare', 'Artificial intelligence (AI) is revolutionizing healthcare by enabling precision medicine, medical imaging analysis, and predictive analytics. This discussion aims to explore the potential of AI to improve patient care, enhance clinical decision-making, and optimize healthcare delivery. Join us to envision the future of AI-powered healthcare.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (25, '15246', '3', 'The Implications of Blockchain Technology for Financial Services', 'Blockchain technology has the potential to disrupt traditional financial services by enabling secure and transparent transactions without intermediaries. This discussion seeks to explore the applications of blockchain in banking, payments, and asset management, as well as its implications for financial inclusion and regulatory frameworks. Join us to discuss the transformative power of blockchain in finance.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (26, '16981', '42', 'The Impact of Social Media on Mental Health', 'The pervasive use of social media has raised concerns about its effects on mental health and well-being. This discussion aims to explore the relationship between social media use and mental health outcomes, including issues of addiction, self-esteem, and social comparison. Join us to discuss strategies for promoting positive online experiences and supporting mental health in the digital age.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (27, '28755', '14', 'The Future of Autonomous Vehicles', 'Autonomous vehicles have the potential to revolutionize transportation systems, with implications for safety, efficiency, and urban planning. This discussion seeks to explore the technological advancements and regulatory challenges shaping the future of autonomous mobility. Join us to envision a world where cars drive themselves and mobility is redefined.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (28, '31478', '24', 'The Role of Technology in Disaster Management', 'Technology plays a crucial role in disaster management, from early warning systems and risk assessment tools to crisis mapping and communication platforms. This discussion aims to explore how technology can enhance preparedness, response, and recovery efforts in the face of natural and man-made disasters. Join us to discuss innovative tech solutions for building resilient communities.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (29, '25237', '7', 'The Impacts of Climate Change on Global Health', 'Climate change poses significant risks to global health, including the spread of infectious diseases, food and water insecurity, and extreme weather events. This discussion seeks to examine the health impacts of climate change and discuss strategies for building climate-resilient health systems. Join us to explore the intersection of climate change and public health.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (30, '38462', '18', 'The Future of Work: Remote vs. Office-based', 'The COVID-19 pandemic has accelerated the shift toward remote work, raising questions about the future of work environments. This discussion aims to compare the benefits and challenges of remote work versus office-based work, including considerations of productivity, work-life balance, and organizational culture. Join us to discuss the evolving nature of work in a post-pandemic world.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (31, '18241', '40', 'The Rise of E-Learning: Challenges and Opportunities', 'The COVID-19 pandemic has accelerated the adoption of e-learning platforms, but it has also highlighted challenges such as the digital divide and the need for effective online teaching methods. This discussion seeks to explore the future of e-learning, including opportunities for innovation and strategies for addressing accessibility and equity issues. Join us to discuss the evolving landscape of education in the digital age.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (32, '48885', '47', 'The Role of Robotics in Industry 4.0', 'Robotics is playing an increasingly important role in Industry 4.0, with applications ranging from manufacturing and logistics to healthcare and agriculture. This discussion aims to explore the impact of robotics on the future of work, including implications for employment, skills development, and workplace safety. Join us to discuss the opportunities and challenges of integrating robotics into the workforce.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (33, '33963', '38', 'The Future of Urban Mobility: Trends and Innovations', 'Urban mobility is undergoing a transformation with the rise of shared mobility services, electric vehicles, and smart city technologies. This discussion seeks to explore emerging trends and innovations in urban transportation, including the shift toward sustainable and inclusive mobility solutions. Join us to envision the future of getting around in cities.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (34, '10802', '35', 'The Impact of Data Science on Business Decision-Making', 'Data science is revolutionizing business decision-making by enabling organizations to extract insights from large and complex datasets. This discussion aims to explore how data science techniques such as machine learning and predictive analytics are reshaping industries and driving innovation. Join us to discuss the opportunities and challenges of harnessing the power of data for strategic decision-making.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (35, '30878', '12', 'The Role of Artificial Intelligence in Personalized Medicine', 'Artificial intelligence (AI) holds promise for personalized medicine by analyzing patient data to tailor treatments and predict outcomes. This discussion seeks to explore the applications of AI in healthcare, including precision oncology, drug discovery, and virtual health assistants. Join us to discuss how AI is transforming the future of healthcare delivery.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (36, '13057', '19', 'The Future of Energy: Renewable Technologies and Sustainable Practices', 'The transition to renewable energy sources and sustainable practices is essential for mitigating climate change and ensuring energy security. This discussion aims to explore the latest advancements in renewable technologies, energy storage, and smart grids, as well as policy and market trends shaping the energy transition. Join us to discuss the path toward a clean and sustainable energy future.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (37, '15035', '50', 'The Ethical Implications of Artificial Intelligence', 'Artificial intelligence (AI) raises ethical questions about bias, accountability, and the impact on society. This discussion seeks to explore the ethical challenges posed by AI technologies, including concerns about privacy, fairness, and the potential for job displacement. Join us to discuss how we can ensure that AI is developed and deployed responsibly.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (38, '20164', '18', 'The Role of Technology in Addressing Social Inequality', 'Technology has the potential to address social inequality by expanding access to education, healthcare, and economic opportunities. This discussion aims to explore how technology can be leveraged to bridge the digital divide, empower marginalized communities, and promote social justice. Join us to discuss strategies for harnessing technology for a more equitable society.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (39, '43907', '33', 'The Future of Privacy in the Digital Age', 'The proliferation of digital technologies has raised concerns about privacy rights and data protection. This discussion seeks to explore the challenges and opportunities of safeguarding privacy in the digital age, including issues of surveillance, data ownership, and regulatory frameworks. Join us to discuss the evolving landscape of privacy in an increasingly connected world.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (40, '44688', '22', 'The Impact of Automation on the Future of Work', 'Automation technologies are reshaping the labor market by automating routine tasks and augmenting human capabilities. This discussion aims to explore the potential impacts of automation on employment trends, job displacement, and the skills required for the future workforce. Join us to discuss how we can prepare for the changing nature of work in the age of automation.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (41, '10721', '13', 'The Role of Artificial Intelligence in Education', 'Artificial intelligence (AI) holds promise for transforming education by personalizing learning experiences, automating administrative tasks, and providing adaptive feedback. This discussion seeks to explore the applications of AI in education, including intelligent tutoring systems, learning analytics, and virtual classrooms. Join us to discuss the potential of AI to revolutionize teaching and learning.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (42, '25321', '39', 'The Impacts of Cybersecurity Threats on Society', 'Cybersecurity threats pose significant risks to individuals, businesses, and governments, including data breaches, ransomware attacks, and cyber espionage. This discussion aims to explore the societal impacts of cybersecurity threats, including implications for privacy, national security, and economic stability. Join us to discuss strategies for enhancing cybersecurity resilience and protecting against emerging threats.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (43, '47059', '24', 'The Future of Artificial Intelligence in Entertainment', 'Artificial intelligence (AI) is revolutionizing the entertainment industry by enabling personalized content recommendations, immersive experiences, and content creation tools. This discussion seeks to explore the applications of AI in entertainment, including virtual reality, algorithmic music composition, and deepfake technology. Join us to discuss the intersection of AI and creativity in entertainment.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (44, '30010', '49', 'The Role of Technology in Mental Health Care', 'Technology has the potential to transform mental health care by increasing access to services, improving diagnostics, and providing support tools for individuals with mental illnesses. This discussion aims to explore the applications of technology in mental health care, including teletherapy, digital therapeutics, and mental health apps. Join us to discuss how technology can be used to promote mental well-being and reduce stigma around mental illness.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (45, '49714', '14', 'The Future of Space Exploration: Challenges and Opportunities', 'Space exploration is entering a new era with plans for human missions to Mars, commercial space tourism, and the search for extraterrestrial life. This discussion seeks to explore the challenges and opportunities of space exploration, including technological barriers, international cooperation, and ethical considerations. Join us to discuss the next frontier of human exploration beyond Earth.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (46, '42581', '7', 'The Impact of Social Media on Mental Well-Being', 'Social media platforms have become integral parts of our daily lives, but they also raise concerns about their impact on mental health and well-being. This discussion aims to explore the effects of social media on self-esteem, relationships, and mental health outcomes. Join us to discuss strategies for promoting positive online experiences and supporting mental health in the digital age.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (47, '48958', '6', 'The Future of Autonomous Vehicles', 'Autonomous vehicles have the potential to revolutionize transportation systems, with implications for safety, efficiency, and urban planning. This discussion seeks to explore the technological advancements and regulatory challenges shaping the future of autonomous mobility. Join us to envision a world where cars drive themselves and mobility is redefined.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (48, '37347', '9', 'The Role of Technology in Disaster Management', 'Technology plays a crucial role in disaster management, from early warning systems and risk assessment tools to crisis mapping and communication platforms. This discussion aims to explore how technology can enhance preparedness, response, and recovery efforts in the face of natural and man-made disasters. Join us to discuss innovative tech solutions for building resilient communities.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (49, '12703', '29', 'The Impacts of Climate Change on Global Health', 'Climate change poses significant risks to global health, including the spread of infectious diseases, food and water insecurity, and extreme weather events. This discussion seeks to examine the health impacts of climate change and discuss strategies for building climate-resilient health systems. Join us to explore the intersection of climate change and public health.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (50, '29591', '26', 'The Future of Work: Remote vs. Office-based', 'The COVID-19 pandemic has accelerated the shift toward remote work, raising questions about the future of work environments. This discussion aims to compare the benefits and challenges of remote work versus office-based work, including considerations of productivity, work-life balance, and organizational culture. Join us to discuss the evolving nature of work in a post-pandemic world.');

-- Insert dummy data into DiscussionPostComments table
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (1, '9', '1', '2023-10-08', 'I think the discussion on technology in disaster management is crucial. We have seen how technology can play a significant role in early warning systems and coordinating relief efforts during natural disasters like hurricanes and earthquakes. It would be interesting to explore further how emerging technologies like AI and drones can improve disaster response and recovery processes.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (2, '13', '48', '2023-11-18', 'I agree with the points made about the ethical implications of AI. As AI becomes more integrated into various aspects of our lives, it is essential to consider how it can impact privacy, fairness, and autonomy. Developing robust ethical frameworks and regulations will be key to ensuring that AI technologies are deployed responsibly and ethically.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (3, '31', '11', '2023-09-29', 'The rise of e-learning platforms indeed presents both challenges and opportunities for education. While it offers flexibility and access to a wide range of resources, it also requires addressing issues like the digital divide and ensuring the quality of online instruction. I am interested in discussing strategies for making e-learning more inclusive and effective for all learners.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (4, '32', '47', '2023-10-12', 'Robotics in Industry 4.0 is a fascinating topic! I believe it has the potential to enhance efficiency and safety in various sectors. However, we must also consider the implications for employment and the need for upskilling workers to adapt to these technological changes. Exploring the balance between automation and human labor is crucial for the future of work.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (5, '22', '44', '2023-11-19', 'The discussion on the impact of automation on the future of work resonates with me. As we see more tasks being automated, it raises questions about the skills that will be in demand in the future job market. I think it is essential for educational institutions and policymakers to prepare individuals for this shift by emphasizing skills like critical thinking, creativity, and adaptability.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (6, '18', '9', '2024-04-05', 'The role of technology in addressing social inequality is a crucial topic. While technology has the potential to bridge gaps in access to education and healthcare, we must also be mindful of creating equitable opportunities for all. This discussion could explore initiatives aimed at empowering marginalized communities through technology, such as digital literacy programs and community-led tech initiatives.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (7, '33', '15', '2024-04-15', 'I am intrigued by the future of urban mobility and the shift toward sustainable transportation solutions. As cities grow and populations increase, finding ways to reduce congestion and pollution becomes increasingly important. I believe smart city technologies and innovations like electric scooters and bike-sharing programs can play a significant role in creating more livable and eco-friendly urban environments.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (8, '1', '31', '2024-01-13', 'The future of energy is a topic that impacts us all. As we move towards renewable energy sources, it is essential to consider the challenges and opportunities associated with this transition. I am particularly interested in discussing innovations in energy storage and grid technologies that can support the integration of renewables into existing infrastructure.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (9, '38', '45', '2023-12-09', 'Privacy in the digital age is a complex issue that requires careful consideration. With the increasing amount of personal data being collected and shared online, it is crucial to establish robust data protection mechanisms and empower individuals to control their own data. I am interested in exploring how emerging technologies like blockchain and differential privacy can enhance privacy rights in the digital era.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (10, '5', '5', '2023-10-08', 'The future of personalized medicine with AI is an exciting frontier in healthcare. By leveraging patient data and machine learning algorithms, we can tailor treatments to individual needs and improve patient outcomes. However, ensuring the accuracy and ethical use of AI in healthcare will be paramount to its success. I look forward to discussing the opportunities and challenges of integrating AI into medical practice.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (11, '50', '8', '2024-01-12', 'The discussion on remote work versus office-based work is particularly relevant in the modern world. While remote work offers flexibility and can improve work-life balance, it also presents challenges like maintaining team cohesion and combating feelings of isolation. I believe a hybrid approach that combines the best of both worlds could be the future of work for many organizations.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (12, '17', '6', '2023-10-09', 'The impacts of cybersecurity threats on society cannot be overstated. As our lives become increasingly digitized, the risks of cyberattacks on individuals, businesses, and critical infrastructure continue to grow. I am interested in discussing strategies for improving cybersecurity awareness and resilience at both the individual and organizational levels.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (13, '40', '20', '2024-01-09', 'The impact of automation on the future of work is a topic that I am passionate about. While automation has the potential to increase efficiency and productivity, it also raises concerns about job displacement and income inequality. I believe it is essential for policymakers to implement measures like universal basic income and lifelong learning programs to support workers during this transition.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (14, '7', '29', '2024-04-04', 'The discussion on the impact of social media on mental well-being is timely and important. While social media can connect people and facilitate communication, it also has negative effects on mental health, such as fostering feelings of inadequacy and anxiety. I am interested in exploring strategies for promoting digital well-being and creating healthier online environments.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (15, '2', '26', '2023-09-13', 'I am interested in the role of artificial intelligence in personalized medicine. As our understanding of genetics and disease mechanisms improves, AI has the potential to revolutionize healthcare by enabling more precise diagnoses and treatments. However, we must address ethical and privacy concerns to ensure that AI technologies benefit patients without compromising their rights or safety.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (16, '48', '37', '2024-02-22', 'The integration of technology in disaster management is crucial for improving response and recovery efforts. By leveraging data analytics, IoT devices, and AI-powered prediction models, we can enhance early warning systems and decision-making processes during emergencies. I am excited to explore how these technologies can make our communities more resilient to disasters of all kinds.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (17, '16', '2', '2023-10-09', 'The discussion on the future of space exploration is fascinating. With advancements in propulsion technology and the increasing interest from both government agencies and private companies, we are on the brink of a new era of space exploration. I am curious to learn more about the challenges and opportunities of sending humans to Mars and beyond.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (18, '45', '40', '2023-12-12', 'The future of autonomous vehicles is an exciting frontier in transportation. While self-driving cars hold the promise of improving road safety and reducing traffic congestion, there are still many technical and regulatory hurdles to overcome. I am interested in discussing the potential societal impacts of widespread adoption of autonomous vehicles and how we can address them proactively.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (19, '8', '43', '2023-11-03', 'The discussion on the impacts of climate change on global health is incredibly important. As temperatures rise and extreme weather events become more frequent, we are likely to see an increase in diseases, food shortages, and displacement of vulnerable populations. I believe urgent action is needed to mitigate these impacts and build resilient health systems that can adapt to a changing climate.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (20, '39', '14', '2023-10-27', 'The future of work in a post-pandemic world is a topic that interests me greatly. The shift towards remote work during the COVID-19 pandemic has highlighted the importance of flexibility and adaptability in the workplace. I believe organizations that embrace remote work and invest in digital infrastructure will be better positioned to attract top talent and remain competitive in the future job market.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (21, '3', '21', '2024-02-15', 'I am intrigued by the potential of telemedicine to improve access to healthcare services, particularly in underserved areas. By leveraging digital technologies like video conferencing and remote monitoring devices, we can overcome geographical barriers and connect patients with healthcare providers more efficiently. I am interested in discussing the challenges and opportunities of implementing telemedicine on a larger scale.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (22, '27', '50', '2024-04-09', 'The future of work is a topic that is top of mind for many people, especially with the rise of automation and AI. While these technologies have the potential to increase productivity and efficiency, they also raise concerns about job displacement and inequality. I believe it is essential for policymakers and businesses to prioritize reskilling and upskilling initiatives to ensure that workers are prepared for the jobs of the future.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (23, '34', '24', '2023-12-30', 'The discussion on climate change and its impacts on global health is critically important. As temperatures rise and extreme weather events become more frequent, we are likely to see an increase in heat-related illnesses, infectious diseases, and malnutrition. I believe it is essential for governments and healthcare systems to prioritize adaptation and mitigation strategies to protect public health in a changing climate.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (24, '24', '25', '2023-12-29', 'I am interested in the role of technology in disaster management, particularly in the context of natural disasters like hurricanes and earthquakes. By leveraging data analytics, remote sensing technologies, and predictive modeling, we can improve early warning systems and response efforts. I believe it is essential to invest in these technologies to build more resilient communities and save lives during emergencies.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (25, '6', '19', '2024-02-21', 'The future of space exploration is an exciting topic that holds immense potential for scientific discovery and innovation. With plans for missions to Mars and beyond, we are on the brink of a new era of human exploration in space. I am curious to learn more about the technological advancements and challenges involved in sending humans to other planets and how we can overcome them.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (26, '19', '30', '2024-01-07', 'The impacts of social media on mental well-being are a growing concern in a digital age. While social media platforms offer opportunities for connection and community, they also present risks to mental health, such as cyberbullying and social comparison. I am interested in discussing strategies for promoting positive online experiences and supporting mental health in the age of social media.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (27, '10', '33', '2023-11-10', 'The future of autonomous vehicles is a fascinating topic with far-reaching implications for transportation, urban planning, and sustainability. While self-driving cars offer the potential to reduce traffic accidents and congestion, they also raise questions about safety, liability, and job displacement. I am curious to explore how policymakers and industry stakeholders are addressing these challenges and shaping the future of mobility.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (28, '23', '23', '2023-10-16', 'The discussion on the role of technology in disaster management is particularly relevant given the increasing frequency and severity of natural disasters worldwide. By leveraging technologies like AI, remote sensing, and drones, we can improve disaster preparedness, response, and recovery efforts. I believe it is essential for governments and humanitarian organizations to invest in these technologies to save lives and mitigate the impact of disasters on vulnerable communities.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (29, '43', '16', '2024-01-29', 'The discussion on the impacts of climate change on global health is critically important. As temperatures rise and extreme weather events become more frequent, we are likely to see an increase in heat-related illnesses, infectious diseases, and food insecurity. I believe it is essential for policymakers and healthcare systems to prioritize adaptation and mitigation strategies to protect public health in a changing climate.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (30, '29', '17', '2024-03-15', 'I am interested in the future of renewable energy and its role in combating climate change. As we transition away from fossil fuels, it is crucial to scale up renewable energy sources like solar, wind, and hydroelectric power. I believe investing in renewable energy infrastructure and technology is key to reducing greenhouse gas emissions and building a more sustainable future.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (31, '44', '35', '2023-11-29', 'The discussion on the ethical implications of artificial intelligence is thought-provoking. As AI technologies become more advanced and ubiquitous, we must consider how they impact privacy, autonomy, and human dignity. I am interested in exploring ethical frameworks and regulations that can guide the responsible development and use of AI in various domains, from healthcare to criminal justice.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (32, '15', '49', '2023-09-04', 'The role of technology in disaster management is incredibly important, especially in the context of climate change and increasing urbanization. By leveraging data analytics, remote sensing, and AI, we can improve early warning systems, emergency response, and infrastructure resilience. I believe it is crucial for governments and communities to invest in these technologies to mitigate the impacts of disasters and protect vulnerable populations.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (33, '42', '10', '2023-09-24', 'The discussion on the future of work in the age of automation is thought-provoking. As automation technologies advance, we are likely to see significant changes in the nature of work and employment. I am interested in exploring how we can prepare for these changes and ensure that workers have the skills and support they need to thrive in a rapidly evolving labor market.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (34, '37', '28', '2023-11-01', 'The impact of artificial intelligence on society is a topic that I find both fascinating and concerning. While AI has the potential to revolutionize industries like healthcare and transportation, it also raises ethical and social challenges. I am interested in discussing how we can harness the benefits of AI while mitigating its risks and ensuring that it serves the greater good.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (35, '30', '22', '2023-09-05', 'The discussion on the future of energy is crucial for addressing climate change and transitioning to a sustainable energy system. By investing in renewable energy sources like solar, wind, and geothermal power, we can reduce greenhouse gas emissions and decrease our reliance on fossil fuels. I am interested in exploring policy solutions and technological innovations that can accelerate this transition and create a more resilient energy infrastructure.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (36, '21', '41', '2023-10-21', 'The role of technology in disaster management is essential for improving resilience and response capabilities in the face of natural disasters. By leveraging innovations like AI, drones, and satellite imaging, we can enhance early warning systems, assess damage, and coordinate relief efforts more effectively. I believe it is crucial for governments and organizations to invest in these technologies and prioritize disaster preparedness and response.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (37, '36', '27', '2024-03-16', 'The discussion on the ethical implications of artificial intelligence is both timely and important. As AI technologies become increasingly integrated into various aspects of society, it is crucial to consider how they impact privacy, fairness, and accountability. I believe it is essential for policymakers, technologists, and ethicists to collaborate in developing ethical frameworks and regulations that can guide the responsible development and deployment of AI.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (38, '47', '7', '2024-02-29', 'The role of technology in disaster management is becoming increasingly important in the face of climate change and natural disasters. By leveraging innovations like AI, drones, and remote sensing technologies, we can improve early warning systems, assess damage, and coordinate emergency response efforts more effectively. I believe investing in these technologies is essential for building more resilient communities and saving lives during disasters.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (39, '28', '32', '2024-01-20', 'The discussion on the impacts of climate change on global health is critically important. As temperatures rise and extreme weather events become more frequent, we are likely to see an increase in heat-related illnesses, infectious diseases, and malnutrition. I believe it is essential for governments and healthcare systems to prioritize adaptation and mitigation strategies to protect public health in a changing climate.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (40, '35', '18', '2023-11-16', 'The future of renewable energy is a topic that is crucial for addressing climate change and transitioning to a more sustainable energy system. By investing in solar, wind, and other renewable sources, we can reduce greenhouse gas emissions and decrease our reliance on fossil fuels. I am interested in exploring policy solutions and technological innovations that can accelerate this transition and create a more resilient energy infrastructure.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (41, '14', '36', '2024-04-02', 'The role of technology in disaster management is increasingly important in the face of climate change and natural disasters. By leveraging innovations like AI, drones, and satellite imaging, we can improve early warning systems, assess damage, and coordinate emergency response efforts more effectively. I believe investing in these technologies is essential for building more resilient communities and saving lives during disasters.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (42, '41', '46', '2023-12-01', 'The discussion on the impacts of climate change on global health is critically important. As temperatures rise and extreme weather events become more frequent, we are likely to see an increase in heat-related illnesses, infectious diseases, and food insecurity. I believe it is essential for policymakers and healthcare systems to prioritize adaptation and mitigation strategies to protect public health in a changing climate.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (43, '20', '13', '2023-10-10', 'The future of renewable energy is a topic that is crucial for addressing climate change and transitioning to a more sustainable energy system. By investing in solar, wind, and other renewable sources, we can reduce greenhouse gas emissions and decrease our reliance on fossil fuels. I am interested in exploring policy solutions and technological innovations that can accelerate this transition and create a more resilient energy infrastructure.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (44, '12', '12', '2023-10-11', 'The impact of social media on mental health is a topic that is increasingly relevant in the modern digital age. While social media platforms offer opportunities for connection and self-expression, they also have negative effects on mental well-being, such as promoting unrealistic standards and fostering cyberbullying. I believe it is important to promote digital literacy and responsible online behavior to mitigate these risks and create healthier online environments.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (45, '46', '39', '2024-02-14', 'The future of renewable energy is a topic that is crucial for addressing climate change and transitioning to a more sustainable energy system. By investing in solar, wind, and other renewable sources, we can reduce greenhouse gas emissions and decrease our reliance on fossil fuels. I am interested in exploring policy solutions and technological innovations that can accelerate this transition and create a more resilient energy infrastructure.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (46, '49', '3', '2024-03-20', 'The integration of technology in disaster management is crucial for improving response and recovery efforts. By leveraging data analytics, IoT devices, and AI-powered prediction models, we can enhance early warning systems and decision-making processes during emergencies. I am excited to explore how these technologies can make our communities more resilient to disasters of all kinds.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (47, '11', '4', '2023-09-28', 'The rise of e-learning platforms presents both opportunities and challenges for education. While it offers flexibility and access to a wide range of resources, it also requires addressing issues like the digital divide and ensuring the quality of online instruction. I am interested in discussing strategies for making e-learning more inclusive and effective for all learners.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (48, '26', '34', '2023-09-15', 'The role of artificial intelligence in personalized medicine is a promising area of research. By analyzing large datasets and identifying patterns in patient data, AI algorithms can help clinicians make more accurate diagnoses and develop personalized treatment plans. However, we must address privacy concerns and ensure that these technologies are accessible to all patients, regardless of socioeconomic status or geographic location.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (49, '9', '38', '2023-10-08', 'The discussion on technology in disaster management is crucial. We have seen how technology can play a significant role in early warning systems and coordinating relief efforts during natural disasters like hurricanes and earthquakes. It would be interesting to explore further how emerging technologies like AI and drones can improve disaster response and recovery processes.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (50, '13', '48', '2023-11-18', 'I agree with the points made about the ethical implications of AI. As AI becomes more integrated into various aspects of our lives, it is essential to consider how it can impact privacy, fairness, and autonomy. Developing robust ethical frameworks and regulations will be key to ensuring that AI technologies are deployed responsibly and ethically.');


-- Insert dummy data into DiscussionPostAnswers table
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (1, '16', '23', '4/7/2024', 'Let us analyze this statement in detail. The author asserts that the process of convallis tempor can be understood through various perspectives. They emphasize the importance of dignissim vestibulum in this context. Additionally, the author highlights the significance of sapien in convallis eget. Overall, the argument presents a nuanced view of the topic.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (2, '17', '47', '4/10/2024', 'The statement provided seems to encapsulate the essence of luctus tincidunt effectively. It suggests a concise understanding of the topic.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (3, '14', '30', '4/4/2024', 'The author articulates a comprehensive understanding of the topic, particularly in the discussion of quam a odio. They effectively integrate various aspects of the topic into the argument.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (4, '50', '43', '4/6/2024', 'The argument presented here showcases a deep understanding of pellentesque ultrices. The author provides insightful commentary on the implications of ligula in this context.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (5, '29', '9', '4/12/2024', 'The statement offers a succinct perspective on the role of posuere in ipsum. It effectively highlights the significance of imperdiet in this context.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (6, '27', '25', '4/8/2024', 'The author presents a concise analysis of sagittis sapien, offering valuable insights into its significance.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (7, '26', '38', '4/11/2024', 'The argument provided demonstrates a nuanced understanding of blandit lacinia. The author effectively articulates the importance of commodo placerat in this context.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (8, '39', '40', '4/7/2024', 'The author succinctly addresses the significance of sit amet in this context.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (9, '48', '17', '4/2/2024', 'The author offers a concise analysis of pede justo, emphasizing its importance in the discussion.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (10, '8', '44', '4/14/2024', 'The statement effectively encapsulates the essence of eget nunc, providing valuable insights into its implications.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (11, '4', '27', '4/16/2024', 'The author provides a comprehensive analysis of sodales scelerisque, highlighting its significance in the broader context of the discussion.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (12, '36', '32', '4/1/2024', 'The argument presented here offers valuable insights into eu sapien cursus vestibulum. The author effectively integrates various perspectives into the discussion.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (13, '45', '8', '4/7/2024', 'The statement provides a comprehensive analysis of felis eu sapien cursus vestibulum. The author effectively highlights the significance of sapien in this context.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (14, '46', '4', '4/5/2024', 'The author presents a comprehensive understanding of platea dictumst. They effectively integrate various aspects of the topic into the argument.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (15, '3', '36', '4/15/2024', 'The author provides a detailed analysis of interdum venenatis, offering valuable insights into its implications.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (16, '37', '11', '4/12/2024', 'The argument presented here offers valuable insights into lacus purus. The author effectively integrates various perspectives into the discussion.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (17, '43', '10', '4/6/2024', 'The author provides a nuanced understanding of vulputate vitae. They effectively articulate the implications of odio in this context.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (18, '20', '33', '4/15/2024', 'The argument presented here showcases a deep understanding of fermentum. The author provides insightful commentary on the implications of massa tempor convallis.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (19, '34', '3', '4/3/2024', 'The author presents a comprehensive analysis of magna at nunc commodo placerat. They effectively integrate various aspects of the topic into the argument.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (20, '21', '26', '4/4/2024', 'The statement offers a succinct perspective on sapien, providing valuable insights into its significance.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (21, '10', '49', '4/15/2024', 'The author provides a detailed analysis of sociis natoque penatibus et magnis dis parturient montes, offering valuable insights into its implications.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (22, '25', '35', '4/1/2024', 'The statement effectively encapsulates the essence of ipsum dolor sit amet, providing valuable insights into its implications.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (23, '13', '16', '4/16/2024', 'The author presents a comprehensive understanding of semper sapien a libero. They effectively integrate various aspects of the topic into the argument.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (24, '18', '6', '4/9/2024', 'The argument provided here offers valuable insights into the significance of Aenean lectus.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (25, '41', '14', '4/13/2024', 'The author presents a comprehensive understanding of potenti. They effectively integrate various aspects of the topic into the argument.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (26, '49', '34', '4/11/2024', 'The statement provides a detailed analysis of ornare consequat lectus, offering valuable insights into its implications.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (27, '44', '5', '4/6/2024', 'The argument presented here offers valuable insights into the significance of ornare consequat lectus.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (28, '12', '48', '4/5/2024', 'The author presents a comprehensive understanding of faucibus cursus urna. They effectively integrate various aspects of the topic into the argument.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (29, '2', '19', '4/16/2024', 'The statement offers a succinct perspective on ipsum dolor sit amet, providing valuable insights into its significance.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (30, '28', '28', '4/14/2024', 'The author provides a detailed analysis of tempus. They effectively integrate various aspects of the topic into the argument.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (31, '6', '1', '4/7/2024', 'The statement effectively encapsulates the essence of eu mi. It suggests a concise understanding of the topic.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (32, '5', '24', '4/12/2024', 'The author presents a comprehensive understanding of massa quis augue luctus tincidunt. They effectively integrate various aspects of the topic into the argument.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (33, '24', '18', '4/12/2024', 'The statement provides a detailed analysis of vel nulla eget eros elementum pellentesque. The author effectively integrates various perspectives into the discussion.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (34, '33', '31', '4/5/2024', 'The argument presented here offers valuable insights into the significance of pretium iaculis. The author effectively integrates various perspectives into the discussion.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (35, '7', '41', '4/11/2024', 'The author presents a comprehensive understanding of magna at nunc commodo placerat. They effectively integrate various aspects of the topic into the argument.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (36, '32', '13', '4/5/2024', 'The statement offers a succinct perspective on ac leo. It suggests a concise understanding of the topic.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (37, '1', '12', '4/16/2024', 'The author presents a comprehensive understanding of felis eu sapien cursus vestibulum. They effectively integrate various aspects of the topic into the argument.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (38, '9', '29', '4/1/2024', 'The argument provided here offers valuable insights into the significance of faucibus cursus urna.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (39, '47', '50', '4/11/2024', 'The author provides a nuanced understanding of ipsum dolor sit amet. They effectively articulate the implications of interdum mauris non ligula pellentesque ultrices in this context.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (40, '19', '2', '4/2/2024', 'The statement offers a succinct perspective on vel lectus in quam fringilla rhoncus, providing valuable insights into its significance.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (41, '15', '22', '4/6/2024', 'The author presents a comprehensive understanding of tristique, offering valuable insights into its implications.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (42, '35', '46', '4/6/2024', 'The statement provides a detailed analysis of molestie nibh in lectus. The author effectively integrates various perspectives into the discussion.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (43, '42', '42', '4/15/2024', 'The author provides a nuanced understanding of ac nibh. They effectively articulate the implications of lacus purus in this context.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (44, '23', '20', '4/5/2024', 'The statement offers a succinct perspective on vel nulla eget eros elementum pellentesque, providing valuable insights into its significance.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (45, '30', '45', '4/16/2024', 'The author presents a comprehensive understanding of vestibulum, offering valuable insights into its implications.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (46, '38', '15', '4/16/2024', 'The argument provided here offers valuable insights into the significance of Aenean lectus. The author effectively integrates various perspectives into the discussion.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (47, '40', '37', '4/11/2024', 'The author provides a nuanced understanding of nulla at nunc commodo placerat. They effectively articulate the implications of purus eu magna vulputate luctus in this context.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (48, '11', '21', '4/8/2024', 'The statement offers a succinct perspective on consequat. It suggests a concise understanding of the topic.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (49, '22', '39', '4/14/2024', 'The author presents a comprehensive understanding of Praesent blandit.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (50, '31', '7', '4/6/2024', 'The argument provided here offers valuable insights into the significance of ut dolor.');

-- Insert dummy data into Schedule table
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (1, '12', '33963', 18);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (2, '11', '44688', 25);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (3, '16', '30878', 21);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (4, '22', '43752', 15);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (5, '3', '33092', 6);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (6, '28', '40831', 18);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (7, '35', '19832', 19);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (8, '47', '15246', 1);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (9, '15', '10802', 12);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (10, '20', '48885', 10);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (11, '38', '41844', 11);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (12, '26', '46133', 18);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (13, '32', '29431', 23);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (14, '27', '10721', 16);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (15, '30', '18241', 6);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (16, '9', '30010', 23);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (17, '33', '44124', 15);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (18, '14', '35975', 25);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (19, '46', '14009', 4);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (20, '23', '47109', 21);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (21, '7', '32137', 16);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (22, '43', '29591', 22);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (23, '42', '10412', 18);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (24, '37', '16981', 6);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (25, '34', '48958', 21);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (26, '21', '15035', 13);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (27, '10', '29755', 9);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (28, '44', '12703', 4);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (29, '49', '19119', 5);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (30, '4', '12479', 19);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (31, '29', '33391', 23);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (32, '41', '46028', 22);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (33, '39', '35903', 20);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (34, '1', '48831', 24);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (35, '25', '42581', 12);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (36, '13', '25321', 2);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (37, '19', '20164', 19);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (38, '24', '16605', 19);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (39, '17', '13057', 9);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (40, '5', '43907', 25);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (41, '40', '38334', 24);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (42, '31', '37347', 18);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (43, '50', '19929', 21);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (44, '6', '47059', 11);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (45, '2', '49714', 20);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (46, '18', '16611', 23);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (47, '45', '34455', 17);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (48, '8', '37829', 22);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (49, '36', '21638', 6);
insert into Schedule (ScheduleID, EmployeeID, CRN, HoursWorked) values (50, '48', '37086', 25);

-- Insert dummy data into DayTimeWorked table
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Thursday', '2:00 - 4:00 PM', '6');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Tuesday', '10:00 AM - 12:00 PM', '37');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Sunday', '8:00 AM - 12:00 PM', '19');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Thursday', '2:00 - 4:00 PM', '22');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Tuesday', '10:00 AM - 12:00 PM', '50');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Monday', '10:00 AM - 12:00 PM', '18');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Monday', '2:00 - 4:00 PM', '10');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Wednesday', '2:00 - 4:00 PM', '20');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Wednesday', '11:00 AM - 1:00 PM', '36');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Wednesday', '2:00 - 4:00 PM', '31');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Wednesday', '9:00 AM - 1:00 PM', '12');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Thursday', '6:00 PM - 8:00 PM', '3');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Wednesday', '11:00 AM - 1:00 PM', '14');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Saturday', '9:00 AM - 1:00 PM', '1');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Monday', '9:00 AM - 1:00 PM', '38');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Tuesday', '11:00 AM - 1:00 PM', '25');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Thursday', '10:00 AM - 12:00 PM', '34');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Saturday', '6:00 PM - 8:00 PM', '49');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Sunday', '2:00 - 4:00 PM', '29');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Thursday', '10:00 AM - 12:00 PM', '48');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Friday', '8:00 AM - 12:00 PM', '39');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Wednesday', '6:00 PM - 8:00 PM', '47');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Tuesday', '2:00 - 4:00 PM', '24');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Tuesday', '11:00 AM - 1:00 PM', '28');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Sunday', '11:00 AM - 1:00 PM', '45');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Tuesday', '10:00 AM - 12:00 PM', '5');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Thursday', '2:00 - 4:00 PM', '11');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Monday', '6:00 PM - 8:00 PM', '21');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Friday', '11:00 AM - 1:00 PM', '8');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Thursday', '10:00 AM - 12:00 PM', '30');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Monday', '2:00 - 4:00 PM', '23');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Saturday', '2:00 - 4:00 PM', '15');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Thursday', '8:00 AM - 12:00 PM', '13');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Wednesday', '8:00 AM - 12:00 PM', '42');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Tuesday', '2:00 - 4:00 PM', '40');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Thursday', '2:00 - 4:00 PM', '4');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Wednesday', '11:00 AM - 1:00 PM', '27');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Thursday', '8:00 AM - 12:00 PM', '43');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Friday', '8:00 AM - 12:00 PM', '32');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Friday', '2:00 - 4:00 PM', '2');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Wednesday', '10:00 AM - 12:00 PM', '44');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Thursday', '9:00 AM - 1:00 PM', '33');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Thursday', '8:00 AM - 12:00 PM', '35');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Saturday', '8:00 AM - 12:00 PM', '17');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Tuesday', '11:00 AM - 1:00 PM', '16');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Saturday', '10:00 AM - 12:00 PM', '46');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Thursday', '11:00 AM - 1:00 PM', '7');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Thursday', '6:00 PM - 8:00 PM', '26');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Wednesday', '6:00 PM - 8:00 PM', '9');
insert into DayTimeWorked (Day, Timeslot, ScheduleID) values ('Thursday', '9:00 AM - 1:00 PM', '41');