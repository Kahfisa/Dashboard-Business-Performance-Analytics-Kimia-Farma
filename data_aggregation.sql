with tmp as (
  select 
  kft.transaction_id,
  kft.date,
  kft.branch_id,
  kkc.branch_name,
  kkc.city,
  kkc.province,
  kkc.rating_branch as branch_rating,
  kft.rating as transaction_rating,
  kft.customer_name,
  kft.product_id,
  kp.product_name,
  kp.price as actual_price,
  kft.discount_percentage,
  case when kp.price <= 50000 then 0.10
       when kp.price > 50000 and kp.price <= 100000 then 0.15
       when kp.price > 100000 and kp.price <= 300000 then 0.20
       when kp.price > 300000 and kp.price <= 500000 then 0.25
       else 0.30
       end as presentase_gross_laba,
  kp.price - (kp.price * kft.discount_percentage) as net_sales
from kf_final_transaction as kft
left join kf_branch_office as kkc on kft.branch_id = kkc.branch_id
left join kf_products as kp on kft.product_id = kp.product_id
)

select
  *,
  net_sales * presentase_gross_laba as net_profit
from tmp