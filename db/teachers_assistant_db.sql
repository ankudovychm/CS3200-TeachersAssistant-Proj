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
insert into CourseSections (CRN, CourseID, Year, Semester) values (44138, '4830', 2024, 'Summer');
insert into CourseSections (CRN, CourseID, Year, Semester) values (36749, '2675', 2018, 'Spring');
insert into CourseSections (CRN, CourseID, Year, Semester) values (30673, '1157', 2024, 'Spring');
insert into CourseSections (CRN, CourseID, Year, Semester) values (38346, '2087', 2018, 'Fall');
insert into CourseSections (CRN, CourseID, Year, Semester) values (11473, '3942', 2018, 'Fall');
insert into CourseSections (CRN, CourseID, Year, Semester) values (34356, '3902', 2022, 'Spring');
insert into CourseSections (CRN, CourseID, Year, Semester) values (40762, '2863', 2023, 'Fall');
insert into CourseSections (CRN, CourseID, Year, Semester) values (42927, '4177', 2019, 'Summer');
insert into CourseSections (CRN, CourseID, Year, Semester) values (27428, '3705', 2022, 'Spring');
insert into CourseSections (CRN, CourseID, Year, Semester) values (17276, '3655', 2021, 'Summer');
insert into CourseSections (CRN, CourseID, Year, Semester) values (33628, '2471', 2022, 'Spring');
insert into CourseSections (CRN, CourseID, Year, Semester) values (46528, '4897', 2021, 'Summer');
insert into CourseSections (CRN, CourseID, Year, Semester) values (25135, '3101', 2024, 'Summer');
insert into CourseSections (CRN, CourseID, Year, Semester) values (21117, '4001', 2023, 'Fall');
insert into CourseSections (CRN, CourseID, Year, Semester) values (19928, '1260', 2020, 'Summer');
insert into CourseSections (CRN, CourseID, Year, Semester) values (43886, '3931', 2020, 'Fall');
insert into CourseSections (CRN, CourseID, Year, Semester) values (42362, '3678', 2018, 'Summer');
insert into CourseSections (CRN, CourseID, Year, Semester) values (28509, '1936', 2019, 'Spring');
insert into CourseSections (CRN, CourseID, Year, Semester) values (28340, '2364', 2019, 'Fall');
insert into CourseSections (CRN, CourseID, Year, Semester) values (28915, '1062', 2024, 'Summer');
insert into CourseSections (CRN, CourseID, Year, Semester) values (42758, '4242', 2019, 'Fall');
insert into CourseSections (CRN, CourseID, Year, Semester) values (25443, '4046', 2023, 'Summer');
insert into CourseSections (CRN, CourseID, Year, Semester) values (25283, '3392', 2021, 'Fall');
insert into CourseSections (CRN, CourseID, Year, Semester) values (28811, '4422', 2023, 'Spring');
insert into CourseSections (CRN, CourseID, Year, Semester) values (46515, '4383', 2023, 'Spring');
insert into CourseSections (CRN, CourseID, Year, Semester) values (46890, '2203', 2022, 'Summer');
insert into CourseSections (CRN, CourseID, Year, Semester) values (24598, '2348', 2022, 'Summer');
insert into CourseSections (CRN, CourseID, Year, Semester) values (36044, '4989', 2023, 'Summer');
insert into CourseSections (CRN, CourseID, Year, Semester) values (11174, '1070', 2021, 'Spring');
insert into CourseSections (CRN, CourseID, Year, Semester) values (42661, '3866', 2023, 'Spring');
insert into CourseSections (CRN, CourseID, Year, Semester) values (37643, '2556', 2020, 'Spring');
insert into CourseSections (CRN, CourseID, Year, Semester) values (31862, '1561', 2024, 'Fall');
insert into CourseSections (CRN, CourseID, Year, Semester) values (40397, '1399', 2022, 'Spring');
insert into CourseSections (CRN, CourseID, Year, Semester) values (32663, '2851', 2021, 'Summer');
insert into CourseSections (CRN, CourseID, Year, Semester) values (47486, '2239', 2022, 'Spring');
insert into CourseSections (CRN, CourseID, Year, Semester) values (12269, '3996', 2022, 'Summer');
insert into CourseSections (CRN, CourseID, Year, Semester) values (41863, '3521', 2019, 'Fall');
insert into CourseSections (CRN, CourseID, Year, Semester) values (33363, '3350', 2022, 'Fall');
insert into CourseSections (CRN, CourseID, Year, Semester) values (33860, '1081', 2018, 'Spring');
insert into CourseSections (CRN, CourseID, Year, Semester) values (20631, '2832', 2020, 'Fall');
insert into CourseSections (CRN, CourseID, Year, Semester) values (33931, '3071', 2022, 'Spring');
insert into CourseSections (CRN, CourseID, Year, Semester) values (42559, '2515', 2020, 'Fall');
insert into CourseSections (CRN, CourseID, Year, Semester) values (34458, '1881', 2018, 'Spring');
insert into CourseSections (CRN, CourseID, Year, Semester) values (38927, '4126', 2020, 'Summer');
insert into CourseSections (CRN, CourseID, Year, Semester) values (46832, '1292', 2018, 'Fall');
insert into CourseSections (CRN, CourseID, Year, Semester) values (34871, '1833', 2019, 'Spring');
insert into CourseSections (CRN, CourseID, Year, Semester) values (29757, '2029', 2020, 'Spring');
insert into CourseSections (CRN, CourseID, Year, Semester) values (33352, '4707', 2024, 'Summer');
insert into CourseSections (CRN, CourseID, Year, Semester) values (14326, '4288', 2023, 'Spring');
insert into CourseSections (CRN, CourseID, Year, Semester) values (33279, '2580', 2024, 'Spring');

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
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (1, 'Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst.', '40');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (2, 'Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', '69');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (3, 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', '90');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (4, 'Cras pellentesque volutpat dui.', '157');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (5, 'Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo.', '115');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (6, 'Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est.', '107');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (7, 'In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem.', '42');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (8, 'In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', '150');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (9, 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum.', '105');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (10, 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', '118');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (11, 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue.', '198');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (12, 'Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis.', '50');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (13, 'Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl.', '113');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (14, 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', '33');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (15, 'In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum.', '94');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (16, 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem.', '132');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (17, 'Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', '117');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (18, 'Aliquam erat volutpat. In congue.', '98');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (19, 'Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit.', '34');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (20, 'Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus.', '68');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (21, 'Aliquam erat volutpat.', '193');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (22, 'Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', '152');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (23, 'Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', '28');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (24, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue.', '81');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (25, 'Duis aliquam convallis nunc.', '169');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (26, 'Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla.', '143');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (27, 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique.', '32');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (28, 'Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus.', '110');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (29, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi.', '73');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (30, 'Nunc purus. Phasellus in felis. Donec semper sapien a libero. Nam dui.', '140');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (31, 'Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla.', '158');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (32, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio.', '57');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (33, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend.', '109');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (34, 'Aenean fermentum. Donec ut mauris eget massa tempor convallis.', '48');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (35, 'Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla.', '88');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (36, 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim.', '6');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (37, 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum.', '129');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (38, 'Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '54');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (39, 'Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante.', '196');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (40, 'Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien.', '35');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (41, 'Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc.', '151');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (42, 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem.', '83');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (43, 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', '100');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (44, 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum.', '85');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (45, 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis.', '168');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (46, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio.', '200');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (47, 'Donec posuere metus vitae ipsum. Aliquam non mauris.', '45');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (48, 'Donec semper sapien a libero. Nam dui.', '92');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (49, 'Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa.', '17');
insert into SubmissionsComments (SubmissionCommentID, CommentText, SubmissionID) values (50, 'Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti.', '12');

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
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (1, 'Aliquam erat volutpat. In congue. Etiam justo.', '2020-05-09', '34', false, '35903');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (2, 'Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum.', '2021-12-28', '2', false, '48958');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (3, 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', '2022-08-16', '39', true, '48885');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (4, 'Fusce posuere felis sed lacus.', '2021-02-14', '36', true, '33391');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (5, 'Vestibulum rutrum rutrum neque.', '2024-04-06', '27', true, '16611');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (6, 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy.', '2021-01-06', '43', false, '40831');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (7, 'Quisque ut erat.', '2020-10-18', '3', false, '14009');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (8, 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', '2022-12-18', '7', false, '10412');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (9, 'Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla.', '2021-11-21', '4', false, '29591');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (10, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy.', '2020-04-18', '16', false, '12479');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (11, 'Proin interdum mauris non ligula pellentesque ultrices.', '2024-03-21', '37', false, '37829');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (12, 'Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna.', '2022-06-21', '21', false, '44124');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (13, 'Nullam molestie nibh in lectus. Pellentesque at nulla.', '2021-12-10', '13', false, '29431');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (14, 'Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', '2020-06-07', '19', false, '10721');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (15, 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci.', '2021-05-06', '30', true, '48831');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (16, 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus.', '2022-06-18', '26', false, '43752');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (17, 'Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo.', '2023-05-22', '23', false, '49714');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (18, 'Nulla justo. Aliquam quis turpis eget elit sodales scelerisque.', '2021-02-23', '28', true, '44688');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (19, 'Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', '2020-04-22', '25', false, '47059');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (20, 'Vivamus tortor.', '2023-06-06', '46', true, '43907');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (21, 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2020-11-10', '10', true, '25321');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (22, 'Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', '2022-12-11', '6', true, '38334');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (23, 'Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum.', '2024-04-08', '40', false, '16605');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (24, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', '2020-08-21', '5', false, '10802');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (25, 'Nulla ut erat id mauris vulputate elementum.', '2020-09-11', '1', false, '41844');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (26, 'Nulla facilisi. Cras non velit nec nisi vulputate nonummy.', '2023-12-09', '11', true, '15246');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (27, 'In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem.', '2021-07-28', '41', false, '30878');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (28, 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl.', '2023-08-23', '45', true, '21638');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (29, 'Proin eu mi.', '2022-07-26', '24', false, '32137');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (30, 'Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat.', '2023-12-11', '31', true, '19929');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (31, 'Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat.', '2023-11-04', '22', false, '35975');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (32, 'Nam tristique tortor eu pede.', '2021-12-11', '9', true, '37347');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (33, 'Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', '2023-03-05', '44', false, '13057');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (34, 'Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti.', '2023-08-31', '50', false, '12703');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (35, 'Sed accumsan felis. Ut at dolor quis odio consequat varius.', '2021-09-26', '20', true, '37086');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (36, 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor.', '2021-02-25', '15', true, '15035');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (37, 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci.', '2022-04-01', '38', false, '34455');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (38, 'Integer a nibh.', '2021-02-28', '42', false, '42581');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (39, 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia.', '2023-01-14', '48', false, '46133');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (40, 'Duis at velit eu est congue elementum. In hac habitasse platea dictumst.', '2022-09-28', '29', true, '19832');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (41, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.', '2022-05-21', '12', false, '46028');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (42, 'Praesent blandit. Nam nulla.', '2022-08-31', '35', true, '16981');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (43, 'Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum.', '2021-10-02', '18', true, '47109');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (44, 'Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula.', '2021-11-03', '47', false, '30010');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (45, 'Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio.', '2024-02-11', '49', false, '33092');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (46, 'Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio.', '2021-06-05', '32', false, '19119');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (47, 'Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum.', '2020-05-07', '33', true, '20164');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (48, 'Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum.', '2020-04-25', '17', true, '18241');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (49, 'Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', '2023-04-08', '8', false, '29755');
insert into FeedbackSurveys (SurveyID, Feedback, Date, ReviewerID, Status, CRN) values (50, 'Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam.', '2020-10-24', '14', true, '33963');

-- Insert dummy data into Chats table
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (1, 'Proin at turpis a pede posuere nonummy.', '14', '40', '2024-04-10');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (2, 'Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti.', '50', '13', '2024-04-16');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (3, 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum.', '36', '49', '2024-02-10');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (4, 'Suspendisse accumsan tortor quis turpis.', '22', '2', '2024-02-29');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (5, 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', '18', '17', '2024-03-28');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (6, 'Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo.', '8', '37', '2023-10-15');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (7, 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam.', '46', '24', '2023-11-13');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (8, 'Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante.', '7', '14', '2024-01-14');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (9, 'Integer non velit.', '15', '7', '2024-02-04');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (10, 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit.', '32', '42', '2024-03-18');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (11, 'Morbi non quam nec dui luctus rutrum. Nulla tellus.', '49', '19', '2023-11-12');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (12, 'Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum.', '19', '34', '2023-10-10');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (13, 'Etiam justo.', '30', '21', '2023-09-07');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (14, 'Fusce consequat.', '16', '1', '2024-03-25');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (15, 'Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', '13', '25', '2024-04-18');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (16, 'Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst.', '33', '11', '2024-01-14');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (17, 'Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam.', '12', '12', '2024-04-24');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (18, 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', '17', '43', '2024-01-14');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (19, 'Quisque id justo sit amet sapien dignissim vestibulum.', '21', '47', '2023-12-16');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (20, 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue.', '34', '16', '2024-01-22');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (21, 'Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla.', '2', '38', '2024-02-18');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (22, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', '20', '26', '2024-04-05');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (23, 'Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo.', '3', '36', '2023-09-19');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (24, 'Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', '41', '20', '2023-11-22');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (25, 'Praesent lectus.', '42', '28', '2024-03-22');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (26, 'Praesent lectus.', '40', '8', '2023-12-17');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (27, 'Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus.', '27', '41', '2023-09-26');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (28, 'Donec posuere metus vitae ipsum. Aliquam non mauris.', '6', '10', '2023-12-10');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (29, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam.', '45', '15', '2023-10-31');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (30, 'Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc.', '23', '50', '2024-01-17');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (31, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', '38', '5', '2023-11-26');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (32, 'Proin risus. Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante.', '44', '44', '2023-10-08');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (33, 'Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque.', '10', '46', '2024-02-15');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (34, 'Suspendisse accumsan tortor quis turpis.', '11', '33', '2023-11-22');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (35, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus.', '4', '48', '2023-09-19');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (36, 'Suspendisse potenti. Nullam porttitor lacus at turpis.', '47', '31', '2024-01-02');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (37, 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', '31', '45', '2023-11-01');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (38, 'In sagittis dui vel nisl.', '28', '18', '2023-12-01');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (39, 'Proin interdum mauris non ligula pellentesque ultrices.', '43', '22', '2024-04-19');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (40, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla.', '1', '3', '2023-12-30');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (41, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.', '9', '6', '2024-02-27');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (42, 'In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', '24', '32', '2023-11-15');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (43, 'Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', '48', '23', '2024-01-28');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (44, 'Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci.', '37', '35', '2023-12-06');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (45, 'Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet.', '39', '29', '2024-03-31');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (46, 'Vivamus in felis eu sapien cursus vestibulum.', '26', '4', '2023-11-20');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (47, 'Morbi quis tortor id nulla ultrices aliquet.', '29', '27', '2023-12-07');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (48, 'Nullam sit amet turpis elementum ligula vehicula consequat.', '25', '39', '2024-03-29');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (49, 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam.', '5', '9', '2024-01-29');
insert into Chats (ChatID, Message, SenderID, RecipientID, TimeSent) values (50, 'In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', '35', '30', '2024-02-12');

-- Insert dummy data into ChatReplies table
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (1, '13', '18', '45', '2023-12-23', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (2, '50', '30', '1', '2024-01-31', 'Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (3, '23', '15', '50', '2023-09-30', 'Morbi ut odio.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (4, '44', '7', '19', '2023-12-23', 'Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (5, '4', '48', '48', '2024-04-01', 'Morbi porttitor lorem id ligula.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (6, '38', '6', '39', '2024-02-18', 'Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (7, '2', '27', '3', '2024-01-22', 'Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (8, '6', '40', '4', '2024-03-26', 'Aenean sit amet justo. Morbi ut odio.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (9, '30', '19', '13', '2024-04-11', 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (10, '5', '48', '24', '2024-03-18', 'Proin risus. Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (11, '31', '23', '38', '2024-01-03', 'Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (12, '33', '14', '36', '2023-10-02', 'Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (13, '17', '37', '29', '2023-12-15', 'Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (14, '43', '44', '48', '2024-01-15', 'Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (15, '9', '41', '13', '2024-01-06', 'In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (16, '32', '3', '50', '2024-03-16', 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (17, '11', '47', '9', '2023-12-02', 'Fusce consequat. Nulla nisl.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (18, '14', '18', '23', '2024-04-16', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (19, '47', '10', '2', '2024-02-09', 'Morbi a ipsum.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (20, '40', '26', '17', '2024-02-06', 'Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (21, '15', '16', '26', '2023-10-18', 'Morbi porttitor lorem id ligula.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (22, '46', '43', '22', '2023-12-07', 'Nam dui.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (23, '37', '50', '16', '2023-09-17', 'Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (24, '29', '36', '32', '2023-11-18', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (25, '18', '49', '13', '2023-09-20', 'Nulla tempus.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (26, '24', '25', '36', '2023-10-08', 'Nunc purus. Phasellus in felis. Donec semper sapien a libero.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (27, '49', '13', '26', '2023-10-06', 'Sed sagittis.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (28, '22', '41', '19', '2024-04-23', 'Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (29, '19', '4', '1', '2023-12-02', 'Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (30, '12', '34', '38', '2024-03-24', 'Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (31, '48', '9', '21', '2023-11-16', 'Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (32, '28', '50', '28', '2024-01-12', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (33, '34', '5', '32', '2024-02-22', 'Sed accumsan felis.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (34, '10', '48', '5', '2023-10-06', 'Morbi non lectus.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (35, '25', '36', '14', '2024-04-16', 'Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (36, '7', '21', '20', '2023-12-14', 'In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (37, '21', '30', '26', '2024-01-22', 'Etiam faucibus cursus urna. Ut tellus.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (38, '1', '4', '10', '2024-04-23', 'Sed vel enim sit amet nunc viverra dapibus.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (39, '8', '46', '35', '2024-02-17', 'Sed accumsan felis. Ut at dolor quis odio consequat varius.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (40, '41', '35', '45', '2023-10-12', 'Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (41, '35', '8', '47', '2024-04-14', 'Sed vel enim sit amet nunc viverra dapibus.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (42, '27', '1', '27', '2023-09-09', 'Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (43, '20', '38', '50', '2024-01-27', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (44, '39', '16', '14', '2023-12-10', 'Morbi non quam nec dui luctus rutrum.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (45, '16', '18', '14', '2023-12-26', 'Aenean fermentum.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (46, '3', '37', '2', '2023-10-24', 'Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (47, '36', '21', '9', '2024-04-22', 'Morbi porttitor lorem id ligula.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (48, '45', '1', '20', '2023-10-06', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (49, '26', '29', '14', '2024-01-15', 'Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula.');
insert into ChatReplies (ReplyID, ChatID, SenderID, RecipientID, TimeSent, ChatReplyText) values (50, '42', '41', '33', '2024-03-30', 'Aenean lectus.');

-- Insert dummy data into DiscussionPosts table
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (1, '35975', '11', 'eleifend pede libero quis', 'Morbi vel lectus in quam fringilla rhoncus.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (2, '44124', '20', 'vestibulum quam sapien varius ut blandit non interdum in', 'Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (3, '19832', '45', 'fusce posuere felis sed lacus morbi sem mauris', 'In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (4, '48831', '2', 'et magnis dis parturient montes', 'In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (5, '19119', '34', 'pede venenatis non sodales sed tincidunt', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (6, '14009', '27', 'donec vitae nisi nam ultrices libero non', 'Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (7, '10412', '43', 'nunc purus phasellus in', 'Phasellus in felis. Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (8, '33092', '1', 'dolor quis odio consequat varius integer ac leo pellentesque', 'Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (9, '19929', '10', 'sit amet nulla quisque arcu libero rutrum', 'In hac habitasse platea dictumst.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (10, '21638', '44', 'id mauris vulputate elementum nullam varius nulla facilisi cras', 'Ut tellus.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (11, '29755', '30', 'ultrices vel augue vestibulum ante ipsum primis in', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (12, '37829', '48', 'elementum nullam varius nulla facilisi cras non velit nec nisi', 'Nullam porttitor lacus at turpis.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (13, '29431', '41', 'diam erat fermentum justo nec condimentum neque sapien placerat', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (14, '32137', '16', 'non mi integer ac neque duis bibendum morbi non quam', 'Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (15, '33391', '46', 'eu mi nulla ac enim in tempor turpis', 'Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (16, '46133', '17', 'arcu sed augue aliquam erat volutpat in', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (17, '34455', '15', 'nulla tempus vivamus in felis', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (18, '43752', '8', 'lacus curabitur at ipsum ac', 'Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (19, '16605', '21', 'morbi non quam nec dui luctus rutrum nulla tellus in', 'Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (20, '47109', '36', 'metus arcu adipiscing molestie hendrerit at vulputate vitae', 'Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (21, '40831', '32', 'lacinia erat vestibulum sed', 'Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (22, '41844', '23', 'luctus et ultrices posuere cubilia curae mauris viverra', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (23, '12479', '5', 'malesuada in imperdiet et commodo vulputate justo in blandit ultrices', 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (24, '35903', '31', 'condimentum neque sapien placerat ante nulla justo aliquam quis', 'Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (25, '15246', '3', 'proin eu mi nulla ac enim', 'Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (26, '16981', '42', 'cum sociis natoque penatibus et magnis dis parturient', 'Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (27, '38334', '28', 'posuere nonummy integer non velit', 'Donec dapibus. Duis at velit eu est congue elementum.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (28, '46028', '25', 'elementum nullam varius nulla facilisi cras non velit nec', 'Curabitur gravida nisi at nibh.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (29, '37086', '4', 'a ipsum integer a nibh in quis justo maecenas', 'Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (30, '16611', '37', 'bibendum imperdiet nullam orci pede venenatis non sodales sed', 'Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (31, '18241', '40', 'ut nunc vestibulum ante ipsum primis in faucibus', 'Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (32, '48885', '47', 'morbi quis tortor id nulla ultrices', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (33, '33963', '38', 'nulla quisque arcu libero', 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (34, '10802', '35', 'rutrum neque aenean auctor gravida sem praesent id', 'Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (35, '30878', '12', 'ut mauris eget massa tempor convallis nulla', 'Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam. Nam tristique tortor eu pede.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (36, '13057', '19', 'nunc commodo placerat praesent blandit nam nulla integer', 'Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (37, '15035', '50', 'ipsum integer a nibh in quis', 'Donec dapibus. Duis at velit eu est congue elementum.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (38, '20164', '18', 'consequat varius integer ac leo pellentesque ultrices mattis', 'Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (39, '43907', '33', 'fusce congue diam id ornare imperdiet sapien urna', 'Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (40, '44688', '22', 'eget massa tempor convallis nulla neque libero convallis', 'Duis bibendum.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (41, '10721', '13', 'nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis', 'Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (42, '25321', '39', 'lorem integer tincidunt ante vel ipsum', 'Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (43, '47059', '24', 'vel sem sed sagittis nam congue risus semper porta volutpat', 'Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (44, '30010', '49', 'diam vitae quam suspendisse potenti', 'Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (45, '49714', '14', 'consequat nulla nisl nunc', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (46, '42581', '7', 'orci luctus et ultrices', 'Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (47, '48958', '6', 'est quam pharetra magna ac consequat', 'Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (48, '37347', '9', 'ante nulla justo aliquam quis turpis', 'Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (49, '12703', '29', 'cras pellentesque volutpat dui maecenas tristique est et tempus', 'Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque.');
insert into DiscussionPosts (PostID, CRN, StudentID, PostTitle, PostContent) values (50, '29591', '26', 'pharetra magna vestibulum aliquet ultrices erat tortor', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.');

-- Insert dummy data into DiscussionPostComments table
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (1, '9', '1', '2023-10-08', 'Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (2, '13', '48', '2023-11-18', 'Etiam faucibus cursus urna.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (3, '31', '11', '2023-09-29', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (4, '32', '47', '2023-10-12', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (5, '22', '44', '2023-11-19', 'Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (6, '18', '9', '2024-04-05', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (7, '33', '15', '2024-04-15', 'In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (8, '1', '31', '2024-01-13', 'Nullam varius. Nulla facilisi.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (9, '38', '45', '2023-12-09', 'In congue. Etiam justo. Etiam pretium iaculis justo.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (10, '5', '5', '2023-10-08', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (11, '50', '8', '2024-01-12', 'Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (12, '17', '6', '2023-10-09', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (13, '40', '20', '2024-01-09', 'Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (14, '7', '29', '2024-04-04', 'Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (15, '2', '26', '2023-09-13', 'Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (16, '48', '37', '2024-02-22', 'Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (17, '16', '2', '2023-10-09', 'Nulla tellus.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (18, '45', '40', '2023-12-12', 'Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (19, '8', '43', '2023-11-03', 'Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (20, '39', '14', '2023-10-27', 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam. Nam tristique tortor eu pede.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (21, '3', '21', '2024-02-15', 'Vivamus in felis eu sapien cursus vestibulum.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (22, '27', '50', '2024-04-09', 'Etiam justo.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (23, '34', '24', '2023-12-30', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (24, '24', '25', '2023-12-29', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (25, '6', '19', '2024-02-21', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (26, '19', '30', '2024-01-07', 'Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (27, '10', '33', '2023-11-10', 'Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (28, '23', '23', '2023-10-16', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (29, '43', '16', '2024-01-29', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (30, '29', '17', '2024-03-15', 'Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (31, '44', '35', '2023-11-29', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (32, '15', '49', '2023-09-04', 'Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (33, '42', '10', '2023-09-24', 'In hac habitasse platea dictumst.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (34, '37', '28', '2023-11-01', 'In congue. Etiam justo.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (35, '30', '22', '2023-09-05', 'Aliquam quis turpis eget elit sodales scelerisque.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (36, '21', '41', '2023-10-21', 'Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (37, '36', '27', '2024-03-16', 'Quisque ut erat.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (38, '47', '7', '2024-02-29', 'Curabitur convallis.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (39, '11', '42', '2024-04-24', 'Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (40, '35', '34', '2023-12-01', 'Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (41, '4', '18', '2023-11-25', 'Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (42, '46', '13', '2023-09-03', 'Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (43, '49', '39', '2024-02-10', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (44, '25', '36', '2024-03-08', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (45, '28', '4', '2024-02-19', 'Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (46, '26', '3', '2024-03-27', 'Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (47, '12', '46', '2024-04-17', 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (48, '20', '32', '2023-09-29', 'Vivamus tortor. Duis mattis egestas metus.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (49, '41', '38', '2024-02-13', 'In blandit ultrices enim.');
insert into DiscussionPostComments (DPCommentID, PostID, StudentID, TimePosted, CommentText) values (50, '14', '12', '2024-01-31', 'Etiam faucibus cursus urna.');

-- Insert dummy data into DiscussionPostAnswers table
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (1, '16', '23', '4/7/2024', 'Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (2, '17', '47', '4/10/2024', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (3, '14', '30', '4/4/2024', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (4, '50', '43', '4/6/2024', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (5, '29', '9', '4/12/2024', 'Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (6, '27', '25', '4/8/2024', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (7, '26', '38', '4/11/2024', 'Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (8, '39', '40', '4/7/2024', 'Aenean sit amet justo.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (9, '48', '17', '4/2/2024', 'Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (10, '8', '44', '4/14/2024', 'Pellentesque eget nunc.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (11, '4', '27', '4/16/2024', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (12, '36', '32', '4/1/2024', 'Vivamus in felis eu sapien cursus vestibulum. Proin eu mi.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (13, '45', '8', '4/7/2024', 'Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (14, '46', '4', '4/5/2024', 'In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (15, '3', '36', '4/15/2024', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (16, '37', '11', '4/12/2024', 'Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (17, '43', '10', '4/6/2024', 'Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (18, '20', '33', '4/15/2024', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (19, '34', '3', '4/3/2024', 'Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (20, '21', '26', '4/4/2024', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (21, '10', '49', '4/15/2024', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (22, '25', '35', '4/1/2024', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (23, '13', '16', '4/16/2024', 'Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (24, '18', '6', '4/9/2024', 'Aenean lectus. Pellentesque eget nunc.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (25, '41', '14', '4/13/2024', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (26, '49', '34', '4/11/2024', 'Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (27, '44', '5', '4/6/2024', 'Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (28, '12', '48', '4/5/2024', 'Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (29, '2', '19', '4/16/2024', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (30, '28', '28', '4/14/2024', 'Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (31, '6', '1', '4/7/2024', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (32, '5', '24', '4/12/2024', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (33, '24', '18', '4/12/2024', 'Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (34, '33', '31', '4/5/2024', 'Etiam pretium iaculis justo. In hac habitasse platea dictumst.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (35, '7', '41', '4/11/2024', 'Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (36, '32', '13', '4/5/2024', 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (37, '1', '12', '4/16/2024', 'Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (38, '9', '29', '4/1/2024', 'Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (39, '47', '50', '4/11/2024', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (40, '19', '2', '4/2/2024', 'Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (41, '15', '22', '4/6/2024', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (42, '35', '46', '4/6/2024', 'Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (43, '42', '42', '4/15/2024', 'Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (44, '23', '20', '4/5/2024', 'Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (45, '30', '45', '4/16/2024', 'Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (46, '38', '15', '4/16/2024', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (47, '40', '37', '4/11/2024', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (48, '11', '21', '4/8/2024', 'Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (49, '22', '39', '4/14/2024', 'Praesent blandit.');
insert into DiscussionPostAnswers (DPAnswerID, PostID, EmployeeID, TimePosted, DiscussionPostAnswer) values (50, '31', '7', '4/6/2024', 'Donec ut dolor.');

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