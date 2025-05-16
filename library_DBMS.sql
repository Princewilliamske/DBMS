-- Clean up existing tables
DROP TABLE IF EXISTS Book_Author, Loans, Books, Authors, Members, Categories;

-- 1. Table: Categories
CREATE TABLE Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- 2. Table: Authors
CREATE TABLE Authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    bio TEXT
);

-- 3. Table: Books
CREATE TABLE Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    isbn VARCHAR(13) UNIQUE,
    published_year YEAR,
    category_id INT,
    copies_available INT DEFAULT 0,
    CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

-- 4. Many-to-Many Table: Book_Author
CREATE TABLE Book_Author (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id) ON DELETE CASCADE
);

-- 5. Table: Members
CREATE TABLE Members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    join_date DATE NOT NULL
);

-- 6. Table: Loans
CREATE TABLE Loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    loan_date DATE NOT NULL,
    return_date DATE,
    returned BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);

-- 7. Sample Data: Categories
INSERT INTO Categories (name) VALUES 
('Fiction'),
('Science'),
('History');

-- 8. Sample Data: Authors
INSERT INTO Authors (name, bio) VALUES 
('George Orwell', 'Author of 1984 and Animal Farm'),
('Isaac Newton', 'Physicist and mathematician'),
('Yuval Noah Harari', 'Author of Sapiens and Homo Deus');

-- 9. Sample Data: Books
INSERT INTO Books (title, isbn, published_year, category_id, copies_available) VALUES 
('1984', '1234567890123', 1949, 1, 5),
('Principia Mathematica', '2345678901234', 1687, 2, 3),
('Sapiens', '3456789012345', 2011, 3, 4);

-- 10. Sample Data: Book_Author
INSERT INTO Book_Author (book_id, author_id) VALUES
(1, 1),
(2, 2),
(3, 3);

-- 11. Sample Data: Members
INSERT INTO Members (full_name, email, join_date) VALUES
('Alice Johnson', 'alice@example.com', '2023-01-10'),
('Bob Smith', 'bob@example.com', '2023-03-15');

-- 12. Sample Data: Loans
INSERT INTO Loans (book_id, member_id, loan_date, return_date, returned) VALUES
(1, 1, '2024-04-01', NULL, FALSE),
(2, 2, '2024-03-20', '2024-04-10', TRUE);

-- 13. View: Active Loans
CREATE VIEW Active_Loans AS
SELECT 
    l.loan_id,
    m.full_name,
    b.title AS book_title,
    l.loan_date,
    l.return_date
FROM Loans l
JOIN Members m ON l.member_id = m.member_id
JOIN Books b ON l.book_id = b.book_id
WHERE l.returned = FALSE;

-- 14. Trigger: Decrement copies when loan is added
DELIMITER //
CREATE TRIGGER trg_decrement_copies
AFTER INSERT ON Loans
FOR EACH ROW
BEGIN
    IF NEW.returned = FALSE THEN
        UPDATE Books
        SET copies_available = copies_available - 1
        WHERE book_id = NEW.book_id;
    END IF;
END;
//
DELIMITER ;

-- 15. Stored Procedure: Get Overdue Loans
DELIMITER //
CREATE PROCEDURE GetOverdueLoans()
BEGIN
    SELECT 
        l.loan_id,
        m.full_name,
        b.title AS book_title,
        l.loan_date
    FROM Loans l
    JOIN Members m ON l.member_id = m.member_id
    JOIN Books b ON l.book_id = b.book_id
    WHERE l.returned = FALSE
      AND l.loan_date < CURDATE() - INTERVAL 30 DAY;
END;
//
DELIMITER ;
