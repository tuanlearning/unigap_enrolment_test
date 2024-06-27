-- Count number of unique client order and number of orders by order month.
select count(distinct order_id)
from order;

select extract(month from date_order), count(distinct order_id) number_of_orders
from order
group by extract(month from date_order);

-- Get list of client who have more than 10 orders in this year.
select client_id
from order
where date_order between trunc(sysdate, 'YEAR') and ADD_MONTHS(TRUNC(SYSDATE, 'YEAR'),12)-1;

-- From the above list of client: get information of first and second last order of client

with tmp as (
    select order_id, date_order, good_type, good_amount, client_id,
    row_number() over(partition by order_id, date_order desc) rn
    from order
)
select order_date, good_type, good_amount
from tmp
where rn <= 2;

-- Calculate total good amount and Count number of Order which were delivered in Sep.2019
select sum(good_amount) total_good_amount, count(distinct order_id) number_of_orders
from order a
inner join order_delivery b
on a.order_id = b.order_id
where b.date_delivery between date'2019-09-01' and date'2019-09-30'

-- Assuming your 2 tables contain a huge amount of data and each join will take about 30 hours, while you need to do daily report, what is your solution?
-- Incremental Data Processing: Instead of joining the entire tables every day, you can process only the new or changed records. This can significantly reduce the amount of data you need to join daily.
-- Create materialized views that pre-compute and store the results of your joins. Materialized views can be refreshed periodically (e.g., nightly) so that the daily report generation is much faster.
-- Partitioning and Indexing