# this is the sql if you just create the table directly in athena.
# one or the other.  terraform will check the table as defined in main.tf or this is the ddl of that table

CREATE EXTERNAL TABLE `vpc_flow_logs`(
	`version` int COMMENT '',
	`interface_id` string COMMENT '',
	`srcaddr` string COMMENT '',
	`dstaddr` string COMMENT '',
	`srcport` int COMMENT '',
	`dstport` int COMMENT '',
	`protocol` bigint COMMENT '',
	`packets` bigint COMMENT '',
	`bytes` bigint COMMENT '',
	`start` bigint COMMENT '',
	`end` bigint COMMENT '',
	`action` string COMMENT '',
	`log_status` string COMMENT '',
	`vpc_id` string COMMENT '',
	`subnet_id` string COMMENT '',
	`instance_id` string COMMENT '',
	`tcp_flags` int COMMENT '',
	`type` string COMMENT '',
	`pkt_srcaddr` string COMMENT '',
	`pkt_dstaddr` string COMMENT '',
	`az_id` string COMMENT '',
	`sublocation_type` string COMMENT '',
	`sublocation_id` string COMMENT '',
	`pkt_src_aws_service` string COMMENT '',
	`pkt_dst_aws_service` string COMMENT '',
	`flow_direction` string COMMENT '',
	`traffic_path` int COMMENT ''
)
PARTITIONED BY (
	`account_id` string COMMENT '',
	`region` string COMMENT '',
	`date` string COMMENT ''
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe'
STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'
LOCATION 's3://bucket/path/AWSLogs/${account_id}/vpcflowlogs'
TBLPROPERTIES (
	'parquet.compression' = 'SNAPPY',
	'projection.account_id.type' = 'enum',
	'projection.account_id.values' = '',
	'projection.date.format' = 'yyyy/MM/dd',
	'projection.date.range' = '2021/01/01,NOW',
	'projection.date.type' = 'date',
	'projection.enabled' = 'true',
	'projection.region.type' = 'enum',
	'projection.region.values' = 'us-east-1',
	'skip.header.line.count' = '1',
	'storage.location.template' = 's3://bucket/path/AWSLogs/${account_id}/vpcflowlogs/${region}/${date}',
)
