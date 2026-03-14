-- 1. 平台效果分析
SELECT
    platform,
    SUM(impressions) AS impressions,
    SUM(clicks) AS clicks,
    SUM(conversions) AS conversions,
    ROUND(SUM(cost), 2) AS cost,
    ROUND(SUM(revenue), 2) AS revenue,
    ROUND(SUM(clicks) * 1.0 / NULLIF(SUM(impressions), 0), 4) AS ctr,
    ROUND(SUM(conversions) * 1.0 / NULLIF(SUM(clicks), 0), 4) AS cvr,
    ROUND(SUM(cost) * 1.0 / NULLIF(SUM(clicks), 0), 4) AS cpc,
    ROUND(SUM(cost) * 1.0 / NULLIF(SUM(conversions), 0), 4) AS cpa,
    ROUND(SUM(revenue) * 1.0 / NULLIF(SUM(cost), 0), 4) AS roi
FROM ad_data
GROUP BY platform
ORDER BY roi DESC;

-- 2. 素材效果分析
SELECT
    creative_type,
    SUM(impressions) AS impressions,
    SUM(clicks) AS clicks,
    SUM(conversions) AS conversions,
    ROUND(SUM(cost), 2) AS cost,
    ROUND(SUM(clicks) * 1.0 / NULLIF(SUM(impressions), 0), 4) AS ctr,
    ROUND(SUM(conversions) * 1.0 / NULLIF(SUM(clicks), 0), 4) AS cvr,
    ROUND(SUM(cost) * 1.0 / NULLIF(SUM(conversions), 0), 4) AS cpa
FROM ad_data
GROUP BY creative_type
ORDER BY cvr DESC;

-- 3. 人群效果分析
SELECT
    target_audience,
    SUM(impressions) AS impressions,
    SUM(clicks) AS clicks,
    SUM(conversions) AS conversions,
    ROUND(SUM(cost), 2) AS cost,
    ROUND(SUM(clicks) * 1.0 / NULLIF(SUM(impressions), 0), 4) AS ctr,
    ROUND(SUM(conversions) * 1.0 / NULLIF(SUM(clicks), 0), 4) AS cvr,
    ROUND(SUM(cost) * 1.0 / NULLIF(SUM(conversions), 0), 4) AS cpa
FROM ad_data
GROUP BY target_audience
ORDER BY cvr DESC;

-- 4. 高消耗低转化广告计划识别
WITH campaign_summary AS (
    SELECT
        campaign_name,
        ROUND(SUM(cost), 2) AS total_cost,
        SUM(conversions) AS total_conversions,
        ROUND(SUM(revenue), 2) AS total_revenue,
        ROUND(SUM(clicks) * 1.0 / NULLIF(SUM(impressions), 0), 4) AS ctr,
        ROUND(SUM(conversions) * 1.0 / NULLIF(SUM(clicks), 0), 4) AS cvr,
        ROUND(SUM(cost) * 1.0 / NULLIF(SUM(conversions), 0), 4) AS cpa,
        ROUND(SUM(revenue) * 1.0 / NULLIF(SUM(cost), 0), 4) AS roi
    FROM ad_data
    GROUP BY campaign_name
)
SELECT *
FROM campaign_summary
ORDER BY total_cost DESC, roi ASC
LIMIT 10;