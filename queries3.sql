-- Q3: For the authors who have multiple published books and are bestsellers, 
-- do they always focus on writing single genre types?

DROP VIEW IF EXISTS Authors CASCADE;
DROP VIEW IF EXISTS MultiAuthor CASCADE;

DROP VIEW IF EXISTS Answer CASCADE;

CREATE VIEW Authors AS
SELECT Book.BID, Author.AID, Book.bookname, Author.authorname, Book.genre
FROM Book, Author, Written
WHERE Book.BID = Written.BID and Author.AID = Written.AID;

-- Authors have multi bestseller books
CREATE VIEW MultiAuthor AS
SELECT DISTINCT a1.AID, a1.authorname, a1.BID, a1.genre
FROM Authors a1, Authors a2
WHERE a1.AID = a2.AID and a1.BID != a2.BID
order by a1.aid;



\echo Report the number of fiction books and nonfuction books wrote by Authors have multi bestseller books
\echo The entire result was stored in the view Answer
CREATE VIEW Answer AS
SELECT AID, authorname, count(*) filter (where genre = 'Fiction') as Ficnum, count(*) filter (where genre = 'Non Fiction') as NonFicnum
From MultiAuthor
GROUP BY AID, authorname
ORDER BY AID;

-- SELECT * FROM Answer;

-- Sample result only for demo
\echo Here we only demo Authors have worte both fiction books and nonFiction books
SELECT AID, authorname, Ficnum, NonFicnum
FROM Answer
WHERE Ficnum!=0 and NonFicnum!=0;




