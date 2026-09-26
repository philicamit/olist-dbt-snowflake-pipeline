with orders as (
    select * from {{ ref('stg_orders') }}
),

payments as (
    select
        order_id,
        sum(payment_value) as total_payment_amount
    from {{ ref('stg_payments') }}
    group by order_id
),

final as (
    select
        orders.order_id,
        orders.customer_id,
        orders.order_status,
        orders.purchased_at,
        orders.approved_at,
        orders.carrier_delivered_at,
        orders.customer_delivered_at,
        orders.estimated_delivery_at,
        coalesce(payments.total_payment_amount, 0) as order_amount
    from orders
    left join payments using (order_id)
)

select * from final