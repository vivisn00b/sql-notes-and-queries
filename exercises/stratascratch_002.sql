-- Find all the users who were active for 3 consecutive days or more.
-- https://platform.stratascratch.com/coding/2054-consecutive-days?code_type=3

-- SELECT *,
--     ROW_NUMBER() OVER (
--         PARTITION BY user_id
--         ORDER BY record_date
--     ) as rn
-- FROM sf_events;

select distinct user_id
from
(select user_id, record_date, lag(record_date, 1) over(partition by user_id order by record_date) prev_date, lead(record_date, 1) over(partition by user_id order by record_date) next_date,
       datediff(record_date, lag(record_date, 1) over(partition by user_id order by record_date)) a,
       datediff(lead(record_date, 1) over(partition by user_id order by record_date), record_date) b
from sf_events) sq
where sq.a=1 and sq.b=1
