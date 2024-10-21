-- Zaim Anwar => c402 

/*
Join Queries

REQUIREMENT - Use a multi-line comment to paste the first 5 or fewer results under your query
		     Also include the total records returned.
*/

USE orderbook_activity_db;

-- #1: Display the dateJoined and username for admin users.
select user.uname as Username, user.dateJoined from user join userroles on userroles.userid=user.userid join role on role.roleid=userroles.roleid where role.name='admin';
/*  output
+----------+---------------------+
| Username | dateJoined          |
+----------+---------------------+
| admin    | 2023-02-14 13:13:28 |
| wiley    | 2023-04-01 13:13:28 |
| alice    | 2023-03-15 19:16:21 |
+----------+---------------------+
3 rows in set (0.00 sec)
*/


-- #2: Display each absolute order net (share*price), status, symbol, trade date, and username.
-- Sort the results with largest the absolute order net (share*price) at the top.
-- Include only orders that were not canceled or partially canceled.

select shares*price net, status, symbol, orderTime trade_date, user.uname username from `order` 
join user on user.userid=order.userid 
where order.status not in ('canceled','canceled_partial_fill') 
order by shares*price DESC;
/*  output
+----------+--------------+--------+---------------------+----------+
| net      | status       | symbol | trade_date          | username |
+----------+--------------+--------+---------------------+----------+
| 36573.00 | partial_fill | SPY    | 2023-03-15 19:24:21 | alice    |
|  3873.00 | partial_fill | WLY    | 2023-03-15 19:20:35 | admin    |
|  3873.00 | pending      | WLY    | 2023-03-15 19:51:06 | james    |
|  3519.00 | filled       | AAPL   | 2023-03-15 19:23:22 | robert   |
|  1298.90 | filled       | A      | 2023-03-15 19:21:31 | alice    |
+----------+--------------+--------+---------------------+----------+
20 rows in set (0.00 sec)
*/




-- #3: Display the orderid, symbol, status, order shares, filled shares, and price for orders with fills.
-- Note that filledShares are the opposite sign (+-) because they subtract from ordershares!

select  order.orderid, order.symbol, order.status, order.shares order_share, fill.share filled_share, fill.price from `order`
join fill
on fill.orderid=order.orderid;

/*  output
+---------+--------+-----------------------+-------------+--------------+--------+
| orderid | symbol | status                | order_share | filled_share | price  |
+---------+--------+-----------------------+-------------+--------------+--------+
|       1 | WLY    | partial_fill          |         100 |          -10 |  38.73 |
|       2 | WLY    | filled                |         -10 |           10 |  38.73 |
|       4 | A      | filled                |          10 |          -10 | 129.89 |
|       5 | A      | filled                |         -10 |           10 | 129.89 |
|       6 | GS     | canceled_partial_fill |         100 |          -10 | 305.63 |
+---------+--------+-----------------------+-------------+--------------+--------+
14 rows in set (0.00 sec)
*/



-- #4: Display all partial_fill orders and how many outstanding shares are left.
-- Also include the username, symbol, and orderid.
select order.status, user.uname as username, order.symbol, order.orderid, (order.shares - fill.share) as outstanding_shares from `order`
join user on user.userid = order.userid
join fill on order.orderid = fill.orderid
where order.status = 'partial_fill';

/*  output
+--------------+----------+--------+---------+--------------------+
| status       | username | symbol | orderid | outstanding_shares |
+--------------+----------+--------+---------+--------------------+
| partial_fill | admin    | WLY    |       1 |                110 |
| partial_fill | alice    | SPY    |      11 |                175 |
+--------------+----------+--------+---------+--------------------+
2 rows in set (0.01 sec)
*/

-- #5: Display the orderid, symbol, status, order shares, filled shares, and price for orders with fills.
-- Also include the username, role, absolute net amount of shares filled, and absolute net order.
-- Sort by the absolute net order with the largest value at the top.

select order.orderid, order.symbol, order.status, order.shares order_shares, fill.share fill_shares, fill.price, user.uname username, role.name role, 
fill.share*fill.price net_fill, order.shares*order.price net_order from `order`
join fill
on fill.orderid=order.orderid
join user
on user.userid=fill.userid
join UserRoles
on UserRoles.userid=user.userid
join role
on role.roleid=UserRoles.roleid
order by order.shares*order.price DESC;

/*  output
+---------+--------+-----------------------+--------------+-------------+--------+----------+-------+-----------+-----------+
| orderid | symbol | status                | order_shares | fill_shares | price  | username | role  | net_fill  | net_order |
+---------+--------+-----------------------+--------------+-------------+--------+----------+-------+-----------+-----------+
|      11 | SPY    | partial_fill          |          100 |         -75 | 365.73 | alice    | admin | -27429.75 |  36573.00 |
|       6 | GS     | canceled_partial_fill |          100 |         -10 | 305.63 | admin    | admin |  -3056.30 |  30563.00 |
|       1 | WLY    | partial_fill          |          100 |         -10 |  38.73 | admin    | admin |   -387.30 |   3873.00 |
|       8 | AAPL   | filled                |           25 |         -10 | 140.76 | robert   | user  |  -1407.60 |   3519.00 |
|       8 | AAPL   | filled                |           25 |         -15 | 140.76 | robert   | user  |  -2111.40 |   3519.00 |
+---------+--------+-----------------------+--------------+-------------+--------+----------+-------+-----------+-----------+
14 rows in set (0.00 sec)
*/


-- #6: Display the username and user role for users who have not placed an order.

select user.uname username, role.name role from `order`
right join user
on order.userid=user.userid 
join UserRoles
on UserRoles.userid=user.userid
join role
on role.roleid=UserRoles.roleid
where order.orderid is null;
/*  output
+----------+-------+
| username | role  |
+----------+-------+
| sam      | user  |
| wiley    | admin |
+----------+-------+
2 rows in set (0.00 sec)
*/

-- #7: Display orderid, username, role, symbol, price, and number of shares for orders with no fills.


select order.orderid, user.uname username, role.name role, order.symbol, order.price, order.shares from `order`
left join fill
on fill.orderid=order.orderid
join user
on user.userid=order.userid
join UserRoles
on UserRoles.userid=user.userid
join role
on role.roleid=UserRoles.roleid
where fill.fillid is null;
/*  output
+---------+----------+------+--------+--------+--------+
| orderid | username | role | symbol | price  | shares |
+---------+----------+------+--------+--------+--------+
|       3 | robert   | user | NFLX   | 243.15 |   -100 |
|      12 | kendra   | user | QQQ    | 268.27 |   -100 |
|      13 | kendra   | user | QQQ    | 268.27 |   -100 |
|      17 | robert   | user | AAA    |  24.09 |     10 |
|      18 | robert   | user | MSFT   | 236.27 |    100 |
+---------+----------+------+--------+--------+--------+
11 rows in set (0.00 sec)
*/


-- #8: Display the symbol, username, role, and number of filled shares where the order symbol is WLY.
-- Include all orders, even if the order has no fills.

select order.symbol, user.uname username, role.name role, fill.share filled_shares from fill
right join `order`
on order.orderid=fill.orderid
join user
on user.userid=order.userid
join UserRoles
on UserRoles.userid=user.userid
join role
on role.roleid=UserRoles.roleid
where order.symbol='WLY';
/*  output
+--------+----------+-------+---------------+
| symbol | username | role  | filled_shares |
+--------+----------+-------+---------------+
| WLY    | admin    | admin |           -10 |
| WLY    | robert   | user  |            10 |
| WLY    | james    | user  |          NULL |
+--------+----------+-------+---------------+
3 rows in set (0.00 sec)
*/




