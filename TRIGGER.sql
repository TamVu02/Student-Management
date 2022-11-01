---CREATE TRIGGER FOR LECTURE
CREATE TRIGGER trigger_Lecture ON LECTURE AFTER INSERT AS
     DECLARE @GroupName VARCHAR(20)
	 DECLARE @CourseID VARCHAR(20)
	 DECLARE @InstructorID VARCHAR(20)
	 DECLARE @InsID2 VARCHAR(20)
	 SELECT @GroupName=GroupName FROM inserted
	 SELECT @CourseID=CourseID FROM inserted
	 SELECT @InstructorID=InstructorID FROM inserted
	 SELECT @InsID2=InstructorID FROM [GROUP] WHERE CourseID=@CourseID AND GroupName=@GroupName
	 IF @InstructorID <> @InsID2
	  BEGIN
	   PRINT @InstructorID+' can not teachs this lecture'
	   ROLLBACK TRANSACTION
	  END

---CREATE TRIGGER FOR TAKE ATTENDANCE
CREATE TRIGGER trigger_Attendance ON TAKE_ATTENDANCE AFTER INSERT AS
     DECLARE @LecID INT
	 SELECT @LecID=LectureID FROM inserted

	 ---Student
	 DECLARE @StuID VARCHAR(10)
	 SELECT @StuID=StudentID FROM inserted
	 IF @StuID NOT IN (SELECT g.StudentID FROM LECTURE l INNER JOIN GROUP_STUDENTS g ON l.GroupName=g.GroupName 
	 AND l.CourseID=g.CourseID WHERE l.LectureID=@LecID)
	   BEGIN
	     PRINT @StuID+' does not in this Group'
		 ROLLBACK TRANSACTION
	   END

	 ---Instructor
	 DECLARE @InsID VARCHAR(10)
	 SELECT @InsID=InstructorID FROM inserted
	 IF @InsID <> (SELECT InstructorID FROM LECTURE WHERE LectureID=@LecID)
	   BEGIN
	     PRINT @InsID+' alternative teach this lecture'
	   END

     ---Record time
     DECLARE @RecordTime TIME
	 DECLARE @Start TIME
	 SELECT @RecordTime=RecordTime FROM inserted
	 SELECT @Start=t.StartTime FROM [LECTURE] l INNER JOIN TIME_SLOT t ON LectureID=@LecID AND l.TimeSlotID=t.TimeSlotID
	 IF @RecordTime < @Start
	   BEGIN
	     PRINT 'Record Time('+CAST(@RecordTime AS VARCHAR(50))+') must not before '+CAST(@Start AS VARCHAR(50))
		 ROLLBACK TRANSACTION
	   END

---CREATE TRIGGER FOR ASSESSMENT
CREATE TRIGGER trigger_Assessment ON ASSESSMENT AFTER INSERT AS
     DECLARE @CourseID VARCHAR(10)
	 DECLARE @Weight INT
	 DECLARE @SumWeight INT
	 SELECT @CourseID=CourseID FROM inserted
	 SELECT @Weight=[Weight] FROM inserted
	 SELECT @SumWeight = (SELECT SUM([Weight]) FROM ASSESSMENT WHERE CourseID=@CourseID)
	 IF @Weight > (100-@SumWeight+@Weight)
	   BEGIN
	     PRINT 'This category weight can not exceed '+CAST((100-@SumWeight+@Weight) AS VARCHAR(10))+'%'
		 ROLLBACK TRANSACTION
	   END

---CREATE TRIGGER FOR GRADING
CREATE TRIGGER trigger_Grading ON GRADING AFTER INSERT AS
     DECLARE @StuID VARCHAR(10)
	 DECLARE @CourseID VARCHAR(10)
	 SELECT @StuID=StudentID FROM inserted
	 SELECT @CourseID=CourseID FROM inserted
	 IF @CourseID NOT IN (SELECT CourseID FROM GROUP_STUDENTS WHERE StudentID=@StuID)
	   BEGIN
	     PRINT @StuID+' does not enroll course name '+@CourseID
		 ROLLBACK TRANSACTION
	   END
     

/*DROP TRIGGER trigger_Lecture
DROP TRIGGER trigger_Attendance
DROP TRIGGER trigger_Assessment
DROP TRIGGER trigger_Grading*/