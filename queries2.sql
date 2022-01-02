-- Q2: For the books that are bestsellers for multiple years, 
-- do they always have higher ratings than the books who only be the bestseller for one year? 
-- Are these books always having non-decreasing reviews or reader ratings?
DROP VIEW IF EXISTS q2 CASCADE;
DROP VIEW IF EXISTS Multiyear CASCADE;
DROP VIEW IF EXISTS Singleyear CASCADE;

DROP VIEW IF EXISTS MultiyearInfo CASCADE;
DROP VIEW IF EXISTS SingleyearInfo CASCADE;

DROP VIEW IF EXISTS NonDecreasingRating CASCADE;
DROP VIEW IF EXISTS NonDecreasingReview CASCADE;
DROP VIEW IF EXISTS HigherRatingNum CASCADE;
DROP VIEW IF EXISTS HigherRatingOverview CASCADE;
DROP VIEW IF EXISTS NonDecreasingRatingOverview CASCADE;
DROP VIEW IF EXISTS NonDecreasingReviewOverview CASCADE;

CREATE VIEW q2 AS
SELECT Book.BID, Book.bookname, Feedback.year, Feedback.userrating, Feedback.review
FROM Book, Feedback
WHERE Book.BID = Feedback.BID;

CREATE VIEW Multiyear AS
SELECT DISTINCT on (c1.BID) c1.BID, c1.bookname
FROM q2 c1, q2 c2
WHERE c1.BID = c2.BID and c1.year != c2.year;

CREATE VIEW Singleyear AS
(SELECT BID, bookname FROM q2) EXCEPT (SELECT * FROM Multiyear);

-- Books are bestsellers for multiple years
CREATE VIEW MultiyearInfo AS
SELECT q2.BID, q2.bookname, q2.userrating, q2.review, q2.year
FROM q2, Multiyear
WHERE q2.BID = Multiyear.BID
ORDER BY q2.userrating DESC, q2.review DESC;

-- Books are bestsellers for only one year
CREATE VIEW SingleyearInfo AS
SELECT q2.BID, q2.bookname, q2.userrating, q2.review, q2.year
FROM q2, Singleyear
WHERE q2.BID = Singleyear.BID
ORDER BY q2.userrating DESC, q2.review DESC;



-- Do they always have higher ratings than [the books who only be the bestseller for one year]? 
CREATE VIEW HigherRatingNum as 
SELECT m.BID, count(*) as num
FROM (SELECT DISTINCT ON (BID) * FROM MultiyearInfo)m, SingleyearInfo
WHERE m.userrating > SingleyearInfo.userrating
GROUP BY m.BID;

\echo The number and frequency of single-year-bestseller books has lower rating than each multiple-years-bestseller book:
\echo Here only demo the top 5 that beats the most single-year-bestseller books
\echo The entire result was stored in the view HigherRatingOverview
CREATE VIEW HigherRatingOverview AS
SELECT HigherRatingNum.BID, num, round(cast(num as numeric)/total, 2) as freq
FROM (SELECT count(*) as total FROM SingleyearInfo)s, HigherRatingNum
ORDER BY num DESC;

-- SELECT * FROM HigherRatingOverview;

-- Sample result only for demo
SELECT * FROM HigherRatingOverview LIMIT 10;

-- Are these books always having non-decreasing reviews or reader ratings?
-- Rating
CREATE VIEW NonDecreasingRating AS
SELECT DISTINCT c1.BID
FROM MultiyearInfo c1, MultiyearInfo c2
WHERE c1.BID = c2.BID and c1.year < c2.year and (c1.userrating < c2.userrating or c1.userrating = c2.userrating);

\echo The multiple-years-bestseller book that has non-decreasing reader ratings:
\echo Here only demo the multiple-years-bestseller books always having higher than 4.8 rating 
\echo The entire result was stored in the view NonDecreasingRatingOverview
CREATE VIEW NonDecreasingRatingOverview AS
SELECT MultiyearInfo.BID, MultiyearInfo.year, MultiyearInfo.userrating
From MultiyearInfo, NonDecreasingRating
WHERE NonDecreasingRating.BID = MultiyearInfo.BID
ORDER BY NonDecreasingRating.BID, MultiyearInfo.year;

-- SELECT * FROM NonDecreasingRatingOverview;

-- Sample result only for demo
SELECT * FROM NonDecreasingRatingOverview WHERE userrating > 4.8;

-- Review
CREATE VIEW NonDecreasingReview AS
SELECT DISTINCT c1.BID
FROM MultiyearInfo c1, MultiyearInfo c2
WHERE c1.BID = c2.BID and c1.year < c2.year and (c1.review < c2.review OR c1.review = c2.review);

\echo The multiple-years-bestseller book that has non-decreasing reviews:
\echo Here only demo the multiple-years-bestseller books having at least 40000 reviews
\echo The entire result was stored in the view NonDecreasingReviewOverview
CREATE VIEW NonDecreasingReviewOverview AS
SELECT MultiyearInfo.BID, MultiyearInfo.year, MultiyearInfo.review
From MultiyearInfo, NonDecreasingReview
WHERE NonDecreasingReview.BID = MultiyearInfo.BID
ORDER BY NonDecreasingReview.BID, MultiyearInfo.year;

-- SELECT * FROM NonDecreasingReviewOverview;

-- Sample result only for demo
SELECT * FROM NonDecreasingReviewOverview WHERE review >= 40000;