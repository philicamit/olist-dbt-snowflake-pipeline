{% snapshot snap_customers %}

{{
    config(
      target_database='OLIST_DB',
      target_schema='DEV',
      unique_key='customer_id',

      strategy='timestamp',
      updated_at='purchased_at',
    )
}}

select 
    c.customer_id,
    c.customer_unique_id,
    c.customer_zip_code_prefix,
    c.customer_city,
    c.customer_state,
    o.order_purchase_timestamp as purchased_at
from {{ source('raw_olist', 'RAW_CUSTOMERS') }} c
left join {{ source('raw_olist', 'RAW_ORDERS') }} o 
    on c.customer_id = o.customer_id

{% endsnapshot %}