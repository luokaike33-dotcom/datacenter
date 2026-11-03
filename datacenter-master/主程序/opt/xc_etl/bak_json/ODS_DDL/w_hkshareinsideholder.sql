drop table if exists ty_ods.w_hkshareinsideholder;
create table if not exists ty_ods.w_hkshareinsideholder
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  ann_dt string comment '公告日期',
  end_dt string comment '截至日期',
  report_type bigint comment '报告类型代码',
  holder_type bigint comment '股东类型代码',
  holdername string comment '股东名称',
  holderid string comment '股东ID',
  holderid_type bigint comment '股东类别代码',
  dirholdnum decimal(20,4) comment '直接持有数量',
  indirholdnum decimal(20,4) comment '间接持有数量',
  sharetype string comment '股份性质',
  pct_tot decimal(20,4) comment '占股份总数比例(%)',
  pct_stype decimal(20,4) comment '占同类型股份比例',
  s_ctnt string comment '备注',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



