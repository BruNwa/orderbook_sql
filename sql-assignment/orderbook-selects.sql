-- Zaim Anwar => c402 

/*
Basic Selects

REQUIREMENT - Use a multi-line comment to paste the first 5 or fewer results under your query
		     Also include the total records returned.
*/

USE orderbook_activity_db;

-- #1: List all users, including username and dateJoined.

 select uname, dateJoined from User;
/*  output
+--------+---------------------+
| uname  | dateJoined          |
+--------+---------------------+
| admin  | 2023-02-14 13:13:28 |
| wiley  | 2023-04-01 13:13:28 |
| james  | 2023-03-15 19:15:48 |
| kendra | 2023-03-15 19:16:06 |
| alice  | 2023-03-15 19:16:21 |
+--------+---------------------+
7 rows in set (0.00 sec)
*/




-- #2: List the username and datejoined from users with the newest users at the top.


 select uname, dateJoined from User order by dateJoined desc;
/*  output
+--------+---------------------+
| uname  | dateJoined          |
+--------+---------------------+
| wiley  | 2023-04-01 13:13:28 |
| sam    | 2023-03-15 19:16:59 |
| robert | 2023-03-15 19:16:43 |
| alice  | 2023-03-15 19:16:21 |
| kendra | 2023-03-15 19:16:06 |
| james  | 2023-03-15 19:15:48 |
| admin  | 2023-02-14 13:13:28 |
+--------+---------------------+
7 rows in set (0.00 sec)
*/


-- #3: List all usernames and dateJoined for users who joined in March 2023.

 select uname, dateJoined from User where dateJoined like '2023-03%';
/*  output
+--------+---------------------+
| uname  | dateJoined          |
+--------+---------------------+
| james  | 2023-03-15 19:15:48 |
| kendra | 2023-03-15 19:16:06 |
| alice  | 2023-03-15 19:16:21 |
| robert | 2023-03-15 19:16:43 |
| sam    | 2023-03-15 19:16:59 |
+--------+---------------------+
5 rows in set (0.00 sec)
*/
-- #4: List the different role names a user can have.

select name from Role;
/*  output
+-------+
| name  |
+-------+
| admin |
| it    |
| user  |
+-------+
3 rows in set (0.00 sec)
*/
-- #5: List all the orders.


select * from `Order`;
/*  output
+---------+--------+--------+------+---------------------+--------+--------+--------------+
| orderid | userid | symbol | side | orderTime           | shares | price  | status       |
+---------+--------+--------+------+---------------------+--------+--------+--------------+
|       1 |      1 | WLY    |    1 | 2023-03-15 19:20:35 |    100 |  38.73 | partial_fill |
|       2 |      6 | WLY    |    2 | 2023-03-15 19:20:50 |    -10 |  38.73 | filled       |
|       3 |      6 | NFLX   |    2 | 2023-03-15 19:21:12 |   -100 | 243.15 | pending      |
|       4 |      5 | A      |    1 | 2023-03-15 19:21:31 |     10 | 129.89 | filled       |
|       5 |      3 | A      |    2 | 2023-03-15 19:21:39 |    -10 | 129.89 | filled       |
+---------+--------+--------+------+---------------------+--------+--------+--------------+
24 rows in set (0.00 sec)
*/

-- #6: List all orders in March where the absolute net order amount is greater than 1000.

select symbol, orderTime, shares, price, shares*price net from `order` where shares*price > 1000;
/*  output
+--------+---------------------+--------+--------+----------+
| symbol | orderTime           | shares | price  | net      |
+--------+---------------------+--------+--------+----------+
| WLY    | 2023-03-15 19:20:35 |    100 |  38.73 |  3873.00 |
| A      | 2023-03-15 19:21:31 |     10 | 129.89 |  1298.90 |
| GS     | 2023-03-15 19:22:11 |    100 | 305.63 | 30563.00 |
| AAPL   | 2023-03-15 19:23:22 |     25 | 140.76 |  3519.00 |
| SPY    | 2023-03-15 19:24:21 |    100 | 365.73 | 36573.00 |
| MSFT   | 2023-03-15 19:34:55 |    100 | 236.27 | 23627.00 |
| GOOG   | 2023-03-15 19:36:35 |    100 | 100.82 | 10082.00 |
| WLY    | 2023-03-15 19:51:06 |    100 |  38.73 |  3873.00 |
+--------+---------------------+--------+--------+----------+
8 rows in set (0.00 sec)
*/

-- #7: List all the unique status types from orders.

select distinct status from `order`;
/*  output
+-----------------------+
| status                |
+-----------------------+
| partial_fill          |
| filled                |
| pending               |
| canceled_partial_fill |
| canceled              |
+-----------------------+
5 rows in set (0.01 sec)
*/
-- #8: List all pending and partial fill orders with oldest orders first.

select * from `order` where status in ('partial_fill', 'pending') order by orderTime;
/*  output
+---------+--------+--------+------+---------------------+--------+--------+--------------+
| orderid | userid | symbol | side | orderTime           | shares | price  | status       |
+---------+--------+--------+------+---------------------+--------+--------+--------------+
|       1 |      1 | WLY    |    1 | 2023-03-15 19:20:35 |    100 |  38.73 | partial_fill |
|       3 |      6 | NFLX   |    2 | 2023-03-15 19:21:12 |   -100 | 243.15 | pending      |
|      11 |      5 | SPY    |    1 | 2023-03-15 19:24:21 |    100 | 365.73 | partial_fill |
|      12 |      4 | QQQ    |    2 | 2023-03-15 19:24:32 |   -100 | 268.27 | pending      |
|      13 |      4 | QQQ    |    2 | 2023-03-15 19:24:32 |   -100 | 268.27 | pending      |
|      20 |      3 | WLY    |    1 | 2023-03-15 19:51:06 |    100 |  38.73 | pending      |
|      21 |      5 | A      |    2 | 2023-03-15 20:09:38 |     -1 | 129.89 | pending      |
|      22 |      5 | A      |    1 | 2023-03-15 20:09:46 |      2 | 129.89 | pending      |
|      23 |      5 | A      |    1 | 2023-03-15 20:09:51 |      5 | 129.89 | pending      |
|      24 |      5 | A      |    1 | 2023-03-15 20:09:56 |      2 | 129.89 | pending      |
+---------+--------+--------+------+---------------------+--------+--------+--------------+
10 rows in set (0.00 sec)
*/

-- #9: List the 10 most expensive financial products where the productType is stock.
-- Sort the results with the most expensive product at the top

select * from product where productType='stock' order by price desc limit 10;
/*  output
+-----------+-----------+-------------+-------------------------------+---------------------+
| symbol    | price     | productType | name                          | lastUpdate          |
+-----------+-----------+-------------+-------------------------------+---------------------+
| 207940.KS | 830000.00 | stock       | Samsung Biologics Co.,Ltd.    | 2022-10-17 15:24:51 |
| 003240.KS | 715000.00 | stock       | Taekwang Industrial Co., Ltd. | 2022-10-17 15:24:51 |
| 000670.KS | 630000.00 | stock       | Young Poong Corporation       | 2022-10-17 15:24:51 |
| 010130.KS | 616000.00 | stock       | Korea Zinc Company, Ltd.      | 2022-10-17 15:24:51 |
| 006400.KS | 605000.00 | stock       | Samsung SDI Co., Ltd.         | 2022-10-17 15:24:51 |
| 051900.KS | 575000.00 | stock       | LG H&H Co., Ltd.              | 2022-10-17 15:24:51 |
| 051910.KS | 575000.00 | stock       | LG Chem, Ltd.                 | 2022-10-17 15:24:51 |
| 007310.KS | 441500.00 | stock       | Ottogi Corporation            | 2022-10-17 15:24:51 |
| BRK-A     | 418391.00 | stock       | Berkshire Hathaway Inc.       | 2022-10-17 15:24:51 |
| 036490.KQ | 402900.00 | stock       | SK Materials Co., Ltd.        | 2022-10-17 15:24:51 |
+-----------+-----------+-------------+-------------------------------+---------------------+
10 rows in set (0.07 sec)
*/

-- #10: Display orderid, fillid, userid, symbol, and absolute net fill amount
-- from fills where the absolute net fill is greater than $1000.
-- Sort the results with the largest absolute net fill at the top.


select orderid, fillid, userid, symbol, share*price as net_fill from fill where share*price > 1000 order by share*price desc;
/*  output
+---------+--------+--------+--------+----------+
| orderid | fillid | userid | symbol | net_fill |
+---------+--------+--------+--------+----------+
|      14 |     12 |      4 | SPY    | 27429.75 |
|       7 |      6 |      4 | GS     |  3056.30 |
|      10 |     10 |      1 | AAPL   |  2111.40 |
|       9 |      8 |      4 | AAPL   |  1407.60 |
|       5 |      4 |      3 | A      |  1298.90 |
+---------+--------+--------+--------+----------+
5 rows in set (0.00 sec)
*/