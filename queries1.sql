-- Q1: How are the booktype and popularity related. 
-- Are fiction books always more popular than non-fiction books? 
-- How are the readers' feedback and popularity related?
DROP VIEW IF EXISTS Ratings CASCADE;
DROP VIEW IF EXISTS AllInfo CASCADE;
DROP VIEW IF EXISTS YearlyMaxRate CASCADE;
DROP VIEW IF EXISTS YearlyDoubleMax CASCADE;
DROP VIEW IF EXISTS YearlyTop CASCADE;

-- Report top 20 books have highest userratings in ten years
CREATE VIEW Ratings AS
SELECT DISTINCT Book.BID, Book.bookname, Book.genre, Feedback.userrating, Feedback.review
FROM Book, Feedback
WHERE Book.BID = Feedback.BID
ORDER BY Feedback.userrating DESC, Feedback.review DESC
LIMIT 20;

\echo All the books in the top 20 books:
SELECT * FROM Ratings ORDER BY BID;

-- Report the number of fiction and non fiction books among these 20 books
\echo The number of Fiction and non-fiction books (f and nf) among these 20 books:
SELECT count(*) filter (where genre = 'Fiction') as F, 
count(*) filter (where genre = 'Non Fiction') as NF
FROM Ratings;

-- Report Top 1 for each year, if there is a tie, report them all
CREATE VIEW AllInfo as 
SELECT Book.BID, Book.bookname, Book.genre, Feedback.userrating, Feedback.review, year
FROM Book, Feedback
WHERE Book.BID = Feedback.BID;

CREATE VIEW YearlyMaxRate as 
SELECT max(userrating) as max_rating, year
FROM AllInfo
GROUP BY year;

CREATE VIEW YearlyDoubleMax as 
SELECT AllInfo.year, max(review) as max_review
FROM AllInfo, YearlyMaxRate
WHERE AllInfo.year = YearlyMaxRate.year and YearlyMaxRate.max_rating = AllInfo.userrating
GROUP BY AllInfo.year;

\echo Top 1 for each year from 2009 to 2019, if there is a tie, report them all:
CREATE VIEW YearlyTop AS
SELECT BID, YearlyMaxRate.year, AllInfo.userrating, AllInfo.review, genre
FROM YearlyMaxRate, YearlyDoubleMax, AllInfo
WHERE YearlyMaxRate.year = YearlyDoubleMax.year and YearlyDoubleMax.year = AllInfo.year 
and YearlyDoubleMax.max_review = AllInfo.review and YearlyMaxRate.max_rating = AllInfo.userrating;

SELECT * FROM YearlyTop ORDER BY year;

-- Report the number of fiction and non fiction books among these yearly top 1 books
\echo The number of Fiction and non-fiction books (f and nf) among these yearly top 1 books:
SELECT count(*) filter (where genre = 'Fiction') as F, 
count(*) filter (where genre = 'Non Fiction') as NF
FROM YearlyTop;