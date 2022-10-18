create table if not exists zx_dws.dws_intention_daycount(


                    -- 维度
                    yearcode               string      comment  '年',
                    monthcode              string      comment  '月',
                    create_time  string comment '意向创建时间', -- 日期
--                  orgin_type   string comment '线上线下', -- 线上线下
--                  clue_state   string comment '新旧线索',-- 新老学员

--                  daycode                string      comment  '日',
--                  hourcode               string      comment  '小时',
                    origin_type_state      string      COMMENT '数据来源:0.线下；1.线上',
                    clue_state_state          STRING COMMENT '新老客户：0.老客户；1.新客户 ',
                    area         string comment '所在地区',    --各地区
                    itcast_school_id int comment '校区id',
                    school_name  string comment '校区名称',     --各校区
                    itcast_subject_id int comment '学科id',
                    subject_name string comment '学科名称', --各学科
                    department_id string comment '部门id',
                    department_name string comment '部门名称', --各部门
                    origin_channel string comment '来源渠道',--来源渠道

                    group_type  string comment '分组标记: ', --分组标记

                    -- 意向用户指标计算
                    total_intention_cnt int comment '意向用户个数'



)COMMENT '意向日统计宽表'
row format delimited fields terminated by '\t'
stored as orc tblproperties ('orc.compress'='snappy');


