drop table if exists ty_ods.w_cmfholderstructure;
create table if not exists ty_ods.w_cmfholderstructure
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  sec_id string comment '证券ID',
  ann_dt string comment '公告日期',
  end_dt string comment '截止日期',
  scope string comment '范围',
  holder_number bigint comment '基金份额持有人户数(户)',
  holder_avgholding decimal(20,4) comment '平均每户持有基金份额(份)',
  holder_institution_holding decimal(20,4) comment '机构投资者持有份额(份)',
  holder_institution_holdingpct decimal(20,4) comment '机构投资者持有份额占比(%)',
  holder_personal_holding decimal(20,4) comment '个人投资者持有份额(份)',
  holder_personal_holdingpct decimal(20,4) comment '个人投资者持有份额占比(%)',
  holder_mngemp_holding decimal(20,4) comment '管理人员工持有份额(份)',
  holder_mngemp_holdingpct decimal(20,8) comment '管理人员工持有份额占比(%)',
  holder_feeder_holding decimal(20,4) comment '联接基金持有份额(份)',
  holder_feeder_holdingpct decimal(20,4) comment '联接基金持有份额占比(%)',
  pur_cost decimal(20,4) comment '报告期买入股票成本总额(元)',
  sell_income decimal(20,4) comment '报告期卖出股票收入总额(元)',
  is_merge_data bigint comment '是否为合并数据',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
 COMMENT '中国共同基金持有人结构'
row format delimited fields terminated by '\t'
stored as orc;



