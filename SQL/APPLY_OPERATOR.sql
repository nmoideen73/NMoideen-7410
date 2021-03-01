
/*
The APPLY operator allows you to join two table expressions; 
the right table expression is processed every time for each row from the left table expression
*/

/*
 has two variants; CROSS APPLY and OUTER APPLY
The CROSS APPLY operator returns only those rows from the left table expression - if it matches with the right table expression. 
The OUTER APPLY operator returns all the rows from the left table expression irrespective of its match with the right table expression.
 - it may contains NULL values in columns of the right table expression.
*/


CREATE TABLE [Department]( 
   [DepartmentID] [int] NOT NULL PRIMARY KEY, 
   [Name] VARCHAR(250) NOT NULL, 
) ON [PRIMARY] 

INSERT [Department] ([DepartmentID], [Name])  
VALUES (1, N'Engineering') 
INSERT [Department] ([DepartmentID], [Name])  
VALUES (2, N'Administration') 
INSERT [Department] ([DepartmentID], [Name])  
VALUES (3, N'Sales') 
INSERT [Department] ([DepartmentID], [Name])  
VALUES (4, N'Marketing') 
INSERT [Department] ([DepartmentID], [Name])  
VALUES (5, N'Finance') 
GO 

CREATE TABLE [Employee]( 
   [EmployeeID] [int] NOT NULL PRIMARY KEY, 
   [FirstName] VARCHAR(250) NOT NULL, 
   [LastName] VARCHAR(250) NOT NULL, 
   [DepartmentID] [int] NOT NULL REFERENCES [Department](DepartmentID), 
) ON [PRIMARY] 
GO
 
INSERT [Employee] ([EmployeeID], [FirstName], [LastName], [DepartmentID]) 
VALUES (1, N'Orlando', N'Gee', 1 ) 
INSERT [Employee] ([EmployeeID], [FirstName], [LastName], [DepartmentID]) 
VALUES (2, N'Keith', N'Harris', 2 ) 
INSERT [Employee] ([EmployeeID], [FirstName], [LastName], [DepartmentID]) 
VALUES (3, N'Donna', N'Carreras', 3 ) 
INSERT [Employee] ([EmployeeID], [FirstName], [LastName], [DepartmentID]) 
VALUES (4, N'Janet', N'Gates', 3 ) 

SELECT TOP (1000) [DepartmentID]
      ,[Name]
  FROM [ES_UID_TEST].[dbo].[Department]

SELECT TOP (1000) [EmployeeID]
      ,[FirstName]
      ,[LastName]
      ,[DepartmentID]
  FROM [ES_UID_TEST].[dbo].[Employee]



/*
CROSS APPLY is equivalent to an INNER JOIN
*/

SELECT * FROM Department D 
INNER JOIN Employee E ON D.DepartmentID = E.DepartmentID 
GO 

SELECT * FROM Department D 
CROSS APPLY 
   ( 
   SELECT * FROM Employee E 
   WHERE E.DepartmentID = D.DepartmentID 
   ) A 
GO


/*
OUTER APPLY is equivalent to a LEFT OUTER JOIN.
*/

SELECT * FROM Department D 
LEFT OUTER JOIN Employee E ON D.DepartmentID = E.DepartmentID 
GO 

SELECT * FROM Department D 
OUTER APPLY 
   ( 
   SELECT * FROM Employee E 
   WHERE E.DepartmentID = D.DepartmentID 
   ) A 
GO

/*
Joining table valued functions and tables using APPLY operators
*/

CREATE FUNCTION dbo.fn_GetAllEmployeeOfADepartment(@DeptID AS INT)  
RETURNS TABLE 
AS 
RETURN 
   ( 
   SELECT * FROM Employee E 
   WHERE E.DepartmentID = @DeptID 
   ) 
GO

SELECT * FROM Department D 
CROSS APPLY dbo.fn_GetAllEmployeeOfADepartment(D.DepartmentID) 
GO
 
 
SELECT * FROM Department D 
OUTER APPLY dbo.fn_GetAllEmployeeOfADepartment(D.DepartmentID) 
GO 