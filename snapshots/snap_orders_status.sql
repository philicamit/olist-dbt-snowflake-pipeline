{% snapshot snap_orders_status %}

{{
    config(
      target_database='OLIST_DB',
      target_schema='DEV',
      unique_key='order_id',

      strategy='check',
      check_cols=['order_status', 'order_delivered_customer_date'],
    )
}}

select 
    order_id,
    customer_id,
    order_status,
    order_delivered_customer_date
from {{ source('raw_olist', 'RAW_ORDERS') }}

{% endsnapshot %}