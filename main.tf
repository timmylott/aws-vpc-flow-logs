terraform {
  required_version = ">= 0.13.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.19.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_glue_catalog_database" "vpc_flow_log_glue_catalog_database" {
  name = "vpc_flow_logs"
}

resource "aws_glue_catalog_table" "vpc_flow_log_table" {
  name          = "vpc_flow_logs"
  database_name = aws_glue_catalog_database.vpc_flow_log_glue_catalog_database.name

  table_type = "EXTERNAL_TABLE"

  parameters = {
    "EXTERNAL"                     = "TRUE"
    "parquet.compression"          = "SNAPPY"
    "projection.date.format"       = "yyyy/MM/dd"
    "projection.date.range"        = "2021/01/01,NOW" # change date to oldest logs
    "projection.date.type"         = "date"
    "projection.enabled"           = "true"
    "projection.region.type"       = "enum"
    "projection.region.values"     = "us-east-1" # if multiple regions, list those here
    "projection.account_id.type"   = "enum"
    "projection.account_id.values" = "" # add list of aws account ids here
    "skip.header.line.count"       = "1"
    "storage.location.template"    = "s3://bucket/path/AWSLogs/${"$"}{account_id}/vpcflowlogs/${"$"}{region}/${"$"}{date}" # update path here
  }
  retention = 0

  partition_keys {
    name = "account_id"
    type = "string"
  }
  partition_keys {
    name = "region"
    type = "string"
  }
  partition_keys {
    name = "date"
    type = "string"
  }

  storage_descriptor {
    bucket_columns            = []
    compressed                = false
    input_format              = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    location                  = "s3://bucket/path/AWSLogs/${"$"}{account_id}/vpcflowlogs" # update path here
    number_of_buckets         = -1
    output_format             = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"
    parameters                = {}
    stored_as_sub_directories = false

    columns {
      name       = "version"
      parameters = {}
      type       = "int"
    }
    columns {
      name       = "interface_id"
      parameters = {}
      type       = "string"
    }
    columns {
      name       = "srcaddr"
      parameters = {}
      type       = "string"
    }
    columns {
      name       = "dstaddr"
      parameters = {}
      type       = "string"
    }
    columns {
      name       = "srcport"
      parameters = {}
      type       = "int"
    }
    columns {
      name       = "dstport"
      parameters = {}
      type       = "int"
    }
    columns {
      name       = "protocol"
      parameters = {}
      type       = "bigint"
    }
    columns {
      name       = "packets"
      parameters = {}
      type       = "bigint"
    }
    columns {
      name       = "bytes"
      parameters = {}
      type       = "bigint"
    }
    columns {
      name       = "start"
      parameters = {}
      type       = "bigint"
    }
    columns {
      name       = "end"
      parameters = {}
      type       = "bigint"
    }
    columns {
      name       = "action"
      parameters = {}
      type       = "string"
    }
    columns {
      name       = "log_status"
      parameters = {}
      type       = "string"
    }
    columns {
      name       = "vpc_id"
      parameters = {}
      type       = "string"
    }
    columns {
      name       = "subnet_id"
      parameters = {}
      type       = "string"
    }
    columns {
      name       = "instance_id"
      parameters = {}
      type       = "string"
    }
    columns {
      name       = "tcp_flags"
      parameters = {}
      type       = "int"
    }
    columns {
      name       = "type"
      parameters = {}
      type       = "string"
    }
    columns {
      name       = "pkt_srcaddr"
      parameters = {}
      type       = "string"
    }
    columns {
      name       = "pkt_dstaddr"
      parameters = {}
      type       = "string"
    }
    columns {
      name       = "az_id"
      parameters = {}
      type       = "string"
    }
    columns {
      name       = "sublocation_type"
      parameters = {}
      type       = "string"
    }
    columns {
      name       = "sublocation_id"
      parameters = {}
      type       = "string"
    }
    columns {
      name       = "pkt_src_aws_service"
      parameters = {}
      type       = "string"
    }
    columns {
      name       = "pkt_dst_aws_service"
      parameters = {}
      type       = "string"
    }
    columns {
      name       = "flow_direction"
      parameters = {}
      type       = "string"
    }
    columns {
      name       = "traffic_path"
      parameters = {}
      type       = "int"
    }

    ser_de_info {
      parameters = {
        "serialization.format" = "1"
      }
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
    }

    skewed_info {
      skewed_column_names               = []
      skewed_column_value_location_maps = {}
      skewed_column_values              = []
    }
  }



}

