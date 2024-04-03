# aws-vpc-flow-logs

This is terraform code for [Querying Amazon VPC flow logs](https://docs.aws.amazon.com/athena/latest/ug/vpc-flow-logs.html)

The sql_create_table.sql and the terraform in main.tf use parition projection

This assumes you already have AWS Athena and glue catalog setup
