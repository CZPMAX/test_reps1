-- ======================= 向宽表中导入数据 =============================
-- 提供支持的表
-- fact_customer_relationship 用户关系表 主表
-- dim_customer 学生基本信息表 提供地区维度
-- dim_customer_clue 线索表 提供新老学员维度
-- dim_employee 员工表
-- dim_scrm_department 员工部门表  提供咨询中心维度
-- dim_itcast_school 校区信息表  提供校区维度
-- dim_itcast_subject 学科信息表 提供学科信息维度
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

set hive.auto.convert.join=true;
insert into zx_dwb.dwb_intention_detail
select
      fcr.id,
      fcr.create_date_time,
      fcr.update_date_time,
      fcr.deleted,
      fcr.customer_id,
      fcr.first_id,
      fcr.origin_type,
      fcr.itcast_school_id,
      fcr.itcast_subject_id,
      fcr.intention_study_type,
      fcr.creator,
      fcr.creator_name,
      fcr.origin_channel,
      fcr.first_customer_clue_id,
      fcr.last_customer_clue_id,
      fcr.payment_state,
      fcr.payment_time,
      fcr.total_fee,
      fcr.yearcode,
      fcr.monthcode,
      fcr.daycode,
      fcr.hourcode,
      fcr.origin_type_state,
      case dcu.clue_state
        when 'VALID_NEW_CLUES' then '1'
        else '0'
       end as clue_state_stat, -- 1 新用户 0 老用户 其他未知

      disc.name as school_name,
      dis.name as subject_name,
      de.tdepart_id,
      dsd.name as department_name,
      dcu.customer_relationship_id,
      dc.name as stu_name,
      dc.area,

      substr(fcr.create_date_time,1,10) as dt
from zx_dwd.fact_customer_relationship fcr
left join zx_dwd.dim_customer_clue dcu on fcr.id = dcu.customer_relationship_id
and dcu.end_date='9999-99-99'
left join zx_dwd.dim_customer dc on fcr.customer_id = dc.id
and dc.end_date='9999-99-99'
left join zx_dwd.dim_employee de on fcr.creator = de.id
left join zx_dwd.dim_scrm_department dsd on de.tdepart_id = dsd.id
left join zx_dwd.dim_itcast_subject dis on fcr.itcast_subject_id = dis.id
left join zx_dwd.dim_itcast_school disc on fcr.itcast_school_id = disc.id
;

create database zx_rpt;



