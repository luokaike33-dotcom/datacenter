drop table if exists ty_ods.w_cmmquarterlydata;
create table if not exists ty_ods.w_cmmquarterlydata
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_date string comment '公告日期',
  f_info_bgndate string comment '报告期起始日期',
  f_info_enddate string comment '报告期截止日期',
  floating_bond_amount decimal(20,4) comment '剩余存续期超过397天的浮动利率债券金额',
  floating_bond_amount_ratio decimal(20,4) comment '剩余存续期超过397天的浮动利率债券占资产净值比例(%)',
  bondrepo_balance decimal(20,4) comment '报告期内债券回购融资余额',
  bondrepo_balance_ratio decimal(20,4) comment '报告期内债券回购融资余额占资产净值的比例(%)',
  end_bondrepo_balance decimal(20,4) comment '报告期末债券回购融资余额',
  end_bondrepo_balance_ratio decimal(20,4) comment '报告期末债券回购融资余额占资产净值的比例(%)',
  avg_remainder_period_max decimal(20,4) comment '报告期内投资组合平均剩余期限最高值',
  avg_remainder_period_min decimal(20,4) comment '报告期内投资组合平均剩余期限最低值',
  deviation_degree_frequency decimal(20,4) comment '报告期内偏离度的绝对值在0.25％(含)－0.5％间的次数',
  deviation_degree_max decimal(20,4) comment '报告期内偏离度的最高值(%)',
  deviation_degree_min decimal(20,4) comment '报告期内偏离度的最低值(%)',
  deviation_degree_avg_value decimal(20,4) comment '报告期内每个工作日偏离度的绝对值的简单平均值(%)',
  fixed_deposit decimal(20,4) comment '商业银行定期存款',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



