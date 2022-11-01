CREATE PROC spGrade
     @StudentID VARCHAR(10),
	 @CourseID VARCHAR(10),
	 @Average FLOAT OUT
AS
BEGIN
     DECLARE @avg FLOAT = 0
	 DECLARE @countFromGrade INT
	 DECLARE @countFromAssessment INT
	 SET @countFromGrade = (SELECT COUNT(*) FROM GRADING WHERE StudentID=@StudentID AND CourseID=@CourseID)
	 SET @countFromAssessment = ( SELECT COUNT(*) FROM ASSESSMENT WHERE CourseID=@CourseID)
	 IF @countFromGrade != @countFromAssessment
	   BEGIN
	     PRINT 'Status: NOT (YET) PASS'
	   END
	 ELSE
	   BEGIN
	     DECLARE @Cate VARCHAR(50)
		 DECLARE @Grade FLOAT
	     DECLARE grade_cursor CURSOR FOR
		 SELECT Category,Grade FROM GRADING WHERE StudentID=@StudentID AND CourseID=@CourseID
		 OPEN grade_cursor
		 FETCH NEXT FROM grade_cursor INTO @Cate,@Grade
		 WHILE @@FETCH_STATUS = 0  
		  BEGIN
		    IF @Grade < (SELECT CompletionCriteria FROM ASSESSMENT WHERE CourseID=@CourseID AND Category=@Cate)
			  BEGIN
			    PRINT 'Status: '+@StudentID+' fail course '+@CourseID
			  END
		    ELSE
			  BEGIN
			    SET @avg= @avg + @Grade*(SELECT [Weight] FROM ASSESSMENT WHERE CourseID=@CourseID AND Category=@Cate)/100
			  END
		    FETCH NEXT FROM grade_cursor INTO @Cate,@Grade
		  END
	     IF @avg < 5
	       BEGIN
		     PRINT 'Status: '+@StudentID+' fail course '+@CourseID
		   END
	     ELSE
	       BEGIN
		     PRINT 'Status: PASS'
		   END
	     CLOSE grade_cursor
         DEALLOCATE grade_cursor
	   END
	   SET @Average = @avg
END

---DROP PROC spGrade
