drop table if exists ty_ods.w_bondissuanceplan;
create table if not exists ty_ods.w_bondissuanceplan
(
  object_id string comment '对象ID',
  s_info_compname string comment '公司名称',
  s_info_compcode string comment '公司ID',
  ann_dt string comment '公告日期',
  progress_code bigint comment '方案进度代码',
  bondtype string comment '拟发行债券类型',
  amount decimal(24,8) comment '发行数量(亿元)',
  description string comment '发行数量说明',
  is_max_amount bigint comment '是否是最大发行数量',
  duration string comment '期限说明',
  rate string comment '利率说明',
  leadunderwriter string comment '主承销商',
  is_approved bigint comment '是否需股东大会批准',
  is_issue_shareholder bigint comment '是否向股东配售',
  arrangement string comment '向股东配售安排',
  s_info_usage string comment '募集资金的用途',
  effectiveperiod string comment '决议的有效期',
  ann_date_board string comment '董事会预案公告日',
  ann_date_shareholder string comment '股东大会公告日',
  ann_date_ndrc string comment '发改委获准公告日',
  ann_date_csiec string comment '发审委通过公告日',
  ann_date_sfc string comment '证监会核准公告日',
  ann_date_implement string comment '实施公告日',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



