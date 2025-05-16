**Library Management System**

*Description*
This project is a relational database schema designed for managing a library's operations using MySQL. It supports essential features such as tracking books, authors, members, and loans. The system includes:

    Well-structured tables with appropriate constraints (primary keys, foreign keys, unique constraints, and not nulls).

    One-to-many and many-to-many relationships.

    Sample data to get started quickly.

    Views to easily query active loans.

    Triggers to automate inventory management (e.g., decrement book copies when loaned).

    Stored procedures to identify overdue loans.

This database is ideal for library staff to manage book lending and monitor the availability of library resources efficiently.

How to Set Up and Run

        Install MySQL on your system if it is not already installed.

        Open your preferred MySQL client (e.g., MySQL Workbench, phpMyAdmin, or command line).

Create a new database or use an existing one, e.g.:


    CREATE DATABASE library_db;
    USE library_db;
    
Import the SQL schema and sample data from the provided library_management.sql file:

In MySQL Workbench:
    Go to File > Run SQL Script..., select library_management.sql, and execute.

In command line:

    mysql -u your_username -p library_db < library_management.sql
    
The tables, sample data, views, triggers, and stored procedures will be created.

To view active loans, run:

    SELECT * FROM Active_Loans;
    
To check overdue loans, call the stored procedure:

    CALL GetOverdueLoans();
    
ER Diagram
![ERD](https://github.com/user-attachments/assets/19f2edd8-2565-434a-871e-82a0c322b03c)
