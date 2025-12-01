CREATE OR REPLACE VIEW fmcg.gold.vw_fmcg_fact_orders_enriched 
AS
SELECT
  -- Fact orders
  FO.date,
  FO.product_code,
  FO.customer_code,
  -- dim date
  DD.year,
  DD.quarter,
  DD.month_name,
  DD.month_short_name,
  DD.year_quarter,
  -- dim customer
  DC.customer,
  DC.market,
  DC.platform,
  DC.channel,
  -- dim products
  DP.product,
  DP.category,
  DP.division,
  DP.variant,
  -- dim_gross_price
  DG.price_inr,
  FO.sold_quantity,
  -- Enriched column
  (DG.price_inr * FO.sold_quantity) AS revenur
FROM
  fmcg.gold.fact_orders AS FO
    LEFT JOIN fmcg.gold.dim_date AS DD
      ON FO.date = DD.month_start_date
    LEFT JOIN fmcg.gold.dim_customers AS DC
      ON FO.customer_code = DC.customer_code
    LEFT JOIN fmcg.gold.dim_products AS DP
      ON FO.product_code = DP.product_code
    LEFT JOIN fmcg.gold.dim_gross_price AS DG
      ON FO.product_code = DG.product_code
      AND YEAR(FO.date) = DG.year