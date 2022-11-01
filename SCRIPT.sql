---CREATE DATABASE PROJECT
USE [master]
CREATE DATABASE HE160536_DBI_ASSIGMENT_SP22
USE HE160536_DBI_ASSIGMENT_SP22


---CREATE STUDENT TABLE
CREATE TABLE STUDENT(
      StudentID VARCHAR(8) PRIMARY KEY NOT NULL CHECK (StudentID LIKE 'HE[0-9][0-9][0-9][0-9][0-9][0-9]'),
	  SurName VARCHAR(10) NOT NULL,
	  MiddleName VARCHAR(10) NOT NULL,
	  GivenName VARCHAR(10) NOT NULL,
	  Email VARCHAR(50) NOT NULL CHECK (Email LIKE '%@fpt.edu.vn'),
	  Gender BIT NOT NULL,
	  Dob DATE NOT NULL CHECK (YEAR(GETDATE()) - YEAR(dob) >= 18),
)

---CREATE TABLE INSTRUCTOR
CREATE TABLE INSTRUCTOR(
     InstructorID VARCHAR(20) PRIMARY KEY NOT NULL,
	 FirstName VARCHAR(15) NOT NULL,
	 LastName VARCHAR(15) NOT NULL,
	 Email VARCHAR(50) NOT NULL CHECK (Email LIKE '%@fe.edu.vn')
)

---CREATE TABLE COURSE
CREATE TABLE COURSE(
     CourseID VARCHAR(6) PRIMARY KEY NOT NULL CHECK(CourseID LIKE '[A-Z][A-Z][A-Z][0-9][0-9][0-9]'),
	 CourseName VARCHAR(50) NOT NULL,
)

---CREATE TABLE GROUP
CREATE TABLE [GROUP](
	 GroupName VARCHAR(6) NOT NULL,
	 CourseID VARCHAR(6) NOT NULL CHECK(CourseID LIKE '[A-Z][A-Z][A-Z][0-9][0-9][0-9]'),
	 InstructorID VARCHAR(20) NOT NULL,
	 CONSTRAINT fk_Group_Course FOREIGN KEY (CourseID) REFERENCES COURSE(CourseID),
	 CONSTRAINT fk_Group_Instructor FOREIGN KEY (InstructorID) REFERENCES INSTRUCTOR(InstructorID),
	 CONSTRAINT pk_Group PRIMARY KEY(GroupName,CourseID)
)

---CREATE TABLE GROUP_MEMBER (GROUP - STUDENT)
CREATE TABLE GROUP_STUDENTS(
     GroupName VARCHAR(6) NOT NULL,
	 CourseID VARCHAR(6) NOT NULL CHECK(CourseID LIKE '[A-Z][A-Z][A-Z][0-9][0-9][0-9]'),
	 StudentID VARCHAR(8) NOT NULL CHECK (StudentID LIKE 'HE[0-9][0-9][0-9][0-9][0-9][0-9]'),
	 CONSTRAINT fk_GroupStudent_Student FOREIGN KEY (StudentID) REFERENCES STUDENT(StudentID),
	 CONSTRAINT fk_GroupStudent_Group FOREIGN KEY (GroupName,CourseID) REFERENCES [GROUP](GroupName,CourseID),
	 CONSTRAINT pk_GroupStudents PRIMARY KEY(GroupName,CourseID,StudentID)
)

---CREATE TABLE TIME_SLOT
CREATE TABLE TIME_SLOT(
     TimeSlotID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	 StartTime TIME NOT NULL,
	 EndTime TIME NOT NULL,
)

---CREATE TABLE LECTURE
CREATE TABLE LECTURE(
     LectureID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	 GroupName VARCHAR(6) NOT NULL,
	 CourseID VARCHAR(6) NOT NULL CHECK(CourseID LIKE '[A-Z][A-Z][A-Z][0-9][0-9][0-9]'),
	 LectureName VARCHAR(50) NOT NULL,
	 InstructorID VARCHAR(20) NOT NULL,
	 TimeSlotID INT NOT NULL,
	 Room VARCHAR(5) NOT NULL,
	 CONSTRAINT fk_Lecture_Group FOREIGN KEY (GroupName,CourseID) REFERENCES [GROUP](GroupName,CourseID),
	 CONSTRAINT fk_Lecture_Instructor FOREIGN KEY (InstructorID) REFERENCES INSTRUCTOR(InstructorID),
	 CONSTRAINT fk_Lecture_TimeSlot FOREIGN KEY (TimeSlotID) REFERENCES TIME_SLOT(TimeSlotID)
)

---CREATE TABLE TAKE_ATTENDANCE
CREATE TABLE TAKE_ATTENDANCE(
     LectureID INT NOT NULL,
	 InstructorID VARCHAR(20) NOT NULL,
	 StudentID VARCHAR(8) NOT NULL CHECK (StudentID LIKE 'HE[0-9][0-9][0-9][0-9][0-9][0-9]'),
     [Status] BIT NOT NULL,
	 RecordTime TIME NOT NULL,
	 CONSTRAINT fk_TakeAttendance_Instructor FOREIGN KEY (InstructorID) REFERENCES INSTRUCTOR(InstructorID),
	 CONSTRAINT fk_TakeAttendance_Student FOREIGN KEY (StudentID) REFERENCES STUDENT(StudentID),
	 CONSTRAINT fk_TakeAttendance_Lecture FOREIGN KEY (LectureID) REFERENCES LECTURE(LectureID),
	 CONSTRAINT pk_TakeAttendance PRIMARY KEY(LectureID,StudentID)
)

---CREATE TABLE COURSE_ASSESSMENT
CREATE TABLE ASSESSMENT(
     CourseID VARCHAR(6) NOT NULL CHECK(CourseID LIKE '[A-Z][A-Z][A-Z][0-9][0-9][0-9]'),
     Category VARCHAR(20) NOT NULL,
	 [Weight] INT NOT NULL,
	 CompletionCriteria INT NOT NULL,
	 CONSTRAINT fk_Assessment_Course FOREIGN KEY (CourseID) REFERENCES COURSE(CourseID),
	 CONSTRAINT pk_Assessment PRIMARY KEY(CourseID,Category)
)

---CREATE TABLE GRADING
CREATE TABLE GRADING(
	 CourseID VARCHAR(6) NOT NULL CHECK(CourseID LIKE '[A-Z][A-Z][A-Z][0-9][0-9][0-9]'),
	 Category VARCHAR(20) NOT NULL,
	 StudentID VARCHAR(8) NOT NULL CHECK (StudentID LIKE 'HE[0-9][0-9][0-9][0-9][0-9][0-9]'),
	 Grade FLOAT NOT NULL,
	 CONSTRAINT fk_Grading_Student FOREIGN KEY (StudentID) REFERENCES STUDENT(StudentID),
	 CONSTRAINT fk_Grading_Assessment FOREIGN KEY (CourseID,Category) REFERENCES ASSESSMENT(CourseID,Category),
	 CONSTRAINT pk_Grading PRIMARY KEY(CourseID,Category,StudentID)
)

---CREATE INDEX FOR GRADING
CREATE INDEX index_StudentGrade ON GRADING (StudentID,CourseID)


----------------------------------------------------------------------------------------------------------------------------

---INSERT INTO STUDENT
INSERT INTO STUDENT(StudentID,SurName,MiddleName,GivenName,Email,Gender,Dob) VALUES('HE160666','Green','Swaniawski','Laz','Alexys_Legros@fpt.edu.vn',1,'2000-7-15')
INSERT INTO STUDENT(StudentID,SurName,MiddleName,GivenName,Email,Gender,Dob) VALUES('HE156788','Jarrell','Dibbert','Lin','Gavin@fpt.edu.vn',0,'2002-8-11')
INSERT INTO STUDENT(StudentID,SurName,MiddleName,GivenName,Email,Gender,Dob) VALUES('HE102623','Johanna','Hand','Lacie','Fae@fpt.edu.vn',1,'2001-2-16')
INSERT INTO STUDENT(StudentID,SurName,MiddleName,GivenName,Email,Gender,Dob) VALUES('HE174829','Pedro','Cartwright','Quing','Solon@fpt.edu.vn',1,'2000-11-5')
INSERT INTO STUDENT(StudentID,SurName,MiddleName,GivenName,Email,Gender,Dob) VALUES('HE147255','Tiffany','Schumm','Bert','Lewis_Doyle@fpt.edu.vn',0,'2002-9-3')
INSERT INTO STUDENT(StudentID,SurName,MiddleName,GivenName,Email,Gender,Dob) VALUES('HE161039','Keeley','DAmore','Jane','Russel.Waelchi@fpt.edu.vn',0,'2001-12-10')
INSERT INTO STUDENT(StudentID,SurName,MiddleName,GivenName,Email,Gender,Dob) VALUES('HE155022','Presley','Sporer','Kayce','Jalon@fpt.edu.vn',1,'2003-12-12')
INSERT INTO STUDENT(StudentID,SurName,MiddleName,GivenName,Email,Gender,Dob) VALUES('HE120192','Flo','Turner','Mune','Charlotte@fpt.edu.vn',0,'2002-11-29')
INSERT INTO STUDENT(StudentID,SurName,MiddleName,GivenName,Email,Gender,Dob) VALUES('HE138474','Miller','Halvorson','Nocturne','Maryjane.Gutkowski@fpt.edu.vn',0,'2000-12-9')
INSERT INTO STUDENT(StudentID,SurName,MiddleName,GivenName,Email,Gender,Dob) VALUES('HE167821','Zoey','Corwin','Alexa','Mina@fpt.edu.vn',0,'2000-2-18')
INSERT INTO STUDENT(StudentID,SurName,MiddleName,GivenName,Email,Gender,Dob) VALUES('HE160098','Leora','Collier','Oin','Kayley@fpt.edu.vn',1,'2001-11-23')
INSERT INTO STUDENT(StudentID,SurName,MiddleName,GivenName,Email,Gender,Dob) VALUES('HE151234','Assunta','Gottlieb','Lao','Domenico_Stehr@fpt.edu.vn',1,'2001-7-26')
INSERT INTO STUDENT(StudentID,SurName,MiddleName,GivenName,Email,Gender,Dob) VALUES('HE143202','Darrin','Kutcht','Sheng','Oda@fpt.edu.vn',0,'2000-12-1')
INSERT INTO STUDENT(StudentID,SurName,MiddleName,GivenName,Email,Gender,Dob) VALUES('HE150192','Rae','McLaughlin','Lilla','Maximillia.Grant@fpt.edu.vn',1,'2002-5-25')
INSERT INTO STUDENT(StudentID,SurName,MiddleName,GivenName,Email,Gender,Dob) VALUES('HE170101','Baron','Larson','Vie','Dianna@fpt.edu.vn',1,'2000-12-2')

---INSERT INSTRUCTOR
INSERT INTO INSTRUCTOR(InstructorID,FirstName,LastName,Email) VALUES ('SonNT5','Son','Ngo','sonnt69@fe.edu.vn')
INSERT INTO INSTRUCTOR(InstructorID,FirstName,LastName,Email) VALUES ('TuNT57','Tu','Nguyen','TuNT57@fe.edu.vn')
INSERT INTO INSTRUCTOR(InstructorID,FirstName,LastName,Email) VALUES ('ChiLP','Chi','Le','chilp@fe.edu.vn')


---INSERT COURSE
INSERT INTO COURSE(CourseID,CourseName) VALUES ('DBI202','Introduction to Databases')
INSERT INTO COURSE(CourseID,CourseName) VALUES ('CSD201','Data Structures and Algorithms')

---INSERT GROUP
INSERT INTO [GROUP](GroupName,CourseID,InstructorID) VALUES ('AI1604','DBI202','SonNT5')
INSERT INTO [GROUP](GroupName,CourseID,InstructorID) VALUES ('AI1604','CSD201','TuNT57')
INSERT INTO [GROUP](GroupName,CourseID,InstructorID) VALUES ('AI1603','DBI202','ChiLP')

---INSERT GROUP_STUDENTS
INSERT INTO GROUP_STUDENTS(GroupName,CourseID,StudentID) VALUES ('AI1604','DBI202','HE102623')
INSERT INTO GROUP_STUDENTS(GroupName,CourseID,StudentID) VALUES ('AI1604','CSD201','HE102623')
INSERT INTO GROUP_STUDENTS(GroupName,CourseID,StudentID) VALUES ('AI1603','DBI202','HE120192')
INSERT INTO GROUP_STUDENTS(GroupName,CourseID,StudentID) VALUES ('AI1604','CSD201','HE120192')
INSERT INTO GROUP_STUDENTS(GroupName,CourseID,StudentID) VALUES ('AI1603','DBI202','HE138474')
INSERT INTO GROUP_STUDENTS(GroupName,CourseID,StudentID) VALUES ('AI1604','CSD201','HE143202')
INSERT INTO GROUP_STUDENTS(GroupName,CourseID,StudentID) VALUES ('AI1604','CSD201','HE150192')
INSERT INTO GROUP_STUDENTS(GroupName,CourseID,StudentID) VALUES ('AI1604','DBI202','HE150192')
INSERT INTO GROUP_STUDENTS(GroupName,CourseID,StudentID) VALUES ('AI1604','DBI202','HE151234')
INSERT INTO GROUP_STUDENTS(GroupName,CourseID,StudentID) VALUES ('AI1604','CSD201','HE151234')
INSERT INTO GROUP_STUDENTS(GroupName,CourseID,StudentID) VALUES ('AI1603','DBI202','HE155022')
INSERT INTO GROUP_STUDENTS(GroupName,CourseID,StudentID) VALUES ('AI1604','DBI202','HE156788')
INSERT INTO GROUP_STUDENTS(GroupName,CourseID,StudentID) VALUES ('AI1604','CSD201','HE156788')
INSERT INTO GROUP_STUDENTS(GroupName,CourseID,StudentID) VALUES ('AI1604','CSD201','HE160098')
INSERT INTO GROUP_STUDENTS(GroupName,CourseID,StudentID) VALUES ('AI1603','DBI202','HE160666')
INSERT INTO GROUP_STUDENTS(GroupName,CourseID,StudentID) VALUES ('AI1604','CSD201','HE160666')
INSERT INTO GROUP_STUDENTS(GroupName,CourseID,StudentID) VALUES ('AI1604','DBI202','HE161039')
INSERT INTO GROUP_STUDENTS(GroupName,CourseID,StudentID) VALUES ('AI1604','DBI202','HE167821')
INSERT INTO GROUP_STUDENTS(GroupName,CourseID,StudentID) VALUES ('AI1604','CSD201','HE170101')
INSERT INTO GROUP_STUDENTS(GroupName,CourseID,StudentID) VALUES ('AI1603','DBI202','HE170101')
INSERT INTO GROUP_STUDENTS(GroupName,CourseID,StudentID) VALUES ('AI1604','DBI202','HE174829')
INSERT INTO GROUP_STUDENTS(GroupName,CourseID,StudentID) VALUES ('AI1604','CSD201','HE174829')

---INSERT TIME_SLOT
INSERT INTO TIME_SLOT(StartTime,EndTime) VALUES ('07:30:00','09:00:00')
INSERT INTO TIME_SLOT(StartTime,EndTime) VALUES ('09:10:00','10:40:00')
INSERT INTO TIME_SLOT(StartTime,EndTime) VALUES ('10:50:00','12:20:00')
INSERT INTO TIME_SLOT(StartTime,EndTime) VALUES ('12:50:00','14:20:00')
INSERT INTO TIME_SLOT(StartTime,EndTime) VALUES ('14:30:00','16:00:00')
INSERT INTO TIME_SLOT(StartTime,EndTime) VALUES ('16:10:00','17:40:00')

---INSERT LECTURE
INSERT INTO LECTURE(GroupName,CourseID,LectureName,InstructorID,TimeSlotID,Room) VALUES ('AI1604','DBI202','The Worlds of Database Systems','SonNT5',2,'B308')
INSERT INTO LECTURE(GroupName,CourseID,LectureName,InstructorID,TimeSlotID,Room) VALUES ('AI1604','CSD201','Course Introduction','TuNT57',1,'A110')
INSERT INTO LECTURE(GroupName,CourseID,LectureName,InstructorID,TimeSlotID,Room) VALUES ('AI1603','DBI202','The Worlds of Database Systems','ChiLP',2,'B207')
INSERT INTO LECTURE(GroupName,CourseID,LectureName,InstructorID,TimeSlotID,Room) VALUES ('AI1604','DBI202','The Relational Model of Data','SonNT5',3,'A301')
INSERT INTO LECTURE(GroupName,CourseID,LectureName,InstructorID,TimeSlotID,Room) VALUES ('AI1604','CSD201','Using Arrays','TuNT57',4,'B308')
INSERT INTO LECTURE(GroupName,CourseID,LectureName,InstructorID,TimeSlotID,Room) VALUES ('AI1603','DBI202','Design Theory for Relational Databases','ChiLP',5,'A301')

---INSERT TAKE_ATTENDANCE
INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (1,'SonNT5','HE102623',1,'9:10:00')
INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (1,'SonNT5','HE150192',1,'9:11:00')
INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (1,'SonNT5','HE156788',1,'9:12:00')
INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (1,'SonNT5','HE161039',1,'10:10:00')
INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (1,'SonNT5','HE167821',0,'10:11:00')
INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (1,'SonNT5','HE174829',0,'11:10:00')

INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (2,'TuNT57','HE120192',1,'7:40:00')
INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (2,'TuNT57','HE143202',1,'7:41:00')
INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (2,'TuNT57','HE150192',0,'7:42:00')
INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (2,'TuNT57','HE151234',1,'7:43:00')
INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (2,'TuNT57','HE156788',0,'7:41:00')
INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (2,'TuNT57','HE102623',0,'7:41:00')
INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (2,'TuNT57','HE160098',1,'7:40:00')
INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (2,'TuNT57','HE160666',1,'7:42:00')
INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (2,'TuNT57','HE170101',0,'7:45:00')
INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (2,'TuNT57','HE174829',1,'7:40:00')

INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (3,'ChiLP','HE120192',1,'9:40:00')
INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (3,'ChiLP','HE155022',0,'9:41:00')
INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (3,'ChiLP','HE160666',1,'9:42:00')
INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (3,'ChiLP','HE170101',1,'9:43:00')

INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (4,'SonNT5','HE120192',1,'10:51:00')
INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (4,'SonNT5','HE138474',1,'10:51:00')
INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (4,'SonNT5','HE155022',0,'10:51:00')
INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (4,'SonNT5','HE160666',1,'10:52:00')
INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (4,'SonNT5','HE170101',1,'10:53:00')

INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (5,'TuNT57','HE120192',1,'13:01:00')
INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (5,'TuNT57','HE143202',1,'13:01:00')
INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (5,'TuNT57','HE150192',0,'13:01:00')
INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (5,'TuNT57','HE151234',1,'13:01:00')
INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (5,'TuNT57','HE156788',0,'13:01:00')
INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (5,'TuNT57','HE160098',1,'13:01:00')
INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (5,'TuNT57','HE160666',1,'13:01:00')
INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (5,'TuNT57','HE170101',1,'13:01:00')
INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (5,'TuNT57','HE174829',0,'13:02:00')
INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (5,'TuNT57','HE102623',1,'13:03:00')

INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (6,'SonNT5','HE120192',1,'14:35:00')
INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (6,'SonNT5','HE138474',1,'14:35:00')
INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (6,'SonNT5','HE155022',1,'14:36:00')
INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (6,'SonNT5','HE160666',0,'14:36:00')
INSERT INTO TAKE_ATTENDANCE(LectureID,InstructorID,StudentID,[Status],RecordTime) VALUES (6,'SonNT5','HE170101',1,'14:37:00')

---INSERT ASSESSMENT
INSERT INTO ASSESSMENT(CourseID,Category,[Weight],CompletionCriteria) VALUES ('DBI202','Lab1',2,0)
INSERT INTO ASSESSMENT(CourseID,Category,[Weight],CompletionCriteria) VALUES ('DBI202','Lab2',2,0)
INSERT INTO ASSESSMENT(CourseID,Category,[Weight],CompletionCriteria) VALUES ('DBI202','Lab3',2,0)
INSERT INTO ASSESSMENT(CourseID,Category,[Weight],CompletionCriteria) VALUES ('DBI202','Lab4',2,0)
INSERT INTO ASSESSMENT(CourseID,Category,[Weight],CompletionCriteria) VALUES ('DBI202','Lab5',2,0)
INSERT INTO ASSESSMENT(CourseID,Category,[Weight],CompletionCriteria) VALUES ('DBI202','Progress Test 1',5,0)
INSERT INTO ASSESSMENT(CourseID,Category,[Weight],CompletionCriteria) VALUES ('DBI202','Progress Test 2',5,0)
INSERT INTO ASSESSMENT(CourseID,Category,[Weight],CompletionCriteria) VALUES ('DBI202','Assignment',20,0)
INSERT INTO ASSESSMENT(CourseID,Category,[Weight],CompletionCriteria) VALUES ('DBI202','Practical Exam',30,0)
INSERT INTO ASSESSMENT(CourseID,Category,[Weight],CompletionCriteria) VALUES ('DBI202','Final Exam',30,4)

INSERT INTO ASSESSMENT(CourseID,Category,[Weight],CompletionCriteria) VALUES ('CSD201','Assignment 1',10,0)
INSERT INTO ASSESSMENT(CourseID,Category,[Weight],CompletionCriteria) VALUES ('CSD201','Assignment 2',10,0)
INSERT INTO ASSESSMENT(CourseID,Category,[Weight],CompletionCriteria) VALUES ('CSD201','Progress Test 1',10,0)
INSERT INTO ASSESSMENT(CourseID,Category,[Weight],CompletionCriteria) VALUES ('CSD201','Progress Test 2',10,0)
INSERT INTO ASSESSMENT(CourseID,Category,[Weight],CompletionCriteria) VALUES ('CSD201','Practical Exam',30,0)
INSERT INTO ASSESSMENT(CourseID,Category,[Weight],CompletionCriteria) VALUES ('CSD201','Final Exam',30,4)

---INSERT INTO GRADING
INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('DBI202','Lab1','HE120192',7.5)
INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('DBI202','Lab2','HE120192',8.5)
INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('DBI202','Lab3','HE120192',8)
INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('DBI202','Lab4','HE120192',7.5)
INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('DBI202','Lab5','HE120192',9)
INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('DBI202','Progress Test 1','HE120192',8)
INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('DBI202','Progress Test 2','HE120192',8.5)
INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('DBI202','Assignment','HE120192',9)
INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('DBI202','Practical Exam','HE120192',7.5)
INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('DBI202','Final Exam','HE120192',6)

INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('DBI202','Lab1','HE138474',4)
INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('DBI202','Lab2','HE138474',5)
INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('DBI202','Lab3','HE138474',6.5)
INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('DBI202','Lab4','HE138474',7)
INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('DBI202','Lab5','HE138474',6)
INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('DBI202','Progress Test 1','HE138474',7)
INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('DBI202','Assignment','HE138474',6.5)

INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('DBI202','Lab1','HE155022',6)
INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('DBI202','Lab2','HE155022',6.5)
INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('DBI202','Lab3','HE155022',5)
INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('DBI202','Lab4','HE155022',4)
INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('DBI202','Lab5','HE155022',5)
INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('DBI202','Progress Test 1','HE155022',7.5)
INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('DBI202','Progress Test 2','HE155022',7)
INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('DBI202','Assignment','HE155022',6.5)
INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('DBI202','Practical Exam','HE155022',6)
INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('DBI202','Final Exam','HE155022',3.8)

INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('CSD201','Assignment 1','HE102623',7)
INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('CSD201','Assignment 2','HE102623',8.5)
INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('CSD201','Progress Test 1','HE102623',7)
INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('CSD201','Progress Test 2','HE102623',9)
INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('CSD201','Practical Exam','HE102623',8)
INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('CSD201','Final Exam','HE102623',6.5)

INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('CSD201','Assignment 1','HE160098',5)
INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('CSD201','Assignment 2','HE160098',8)
INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('CSD201','Progress Test 1','HE160098',6.5)
INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('CSD201','Progress Test 2','HE160098',6)

INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('CSD201','Assignment 1','HE174829',3)
INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('CSD201','Assignment 2','HE174829',4)
INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('CSD201','Progress Test 1','HE174829',4.5)
INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('CSD201','Progress Test 2','HE174829',5)
INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('CSD201','Practical Exam','HE174829',2)
INSERT INTO GRADING (CourseID,Category,StudentID,Grade) VALUES ('CSD201','Final Exam','HE174829',5)

----------------------------------------------------------------------------------------------------------------------------

---SELECT FROM ALL TABLES
SELECT * FROM STUDENT
SELECT * FROM INSTRUCTOR
SELECT * FROM COURSE
SELECT * FROM [GROUP]
SELECT * FROM GROUP_STUDENTS
SELECT * FROM TIME_SLOT
SELECT * FROM LECTURE
SELECT * FROM TAKE_ATTENDANCE
SELECT * FROM ASSESSMENT
SELECT * FROM GRADING

/*DROP TABLE GRADING
DROP TABLE ASSESSMENT
DROP TABLE TAKE_ATTENDANCE
DROP TABLE LECTURE
DROP TABLE TIME_SLOT
DROP TABLE GROUP_STUDENTS
DROP TABLE [GROUP]
DROP TABLE COURSE
DROP TABLE STUDENT
DROP TABLE INSTRUCTOR*/







