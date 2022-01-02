# SQL-CSC343-
## Data Analysis about Amazon top 50 bestselling books from 2009 to 2019
* <b>Domain</b>: The summary of Amazon top 50 bestselling books from 2009 to 2019.  
* <b>Link</b>: https://www.kaggle.com/sootersaalu/amazon-top-50-bestselling-books-2009-2019  
* <b>Questions</b>:
  * How are the booktype and popularity related. Are fiction books always more popular than non-fiction books? How are the readers' feedback and popularity related?
  * For the books that are bestsellers for multiple years, do they always have higher ratings than the books who only be the bestseller for one year? Are these books always having non-decreasing reviews or reader ratings?
  * For the authors who have multiple published books and are bestsellers, do they always focus on writing single genre types?
***
* Schema
  * Book (<b>BID</b>, bookname, price) Key: BID.  
  <i>An Amazon's Top 50 bestselling book</i>
  * BookType (BID, bookname, genre) Key: BID.  
    Foreign (BID) References Book(BID).  
  <i> The type of an Amazon's Top 50 bestselling book.</i> 
  * Author (AID, authorname) Key: AID.  
  <i> The author of an Amazon's Top 50 bestselling book. </i>
  * Written (AID, BID) Key: AID&BID.  
  FOREIGN KEY (BID) REFERENCES Book(BID), FOREIGN KEY (AID) REFERENCES Author(AID).  
  <i> Indicates which author wrote which book. </i>
  * Feedback (BID, year, userrating, review) Key:BID&year.  
  Foreign (BID) References Book(BID).  
  <i> The review and user rating for the book at the year. </i>
