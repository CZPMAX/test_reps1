create database zx_ods;
-------------------------
--------------------------------- 员工表的创建 ---------------------------------------
-- 注意导入数据分区表分区字段的值

CREATE TABLE zx_ods.employee
(
    id                  INT         COMMENT '员工id',
    email               string      COMMENT '公司邮箱，OA登录账号',
    real_name           string      COMMENT '员工的真实姓名',
    phone               string      COMMENT '手机号，目前还没有使用；隐私问题OA接口没有提供这个属性，',
    department_id       string      COMMENT 'OA中的部门编号，有负值',
    department_name     string      COMMENT 'OA中的部门名',
    remote_login        string      COMMENT '员工是否可以远程登录',
    job_number          string      COMMENT '员工工号',
    cross_school        string      COMMENT '是否有跨校区权限',
    last_login_date     string      COMMENT '最后登录日期',
    creator             string      COMMENT '创建人',
    create_date_time    string      COMMENT '创建时间',
    update_date_time    string      COMMENT '最后更新时间',
    deleted             string      COMMENT '是否被删除（禁用）',
    scrm_department_id  INT         COMMENT 'SCRM内部部门id',
    leave_office        string      COMMENT '离职状态',
    leave_office_time   string      COMMENT '离职时间',
    reinstated_time     string      COMMENT '复职时间',
    superior_leaders_id INT         COMMENT '上级领导ID',
    tdepart_id          INT         COMMENT '直属部门',
    tenant              INT         ,
    ems_user_name       string
)COMMENT '员工信息表'
row format delimited fields terminated by '\t'
stored as orc tblproperties('orc.compress'='ZLIB');
-- sqoop导入数据
-- sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
-- --connect 'jdbc:mysql://106.75.33.59:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
-- --username itcast_edu_stu \
-- --password itcast_edu_stu \
-- --query "select * from employee where 1=1 and  \$CONDITIONS" \
-- --hcatalog-database zx_ods \
-- --hcatalog-table employee \
-- -m 1


-- ==========================================================================
------------------------------- 员工部门表的创建 --------------------------------
--------------
CREATE TABLE zx_ods.scrm_department
(
    id               INT          COMMENT '部门id',
    name             string       COMMENT '部门名称',
    parent_id        INT          COMMENT '父部门id',
    create_date_time string       COMMENT '创建时间',
    update_date_time string       COMMENT '更新时间',
    deleted          string       COMMENT '删除标志',
    id_path          string       COMMENT '编码全路径',
    tdepart_code     INT          COMMENT '直属部门',
    creator          string       COMMENT '创建者',
    depart_level     INT          COMMENT '部门层级',
    depart_sign      INT          COMMENT '部门标志，暂时默认1',
    depart_line      INT          COMMENT '业务线，存储业务线编码',
    depart_sort      INT          COMMENT '排序字段',
    disable_flag     INT          COMMENT '禁用标志',
    tenant           INT
)COMMENT '员工部门表'
row format delimited fields terminated by '\t'
stored as orc tblproperties('orc.compress'='ZLIB');
--------------------------------------------------------------------
-- sqoop导入数据
-- sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
-- --connect 'jdbc:mysql://106.75.33.59:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
-- --username itcast_edu_stu \
-- --password itcast_edu_stu \
-- --query "select * from scrm_department where 1=1 and  \$CONDITIONS" \
-- --hcatalog-database zx_ods \
-- --hcatalog-table scrm_department \
-- -m 1
-- ==========================================================================



--------------------------------- 学科信息表 -------------------------------------
CREATE TABLE zx_ods.itcast_subject
(
    id               INT         COMMENT '学科id'                ,
    create_date_time string      COMMENT '创建时间',
    update_date_time string      COMMENT '最后更新时间',
    deleted          string      COMMENT '是否被删除（禁用）',
    name             string      COMMENT '学科名称',
    code             string      ,
    tenant           INT
)COMMENT '学科信息表'
row format delimited fields terminated by '\t'
stored as orc tblproperties('orc.compress'='ZLIB');
-- sqoop导入数据
-- sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
-- --connect 'jdbc:mysql://106.75.33.59:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
-- --username itcast_edu_stu \
-- --password itcast_edu_stu \
-- --query "select * from itcast_subject where 1=1 and  \$CONDITIONS" \
-- --hcatalog-database zx_ods \
-- --hcatalog-table itcast_subject \
-- -m 1

------------------------------- 校区信息表 -----------------------------------
CREATE TABLE zx_ods.itcast_school
(
    id               INT          COMMENT '校区id',
    create_date_time string       COMMENT '创建时间',
    update_date_time string       COMMENT '最后更新时间',
    deleted          string       COMMENT '是否被删除（禁用）',
    name             string       COMMENT '校区名称',
    code             string ,
    tenant           INT
) COMMENT '校区信息表'
row format delimited fields terminated by '\t'
stored as orc tblproperties('orc.compress'='ZLIB');
---------------------------------------------------------------------------
-- sqoop导入数据
-- sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
-- --connect 'jdbc:mysql://106.75.33.59:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
-- --username itcast_edu_stu \
-- --password itcast_edu_stu \
-- --query "select * from itcast_school where 1=1 and  \$CONDITIONS" \
-- --hcatalog-database zx_ods \
-- --hcatalog-table itcast_school \
-- -m 1

----------------------------- 申诉表 -------------------------------------
CREATE TABLE zx_ods.customer_appeal
(
    id                             INT            COMMENT '主键',
    customer_relationship_first_id INT            COMMENT '第一条客户关系id \ 意向id',
    employee_id                    INT            COMMENT '申诉人',
    employee_name                  string         COMMENT '申诉人姓名',
    employee_department_id         INT            COMMENT '申诉人部门',
    employee_tdepart_id            INT            COMMENT '申诉人所属部门',
    appeal_status                  INT            COMMENT '申诉状态，0:待稽核 1:无效 2：有效',
    audit_id                       INT            COMMENT '稽核人id',
    audit_name                     string         COMMENT '稽核人姓名',
    audit_department_id            INT            COMMENT '稽核人所在部门',
    audit_department_name          string         COMMENT '稽核人部门名称',
    audit_date_time                string         COMMENT '稽核时间',
    create_date_time               string         COMMENT '创建时间（申诉时间）',
    update_date_time               string         COMMENT '更新时间',
    deleted                        string         COMMENT '删除标志位',
    tenant                         INT
)COMMENT '申诉信息表'
row format delimited fields terminated by '\t'
stored as orc tblproperties('orc.compress'='ZLIB');
----------------------------------------------------------------------------------
-- sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
-- --connect 'jdbc:mysql://106.75.33.59:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
-- --username itcast_edu_stu \
-- --password itcast_edu_stu \
-- --query "select * from customer_appeal where 1=1 and  \$CONDITIONS" \
-- --hcatalog-database zx_ods \
-- --hcatalog-table customer_appeal \
-- -m 1

---------------------------------------------------------------------------------
CREATE TABLE zx_ods.customer_clue
(
    id                       INT           COMMENT '线索id',
    create_date_time         string        COMMENT '创建时间',
    update_date_time         string        COMMENT '最后更新时间',
    deleted                  string        COMMENT '是否被删除（禁用）',
    customer_id              INT           COMMENT '客户id',
    customer_relationship_id INT           COMMENT '客户关系id',
    session_id               string        COMMENT '七陌会话id',
    sid                      string        COMMENT '访客id',
    `status`                 string        COMMENT '状态（undeal待领取 deal 已领取 finish 已关闭 changePeer 已流转）',
    `user`                   string        COMMENT '所属坐席',
    create_time              string        COMMENT '七陌创建时间',
    platform                 string        COMMENT '平台来源 （pc-网站咨询|wap-wap咨询|sdk-app咨询|weixin-微信咨询）',
    s_name                   string        COMMENT '用户名称',
    seo_source               string        COMMENT '搜索来源',
    seo_keywords             string        COMMENT '关键字',
    ip                       string        COMMENT 'IP地址',
    referrer                 string        COMMENT '上级来源页面',
    from_url                 string        COMMENT '会话来源页面',
    landing_page_url         string        COMMENT '访客着陆页面',
    url_title                string        COMMENT '咨询页面title',
    to_peer                  string        COMMENT '所属技能组',
    manual_time              string        COMMENT '人工开始时间',
    begin_time               string        COMMENT '坐席领取时间 ',
    reply_msg_count          INT           COMMENT '客服回复消息数',
    total_msg_count          INT           COMMENT '消息总数',
    msg_count                INT           COMMENT '客户发送消息数',
    `comment`                   string        COMMENT '备注',
    finish_reason            string        COMMENT '结束类型',
    finish_user              string        COMMENT '结束坐席',
    end_time                 string        COMMENT '会话结束时间',
    platform_description     string        COMMENT '客户平台信息',
    browser_name             string        COMMENT '浏览器名称',
    os_info                  string        COMMENT '系统名称',
    area                     string        COMMENT '区域',
    country                  string        COMMENT '所在国家',
    province                 string        COMMENT '省',
    city                     string        COMMENT '城市',
    creator                  INT           COMMENT '创建人',
    name                     string        COMMENT '客户姓名',
    idcard                   string        COMMENT '身份证号',
    phone                    string        COMMENT '手机号',
    itcast_school_id         INT           COMMENT '校区Id',
    itcast_school            string        COMMENT '校区',
    itcast_subject_id        INT           COMMENT '学科Id',
    itcast_subject           string        COMMENT '学科',
    wechat                   string        COMMENT '微信',
    qq                       string        COMMENT 'qq号',
    email                    string        COMMENT '邮箱',
    gender                   string        COMMENT '性别',
    `level`                    string        COMMENT '客户级别',
    origin_type              string        COMMENT '数据来源渠道',
    information_way          string        COMMENT '资讯方式',
    working_years            string        COMMENT '开始工作时间',
    technical_directions     string        COMMENT '技术方向',
    customer_state           string        COMMENT '当前客户状态',
    valid                    string        COMMENT '该线索是否是网资有效线索',
    anticipat_signup_date    string        COMMENT '预计报名时间',
    clue_state               string        COMMENT '线索状态',
    scrm_department_id       string        COMMENT 'SCRM内部部门id',
    superior_url             string        COMMENT '诸葛获取上级页面URL',
    superior_source          string        COMMENT '诸葛获取上级页面URL标题',
    landing_url              string        COMMENT '诸葛获取着陆页面URL',
    landing_source           string        COMMENT '诸葛获取着陆页面URL来源',
    info_url                 string        COMMENT '诸葛获取留咨页URL',
    info_source              string        COMMENT '诸葛获取留咨页URL标题',
    origin_channel           string        COMMENT '投放渠道',
    course_id                string        COMMENT '',
    course_name              string,
    zhuge_session_id         string,
    is_repeat                INT           COMMENT '是否重复线索(手机号维度) 0:正常 1：重复',
    tenant                   INT           COMMENT '租户id',
    activity_id              string        COMMENT '活动id',
    activity_name            string        COMMENT '活动名称',
    follow_type              INT           COMMENT '分配类型，0-自动分配，1-手动分配，2-自动转移，3-手动单个转移，4-手动批量转移，5-公海领取',
    shunt_mode_id            INT           COMMENT '匹配到的技能组id',
    shunt_employee_group_id  INT           COMMENT '所属分流员工组'

)COMMENT '客户线索表'
partitioned by(dt string)
row format delimited fields terminated by '\t'
stored as orc tblproperties('orc.compress'='ZLIB');
---------------------------------------------------------------
-- sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
-- --connect 'jdbc:mysql://106.75.33.59:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
-- --username itcast_edu_stu \
-- --password itcast_edu_stu \
-- --query "select * ,'2022-10-13' as dt from customer_clue where 1=1 and  \$CONDITIONS" \
-- --hcatalog-database zx_ods \
-- --hcatalog-table customer_clue \
-- -m 1

-----------------------------------------------------------------------------
CREATE TABLE zx_ods.customer_relationship
(
    id                     INT         COMMENT '意向id，唯一标记一条意向信息',
    create_date_time       string      COMMENT '意向创建时间',
    update_date_time       string      COMMENT '最后更新时间',
    deleted                string      COMMENT '是否被删除（禁用）',
    customer_id            INT         COMMENT '所属客户id',
    first_id               INT         COMMENT '第一条客户关系id',
    belonger               INT         COMMENT '归属人',
    belonger_name          string      COMMENT '归属人姓名',
    initial_belonger       INT         COMMENT '初始归属人',
    distribution_handler   INT         COMMENT '分配处理人',
    business_scrm_department_id INT    COMMENT '归属部门',
    last_visit_time        string      COMMENT '最后回访时间',
    next_visit_time        string      COMMENT '下次回访时间',
    origin_type            string      COMMENT '数据来源',
    itcast_school_id       INT      COMMENT '校区Id',
    itcast_subject_id      INT         COMMENT '学科Id',
    intention_study_type   string      COMMENT '意向学习方式',
    anticipat_signup_date  string      COMMENT '预计报名时间',
    `level`                string      COMMENT '客户级别',
    creator                INT         COMMENT '创建人',
    current_creator        INT         COMMENT '当前创建人：初始==创建人，当在公海拉回时为 拉回人',
    creator_name           string      COMMENT '创建者姓名',
    origin_channel         string      COMMENT '来源渠道',
    `COMMENT`                 string      COMMENT '学习意向描述',
    first_customer_clue_id   INT       COMMENT '第一条线索id',
    last_customer_clue_id    INT       COMMENT '最后一条线索id',
    process_state          string      COMMENT '处理状态',
    process_time           string      COMMENT '处理状态变动时间',
    payment_state          string      COMMENT '支付状态',
    payment_time           string      COMMENT '支付状态变动时间',
    signup_state           string      COMMENT '报名状态',
    signup_time            string      COMMENT '报名时间',
    notice_state           string      COMMENT '通知状态',
    notice_time            string      COMMENT '通知状态变动时间',
    lock_state             string      COMMENT '锁定状态',
    lock_time              string      COMMENT '锁定状态修改时间',
    itcast_clazz_id           INT      COMMENT '所属ems班级id',
    itcast_clazz_time      string      COMMENT '报班时间',
    payment_url            string      COMMENT '付款链接',
    payment_url_time       string      COMMENT '支付链接生成时间',
    ems_student_id            INT      COMMENT 'ems的学生id',
    delete_reason          string      COMMENT '删除原因',
    deleter                   INT      COMMENT '删除人',
    deleter_name           string      COMMENT '删除人姓名',
    delete_time            string      COMMENT '删除时间',
    course_id                 INT      COMMENT '课程ID',
    course_name            string      COMMENT '课程名称',
    delete_comment         string      COMMENT '删除原因说明',
    close_state            string      COMMENT '关闭装填',
    close_time             string      COMMENT '关闭状态变动时间',
    appeal_id                 INT      COMMENT '申诉id',
    tenant                    INT      COMMENT '租户',
    total_fee             DECIMAL(25,2)COMMENT '报名费总金额',
    belonged                  INT      COMMENT '小周期归属人',
    belonged_time          string      COMMENT '归属时间',
    belonger_time          string      COMMENT '归属时间',
    transfer                  INT      COMMENT '转移人',
    transfer_time         string       COMMENT '转移时间',
    follow_type               INT      COMMENT '分配类型，0-自动分配，1-手动分配，2-自动转移，3-手动单个转移，4-手动批量转移，5-公海领取',
    transfer_bxg_oa_account  string    COMMENT '转移到博学谷归属人OA账号',
    transfer_bxg_belonger_name  string COMMENT '转移到博学谷归属人OA姓名'
)COMMENT '客户意向表'
partitioned by(dt string)
row format delimited fields terminated by '\t'
stored as orc tblproperties('orc.compress'='ZLIB');
;
---------------------------------------------------------------------------------
-- sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
-- --connect 'jdbc:mysql://106.75.33.59:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
-- --username itcast_edu_stu \
-- --password itcast_edu_stu \
-- --query "select * ,'2022-10-13' as dt from customer_relationship where 1=1 and  \$CONDITIONS" \
-- --hcatalog-database zx_ods \
-- --hcatalog-table customer_relationship \
-- -m 1
----------------------------------------------------------------------------------

CREATE TABLE zx_ods.customer
(
    id                        INT         COMMENT '学生id'  ,
    customer_relationship_id  INT         COMMENT '当前意向id',                   create_date_time         string       COMMENT '创建时间',
    update_date_time         string       COMMENT '最后更新时间',
    deleted                  string       COMMENT '是否被删除（禁用）',
    name                     string       COMMENT '姓名',
    idcard                   string       COMMENT '身份证号',
    birth_year               string       COMMENT '出生年份',
    gender                   string       COMMENT '性别',
    phone                    string       COMMENT '手机号',
    wechat                   string       COMMENT '微信',
    qq                       string       COMMENT 'qq号',
    email                    string       COMMENT '邮箱',
    area                     string        COMMENT '所在区域',
    leave_school_date        string       COMMENT '离校时间',                     graduation_date          string       COMMENT '毕业时间',
    bxg_student_id           string       COMMENT '博学谷学员ID，可能未关联到，不存在',
    creator                  INT          COMMENT '创建人ID,是员工创建的信息，所以跟员工表的id关联',
    origin_type              string        COMMENT '数据来源',
    origin_channel           string        COMMENT '来源渠道',
    tenant                   INT           ,
    md_id                    INT           COMMENT '中台id'



)COMMENT '学员信息表'
partitioned by (dt string)
row format delimited fields terminated by '\t';
-----------------------------------------------------------------------
-- sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
-- --connect 'jdbc:mysql://106.75.33.59:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
-- --username itcast_edu_stu \
-- --password itcast_edu_stu \
-- --query "select * ,'2022-10-13' as dt from customer where 1=1 and  \$CONDITIONS" \
-- --hcatalog-database zx_ods \
-- --hcatalog-table customer \
-- -m 1
-----------------------------------------------------------------