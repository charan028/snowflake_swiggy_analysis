
use sysadmin role.
use role sysadmin;

-- create a warehouse if not exist 
-- create warehouse if not exists adhoc_wh
--      comment = 'This is the adhoc-wh'
--      warehouse_size = 'x-small' 
--      auto_resume = true 
--      auto_suspend = 60 
--      enable_query_acceleration = false 
--      warehouse_type = 'standard' 
--      min_cluster_count = 1 
--      max_cluster_count = 1 
--      scaling_policy = 'standard'
--      initially_suspended = true;

-- create development database/schema  if does not exist
create database if not exists sandbox;
use database sandbox;
create schema if not exists stage_sch;
create schema if not exists clean_sch;
create schema if not exists consumption_sch;
create schema if not exists common;

use schema stage_sch;

 -- create file format to process the CSV file
  create file format if not exists stage_sch.csv_file_format 
        type = 'csv' 
        compression = 'auto' 
        field_delimiter = ',' 
        record_delimiter = '\n' 
        skip_header = 1 
        field_optionally_enclosed_by = '\042' 
        null_if = ('\\N');

create stage stage_sch.csv_stg
    directory = ( enable = true )
    comment = 'this is the snowflake internal stage';


create or replace tag 
    common.pii_policy_tag 
    allowed_values 'PII','PRICE','SENSITIVE','EMAIL'
    comment = 'This is PII policy tag object';

create or replace masking policy 
    common.pii_masking_policy as (pii_text string)
    returns string -> 
    to_varchar('** PII **');

create or replace masking policy 
    common.email_masking_policy as (email_text string)
    returns string -> 
    to_varchar('** EAMIL **');

create or replace masking policy 
    common.phone_masking_policy as (phone string)
    returns string -> 
    to_varchar('** Phone **');

list @stage_sch.csv_stg;
list @stage_sch.csv_stg/initial;

-- select 
--         t.$1::text as locationid,
--         t.$2::text as city,
--         t.$3::text as state,
--         t.$4::text as zipcode,
--         t.$5::text as activeflag,
--         t.$6::text as createddate,
--         t.$7::text as modifieddate,
--         metadata$filename as _stg_file_name,
--         metadata$file_last_modified as _stg_file_load_ts,
--         metadata$file_content_key as _stg_file_md5,
--         current_timestamp as _copy_data_ts
--     from @stage_sch.csv_stg/initial/location t



