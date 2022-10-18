--- ======================== 向日统计宽表中添加数据 =========================
-- 从宽表中精确抽取字段
insert into zx_dws.dws_intention_daycount
with temp as (

  select
        -- 维度抽取
        dt as create_time, -- 具体日期
        yearcode  , -- 年
        monthcode  , -- 月
        daycode    , -- 天
        hourcode    , -- 小时
        origin_type_state, -- 线上线下
        clue_state_stat , -- 新老用户
        area, -- 地区
        itcast_school_id,
        school_name,-- 校区
        itcast_subject_id,
        subject_name,-- 学科
        department_id,
        department_name,--部门
        origin_channel, -- 来源渠道
         deleted      ,

        -- 意向用户指标
        customer_id
  from zx_dwb.dwb_intention_detail
)
select


       case when grouping(yearcode)=0
            then yearcode
       else null end as yearcode  , -- 年

       case when grouping(monthcode)=0
            then monthcode
       else null end as monthcode  , -- 月

       case when grouping(create_time)=0
            then create_time
       else null end as create_time,

       case when grouping(origin_type_state)=0
            then origin_type_state
       else null end as origin_type_state, -- 线上线下

       case when grouping(clue_state_stat)=0
            then clue_state_stat
       else null end as clue_state_stat, -- 新老学员

       case when grouping(area)=0
            then area
       else null end as area, -- 地区

       case when grouping(itcast_school_id)=0
            then itcast_school_id
       else null end as itcast_school_id,

       case when grouping(itcast_school_id)=0
            then school_name
       else null end as school_name,

       case when grouping(itcast_subject_id)=0
            then itcast_subject_id
       else null end as itcast_subject_id,

        case when grouping(itcast_subject_id)=0
            then  subject_name
       else null end as  subject_name,

        case when grouping( department_id)=0
            then  department_id
       else null end as  department_id,

       case when grouping( department_id)=0
            then  department_name
       else null end as  department_name,


        case when grouping(origin_channel)=0
            then origin_channel
       else null end as origin_channel, -- 来源渠道

       -- 分组标记
       case when grouping(yearcode,monthcode,create_time,origin_type_state,clue_state_stat,area,origin_channel,department_id,itcast_school_id,itcast_subject_id)=159
            then 'month_origin_user'
            when grouping(yearcode,monthcode,create_time,origin_type_state,clue_state_stat,area,origin_channel,department_id,itcast_school_id,itcast_subject_id)=799
            then 'day_origin_user'
            when grouping(yearcode,monthcode,create_time,origin_type_state,clue_state_stat,area,origin_channel,department_id,itcast_school_id,itcast_subject_id)=415
            then 'year_origin_user'

            when grouping(yearcode,monthcode,create_time,origin_type_state,clue_state_stat,area,origin_channel,department_id,itcast_school_id,itcast_subject_id)=783
            then 'day_origin_user_area'
            when grouping(yearcode,monthcode,create_time,origin_type_state,clue_state_stat,area,origin_channel,department_id,itcast_school_id,itcast_subject_id)=143
            then 'month_origin_user_area'
            when grouping(yearcode,monthcode,create_time,origin_type_state,clue_state_stat,area,origin_channel,department_id,itcast_school_id,itcast_subject_id)=399
            then 'year_origin_user_area'

            when grouping(yearcode,monthcode,create_time,origin_type_state,clue_state_stat,area,origin_channel,department_id,itcast_school_id,itcast_subject_id)=791
            then 'day_origin_user_channel'
            when grouping(yearcode,monthcode,create_time,origin_type_state,clue_state_stat,area,origin_channel,department_id,itcast_school_id,itcast_subject_id)=151
            then 'month_origin_user_area_channel'
            when grouping(yearcode,monthcode,create_time,origin_type_state,clue_state_stat,area,origin_channel,department_id,itcast_school_id,itcast_subject_id)=407
            then 'year_origin_user_area_channel'

            when grouping(yearcode,monthcode,create_time,origin_type_state,clue_state_stat,area,origin_channel,department_id,itcast_school_id,itcast_subject_id)=795
            then 'day_origin_user_dep'
            when grouping(yearcode,monthcode,create_time,origin_type_state,clue_state_stat,area,origin_channel,department_id,itcast_school_id,itcast_subject_id)=155
            then 'month_origin_user_dep'
            when grouping(yearcode,monthcode,create_time,origin_type_state,clue_state_stat,area,origin_channel,department_id,itcast_school_id,itcast_subject_id)=411
            then 'year_origin_user_dep'

            when grouping(yearcode,monthcode,create_time,origin_type_state,clue_state_stat,area,origin_channel,department_id,itcast_school_id,itcast_subject_id)=797
            then 'day_origin_user_school'
            when grouping(yearcode,monthcode,create_time,origin_type_state,clue_state_stat,area,origin_channel,department_id,itcast_school_id,itcast_subject_id)=157
            then 'month_origin_user_school'
            when grouping(yearcode,monthcode,create_time,origin_type_state,clue_state_stat,area,origin_channel,department_id,itcast_school_id,itcast_subject_id)=413
            then 'year_origin_user_school'

            when grouping(yearcode,monthcode,create_time,origin_type_state,clue_state_stat,area,origin_channel,department_id,itcast_school_id,itcast_subject_id)=798
            then 'day_origin_user_subject'
            when grouping(yearcode,monthcode,create_time,origin_type_state,clue_state_stat,area,origin_channel,department_id,itcast_school_id,itcast_subject_id)=158
            then 'month_origin_user_subject'
            when grouping(yearcode,monthcode,create_time,origin_type_state,clue_state_stat,area,origin_channel,department_id,itcast_school_id,itcast_subject_id)=414
            then 'year_origin_user_subject'
            else 'other'
            end as group_type,

------------------------------------------------------------------------------------------------

       -- 指标计算
--        case when grouping(yearcode,monthcode,create_time,origin_type_state,clue_state_stat,area,origin_channel,department_id,itcast_school_id,itcast_subject_id)=783
--             then count( if(customer_id is not null , customer_id,null)) end total_intention_cnt

case when grouping(yearcode,monthcode,create_time,origin_type_state,clue_state_stat,area,origin_channel,department_id,itcast_school_id,itcast_subject_id)=159
            then count(customer_id)
            when grouping(yearcode,monthcode,create_time,origin_type_state,clue_state_stat,area,origin_channel,department_id,itcast_school_id,itcast_subject_id)=799
            then count(customer_id)
            when grouping(yearcode,monthcode,create_time,origin_type_state,clue_state_stat,area,origin_channel,department_id,itcast_school_id,itcast_subject_id)=415
            then count(customer_id)

            when grouping(yearcode,monthcode,create_time,origin_type_state,clue_state_stat,area,origin_channel,department_id,itcast_school_id,itcast_subject_id)=783
            then count(customer_id)
            when grouping(yearcode,monthcode,create_time,origin_type_state,clue_state_stat,area,origin_channel,department_id,itcast_school_id,itcast_subject_id)=143
            then count(customer_id)
            when grouping(yearcode,monthcode,create_time,origin_type_state,clue_state_stat,area,origin_channel,department_id,itcast_school_id,itcast_subject_id)=399
            then count(customer_id)

            when grouping(yearcode,monthcode,create_time,origin_type_state,clue_state_stat,area,origin_channel,department_id,itcast_school_id,itcast_subject_id)=791
            then count(customer_id)
            when grouping(yearcode,monthcode,create_time,origin_type_state,clue_state_stat,area,origin_channel,department_id,itcast_school_id,itcast_subject_id)=151
            then count(customer_id)
            when grouping(yearcode,monthcode,create_time,origin_type_state,clue_state_stat,area,origin_channel,department_id,itcast_school_id,itcast_subject_id)=407
            then count(customer_id)

            when grouping(yearcode,monthcode,create_time,origin_type_state,clue_state_stat,area,origin_channel,department_id,itcast_school_id,itcast_subject_id)=795
            then count(customer_id)
            when grouping(yearcode,monthcode,create_time,origin_type_state,clue_state_stat,area,origin_channel,department_id,itcast_school_id,itcast_subject_id)=155
            then count(customer_id)
            when grouping(yearcode,monthcode,create_time,origin_type_state,clue_state_stat,area,origin_channel,department_id,itcast_school_id,itcast_subject_id)=411
            then count(customer_id)

            when grouping(yearcode,monthcode,create_time,origin_type_state,clue_state_stat,area,origin_channel,department_id,itcast_school_id,itcast_subject_id)=797
            then count(customer_id)
            when grouping(yearcode,monthcode,create_time,origin_type_state,clue_state_stat,area,origin_channel,department_id,itcast_school_id,itcast_subject_id)=157
            then count(customer_id)
            when grouping(yearcode,monthcode,create_time,origin_type_state,clue_state_stat,area,origin_channel,department_id,itcast_school_id,itcast_subject_id)=413
            then count(customer_id)

            when grouping(yearcode,monthcode,create_time,origin_type_state,clue_state_stat,area,origin_channel,department_id,itcast_school_id,itcast_subject_id)=798
            then count(customer_id)
            when grouping(yearcode,monthcode,create_time,origin_type_state,clue_state_stat,area,origin_channel,department_id,itcast_school_id,itcast_subject_id)=158
            then count(customer_id)
            when grouping(yearcode,monthcode,create_time,origin_type_state,clue_state_stat,area,origin_channel,department_id,itcast_school_id,itcast_subject_id)=414
            then count(customer_id)
            else null
            end as total_intention_cnt

from temp
where  deleted='false'
group by
grouping sets (

      -- 日期==》天
     (create_time,origin_type_state,clue_state_stat), -- 日期+线上线下+新老学员
     (create_time,origin_type_state,clue_state_stat,area), -- 日期+线上线下+新老学员+地区
     (create_time,origin_type_state,clue_state_stat,itcast_school_id,school_name), --日期+线上线下+新老学员+校区
     (create_time,origin_type_state,clue_state_stat,itcast_subject_id,subject_name), -- 日期+线上线下+新老学员+学科  日期==》天
     (create_time,origin_type_state,clue_state_stat,department_id,department_name), -- 日期+线上线下+新老学员+部门
     (create_time,origin_type_state,clue_state_stat,origin_channel), -- 日期+线上线下+新老学员+来源渠道

     -- 月
     (yearcode,monthcode,origin_type_state,clue_state_stat), -- 日期+线上线下+新老学员
     (yearcode,monthcode,origin_type_state,clue_state_stat,area), -- 日期+线上线下+新老学员+地区
     (yearcode,monthcode,origin_type_state,clue_state_stat,itcast_school_id,school_name), --日期+线上线下+新老学员+校区
     (yearcode,monthcode,origin_type_state,clue_state_stat,itcast_subject_id,subject_name), -- 日期+线上线下+新老学员+学科  日期==》天
     (yearcode,monthcode,origin_type_state,clue_state_stat,department_id,department_name), -- 日期+线上线下+新老学员+部门
     (yearcode,monthcode,origin_type_state,clue_state_stat,origin_channel), -- 日期+线上线下+新老学员+来源渠道

     -- 年
     (yearcode,origin_type_state,clue_state_stat), -- 日期+线上线下+新老学员
     (yearcode,origin_type_state,clue_state_stat,area), -- 日期+线上线下+新老学员+地区
     (yearcode,origin_type_state,clue_state_stat,itcast_school_id,school_name), --日期+线上线下+新老学员+校区
     (yearcode,origin_type_state,clue_state_stat,itcast_subject_id,subject_name), -- 日期+线上线下+新老学员+学科  日期==》天
     (yearcode,origin_type_state,clue_state_stat,department_id,department_name), -- 日期+线上线下+新老学员+部门
     (yearcode,origin_type_state,clue_state_stat,origin_channel) -- 日期+线上线下+新老学员+来源渠道

);
