-- =============== 每天/每月/每日各个学科线上线下以及新老学员意向用户个数 ==
create table zx_rpt.rpt_year_intention_topN(

      -- 维度
       yearcode               string      comment  '年',
       monthcode              string      comment  '月',
       create_time  string comment '意向创建时间', -- 日期
       itcast_subject_id bigint comment '学科id',
       subject_name string comment '学科名称',
       origin_type_state      string      COMMENT '数据来源:0.线下；1.线上',
      clue_state_state          STRING COMMENT '新老客户：0.老客户；1.新客户 ',
      group_type        string  comment '分组标记',

      -- 计算指标
      year_sub_online_new  bigint COMMENT '年各学科线上新用户',
      year_sub_online_old  bigint COMMENT '年各学科线上旧用户',
      year_sub_offline_new bigint COMMENT '年各学科线下新用户',
      year_sub_offline_old bigint COMMENT '年各学科线下旧用户',

      month_sub_online_new  bigint COMMENT '月各学科线上新用户',
      month_sub_online_old  bigint COMMENT '月各学科线上旧用户',
      month_sub_offline_new bigint COMMENT '月各学科线下新用户',
      month_sub_offline_old bigint COMMENT '月各学科线下旧用户',

      day_sub_online_new  bigint COMMENT '月各学科线上新用户',
      day_sub_online_old  bigint COMMENT '月各学科线上旧用户',
      day_sub_offline_new bigint COMMENT '月各学科线下新用户',
      day_sub_offline_old bigint COMMENT '月各学科线下旧用户'

)row format delimited fields terminated by '\t'
stored as orc tblproperties ('orc.compress'='snappy');

insert into hive.zx_rpt.rpt_year_intention_topn
select
       yearcode,
       monthcode,
       create_time,
       itcast_subject_id,
       subject_name,
       origin_type_state ,
       clue_state_state,
       group_type,
       case when group_type='year_origin_user_subject' and clue_state_state = '1' and  origin_type_state = '1'
            then total_intention_cnt end as year_sub_online_new, -- '年各学科线上新用户'
       case when group_type='year_origin_user_subject' and origin_type_state = '1' and   clue_state_state = '0'
            then total_intention_cnt end as year_sub_online_old, -- '年各学科线上老用户'
       case when group_type='year_origin_user_subject' and origin_type_state = '0' and   clue_state_state = '1'
            then total_intention_cnt end as year_sub_offline_new, -- '年各学科线下新用户'
       case when group_type='year_origin_user_subject' and origin_type_state = '0' and   clue_state_state = '0'
            then total_intention_cnt end as year_sub_offline_old, -- '年各学科线下老用户'

       case when group_type='month_origin_user_subject' and clue_state_state = '1' and  origin_type_state = '1'
            then total_intention_cnt end as month_sub_online_new, -- '月各学科线上新用户'
       case when group_type='month_origin_user_subject' and origin_type_state = '1' and   clue_state_state = '0'
            then total_intention_cnt end as month_sub_online_old, -- '月各学科线上新老户'
       case when group_type='month_origin_user_subject' and origin_type_state = '0' and   clue_state_state = '1'
            then total_intention_cnt end as month_sub_offline_new, -- '月各学科线下新用户'
       case when group_type='month_origin_user_subject' and origin_type_state = '0' and   clue_state_state = '0'
            then total_intention_cnt end as month_sub_offline_old, -- '月各学科线下老用户'

       case when group_type='day_origin_user_subject' and origin_type_state = '1' and   clue_state_state = '1'
            then total_intention_cnt end as day_sub_online_new, -- '天各学科线上新用户'
       case when group_type='day_origin_user_subject' and origin_type_state = '1' and  clue_state_state = '0'
            then total_intention_cnt end as day_sub_online_old, -- '天各学科线上老用户'
       case when group_type='day_origin_user_subject' and   origin_type_state = '0' and   clue_state_state = '1'
            then total_intention_cnt end as day_sub_offline_new, -- '天各学科线下新用户'
       case when group_type='day_origin_user_subject' and origin_type_state = '0' and   clue_state_state = '0'
            then total_intention_cnt end as day_sub_offline_old -- '天各学科线下老用户'


from zx_dws.dws_intention_daycount
where group_type in ('day_origin_user_subject','month_origin_user_subject','year_origin_user_subject')
;
-------------------------------------------------------------------------------------------------------
-- =========================================================================================
-- create table zx_rpt.rpt_year_intention_topN(
--
--       -- 维度
--        yearcode               string      comment  '年',
--       -- monthcode              string      comment  '月',
--       -- create_time  string comment '意向创建时间', -- 日期
--        itcast_subject_id bigint comment '学科id',
--        subject_name string comment '学科名称',
--        origin_type_state      string      COMMENT '数据来源:0.线下；1.线上',
--        clue_state_state          STRING COMMENT '新老客户：0.老客户；1.新客户 ',
--        group_type        string  comment '分组标记',
--
--       -- 计算指标
--        total_cnt bigint
--
-- )row format delimited fields terminated by '\t'
-- stored as orc tblproperties ('orc.compress'='snappy');
-- ===================================================================================================
------
create table zx_rpt.rpt_intention_detail(

      -- 维度
       timecode               string      comment  '时间标记 有年 月 日',
      -- monthcode              string      comment  '月',
      -- create_time  string comment '意向创建时间', -- 日期
       type_id bigint comment '标记id 学科id 或者 校区id',
       type_name  string comment '标记名称  学科名称 或者 校区名称',
--        origin_type_state      string      COMMENT '数据来源:0.线下；1.线上',
--        clue_state_state          STRING COMMENT '新老客户：0.老客户；1.新客户 ',
       int_people_cnt bigint comment '意向人数',
        t_type         string  comment '分组标记'

      -- 计算指标


)row format delimited fields terminated by '\t'
stored as orc tblproperties ('orc.compress'='snappy');

truncate table zx_rpt.rpt_intention_detail;

-- 学科指标插入
insert into hive.zx_rpt.rpt_intention_detail select create_time,itcast_subject_id,subject_name, day_sub_online_new , 'day_sub_online_new' as t_type from zx_rpt.rpt_year_intention_topN where group_type='day_origin_user_subject' and origin_type_state='1' and clue_state_state='1' ;
insert into hive.zx_rpt.rpt_intention_detail select create_time, itcast_subject_id, subject_name, day_sub_online_old , 'day_sub_online_old' as t_type from zx_rpt.rpt_year_intention_topN where group_type='day_origin_user_subject' and origin_type_state='1' and clue_state_state='0' ;
insert into hive.zx_rpt.rpt_intention_detail select create_time, itcast_subject_id, subject_name,day_sub_offline_old , 'day_sub_offline_old' as t_type from zx_rpt.rpt_year_intention_topN where group_type='day_origin_user_subject' and origin_type_state='0' and clue_state_state='0' ;
insert into hive.zx_rpt.rpt_intention_detail select create_time, itcast_subject_id, subject_name,day_sub_offline_new , 'day_sub_offline_new' as t_type from zx_rpt.rpt_year_intention_topN where group_type='day_origin_user_subject'   and origin_type_state='0' and clue_state_state='1' ;


insert into hive.zx_rpt.rpt_intention_detail select concat(yearcode,'-',monthcode), itcast_subject_id,subject_name,month_sub_online_new,  'month_sub_online_new' as t_type from zx_rpt.rpt_year_intention_topN where group_type='month_origin_user_subject' and origin_type_state='1' and clue_state_state='1'  ;
insert into hive.zx_rpt.rpt_intention_detail select concat(yearcode,'-',monthcode), itcast_subject_id,subject_name,month_sub_online_old,  'month_sub_online_old' as t_type from zx_rpt.rpt_year_intention_topN where group_type='month_origin_user_subject' and origin_type_state='1' and clue_state_state='0'  ;
insert into hive.zx_rpt.rpt_intention_detail select concat(yearcode,'-',monthcode), itcast_subject_id,subject_name,month_sub_offline_new, 'month_sub_offline_new' as t_type from zx_rpt.rpt_year_intention_topN where group_type='month_origin_user_subject' and origin_type_state='0' and clue_state_state='1' ;
insert into hive.zx_rpt.rpt_intention_detail select concat(yearcode,'-',monthcode), itcast_subject_id,subject_name,month_sub_offline_old, 'month_sub_offline_old' as t_type from zx_rpt.rpt_year_intention_topN where group_type='month_origin_user_subject' and origin_type_state='0' and clue_state_state='0'  ;

insert into hive.zx_rpt.rpt_intention_detail select yearcode,  itcast_subject_id,subject_name,year_sub_online_new ,'year_sub_online_new' as t_type from zx_rpt.rpt_year_intention_topN where group_type='year_origin_user_subject' and origin_type_state='1' and clue_state_state='1' ;
insert into hive.zx_rpt.rpt_intention_detail select yearcode, itcast_subject_id,subject_name, year_sub_online_old ,'year_sub_online_old' as t_type from zx_rpt.rpt_year_intention_topN where group_type='year_origin_user_subject' and origin_type_state='1' and clue_state_state='0' ;
insert into hive.zx_rpt.rpt_intention_detail select yearcode,  itcast_subject_id,subject_name, year_sub_offline_new ,'year_sub_offline_new' as t_type from zx_rpt.rpt_year_intention_topN where group_type='year_origin_user_subject' and origin_type_state='0' and clue_state_state='1' ;
insert into hive.zx_rpt.rpt_intention_detail select yearcode, itcast_subject_id,subject_name, year_sub_offline_old ,'year_sub_offline_old' as t_type from zx_rpt.rpt_year_intention_topN where group_type='year_origin_user_subject' and origin_type_state='0' and clue_state_state='0' ;

-- 校区指标插入
insert into hive.zx_rpt.rpt_intention_detail select create_time, itcast_school_id,school_name, day_sch_online_new ,  'day_sch_online_new' as t_type from   zx_rpt.rpt_school_intention where group_type='day_origin_user_school' and origin_type_state='1' and clue_state_state='1' ;
insert into hive.zx_rpt.rpt_intention_detail select create_time, itcast_school_id,school_name, day_sch_online_old ,  'day_sch_online_old' as t_type from   zx_rpt.rpt_school_intention where group_type='day_origin_user_school' and origin_type_state='1' and clue_state_state='0' ;
insert into hive.zx_rpt.rpt_intention_detail select create_time, itcast_school_id,school_name, day_sch_offline_old , 'day_sch_offline_old' as t_type from zx_rpt.rpt_school_intention where  group_type='day_origin_user_school' and origin_type_state='0' and clue_state_state='0' ;
insert into hive.zx_rpt.rpt_intention_detail select create_time, itcast_school_id,school_name, day_sch_offline_new , 'day_sch_offline_new' as t_type from zx_rpt.rpt_school_intention where  group_type='day_origin_user_school'   and origin_type_state='0' and clue_state_state='1' ;


insert into hive.zx_rpt.rpt_intention_detail select concat(yearcode,'-',monthcode), itcast_school_id,school_name ,month_sch_online_new,  'month_sch_online_new' as t_type from  zx_rpt.rpt_school_intention where group_type='month_origin_user_school' and origin_type_state='1' and clue_state_state='1'  ;
insert into hive.zx_rpt.rpt_intention_detail select concat(yearcode,'-',monthcode), itcast_school_id,school_name ,month_sch_online_old,  'month_sch_online_old' as t_type from  zx_rpt.rpt_school_intention where group_type='month_origin_user_school' and origin_type_state='1' and clue_state_state='0'  ;
insert into hive.zx_rpt.rpt_intention_detail select concat(yearcode,'-',monthcode), itcast_school_id,school_name ,month_sch_offline_new, 'month_sch_offline_new' as t_type from zx_rpt.rpt_school_intention where group_type='month_origin_user_school' and origin_type_state='0' and clue_state_state='1' ;
insert into hive.zx_rpt.rpt_intention_detail select concat(yearcode,'-',monthcode), itcast_school_id,school_name ,month_sch_offline_old, 'month_sch_offline_old' as t_type from zx_rpt.rpt_school_intention where group_type='month_origin_user_school' and origin_type_state='0' and clue_state_state='0'  ;

insert into hive.zx_rpt.rpt_intention_detail select yearcode,itcast_school_id,school_name , year_sch_online_new ,' year_sch_online_new' as t_type from zx_rpt.rpt_school_intention where group_type='year_origin_user_school' and origin_type_state='1' and clue_state_state='1' ;
insert into hive.zx_rpt.rpt_intention_detail select yearcode,itcast_school_id,school_name , year_sch_online_old , 'year_sch_online_old' as t_type from zx_rpt.rpt_school_intention where group_type='year_origin_user_school' and origin_type_state='1' and clue_state_state='0' ;
insert into hive.zx_rpt.rpt_intention_detail select yearcode,itcast_school_id,school_name , year_sch_offline_new ,'year_sch_offline_new' as t_type from zx_rpt.rpt_school_intention where group_type='year_origin_user_school' and origin_type_state='0' and clue_state_state='1' ;
insert into hive.zx_rpt.rpt_intention_detail select yearcode,itcast_school_id,school_name , year_sch_offline_old ,'year_sch_offline_old' as t_type from zx_rpt.rpt_school_intention where group_type='year_origin_user_school' and origin_type_state='0' and clue_state_state='0' ;


----------------------------------------------------------------------------------------------------
--- 插入线索报表数据
insert into hive.zx_rpt.rpt_clue_detail
with ac as (
select
       create_date_time,
       cast(0 as varchar)as hourcode,
--        hourcode,
--        origin_type,
--        clue_state,
--        group_type,
        'day_offline_old' as t_type,
        case when group_type='day_origin_user' and origin_type = '0' and clue_state = '0'
        then day_intention_cnt end as peopleo_cnt,
         cast(0 as decimal(5,2) )as use_rate
--        hour_av_clue_rate
from zx_dws.dws_clue_count )
,bc as
(select
       create_date_time,
       cast(0 as varchar)as hourcode,
--        hourcode,
--        origin_type,
--        clue_state,
--        group_type,
        'day_online_new' as t_type,
       case when group_type='day_origin_user' and origin_type = '1' and clue_state = '1'
       then day_intention_cnt end as peopleo_cnt,
       cast(0 as decimal(5,2) )as use_rate
--        hour_av_clue_rate
from zx_dws.dws_clue_count
)
,bcc as
(select
       create_date_time,
       cast(0 as varchar)as hourcode,
--        hourcode,
--        origin_type,
--        clue_state,
--        group_type,
        'day_offline_new' as t_type,
       case when group_type='day_origin_user' and origin_type = '0' and clue_state = '1'
       then day_intention_cnt end as peopleo_cnt,
       cast(0 as decimal(5,2) )as use_rate
--        hour_av_clue_rate
from zx_dws.dws_clue_count )
,dc as
(select
       create_date_time,
        cast(0 as varchar)as hourcode,
--        hourcode,
--        origin_type,
--        clue_state,
--        group_type,
       'day_online_old' as t_type,
       case when group_type='day_origin_user' and origin_type = '1' and clue_state = '0'
       then day_intention_cnt end as peopleo_cnt,
         cast(0 as decimal(5,2) )as use_rate
--        hour_av_clue_rate
from zx_dws.dws_clue_count )
,ec as
(select
       '0' as create_date_time,
       hourcode,
--        hourcode,
--        origin_type,
--        clue_state,
--        group_type,
       'hour_offline_old' as t_type,
       cast(0 as bigint) as peopleo_cnt,
       case when group_type='hour_origin_user' and origin_type = '0' and clue_state = '0'
       then hour_av_clue_rate end as use_rate
--        hour_av_clue_rate
from zx_dws.dws_clue_count )
,fc as (
select
       '0' as create_date_time,
       hourcode,
--        hourcode,
--        origin_type,
--        clue_state,
--        group_type,
       'hour_online_new' as t_type,
       cast(0 as bigint) as peopleo_cnt,
       case when group_type='hour_origin_user' and origin_type = '1' and clue_state = '1'
       then hour_av_clue_rate end as use_rate
--        hour_av_clue_rate
from zx_dws.dws_clue_count

)
,gc as (
select
       '0' as create_date_time,
       hourcode,
--        hourcode,
--        origin_type,
--        clue_state,
--        group_type,
       'hour_offline_new' as t_type,
       cast(0 as bigint) as peopleo_cnt,
       case when group_type='hour_origin_user' and origin_type = '0' and clue_state = '1'
       then hour_av_clue_rate end as use_rate
--        hour_av_clue_rate
from zx_dws.dws_clue_count


)
,ccc as(
  select * from ac
  union all
  select * from bc
  union all
  select * from bcc
  union all
  select * from dc
  union all
  select * from ec
  union all
  select * from fc
  union all
  select * from gc

)select * from ccc;

-------------------------------------------------------------------------------------------------------



-- 建表
create table zx_rpt.rpt_clue_detail(

     daycode string comment '天',
     hourcode string comment '小时',
     t_type string comment '指标类型',
     av_cnt bigint comment '有效线索条数',
     use_rate decimal(5,2) comment '有效线索转化率'

)row format delimited fields terminated by '\t'
stored as orc tblproperties ('orc.compress'='ZLIB');

select * from zx_rpt.rpt_clue_detail where t_type='day_offline_old' order by av_cnt desc limit 10;


-------------------------------------------------------
create table zx_rpt.rpt_school_intention(

      -- 维度
       yearcode               string      comment  '年',
       monthcode              string      comment  '月',
       create_time  string comment '意向创建时间', -- 日期
       itcast_school_id bigint comment '校区id',
       schoool_name string comment '校区名称',
       origin_type_state      string      COMMENT '数据来源:0.线下；1.线上',
       clue_state_state          STRING COMMENT '新老客户：0.老客户；1.新客户 ',
       group_type        string  comment '分组标记',

      -- 计算指标
      year_sch_online_new  bigint COMMENT  '年各校区线上新用户',
      year_sch_online_old  bigint COMMENT  '年各校区线上旧用户',
      year_sch_offline_new bigint COMMENT  '年各校区线下新用户',
      year_sch_offline_old bigint COMMENT  '年各校区线下旧用户',

      month_sch_online_new  bigint COMMENT '月各校区线上新用户',
      month_sch_online_old  bigint COMMENT '月各校区线上旧用户',
      month_sch_offline_new bigint COMMENT '月各校区线下新用户',
      month_sch_offline_old bigint COMMENT '月各校区线下旧用户',

      day_sch_online_new  bigint COMMENT '月各校区线上新用户',
      day_sch_online_old  bigint COMMENT '月各校区线上旧用户',
      day_sch_offline_new bigint COMMENT '月各校区线下新用户',
      day_sch_offline_old bigint COMMENT '月各校区线下旧用户'

)row format delimited fields terminated by '\t'
stored as orc tblproperties ('orc.compress'='snappy');

insert into hive.zx_rpt.rpt_school_intention
select
       yearcode,
       monthcode,
       create_time,
       itcast_school_id,
       school_name,
       origin_type_state ,
       clue_state_state,
       group_type,
       case when group_type='year_origin_user_school' and clue_state_state = '1' and  origin_type_state = '1'
            then total_intention_cnt end as year_sch_online_new, -- '年各校区线上新用户'
       case when group_type='year_origin_user_school' and origin_type_state = '1' and   clue_state_state = '0'
            then total_intention_cnt end as year_sch_online_old, -- '年各校区线上老用户'
       case when group_type='year_origin_user_school' and origin_type_state = '0' and   clue_state_state = '1'
            then total_intention_cnt end as year_sch_offline_new, -- '年各校区线下新用户'
       case when group_type='year_origin_user_school' and origin_type_state = '0' and   clue_state_state = '0'
            then total_intention_cnt end as year_sch_offline_old, -- '年各校区线下老用户'

       case when group_type='month_origin_user_school' and clue_state_state = '1' and  origin_type_state = '1'
            then total_intention_cnt end as month_sch_online_new, -- '月各校区线上新用户'
       case when group_type='month_origin_user_school' and origin_type_state = '1' and   clue_state_state = '0'
            then total_intention_cnt end as month_sch_online_old, -- '月各校区线上新老户'
       case when group_type='month_origin_user_school' and origin_type_state = '0' and   clue_state_state = '1'
            then total_intention_cnt end as month_sch_offline_new, -- '月各校区线下新用户'
       case when group_type='month_origin_user_school' and origin_type_state = '0' and   clue_state_state = '0'
            then total_intention_cnt end as month_sch_offline_old, -- '月各校区线下老用户'

       case when group_type='day_origin_user_school' and origin_type_state = '1' and   clue_state_state = '1'
            then total_intention_cnt end as day_sch_online_new, -- '天各校区线上新用户'
       case when group_type='day_origin_user_school' and origin_type_state = '1' and  clue_state_state = '0'
            then total_intention_cnt end as day_sch_online_old, -- '天各校区线上老用户'
       case when group_type='day_origin_user_school' and   origin_type_state = '0' and   clue_state_state = '1'
            then total_intention_cnt end as day_sch_offline_new, -- '天各校区线下新用户'
       case when group_type='day_origin_user_school' and origin_type_state = '0' and   clue_state_state = '0'
            then total_intention_cnt end as day_sch_offline_old -- '天各校区线下老用户'


from zx_dws.dws_intention_daycount
where group_type in ('day_origin_user_school','month_origin_user_school','year_origin_user_school')


