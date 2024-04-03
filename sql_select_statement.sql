# sample select statement to run in athena
SELECT account_id,
	SUM(packets) AS packetcount,
	dstaddr
FROM vpc_flow_logs
WHERE dstport = 443
    --date is a string since that is part of partitioning so it has to be converted when doing filters
	AND cast(date_parse('date', '%Y/%m/%d') as date) > current_date - interval '7' day
GROUP BY account_id, dstaddr
ORDER BY packetcount DESC
