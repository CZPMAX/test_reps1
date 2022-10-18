-- ========================= 创建意向明细宽表 ================================
CREATE DATABASE zx_dwb;
CREATE TABLE IF NOT EXISTS zx_dwb.dwb_intention_detail(

      -- 意向关系表
       id                     INT         COMMENT '意向id，唯一标记一条意向信息',
       create_date_time       string      COMMENT '意向创建时间',
       update_date_time       string      COMMENT '最后更新时间',
       deleted                string      COMMENT '是否被删除（禁用）',
       customer_id            INT         COMMENT '所属客户id',
       first_id               INT         COMMENT '第一条客户关系id',
       origin_type            string      COMMENT '线上线下',
       itcast_school_id       INT         COMMENT '校区Id',
       itcast_subject_id      INT         COMMENT '学科Id',
       intention_study_type   string      COMMENT '意向学习方式',
       creator                INT         COMMENT '负责这个意向信息的销售id',
       creator_name           string      COMMENT '负责这个意向信息的销售姓名',
       origin_channel         string      COMMENT '来源渠道',
       first_customer_clue_id   INT       COMMENT '第一条线索id',
       last_customer_clue_id    INT       COMMENT '最后一条线索id',
       payment_state          string      COMMENT '支付状态',
       payment_time           string      COMMENT '支付状态变动时间',
       total_fee             DECIMAL(25,2)COMMENT '报名费总金额',
       yearcode               string      comment  '年',
       monthcode              string      comment  '月',
       daycode                string      comment  '日',
       hourcode               string      comment  '小时',
       origin_type_state      string      COMMENT '数据来源:0.线下；1.线上',
       clue_state_state       STRING COMMENT '新老客户：0.老客户；1.新客户 -1 其他',
       -- 校区信息表
       school_name              string        COMMENT '校区名称',

       -- 学科信息表
       subject_name             string        COMMENT '学科名称',

       -- 员工表 员工部门表
       department_id           string         COMMENT '部门id',
       department_name         string         COMMENT '咨询中心部门名称',

       -- 学员信息表
       customer_relationship_id  INT         COMMENT '当前意向id',
       stu_name                 string       COMMENT '姓名',
       area                     string       COMMENT '所在区域',
       dt                       string       comment '具体天日期'
)
row format delimited fields terminated by '\t'
stored as orc tblproperties ('orc.compress'='snappy');

----------------------
-- 创建dws层
create database zx_dws;
----------------------------
-- ====================================== 线索宽表 ===========================================
CREATE TABLE IF NOT EXISTS zx_dws.dws_clue_count(

    -- 线索表
    create_date_time         string comment '创建时间',
    hourcode                 string comment '小时',
    origin_type              string comment '数据来源渠道',
    clue_state               string comment '线索状态',

    -- 分组标记
    group_type              string comment '分组标记',

    -- 指标
    day_intention_cnt      bigint comment '意向人数',

    hour_av_clue_rate      decimal(5,2) comment '有效转化率'


)
row format delimited fields terminated by '\t'
stored as orc tblproperties ('orc.compress'='snappy');

-- ===========================================================================
insert into hive.zx_dws.dws_clue_count
with temp as (
select
       dic.id,
       substr(dcc.create_date_time,1,10) as create_date_time,
       substr(dcc.create_date_time,1,13) as hourcode,
       dcc.update_date_time,
       dcc.deleted,
       dcc.customer_id,
       dic.customer_relationship_id,
       if(dcc.origin_type in ('NETSERVICE','PRESIGNUP'),'1','0') as origin_type_state, -- 1.线上 0.线下
       case dic.clue_state
       when 'VALID_NEW_CLUES' then '1'
       else '0' end as clue_state_stat, -- 1 新用户 0 老用户
       fac.customer_relationship_first_id as customer_relationship_first_id ,
       fac.appeal_status as appeal_status

from zx_dwd.fact_customer_relationship dcc
left  join zx_dwd.fact_customer_appeal fac
on dcc.id = fac.customer_relationship_first_id and  dcc.deleted='false'
left join zx_dwd.dim_customer_clue dic
on dic.customer_relationship_id = dcc.id
 )
 select
      -- 维度
      create_date_time,
      hourcode,
      origin_type_state,
      clue_state_stat,

      -- 分组标记
      case when grouping(create_date_time,hourcode,origin_type_state,clue_state_stat)=4
           then 'day_origin_user'
           when grouping(create_date_time,hourcode,origin_type_state,clue_state_stat)=8
           then 'hour_origin_user' end as group_type,

      -- 指标计算
      case when grouping(create_date_time,hourcode,origin_type_state,clue_state_stat)=4
           then count(if(customer_relationship_first_id is null or appeal_status = 2,id,null))
           end as day_intention_cnt,

      case when grouping(create_date_time,hourcode,origin_type_state,clue_state_stat)=8
           then cast(cast(count(if(customer_relationship_first_id is null or appeal_status = 2,id,null)) as decimal(8,2)) / cast(count(id) as decimal(8,2)) * 100 as decimal(5,2))
           end as hour_av_clue_rate



 from temp
 group by
 grouping sets (
   (create_date_time,origin_type_state,clue_state_stat),
   (hourcode,origin_type_state,clue_state_stat)

 )
;


