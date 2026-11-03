drop table if exists ty_ods.w_cbondfinnotesdetail;
create table if not exists ty_ods.w_cbondfinnotesdetail
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  report_period string comment '报告期',
  statement_type bigint comment '报表类型代码',
  bd_loss decimal(20,4) comment '坏账损失',
  inv_loss decimal(20,4) comment '存货跌价损失',
  gi_loss decimal(20,4) comment '商誉减值损失',
  gc_loss decimal(20,4) comment '发放贷款和垫款减值损失',
  afa_loss decimal(20,4) comment '可供出售金融资产减值损失',
  hi_loss decimal(20,4) comment '持有至到期投资减值损失',
  oth_loss decimal(20,4) comment '其他金融资产减值损失',
  lti_invinc decimal(20,4) comment '处置长期股权投资产生的投资收益',
  fat_invinc decimal(20,4) comment '处置交易性金融资产取得的投资收益',
  afa_invinc decimal(20,4) comment '处置可供出售金融资产取得的投资收益',
  paei_invinc decimal(20,4) comment '委托投资损益',
  fel_invinc decimal(20,4) comment '对外委托贷款取得的收益',
  cfeo_invinc decimal(20,4) comment '受托经营取得的托管费收入',
  othn_invinc decimal(20,4) comment '其他非经常性投资收益',
  lti_cost decimal(20,4) comment '成本法核算的长期股权投资收益',
  lur_orival decimal(20,4) comment '土地使用权-原值',
  lur_acca decimal(20,4) comment '土地使用权-累计摊销',
  lur_imp decimal(20,4) comment '土地使用权-减值准备',
  lur_bookval decimal(20,4) comment '土地使用权-账面价值',
  lti_equ decimal(20,4) comment '权益法核算的长期股权投资',
  monf_res decimal(20,4) comment '受限制的货币资金',
  sal_cos decimal(20,4) comment '工资薪酬(销售费用)',
  sal_gex decimal(20,4) comment '工资薪酬(管理费用)',
  da_cos decimal(20,4) comment '折旧摊销(销售费用)',
  da_gex decimal(20,4) comment '折旧摊销(管理费用)',
  ren_cos decimal(20,4) comment '租赁费(销售费用)',
  ren_gex decimal(20,4) comment '租赁费(管理费用)',
  stc_cos decimal(20,4) comment '仓储运输费(销售费用)',
  ape_cos decimal(20,4) comment '广告宣传推广费(销售费用)',
  ltloan_1y decimal(20,4) comment '1年内到期的长期借款',
  bondpay_1y decimal(20,4) comment '1年内到期的应付债券',
  stfinbond decimal(20,4) comment '短期融资债(其他流动负债)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



