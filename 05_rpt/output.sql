create DATABASE zx_olap;

CREATE DATABASE zx_olap DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

create table mysql.zx_olap.olap_clue
as select * from hive.zx_rpt.rpt_clue_detail;

create table mysql.zx_olap.olap_intention
as select * from hive.zx_rpt.rpt_intention_detail;

SHOW VARIABLES LIKE 'character%';
SET character_set_server = utf8;

create table zx_olap.olap_intention_detail(



    timecode       varchar(50) comment '时间标记 有年 月 日',
    type_id        bigint comment '标记id 学科id 或者 校区id',
    type_name      varchar(50) comment '标记名称  学科名称 或者 校区名称',
    int_people_cnt bigint comment '意向人数',
    t_type         varchar(50) comment '分组标记'



)ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- 每天北京线上新学员意向人数top10
select timecode,
--        type_id,
       type_name,
       int_people_cnt
--        t_type
from zx_olap.olap_intention where type_name='北京' and t_type='day_sch_online_new' order by int_people_cnt desc limit 10;