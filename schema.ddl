DROP SCHEMA IF EXISTS bestseller CASCADE;
CREATE SCHEMA bestseller;
SET SEARCH_PATH TO bestseller;

---------------------------------
----- New changes in phase3 -----
-- We remove the table "Booktype", add new attribute "genre" (which is used to be in Booktype) to table Book.
-- We still keep table "Author" because we think we need to avoid redundancy, 
-- and we decided to use "Written" to describe the relationship between Book & its Author, 
-- as a author may write many books.

-- A type describes the genre of an Amazon's Top 50 bestselling book.
-- It can only be either Fiction or Non Fiction.
CREATE DOMAIN Genre AS VARCHAR(15)
    CHECK (Value = 'Fiction' or Value = 'Non Fiction');

-- An Amazon's Top 50 bestselling book.
-- BID is the book's ID, bookname is the tile of the book, 
-- and price is the price of the book,
-- genre is the type of the book, it can be either Fiction or Non Fiction.
CREATE TABLE Book(
    BID SERIAL PRIMARY Key,
    bookname TEXT NOT NULL,
    price INT NOT NULL,
    genre Genre NOT NULL
);

-- The author of an Amazon's Top 50 bestselling book.
-- AID is the author's ID, authorname is the name of the author.
CREATE TABLE Author(
    AID SERIAL PRIMARY Key,
    authorname TEXT NOT NULL
);

-- Indicates which author wrote which book
-- AID is the author's ID, BID is the book's ID
CREATE TABLE Written(
    AID INT,
    BID INT,
    PRIMARY KEY(AID, BID),
    FOREIGN KEY (BID) REFERENCES Book(BID),
    FOREIGN KEY (AID) REFERENCES Author(AID)
);

-- Feedback given by readers of an Amazon's Top 50 bestselling book.
-- Includes two kinds of feedback: userrating and reviews.
-- BID is the book's ID, year is the time when it became the bestseller in Amazon, 
-- userrating is a numeric rating between 0 and 5 at that time, 
-- review is the number of reviews written on amazon at that time.
CREATE TABLE Feedback(
    BID INT,
    year INT,
    userrating FLOAT NOT NULL,
    review INT NOT NULL,
    PRIMARY KEY(BID, year),
    FOREIGN KEY (BID) REFERENCES Book(BID)
);



