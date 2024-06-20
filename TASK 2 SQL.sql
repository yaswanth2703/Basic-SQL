
/* #1- How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"? */

CREATE PROC dbo.bookCopiesAtAllSharpstown 
(@bookTitle varchar(70) = 'The Lost Tribe', @branchName varchar(70) = 'Sharpstown')
AS
SELECT copies.book_copies_BranchID AS [Branch ID], branch.library_branch_BranchName AS [Branch Name],
	   copies.book_copies_No_Of_Copies AS [Number of Copies],
	   book.book_Title AS [Book Title]
	   FROM tbl_book_copies AS copies
			INNER JOIN tbl_book AS book ON copies.book_copies_BookID = book.book_BookID
			INNER JOIN tbl_library_branch AS branch ON book_copies_BranchID = branch.library_branch_BranchID
	   WHERE book.book_Title = @bookTitle AND branch.library_branch_BranchName = @branchName
GO
EXEC dbo.bookCopiesAtAllSharpstown 
drop proc dbo.bookCopiesAtAllSharpstown

/* #2- How many copies of the book titled "The Lost Tribe" are owned by each library branch? */

CREATE PROC dbo.bookCopiesAtAllBranches 
(@bookTitle varchar(70) = 'The Lost Tribe')
AS
SELECT copies.book_copies_BranchID AS [Branch ID], branch.library_branch_BranchName AS [Branch Name],
	   copies.book_copies_No_Of_Copies AS [Number of Copies],
	   book.book_Title AS [Book Title]
	   FROM tbl_book_copies AS copies
			INNER JOIN tbl_book AS book ON copies.book_copies_BookID = book.book_BookID
			INNER JOIN tbl_library_branch AS branch ON book_copies_BranchID = branch.library_branch_BranchID
	   WHERE book.book_Title = @bookTitle 
GO
EXEC dbo.bookCopiesAtAllBranches


/* #3- Retrieve the names of all borrowers who do not have any books checked out. */
		
CREATE PROC dbo.NoLoans
AS
SELECT borrower_BorrowerName FROM tbl_borrower
	WHERE NOT EXISTS
		(SELECT * FROM tbl_book_loans
		WHERE book_loans_CardNo = borrower_CardNo)
GO
EXEC dbo.NoLoans
drop procedure dbo.NoLoans

/* #4- For each book that is loaned out from the "Sharpstown" branch and whose DueDate is today, retrieve the book title, the borrower's name, and the borrower's address.  */

CREATE PROC dbo.LoanersInfo 
(@DueDate date = NULL, @LibraryBranchName varchar(50) = 'Sharpstown')
AS
SET @DueDate = GETDATE()
SELECT Branch.library_branch_BranchName AS [Branch Name],  Book.book_Title [Book Name],
	   Borrower.borrower_BorrowerName AS [Borrower Name], Borrower.borrower_BorrowerAddress AS [Borrower Address],
	   Loans.book_loans_DateOut AS [Date Out], Loans.book_loans_DueDate [Due Date]
	   FROM tbl_book_loans AS Loans
			INNER JOIN tbl_book AS Book ON Loans.book_loans_BookID = Book.book_BookID
			INNER JOIN tbl_borrower AS Borrower ON Loans.book_loans_CardNo = Borrower.borrower_CardNo
			INNER JOIN tbl_library_branch AS Branch ON Loans.book_loans_BranchID = Branch.library_branch_BranchID
		WHERE Loans.book_loans_DueDate = @DueDate AND Branch.library_branch_BranchName = @LibraryBranchName
GO
EXEC dbo.LoanersInfo 

drop proc dbo.LoanersInfo 
/* #5- For each library branch, retrieve the branch name and the total number of books loaned out from that branch.  */

CREATE PROC dbo.TotalLoansPerBranch
AS
SELECT  Branch.library_branch_BranchName AS [Branch Name], COUNT (Loans.book_loans_BranchID) AS [Total Loans]
		FROM tbl_book_loans AS Loans
			INNER JOIN tbl_library_branch AS Branch ON Loans.book_loans_BranchID = Branch.library_branch_BranchID
			GROUP BY library_branch_BranchName
GO
EXEC dbo.TotalLoansPerBranch

/* #6- Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out. */

CREATE PROC dbo.BooksLoanedOut
(@BooksCheckedOut INT = 5)
AS
	SELECT Borrower.borrower_BorrowerName AS [Borrower Name], Borrower.borrower_BorrowerAddress AS [Borrower Address],
		   COUNT(Borrower.borrower_BorrowerName) AS [Books Checked Out]
		   FROM tbl_book_loans AS Loans
		   			INNER JOIN tbl_borrower AS Borrower ON Loans.book_loans_CardNo = Borrower.borrower_CardNo
					GROUP BY Borrower.borrower_BorrowerName, Borrower.borrower_BorrowerAddress
		   HAVING COUNT(Borrower.borrower_BorrowerName) >= @BooksCheckedOut
GO
EXEC dbo.BooksLoanedOut



/* #7- For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".*/

CREATE PROC dbo.BookbyAuthorandBranch
	(@BranchName varchar(50) = 'Central', @AuthorName varchar(50) = 'Stephen King')
AS
	SELECT Branch.library_branch_BranchName AS [Branch Name], Book.book_Title AS [Title], Copies.book_copies_No_Of_Copies AS [Number of Copies]
		   FROM tbl_book_authors AS Authors
				INNER JOIN tbl_book AS Book ON Authors.book_authors_BookID = Book.book_BookID
				INNER JOIN tbl_book_copies AS Copies ON Authors.book_authors_BookID = Copies.book_copies_BookID
				INNER JOIN tbl_library_branch AS Branch ON Copies.book_copies_BranchID = Branch.library_branch_BranchID
			WHERE Branch.library_branch_BranchName = @BranchName AND Authors.book_authors_AuthorName = @AuthorName
GO	
EXEC dbo.BookbyAuthorandBranch

/* ==================================== STORED PROCEDURE QUERY QUESTIONS =================================== */
CREATE DATABASE LibraryManagement;

USE LibraryManagement;

CREATE TABLE Books (
    BookID INT PRIMARY KEY IDENTITY,
    Title VARCHAR(255) NOT NULL,
    Author VARCHAR(255) NOT NULL,
    Category VARCHAR(100),
    Price DECIMAL(10, 2),
    Status VARCHAR(50),
    TotalCopies INT
);
 SELECT * from Books
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE,
    MembershipDate DATE
);
SELECT * from users
drop table users
CREATE TABLE IssuedBooks (
    IssueID INT PRIMARY KEY IDENTITY,
    BookID INT,
    UserID INT,
    IssueDate DATE,
    ReturnDate DATE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
SELECT * from IssuedBooks
Inserting Sample Data:

sql
Copy code
INSERT INTO Books (Title, Author, Category, Price, Status, TotalCopies)
VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', 'Fiction', 10.99, 'Available', 5),
('1984', 'George Orwell', 'Dystopian', 8.99, 'Available', 3),
('To Kill a Mockingbird', 'Harper Lee', 'Fiction', 12.99, 'Available', 4);

INSERT INTO Users (Name, Email, MembershipDate)
VALUES
('Alice Johnson', 'alice@example.com', '2024-01-15'),
('Bob Smith', 'bob@example.com', '2024-02-20');
Query to Issue a Book:
sql
Copy code
INSERT INTO IssuedBooks (BookID, UserID, IssueDate, ReturnDate)
VALUES (1, 1, '2024-05-20', NULL);

 UPDATE IssuedBooks
SET ReturnDate = '2024-06-10'
WHERE IssueID = 1;

UPDATE Books
SET Status = 'Available'
WHERE BookID = 1;
Query to Categorize Books:
sql
Copy code
SELECT Category, COUNT(*) AS NumberOfBooks
FROM Books
GROUP BY Category;
Query to Track Book Availability:
sql
Copy code
SELECT Title, Status
FROM Books;
Task 2: Student Database Management
Project Summary: Create a system to manage student records, including personal details and academic performance.

Database Design:

Tables:
Students: StudentID, Name, Address, DepartmentID, DateOfBirth
Departments: DepartmentID, DepartmentName
Attendance: AttendanceID, StudentID, Date, Status
Performance: PerformanceID, StudentID, Subject, Marks
SQL Scripts:

Creating Tables:
sql
Copy code
CREATE DATABASE StudentManagement;


USE StudentManagement;

CREATE TABLE Students (
    StudentID INT PRIMARY KEY IDENTITY,
    Name VARCHAR(255) NOT NULL,
    Address VARCHAR(255),
    DepartmentID INT,
    DateOfBirth DATE
);
SELECT * from students
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY IDENTITY,
    DepartmentName VARCHAR(255) NOT NULL
);
SELECT * from departments
CREATE TABLE Attendance (
    AttendanceID INT PRIMARY KEY IDENTITY,
    StudentID INT,
    Date DATE,
    Status VARCHAR(50),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);
SELECT * from attendance
CREATE TABLE Performance (
    PerformanceID INT PRIMARY KEY IDENTITY,
    StudentID INT,
    Subject VARCHAR(255),
    Marks INT,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);
SELECT * from performance
Inserting Sample Data:
sql
Copy code
INSERT INTO Departments (DepartmentName)
VALUES ('Computer Science'), ('Mathematics');

INSERT INTO Students (Name, Address, DepartmentID, DateOfBirth)
VALUES
('John Doe', '123 Elm St', 1, '2000-04-23'),
('Jane Smith', '456 Oak St', 2, '1999-08-15');

INSERT INTO Performance (StudentID, Subject, Marks)
VALUES
(1, 'Math', 85),
(2, 'Math', 90);
Query to Get Student Details:
sql
Copy code
SELECT * FROM Students;
Query to Get Department-Specific Data:
sql
Copy code
SELECT s.Name, d.DepartmentName
FROM Students s
JOIN Departments d ON s.DepartmentID = d.DepartmentID;
Query to Track Attendance:
sql
Copy code
SELECT s.Name, a.Date, a.Status
FROM Attendance a
JOIN Students s ON a.StudentID = s.StudentID;
Query to Track Performance:
sql
Copy code
SELECT s.Name, p.Subject, p.Marks
FROM Performance p
JOIN Students s ON p.StudentID = s.StudentID;
