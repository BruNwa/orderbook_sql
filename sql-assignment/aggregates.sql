-- Zaim Anwar => c402 

/*
Aggregate Queries

REQUIREMENT - Use a multi-line comment to paste the first 5 or fewer results under your query
		     THEN records returned. 
*/

USE orderbook_activity_db;

-- #1: How many users do we have?

select count(*) Users from user;
/*  output
+-------+
| Users |
+-------+
|     7 |
+-------+
1 row in set (0.00 sec)
*/

-- #2: List the username, userid, and number of orders each user has placed.

select user.uname username, user.userid, count(*) order_num from `order`
join user
on user.userid=order.userid
group by user.userid;
/*  output
+----------+--------+-----------+
| username | userid | order_num |
+----------+--------+-----------+
| admin    |      1 |         3 |
| james    |      3 |         3 |
| kendra   |      4 |         5 |
| alice    |      5 |         8 |
| robert   |      6 |         5 |
+----------+--------+-----------+
5 rows in set (0.00 sec)
*/

-- #3: List the username, symbol, and number of orders placed for each user and for each symbol. 
-- Sort results in alphabetical order by symbol.

select user.uname username, order.symbol, count(*) order_num, (select count(*) from `order` o where o.symbol=order.symbol) symbol_num from `order`
join user
on user.userid=order.userid
group by user.uname, order.symbol
order by order.symbol ASC;

/*  output
+----------+--------+-----------+------------+
| username | symbol | order_num | symbol_num |
+----------+--------+-----------+------------+
| alice    | A      |         5 |          6 |
| james    | A      |         1 |          6 |
| robert   | AAA    |         1 |          1 |
| robert   | AAPL   |         1 |          3 |
| admin    | AAPL   |         1 |          3 |
+----------+--------+-----------+------------+
19 rows in set (0.00 sec)
*/

-- #4: Perform the same query as the one above, but only include admin users.

select user.uname username, order.symbol, count(*) order_num, (select count(*) from `order` o where o.symbol=order.symbol) symbol_num from `order`
join user
on user.userid=order.userid
join UserRoles
on UserRoles.userid=user.userid
join role
on role.roleid=UserRoles.roleid
where role.name='admin'
group by user.uname, order.symbol
order by order.symbol ASC;
/*  output
+----------+--------+-----------+------------+
| username | symbol | order_num | symbol_num |
+----------+--------+-----------+------------+
| alice    | A      |         5 |          6 |
| admin    | AAPL   |         1 |          3 |
| alice    | GOOG   |         1 |          1 |
| admin    | GS     |         1 |          2 |
| alice    | SPY    |         1 |          2 |
| alice    | TLT    |         1 |          2 |
| admin    | WLY    |         1 |          3 |
+----------+--------+-----------+------------+
7 rows in set (0.00 sec)
*/


-- #5: List the username and the average absolute net order amount for each user with an order.
-- Round the result to the nearest hundredth and use an alias (averageTradePrice).
-- Sort the results by averageTradePrice with the largest value at the top.

select user.uname username, round(avg(order.shares*order.price),2) averageTradePrice from `order` 
join user 
on user.userid=order.userid
group by user.uname
order by averageTradePrice desc;

/*  output
+----------+-------------------+
| username | averageTradePrice |
+----------+-------------------+
| admin    |          10774.87 |
| alice    |           6000.47 |
| james    |           1187.80 |
| robert   |            536.92 |
| kendra   |         -17109.53 |
+----------+-------------------+
5 rows in set (0.00 sec)
*/

-- #6: How many shares for each symbol does each user have?
-- Display the username and symbol with number of shares.


select user.uname username, order.symbol, count(*) shares from `order`
join user
on user.userid=order.userid
group by user.uname, order.symbol;

/*  output
+----------+--------+--------+
| username | symbol | shares |
+----------+--------+--------+
| admin    | WLY    |      1 |
| admin    | GS     |      1 |
| admin    | AAPL   |      1 |
| alice    | A      |      5 |
| alice    | SPY    |      1 |
+----------+--------+--------+
19 rows in set (0.00 sec)
*/

-- #7: What symbols have at least 3 orders?

select symbol, count(*) order_count from `order`
group by symbol
having count(*)>=3;
/*  output
+--------+-------------+
| symbol | order_count |
+--------+-------------+
| A      |           6 |
| AAPL   |           3 |
| WLY    |           3 |
+--------+-------------+
3 rows in set (0.00 sec)
*/

-- #8: List all the symbols and absolute net fills that have fills exceeding $100.
-- Do not include the WLY symbol in the results.
-- Sort the results by highest net with the largest value at the top.

select fill.symbol, abs(fill.share*fill.price)  absolute_net_fill from fill
where abs(fill.share*fill.price) > 100 and fill.symbol != 'WLY'
order by absolute_net_fill DESC;
/*  output
 +--------+-------------------+
| symbol | absolute_net_fill |
+--------+-------------------+
| SPY    |          27429.75 |
| SPY    |          27429.75 |
| GS     |           3056.30 |
| GS     |           3056.30 |
| AAPL   |           2111.40 |
+--------+-------------------+
12 rows in set (0.00 sec)
*/

-- #9: List the top five users with the greatest amount of outstanding orders.
-- Display the absolute amount filled, absolute amount ordered, and net outstanding.
-- Sort the results by the net outstanding amount with the largest value at the top.


select user.uname as username, abs(sum(order.shares)) as total_ordered, abs(sum(coalesce(fill.share, 0))) as total_filled, abs(sum(order.shares) - sum(coalesce(fill.share, 0))) as net_outstanding from `order`
join user
on order.userid = user.userid
left join fill
on order.orderid = fill.orderid
where order.status in ('partial_fill', 'pending')
group by user.uname
order by net_outstanding desc
limit 5;
/*  output
+----------+---------------+--------------+-----------------+
| username | total_ordered | total_filled | net_outstanding |
+----------+---------------+--------------+-----------------+
| kendra   |           200 |            0 |             200 |
| alice    |           108 |           75 |             183 |
| admin    |           100 |           10 |             110 |
| robert   |           100 |            0 |             100 |
| james    |           100 |            0 |             100 |
+----------+---------------+--------------+-----------------+
5 rows in set (0.00 sec)
*/