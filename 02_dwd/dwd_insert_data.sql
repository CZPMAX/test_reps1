---------------------------------------------------------------------------
-- 动态分区插入参数
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.max.dynamic.partitions.pernode=10000;
set hive.exec.max.dynamic.partitions=100000;
set hive.exec.max.created.files=150000;
--hive压缩
set hive.exec.compress.intermediate=true;
set hive.exec.compress.output=true;
--写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;

---------------------------------------------------------------------------
-- =========================== 首次全量导入数据 (拉链表) ================================

insert into zx_dwd.fact_customer_relationship partition (start_date)
select
       id,
       create_date_time,
       update_date_time,
       deleted,
       customer_id,
       first_id,
       belonger,
       belonger_name,
       initial_belonger,
       distribution_handler,
       business_scrm_department_id,
       last_visit_time,
       next_visit_time,
       origin_type,
       if(itcast_school_id is null or itcast_school_id = 0,-1,itcast_school_id) AS itcast_school_id,
       if(itcast_subject_id is null or itcast_subject_id = 0,-1,itcast_subject_id) AS itcast_subject_id,
       intention_study_type,
       anticipat_signup_date,
       `level`,
       creator,
       current_creator,
       creator_name,
       origin_channel,
       `comment`,
       first_customer_clue_id,
       last_customer_clue_id,
       process_state,
       process_time,
       payment_state,
       payment_time,
       signup_state,
       signup_time,
       notice_state,
       notice_time,
       lock_state,
       lock_time,
       itcast_clazz_id,
       itcast_clazz_time,
       payment_url,
       payment_url_time,
       ems_student_id,
       delete_reason,
       deleter,
       deleter_name,
       delete_time,
       course_id,
       course_name,
       delete_comment,
       close_state,
       close_time,
       appeal_id,
       tenant,
       total_fee,
       belonged,
       belonged_time,
       belonger_time,
       transfer,
       transfer_time,
       follow_type,
       transfer_bxg_oa_account,
       transfer_bxg_belonger_name,
       substr(create_date_time,1,4) as yearcode,
       substr(create_date_time,6,2) as monthcode,
       substr(create_date_time,9,2) as daycode,
       substr(create_date_time,12,2) as hourcode,
       if(origin_type in ('NETSERVICE','PRESIGNUP'),'1','0') as origin_type_state,
       '9999-99-99' as end_date, -- 拉链结束时间
       dt as start_date
from zx_ods.customer_relationship;

truncate table zx_dwd.fact_customer_relationship;
----------------------------------------------------------------------
insert into zx_dwd.dim_customer partition (start_date)
select id,
       customer_relationship_id,
       create_date_time,
       update_date_time,
       deleted,
       name,
       idcard,
       birth_year,
       gender,
       phone,
       wechat,
       qq,
       email,
       area,
       leave_school_date,
       graduation_date,
       bxg_student_id,
       creator,
       origin_type,
       origin_channel,
       tenant,
       md_id,
       '9999-99-99' as end_date,
       dt as start_date
from zx_ods.customer;
---------------------------------------------------------------------
insert into zx_dwd.dim_customer_clue partition (start_date)
SELECT id,
       create_date_time,
       update_date_time,
       deleted,
       customer_id,
       customer_relationship_id,
       session_id,
       sid,
       `status`,
       `user`,
       create_time,
       platform,
       s_name,
       seo_source,
       seo_keywords,
       ip,
       referrer,
       from_url,
       landing_page_url,
       url_title,
       to_peer,
       manual_time,
       begin_time,
       reply_msg_count,
       total_msg_count,
       msg_count,
       `comment`,
       finish_reason,
       finish_user,
       end_time,
       platform_description,
       browser_name,
       os_info,
       area,
       country,
       province,
       city,
       creator,
       name,
       idcard,
       phone,
       itcast_school_id,
       itcast_school,
       itcast_subject_id,
       itcast_subject,
       wechat,
       qq,
       email,
       gender,
       `level`,
       origin_type,
       information_way,
       working_years,
       technical_directions,
       customer_state,
       valid,
       anticipat_signup_date,
       clue_state,
       scrm_department_id,
       superior_url,
       superior_source,
       landing_url,
       landing_source,
       info_url,
       info_source,
       origin_channel,
       course_id,
       course_name,
       zhuge_session_id,
       is_repeat,
       tenant,
       activity_id,
       activity_name,
       follow_type,
       shunt_mode_id,
       shunt_employee_group_id,
       '9999-99-99' AS end_date,
       dt AS start_date
FROM zx_ods.customer_clue;
--------------------------------------------------------------
insert into zx_dwd.fact_customer_appeal
select *
from zx_ods.customer_appeal;
----------------------------------------
insert into zx_dwd.dim_employee
select
      *
from zx_ods.employee;
--------------------------------------------
insert into zx_dwd.dim_itcast_school
select * from zx_ods.itcast_school;
----------------------------------------
insert into zx_dwd.dim_itcast_subject
select * from zx_ods.itcast_subject;
--------------------------------------
insert into zx_dwd.dim_scrm_department
select * from zx_ods.scrm_department;


