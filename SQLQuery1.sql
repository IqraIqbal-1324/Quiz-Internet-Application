-- Create Database
CREATE DATABASE IADLAB08_quizapplication_final;
GO

USE IADLAB08_quizapplication_final;
GO

-- USERS TABLE
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Username NVARCHAR(50) NOT NULL UNIQUE,
    Password NVARCHAR(50) NOT NULL,
    Role NVARCHAR(20) NOT NULL -- Admin, Teacher, Student
);

-- QUESTIONS TABLE
CREATE TABLE Questions (
    QuestionID INT PRIMARY KEY IDENTITY(1,1),
    QuestionText NVARCHAR(MAX) NOT NULL,
    OptionA NVARCHAR(200) NOT NULL,
    OptionB NVARCHAR(200) NOT NULL,
    OptionC NVARCHAR(200) NOT NULL,
    OptionD NVARCHAR(200) NOT NULL,
    CorrectOption CHAR(1) NOT NULL, -- A, B, C, D
    Subject NVARCHAR(50),
    DifficultyLevel NVARCHAR(20),
    TeacherID INT FOREIGN KEY REFERENCES Users(UserID)
);

-- QUIZ TABLE
CREATE TABLE Quiz (
    QuizID INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(100) NOT NULL,
    TotalQuestions INT,
    TotalMarks INT,
    Duration INT, -- in minutes
    StartTime DATETIME,
    ShuffleQuestions BIT DEFAULT 0,
    ShuffleOptions BIT DEFAULT 0,
    AttemptOnlyOnce BIT DEFAULT 1,
    AllowReview BIT DEFAULT 0,
    CreatedBy INT FOREIGN KEY REFERENCES Users(UserID)
);

-- QUIZ QUESTIONS TABLE
CREATE TABLE QuizQuestions (
    ID INT PRIMARY KEY IDENTITY(1,1),
    QuizID INT FOREIGN KEY REFERENCES Quiz(QuizID),
    QuestionID INT FOREIGN KEY REFERENCES Questions(QuestionID),
    Marks INT DEFAULT 1
);

-- ANSWERS TABLE
CREATE TABLE Answers (
    AnswerID INT PRIMARY KEY IDENTITY(1,1),
    StudentID INT FOREIGN KEY REFERENCES Users(UserID),
    QuizID INT FOREIGN KEY REFERENCES Quiz(QuizID),
    QuestionID INT FOREIGN KEY REFERENCES Questions(QuestionID),
    SelectedOption CHAR(1),
    CorrectOption CHAR(1),
    MarksObtained INT DEFAULT 0
);

-- RESULTS TABLE
CREATE TABLE Results (
    ResultID INT PRIMARY KEY IDENTITY(1,1),
    StudentID INT FOREIGN KEY REFERENCES Users(UserID),
    QuizID INT FOREIGN KEY REFERENCES Quiz(QuizID),
    Score INT,
    TotalMarks INT,
    AttemptDate DATETIME DEFAULT GETDATE(),

    CONSTRAINT UQ_Student_Quiz UNIQUE(StudentID, QuizID)
);

-- SAMPLE USERS
INSERT INTO Users (Username, Password, Role) VALUES
('admin', '123', 'Admin'),
('teacher1', '123', 'Teacher'),
('student1', '123', 'Student');

INSERT INTO Quiz 
(Title, TotalQuestions, TotalMarks, Duration, StartTime, ShuffleQuestions, ShuffleOptions, AttemptOnlyOnce, AllowReview, CreatedBy)
VALUES
('Sample Quiz', 5, 5, 30, GETDATE(), 1, 1, 1, 0, 2);

SELECT * FROM Quiz;

USE IADLAB08_quizapplication_final;
GO

SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Users';

ALTER TABLE Questions
ADD QuestionType NVARCHAR(20);

UPDATE Questions
SET QuestionType = DifficultyLevel
WHERE QuestionType IS NULL;

USE IADLAB08_quizapplication_final;
GO

ALTER TABLE Questions
ADD QuestionType NVARCHAR(20);
GO

UPDATE Questions
SET QuestionType = DifficultyLevel
WHERE QuestionType IS NULL;
GO