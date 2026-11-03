drop table if exists ty_ods.w_absinsideholder;
create table if not exists ty_ods.w_absinsideholder
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  s_info_compname string comment '公司名称',
  ann_dt string comment '公告日期',
  b_holder_enddate string comment '截止日期',
  b_holder_holdercategory string comment '股东类型',
  b_holder_name string comment '股东名称',
  b_holder_quantity decimal(20,4) comment '持股数量',
  b_holder_pct decimal(20,4) comment '持股比例',
  b_holder_sharecategory string comment '持股性质',
  b_holder_aname string comment '股东名称',
  holderid string comment '股东ID',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_abssensitanalysis;
create table if not exists ty_ods.w_abssensitanalysis
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  anal_type string comment '敏感性分析类型',
  anal_ratio decimal(20,4) comment '早偿率/违约率',
  weigh_avg_term decimal(20,4) comment '加权平均期限',
  est_maturitydate string comment '预期到期日',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_abstransaction;
create table if not exists ty_ods.w_abstransaction
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '转让日期',
  s_inc_initexecpri decimal(20,4) comment '转让价格',
  transferred decimal(20,4) comment '转让数量(手)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_accountrelatedwithbondissue;
create table if not exists ty_ods.w_accountrelatedwithbondissue
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  type_code bigint comment '发行类型代码',
  account_num string comment '账号',
  account_title string comment '账户名称',
  bank_name string comment '开户行名称',
  bank_num string comment '清算行行号',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_aequfropleinforepperend;
create table if not exists ty_ods.w_aequfropleinforepperend
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_info_compcode string comment '公司ID',
  price_date string comment '报告期',
  f_nav_unit string comment '公告日期',
  f_nav_accumulated string comment '股东名称',
  f_nav_divaccumulated decimal(20,4) comment '质押或冻结数量(股)',
  f_nav_adjfactor decimal(20,4) comment '持股数量(股)',
  crncy_code decimal(20,4) comment '质押冻结比例(%)',
  f_nav_adjusted string comment '备注',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_aindexalternativemembers;
create table if not exists ty_ods.w_aindexalternativemembers
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_con_windcode string comment 'Wind代码',
  ann_date string comment '公告日期',
  sequence bigint comment '序号',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_aindexconsensusdata;
create table if not exists ty_ods.w_aindexconsensusdata
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  est_dt string comment '日期',
  est_report_dt string comment '报告期',
  net_profit decimal(20,4) comment '净利润',
  est_eps decimal(20,4) comment '每股收益',
  est_pe decimal(20,4) comment '市盈率',
  est_peg decimal(20,4) comment 'PEG',
  est_pb decimal(20,4) comment '市净率',
  est_roe decimal(20,4) comment '净资产收益率',
  est_oper_revenue decimal(20,4) comment '营业收入',
  est_cfps decimal(20,4) comment '每股现金流',
  est_dps decimal(20,4) comment '每股股利',
  est_bps decimal(20,4) comment '每股净资产',
  est_ebit decimal(20,4) comment '息税前利润',
  est_ebitda decimal(20,4) comment '息税折旧摊销前利润',
  est_total_profit decimal(20,4) comment '利润总额',
  est_oper_profit decimal(20,4) comment '营业利润',
  est_oper_cost decimal(20,4) comment '营业成本及附加',
  est_shr decimal(20,4) comment '预测基准股本',
  type1 string comment '类型',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
 COMMENT 'Wind一致预测指数指标'
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_aindexconsensusrollingdata;
create table if not exists ty_ods.w_aindexconsensusrollingdata
(
  object_id string comment '对象ID',
  s_info_windcode string comment '证券ID',
  est_dt string comment '日期',
  rolling_type string comment '类型',
  net_profit decimal(20,4) comment '净利润',
  est_eps decimal(20,4) comment '每股收益',
  est_pe decimal(20,4) comment '市盈率',
  est_peg decimal(20,4) comment 'PEG',
  est_ decimal(20,4) comment '市净率',
  est_roe decimal(20,4) comment '净资产收益率',
  est_oper_revenue decimal(20,4) comment '营业收入',
  est_cfps decimal(20,4) comment '每股现金流',
  est_dps decimal(20,4) comment '每股股利',
  est_bps decimal(20,4) comment '每股净资产',
  est_ebit decimal(20,4) comment '息税前利润',
  est_ebitda decimal(20,4) comment '息税折旧摊销前利润',
  est_total_profit decimal(20,4) comment '利润总额',
  est_oper_profit decimal(20,4) comment '营业利润',
  est_oper_cost decimal(20,4) comment '营业成本及附加',
  benchmark_yr string comment '基准年度',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
 COMMENT 'Wind一致预测指数滚动指标'
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_aindexfinancialderivative;
create table if not exists ty_ods.w_aindexfinancialderivative
(
  object_id string comment '对象ID',
  s_info_windcode string comment '指数Wind代码',
  report_period string comment '报告期',
  ingredient_num bigint comment '成分股数量',
  loss_ingredient_num bigint comment '亏损成分股数量',
  net_profit_tot decimal(20,4) comment '净利润合计',
  oper_rev decimal(20,4) comment '营业收入合计',
  s_val_pcf_ocf decimal(20,4) comment '经营现金流合计',
  net_incr_cash_cash_equ_tot decimal(20,4) comment '现金及现金等价物净增加额合计',
  total_assets decimal(20,4) comment '总资产合计',
  total_net_assets decimal(20,4) comment '净资产合计',
  total_inventory decimal(20,4) comment '存货合计',
  total_accounts_receivable decimal(20,4) comment '应收账款合计',
  roe decimal(20,4) comment 'ROE',
  roa decimal(20,4) comment 'ROA',
  net_profit_rate decimal(20,4) comment '净利润率',
  gross_profit_margin decimal(20,4) comment '毛利率',
  assets_liabilities decimal(20,4) comment '资产负债率',
  period_expense_rate decimal(20,4) comment '期间费用率',
  financial_leverage decimal(20,4) comment '财务杠杆',
  asset_turnover decimal(20,4) comment '资产周转率',
  net_asset_turnover decimal(20,4) comment '净资产周转率',
  s_fa_invturndays decimal(20,4) comment '存货周转天数',
  s_fa_arturndays decimal(20,4) comment '应收账款周转天数',
  net_business_cycle decimal(20,4) comment '净营业周期',
  net_cashflow_profit decimal(20,4) comment '现金流净利润比',
  cashflow_income_ratio decimal(20,4) comment '现金流收入比',
  net_profit_ttm decimal(20,4) comment '净利润(TTM)',
  oper_rev_ttm decimal(20,4) comment '营业收入(TTM)',
  s_val_pcf_ocf_ttm decimal(20,4) comment '经营现金流(TTM)',
  net_incr_cash_cash_equ_ttm decimal(20,4) comment '现金及现金等价物净增加额(TTM)',
  roe_ttm decimal(20,4) comment 'ROE(TTM)',
  roa_ttm decimal(20,4) comment 'ROA(TTM)',
  net_profit_rate_ttm decimal(20,4) comment '净利润率(TTM)',
  net_profit_growth_rate decimal(20,4) comment '净利润同比增速',
  net_profit_growth_rate_ttm decimal(20,4) comment '净利润同比增速(TTM)',
  net_profit_growth_rate_qua decimal(20,4) comment '单季度:净利润同比增速',
  net_profit_growth_rate_chain decimal(20,4) comment '单季度:净利润环比增速',
  oper_rev_growth_rate decimal(20,4) comment '营业收入同比增速',
  oper_rev_growth_rate_ttm decimal(20,4) comment '营业收入同比增速(TTM)',
  oper_rev_growth_rate_qua decimal(20,4) comment '单季度:营业收入同比增速',
  oper_rev_growth_rate_chain decimal(20,4) comment '单季度:营业收入环比增速',
  s_val_pcf_ocf_growth_rate decimal(20,4) comment '经营现金流同比增速',
  s_val_pcf_ocf_growth_rate_ttm decimal(20,4) comment '经营现金流同比增速(TTM)',
  s_val_pcf_ocf_qua decimal(20,4) comment '单季度:经营现金流同比增速',
  s_val_pcf_ocf_chain decimal(20,4) comment '单季度:经营现金流环比增速',
  roe_increase_less decimal(20,4) comment 'ROE同比增减',
  roe_increase_less_ttm decimal(20,4) comment 'ROE同比增减(TTM)',
  roe_increase_less_qua decimal(20,4) comment '单季度:ROE同比增减',
  roe_increase_less_chain decimal(20,4) comment '单季度:ROE环比增减',
  roa_increase_less decimal(20,4) comment 'ROA同比增减',
  roa_increase_less_ttm decimal(20,4) comment 'ROA同比增减(TTM)',
  roa_increase_less_qua decimal(20,4) comment '单季度:ROA同比增减',
  roa_increase_less_chain decimal(20,4) comment '单季度:ROA环比增减',
  net_pro_rate_increase_less decimal(20,4) comment '净利润率同比增减',
  net_pro_rate_inc_less_ttm decimal(20,4) comment '净利率同比增减(TTM)',
  net_pro_rate_inc_less_qua decimal(20,4) comment '单季度:净利润率同比增减',
  net_pro_rate_inc_less_chain decimal(20,4) comment '单季度:净利润率环比增减',
  grossprofit_margin_inc_less decimal(20,4) comment '毛利率同比增减',
  gross_margin_inc_less_qua decimal(20,4) comment '单季度:毛利率同比增减',
  gross_margin_inc_less_chain decimal(20,4) comment '单季度:毛利率环比增减',
  period_expense_inc_less decimal(20,4) comment '期间费用率同比增减',
  period_expense_inc_less_qua decimal(20,4) comment '单季度:期间费用率同比增减',
  period_expense_inc_less_chain decimal(20,4) comment '单季度:期间费用率环比增减',
  net_assets_growth_rate decimal(20,4) comment '净资产比年初增速',
  assets_growth_rate decimal(20,4) comment '总资产比年初增速',
  stock_ratio_growth_rate decimal(20,4) comment '存货比年初增速',
  accounts_growth_rate decimal(20,4) comment '应收账款比年初增速',
  report_type_code bigint comment '报表类型代码',
  s_fa_current decimal(20,4) comment '流动比率',
  s_fa_quick decimal(20,4) comment '速动比率',
  sales_expense_rate decimal(20,4) comment '销售费用率',
  sales_expense_rate_qua decimal(20,4) comment '单季度:销售费用率',
  period_expense_rate_qua decimal(20,4) comment '单季度:期间费用率',
  net_profit_rate_qua decimal(20,4) comment '单季度:净利润率',
  profit_rate_qua decimal(20,4) comment '单季度:毛利率',
  roe_qua decimal(20,4) comment '单季度:ROE',
  roa_qua decimal(20,4) comment '单季度:ROA',
  oper_cost_tot decimal(20,4) comment '营业成本合计',
  selling_dist_exp_tot decimal(20,4) comment '销售费用合计',
  gerl_admin_exp_tot decimal(20,4) comment '管理费用合计',
  fin_exp_tot decimal(20,4) comment '财务费用合计',
  impair_loss_assets_tot decimal(20,4) comment '资产减值损失合计',
  net_gain_chg_fv_tot decimal(20,4) comment '公允价值变动净收益合计',
  net_invest_inc_tot decimal(20,4) comment '投资净收益合计',
  oper_profit_tot decimal(20,4) comment '营业利润合计',
  non_oper_rev_tot decimal(20,4) comment '营业外收入合计',
  non_oper_exp_tot decimal(20,4) comment '营业外支出合计',
  tot_profit decimal(20,4) comment '利润总额合计',
  inc_tax_tot decimal(20,4) comment '所得税合计',
  net_profit_incl_min_int_inc decimal(20,4) comment '净利润(含少数股东权益)合计',
  net_after_ded_nr_lp_correct decimal(20,4) comment '扣非归属净利润合计',
  s_fa_extraordinary decimal(20,4) comment '非经常性损益合计',
  s_fa_salescashintoor decimal(20,4) comment '销售商品提供劳务收到的现金合计',
  stot_cash_inflows_oper_tot decimal(20,4) comment '经营活动现金流入合计',
  cash_pay_goods_purch_serv_rec decimal(20,4) comment '购买商品支付的现金合计',
  cash_pay_beh_empl decimal(20,4) comment '支付给职工以及为职工支付的现金合计',
  stot_cash_outflows_oper_tot decimal(20,4) comment '经营活动现金流出合计',
  net_cash_recp_disp_fiolta decimal(20,4) comment '处置固定资产等收回的现金合计',
  stot_cash_inflows_inv_tot decimal(20,4) comment '投资活动现金流入合计',
  cash_pay_acq_const_fiolta decimal(20,4) comment '购建固定无形和长期资产支付的现金合计',
  cash_paid_invest decimal(20,4) comment '投资支付的现金合计',
  cash_paid_invest_tot decimal(20,4) comment '投资现金流出合计',
  net_cash_flows_inv_tot decimal(20,4) comment '投资活动净流量合计',
  cash_recp_cap_contrib decimal(20,4) comment '吸收投资收到的现金合计',
  cash_recp_borrow decimal(20,4) comment '取得借款收到的现金合计',
  proc_issue_bonds decimal(20,4) comment '发行债券收到的现金合计',
  stot_cash_inflows_fnc_tot decimal(20,4) comment '筹资活动现金流入合计',
  cash_prepay_amt_borr decimal(20,4) comment '偿付债务支付的现金合计',
  cash_pay_dist_dpcp_int_exp decimal(20,4) comment '分配股利偿付利息支付的现金合计',
  stot_cash_outflows_fnc_tot decimal(20,4) comment '筹资活动现金流出合计',
  net_cash_flows_fnc_tot decimal(20,4) comment '筹资活动净流量合计',
  cash_cash_equ_end_period decimal(20,4) comment '期末现金合计',
  monetary_cap decimal(20,4) comment '货币资金合计',
  notes_rcv decimal(20,4) comment '应收票据合计',
  acct_rcv decimal(20,4) comment '应收账款合计',
  prepay decimal(20,4) comment '预付款项合计',
  tot_cur_assets decimal(20,4) comment '流动资产合计',
  long_term_eqy_invest decimal(20,4) comment '长期股权投资合计',
  invest_real_estate decimal(20,4) comment '投资性房地产合计',
  fix_assets decimal(20,4) comment '固定资产合计',
  const_in_prog decimal(20,4) comment '在建工程合计',
  tot_non_cur_assets decimal(20,4) comment '非流动资产合计',
  st_borrow decimal(20,4) comment '短期借款合计',
  notes_payable decimal(20,4) comment '应付票据合计',
  acct_payable decimal(20,4) comment '应付账款合计',
  adv_from_cust decimal(20,4) comment '预收账款合计',
  empl_ben_payable decimal(20,4) comment '应付职工薪酬合计',
  non_cur_liab_due_within_1y decimal(20,4) comment '一年内到期的非流动负债合计',
  tot_cur_liab decimal(20,4) comment '流动负债合计',
  lt_borrow decimal(20,4) comment '长期借款合计',
  bonds_payable decimal(20,4) comment '应付债券合计',
  tot_non_cur_liab decimal(20,4) comment '非流动负债合计',
  paid_up_capital decimal(20,4) comment '实收资本合计',
  cap_rsrv decimal(20,4) comment '资本公积金合计',
  undistributed_profit decimal(20,4) comment '未分配利润合计',
  owners_equity decimal(20,4) comment '所有者权益合计',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_aindexhs300weight;
create table if not exists ty_ods.w_aindexhs300weight
(
  object_id string comment '对象ID',
  s_info_windcode string comment '指数Wind代码',
  s_con_windcode string comment '成份股Wind代码',
  trade_dt string comment '交易日期',
  i_weight decimal(20,4) comment '权重',
  s_in_index decimal(20,2) comment '计算用股本(股)',
  i_weight_11 decimal(20,2) comment '总股本(股)',
  i_weight_12 decimal(20,4) comment '自由流通比例(%)(归档后)',
  i_weight_14 decimal(20,8) comment '权重因子',
  i_weight_15 decimal(20,4) comment '收盘',
  i_weight_16 decimal(20,4) comment '调整后开盘参考价',
  i_weight_17 decimal(20,2) comment '总市值',
  i_weight_18 decimal(20,2) comment '计算用市值',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_aindexmemberswind;
create table if not exists ty_ods.w_aindexmemberswind
(
  object_id string comment '对象ID',
  f_info_windcode string comment '指数Wind代码',
  s_con_windcode string comment '成份股Wind代码',
  s_con_indate string comment '纳入日期',
  s_con_outdate string comment '剔除日期',
  cur_sign bigint comment '最新标志',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_aindexvaluation;
create table if not exists ty_ods.w_aindexvaluation
(
  object_id string comment '对象ID',
  s_info_windcode string comment '指数Wind代码',
  trade_dt string comment '交易日期',
  con_num decimal(20,4) comment '成分股数量',
  pe_lyr decimal(20,4) comment '市盈率(PE,LYR)',
  pe_ttm decimal(20,4) comment '市盈率(PE,TTM)',
  pb_lf decimal(20,4) comment '市净率(PB,LF)',
  pcf_lyr decimal(20,4) comment '市现率(PCF,LYR)',
  pcf_ttm decimal(20,4) comment '市现率(PCF,TTM)',
  ps_lyr decimal(20,4) comment '市销率(PS,LYR)',
  ps_ttm decimal(20,4) comment '市销率(PS,TTM)',
  mv_total decimal(24,4) comment '当日总市值合计（元）',
  mv_float decimal(24,4) comment '当日流通市值合计（元）',
  dividend_yield decimal(20,4) comment '股息率',
  peg_his decimal(20,4) comment '历史PEG',
  tot_shr decimal(20,4) comment '总股本合计（股）',
  tot_shr_float decimal(20,4) comment '流通股本合计（股）',
  tot_shr_free decimal(20,4) comment '自由流通股本合计（股）',
  turnover decimal(20,4) comment '换手率',
  turnover_free decimal(20,4) comment '换手率(自由流通)',
  est_net_profit_y1 decimal(20,4) comment '预测净利润(Y1)',
  est_net_profit_y2 decimal(20,4) comment '预测净利润(Y2)',
  est_bus_inc_y1 decimal(20,4) comment '预测营业收入(Y1)',
  est_bus_inc_y2 decimal(20,4) comment '预测营业收入(Y2)',
  est_eps_y1 decimal(20,4) comment '预测每股收益(Y1)',
  est_eps_y2 decimal(20,4) comment '预测每股收益(Y2)',
  est_yoyprofit_y1 decimal(20,4) comment '预测净利润同比增速(Y1)',
  est_yoyprofit_y2 decimal(20,4) comment '预测净利润同比增速(Y2)',
  est_yoygr_y1 decimal(20,4) comment '预测营业收入同比增速(Y1)',
  est_yoygr_y2 decimal(20,4) comment '预测营业收入同比增速(Y2)',
  est_pe_y1 decimal(20,4) comment '预测PE(Y1)',
  est_pe_y2 decimal(20,4) comment '预测PE(Y2)',
  est_peg_y1 decimal(20,4) comment '预测PEG(Y1)',
  est_peg_y2 decimal(20,4) comment '预测PEG(Y2)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asareplantrade;
create table if not exists ty_ods.w_asareplantrade
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_dt string comment '首次披露公告日',
  ann_dt_new string comment '最新公告日',
  is_adjustment bigint comment '方案是否有过调整',
  programme_progress bigint comment '方案进度代码',
  holder_name string comment '持有方名称',
  holder_id string comment '持有方id',
  holder_status string comment '股东身份类别',
  holder_type string comment '股东类型',
  hold_number decimal(20,4) comment '持有证券数量(股/张)',
  hold_proportion decimal(20,4) comment '持股数量占比(%)',
  hold_restricted_stock decimal(20,4) comment '持有限售股数量(股)',
  hold_unlimited_sale_shares decimal(20,4) comment '持有无限售股数量(股)',
  transact_type string comment '变动方向',
  transact_objective string comment '变动目的',
  transact_stock_source string comment '变动股份来源',
  transact_source_funds string comment '变动资金来源',
  transact_period_description string comment '变动期间说明',
  transaction_mode string comment '交易方式',
  plan_transact_max_num decimal(20,4) comment '拟变动数量上限(股/张)',
  plan_transact_max_ratio decimal(20,4) comment '拟变动数量上限占比(%)',
  plan_transact_min_num decimal(20,4) comment '拟变动数量下限(股/张)',
  plan_transact_min_ratio decimal(20,4) comment '拟变动数量下限占比(%)',
  plan_max_hold_ratio decimal(20,4) comment '拟最大变动数量占持有公司股份的比例(%)',
  tot_actual_transact_num decimal(20,4) comment '实际累计变动证券数量(股/张)',
  total_capital_stock decimal(20,4) comment '公司总股本(股)',
  plan_transact_min decimal(20,4) comment '拟变动金额下限(元)',
  plan_transact_max decimal(20,4) comment '拟变动金额上限(元)',
  variable_price_memo string comment '变动价格说明',
  change_start_date string comment '变动起始日期',
  change_end_date string comment '变动截止日期',
  is_change_control bigint comment '是否导致公司控制权变更',
  special_changes_memo string comment '特殊变动说明',
  program_adjustment_memo string comment '方案调整说明',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareaccountingchange;
create table if not exists ty_ods.w_ashareaccountingchange
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  report_period string comment '报告期',
  s_change_itemcode bigint comment '变更项目代码',
  s_change_reason string comment '变更的内容和原因',
  s_approval_program string comment '审批程序',
  be_affected_itemcode string comment '受影响的报表项目名称',
  influence_money decimal(20,4) comment '影响金额(元)',
  crncy_code string comment '货币代码',
  ann_date string comment '公告日期',
  be_affected_report_period string comment '受影响的报告期',
  be_affected_report_type bigint comment '受影响的报表类型',
  be_affected_subject string comment '受影响的报表科目名称(容错)',
  processing_result string comment '董事会对责任人采取的问责措施及处理结果',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareaccountspayable;
create table if not exists ty_ods.w_ashareaccountspayable
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  s_info_dimension string comment '维度',
  s_info_dimension1 string comment '子维度',
  s_info_comp_name string comment '上游公司名称',
  s_info_comp_sname string comment '上游公司中文简称',
  s_info_compcode1 string comment '上游公司ID',
  report_period string comment '报告期',
  s_info_amount decimal(20,4) comment '金额',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareaccountsreceivable;
create table if not exists ty_ods.w_ashareaccountsreceivable
(
  object_id string comment '对象ID',
  memo string comment '备注',
  s_info_compcode string comment '公司ID',
  report_period string comment '报告期',
  debtor_name string comment '债务人名称',
  arrears decimal(20,4) comment '金额',
  rate decimal(20,4) comment '比例(%)',
  currency_code string comment '货币代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareadministration;
create table if not exists ty_ods.w_ashareadministration
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  s_info_dimension string comment '维度',
  s_info_dimension1 string comment '子维度',
  s_info_manager_name string comment '姓名',
  s_info_manager_startdate string comment '任职日期',
  s_info_manager_post string comment '职务',
  s_info_manid string comment '人物id',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareadvancepayment;
create table if not exists ty_ods.w_ashareadvancepayment
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareadvancereceipt;
create table if not exists ty_ods.w_ashareadvancereceipt
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareaftereodprices;
create table if not exists ty_ods.w_ashareaftereodprices
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '日期',
  crncy_code string comment '货币代码',
  s_dq_after_price decimal(20,4) comment '盘后固定价格(元)',
  s_dq_volume decimal(20,4) comment '成交量(手)',
  s_dq_amount decimal(20,4) comment '成交金额(千元)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareagingstructure;
create table if not exists ty_ods.w_ashareagingstructure
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  statement_type_name string comment '报表类型名称',
  memo string comment '备注',
  aging string comment '帐龄',
  currency_code string comment '货币代码',
  amount_money decimal(20,4) comment '金额',
  rate decimal(20,4) comment '比例(%)',
  bad_debt_preparation decimal(20,4) comment '坏帐准备',
  report_period string comment '报告期',
  min_aging decimal(20,4) comment '最小账龄(年)',
  max_aging decimal(20,4) comment '最大账龄(年)',
  classification_criteria string comment '分类标准',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareauditdescription;
create table if not exists ty_ods.w_ashareauditdescription
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  report_period string comment '报告期',
  audit_project_type bigint comment '审计项目类型代码',
  audit_matters_type string comment '关键审计事项类型',
  audit_matters_num bigint comment '关键审计事项序号',
  matter_description string comment '事项描述',
  audit_response string comment '审计应对',
  ann_dt string comment '公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareauditopinion;
create table if not exists ty_ods.w_ashareauditopinion
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_dt string comment '公告日期',
  report_period string comment '报告期',
  s_stmnote_audit_category bigint comment '审计结果类别代码',
  s_stmnote_audit_agency string comment '会计师事务所',
  s_stmnote_audit_cpa string comment '签字会计师',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharebeguaranteed;
create table if not exists ty_ods.w_asharebeguaranteed
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  s_info_dimension string comment '维度',
  s_info_dimension1 string comment '子维度',
  s_info_comp_name string comment '担保公司名称',
  s_info_comp_sname string comment '担保公司中文简称',
  s_info_compcode1 string comment '担保公司ID',
  report_period string comment '报告期',
  s_info_amount decimal(20,4) comment '金额',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareblocktrade;
create table if not exists ty_ods.w_ashareblocktrade
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '交易日期',
  s_block_price decimal(20,4) comment '成交价（元）',
  s_block_volume decimal(20,4) comment '成交量（万股）',
  s_block_amount decimal(20,4) comment '成交金额（万元）',
  crncy_code string comment '货币代码',
  s_block_buyername string comment '买方营业部名称',
  s_block_sellername string comment '卖方营业部名称',
  s_block_frequency decimal(20,4) comment '笔数',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharebuyresalefinassets;
create table if not exists ty_ods.w_asharebuyresalefinassets
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharecapitaloperation;
create table if not exists ty_ods.w_asharecapitaloperation
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_dt string comment '公告日期',
  s_capitaloperation_enddate string comment '截止日期',
  s_capitaloperation_share decimal(20,4) comment '股票数量',
  s_capitaloperation_amount decimal(20,4) comment '投资金额',
  crncy_code string comment '货币代码',
  s_capitaloperation_companyname string comment '参股公司名称',
  s_capitaloperat_compwindcode string comment '参股公司Wind代码',
  s_end_bal decimal(20,4) comment '期末账面值',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharecapitalsurplus;
create table if not exists ty_ods.w_asharecapitalsurplus
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharecashadepositswithcb;
create table if not exists ty_ods.w_asharecashadepositswithcb
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharecirculatingholders;
create table if not exists ty_ods.w_asharecirculatingholders
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  s_info_dimension string comment '维度',
  s_info_dimension1 string comment '子维度',
  s_info_comp_name string comment '股东公司名称',
  s_info_comp_sname string comment '股东公司中文简称',
  s_info_compcode1 string comment '股东公司ID',
  s_holder_enddate string comment '报告期',
  s_holder_pct decimal(20,4) comment '持股比例',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharecocapitaloperation;
create table if not exists ty_ods.w_asharecocapitaloperation
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  s_event_id string comment '事件ID',
  s_event_categorycode bigint comment '事件类型代码',
  ann_date string comment '公告日期',
  s_financing_amount decimal(20,4) comment '融资金额(人民币)',
  s_valuation_amount decimal(20,4) comment '估值金额(人民币)',
  s_pe decimal(20,4) comment '市盈率(PE)',
  s_pb decimal(20,4) comment '市净率(PB)',
  s_ps decimal(20,4) comment '市销率(PS)',
  s_financing_rate decimal(20,4) comment '融资费率',
  s_financing_rt decimal(20,4) comment '融资利率',
  s_financing_amount_us decimal(20,4) comment '融资金额(美元)',
  s_valuation_amount_us decimal(20,4) comment '估值金额(美元)',
  s_event_description string comment '事件说明',
  s_financing_process bigint comment '融资进程',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharecompanyholdshares;
create table if not exists ty_ods.w_asharecompanyholdshares
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_dt string comment '公告日期',
  enddate string comment '截止日期',
  s_capitaloperation_companyname string comment '被参控公司名称',
  s_capitaloperation_companyid string comment '被参控公司ID',
  s_capitaloperation_comainbus string comment '被参控公司主营业务',
  relations_code string comment '关系代码',
  s_capitaloperation_pct decimal(20,4) comment '直接持股比例',
  voting_rights decimal(20,4) comment '表决权比例',
  s_capitaloperation_amount decimal(20,4) comment '投资金额(万元)',
  operationcrncy_code string comment '货币代码',
  s_capitaloperation_coregcap decimal(20,4) comment '被参股公司注册资本(万元)',
  capitalcrncy_code string comment '注册资本货币代码',
  is_consolidate bigint comment '是否合并报表',
  notconsolidate_reason string comment '未纳入合并报表原因',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharecompensationpayable;
create table if not exists ty_ods.w_asharecompensationpayable
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareconceptualplate;
create table if not exists ty_ods.w_ashareconceptualplate
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  s_info_dimension string comment '维度',
  s_info_dimension1 string comment '子维度',
  s_info_comp_name string comment '公司名称',
  s_info_comp_sname string comment '公司中文简称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareconsensusdata;
create table if not exists ty_ods.w_ashareconsensusdata
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  wind_code string comment 'Wind代码',
  est_dt string comment '预测日期',
  est_report_dt string comment '预测报告期',
  num_est_inst bigint comment '预测机构家数',
  eps_avg decimal(20,4) comment '每股收益平均值(元)',
  main_bus_inc_avg decimal(20,4) comment '主营业务收入平均值(万元)',
  net_profit_avg decimal(20,4) comment '净利润平均值(万元)',
  ebit_avg decimal(20,4) comment '息税前利润平均值(万元)',
  ebitda_avg decimal(20,4) comment '息税折旧摊销前利润平均值(万元)',
  eps_median decimal(20,4) comment '每股收益中值(元)',
  main_bus_inc_median decimal(20,4) comment '主营业务收入中值(万元)',
  net_profit_median decimal(20,4) comment '净利润中值(万元)',
  ebit_median decimal(20,4) comment '息税前利润中值(万元)',
  ebitda_median decimal(20,4) comment '息税折旧摊销前利润中值(万元)',
  consen_data_cycle_typ string comment '综合值周期类型',
  eps_dev decimal(20,4) comment '每股收益标准差',
  main_bus_inc_dev decimal(20,4) comment '主营业务收入标准差(万元)',
  net_profit_dev decimal(20,4) comment '净利润标准差(万元)',
  ebit_dev decimal(20,4) comment '息税前利润标准差(万元)',
  ebitda_dev decimal(20,4) comment '息税折旧摊销前利润标准差(万元)',
  eps_max decimal(20,4) comment '每股收益最大值',
  eps_min decimal(20,4) comment '每股收益最小值',
  main_bus_inc_max decimal(20,4) comment '主营业务收入最大值(万元)',
  main_bus_inc_min decimal(20,4) comment '主营业务收入最小值(万元)',
  main_bus_inc_upgrade decimal(20,4) comment '主营业务收入调高家数（与一个月前相比）',
  main_bus_inc_downgrade decimal(20,4) comment '主营业务收入调低家数（与一个月前相比）',
  main_bus_inc_maintain decimal(20,4) comment '主营业务收入维持家数（与一个月前相比）',
  net_profit_max decimal(20,4) comment '净利润最大值（万元)',
  net_profit_min decimal(20,4) comment '净利润最小值（万元)',
  net_profit_upgrade decimal(20,4) comment '净利润调高家数（与一个月前相比）',
  net_profit_downgrade decimal(20,4) comment '净利润调低家数（与一个月前相比）',
  net_profit_maintain decimal(20,4) comment '净利润维持家数（与一个月前相比）',
  s_est_avgcps decimal(20,4) comment '每股现金流平均值',
  s_est_mediancps decimal(20,4) comment '每股现金流中值',
  s_est_stdcps decimal(20,4) comment '每股现金流标准差',
  s_est_maxcps decimal(20,4) comment '每股现金流最大值',
  s_est_mincps decimal(20,4) comment '每股现金流最小值',
  s_est_avgdps decimal(20,4) comment '每股股利平均值',
  s_est_mediandps decimal(20,4) comment '每股股利中值',
  s_est_stddps decimal(20,4) comment '每股股利标准差',
  s_est_maxdps decimal(20,4) comment '每股股利最大值',
  s_est_mindps decimal(20,4) comment '每股股利最小值',
  ebit_max decimal(20,4) comment '息税前利润最大值(万元)',
  ebit_min decimal(20,4) comment '息税前利润最小值(万元)',
  ebitda_max decimal(20,4) comment '息税折旧摊销前利润最大值(万元)',
  ebitda_min decimal(20,4) comment '息税折旧摊销前利润最小值(万元)',
  s_est_avgbps decimal(20,4) comment '每股净资产平均值',
  s_est_medianbps decimal(20,4) comment '每股净资产中值',
  s_est_stdbps decimal(20,4) comment '每股净资产标准差',
  s_est_maxbps decimal(20,4) comment '每股净资产最大值',
  s_est_minbps decimal(20,4) comment '每股净资产最小值',
  s_est_avgebt decimal(20,4) comment '利润总额平均值(万元)',
  s_est_medianebt decimal(20,4) comment '利润总额中值(万元)',
  s_est_stdebt decimal(20,4) comment '利润总额标准差(万元)',
  s_est_maxebt decimal(20,4) comment '利润总额最大值(万元)',
  s_est_minebt decimal(20,4) comment '利润总额最小值(万元)',
  s_est_avgroa decimal(20,4) comment '总资产收益率平均值（%）',
  s_est_medianroa decimal(20,4) comment '总资产收益率中值（%）',
  s_est_stdroa decimal(20,4) comment '总资产收益率标准差（%）',
  s_est_maxroa decimal(20,4) comment '总资产收益率最大值（%）',
  s_est_minroa decimal(20,4) comment '总资产收益率最小值（%）',
  s_est_avgroe decimal(20,4) comment '净资产收益率平均值（%）',
  s_est_medianroe decimal(20,4) comment '净资产收益率中值（%）',
  s_est_stdroe decimal(20,4) comment '净资产收益率标准差（%）',
  s_est_maxroe decimal(20,4) comment '净资产收益率最大值（%）',
  s_est_minroe decimal(20,4) comment '净资产收益率最小值（%）',
  s_est_avgoperatingprofit decimal(20,4) comment '营业利润平均值(万元)',
  s_est_medianoperatingprofit decimal(20,4) comment '营业利润中值(万元)',
  s_est_stdoperatingprofit decimal(20,4) comment '营业利润标准差(万元)',
  s_est_maxoperatingprofit decimal(20,4) comment '营业利润最大值(万元)',
  s_est_minoperatingprofit decimal(20,4) comment '营业利润最小值(万元)',
  s_est_epsinstnum decimal(20,4) comment '每股收益预测家数',
  s_est_mainbusincinstnum decimal(20,4) comment '主营业务收入预测家数',
  s_est_netprofitinstnum decimal(20,4) comment '净利润预测家数',
  s_est_cpsinstnum decimal(20,4) comment '每股现金流预测家数',
  s_est_dpsinstnum decimal(20,4) comment '每股股利预测家数',
  s_est_ebitinstnum decimal(20,4) comment '息税前利润预测家数',
  s_est_ebitdainstnum decimal(20,4) comment '息税折旧摊销前利润预测家数',
  s_est_bpsinstnum decimal(20,4) comment '每股净资产预测家数',
  s_est_ebtinstnum decimal(20,4) comment '利润总额预测家数',
  s_est_roainstnum decimal(20,4) comment '总资产收益率预测家数',
  s_est_roeinstnum decimal(20,4) comment '净资产资产收益率预测家数',
  s_est_oprofitinstnum decimal(20,4) comment '营业利润预测家数',
  s_est_avgoc decimal(20,4) comment '营业成本及附加平均值(万元)',
  s_est_mediaoc decimal(20,4) comment '营业成本及附加中值(万元)',
  s_est_stoc decimal(20,4) comment '营业成本及附加标准差(万元)',
  s_est_maxoc decimal(20,4) comment '营业成本及附加最大值(万元)',
  s_est_minoc decimal(20,4) comment '营业成本及附加最小值(万元)',
  s_est_ocinstnum decimal(20,4) comment '营业成本及附加预测家数',
  s_est_baseshare decimal(20,4) comment '预测基准股本综合值',
  s_est_yeartype string comment '预测年度类型',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharecorporatefinance;
create table if not exists ty_ods.w_asharecorporatefinance
(
  object_id string comment '对象ID',
  event_id string comment '事件ID',
  s_info_windcode string comment 'Wind代码',
  ann_date string comment '公告日期',
  buy_company_name string comment '实际购买公司名称',
  s_relation_typcode bigint comment '实际购买公司和上市公司关系类型代码',
  s_issuer_name string comment '产品发行方公布名称',
  s_issuer_id string comment '产品发行方ID',
  s_fullname string comment '理财产品名称',
  s_info_code string comment '[内部]理财产品ID',
  s_underlying bigint comment '理财类型代码',
  s_subscription_date string comment '认购日期',
  s_subscription_amount decimal(20,4) comment '认购金额',
  s_crncy_code string comment '货币代码',
  s_incomestartdate string comment '产品起息日期',
  s_incomeenddate string comment '产品到期日期',
  s_commission string comment '产品期限',
  s_expyidld_min decimal(20,4) comment '预计最低收益率',
  s_expyield_max decimal(20,4) comment '预计最高收益率',
  s_sources_funds_code bigint comment '资金来源类型代码',
  is_connection_relation bigint comment '买方与卖方是否有关联关系',
  s_net_assets_ratio decimal(20,4) comment '本次出资占公司最近一期审计净资产比例',
  s_summary string comment '理财产品摘要',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharecreditorrights;
create table if not exists ty_ods.w_asharecreditorrights
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  s_info_dimension string comment '维度',
  s_info_dimension1 string comment '子维度',
  s_info_comp_name string comment '债务公司名称',
  s_info_comp_sname string comment '债务公司中文简称',
  s_info_compcode1 string comment '债务公司公司ID',
  report_period string comment '报告期',
  s_info_amount decimal(20,4) comment '金额',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharecustomer;
create table if not exists ty_ods.w_asharecustomer
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  s_info_dimension string comment '维度',
  s_info_dimension1 string comment '子维度',
  s_info_comp_name string comment '下游公司名称',
  s_info_comp_sname string comment '下游公司中文简称',
  s_info_compcode1 string comment '下游公司ID',
  report_period string comment '报告期',
  s_info_amount decimal(20,4) comment '金额',
  s_info_discloser string comment '披露公司ID',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharedefendant;
create table if not exists ty_ods.w_asharedefendant
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  s_info_dimension string comment '维度',
  s_info_dimension1 string comment '子维度',
  s_info_comp_name string comment '诉讼公司名称',
  s_info_comp_sname string comment '诉讼公司中文简称',
  s_info_compcode1 string comment '诉讼公司ID',
  s_info_case_type string comment '案件类型',
  ann_date string comment '公告日期',
  litigation_events_id string comment '诉讼事件ID',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharedeferredtaxassets;
create table if not exists ty_ods.w_asharedeferredtaxassets
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharedeferredtaxliability;
create table if not exists ty_ods.w_asharedeferredtaxliability
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharedevaluationpreparation;
create table if not exists ty_ods.w_asharedevaluationpreparation
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  s_development_cost decimal(15,2) comment '开发成本',
  s_low_value_consumables decimal(15,2) comment '低值易耗品',
  s_finished_product decimal(15,2) comment '产成品',
  s_office_equipment decimal(15,2) comment '办公及其他设备',
  s_other_equipment decimal(15,2) comment '其他设备',
  s_land_use_right decimal(15,2) comment '土地使用权',
  s_materials_in_transit decimal(15,2) comment '在途物资',
  s_in_product decimal(15,2) comment '在产品',
  s_developing_products decimal(15,2) comment '开发产品',
  s_part_prepared_products decimal(15,2) comment '自制半成品',
  s_right_use_housing decimal(15,2) comment '职工住房使用权',
  s_packaging decimal(15,2) comment '包装物',
  statement_type string comment '报表类型',
  statement_type_code bigint comment '报表类型代码',
  s_bad_debt_tot decimal(20,4) comment '坏账准备合计',
  s_acct_rcv decimal(20,4) comment '应收帐款',
  s_oth_rcv decimal(20,4) comment '其他应收款',
  s_short_term_inv_fall decimal(20,4) comment '短期投资跌价准备合计',
  s_stock_investment decimal(20,4) comment '股票投资',
  s_bond_investment decimal(20,4) comment '债券投资',
  s_stock_price_drop1 decimal(20,4) comment '存货跌价准备合计',
  s_inventory_goods decimal(20,4) comment '库存商品',
  s_raw_material decimal(20,4) comment '原材料',
  s_long_inv_depre_res_tot decimal(20,4) comment '长期投资减值准备合计',
  s_equity_investment decimal(20,4) comment '长期股权投资减值准备',
  s_long_debt_investments decimal(20,4) comment '长期债权投资',
  s_fixed_asset_impairment decimal(20,4) comment '固定资产减值准备',
  s_building1 decimal(20,4) comment '房屋、建筑物',
  s_machinery decimal(20,4) comment '机器设备',
  s_intangible_assets_devalue decimal(20,4) comment '无形资产减值准备',
  s_patent_right decimal(20,4) comment '专利权',
  s_trademark_right decimal(20,4) comment '商标权',
  s_con_project_devalue decimal(20,4) comment '在建工程减值准备',
  s_loan_mandate_devalue decimal(20,4) comment '委托贷款减值准备',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  s_special_equipment decimal(20,4) comment '专用设备',
  s_conveyance decimal(20,4) comment '运输工具',
  s_communication decimal(20,4) comment '通讯设备',
  s_electronic decimal(20,4) comment '电子设备',
  s_stock_price_drop decimal(20,4) comment '自营证券跌价准备',
  s_pre_bad_loans decimal(20,4) comment '贷款呆帐准备',
  s_turnover decimal(20,4) comment '周转材料',
  s_expend_assets decimal(20,4) comment '消耗性生物资产',
  s_sell_financial_assets decimal(20,4) comment '可供出售金融资产减值准备',
  s_hold_expiry_investment decimal(20,4) comment '持有至到期投资减值准备',
  s_building decimal(20,4) comment '房屋、建筑物',
  s_investment_real_estate decimal(20,4) comment '投资性房地产减值准备',
  s_land_use_right1 decimal(20,4) comment '土地使用权',
  s_material_devalue decimal(20,4) comment '工程物资减值准备',
  s_biological_assets_devalue decimal(20,4) comment '生产性生物资产减值准备',
  s_biological_assets_devalue1 decimal(20,4) comment '成熟生产性生物资产减值准备',
  s_oil_gas_assets_devalue decimal(20,4) comment '油气资产减值准备',
  s_goodwill_devalue decimal(20,4) comment '商誉减值准备',
  s_other decimal(20,4) comment '其他',
  s_loan_loss_preparation decimal(20,4) comment '贷款损失准备',
  s_interbank_payments_devalue decimal(20,4) comment '存放同业款项减值准备',
  s_demolition_capital_devalue decimal(20,4) comment '拆出资金减值准备',
  s_debt_set_devalue decimal(20,4) comment '抵债资产减值准备',
  s_back_sale_financial_assets decimal(20,4) comment '买入返售金融资产减值准备',
  s_noble_metal_depreciation decimal(20,4) comment '贵金属跌价准备',
  s_treated_assets_devalue decimal(20,4) comment '待处理资产减值准备',
  s_interest_receivable_devalue decimal(20,4) comment '应收利息减值准备',
  s_other_assets_devalue decimal(20,4) comment '其他资产减值准备',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharedirector;
create table if not exists ty_ods.w_asharedirector
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  s_info_dimension string comment '维度',
  s_info_dimension1 string comment '子维度',
  s_info_manager_name string comment '姓名',
  s_info_manager_startdate string comment '任职日期',
  s_info_manager_post string comment '职务',
  s_info_manid string comment '人物id',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharedivisionelimination;
create table if not exists ty_ods.w_asharedivisionelimination
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_dq_resumpdate string comment '实施复牌日',
  s_dq_adjfactor decimal(20,4) comment '复权因子',
  s_dq_resump_preclose decimal(20,4) comment '复牌日昨收盘价',
  s_dq_preclose decimal(20,4) comment '昨收盘价(流通股除权)',
  s_dq_factor decimal(20,8) comment '对价因子',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareembvalueassessresults;
create table if not exists ty_ods.w_ashareembvalueassessresults
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareembvaluechangeanal;
create table if not exists ty_ods.w_ashareembvaluechangeanal
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareenergyindexadj;
create table if not exists ty_ods.w_ashareenergyindexadj
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '日期',
  boll_mid bigint comment 'BOLL布林带MID(26日,2)',
  boll_upper bigint comment 'BOLL布林带UPPER(26日,2)',
  boll_lower bigint comment 'BOLL布林带LOWER(26日,2)',
  bbiboll_bbi bigint comment 'BBIBOLL多空布林线BBI(10日,3)',
  bbiboll_upr bigint comment 'BBIBOLL多空布林线UPR(10日,3)',
  bbiboll_dwn bigint comment 'BBIBOLL多空布林线DWN(10日,3)',
  cdp bigint comment 'CDP逆势操作CDP',
  cdp_ah bigint comment 'CDP逆势操作AH',
  cdp_al bigint comment 'CDP逆势操作AL',
  cdp_nh bigint comment 'CDP逆势操作NH',
  cdp_nl bigint comment 'CDP逆势操作NL',
  env_upper bigint comment 'ENV指标UPPER(14日)',
  env_lower bigint comment 'ENV指标LOWER(14日)',
  mike_wr bigint comment 'MIKE麦克指标WR(12日)',
  mike_mr bigint comment 'MIKE麦克指标MR(12日)',
  mike_sr bigint comment 'MIKE麦克指标SR(12日)',
  mike_ws bigint comment 'MIKE麦克指标WS(12日)',
  mike_ms bigint comment 'MIKE麦克指标MS(12日)',
  mike_ss bigint comment 'MIKE麦克指标SS(12日)',
  mfi bigint comment 'MFI资金流向指标(14日)',
  obv bigint comment 'OBV能量潮OBV',
  obv_obv bigint comment 'OBV能量潮修正OBV',
  pvt bigint comment 'PVT量价趋势指标',
  wvad_wvad bigint comment 'WVAD威廉变异离散量WVAD(24,6日)',
  wvad_mawvad bigint comment 'WVAD威廉变异离散量MAWVAD(24,6日)',
  arbr_ar bigint comment 'ARBR人气意愿指标AR(26日)',
  arbr_br bigint comment 'ARBR人气意愿指标BR(26日)',
  cr bigint comment 'CR能量指标(26日)',
  psy bigint comment 'PSY心理指标PSY(12,6日)',
  psyma bigint comment 'PSY心理指标PSYMA(12,6日)',
  wad bigint comment 'WAD威廉聚散指标WAD(30日)',
  mawad bigint comment 'WAD威廉聚散指标MAWAD(30日)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareenergyindex;
create table if not exists ty_ods.w_ashareenergyindex
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '日期',
  boll_mid bigint comment 'BOLL布林带MID(26日,2)',
  boll_upper bigint comment 'BOLL布林带UPPER(26日,2)',
  boll_lower bigint comment 'BOLL布林带LOWER(26日,2)',
  bbiboll_bbi bigint comment 'BBIBOLL多空布林线BBI(10日,3)',
  bbiboll_upr bigint comment 'BBIBOLL多空布林线UPR(10日,3)',
  bbiboll_dwn bigint comment 'BBIBOLL多空布林线DWN(10日,3)',
  cdp bigint comment 'CDP逆势操作CDP',
  cdp_ah bigint comment 'CDP逆势操作AH',
  cdp_al bigint comment 'CDP逆势操作AL',
  cdp_nh bigint comment 'CDP逆势操作NH',
  cdp_nl bigint comment 'CDP逆势操作NL',
  env_upper bigint comment 'ENV指标UPPER(14日)',
  env_lower bigint comment 'ENV指标LOWER(14日)',
  mike_wr bigint comment 'MIKE麦克指标WR(12日)',
  mike_mr bigint comment 'MIKE麦克指标MR(12日)',
  mike_sr bigint comment 'MIKE麦克指标SR(12日)',
  mike_ws bigint comment 'MIKE麦克指标WS(12日)',
  mike_ms bigint comment 'MIKE麦克指标MS(12日)',
  mike_ss bigint comment 'MIKE麦克指标SS(12日)',
  mfi bigint comment 'MFI资金流向指标(14日)',
  obv bigint comment 'OBV能量潮OBV',
  obv_obv bigint comment 'OBV能量潮修正OBV',
  pvt bigint comment 'PVT量价趋势指标',
  wvad_wvad bigint comment 'WVAD威廉变异离散量WVAD(24,6日)',
  wvad_mawvad bigint comment 'WVAD威廉变异离散量MAWVAD(24,6日)',
  arbr_ar bigint comment 'ARBR人气意愿指标AR(26日)',
  arbr_br bigint comment 'ARBR人气意愿指标BR(26日)',
  cr bigint comment 'CR能量指标(26日)',
  psy bigint comment 'PSY心理指标PSY(12,6日)',
  psyma bigint comment 'PSY心理指标PSYMA(12,6日)',
  wad bigint comment 'WAD威廉聚散指标WAD(30日)',
  mawad bigint comment 'WAD威廉聚散指标MAWAD(30日)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareengineering;
create table if not exists ty_ods.w_ashareengineering
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareequitydivision;
create table if not exists ty_ods.w_ashareequitydivision
(
  object_id string comment '对象ID',
  comp_id string comment '公司id',
  windcode string comment 'Wind代码',
  ann_dt string comment '公告日期',
  ann_appdt string comment '获准公告日期',
  pro_sche string comment '方案进度',
  ntshareholders_prop decimal(20,4) comment '非流通股东持股比例(%)',
  sponsor string comment '保荐机构',
  summary_ed string comment '股权分置改革对价方案摘要',
  preplandate string comment '董事会预案公告日',
  recorddate string comment '股东大会股权登记日',
  voting_startdate string comment '董事征集投票权起始日',
  voting_enddate string comment '董事征集投票权截止日',
  meetreg_startdate string comment '现场股东大会登记起始日',
  meetreg_enddate string comment '现场股东大会登记截止日',
  netvoting_startdate string comment '网络投票起始日',
  netvoting_enddate string comment '网络投票截止日',
  meeting_startdate string comment '股东大会召开日',
  meeting_enddate string comment '股东大会公告日',
  shareno_ten decimal(24,8) comment '每10股支付股数(对价)',
  cashno_ten decimal(24,8) comment '每10股支付现金数(对价)',
  act_shares_ten decimal(24,8) comment '流通股东每10股实际获得股数',
  act_cash_ten decimal(24,8) comment '流通股东每10股实际获得现金数',
  trans_ten decimal(24,8) comment '上市公司每10股送转股数',
  ed_anndt string comment '股权分置实施股权公告日',
  ed_regdt string comment '股权分置实施股权登记日',
  pay_listeddate string comment '对价支付股票上市日',
  pay_cash_date string comment '对价支付现金支付日',
  sasac_appdate string comment '国资委批准日期',
  comdep_appdate string comment '商务部批准日期',
  is_ed_ex bigint comment '股权分置实施是否除权',
  nts_lockcom string comment '非流通股持股锁定承诺',
  ed_procode string comment '股权分置方案类型代码',
  is_newpro bigint comment '是否最新方案',
  summary_cs string comment '对价方案摘要',
  description_ch_cs string comment '对价方案变动说明',
  plan_resdate string comment '预案阶段复牌日',
  put_resdate string comment '实施复牌日',
  vote_res_date string comment '表决到实施阶段复牌日',
  ntsholders_shrink decimal(20,4) comment '非流通股东每10股缩股',
  tsholders_sub_war decimal(20,4) comment '流通股东每10股获得认购权证数',
  warrant_prodes string comment '权证方案说明',
  holdings_com string comment '增持承诺',
  fut_div_com string comment '未来分红承诺',
  add_com string comment '追加对价承诺',
  eqinc_plan string comment '股权激励方案',
  dividend_ten decimal(20,4) comment '上市公司每10股派息',
  is_based_tracap bigint comment '对价是否基于送转后股本',
  send_rate decimal(20,4) comment '送出率(%)',
  tsholders_put_war decimal(20,4) comment '流通股东每10股获得认沽权证数',
  comtype string comment '承诺类型',
  votesus_startdate string comment '股改投票停牌起始日期',
  inj_asset_com string comment '注入资产承诺',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareesopdescription;
create table if not exists ty_ods.w_ashareesopdescription
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  bm_prepro_ann_dt string comment '董事会预案公告日',
  sholder_meeting_ann_dt string comment '股东大会公告日',
  initial_capital decimal(20,4) comment '初始资金规模（万元）',
  capital_resource_code bigint comment '资金来源代码',
  estimated_volumn decimal(20,4) comment '预计股票数量(万)',
  ratio_to_totalshares decimal(20,4) comment '预计占公司总股本比例(%)',
  sholders_no bigint comment '持有人数',
  sholders_proportion decimal(20,4) comment '持有人占公司员工比例',
  duration bigint comment '存续期(月)',
  lockup_period_m bigint comment '锁定期限',
  empl_subs_amt decimal(20,4) comment '员工认购金额(万)',
  empl_subs_proportion decimal(20,4) comment '员工认购比例(%)',
  senmngr_subs_no bigint comment '高管认购人数',
  senmngr_subs_amt decimal(20,4) comment '高管认购金额(万元)',
  senmngr_subs_proportion decimal(20,4) comment '高管认购比例（%）',
  estimated_price decimal(20,4) comment '标的股票预估价格',
  shares_resource_code bigint comment '股票来源代码',
  is_self_manage bigint comment '是否自行管理',
  corr_proname string comment '持股计划对应产品名称',
  ratio_ownfunds decimal(20,4) comment '员工自有资金占比',
  initial_leverage decimal(20,4) comment '初始杠杆',
  sholders_loan decimal(20,4) comment '股东借款金额',
  sholders_loanratio decimal(20,4) comment '股东借款比例',
  act_fundsize decimal(20,4) comment '实际资金规模',
  act_sharesno decimal(20,4) comment '实际股票数量',
  act_sharesprice decimal(20,4) comment '实际股票价格',
  act_cap_ratio decimal(20,4) comment '实际占公司总股本比例',
  sharehold_findt string comment '持股完成日',
  event_id string comment '事件ID',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareesoptradinginfo;
create table if not exists ty_ods.w_ashareesoptradinginfo
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  esop_windcode string comment '员工持股计划证券ID',
  end_dt string comment '截止日期',
  ann_dt string comment '公告日期',
  trade_avg_price decimal(20,4) comment '成交均价',
  trading_volume decimal(20,4) comment '成交数量',
  ratio_to_totalshares decimal(20,4) comment '占公司总股本比例',
  lockup_period bigint comment '锁定期限',
  event_id string comment '事件ID',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareeventdateinformation;
create table if not exists ty_ods.w_ashareeventdateinformation
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  event_type bigint comment '事件类型编号',
  occurrence_date string comment '发生日期',
  disclosure_date string comment '披露日期',
  memo string comment '内容说明',
  date_created string comment '创建日期',
  s_info_code string comment '交易代码',
  s_info_name string comment '证券简称',
  type_code string comment '证券类型代码',
  language1 string comment '语言',
  eqy_record_dt string comment '权益登记日',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharefairvaluechange;
create table if not exists ty_ods.w_asharefairvaluechange
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharefinancialexpense;
create table if not exists ty_ods.w_asharefinancialexpense
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_dt string comment '公告日期',
  report_period string comment '报告期',
  statement_typecode bigint comment '报表类型代码',
  s_stmnote_intexp decimal(20,4) comment '利息支出(元)',
  s_stmnote_intinc decimal(20,4) comment '减：利息收入(元)',
  s_stmnote_exch decimal(20,4) comment '汇兑损益(元)',
  s_stmnote_fee decimal(20,4) comment '手续费(元)',
  s_stmnote_others decimal(20,4) comment '其他(元)',
  s_stmnote_finexp decimal(20,4) comment '合计(元)',
  s_stmnote_finexp_1 decimal(20,4) comment '减：利息资本化金额(元)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharefinancialexp;
create table if not exists ty_ods.w_asharefinancialexp
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharefinancialsecurities;
create table if not exists ty_ods.w_asharefinancialsecurities
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharefinsegmentinfo;
create table if not exists ty_ods.w_asharefinsegmentinfo
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  report_period string comment '报告期',
  statement_type bigint comment '报表类型代码',
  class_code bigint comment '分部类别代码',
  subject_code bigint comment '科目代码',
  item_amount decimal(20,4) comment '金额',
  unit string comment '单位',
  crncy_code string comment '货币代码',
  subject_name_ann string comment '[内部]公布科目名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharefixedassets;
create table if not exists ty_ods.w_asharefixedassets
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharefreefloatcalendar;
create table if not exists ty_ods.w_asharefreefloatcalendar
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_info_listdate string comment '限售股上市日期',
  ann_dt string comment '公告日期',
  s_share_lst decimal(20,4) comment '上市股份数量（万股）',
  s_share_nonlst decimal(20,4) comment '未上市股份数量（万股）',
  s_share_unrestricted decimal(20,4) comment '无限售条件股份数量（万股）',
  s_share_lsttypecode bigint comment '上市股份类型代码',
  s_share_lst_is_ann string comment '上市数量是否公布值',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharefreefloat;
create table if not exists ty_ods.w_asharefreefloat
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  change_dt string comment '变动日期(除权日)',
  s_share_freeshares decimal(20,4) comment '自由流通股本(万股)',
  change_dt1 string comment '变动日期(上市日)',
  ann_dt string comment '公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharefundusing;
create table if not exists ty_ods.w_asharefundusing
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  financing_events_type string comment '融资事件类型',
  money_raised_amount decimal(20,4) comment '货币募集金额',
  non_currency_raise_amount decimal(20,4) comment '非货币募集金额',
  issue_cost decimal(20,4) comment '发行费用',
  actual_fundraising_amount decimal(20,4) comment '实际募资金额',
  currency_code string comment '货币代码',
  ann_date string comment '公告日期',
  item_number string comment '项目序号',
  investment_projects string comment '投资项目',
  plan_invest decimal(20,4) comment '项目总计划投入资金',
  issuer_plan_invest decimal(20,4) comment '募资主体计划投入资金',
  issuer_plan_funds_investment decimal(20,4) comment '募资主体计划投入募集资金',
  funds_has_invested decimal(20,4) comment '已投入募集资金',
  is_change bigint comment '是否变更',
  new_ann_date string comment '最新公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharegoodwilldevalue;
create table if not exists ty_ods.w_asharegoodwilldevalue
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharegoodwill;
create table if not exists ty_ods.w_asharegoodwill
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharegovernmentgrants;
create table if not exists ty_ods.w_asharegovernmentgrants
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  report_period string comment '报告期',
  item_name string comment '项目',
  amount_current_issue decimal(20,4) comment '本期发生额',
  amount_previous_period decimal(20,4) comment '上期发生额',
  memo string comment '说明',
  currency_code string comment '货币代码',
  ann_date string comment '公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharegovernmentsubsidydefin;
create table if not exists ty_ods.w_asharegovernmentsubsidydefin
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharegroupinformation;
create table if not exists ty_ods.w_asharegroupinformation
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  s_info_dimension string comment '维度',
  s_info_dimension1 string comment '子维度',
  s_info_comp_name string comment '集团公司名称',
  s_info_comp_sname string comment '集团公司中文简称',
  s_info_compcode1 string comment '集团公司ID',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareguaranteerelationship;
create table if not exists ty_ods.w_ashareguaranteerelationship
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  s_info_dimension string comment '维度',
  s_info_dimension1 string comment '子维度',
  s_info_comp_name string comment '被担保公司名称',
  s_info_comp_sname string comment '被担保公司中文简称',
  s_info_compcode1 string comment '被担保公司ID',
  report_period string comment '报告期',
  s_info_amount decimal(20,4) comment '金额',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareguarantee;
create table if not exists ty_ods.w_ashareguarantee
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_info_compcode string comment '公司ID',
  relation string comment '担保方与披露方关系',
  guarantor string comment '担保方公司名称',
  relation2 string comment '被担保方与披露方关系',
  securedparty string comment '被担保方公司名称',
  method string comment '担保方式',
  amount decimal(20,4) comment '担保金额(元)',
  crncy_code string comment '币种',
  term decimal(20,4) comment '担保期限(年)',
  start_dt string comment '担保起始日期',
  end_dt string comment '担保终止日期',
  is_complete bigint comment '是否履行完毕',
  is_related bigint comment '是否关联交易',
  trade_dt string comment '交易日期',
  report_period string comment '报告期',
  is_overdue bigint comment '担保是否逾期',
  overdue_amount decimal(20,4) comment '担保逾期金额(元)',
  is_counterguarantee bigint comment '是否存在反担保',
  ann_dt string comment '公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareguaranteestatistics;
create table if not exists ty_ods.w_ashareguaranteestatistics
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  total_amount_guarantee decimal(20,4) comment '担保发生额合计',
  guarantee_balance_total decimal(20,4) comment '担保余额合计',
  amount_of_guarantee decimal(20,4) comment '担保总额',
  holding_total_amount_guarantee decimal(20,4) comment '对控股子公司担保发生额合计',
  violation_amount_guarantee decimal(20,4) comment '违规担保总额',
  amount_of_guarantee_rate decimal(20,4) comment '担保总额占净资产比例',
  deadline string comment '截止日期',
  ann_date string comment '公告日期',
  currency_code string comment '货币代码',
  holding_total decimal(20,4) comment '对控股子公司担保余额合计',
  controlling_total decimal(20,4) comment '为控股股东及其他关联方提供担保金额',
  total_amount_guarantee1 decimal(20,4) comment '为高负债对象提供担保金额',
  is_more_than_net_assets bigint comment '担保总额是否超过净资产50%',
  net_assets_rate decimal(20,4) comment '担保总额占净资产比例(%)(计算值)',
  more_than_net_assets_amount decimal(20,4) comment '担保总额超过净资产50%部分的金额',
  holding_amount_of_guarantee decimal(20,4) comment '对控股子公司担保额度合计',
  external_guarantee decimal(20,4) comment '对外担保额度合计',
  amount_of_guarantee_total decimal(20,4) comment '担保额度合计',
  net_assets_rate2 decimal(20,4) comment '担保额度占净资产比例',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareholdernumber;
create table if not exists ty_ods.w_ashareholdernumber
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_dt string comment '公告日期',
  s_holder_enddate string comment '截止日期',
  s_holder_num decimal(20,4) comment 'A股股东户数',
  s_holder_total_num decimal(20,4) comment '股东总户数',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareholdersmeeting;
create table if not exists ty_ods.w_ashareholdersmeeting
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_dt string comment '公告日期',
  meeting_dt string comment '会议日期',
  meeting_type string comment '会议类型',
  votingcode bigint comment '投票通道代码',
  smtgrecdate string comment '股东大会股权登记日',
  spotmtgstartdate string comment '会议登记起始日',
  spotmtgenddate string comment '会议登记截止日',
  is_intnet string comment '是否可以网络投票',
  intnetcode string comment '网络投票代码',
  intnetname string comment '网络投票简称',
  meeting_content string comment '会议内容',
  change_his string comment '变更历史',
  meetevent_id string comment '会议事件ID',
  is_new bigint comment '最新标志',
  intnet_startdate string comment '互联网投票起始日',
  intnet_enddate string comment '互联网投票终止日',
  meeting_time string comment '会议召开时间',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
 COMMENT '中国A股召开股东大会'
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareholdersmeetingvotes;
create table if not exists ty_ods.w_ashareholdersmeetingvotes
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'WIND代码',
  s_info_compcode string comment '公司ID',
  ann_dt string comment '公告日期',
  meeting_dt string comment '会议日期',
  motion_title string comment '议案标题',
  is_classified_vote bigint comment '是否需要分类表决',
  favor_share decimal(20,4) comment '赞成股数',
  favor_share_radio decimal(20,4) comment '赞成股数比重(%)',
  oppose_share decimal(20,4) comment '反对股数',
  oppose_share_radio decimal(20,4) comment '反对股数比重(%)',
  abstained_share decimal(20,4) comment '弃权股数',
  abstained_share_radio decimal(20,4) comment '弃权股数比重(%)',
  non_tradable_favor_share decimal(20,4) comment '非流通股(限售流通股)赞成股数',
  non_tradable_oppose_share decimal(20,4) comment '非流通股(限售流通股)反对股数',
  non_tradable_abstain_share decimal(20,4) comment '非流通股(限售流通股)弃权股数',
  tradable_favor_share decimal(20,4) comment '流通股赞成股数',
  tradable_favor_share_radio decimal(20,4) comment '流通股赞成股数比重(%)',
  tradable_oppose_share decimal(20,4) comment '流通股反对股数',
  tradable_oppose_share_radio decimal(20,4) comment '流通股反对股数比重(%)',
  tradable_abstain_share decimal(20,4) comment '流通股弃权股数',
  tradable_abstain_share_radio decimal(20,4) comment '流通股弃权股数比重(%)',
  is_passed bigint comment '是否通过',
  is_shareholder_avoid bigint comment '关联股东是否回避',
  avoid_share decimal(20,4) comment '回避股数',
  avoid_share_radio decimal(20,4) comment '回避股数比重(%)',
  motion_type string comment '议案类型',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareholdingoperate;
create table if not exists ty_ods.w_ashareholdingoperate
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  ann_dt string comment '公告日期',
  report_period string comment '截止日期',
  s_capitaloperation_companyname string comment '被参控公司名称',
  s_tot_assets decimal(24,8) comment '资产规模',
  s_net_profit decimal(24,8) comment '净利润',
  crncy_code string comment '货币代码',
  s_net_assets decimal(24,8) comment '净资产',
  s_tot_liab decimal(24,8) comment '负债总额',
  s_oper_rev decimal(24,8) comment '营业收入',
  s_tot_profit decimal(24,8) comment '利润总额',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareillegality;
create table if not exists ty_ods.w_ashareillegality
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_info_compcode string comment '公司ID',
  ann_dt string comment '公告日期',
  illeg_type string comment '违规类型',
  subject_type bigint comment '主体类别代码',
  subject string comment '违规主体',
  relation_type bigint comment '与上市公司的关系',
  behavior string comment '违规行为',
  disposal_dt string comment '处罚日期',
  disposal_type string comment '处分类型',
  method string comment '处分措施',
  processor string comment '处理人',
  amount decimal(20,4) comment '处罚金额(元)',
  ban_year decimal(20,4) comment '市场禁入期限(年)',
  ref_rule string comment '相关法规',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareimpairlossassets;
create table if not exists ty_ods.w_ashareimpairlossassets
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareincdescription;
create table if not exists ty_ods.w_ashareincdescription
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_inc_sequence string comment '序号',
  s_inc_subject bigint comment '激励标的',
  s_inc_type bigint comment '激励方式',
  s_inc_quantity decimal(20,4) comment '激励总数(万股/万份)',
  s_inc_firstinc string comment '起始日',
  s_inc_endinc string comment '到期日',
  s_inc_initexecpri decimal(20,4) comment '期权初始行权价格(股票转让价格)',
  s_inc_expirydate decimal(20,4) comment '有效期',
  ann_dt string comment '公告日期',
  s_inc_programdescript string comment '方案说明',
  s_inc_incentsharesaledescript string comment '激励股票出售说明',
  s_inc_incentcondition string comment '激励授予条件',
  s_inc_optexespecialcondition string comment '期权行权特别条件',
  progress string comment '方案进度',
  price_description string comment '价格说明',
  inc_numbers_rate decimal(20,4) comment '激励数量占当前总股本比例(%)',
  preplan_ann_date string comment '预案公告日',
  gm_date string comment '股东大会公告日',
  implement_date string comment '首次实施公告日',
  inc_fund_description string comment '激励基金说明',
  interval_months decimal(20,4) comment '授权日与首次可行权日间隔时间(月)',
  eqinc_plan_event_id string comment '股权激励事件ID',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareincexecqtypri;
create table if not exists ty_ods.w_ashareincexecqtypri
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_inc_sequence string comment '序号',
  s_inc_name string comment '姓名',
  s_inc_execqty decimal(20,4) comment '行权数量(万份)',
  s_inc_execpri decimal(20,4) comment '行权价格',
  s_inc_execdate string comment '行权日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareincexercisepct;
create table if not exists ty_ods.w_ashareincexercisepct
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_inc_sequence string comment '序号',
  s_inc_execbatch string comment '行权期',
  s_inc_execpct decimal(20,4) comment '行权比例(%)',
  s_inc_intervaltime decimal(20,4) comment '首个授权日至行权期间隔时间(月)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareincometaxadjproc;
create table if not exists ty_ods.w_ashareincometaxadjproc
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareincometax;
create table if not exists ty_ods.w_ashareincometax
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareincquantitydetails;
create table if not exists ty_ods.w_ashareincquantitydetails
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_inc_sequence string comment '序号',
  s_inc_name string comment '姓名',
  s_inc_post string comment '职位',
  s_inc_quantity decimal(20,4) comment '数量(万股/万份)',
  s_inc_totalqtypct decimal(20,4) comment '占本次授予总数量比例(%)',
  ann_dt string comment '公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareincquantityprice;
create table if not exists ty_ods.w_ashareincquantityprice
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_inc_sequence string comment '序号',
  s_inc_transferpriper decimal(20,4) comment '每股转让价格(行权价格)',
  s_inc_quantity decimal(20,4) comment '激励数量(万份)',
  s_inc_getfundqty decimal(20,4) comment '提取激励基金数量(元)',
  s_inc_iscompleted bigint comment '股权激励是否全部完成',
  s_inc_grantdate string comment '期权授权日',
  s_inc_dnexec_quantity decimal(20,4) comment '已授权未行权的期权数量(万份)',
  s_inc_enddate string comment '截止日期',
  ann_dt string comment '公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareindusrating;
create table if not exists ty_ods.w_ashareindusrating
(
  object_id string comment '对象ID',
  wind_ind_code string comment 'Wind行业ID',
  rating_institute string comment '机构',
  rating_institute_id string comment '[内部]机构id',
  rating_analyst string comment '分析师',
  rating_analyst_id string comment '[内部]分析师id',
  report_type_code bigint comment '报告类型代码',
  rating_dt string comment '评级日期',
  end_dt string comment '有效期截止日',
  rating_memo string comment '[内部]摘要',
  score bigint comment '得分',
  rating string comment '新评级',
  report_ind string comment '原始行业',
  collect_dt string comment '[内部]公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareinsidertrade;
create table if not exists ty_ods.w_ashareinsidertrade
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  related_manager_name string comment '相关管理层姓名',
  reported_trader_name string comment '变动人姓名',
  change_volume decimal(20,4) comment '变动数',
  trade_avg_price decimal(20,4) comment '成交均价',
  position_after_trade decimal(20,4) comment '变动后持股',
  trade_dt string comment '变动日期',
  ann_dt string comment '填报日期',
  trade_reason_code bigint comment '变动原因类型代码',
  related_manager_post string comment '相关管理层职务',
  trader_manager_relation string comment '变动人与管理层的关系',
  actual_ann_dt string comment '实际公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareinstholderderdata;
create table if not exists ty_ods.w_ashareinstholderderdata
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  report_period string comment '报告期',
  s_holder_compcode string comment '股东公司id',
  s_holder_name string comment '股东名称',
  s_holder_holdercategory string comment '股东类型',
  s_holder_quantity decimal(20,4) comment '持股数',
  s_holder_pct decimal(20,4) comment '持股比例(计算)',
  ann_date string comment '公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareintangibleassets;
create table if not exists ty_ods.w_ashareintangibleassets
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareintensitytrendadj;
create table if not exists ty_ods.w_ashareintensitytrendadj
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '日期',
  market bigint comment '大盘同步指标沪深300(7日)',
  strength bigint comment '阶段强势指标沪深300(20日)',
  weakkness bigint comment '阶段弱势指标沪深300(20日)',
  bottoming_b bigint comment '筑底指标B(125,5,20日)',
  bottoming_d bigint comment '筑底指标D(125,5,20日)',
  dmi_pdi bigint comment 'DMI趋向指标PDI(14,6日)',
  dmi_mdi bigint comment 'DMI趋向指标MDI(14,6日)',
  dmi_adx bigint comment 'DMI趋向指标ADX(14,6日)',
  dmi_adxr bigint comment 'DMI趋向指标ADXR(14,6日)',
  expma bigint comment 'EXPMA指数平均数(12日)',
  ma_5d bigint comment 'MA简单移动平均(5日)',
  ma_10d bigint comment 'MA简单移动平均(10日)',
  ma_20d bigint comment 'MA简单移动平均(20日)',
  ma_30d bigint comment 'MA简单移动平均30日)',
  ma_60d bigint comment 'MA简单移动平均(60日)',
  ma_120d bigint comment 'MA简单移动平均(120日)',
  ma_250d bigint comment 'MA简单移动平均(250日)',
  macd_diff bigint comment 'MACD指数平滑异同平均DIFF(26,12,9日)',
  macd_dea bigint comment 'MACD指数平滑异同平均DEA(26,12,9日)',
  macd_macd bigint comment 'MACD指数平滑异同平均MACD(26,12,9日)',
  bbi bigint comment 'BBI多空指数(3,6,12,24日)',
  ddi bigint comment 'DDI方向标准离差指数DDI(13,30,5,10日)',
  ddi_addi bigint comment 'DDI方向标准离差指数ADDI(13,30,5,10日)',
  ddi_ad bigint comment 'DDI方向标准离差指数AD(13,30,5,10日)',
  dma_ddd bigint comment 'DMA平均线差DDD(10,50,10日)',
  dma_ama bigint comment 'DMA平均线差AMA(10,50,10日)',
  mtm bigint comment 'MTM动力指标MTM(6,6日)',
  mtm_mtmma bigint comment 'MTM动力指标MTMMA(6,6日)',
  priceosc bigint comment 'PRICEOSC价格振荡指标(26,12日)',
  trix bigint comment 'TRIX三重指数平滑平均TRIX(12,20日)',
  trma bigint comment 'TRIX三重指数平滑平均TRMA(12,20日)',
  sar bigint comment 'SAR抛物转向(4,2,20日)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareintensitytrend;
create table if not exists ty_ods.w_ashareintensitytrend
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '日期',
  market bigint comment '大盘同步指标沪深300(7日)',
  strength bigint comment '阶段强势指标沪深300(20日)',
  weakkness bigint comment '阶段弱势指标沪深300(20日)',
  bottoming_b bigint comment '筑底指标B(125,5,20日)',
  bottoming_d bigint comment '筑底指标D(125,5,20日)',
  dmi_pdi bigint comment 'DMI趋向指标PDI(14,6日)',
  dmi_mdi bigint comment 'DMI趋向指标MDI(14,6日)',
  dmi_adx bigint comment 'DMI趋向指标ADX(14,6日)',
  dmi_adxr bigint comment 'DMI趋向指标ADXR(14,6日)',
  expma bigint comment 'EXPMA指数平均数(12日)',
  ma_5d bigint comment 'MA简单移动平均(5日)',
  ma_10d bigint comment 'MA简单移动平均(10日)',
  ma_20d bigint comment 'MA简单移动平均(20日)',
  ma_30d bigint comment 'MA简单移动平均30日)',
  ma_60d bigint comment 'MA简单移动平均(60日)',
  ma_120d bigint comment 'MA简单移动平均(120日)',
  ma_250d bigint comment 'MA简单移动平均(250日)',
  macd_diff bigint comment 'MACD指数平滑异同平均DIFF(26,12,9日)',
  macd_dea bigint comment 'MACD指数平滑异同平均DEA(26,12,9日)',
  macd_macd bigint comment 'MACD指数平滑异同平均MACD(26,12,9日)',
  bbi bigint comment 'BBI多空指数(3,6,12,24日)',
  ddi bigint comment 'DDI方向标准离差指数DDI(13,30,5,10日)',
  ddi_addi bigint comment 'DDI方向标准离差指数ADDI(13,30,5,10日)',
  ddi_ad bigint comment 'DDI方向标准离差指数AD(13,30,5,10日)',
  dma_ddd bigint comment 'DMA平均线差DDD(10,50,10日)',
  dma_ama bigint comment 'DMA平均线差AMA(10,50,10日)',
  mtm bigint comment 'MTM动力指标MTM(6,6日)',
  mtm_mtmma bigint comment 'MTM动力指标MTMMA(6,6日)',
  priceosc bigint comment 'PRICEOSC价格振荡指标(26,12日)',
  trix bigint comment 'TRIX三重指数平滑平均TRIX(12,20日)',
  trma bigint comment 'TRIX三重指数平滑平均TRMA(12,20日)',
  sar bigint comment 'SAR抛物转向(4,2,20日)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareinterestraterisk;
create table if not exists ty_ods.w_ashareinterestraterisk
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareinterestreceivable;
create table if not exists ty_ods.w_ashareinterestreceivable
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareinternetvoting;
create table if not exists ty_ods.w_ashareinternetvoting
(
  object_id string comment '对象ID',
  s_event_id string comment '会议事件ID',
  s_event_num string comment '议案序号',
  s_event_name string comment '议案名称',
  s_info_type string comment '表决方式类型',
  s_info_price decimal(20,4) comment '申报价格',
  s_info_compcode string comment '[内部]公司ID',
  ann_dt string comment '[内部]公告日期',
  is_passed bigint comment '是否通过',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareintpayable;
create table if not exists ty_ods.w_ashareintpayable
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareinvefallpriceres;
create table if not exists ty_ods.w_ashareinvefallpriceres
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareinventorydetails;
create table if not exists ty_ods.w_ashareinventorydetails
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  report_period string comment '报告期',
  inv_object string comment '项目',
  inv_amt decimal(20,4) comment '金额',
  crncy_code string comment '货币代码',
  provision decimal(20,4) comment '跌价准备',
  statement_type bigint comment '报告类型代码',
  net decimal(20,4) comment '净额',
  subject_name string comment '科目名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareinvestmentincome;
create table if not exists ty_ods.w_ashareinvestmentincome
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareinvestmentpevc;
create table if not exists ty_ods.w_ashareinvestmentpevc
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  s_info_dimension string comment '维度',
  s_info_dimension1 string comment '子维度',
  s_info_comp_name string comment '投资公司名称',
  s_info_comp_sname string comment '投资公司中文简称',
  s_info_compcode1 string comment '投资公司ID',
  s_holder_date string comment '投资时间',
  s_holder_pct decimal(20,4) comment '股权比例',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareinvestmentrealestate;
create table if not exists ty_ods.w_ashareinvestmentrealestate
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareipoamount;
create table if not exists ty_ods.w_ashareipoamount
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  change_date string comment '变动日',
  ann_date string comment '公告日',
  s_ipo_osdexpoffamount decimal(20,4) comment '发行股份数',
  s_share_totalrestricted decimal(20,4) comment '限售股数',
  s_share_totaltradable decimal(20,4) comment '无限售股份数',
  s_share_be_listed decimal(20,4) comment '其中:待上市流通股数',
  s_share_ntrd_statjur decimal(20,4) comment '非流通股份数',
  s_share_changereason string comment '[内部]股本变动原因',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareipopricingforecast;
create table if not exists ty_ods.w_ashareipopricingforecast
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  research_inst_name string comment '机构名称',
  research_inst_id string comment '机构ID',
  research_inst_id2 string comment '机构编码',
  analyst_name string comment '分析师名称',
  analyst_id string comment '作者ID',
  est_dt string comment '预测日期',
  collect_time string comment '[内部]公告日期',
  first_optime timestamp comment '[内部]发布日期',
  price_floor decimal(20,4) comment '定价区间下限',
  price_ceiling decimal(20,4) comment '定价区间上限',
  inquiry_price_floor decimal(20,4) comment '询价建议区间下限',
  inquiry_price_ceiling decimal(20,4) comment '询价建议区间上限',
  est_memo string comment '预测摘要',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareisactivity;
create table if not exists ty_ods.w_ashareisactivity
(
  object_id string comment '对象ID',
  event_id string comment '事件ID',
  s_info_windcode string comment 'Wind代码',
  s_activitiestype bigint comment '投资者关系活动类别代码',
  s_surveydate string comment '调研日期',
  s_surveytime string comment '调研具体时间',
  ann_dt string comment '公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareisparticipant;
create table if not exists ty_ods.w_ashareisparticipant
(
  object_id string comment '对象ID',
  event_id string comment '事件ID',
  s_institutionname string comment '机构投资者名称',
  s_institutioncode string comment '机构投资者ID',
  s_institutiontype bigint comment '机构投资者类型',
  s_analystname string comment '机构参与人员姓名',
  s_institutiontypecode bigint comment '参与者类型代码',
  manager_post string comment '机构参与人员公布职务',
  s_analyst_id string comment '机构参与人员ID',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareisqa;
create table if not exists ty_ods.w_ashareisqa
(
  object_id string comment '对象ID',
  event_id string comment '事件ID',
  s_info_windcode string comment 'Wind代码',
  s_askdate string comment '提问日期',
  s_questiontype bigint comment '问题内容分类代码',
  s_questioncontent string comment '问题内容',
  s_answercontent string comment '回答内容',
  originalwebsite string comment '原文地址',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareissuecommaudit;
create table if not exists ty_ods.w_ashareissuecommaudit
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_info_companyname string comment '公司名称',
  s_ic_year string comment '年度',
  s_ic_sessiontimes string comment '会议届次',
  s_ic_audittype string comment '审核类型',
  s_ic_type bigint comment '发审委类型',
  s_ic_announcementdate string comment '会议公告日期',
  s_ic_date string comment '会议日期',
  s_ic_auditocetype string comment '审核结果类型',
  s_ic_auditannocedate string comment '审核结果公告日期',
  s_info_expectedissueshares decimal(20,4) comment '预计发行股数(万股)',
  s_info_expectedcollection decimal(20,4) comment '预计募集资金(万元)',
  s_info_veto_reason string comment '被否原因',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareissuingdatepredict;
create table if not exists ty_ods.w_ashareissuingdatepredict
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  report_period string comment '报告期',
  s_stm_predict_issuingdate string comment '预计披露日期(最新)',
  s_stm_actual_issuingdate string comment '实际披露日期',
  s_stm_correct_num string comment '更正公告披露次数',
  s_stm_correct_issuingdate string comment '更正公告披露日期',
  ann_dt string comment '预计披露日期公告日(最新)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharekindsoveloansterm;
create table if not exists ty_ods.w_asharekindsoveloansterm
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额(元)',
  item_name string comment '项目容错名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharel2indicators;
create table if not exists ty_ods.w_asharel2indicators
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '交易日期',
  s_li_initiativebuyrate decimal(20,4) comment '主买比率',
  s_li_initiativebuymoney decimal(20,4) comment '主买总额',
  s_li_initiativebuyamount decimal(20,4) comment '主买总量',
  s_li_initiativesellrate decimal(20,4) comment '主卖比率',
  s_li_initiativesellmoney decimal(20,4) comment '主卖总额',
  s_li_initiativesellamount decimal(20,4) comment '主卖总量',
  s_li_largebuyrate decimal(20,4) comment '大买比率',
  s_li_largebuymoney decimal(20,4) comment '大买总额',
  s_li_largebuyamount decimal(20,4) comment '大买总量',
  s_li_largesellrate decimal(20,4) comment '大卖比率',
  s_li_largesellmoney decimal(20,4) comment '大卖总额',
  s_li_largesellamount decimal(20,4) comment '大卖总量',
  s_li_entrustrate decimal(20,4) comment '总委比',
  s_li_entrudifferamount decimal(20,4) comment '总委差量',
  s_li_entrudifferamoney decimal(20,4) comment '总委差额',
  s_li_entrustbuymoney decimal(20,4) comment '总委买额',
  s_li_entrustsellmoney decimal(20,4) comment '总委卖额',
  s_li_entrustbuyamount decimal(20,4) comment '总委买量',
  s_li_entrustsellamount decimal(20,4) comment '总委卖量',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareliquidityrisk;
create table if not exists ty_ods.w_ashareliquidityrisk
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareloandetails;
create table if not exists ty_ods.w_ashareloandetails
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  loan_type string comment '贷款类型',
  loan_cny decimal(20,4) comment '人民币贷款',
  loan_usd decimal(20,4) comment '美元贷款(折算人民币)',
  loan_jpy decimal(20,4) comment '日元贷款(折算人民币)',
  loan_eur decimal(20,4) comment '欧元贷款(折算人民币)',
  loan_hkd decimal(20,4) comment '港币贷款(折算人民币)',
  loan_gbp decimal(20,4) comment '英镑贷款(折算人民币)',
  loan_other decimal(20,4) comment '其他货币贷款(折算人民币)',
  loan_tot decimal(20,4) comment '贷款合计',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareloansothbanks;
create table if not exists ty_ods.w_ashareloansothbanks
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharelongloan;
create table if not exists ty_ods.w_asharelongloan
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  s_info_dimension string comment '维度',
  s_info_dimension1 string comment '子维度',
  s_info_comp_name string comment '债务公司名称',
  s_info_comp_sname string comment '债务公司中文简称',
  s_info_compcode1 string comment '债务公司ID',
  report_period string comment '报告期',
  s_info_amount decimal(20,4) comment '金额',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharelteqyinvest;
create table if not exists ty_ods.w_asharelteqyinvest
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareltloan;
create table if not exists ty_ods.w_ashareltloan
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareltpayables;
create table if not exists ty_ods.w_ashareltpayables
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareltprepaidexp;
create table if not exists ty_ods.w_ashareltprepaidexp
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharemajorevent;
create table if not exists ty_ods.w_asharemajorevent
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_event_categorycode bigint comment '事件类型代码',
  s_event_anncedate string comment '披露日期',
  s_event_hapdate string comment '发生日期',
  s_event_expdate string comment '失效日期',
  s_event_content string comment '事件内容',
  s_event_templateid bigint comment '模板ID',
  sec_id string comment '证券ID',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharemajorholderplanhold;
create table if not exists ty_ods.w_asharemajorholderplanhold
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_holder_name string comment '股东名称',
  s_ph_startdate string comment '增持计划起始日期',
  s_ph_enddate string comment '增持计划截止日期',
  s_ph_conditionornot bigint comment '是否无条件增持',
  s_ph_triggerprice decimal(20,4) comment '增持触发价格',
  s_ph_continuousdays decimal(20,4) comment '连续天数',
  s_ph_calculatedays decimal(20,4) comment '计算天数',
  s_ph_calculatepricemode string comment '价格计算方式',
  s_ph_sharenumdownlimit decimal(20,4) comment '增持股数下限(万股)',
  s_ph_sharenumuplimit decimal(20,4) comment '增持股数上限(万股)',
  s_ph_intendputmoneydownlimit decimal(20,4) comment '拟投入金额下限(亿元)',
  s_ph_intendputmoneyuplimit decimal(20,4) comment '拟投入金额上限(亿元)',
  s_ph_priceuplimit decimal(20,4) comment '增持价格上限',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharemajorreceivables;
create table if not exists ty_ods.w_asharemajorreceivables
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  statement_type string comment '报表类型',
  debtor_name string comment '债务人名称',
  arrears decimal(20,4) comment '金额',
  delaytime string comment '拖欠时间',
  delayreason string comment '拖欠原因',
  currency_code string comment '货币代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharemanagementexpense;
create table if not exists ty_ods.w_asharemanagementexpense
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharemanagementholdreward;
create table if not exists ty_ods.w_asharemanagementholdreward
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_date string comment '公告日期',
  end_date string comment '截止日期',
  crny_code string comment '货币代码',
  s_info_manager_name string comment '姓名',
  s_info_manager_post string comment '职务',
  s_manager_return decimal(20,4) comment '报酬',
  s_manager_quantity decimal(20,4) comment '持股数量',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharemanagement;
create table if not exists ty_ods.w_asharemanagement
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_date string comment '公告日期',
  s_info_manager_name string comment '姓名',
  s_info_manager_gender string comment '性别',
  s_info_manager_education string comment '学历',
  s_info_manager_nationality string comment '国籍',
  s_info_manager_birthyear string comment '出生年份',
  s_info_manager_startdate string comment '任职日期',
  s_info_manager_leavedate string comment '离职日期',
  s_info_manager_type bigint comment '管理层类别',
  s_info_manager_post string comment '职务',
  s_info_manager_introduction string comment '个人简历',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharemarginshortfeerate;
create table if not exists ty_ods.w_asharemarginshortfeerate
(
  object_id string comment '对象ID',
  publisher_id string comment '发布方ID',
  item_code bigint comment '项目类别代码',
  effective_date string comment '生效日',
  fee_rate decimal(20,4) comment '项目数据',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharemarginsubject;
create table if not exists ty_ods.w_asharemarginsubject
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_margin_sharetype bigint comment '融资融券相关证券类型代码',
  s_margin_effectdate string comment '生效日',
  s_margin_elimindate string comment '剔除日',
  s_margin_marginrate decimal(20,4) comment '保证金比例',
  s_margin_conversionrate decimal(20,4) comment '折算率',
  s_margin_rateeffectdate string comment '保证金比例或折算率生效日',
  s_is_new bigint comment '是否最新',
  s_margin_expirationdate string comment '保证金比例或折算率失效日',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharemargintrade;
create table if not exists ty_ods.w_asharemargintrade
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '日期',
  s_margin_tradingbalance decimal(20,4) comment '融资余额(元)',
  s_margin_purchwithborrowmoney decimal(20,4) comment '融资买入额(元,股)',
  s_margin_repaymenttobroker decimal(20,4) comment '融资偿还额(元,股)',
  s_margin_seclendingbalance decimal(20,4) comment '融券余额(元)',
  s_margin_seclendingbalancevol decimal(20,4) comment '融券余量(股,份,手)',
  s_margin_salesofborrowedsec decimal(20,4) comment '融券卖出量(股,份,手)',
  s_margin_repaymentofborrowsec decimal(20,4) comment '融券偿还量(股,份,手)',
  s_margin_margintradebalance decimal(20,4) comment '融资融券余额(元)',
  s_refin_sl_vol_3d bigint comment '转融券融出数量(3天)',
  s_refin_sl_vol_7d bigint comment '转融券融出数量(7天)',
  s_refin_sl_vol_14d bigint comment '转融券融出数量(14天)',
  s_refin_sl_vol_28d bigint comment '转融券融出数量(28天)',
  s_refin_sl_vol_182d bigint comment '转融券融出数量(182天)',
  s_refin_sb_vol_3d bigint comment '转融券融入数量(3天)',
  s_refin_sb_vol_7d bigint comment '转融券融入数量(7天)',
  s_refin_sb_vol_14d bigint comment '转融券融入数量(14天)',
  s_sb_vol_28d bigint comment '转融券融入数量(28天)',
  s_sb_vol_182d bigint comment '转融券融入数量(182天)',
  s_refin_sl_eod_vol bigint comment '转融券融出日成交量',
  s_refin_sb_eod_vol bigint comment '转融券融入日成交量',
  s_refin_sl_eop_vol bigint comment '转融券期末余量',
  s_refin_sl_eop_bal decimal(20,4) comment '转融券期末余额',
  s_refin_repay_vol bigint comment '转融券偿还量',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharemargintradesum;
create table if not exists ty_ods.w_asharemargintradesum
(
  object_id string comment '对象ID',
  trade_dt string comment '日期',
  s_marsum_exchmarket string comment '交易所英文简称',
  s_marsum_tradingbalance decimal(20,4) comment '融资余额(元)',
  s_marsum_purchwithborrowmoney decimal(20,4) comment '融资买入额(元)',
  s_marsum_repaymenttobroker decimal(20,4) comment '融资偿还额(元)',
  s_marsum_seclendingbalance decimal(20,4) comment '融券余额(元)',
  s_marsum_salesofborrowedsec decimal(20,4) comment '融券卖出量(股,份,手)',
  s_marsum_margintradebalance decimal(20,4) comment '融资融券余额(元)',
  s_marsum_margin_margin decimal(20,4) comment '融券余量',
  s_marsum_financing_margin decimal(20,4) comment '融资余量股(份/手)',
  s_marsum_securities_sales decimal(20,4) comment '融券卖出额(元)',
  s_marsum_securities_repay decimal(20,4) comment '融券偿还额(元)',
  s_marsum_flow_equity decimal(20,4) comment 'A股流通股本(万股)',
  s_marsum_circulation_value decimal(20,4) comment 'A股流通市值(万元)',
  s_marsum_turnover_amount decimal(20,4) comment 'A股成交金额(万元)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharemarketoverallindex;
create table if not exists ty_ods.w_asharemarketoverallindex
(
  object_id string comment '对象ID',
  month1 string comment '月份',
  `exchange` string comment '交易所',
  listed_company_num decimal(15,4) comment '上市公司总数',
  listed_securities_num decimal(15,4) comment '上市证券总数',
  listed_stock_num decimal(15,4) comment '上市股票总数',
  listed_ashare_num decimal(15,4) comment '上市A股总数',
  listed_bshare_num decimal(15,4) comment '上市B股总数',
  stock_total_capital decimal(15,4) comment '股票-总股本(亿元)',
  stock_total_market_value decimal(15,4) comment '股票-总市值(亿元)',
  stock_flow_equity decimal(15,4) comment '股票-流通股本(亿股)',
  stock_flow_market_value decimal(15,4) comment '股票-流通市值(亿元)',
  open_accounts_num decimal(15,4) comment '投资者开户总数(万户)',
  average_pe decimal(15,4) comment '平均市盈率',
  ashare_average_pe decimal(15,4) comment 'A股平均市盈率',
  bshare_average_pe decimal(15,4) comment 'B股平均市盈率',
  stock_fund_transaction_amount decimal(15,4) comment '股票、基金成交金额:当年累计(亿元)',
  ashare_transaction_amount decimal(15,4) comment 'A股成交金额:当年累计(亿元)',
  bshare_transaction_amount decimal(15,4) comment 'B股成交金额:当年累计(亿元)',
  fund_transaction_amount decimal(15,4) comment '基金成交金额:当年累计(亿元)',
  bond_transaction_amount decimal(15,4) comment '债券成交金额:当年累计(亿元)',
  ashare_stamp_duty decimal(15,4) comment '代扣A股交易印花税(亿元)',
  bshare_stamp_duty decimal(15,4) comment '代扣B股交易印花税(亿美元/港币)',
  stock_repurchase_amount decimal(20,4) comment '股票回购金额:当年累计',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharemergersubject;
create table if not exists ty_ods.w_asharemergersubject
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  s_info_dimension string comment '维度',
  s_info_dimension1 string comment '子维度',
  s_info_comp_name string comment '并购公司名称',
  s_info_comp_sname string comment '并购公司中文简称',
  s_info_compcode1 string comment '并购公司ID',
  s_info_progress string comment '方案进度',
  s_update_date string comment '最新披露日期',
  s_meetevent_id string comment '事件ID',
  s_info_comp_name1 string comment '并购目标公司名称',
  s_info_comp_sname1 string comment '并购目标公司中文简称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharemjrholdertrade;
create table if not exists ty_ods.w_asharemjrholdertrade
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_dt string comment '公告日期',
  transact_startdate string comment '变动起始日期',
  transact_enddate string comment '变动截至日期',
  holder_name string comment '持有人',
  holder_type string comment '持有人类型',
  transact_type string comment '买卖方向',
  transact_quantity decimal(20,4) comment '变动数量',
  transact_quantity_ratio decimal(20,4) comment '变动数量占流通量比例(%)',
  holder_quantity_new decimal(20,4) comment '最新持有流通数量',
  holder_quantity_new_ratio decimal(20,4) comment '最新持有流通数量占流通量比例(%)',
  avg_price decimal(20,4) comment '平均价格',
  whether_agreed_repur_trans bigint comment '是否约定购回式交易',
  blocktrade_quantity decimal(20,4) comment '通过大宗交易系统的变动数量',
  is_restricted bigint comment '是否为减持限售股份',
  is_reannounced bigint comment '是否重复披露',
  trade_detail string comment '变动说明',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharemonetaryfundofproj;
create table if not exists ty_ods.w_asharemonetaryfundofproj
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharemonetaryfunds;
create table if not exists ty_ods.w_asharemonetaryfunds
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_date string comment '公告日期',
  s_rmb decimal(20,4) comment '人民币',
  s_us decimal(20,4) comment '美元(折算人民币)',
  s_jpy decimal(20,4) comment '日元(折算人民币)',
  s_eur decimal(20,4) comment '欧元(折算人民币)',
  s_hkd decimal(20,4) comment '港币(折算人民币)',
  s_gbp decimal(20,4) comment '英镑(折算人民币)',
  s_other decimal(20,4) comment '其他货币(折算人民币)',
  capital_tot decimal(20,4) comment '货币资金合计',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharemonthlyreportsofbrokers;
create table if not exists ty_ods.w_asharemonthlyreportsofbrokers
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_dt string comment '公告日期',
  report_period string comment '报告期',
  statement_typecode bigint comment '报表类型代码',
  acc_sta_code bigint comment '原始报表采用会计准则代码',
  iflisted_data bigint comment '是否上市后数据',
  oper_rev decimal(20,4) comment '营业收入',
  net_profit_incl_min_int_inc decimal(20,4) comment '净利润(含少数股东权益)',
  net_profit_excl_min_int_inc decimal(20,4) comment '净利润(不含少数股东权益)',
  tot_shrhldr_eqy_excl_min_int decimal(20,4) comment '股东权益合计(不含少数股东权益)',
  tot_shrhldr_eqy_incl_min_int decimal(20,4) comment '股东权益合计(含少数股东权益)',
  s_info_compname string comment '公司名称',
  s_info_compcode string comment '公司ID',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharemonthlyyield;
create table if not exists ty_ods.w_asharemonthlyyield
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '截至日期',
  crncy_code string comment '货币代码',
  s_mq_pctchange decimal(20,4) comment '月收益率(%)',
  s_mq_turn decimal(20,4) comment '月换手率(合计)(%)',
  s_mq_avgturn decimal(20,4) comment '月换手率(算术平均)(%)',
  s_mq_amount decimal(20,4) comment '月成交金额(万元)',
  s_risk_betar24 decimal(20,4) comment 'BETA(24月)',
  s_risk_betar60 decimal(20,4) comment 'BETA (60月)',
  s_mq_varpctchange24 decimal(20,4) comment '月收益率方差(24月)',
  s_mq_devpctchange24 decimal(20,4) comment '月收益率标准差(24月)',
  s_mq_avgpctchange24 decimal(20,4) comment '月收益率平均值(24月)',
  s_mq_varpctchange60 decimal(20,4) comment '月收益率方差(60月)',
  s_mq_devpctchange60 decimal(20,4) comment '月收益率标准差(60月)',
  s_mq_avgpctchange60 decimal(20,4) comment '月收益率平均值(60月)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharenoncurrentliabilities1y;
create table if not exists ty_ods.w_asharenoncurrentliabilities1y
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharenonoperexp;
create table if not exists ty_ods.w_asharenonoperexp
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharenonoperrev;
create table if not exists ty_ods.w_asharenonoperrev
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharenonprofitloss;
create table if not exists ty_ods.w_asharenonprofitloss
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  ann_dt string comment '公告日期',
  report_period string comment '报告期',
  statement_type string comment '报表类型',
  crncy_code string comment '货币代码',
  non_current_gains_losses decimal(20,4) comment '非流动资产处置损益',
  tax_return decimal(20,4) comment '税收返还减免',
  government_subsidy decimal(20,4) comment '政府补助',
  capital_occupation_fee decimal(20,4) comment '资金占用费',
  consolidated_gains_losses decimal(20,4) comment '企业合并产生的损益',
  non_assets_gains_losses decimal(20,4) comment '非货币性资产交换损益',
  investment_gains_losses decimal(20,4) comment '委托投资损益',
  impairment_assets decimal(20,4) comment '资产减值准备',
  debt_restructuring decimal(20,4) comment '债务重组损益',
  enterprise_restructuring decimal(20,4) comment '企业重组费用',
  trading_price_unfair decimal(20,4) comment '交易价格显失公允产生的损益',
  net_profit_loss_subsidiaries decimal(20,4) comment '同一控制下企业合并产生的子公司净损益',
  expected_liabilities decimal(20,4) comment '预计负债产生的损益',
  onoiae decimal(20,4) comment '其他营业外收支净额',
  other_projects decimal(20,4) comment '其他项目',
  non_recurring_gains_losses decimal(20,4) comment '非经常性损益项目小计',
  income_tax_impact decimal(20,4) comment '所得税影响数',
  profit_loss_shareholders decimal(20,4) comment '少数股东损益影响数',
  non_recurring_gains_losses1 decimal(20,4) comment '非经常性损益项目合计',
  s_fa_deductedprofittoprofit decimal(20,4) comment '扣除非经常损益后的净利润',
  s_fa_deductedprofittoprofit1 decimal(20,4) comment '扣除非经常损益后的归属公司股东的净利润',
  fairvalue_change_gains_losses decimal(20,4) comment '持有(或处置)交易性金融资产和负债产生的公允价值变动损益',
  provision_impairment_reversed decimal(20,4) comment '单独进行监制测试的应收款项减值准备转回',
  proceeds_loan decimal(20,4) comment '对外委托贷款取得的收益',
  changes_real_estate_value decimal(20,4) comment '公允价值法计量的投资性房地产价值变动损益',
  profit_loss_adjustment decimal(20,4) comment '法规要求一次性损益调整影响',
  custody_fee_income decimal(20,4) comment '受托经营取得的托管费收入',
  is_published bigint comment '是否公布',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharenotespayable;
create table if not exists ty_ods.w_asharenotespayable
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharenotesreceivable;
create table if not exists ty_ods.w_asharenotesreceivable
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareofferforoffer;
create table if not exists ty_ods.w_ashareofferforoffer
(
  object_id string comment '对象ID',
  s_info_compcode string comment '被要约收购公司id',
  acquirer_name string comment '收购人名称',
  is_privatization bigint comment '是否属于私有化',
  start_date string comment '要约起始日期',
  end_date string comment '要约终止日期',
  circulation_stock_num decimal(20,4) comment '预定收购流通股数量(万股)',
  circulation_stock_proportion decimal(20,4) comment '预定收购流通股数量占总股本比例(%)',
  purchasing_price decimal(20,4) comment '流通股每股收购价格',
  conv_code string comment '流通股股东申报代码',
  restricted_stock_num decimal(20,4) comment '预定收购非流通股(限售流通股)数量(万股)',
  restricted_stock_proportion decimal(20,4) comment '预定收购非流通股(限售流通股)数量占总股本比例(%)',
  restricted_purchasing_price decimal(20,4) comment '非流通股(限售流通股)每股收购价格',
  restricted_conv_code string comment '非流通股(限售流通股)股东申报代码',
  total_amount_funds decimal(20,4) comment '预定收购资金总额(万元)',
  payment_method string comment '支付方式',
  circulation_stock_num1 decimal(20,4) comment '实际收购流通股数量(万股)',
  total_amount_funds1 decimal(20,4) comment '实际收购资金总额(万元)',
  offer_for_offer string comment '要约收购目的',
  effective_conditions string comment '要约收购生效条件',
  price_description string comment '要约收购价格说明',
  financialadvisor string comment '财务顾问',
  s_profitnotice_firstanndate string comment '首次公告日',
  s_profitnotice_date string comment '要约收购书公告日',
  s_result_bulletin_day string comment '要约收购结果公告日',
  nann_date string comment '最新公告日期',
  shareholding_ratio decimal(20,4) comment '要约收购书公告日收购人持股比例(%)',
  new_shareholding_ratio decimal(20,4) comment '要约期满收购人持股比例(%)',
  circulation_stock_ratio decimal(20,4) comment '实际收购流通股数量占总股本比例(%)',
  restricted_stock_num1 decimal(20,4) comment '实际收购非流通股(限售流通股)数量(万股)',
  restricted_stock_ratio decimal(20,4) comment '实际收购非流通股(限售流通股)数量占总股本比例(%)',
  capital_description string comment '要约收购资金说明',
  offer_code bigint comment '要约方式代码',
  event_id string comment '并购事件ID',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareoperationevent;
create table if not exists ty_ods.w_ashareoperationevent
(
  object_id string comment '对象ID',
  comp_id string comment '公司id',
  sec_id string comment '品种ID',
  s_info_windcode string comment 'Wind代码',
  ann_date string comment '公告日期',
  event_type bigint comment '事件类型',
  event_name string comment '事件标题',
  cattype_id bigint comment '品种类别代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareoperrevandcost;
create table if not exists ty_ods.w_ashareoperrevandcost
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareotheraccountsreceivable;
create table if not exists ty_ods.w_ashareotheraccountsreceivable
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  statement_type string comment '报表类型',
  aging string comment '帐龄',
  currency_code string comment '货币代码',
  oth_rcv decimal(20,4) comment '金额',
  oth_rcv_pct decimal(20,4) comment '比例',
  extra_amount decimal(20,4) comment '坏帐准备',
  min_aging decimal(20,4) comment '最小帐龄',
  max_aging decimal(20,4) comment '最大帐龄',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareothercomprehincome;
create table if not exists ty_ods.w_ashareothercomprehincome
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareothercurrentassets;
create table if not exists ty_ods.w_ashareothercurrentassets
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareothercurrentliabilities;
create table if not exists ty_ods.w_ashareothercurrentliabilities
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareotherincome;
create table if not exists ty_ods.w_ashareotherincome
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareothernoncurrentassets;
create table if not exists ty_ods.w_ashareothernoncurrentassets
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareothernoncurrentliab;
create table if not exists ty_ods.w_ashareothernoncurrentliab
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareotherpayables;
create table if not exists ty_ods.w_ashareotherpayables
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareotherreceivables;
create table if not exists ty_ods.w_ashareotherreceivables
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  statement_type string comment '报表类型',
  debtor_name string comment '债务人名称',
  arrears decimal(20,4) comment '金额',
  oth_rcv_pct decimal(20,4) comment '比例(%)',
  currency_code string comment '货币代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharepevcinvestment;
create table if not exists ty_ods.w_asharepevcinvestment
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  s_info_dimension string comment '维度',
  s_info_dimension1 string comment '子维度',
  s_info_comp_name string comment '股东公司名称',
  s_info_comp_sname string comment '股东公司中文简称',
  s_info_compcode1 string comment '股东公司ID',
  s_holder_date string comment '融资时间',
  s_holder_pct decimal(12,4) comment '股权比例',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareplacementinfo;
create table if not exists ty_ods.w_ashareplacementinfo
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '公告日期',
  pct_change_1d bigint comment '投资者类型代码',
  pct_change_1w decimal(20,8) comment '网下中签率',
  pct_change_1m decimal(20,4) comment '配售数量',
  volume_w decimal(20,4) comment '申购数量',
  volume_m decimal(20,4) comment '配售数量占比',
  amount_w decimal(20,4) comment '有效申购数量占比',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareplaintiff;
create table if not exists ty_ods.w_ashareplaintiff
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  s_info_dimension string comment '维度',
  s_info_dimension1 string comment '子维度',
  s_info_comp_name string comment '诉讼公司名称',
  s_info_comp_sname string comment '诉讼公司中文简称',
  s_info_compcode1 string comment '诉讼公司ID',
  s_info_case_type string comment '案件类型',
  ann_date string comment '公告日期',
  litigation_events_id string comment '诉讼事件ID',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharepledgetrade;
create table if not exists ty_ods.w_asharepledgetrade
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '交易日期',
  initial_num decimal(20,4) comment '初始交易数量',
  repurchase_num decimal(20,4) comment '购回交易数量',
  repurchase_allowance decimal(20,4) comment '待购回余量',
  repurchase_allowance1 decimal(20,4) comment '待购回余量(无限售条件)',
  repurchase_allowance2 decimal(20,4) comment '待购回余量(有限售条件)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareproduct;
create table if not exists ty_ods.w_ashareproduct
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  s_info_dimension string comment '维度',
  s_info_dimension1 string comment '子维度',
  s_info_comp_name string comment '公司名称',
  s_info_comp_sname string comment '公司中文简称',
  s_enddate string comment '截止日期',
  s_product_name string comment '产品名称',
  s_product_number decimal(20,4) comment '数量',
  number_typecode bigint comment '数量类型代码',
  frequency_code bigint comment '频率代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareprofitexpress;
create table if not exists ty_ods.w_ashareprofitexpress
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_dt string comment '公告日期',
  report_period string comment '报告期',
  oper_rev decimal(20,4) comment '营业总收入(元)',
  oper_profit decimal(20,4) comment '营业利润(元)',
  tot_profit decimal(20,4) comment '利润总额(元)',
  net_profit_excl_min_int_inc decimal(20,4) comment '净利润(元)',
  tot_assets decimal(20,4) comment '总资产(元)',
  tot_shrhldr_eqy_excl_min_int decimal(20,4) comment '股东权益合计(不含少数股东权益)(元)',
  eps_diluted decimal(20,4) comment '每股收益-基本(元)',
  roe_diluted decimal(20,4) comment '净资产收益率-加权(%)',
  s_isaudit bigint comment '是否审计',
  yoynet_profit_excl_min_int_inc decimal(20,4) comment '去年同期修正后净利润',
  brief_performance string comment '业绩简要说明',
  memo string comment '备注',
  s_fa_bps decimal(20,4) comment '每股净资产',
  s_fa_yoysales decimal(20,4) comment '同比增长率:营业总收入',
  s_fa_yoyop decimal(20,4) comment '同比增长率:营业利润',
  s_fa_yoyebt decimal(20,4) comment '同比增长率:利润总额',
  s_fa_yoynetprofit_deducted decimal(20,4) comment '同比增长率:归属母公司股东的净利润',
  s_fa_yoyeps_basic decimal(20,4) comment '同比增长率:基本每股收益',
  s_fa_roe_yearly decimal(20,4) comment '同比增减:加权平均净资产收益率',
  s_fa_growth_assets decimal(20,4) comment '比年初增长率:总资产',
  s_fa_yoyequity decimal(20,4) comment '比年初增长率:归属母公司的股东权益',
  growth_bps_sh decimal(20,4) comment '比年初增长率:归属于母公司股东的每股净资产',
  last_year_oper_rev decimal(20,4) comment '去年同期营业总收入',
  last_year_oper_profit decimal(20,4) comment '去年同期营业利润',
  last_year_tot_profit decimal(20,4) comment '去年同期利润总额',
  last_year_net_profit_excl_inc decimal(20,4) comment '去年同期净利润',
  last_year_eps_diluted decimal(20,4) comment '去年同期每股收益',
  s_early_net_assets decimal(20,4) comment '期初净资产',
  s_early_bps decimal(20,4) comment '期初每股净资产',
  actual_ann_dt string comment '实际公告日期',
  performexp_npdedtoshareholder decimal(20,4) comment '归属于上市公司股东的扣除非经常性损益的净利润',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
 COMMENT '中国A股业绩快报'
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareprofitnotice;
create table if not exists ty_ods.w_ashareprofitnotice
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_profitnotice_date string comment '公告日期',
  s_profitnotice_period string comment '报告期',
  s_profitnotice_style bigint comment '业绩预告类型代码',
  s_profitnotice_signchange string comment '是否变脸',
  s_profitnotice_changemin decimal(20,4) comment '预告净利润变动幅度下限（%）',
  s_profitnotice_changemax decimal(20,4) comment '预告净利润变动幅度上限（%）',
  s_profitnotice_netprofitmin decimal(20,4) comment '预告净利润下限（万元）',
  s_profitnotice_netprofitmax decimal(20,4) comment '预告净利润上限（万元）',
  s_profitnotice_number decimal(15,4) comment '公布次数',
  s_profitnotice_firstanndate string comment '首次公告日',
  s_profitnotice_abstract string comment '业绩预告摘要',
  s_profitnotice_reason string comment '业绩变动原因',
  s_profitnotice_net_parent_firm decimal(20,4) comment '上年同期归母净利润',
  s_info_compcode string comment '公司ID',
  s_profitnotice_changemin_ded decimal(20,4) comment '预告扣非净利润变动幅度下限',
  s_profitnotice_changemax_ded decimal(20,4) comment '预告扣非净利润变动幅度上限',
  s_profitnotice_ni_min_ded decimal(20,8) comment '预告扣非净利润下限',
  s_profitnotice_ni_max_ded decimal(20,8) comment '预告扣非净利润上限',
  s_profitnotice_netprofit_ded decimal(20,8) comment '上年同期扣非净利润',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareprosecution;
create table if not exists ty_ods.w_ashareprosecution
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_info_compcode string comment '公司ID',
  ann_dt string comment '公告日期',
  title string comment '案件名称',
  introduction string comment '案件描述',
  accuser string comment '原告方',
  defendant string comment '被告方',
  pro_type string comment '诉讼类型',
  amount decimal(20,4) comment '涉案金额',
  crncy_code string comment '货币代码',
  prosecute_dt string comment '起诉日期',
  court string comment '一审受理法院',
  judge_dt string comment '判决日期',
  result string comment '判决内容',
  is_appeal bigint comment '是否上诉',
  appellant string comment '二审上诉方(是否原告)',
  court2 string comment '二审受理法院',
  judge_dt2 string comment '二审判决日期',
  result2 string comment '二审判决内容',
  resultamount decimal(20,4) comment '判决金额',
  briefresult string comment '诉讼结果',
  execution string comment '执行情况',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareprovisionbaddebts;
create table if not exists ty_ods.w_ashareprovisionbaddebts
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  statement_type string comment '报表类型',
  aging string comment '帐龄',
  extraction_ratio decimal(20,4) comment '提取比例',
  min_aging decimal(20,4) comment '最小帐龄',
  max_aging decimal(20,4) comment '最大帐龄',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareralatedtrade;
create table if not exists ty_ods.w_ashareralatedtrade
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_dt string comment '公告日期',
  s_relatedtrade_name string comment 'B公司名称',
  s_relatedtrade_relationcode string comment '关联关系',
  s_relatedtrade_control bigint comment '是否存在控制关系',
  s_relatedtrade_tradetype string comment '交易类型',
  s_relatedtrade_settletype string comment '结算方式',
  crncy_code string comment '货币代码',
  s_relatedtrade_amount string comment '交易金额',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharerdexpenditure;
create table if not exists ty_ods.w_asharerdexpenditure
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharerdexpense;
create table if not exists ty_ods.w_asharerdexpense
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharereceivables;
create table if not exists ty_ods.w_asharereceivables
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  s_info_dimension string comment '维度',
  s_info_dimension1 string comment '子维度',
  s_info_comp_name string comment '下游公司名称',
  s_info_comp_sname string comment '下游公司中文简称',
  s_info_compcode1 string comment '下游公司ID',
  report_period string comment '报告期',
  s_info_amount decimal(20,4) comment '金额',
  s_info_discloser string comment '披露公司ID',
  period string comment '拖欠时间',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharereginv;
create table if not exists ty_ods.w_asharereginv
(
  object_id string comment '对象ID',
  comp_id string comment '公司ID',
  sec_id string comment '证券id',
  s_info_windcode string comment 'Wind代码',
  sur_institute string comment '调查机构',
  sur_reasons string comment '调查原因',
  str_anndate string comment '开始公告日期',
  end_anndate string comment '结束公告日期',
  str_date string comment '开始日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharerelatedclaimsdebts;
create table if not exists ty_ods.w_asharerelatedclaimsdebts
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  associated_name string comment '关联方名称',
  associated_funding_amount decimal(20,4) comment '向关联方提供资金发生额',
  associated_funding_balance decimal(20,4) comment '向关联方提供资金余额',
  ashare_funding_amount decimal(20,4) comment '关联方向上市公司提供资金发生额',
  ashare_funding_balance decimal(20,4) comment '关联方向上市公司提供资金余额',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  crncy_code string comment '货币代码',
  connection_relation string comment '关联关系',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharerelatedpartydebt;
create table if not exists ty_ods.w_asharerelatedpartydebt
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  s_info_dimension string comment '维度',
  s_info_dimension1 string comment '子维度',
  s_info_comp_name string comment '债权公司名称',
  s_info_comp_sname string comment '债权公司中文简称',
  s_info_compcode1 string comment '债权公司ID',
  report_period string comment '报告期',
  s_info_amount decimal(20,4) comment '金额',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharereportperiodindex;
create table if not exists ty_ods.w_asharereportperiodindex
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  ann_date string comment '公告日期',
  end_date string comment '截止日期',
  s_ft_bps decimal(20,4) comment '净资产',
  s_bps_change_reason string comment '净资产变动原因',
  s_cap_rsrv decimal(20,4) comment '资本公积金',
  s_cap_rsrv_change_reason string comment '资本公积金变动原因',
  s_undistributedps decimal(20,4) comment '未分配利润',
  s_change_reason string comment '未分配利润变动原因',
  memo string comment '备注',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharerestructuringevents;
create table if not exists ty_ods.w_asharerestructuringevents
(
  object_id string comment '对象ID',
  s_info_windcode string comment '万得代码',
  progress bigint comment '重组进度',
  event string comment '重组事件',
  form bigint comment '重组形式代码',
  purpose bigint comment '重组目的代码',
  type bigint comment '重组类型代码',
  trading_object string comment '交易标的',
  trading_objectcode bigint comment '交易标的类型',
  is_m_a bigint comment '是否并购',
  is_imptrestructuring bigint comment '是否重大资产重组',
  is_controlchanged bigint comment '控制权是否变更',
  shares_traded decimal(20,4) comment '交易股份占比(%)',
  totalvaluedeals decimal(20,4) comment '交易总价值(万元)',
  buyertopaycash decimal(20,4) comment '买方支付现金(万元)',
  crncy_code string comment '货币代码',
  paymentmethod bigint comment '支付方式代码',
  injectedassetbooknet decimal(20,4) comment '注入资产净资产账面值(万元)',
  assetinjectedassessnet decimal(20,4) comment '注入资产净资产评估值(万元)',
  ultimateassessmethod bigint comment '最后采用评估方法',
  basedate string comment '资产评估基准日',
  appreciationrate decimal(20,4) comment '增值率',
  indepfinaadviser string comment '独立财务顾问',
  acquireradviser string comment '购买方财务顾问',
  suspensiondate string comment '重大资产重组停牌日',
  prelandate string comment '预案公告日',
  smtganncedate string comment '股东大会公告日',
  passdate string comment '发审委通过公告日',
  approveddate string comment '证监会核准公告日',
  seo_dt string comment '增发公告日(交易完成日期)',
  ann_dt string comment '最新公告日',
  institutionlisted_dt string comment '向机构所持增发上市日期',
  orientationseo_dt string comment '定增股份上市日期',
  issuevolume decimal(20,4) comment '增发发行数量(万元)',
  seo_price decimal(20,4) comment '增发价格(元)',
  seo_downprice decimal(20,4) comment '增发预案价下限(元)',
  base_dt_avgp_20_m decimal(20,4) comment '定价基准日前20日交易均价',
  base_dt string comment '定价基准日',
  base_dt_type string comment '定价基准日类型',
  estimatednetprofit decimal(20,4) comment '预测净利润(元)',
  forecastyear string comment '预测年度',
  issuedsharesago_seo_m decimal(20,4) comment '重组实施前总股本（万股）',
  issuedsharesago_seo_a decimal(20,4) comment '重组实施后总股本（万股）',
  first_ann_date string comment '首次披露日期',
  event_id string comment '并购事件ID',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharesaleexpense;
create table if not exists ty_ods.w_asharesaleexpense
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharesalessegment;
create table if not exists ty_ods.w_asharesalessegment
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  report_period string comment '报告期',
  crncy_code string comment '货币代码',
  s_segment_itemcode bigint comment '项目类别',
  s_segment_item string comment '主营业务项目',
  s_segment_sales decimal(20,4) comment '主营业务收入(元)',
  s_segment_profit decimal(20,4) comment '主营业务利润(元)',
  s_segment_cost decimal(20,4) comment '主营业务成本(元)',
  is_published_value bigint comment '是否公布值',
  pct_segment_sales decimal(20,4) comment '主营业务收入占比(%)',
  pct_segment_profit decimal(20,4) comment '主营业务利润占比(%)',
  pct_segment_cost decimal(20,4) comment '主营业务成本占比(%)',
  inc_segment_sales decimal(20,4) comment '主营业务收入同比增长率(%)',
  inc_segment_profit decimal(20,4) comment '主营业务利润同比增长率(%)',
  inc_segment_cost decimal(20,4) comment '主营业务成本同比增长率(%)',
  gross_profit_margin decimal(20,4) comment '毛利率(%)',
  inc_profit_margin decimal(20,4) comment '毛利率增长率(%)',
  s_info_compcode string comment '公司ID',
  subject_code string comment '科目ID',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharesellsubject;
create table if not exists ty_ods.w_asharesellsubject
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  s_info_dimension string comment '维度',
  s_info_dimension1 string comment '子维度',
  s_info_comp_name string comment '并购公司名称',
  s_info_comp_sname string comment '并购公司中文简称',
  s_info_compcode1 string comment '并购出售目标公司ID',
  s_info_progress string comment '方案进度',
  s_update_date string comment '最新披露日期',
  s_meetevent_id string comment '事件ID',
  s_info_comp_name1 string comment '并购出售目标公司名称',
  s_info_comp_sname1 string comment '并购出售目标公司中文简称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharesensitanalysis;
create table if not exists ty_ods.w_asharesensitanalysis
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharestaff;
create table if not exists ty_ods.w_asharestaff
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_info_compcode string comment '公司id',
  end_dt string comment '截止日期',
  ann_dt string comment '公告日期',
  s_info_totalemployees decimal(20,4) comment '员工人数(人)',
  s_info_totalemployees2 bigint comment '母公司员工人数(人)',
  memo string comment '特殊情况说明',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharestaffstructure;
create table if not exists ty_ods.w_asharestaffstructure
(
  object_id string comment '对象ID',
  s_info_compcode string comment '交易代码',
  staff_type_code bigint comment '人数类别代码',
  end_dt string comment '截止日期',
  report_type_code bigint comment '报告类型代码',
  item_type_code bigint comment '项目分类代码',
  item_name string comment '项目',
  item_code bigint comment '项目代码',
  staff_number bigint comment '人数',
  proportion decimal(20,4) comment '所占比例',
  ann_dt string comment '公告日期',
  s_info_windcode string comment 'Wind代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharestibholdervote;
create table if not exists ty_ods.w_asharestibholdervote
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  ann_date string comment '公告日期',
  deadline string comment '截止日期',
  s_holder_holdercategory string comment '股东类型',
  s_holder_name string comment '股东名称',
  s_holder_code string comment '股东ID',
  s_holder_quantity decimal(20,4) comment '持股数量(股)',
  s_holder_voting_number decimal(20,4) comment '表决权数量(票)',
  s_holder_lsttypecode bigint comment '股份类型',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharestibinterest;
create table if not exists ty_ods.w_asharestibinterest
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_info_industrycode string comment '板块代码',
  s_info_industryname string comment '板块名称',
  start_dt string comment '起始日期',
  end_dt string comment '终止日期',
  cur_sign bigint comment '是否最新',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharestibinvestmentiending;
create table if not exists ty_ods.w_asharestibinvestmentiending
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  change_dt string comment '交易日期',
  s_share_totalrestricted decimal(20,4) comment '限售股(万股)',
  s_share_float decimal(20,4) comment '非限售股(万股)',
  s_share_lending decimal(20,4) comment '可出借股份(万股)',
  s_share_lending_margin decimal(20,4) comment '出借余量(万股)',
  s_share_change decimal(20,4) comment '当日出借变动股份(万股)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharestloan;
create table if not exists ty_ods.w_asharestloan
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharestockratingconsus;
create table if not exists ty_ods.w_asharestockratingconsus
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  rating_dt string comment '日期',
  s_wrating_avg decimal(20,4) comment '综合评级',
  s_wrating_instnum decimal(20,4) comment '评级机构数量',
  s_wrating_upgrade decimal(20,4) comment '调高家数（相比一月前）',
  s_wrating_downgrade decimal(20,4) comment '调低家数（相比一月前）',
  s_wrating_maintain decimal(20,4) comment '维持家数（相比一月前）',
  s_wrating_numofbuy decimal(20,4) comment '买入家数',
  s_wrating_numofoutperform decimal(20,4) comment '增持家数',
  s_wrating_numofhold decimal(20,4) comment '中性家数',
  s_wrating_numofunderperform decimal(20,4) comment '减持家数',
  s_wrating_numofsell decimal(20,4) comment '卖出家数',
  s_wrating_cycle string comment '周期',
  s_est_price decimal(20,4) comment '一致预测目标价',
  s_est_priceinstnum decimal(20,4) comment '目标价预测机构数',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharestockrating;
create table if not exists ty_ods.w_asharestockrating
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_est_institute string comment '研究机构名称',
  s_est_ratinganalyst string comment '分析师名称',
  s_est_estnewtime_inst string comment '评级日期',
  s_est_scorerating_inst decimal(20,4) comment '本次标准评级',
  s_est_prescorerating_inst decimal(20,4) comment '前次标准评级',
  s_est_lowprice_inst decimal(20,4) comment '本次最低目标价',
  s_est_highprice_inst decimal(20,4) comment '本次最高目标价',
  s_est_prelowprice_inst decimal(20,4) comment '前次最低目标价',
  s_est_prehighprice_inst decimal(20,4) comment '前次最高目标价',
  ann_dt string comment '公告日期(内部)',
  s_est_rating_inst string comment '本次评级',
  s_est_prerating_inst string comment '前次评级',
  s_est_report_title string comment '报告标题',
  s_est_report_type bigint comment '报告类别',
  s_est_ratinganalystid string comment '分析师id',
  s_rating_change bigint comment '评级变动方向',
  s_rating_validenddt string comment '评级有效截止日',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharestockrepo;
create table if not exists ty_ods.w_asharestockrepo
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  event_id string comment '事件ID',
  ann_dt string comment '公告日期',
  end_dt string comment '截止日期',
  status bigint comment '进度类型代码',
  exp_dt string comment '过期日期',
  qty decimal(20,4) comment '回购数量',
  amt decimal(20,4) comment '回购金额',
  s_dq_high decimal(20,4) comment '最高价',
  s_dq_low decimal(20,4) comment '最低价',
  crncy_code string comment '货币代码',
  stock_repo_objective_code bigint comment '股份回购目的代码',
  s_share_lsttypecode bigint comment '回购股份类型代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharestockswap;
create table if not exists ty_ods.w_asharestockswap
(
  object_id string comment '对象ID',
  transferer_windcode string comment '换股方万得代码',
  transferer_name string comment '换股方简称',
  progress string comment '方案进度',
  targetcomp_windcode string comment '标的方万得代码',
  targetcomp_name string comment '标的方简称',
  transferer_conversionprice decimal(20,4) comment '换股方换股价',
  targetcomp_conversionprice decimal(20,4) comment '标的方换股价',
  conversionratio decimal(20,8) comment '换股比例',
  is_cashoption bigint comment '是否有现金选择权',
  cashoption decimal(20,4) comment '现金选择权',
  cashoption_reportstartdate string comment '现金选择权申报起始日',
  cashoption_reportenddate string comment '现金选择权申报截止日',
  cashoption_applicationcode string comment '现金选择权申请代码',
  cashoption_sharepurchaser string comment '现金选择权股份购买方',
  cashoption_applicantname string comment '现金选择权适用方简称',
  is_overalllisting bigint comment '是否属于整体上市',
  prelandate string comment '预案公告日',
  mtstartdate string comment '股东大会召开日',
  smtgrecdate string comment '股东大会股权登记日',
  smtganncedate string comment '股东大会公告日',
  iecannouncementdate string comment '证监会发审委公告日',
  anncedate string comment '实施公告日',
  anncelstdate string comment '上市公告日',
  ann_dt string comment '最新公告日',
  traderesumptiondate string comment '预案公布后复牌日',
  lasttradedate string comment '实施前最后交易日',
  equityregistrationdate string comment '换股股权登记日',
  listdate string comment '上市日',
  consolidationbasedate string comment '合并基准日',
  financialadvisor string comment '财务顾问',
  plandescription string comment '方案说明',
  casharrivaldate string comment '现金选择权现金到账日',
  effectivereportedshares decimal(20,4) comment '现金选择权有效申报股数',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharestrangetrade;
create table if not exists ty_ods.w_asharestrangetrade
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_strange_bgdate string comment '交易起始日',
  s_strange_enddate string comment '交易截止日',
  s_strange_range decimal(20,4) comment '涨跌幅',
  s_strange_volume decimal(20,4) comment '总成交量(万股)',
  s_strange_amount decimal(20,4) comment '总成交金额',
  s_strange_tradername string comment '营业部名称',
  s_strange_traderamount decimal(20,4) comment '营业部买卖金额',
  s_strange_buyamount decimal(20,4) comment '买入金额(元)',
  s_strange_sellamount decimal(20,4) comment '卖出金额(元)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharestylecoefficient;
create table if not exists ty_ods.w_asharestylecoefficient
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_change_date string comment '变动日期',
  date_closing_date string comment '引用数据的截止日期',
  style_coefficient decimal(20,4) comment '风格系数',
  growth_z decimal(20,4) comment '成长性Z分值',
  value_z decimal(20,4) comment '价值因子Z分值(ZVP)',
  avg_market_value decimal(20,4) comment '1年日均市值(万元)',
  gross_oper_rev decimal(20,4) comment '营业收入增长率(%)',
  gross_oper_netprofit decimal(20,4) comment '净利润增长率(%)',
  value_coefficient decimal(20,4) comment '调整市值系数',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharesupervisor;
create table if not exists ty_ods.w_asharesupervisor
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  s_info_dimension string comment '维度',
  s_info_dimension1 string comment '子维度',
  s_info_manager_name string comment '姓名',
  s_info_manager_startdate string comment '任职日期',
  s_info_manager_post string comment '职务',
  s_info_manid string comment '人物id',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharesupplier;
create table if not exists ty_ods.w_asharesupplier
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  s_info_dimension string comment '维度',
  s_info_dimension1 string comment '子维度',
  s_info_comp_name string comment '上游公司名称',
  s_info_comp_sname string comment '上游公司中文简称',
  s_info_compcode1 string comment '上游公司ID',
  report_period string comment '报告期',
  s_info_amount decimal(20,4) comment '金额',
  s_info_discloser string comment '披露公司ID',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharesurplusreserve;
create table if not exists ty_ods.w_asharesurplusreserve
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareswingreversetrendadj;
create table if not exists ty_ods.w_ashareswingreversetrendadj
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '日期',
  rc_50d bigint comment 'RC变化率指数(50日)',
  mi_a12d bigint comment 'MI动量指标A(12日)',
  mi_mi12d bigint comment 'MI动量指标MI?(12日)',
  micd_dif bigint comment 'MICD异同离差动力指数DIF(3,10,20日)',
  micd_micd bigint comment 'MICD异同离差动力指数MICD(3,10,20,10日)',
  rccd_dif bigint comment 'RCCD异同离差变化率指数DIF(59,21,28日)',
  rccd_rccd bigint comment 'RCCD异同离差变化率指数RCCD(59,21,28日)',
  srmi_9d bigint comment 'SRMI?MI修正指标(9日)',
  atr_tr14d bigint comment 'ATR真实波幅TR(14日)',
  atr_atr14d bigint comment 'ATR真实波幅ATR(14日)',
  mass bigint comment 'MASS梅丝线(9,25日)',
  vhf bigint comment 'VHF纵横指标(28日)',
  cvlt bigint comment 'CVLT佳庆离散指标(10日)',
  adtm_adtm bigint comment 'ADTM动态买卖气指标ADTM(23,8日)',
  adtm_adtmma bigint comment 'ADTM动态买卖气指标ADTMMA(23,8日)',
  bias bigint comment 'BIAS乖离率(12日)',
  kdj_k bigint comment 'KDJ随机指标K(9,3,3日)',
  kdj_d bigint comment 'KDJ随机指标D(9,3,3日)',
  kdj_j bigint comment 'KDJ随机指标J(9,3,3日)',
  rsi bigint comment 'RSI相对强弱指标(6日)',
  cci bigint comment 'CCI顺势指标(14日)',
  dbcd_dbcd bigint comment 'DBCD异同离差乖离率DBCD(5,16,76日)',
  dbcd_mm bigint comment 'DBCD异同离差乖离率MM(5,16,76日)',
  dpo bigint comment 'DPO区间震荡线DPO(20,6日)',
  dpo_madpo bigint comment 'DPO区间震荡线MADPO(20,6日)',
  lwr1 bigint comment 'LWR威廉指标LWR1(9,3,3日)',
  lwr2 bigint comment 'LWR威廉指标LWR2(9,3,3日)',
  roc bigint comment 'ROC变动速率ROC(12,6日)',
  roc_rocma bigint comment 'ROC变动速率ROCMA(12,6日)',
  si bigint comment 'SI摆动指标',
  slowkd_k bigint comment 'SLOWKD慢速K(9,3,3,5日)',
  slowkd_d bigint comment 'SLOWKD慢速D(9,3,3,5日)',
  wr bigint comment 'WR威廉指标(14日)',
  bias36 bigint comment 'B3612三减六日乖离BIAS36',
  bias612 bigint comment 'B3612三减六日乖离BIAS612',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareswingreversetrend;
create table if not exists ty_ods.w_ashareswingreversetrend
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '日期',
  rc_50d bigint comment 'RC变化率指数(50日)',
  mi_a12d bigint comment 'MI动量指标A(12日)',
  mi_mi12d bigint comment 'MI动量指标MI?(12日)',
  micd_dif bigint comment 'MICD异同离差动力指数DIF(3,10,20日)',
  micd_micd bigint comment 'MICD异同离差动力指数MICD(3,10,20,10日)',
  rccd_dif bigint comment 'RCCD异同离差变化率指数DIF(59,21,28日)',
  rccd_rccd bigint comment 'RCCD异同离差变化率指数RCCD(59,21,28日)',
  srmi_9d bigint comment 'SRMI?MI修正指标(9日)',
  atr_tr14d bigint comment 'ATR真实波幅TR(14日)',
  atr_atr14d bigint comment 'ATR真实波幅ATR(14日)',
  mass bigint comment 'MASS梅丝线(9,25日)',
  vhf bigint comment 'VHF纵横指标(28日)',
  cvlt bigint comment 'CVLT佳庆离散指标(10日)',
  adtm_adtm bigint comment 'ADTM动态买卖气指标ADTM(23,8日)',
  adtm_adtmma bigint comment 'ADTM动态买卖气指标ADTMMA(23,8日)',
  bias bigint comment 'BIAS乖离率(12日)',
  kdj_k bigint comment 'KDJ随机指标K(9,3,3日)',
  kdj_d bigint comment 'KDJ随机指标D(9,3,3日)',
  kdj_j bigint comment 'KDJ随机指标J(9,3,3日)',
  rsi bigint comment 'RSI相对强弱指标(6日)',
  cci bigint comment 'CCI顺势指标(14日)',
  dbcd_dbcd bigint comment 'DBCD异同离差乖离率DBCD(5,16,76日)',
  dbcd_mm bigint comment 'DBCD异同离差乖离率MM(5,16,76日)',
  dpo bigint comment 'DPO区间震荡线DPO(20,6日)',
  dpo_madpo bigint comment 'DPO区间震荡线MADPO(20,6日)',
  lwr1 bigint comment 'LWR威廉指标LWR1(9,3,3日)',
  lwr2 bigint comment 'LWR威廉指标LWR2(9,3,3日)',
  roc bigint comment 'ROC变动速率ROC(12,6日)',
  roc_rocma bigint comment 'ROC变动速率ROCMA(12,6日)',
  si bigint comment 'SI摆动指标',
  slowkd_k bigint comment 'SLOWKD慢速K(9,3,3,5日)',
  slowkd_d bigint comment 'SLOWKD慢速D(9,3,3,5日)',
  wr bigint comment 'WR威廉指标(14日)',
  bias36 bigint comment 'B3612三减六日乖离BIAS36',
  bias612 bigint comment 'B3612三减六日乖离BIAS612',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharetaxespayable;
create table if not exists ty_ods.w_asharetaxespayable
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  vat decimal(20,4) comment '增值税',
  business_tax decimal(20,4) comment '营业税',
  corporate_income_tax decimal(20,4) comment '企业所得税',
  urban_maintenance_tax decimal(20,4) comment '城市维护建设税',
  property_tax decimal(20,4) comment '房产税',
  personal_income_tax decimal(20,4) comment '个人所得税',
  sale_tax decimal(20,4) comment '消费税',
  land_holding_tax decimal(20,4) comment '土地使用税',
  stamp_duty decimal(20,4) comment '印花税',
  vehicle_usage_tax decimal(20,4) comment '车船使用税',
  land_value_added_tax decimal(20,4) comment '土地增值税',
  resource_tax decimal(20,4) comment '资源税',
  other decimal(20,4) comment '其他',
  total decimal(20,4) comment '合计',
  memo string comment '备注',
  statement_type string comment '报表类型',
  education_surcharge decimal(20,4) comment '教育费附加',
  flood_control_fund decimal(20,4) comment '防洪基金',
  compensation_mineral_resources decimal(20,4) comment '矿产资源补偿费',
  vehicle_purchase_surcharge decimal(20,4) comment '车辆购置附加费',
  agriculture_forestry_tax decimal(20,4) comment '农林特产税',
  local_education_fee decimal(20,4) comment '地方教育费附加',
  price_control_fund decimal(20,4) comment '价格调控基金',
  statement_type_code bigint comment '报表类型代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharetaxespay;
create table if not exists ty_ods.w_asharetaxespay
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharetaxrate;
create table if not exists ty_ods.w_asharetaxrate
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  report_period string comment '报告期',
  tax_rate decimal(20,4) comment '税率(%)',
  begin_mon bigint comment '起始月份',
  end_mon bigint comment '终止月份',
  discount_reason string comment '税项优惠原因',
  memo string comment '备注',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharetaxsurcharge;
create table if not exists ty_ods.w_asharetaxsurcharge
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharetechindicators;
create table if not exists ty_ods.w_asharetechindicators
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '日期',
  volume_ratio_5d decimal(20,8) comment '量比(5日)',
  vam_1m decimal(20,8) comment 'VMA量简单移动平均(1月)',
  vam_5m decimal(20,8) comment 'VMA量简单移动平均(5日)',
  vam_22m decimal(20,8) comment 'VMA量简单移动平均(22日)',
  vam_60m decimal(20,8) comment 'VMA量简单移动平均(60日)',
  ama_1w decimal(20,8) comment 'AMA额简单移动平均(1周)',
  ama_1m decimal(20,8) comment 'AMA额简单移动平均(1月)',
  ama_1q decimal(20,8) comment 'AMA额简单移动平均(1季)',
  vmacd decimal(20,8) comment 'VMACD量指数平滑异同平均DIF(12,26,9日)',
  vmacd_dea decimal(20,8) comment 'VMACD量指数平滑异同平均DEA(12,26,9日)',
  vmacd_macd decimal(20,8) comment 'VMACD量指数平滑异同平均MACD(12,26,9日)',
  vosc decimal(20,8) comment 'VOSC成交量震荡(12,26日)',
  tapi_16d decimal(20,8) comment 'TAPI加权指数成交值TAPI(6日)',
  tapi_6d decimal(20,8) comment 'TAPI加权指数成交值TAPIMA(6日)',
  vstd_10d decimal(20,8) comment 'VSTD成交量标准差(10日)',
  vmacd_ema12d decimal(20,8) comment 'VMACD量指数平滑异同平均EMA(成交量,12日)',
  vmacd_ema26d decimal(20,8) comment 'VMACD量指数平滑异同平均EMA(成交量,26日)',
  vrsi_6d decimal(20,8) comment 'VRSI量相对强弱(6日)',
  vroc_12d decimal(20,8) comment 'VROC量变动速率(12日)',
  sobv decimal(20,8) comment 'SOBV能量潮',
  vr_26d decimal(20,8) comment 'VR成交量比率(26日)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharetotalinvest;
create table if not exists ty_ods.w_asharetotalinvest
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharetrustinvestmenttot;
create table if not exists ty_ods.w_asharetrustinvestmenttot
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_date string comment '公告日期',
  rp_sale_product decimal(20,4) comment '向关联方销售产品金额合计(万元)',
  contro_party_capital_amount decimal(20,4) comment '向控股方提供资金发生额合计(万元)',
  contro_party_capital_balance decimal(20,4) comment '向控股方提供资金余额合计(万元)',
  rp_amount decimal(20,4) comment '向关联方提供资金发生额合计(万元)',
  rp_balance decimal(20,4) comment '向关联方提供资金余额合计(万元)',
  amount_funds_available decimal(20,4) comment '关联方向上市公司提供资金发生额合计(万元)',
  funding_balance decimal(20,4) comment '关联方向上市公司提供资金余额合计(万元)',
  fp_amount_tot decimal(20,4) comment '委托理财累计金额(万元)',
  fp_balance decimal(20,4) comment '委托理财余额(万元)',
  fp_overdue_amount decimal(20,4) comment '委托理财逾期未收回的本金和收益累计金额(万元)',
  fp_addup_profit decimal(20,4) comment '委托理财收益累计金额(万元)',
  rp_sale_product_ratio decimal(20,4) comment '向关联方销售产品金额占比(%)',
  rp_purchase_amount decimal(20,4) comment '向关联方采购产品金额合计(万元)',
  rp_purchase_ratio decimal(20,4) comment '向关联方采购产品金额占比(%)',
  rp_sale_product_est decimal(20,4) comment '向关联方销售产品预计金额合计(万元)',
  rp_labour_services_est decimal(20,4) comment '向关联方提供劳务预计金额合计(万元)',
  rp_purchase_amount_est decimal(20,4) comment '向关联方采购产品预计金额合计(万元)',
  rp_accept_service_est decimal(20,4) comment '向关联方接受劳务预计金额合计(万元)',
  rp_other_transactions decimal(20,4) comment '向关联方其他交易预计金额合计(万元)',
  pricing_principle string comment '定价原则',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharettmandmrq;
create table if not exists ty_ods.w_asharettmandmrq
(
  object_id string comment '对象ID',
  s_info_windcode string comment '万得代码',
  report_period string comment '报告期',
  statement_type string comment '报表类型',
  s_fa_or_ttm decimal(20,4) comment '营业收入(TTM)',
  s_fa_cost_ttm decimal(20,4) comment '营业成本-非金融类(TTM)',
  s_fa_expense_ttm decimal(20,4) comment '营业支出-金融类(TTM)',
  s_fa_grossmargin_ttm decimal(20,4) comment '毛利(TTM)',
  s_fa_operateincome_ttm decimal(20,4) comment '经营活动净收益(TTM)',
  s_fa_investincome_ttm decimal(20,4) comment '价值变动净收益(TTM)',
  s_fa_op_ttm decimal(20,4) comment '营业利润(TTM)',
  s_fa_ebt_ttm decimal(20,4) comment '利润总额(TTM)',
  s_fa_profit_ttm decimal(20,4) comment '净利润(TTM)',
  s_fa_netprofit_ttm decimal(20,4) comment '归属于母公司的净利润(TTM)',
  s_fa_gr_ttm decimal(20,4) comment '营业总收入(TTM)',
  s_fa_gc_ttm decimal(20,4) comment '营业总成本(TTM)',
  s_fa_cashflow_ttm decimal(20,4) comment '现金净流量(TTM)',
  s_fa_operatecashflow_ttm decimal(20,4) comment '经营活动现金净流量(TTM)',
  s_fa_investcashflow_ttm decimal(20,4) comment '投资活动现金净流量(TTM)',
  s_fa_financecashflow_ttm decimal(20,4) comment '筹资活动现金净流量(TTM)',
  s_fa_asset_mrq decimal(20,4) comment '资产总计(MRQ)',
  s_fa_debt_mrq decimal(20,4) comment '负债合计(MRQ)',
  s_fa_totalequity_mrq decimal(20,4) comment '股东权益(MRQ)',
  s_fa_equity_mrq decimal(20,4) comment '归属于母公司的股东权益(MRQ)',
  s_fa_equity_new decimal(20,4) comment '归属于母公司的股东权益(最新)',
  s_fa_netprofitmargin_ttm decimal(20,4) comment '销售净利率(TTM)',
  s_fa_grossprofitmargin_ttm decimal(20,4) comment '销售毛利率(TTM)',
  s_fa_expensetosales_ttm decimal(20,4) comment '销售期间费用率(TTM)',
  s_fa_profittogr_ttm decimal(20,4) comment '净利润/营业总收入(TTM)',
  s_fa_operateexpensetogr_ttm decimal(20,4) comment '销售费用/营业总收入(TTM)',
  s_fa_adminexpensetogr_ttm decimal(20,4) comment '管理费用/营业总收入(TTM)',
  s_fa_finaexpensetogr_ttm decimal(20,4) comment '财务费用/营业总收入(TTM)',
  s_fa_impairtogr_ttm decimal(20,4) comment '资产减值损失/营业总收入(TTM)',
  s_fa_gctogr_ttm decimal(20,4) comment '营业总成本/营业总收入(TTM)',
  s_fa_optogr_ttm decimal(20,4) comment '营业利润/营业总收入(TTM)',
  s_fa_roa_ttm decimal(20,4) comment '总资产净利率(TTM)',
  s_fa_roa2_ttm decimal(20,4) comment '总资产报酬率(TTM)',
  s_fa_roe_ttm decimal(20,4) comment '净资产收益率(TTM)',
  s_fa_operateincometoebt_ttm decimal(20,4) comment '经营活动净收益/利润总额(TTM)',
  s_fa_investincometoebt_ttm decimal(20,4) comment '价值变动净收益/利润总额(TTM)',
  s_fa_nonoperateprofittoebt_ttm decimal(20,4) comment '营业外收支净额/利润总额(TTM)',
  s_fa_salescashintoor_ttm decimal(20,4) comment '销售商品提供劳务收到的现金/营业收入(TTM)',
  s_fa_ocftoor_ttm decimal(20,4) comment '经营活动产生的现金流量净额/营业收入(TTM)',
  s_fa_ocftooperateincome_ttm decimal(20,4) comment '经营活动产生的现金流量净额/经营活动净收益(TTM)',
  s_fa_eps_ttm decimal(20,4) comment '每股收益(TTM)',
  s_fa_orps_ttm decimal(20,4) comment '每股营业收入(TTM)',
  s_fa_ocfps_ttm decimal(20,4) comment '每股经营活动产生的现金流量净额(TTM)',
  s_fa_cfps_ttm decimal(20,4) comment '每股现金流量净额(TTM)',
  s_fa_bps_new decimal(20,4) comment '每股净资产(最新)',
  s_fa_salescashin_ttm decimal(20,4) comment '销售商品提供劳务收到的现金(TTM)',
  s_fa_operateexpense_ttm decimal(20,4) comment '销售费用(TTM) ',
  s_fa_adminexpense_ttm decimal(20,4) comment '管理费用(TTM) ',
  s_fa_finaexpense_ttm decimal(20,4) comment '财务费用(TTM) ',
  s_fa_expense decimal(20,4) comment '期间费用(TTM) ',
  s_fa_nonoperateprofit_ttm decimal(20,4) comment '营业外收支净额(TTM)',
  s_fa_impairment_ttm decimal(20,4) comment '资产减值损失',
  s_fa_ebit_ttm decimal(20,4) comment '息税前利润',
  s_fa_investcapital_mrq decimal(20,4) comment '全部投入资本(MRQ) ',
  fa_roic_ttm decimal(20,4) comment '投入资本回报率ROIC(TTM)',
  s_stm_bsmrq decimal(20,4) comment '固定资产合计(MRQ)',
  s_fa_nonopprofit_ttm decimal(20,4) comment '非营业利润(TTM)',
  s_fa_prefinexp_op_ttm decimal(20,4) comment '扣除财务费用前营业利润(TTM)',
  s_fa_optoebt_ttm decimal(20,4) comment '营业利润／利润总额(TTM)',
  s_fa_noptoebt_ttm decimal(20,4) comment '非营业利润／利润总额(TTM)',
  s_fa_taxtoebt_ttm decimal(20,4) comment '税项／利润总额(TTM)',
  s_fa_optoor_ttm decimal(20,4) comment '营业利润／营业收入(TTM)',
  s_fa_ebttoor_ttm decimal(20,4) comment '利润总额／营业收入(TTM)',
  s_fa_prefinexpoptoor_ttm decimal(20,4) comment '扣除融资费用前营业利润／营业收入(TTM)',
  s_fa_netprofittoor_ttm decimal(20,4) comment '归属母公司股东的净利润／营业收入(TTM)',
  s_fa_prefinexpoptoebt_ttm decimal(20,4) comment '扣除融资费用前营业利润／利润总额(TTM)',
  s_fa_ocftoop_ttm decimal(20,4) comment '经营活动产生的现金流量净额／营业利润(TTM)',
  roa_exclminintinc_ttm decimal(20,4) comment '总资产净利率-不含少数股东损益(TTM)',
  s_fa_debttoassets_mrq decimal(20,4) comment '资产负债率(MRQ)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharettmhis;
create table if not exists ty_ods.w_asharettmhis
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  ann_dt string comment '公告日期',
  report_period string comment '截止日期',
  statement_type string comment '报表类型',
  tot_oper_rev_ttm decimal(20,4) comment '营业总收入(TTM)',
  oper_rev_ttm decimal(20,4) comment '营业收入(TTM)',
  net_profit_ttm decimal(20,4) comment '净利润(TTM)',
  net_profit_parent_comp_ttm decimal(20,4) comment '归属于母公司的净利润(TTM)',
  net_cash_flows_oper_act_ttm decimal(20,4) comment '经营活动现金净流量(TTM)',
  net_incr_cash_cash_equ_ttm decimal(20,4) comment '现金净流量(TTM)',
  crncy_code string comment '货币代码',
  s_fa_cost_ttm decimal(20,4) comment '营业成本-非金融类(TTM)',
  s_fa_expense_ttm decimal(20,4) comment '营业支出-金融类(TTM)',
  s_fa_grossmargin_ttm decimal(20,4) comment '毛利(TTM)',
  s_fa_operateincome_ttm decimal(20,4) comment '经营活动净收益(TTM)',
  s_fa_investincome_ttm decimal(20,4) comment '价值变动净收益(TTM)',
  s_fa_op_ttm decimal(20,4) comment '营业利润(TTM)',
  s_fa_ebt_ttm decimal(20,4) comment '利润总额(TTM)',
  s_fa_gr_ttm decimal(20,4) comment '营业总收入(TTM)',
  s_fa_gc_ttm decimal(20,4) comment '营业总成本(TTM)',
  s_fa_investcashflow_ttm decimal(20,4) comment '投资活动现金净流量(TTM)',
  s_fa_financecashflow_ttm decimal(20,4) comment '筹资活动现金净流量(TTM)',
  s_fa_asset_mrq decimal(20,4) comment '资产总计(MRQ)',
  s_fa_debt_mrq decimal(20,4) comment '负债合计(MRQ)',
  s_fa_totalequity_mrq decimal(20,4) comment '股东权益(MRQ)',
  s_fa_equity_mrq decimal(20,4) comment '归属于母公司的股东权益(MRQ)',
  s_fa_netprofitmargin_ttm decimal(20,4) comment '销售净利率(TTM)',
  s_fa_grossprofitmargin_ttm decimal(20,4) comment '销售毛利率(TTM)',
  s_fa_expensetosales_ttm decimal(20,4) comment '销售期间费用率(TTM)',
  s_fa_profittogr_ttm decimal(20,4) comment '净利润/营业总收入(TTM)',
  s_fa_operateexpensetogr_ttm decimal(20,4) comment '销售费用/营业总收入(TTM)',
  s_fa_adminexpensetogr_ttm decimal(20,4) comment '管理费用/营业总收入(TTM)',
  s_fa_finaexpensetogr_ttm decimal(20,4) comment '财务费用/营业总收入(TTM)',
  s_fa_impairtogr_ttm decimal(20,4) comment '资产减值损失/营业总收入(TTM)',
  s_fa_gctogr_ttm decimal(20,4) comment '营业总成本/营业总收入(TTM)',
  s_fa_optogr_ttm decimal(20,4) comment '营业利润/营业总收入(TTM)',
  s_fa_roa_ttm decimal(20,4) comment '总资产净利率(TTM)',
  s_fa_roa2_ttm decimal(20,4) comment '总资产报酬率(TTM)',
  s_fa_roe_ttm decimal(20,4) comment '净资产收益率(TTM)',
  s_fa_operateincometoebt_ttm decimal(20,4) comment '经营活动净收益/利润总额(TTM)',
  s_fa_investincometoebt_ttm decimal(20,4) comment '价值变动净收益/利润总额(TTM)',
  s_fa_nonoperateprofittoebt_ttm decimal(20,4) comment '营业外收支净额/利润总额(TTM)',
  s_fa_salescashintoor_ttm decimal(20,4) comment '销售商品提供劳务收到的现金/营业收入(TTM)',
  s_fa_ocftoor_ttm decimal(20,4) comment '经营活动产生的现金流量净额/营业收入(TTM)',
  s_fa_ocftooperateincome_ttm decimal(20,4) comment '经营活动产生的现金流量净额/经营活动净收益(TTM)',
  s_fa_deductedprofit_ttm decimal(20,4) comment '扣除非经常性损益后的净利润(TTM)',
  s_fa_ebitda_ttm_inverse decimal(20,4) comment 'EBITDA(TTM反推法)',
  s_fa_ebitda_ttm decimal(20,4) comment 'EBITDA(TTM)',
  s_fa_ebit_ttm decimal(20,4) comment 'EBIT(TTM)',
  fa_roic_ttm decimal(20,4) comment '投入资本回报率(TTM)',
  s_fa_salescashin_ttm decimal(20,4) comment '销售商品提供劳务收到的现金(TTM)',
  s_fa_operateexpense_ttm decimal(20,4) comment '销售费用(TTM)',
  s_fa_adminexpense_ttm decimal(20,4) comment '管理费用(TTM)',
  s_fa_finaexpense_ttm decimal(20,4) comment '财务费用(TTM)',
  s_fa_expense decimal(20,4) comment '期间费用(TTM)',
  s_fa_nonoperateprofit_ttm decimal(20,4) comment '营业外收支净额(TTM)',
  s_fa_impairment_ttm decimal(20,4) comment '资产减值损失(TTM)',
  s_fa_ebit_ttm_inverse decimal(20,4) comment 'EBIT(TTM反推法)',
  s_fa_investcapital_mrq decimal(20,4) comment '全部投入资本(MRQ)',
  fa_roic_ttm2 decimal(20,4) comment '投入资本回报率ROIC(TTM)',
  s_stm_bsmrq decimal(20,4) comment '固定资产合计(MRQ)',
  s_fa_nonopprofit_ttm decimal(20,4) comment '非营业利润(TTM)',
  s_fa_prefinexp_op_ttm decimal(20,4) comment '扣除财务费用前营业利润(TTM)',
  s_fa_optoebt_ttm decimal(20,4) comment '营业利润/利润总额(TTM)',
  s_fa_noptoebt_ttm decimal(20,4) comment '非营业利润/利润总额(TTM)',
  s_fa_taxtoebt_ttm decimal(20,4) comment '税项/利润总额(TTM)',
  s_fa_optoor_ttm decimal(20,4) comment '营业利润/营业收入(TTM)',
  s_fa_ebttoor_ttm decimal(20,4) comment '利润总额/营业收入(TTM)',
  s_fa_prefinexpoptoor_ttm decimal(20,4) comment '扣除融资费用前营业利润/营业收入(TTM)',
  s_fa_netprofittoor_ttm decimal(20,4) comment '归属母公司股东的净利润/营业收入(TTM)',
  s_fa_prefinexpoptoebt_ttm decimal(20,4) comment '扣除融资费用前营业利润/利润总额(TTM)',
  s_fa_ocftoop_ttm decimal(20,4) comment '经营活动产生的现金流量净额/营业利润(TTM)',
  roa_exclminintinc_ttm decimal(20,4) comment '总资产净利率-不含少数股东损益(TTM)',
  s_fa_debttoassets_mrq decimal(20,4) comment '资产负债率(MRQ)',
  int_exp_ttm decimal(20,4) comment '利息支出(TTM)',
  inc_tax_ttm decimal(20,4) comment '所得税(TTM)',
  minority_int_ttm decimal(20,4) comment '少数股东权益(TTM)',
  continuous_net_op_ttm decimal(20,4) comment '持续经营净利润(TTM)',
  noncontinuous_net_op_ttm decimal(20,4) comment '非持续经营净利润(TTM)',
  nonnetoptotaxprofit decimal(20,4) comment '非持续经营净利润/税后利润(TTM)',
  netoptotaxprofit decimal(20,4) comment '持续经营净利润/税后利润(TTM)',
  s_info_windcode string comment 'Wind代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareundistributedprofit;
create table if not exists ty_ods.w_ashareundistributedprofit
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  item_type_name string comment '项目类别名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ashareweeklyyield;
create table if not exists ty_ods.w_ashareweeklyyield
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '截至日期',
  crncy_code string comment '货币代码',
  s_wq_pctchange decimal(20,4) comment '周收益率(%)',
  s_wq_turn decimal(20,4) comment '周换手率(合计)(%)',
  s_wq_avgturn decimal(20,4) comment '周换手率(算术平均)(%)',
  s_wq_amount decimal(20,4) comment '周成交金额(万元)',
  s_risk_betar100 decimal(20,4) comment 'BETA (100周)',
  s_wq_varpctchange100 decimal(20,4) comment '周收益率方差(100周)',
  s_wq_devpctchange100 decimal(20,4) comment '周收益率标准差(100周)',
  s_wq_avgpctchange100 decimal(20,4) comment '周收益率平均值(100周)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_asharewinning;
create table if not exists ty_ods.w_asharewinning
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_dt string comment '公告日期',
  last_digit bigint comment '末尾位数',
  winning_number string comment '中签号码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



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



drop table if exists ty_ods.w_bondissueauditprocess;
create table if not exists ty_ods.w_bondissueauditprocess
(
  object_id string comment '对象ID',
  s_info_compname string comment '公司名称(申请企业)',
  s_info_compcode string comment '公司ID',
  ann_dt string comment '公告日期',
  end_dt string comment '截止日期',
  type_code bigint comment '审核类型代码',
  type_name string comment '申请事项',
  s_info_process string comment '说明',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_bondissueregistration;
create table if not exists ty_ods.w_bondissueregistration
(
  object_id string comment '对象ID',
  s_info_compname string comment '公司名称',
  s_info_compcode string comment '公司ID',
  ann_dt string comment '[内部]公告日期',
  meeting_dt string comment '注册会议日期',
  int_amount decimal(20,4) comment '初始注册金额(亿元)',
  change_amount decimal(20,4) comment '变更后注册金额(亿元)',
  crncy_code string comment '货币代码',
  filelocation string comment '备案场所',
  filenum string comment '文件号',
  end_dt_effective string comment '有效期截止日',
  end_dt_firstissue string comment '首期发行截止日',
  is_install bigint comment '是否可分期发行',
  leadunderwriter string comment '主承销商名称',
  type_code bigint comment '注册债券类型代码',
  abs_managerid string comment 'ABS产品管理人公司ID',
  abs_manager string comment 'ABS产品管理人/SPV',
  abs_name string comment 'ABS产品名称',
  num bigint comment '[内部]序号',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_bondissueregistunderwriters;
create table if not exists ty_ods.w_bondissueregistunderwriters
(
  object_id string comment '对象ID',
  s_info_compname string comment '公司名称',
  s_info_compcode string comment '公司id',
  ann_dt string comment '公告日期',
  underwriter string comment '承销商名称',
  underwriterid string comment '承销商公司ID',
  b_relation_typcode string comment '关系类型代码',
  start_dt string comment '起始日期',
  end_dt string comment '终止日期',
  cur_sign bigint comment '最新标志',
  bondtype_code bigint comment '债券类型代码',
  bondtype string comment '债券类型',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_bondkeytermduration;
create table if not exists ty_ods.w_bondkeytermduration
(
  object_id string comment '对象ID',
  s_info_windcode string comment '债券Wind代码',
  trade_dt string comment '交易日期',
  dura1m decimal(20,8) comment '1月久期',
  dura3m decimal(20,8) comment '3月久期',
  dura6m decimal(20,8) comment '6月久期',
  dura1y decimal(20,8) comment '1年久期',
  dura2y decimal(20,8) comment '2年久期',
  dura3y decimal(20,8) comment '3年久期',
  dura4y decimal(20,8) comment '4年久期',
  dura5y decimal(20,8) comment '5年久期',
  dura7y decimal(20,8) comment '7年久期',
  dura9y decimal(20,8) comment '9年久期',
  dura10y decimal(20,8) comment '10年久期',
  dura15y decimal(20,8) comment '15年久期',
  dura20y decimal(20,8) comment '20年久期',
  dura30y decimal(20,8) comment '30年久期',
  durast decimal(20,8) comment '短边久期',
  duralg decimal(20,8) comment '长边久期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbankdepositstructure;
create table if not exists ty_ods.w_cbankdepositstructure
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  statement_type bigint comment '报表类型代码',
  crncy_code string comment '货币代码',
  crncy_type_code bigint comment '币种类型代码',
  loan_type_code bigint comment '项目类别代码',
  deposit_item_code bigint comment '存款项目代码',
  ann_item string comment '存款项目公布名称',
  total_deposit decimal(20,4) comment '存款余额',
  ave_deposit decimal(20,4) comment '存款平均余额',
  interest_cost decimal(20,4) comment '存款利息支出',
  average_yield decimal(20,4) comment '存款平均成本率',
  memo string comment '备注',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbankloanstructure;
create table if not exists ty_ods.w_cbankloanstructure
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  statement_type bigint comment '报表类型代码',
  crncy_code string comment '货币代码',
  crncy_type_code bigint comment '币种类型代码',
  loan_type_code bigint comment '项目类别代码',
  ann_item string comment '[内部]公布名称',
  loan_item_code bigint comment '贷款项目代码',
  total_loans decimal(20,4) comment '贷款余额',
  ave_loans decimal(20,4) comment '贷款平均余额',
  interest_income decimal(20,4) comment '贷款利息收入',
  average_yield decimal(20,4) comment '贷款平均收益率',
  non_performing_loans decimal(20,4) comment '不良贷款余额',
  non_performing_loans_ratio decimal(20,4) comment '不良贷款率(%)',
  memo string comment '备注',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbillbtransdiscountquote;
create table if not exists ty_ods.w_cbillbtransdiscountquote
(
  object_id string comment '对象ID',
  trade_dt string comment '日期',
  trade_tm string comment '时间',
  b_info_tradetypcode bigint comment '业务类型代码',
  b_info_tradeside bigint comment '交易方向',
  b_info_amountmn decimal(20,4) comment '报价金额',
  b_info_interest decimal(20,8) comment '利率',
  b_anal_ptm string comment '剩余期限',
  b_info_accepttype bigint comment '承兑行类型代码',
  b_info_billtype bigint comment '票据类型代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
 COMMENT '中国银行间票据转贴现报价'
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbillpubsummon;
create table if not exists ty_ods.w_cbillpubsummon
(
  object_id string comment '对象ID',
  ann_dt string comment '公告日期',
  b_info_billno string comment '票号',
  b_info_billtype bigint comment '票据类型代码',
  b_info_facevalue decimal(20,4) comment '票面金额',
  issue_dt string comment '出票日期',
  maturity_dt string comment '到期日',
  b_info_drawer string comment '出票人',
  b_info_acceptbank string comment '付款银行/付款人',
  b_info_summontype string comment '状态类别',
  b_info_applicant string comment '申请人',
  b_info_noticereleaser string comment '发布机构',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondaccountsreceivable;
create table if not exists ty_ods.w_cbondaccountsreceivable
(
  object_id string comment '对象ID',
  memo string comment '备注',
  s_info_compcode string comment '公司ID',
  report_period string comment '报告期',
  debtor_name string comment '债务人名称',
  arrears decimal(20,4) comment '金额',
  rate decimal(20,4) comment '比例(%)',
  currency_code string comment '货币代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondagingstructure;
create table if not exists ty_ods.w_cbondagingstructure
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  statement_type_name string comment '报表类型名称',
  memo string comment '备注',
  aging string comment '账龄',
  currency_code string comment '货币代码',
  amount_money decimal(20,4) comment '金额',
  rate decimal(20,4) comment '比例(%)',
  bad_debt_preparation decimal(20,4) comment '坏账准备',
  report_period string comment '报告期',
  min_aging decimal(20,4) comment '最小账龄(年)',
  max_aging decimal(20,4) comment '最大账龄(年)',
  classification_criteria string comment '分类标准',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondanalysiscnm;
create table if not exists ty_ods.w_cbondanalysiscnm
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '日期',
  anal_dirty decimal(20,4) comment '估价全价',
  anal_net decimal(20,4) comment '估价净价',
  anal_yield decimal(20,4) comment '估价收益率',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondapprovalinformation;
create table if not exists ty_ods.w_cbondapprovalinformation
(
  object_id string comment '对象ID',
  ann_date string comment '更新日期',
  b_info_fullname string comment '债券名称',
  bondtype bigint comment '债券类型',
  amount decimal(24,8) comment '计划发行金额(亿元)',
  s_info_compname string comment '原始权益人名称',
  s_info_compcode string comment '发行人公司ID',
  leadunderwriter string comment '主承销商/管理人',
  s_info_exchmarket string comment '交易所代码',
  filenum string comment '交易所确认文件文号',
  progress_code bigint comment '项目状态',
  project_typecode bigint comment '项目类型',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondbillissuance;
create table if not exists ty_ods.w_cbondbillissuance
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  bill_name string comment '票据名称',
  issue_ann_date string comment '发行公告日期',
  list_ann_date string comment '上市公告日期',
  issue_date string comment '发行日期',
  list_date string comment '上市日期',
  ptotal_num_issues decimal(20,4) comment '计划发行总量(万元)',
  total_num_issues decimal(20,4) comment '实际发行总量(万元)',
  issue_type string comment '发行方式',
  s_info_par decimal(20,4) comment '面额',
  term decimal(20,4) comment '期限(月)',
  paymentdate string comment '缴款日',
  carry_date string comment '起息日',
  maturity_date string comment '到期日',
  tender_method string comment '招标方式',
  issue_price decimal(20,4) comment '发行价格',
  tendrst_referyield decimal(20,4) comment '利率/参考收益率（%）',
  issue_gobject string comment '发行对象',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondbillrate;
create table if not exists ty_ods.w_cbondbillrate
(
  object_id string comment '对象ID',
  b_info_ratetype string comment '利率类型',
  trade_dt string comment '交易日期',
  b_info_rate decimal(20,6) comment '利率(%)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondblocktrade;
create table if not exists ty_ods.w_cbondblocktrade
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  sec_id string comment '证券id',
  trade_dt string comment '交易日期',
  s_block_price decimal(20,4) comment '成交价（元）',
  s_block_volume decimal(20,4) comment '成交量（万股）',
  s_block_amount decimal(20,4) comment '成交金额（万元）',
  crncy_code string comment '货币代码',
  s_block_buyername string comment '买方营业部',
  s_block_sellername string comment '卖方营业部',
  s_block_frequency decimal(20,4) comment '笔数',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondcalendar;
create table if not exists ty_ods.w_cbondcalendar
(
  object_id string comment '对象ID',
  trade_days string comment '交易日',
  s_info_exchmarket string comment '交易所英文简称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondcollateralinformation;
create table if not exists ty_ods.w_cbondcollateralinformation
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'wind代码',
  b_agency_grnttypecode bigint comment '担保方式代码',
  b_agency_collateraltypecode bigint comment '担保物类型代码',
  eqy_targetcomp string comment '股权标的',
  b_guaranteeowner string comment '担保物所有方',
  b_guaranteeowner_compcode string comment '担保物所有方公司ID',
  b_info_collateralnumber bigint comment '担保物数量',
  b_info_collateralpunit string comment '担保物单位',
  b_info_collateralvalue bigint comment '担保物价值',
  crncy_code string comment '货币代码',
  b_info_guarintroduction string comment '担保情况',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbonddevaluationpreparation;
create table if not exists ty_ods.w_cbonddevaluationpreparation
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  s_development_cost decimal(15,2) comment '开发成本',
  s_low_value_consumables decimal(15,2) comment '低值易耗品',
  s_finished_product decimal(15,2) comment '产成品',
  s_office_equipment decimal(15,2) comment '办公及其他设备',
  s_other_equipment decimal(15,2) comment '其他设备',
  s_land_use_right decimal(15,2) comment '土地使用权',
  s_materials_in_transit decimal(15,2) comment '在途物资',
  s_in_product decimal(15,2) comment '在产品',
  s_developing_products decimal(15,2) comment '开发产品',
  s_part_prepared_products decimal(15,2) comment '自制半成品',
  s_right_use_housing decimal(15,2) comment '职工住房使用权',
  s_packaging decimal(15,2) comment '包装物',
  statement_type string comment '报表类型',
  statement_type_code bigint comment '报表类型代码',
  s_bad_debt_tot decimal(20,4) comment '坏账准备合计',
  s_acct_rcv decimal(20,4) comment '应收账款',
  s_oth_rcv decimal(20,4) comment '其他应收款',
  s_short_term_inv_fall decimal(20,4) comment '短期投资跌价准备合计',
  s_stock_investment decimal(20,4) comment '股票投资',
  s_bond_investment decimal(20,4) comment '债券投资',
  s_stock_price_drop1 decimal(20,4) comment '存货跌价准备合计',
  s_inventory_goods decimal(20,4) comment '库存商品',
  s_raw_material decimal(20,4) comment '原材料',
  s_long_inv_depre_res_tot decimal(20,4) comment '长期投资减值准备合计',
  s_equity_investment decimal(20,4) comment '长期股权投资减值准备',
  s_long_debt_investments decimal(20,4) comment '长期债权投资',
  s_fixed_asset_impairment decimal(20,4) comment '固定资产减值准备',
  s_building1 decimal(20,4) comment '房屋、建筑物',
  s_machinery decimal(20,4) comment '机器设备',
  s_intangible_assets_devalue decimal(20,4) comment '无形资产减值准备',
  s_patent_right decimal(20,4) comment '专利权',
  s_trademark_right decimal(20,4) comment '商标权',
  s_con_project_devalue decimal(20,4) comment '在建工程减值准备',
  s_loan_mandate_devalue decimal(20,4) comment '委托贷款减值准备',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  s_special_equipment decimal(20,4) comment '专用设备',
  s_conveyance decimal(20,4) comment '运输工具',
  s_communication decimal(20,4) comment '通讯设备',
  s_electronic decimal(20,4) comment '电子设备',
  s_stock_price_drop decimal(20,4) comment '自营证券跌价准备',
  s_pre_bad_loans decimal(20,4) comment '贷款呆账准备',
  s_turnover decimal(20,4) comment '周转材料',
  s_expend_assets decimal(20,4) comment '消耗性生物资产',
  s_sell_financial_assets decimal(20,4) comment '可供出售金融资产减值准备',
  s_hold_expiry_investment decimal(20,4) comment '持有至到期投资减值准备',
  s_building decimal(20,4) comment '房屋、建筑物',
  s_investment_real_estate decimal(20,4) comment '投资性房地产减值准备',
  s_land_use_right1 decimal(20,4) comment '土地使用权',
  s_material_devalue decimal(20,4) comment '工程物资减值准备',
  s_biological_assets_devalue decimal(20,4) comment '生产性生物资产减值准备',
  s_biological_assets_devalue1 decimal(20,4) comment '成熟生产性生物资产减值准备',
  s_oil_gas_assets_devalue decimal(20,4) comment '油气资产减值准备',
  s_goodwill_devalue decimal(20,4) comment '商誉减值准备',
  s_other decimal(20,4) comment '其他',
  s_loan_loss_preparation decimal(20,4) comment '贷款损失准备',
  s_interbank_payments_devalue decimal(20,4) comment '存放同业款项减值准备',
  s_demolition_capital_devalue decimal(20,4) comment '拆出资金减值准备',
  s_debt_set_devalue decimal(20,4) comment '抵债资产减值准备',
  s_back_sale_financial_assets decimal(20,4) comment '买入返售金融资产减值准备',
  s_noble_metal_depreciation decimal(20,4) comment '贵金属跌价准备',
  s_treated_assets_devalue decimal(20,4) comment '待处理资产减值准备',
  s_interest_receivable_devalue decimal(20,4) comment '应收利息减值准备',
  s_other_assets_devalue decimal(20,4) comment '其他资产减值准备',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondestimateissueamount;
create table if not exists ty_ods.w_cbondestimateissueamount
(
  object_id string comment '对象ID',
  issue_firstissue string comment '发行日期',
  bond_type string comment '债券类型',
  issue_amountplan decimal(20,4) comment '发行数量(亿元)',
  term_year decimal(20,4) comment '债券期限(年)',
  interesttype string comment '利率类型',
  interestfrequency string comment '付息频率',
  isser_introduce string comment '发行简介',
  specialbondtype bigint comment '债券品种代码',
  interesttype_code bigint comment '附息利率品种代码',
  reimbursement bigint comment '偿还方式代码',
  s_info_windcode string comment 'Wind代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondeventdateinformation;
create table if not exists ty_ods.w_cbondeventdateinformation
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  event_type bigint comment '事件类型编号',
  occurrence_date string comment '发生日期',
  disclosure_date string comment '披露日期',
  memo string comment '内容说明',
  date_created string comment '创建日期',
  s_info_code string comment '交易代码',
  s_info_name string comment '证券简称',
  type_code string comment '证券类型代码',
  language1 string comment '语言',
  eqy_record_dt string comment '权益登记日',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondfinancialaccounts;
create table if not exists ty_ods.w_cbondfinancialaccounts
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  subject_chinese_name string comment '科目中文名',
  classification_number string comment '分类序号',
  s_info_datatype string comment '数据类型',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondfinancialexpense;
create table if not exists ty_ods.w_cbondfinancialexpense
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  s_info_compname string comment '公司名称',
  ann_dt string comment '公告日期',
  report_period string comment '报告期',
  statement_typecode bigint comment '报表类型代码',
  s_stmnote_intexp decimal(20,4) comment '利息支出',
  s_stmnote_intinc decimal(20,4) comment '减：利息收入',
  s_stmnote_exch decimal(20,4) comment '汇兑损益',
  s_stmnote_fee decimal(20,4) comment '手续费',
  s_stmnote_others decimal(20,4) comment '其他',
  s_stmnote_finexp decimal(20,4) comment '合计',
  s_stmnote_finexp_1 decimal(20,4) comment '利息资本化金额',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



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



drop table if exists ty_ods.w_cbondfixedincomeplatform;
create table if not exists ty_ods.w_cbondfixedincomeplatform
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '日期',
  s_info_name string comment '证券中文简称',
  bid_trade_time string comment '买入报价时间',
  bid_quotingparty string comment '买入报价方',
  bid_clean_price decimal(20,4) comment '买入价(净价)',
  bid_num decimal(20,4) comment '买入数量',
  bid_price decimal(20,4) comment '买入价(全价)',
  bid_yield_to_maturity decimal(20,4) comment '买入到期收益率(%)',
  ask_trade_time string comment '卖出报价时间',
  ask_quotingparty string comment '卖出报价方',
  ask_clean_price decimal(20,4) comment '卖出价(净价)',
  ask_num decimal(20,4) comment '卖出数量',
  ask_price decimal(20,4) comment '卖出价(全价)',
  ask_yield_to_maturity decimal(20,4) comment '卖出到期收益率(%)',
  rate decimal(20,4) comment '应计利息',
  bid_order_number string comment '买入订单编号',
  ask_order_number string comment '卖出订单编号',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondfthirdpartyvaluation;
create table if not exists ty_ods.w_cbondfthirdpartyvaluation
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  dls_windcode string comment 'Wind代码',
  pricetype_code bigint comment '价格类型代码',
  trade_dt string comment '日期',
  dl_interest decimal(24,8) comment '交割利息',
  intervalinterest decimal(24,8) comment '区间利息',
  dl_cost decimal(20,4) comment '交割成本',
  fs_spread decimal(20,4) comment '期现价差',
  irr decimal(20,4) comment 'IRR',
  rt_spread decimal(20,4) comment '基差',
  rec_trans_marks decimal(20,4) comment '近期成交标识',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondfundstop5companies;
create table if not exists ty_ods.w_cbondfundstop5companies
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  s_info_compname string comment '单位名称',
  s_info_compcode2 string comment '单位名称ID',
  typecode bigint comment '往来资金类别代码',
  conditioncode bigint comment '往来资金条件代码',
  start_dt string comment '起始日',
  end_dt string comment '终止日',
  amount1 decimal(20,4) comment '金额',
  amount2 decimal(20,4) comment '原币金额',
  crncy_code string comment '货币代码',
  rate string comment '利率',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondfundusing;
create table if not exists ty_ods.w_cbondfundusing
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  sec_id string comment '证券ID',
  start_dt string comment '起始日期',
  end_dt string comment '截止日期',
  cur_sign bigint comment '最新标志',
  funduse string comment '资金用途',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondfuturespositions;
create table if not exists ty_ods.w_cbondfuturespositions
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '日期',
  fs_info_membername string comment '会员简称',
  fs_info_type string comment '类型',
  fs_info_positionsnum decimal(20,4) comment '数量',
  fs_info_rank bigint comment '名次',
  s_oi_positionsnumc decimal(20,4) comment '比上交易日增减',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondfvaluation;
create table if not exists ty_ods.w_cbondfvaluation
(
  object_id string comment '对象ID',
  s_info_windcode string comment '月合约Wind代码',
  dls_windcode string comment '可交割券Wind代码',
  trade_dt string comment '日期',
  dl_interest decimal(20,8) comment '交割利息',
  intervalinterest decimal(20,8) comment '区间利息',
  dl_cost decimal(20,4) comment '交割成本',
  fs_spread decimal(20,4) comment '期现价差',
  irr decimal(20,4) comment 'IRR',
  rt_spread decimal(20,4) comment '基差',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondgovernmentgrants;
create table if not exists ty_ods.w_cbondgovernmentgrants
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  report_period string comment '报告期',
  item_name string comment '项目',
  amount_current_issue decimal(20,4) comment '本期发生额',
  amount_previous_period decimal(20,4) comment '上期发生额',
  memo string comment '说明',
  currency_code string comment '货币代码',
  ann_date string comment '公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondguaranteedetail;
create table if not exists ty_ods.w_cbondguaranteedetail
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  enddate string comment '截止日期',
  ann_date string comment '公告日期',
  company_guaranteed string comment '被担保公司名称',
  amountofguarantee bigint comment '担保金额(万元)',
  guaranteecompanytype string comment '担保公司类别',
  crncy_code string comment '货币代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondguaranteestatistics;
create table if not exists ty_ods.w_cbondguaranteestatistics
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  total_amount_guarantee decimal(20,4) comment '担保发生额合计',
  guarantee_balance_total decimal(20,4) comment '担保余额合计',
  amount_of_guarantee decimal(20,4) comment '担保总额',
  holding_total_amount_guarantee decimal(20,4) comment '对控股子公司担保发生额合计',
  violation_amount_guarantee decimal(20,4) comment '违规担保总额',
  amount_of_guarantee_rate decimal(20,4) comment '担保总额占净资产比例',
  deadline string comment '截止日期',
  ann_date string comment '公告日期',
  currency_code string comment '货币代码',
  holding_total decimal(20,4) comment '对控股子公司担保余额合计',
  controlling_total decimal(20,4) comment '为控股股东及其他关联方提供担保金额',
  total_amount_guarantee1 decimal(20,4) comment '为高负债对象提供担保金额',
  is_more_than_net_assets bigint comment '担保总额是否超过净资产50%',
  net_assets_rate decimal(20,4) comment '担保总额占净资产比例(%)(计算值)',
  more_than_net_assets_amount decimal(20,4) comment '担保总额超过净资产50%部分的金额',
  holding_amount_of_guarantee decimal(20,4) comment '对控股子公司担保额度合计',
  external_guarantee decimal(20,4) comment '对外担保额度合计',
  amount_of_guarantee_total decimal(20,4) comment '担保额度合计',
  net_assets_rate2 decimal(20,4) comment '担保额度占净资产比例',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondguaranteetotal;
create table if not exists ty_ods.w_cbondguaranteetotal
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  enddate string comment '截止日期',
  ann_date string comment '公告日期',
  guar_balance decimal(20,4) comment '担保余额(亿元)',
  guar_inwards decimal(20,4) comment '对内担保余额(亿元)',
  guar_outwards decimal(20,4) comment '对外担保余额(亿元)',
  memo string comment '备注',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondholdersmeeting;
create table if not exists ty_ods.w_cbondholdersmeeting
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  meeting_name string comment '会议名称',
  is_new bigint comment '最新标志',
  ann_dt string comment '公告日期',
  meeting_dt string comment '会议日期',
  meeting_type string comment '会议类型',
  meeting_content string comment '会议内容',
  is_intnet bigint comment '是否可以网络投票',
  smtgrecdate string comment 'A股股权登记日',
  spotmtgstartdate string comment '会议登记起始日',
  spotmtgenddate string comment '会议登记截止日',
  votingcode bigint comment '投票通道代码',
  meetevent_id string comment '会议事件ID',
  type_code bigint comment '品种类型代码',
  meeting_place string comment '会议召开地点',
  is_notarization bigint comment '是否经公证',
  resolution_ann_dt string comment '决议公告日',
  resolution_content string comment '决议内容',
  cost_tot decimal(20,4) comment '大会费用合计',
  attend_ratio decimal(20,4) comment '持有人出席比例',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondholder;
create table if not exists ty_ods.w_cbondholder
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_dt string comment '公告日期',
  s_info_enddate string comment '截止日期',
  s_fa_latelyrd string comment '报告期',
  b_info_holder string comment '持有人',
  b_info_holdamount decimal(20,4) comment '持有数量(张)',
  b_issuer_sharecategory string comment '持有人类型',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondibrmbmondmaroview;
create table if not exists ty_ods.w_cbondibrmbmondmaroview
(
  object_id string comment '对象ID',
  trade_dt string comment '交易日期',
  s_info_typecode string comment '交易品种代码',
  b_dq_type string comment '交易品种',
  b_dq_number decimal(20,8) comment '成交笔数',
  b_dq_nochange decimal(20,8) comment '成交笔数增减',
  b_dq_tradingvalue decimal(20,8) comment '成交量(亿元)',
  b_dq_vchange decimal(20,8) comment '成交额增减（亿元）',
  b_dq_wavrate decimal(20,8) comment '加权平均利率(%)',
  b_dq_bpchange decimal(20,8) comment '升降基点',
  b_dq_nomembersinvo decimal(20,8) comment '参与成员家数',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondibrmbmondmarquotation;
create table if not exists ty_ods.w_cbondibrmbmondmarquotation
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  b_dq_type string comment '交易品种',
  trade_dt string comment '交易日期',
  b_dq_open decimal(20,8) comment '开盘利率',
  b_dq_high decimal(20,8) comment '最高利率',
  b_dq_low decimal(20,8) comment '最低利率',
  b_dq_originclose decimal(20,8) comment '收盘利率',
  b_dq_waveragerate decimal(20,8) comment '加权平均利率',
  b_dq_bpchange decimal(20,8) comment '升降(基点)',
  b_dq_volume decimal(20,8) comment '成交量(手)',
  b_dq_amount decimal(20,8) comment '成交金额(亿元)',
  b_dq_amountchange decimal(20,8) comment '成交量增减(亿元)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondimportantindicators;
create table if not exists ty_ods.w_cbondimportantindicators
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  statement_type string comment '报表类型',
  iflisted_data bigint comment '是否上市后数据',
  report_period string comment '报告期',
  s_fa_eps_diluted decimal(20,4) comment '每股收益-摊薄',
  s_fa_bps_sh decimal(20,4) comment '归属于母公司股东的每股净资产',
  s_fa_bps_adjust decimal(20,4) comment '每股净资产-调整',
  roe_diluted decimal(20,4) comment '净资产收益率-摊薄(%)',
  s_info_div string comment '分红方案',
  ann_dt string comment '公告日期',
  s_fa_eps_ex decimal(20,4) comment '每股收益-扣除',
  roe_weighted decimal(20,4) comment '净资产收益率-加权(%)',
  roe_exweighted decimal(20,4) comment '净资产收益率-扣除/加权(%)',
  s_fa_eps_basic decimal(20,4) comment '每股收益-基本',
  s_fa_eps_exbasic decimal(20,4) comment '每股收益-扣除/基本',
  roe_ex decimal(20,4) comment '净资产收益率-扣除(%)',
  s_fa_deductedprofit decimal(20,4) comment '扣除非经常性损益后的净利润(扣除少数股东损益)',
  s_fa_current decimal(20,4) comment '流动比',
  s_fa_quick decimal(20,4) comment '速动比',
  s_fa_arturn decimal(20,4) comment '应收账款周转率',
  s_fa_invturn decimal(20,4) comment '存货周转率',
  s_ft_debttoassets decimal(20,4) comment '资产负债率(%)',
  s_fa_ocfps decimal(20,4) comment '每股经营活动产生的现金流量净额',
  net_profit decimal(20,4) comment '国际会计准则净利润',
  rd_expense decimal(20,4) comment '研发费用',
  s_fa_eps_diluted2 decimal(20,6) comment '每股收益-稀释',
  s_fa_eps_exdiluted decimal(20,4) comment '每股收益-扣除/稀释',
  s_fa_bps decimal(22,4) comment '每股净资产',
  s_fa_extraordinary decimal(22,4) comment '非经常性损益',
  s_fa_tot_assets decimal(22,4) comment '比年初增长率.总资产(%)',
  s_fa_yoyeps_basic decimal(22,4) comment '同比增长率.基本每股收益(%)',
  s_fa_yoyeps_diluted decimal(22,4) comment '同比增长率.稀释每股收益(%)',
  s_fa_yoyequity decimal(22,4) comment '比年初增长率.归属母公司的股东权益(%)',
  growth_bps_sh decimal(22,4) comment '比年初增长率.归属于母公司股东的每股净资产(%)',
  s_fa_yoyocfps decimal(22,4) comment '同比增长率.每股经营活动产生的现金流量净额(%)',
  yoy_net_cash_flows decimal(22,4) comment '同比增长率.经营活动产生的现金流量净额(%)',
  s_fa_deductedprofit_yoy decimal(22,4) comment '同比增长率.扣除非经常性损益后的净利润(扣除少数股东损益)(%)',
  yoy_roe_diluted decimal(22,4) comment '同比增长率.净资产收益率(摊薄)(%)',
  s_fa_yoyop decimal(20,4) comment '同比增长率.营业利润(%)',
  s_fa_yoyebt decimal(20,4) comment '同比增长率.利润总额(%)',
  net_profit_yoy decimal(20,4) comment '同比增长率.净利润(%)',
  crncy_code string comment '货币代码',
  statement_type_code bigint comment '报表类型代码',
  contributionps decimal(20,4) comment '每股社会贡献值',
  memo string comment '备注',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondindexperformance;
create table if not exists ty_ods.w_cbondindexperformance
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '交易日期',
  pct_chg_recent1m decimal(20,6) comment '最近1月涨跌幅',
  pct_chg_recent3m decimal(20,6) comment '最近3月涨跌幅',
  pct_chg_recent6m decimal(20,6) comment '最近6月涨跌幅',
  pct_chg_recent1y decimal(20,6) comment '最近1年涨跌幅',
  pct_chg_recent2y decimal(20,6) comment '最近2年涨跌幅',
  pct_chg_recent3y decimal(20,6) comment '最近3年涨跌幅',
  pct_chg_recent4y decimal(20,6) comment '最近4年涨跌幅',
  pct_chg_recent5y decimal(20,6) comment '最近5年涨跌幅',
  pct_chg_recent6y decimal(20,6) comment '最近6年涨跌幅',
  pct_chg_thisweek decimal(20,6) comment '本周以来涨跌幅',
  pct_chg_thismonth decimal(20,6) comment '本月以来涨跌幅',
  pct_chg_thisquarter decimal(20,6) comment '本季以来涨跌幅',
  pct_chg_thisyear decimal(20,6) comment '本年以来涨跌幅',
  si_pct_chg decimal(20,6) comment '发布以来涨跌幅',
  annualyeild decimal(20,6) comment '年化收益率',
  std_dev_6m decimal(20,6) comment '6个月标准差',
  std_dev_1y decimal(20,6) comment '1年标准差',
  std_dev_2y decimal(20,6) comment '2年标准差',
  std_dev_3y decimal(20,6) comment '3年标准差',
  sharpratio_6m decimal(20,6) comment '6个月夏普比率',
  sharpratio_1y decimal(20,6) comment '1年夏普比率',
  sharpratio_2y decimal(20,6) comment '2年夏普比率',
  sharpratio_3y decimal(20,6) comment '3年夏普比率',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondindustrynafmii;
create table if not exists ty_ods.w_cbondindustrynafmii
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_info_industrycode string comment '一级板块代码',
  s_info_industryname string comment '一级板块名称',
  s_info_industrycode2 string comment '二级板块代码',
  s_info_industryname2 string comment '二级板块名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondinventorydetails;
create table if not exists ty_ods.w_cbondinventorydetails
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  report_period string comment '报告期',
  inv_object string comment '项目',
  inv_amt decimal(20,4) comment '金额',
  crncy_code string comment '货币代码',
  provision decimal(20,4) comment '跌价准备',
  statement_type bigint comment '报告类型代码',
  net decimal(20,4) comment '净额',
  subject_name string comment '科目名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondissuermanagement;
create table if not exists ty_ods.w_cbondissuermanagement
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id ',
  s_info_compname string comment '公司名称',
  ann_date string comment '公告日期',
  s_info_manager_name string comment '姓名',
  s_info_manager_gender string comment '性别代码',
  s_info_manager_education string comment '学历',
  s_info_manager_nationality string comment '国籍',
  s_info_manager_birthyear string comment '出生日期',
  s_info_manager_startdate string comment '任职日期',
  s_info_manager_leavedate string comment '离职日期',
  s_info_manager_type bigint comment '管理层类别',
  s_info_manager_post string comment '公布职务名称',
  s_info_manager_introduction string comment '个人简历',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondissuerofficecity;
create table if not exists ty_ods.w_cbondissuerofficecity
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  wind_ind_code string comment '所属板块代码',
  wind_ind_name string comment '板块名称',
  entry_dt string comment '纳入日期',
  remove_dt string comment '剔除日期',
  cur_sign bigint comment '最新标志',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondleadunderwriter;
create table if not exists ty_ods.w_cbondleadunderwriter
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  meeting_dt string comment '发审委会议日期',
  pass_dt string comment '发审委通过公告日',
  s_lu_annissuedate string comment '发行公告日',
  s_lu_issuedate string comment '发行日期',
  s_info_listdate string comment '上市日期(债券起息日)',
  s_lu_issuetype string comment '发行类型',
  bondtype string comment '辅助类型',
  s_lu_totalissuecollection decimal(20,4) comment '募集资金合计(万元)',
  netcollection decimal(20,4) comment '实际募资金额(万元)',
  avg_totalcoll decimal(20,4) comment '募集资金合计(平均分配)',
  avg_netcoll decimal(20,4) comment '实际募资金额(平均分配)',
  s_lu_totalissueexpenses decimal(20,4) comment '发行费用合计(万元)',
  s_lu_totaluderandsponefee decimal(20,4) comment '承销与保荐费用(万元)',
  all_lu string comment '参与主承销商名称',
  s_lu_number bigint comment '参与主承销商个数',
  s_lu_name string comment '主承销商名称',
  s_info_compcode string comment '主承销商公司ID',
  s_lu_institype string comment '机构类型',
  s_is_statistics bigint comment '是否参与统计',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondloandetails;
create table if not exists ty_ods.w_cbondloandetails
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  loan_type string comment '贷款类型',
  loan_cny decimal(20,4) comment '人民币贷款',
  loan_usd decimal(20,4) comment '美元贷款(折算人民币)',
  loan_jpy decimal(20,4) comment '日元贷款(折算人民币)',
  loan_eur decimal(20,4) comment '欧元贷款(折算人民币)',
  loan_hkd decimal(20,4) comment '港币贷款(折算人民币)',
  loan_gbp decimal(20,4) comment '英镑贷款(折算人民币)',
  loan_other decimal(20,4) comment '其他货币贷款(折算人民币)',
  loan_tot decimal(20,4) comment '贷款合计',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondmajorreceivables;
create table if not exists ty_ods.w_cbondmajorreceivables
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  statement_type string comment '报表类型',
  debtor_name string comment '债务人名称',
  arrears decimal(20,4) comment '金额',
  delaytime string comment '拖欠时间',
  delayreason string comment '拖欠原因',
  currency_code string comment '货币代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondmanagementholdreward;
create table if not exists ty_ods.w_cbondmanagementholdreward
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  ann_date string comment '公告日期',
  end_date string comment '截止日期',
  crny_code string comment '货币代码',
  s_info_manager_name string comment '姓名',
  s_info_manager_post string comment '职务',
  s_manager_return decimal(20,4) comment '报酬',
  s_manager_quantity decimal(20,4) comment '持股数量',
  manid string comment '人物ID',
  s_manager_return_other bigint comment '是否在股东或关联单位领取报酬、津贴',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondmonetaryfunds;
create table if not exists ty_ods.w_cbondmonetaryfunds
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_date string comment '公告日期',
  s_rmb decimal(20,4) comment '人民币',
  s_us decimal(20,4) comment '美元(折算人民币)',
  s_jpy decimal(20,4) comment '日元(折算人民币)',
  s_eur decimal(20,4) comment '欧元(折算人民币)',
  s_hkd decimal(20,4) comment '港币(折算人民币)',
  s_gbp decimal(20,4) comment '英镑(折算人民币)',
  s_other decimal(20,4) comment '其他货币(折算人民币)',
  capital_tot decimal(20,4) comment '货币资金合计',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondnegativecreditevent;
create table if not exists ty_ods.w_cbondnegativecreditevent
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'wind代码',
  acu_date string comment '[内部]发生日期',
  event_type bigint comment '事件类型',
  s_info_compcode string comment '公司ID',
  subject_type bigint comment '主体类型代码',
  event_title string comment '事件标题 ',
  event_memo string comment '事件摘要 ',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondnonprofitloss;
create table if not exists ty_ods.w_cbondnonprofitloss
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  ann_dt string comment '公告日期',
  report_period string comment '报告期',
  statement_type string comment '报表类型',
  crncy_code string comment '货币代码',
  non_current_gains_losses decimal(20,4) comment '非流动资产处置损益',
  tax_return decimal(20,4) comment '税收返还减免',
  government_subsidy decimal(20,4) comment '政府补助',
  capital_occupation_fee decimal(20,4) comment '资金占用费',
  consolidated_gains_losses decimal(20,4) comment '企业合并产生的损益',
  non_assets_gains_losses decimal(20,4) comment '非货币性资产交换损益',
  investment_gains_losses decimal(20,4) comment '委托投资损益',
  impairment_assets decimal(20,4) comment '资产减值准备',
  debt_restructuring decimal(20,4) comment '债务重组损益',
  enterprise_restructuring decimal(20,4) comment '企业重组费用',
  trading_price_unfair decimal(20,4) comment '交易价格显失公允产生的损益',
  net_profit_loss_subsidiaries decimal(20,4) comment '同一控制下企业合并产生的子公司净损益',
  expected_liabilities decimal(20,4) comment '预计负债产生的损益',
  onoiae decimal(20,4) comment '其他营业外收支净额',
  other_projects decimal(20,4) comment '其他项目',
  non_recurring_gains_losses decimal(20,4) comment '非经常性损益项目小计',
  income_tax_impact decimal(20,4) comment '所得税影响数',
  profit_loss_shareholders decimal(20,4) comment '少数股东损益影响数',
  non_recurring_gains_losses1 decimal(20,4) comment '非经常性损益项目合计',
  s_fa_deductedprofittoprofit decimal(20,4) comment '扣除非经常损益后的净利润',
  s_fa_deductedprofittoprofit1 decimal(20,4) comment '扣除非经常损益后的归属公司股东的净利润',
  fairvalue_change_gains_losses decimal(20,4) comment '持有(或处置)交易性金融资产和负债产生的公允价值变动损益',
  provision_impairment_reversed decimal(20,4) comment '单独进行监制测试的应收款项减值准备转回',
  proceeds_loan decimal(20,4) comment '对外委托贷款取得的收益',
  changes_real_estate_value decimal(20,4) comment '公允价值法计量的投资性房地产价值变动损益',
  profit_loss_adjustment decimal(20,4) comment '法规要求一次性损益调整影响',
  custody_fee_income decimal(20,4) comment '受托经营取得的托管费收入',
  is_published bigint comment '是否公布',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondotheraccountsreceivable;
create table if not exists ty_ods.w_cbondotheraccountsreceivable
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  statement_type string comment '报表类型',
  aging string comment '账龄',
  currency_code string comment '货币代码',
  oth_rcv decimal(20,4) comment '金额',
  oth_rcv_pct decimal(20,4) comment '比例',
  extra_amount decimal(20,4) comment '坏账准备',
  min_aging decimal(20,4) comment '最小账龄',
  max_aging decimal(20,4) comment '最大账龄',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondotherreceivables;
create table if not exists ty_ods.w_cbondotherreceivables
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  statement_type string comment '报表类型',
  debtor_name string comment '债务人名称',
  arrears decimal(20,4) comment '金额',
  oth_rcv_pct decimal(20,4) comment '比例(%)',
  currency_code string comment '货币代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondplacementdetails;
create table if not exists ty_ods.w_cbondplacementdetails
(
  object_id string comment '对象ID',
  s_info_windcode string comment '证券ID',
  typeofinvestor string comment '法人投资者类型',
  investor_name string comment '法人投资者',
  investor_id string comment '法人投资者ID',
  placement decimal(20,4) comment '获配数量(万股/万张)',
  lockmonth decimal(20,4) comment '冻结期限(月)',
  ann_ordqty decimal(20,4) comment '实际申购数量',
  ann_dt string comment '公告日期',
  trade_dt string comment '配售截止日期',
  refund_payback_amount decimal(20,4) comment '退款或补缴金额',
  share_type string comment '股份类型',
  tradable_dt string comment '可流通日期',
  latest_own_qty decimal(20,4) comment '最新持股数量',
  latest_own_qty_financing decimal(20,4) comment '最新持股数量(配套融资)',
  investor_type_code bigint comment '投资者类型代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondprerelease;
create table if not exists ty_ods.w_cbondprerelease
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_date string comment '公告日期',
  pre_release_code string comment '预发行代码',
  pre_release_name string comment '预发行简称',
  pre_release_begindate string comment '预发行交易起始日',
  pre_release_enddate string comment '预发行交易截止日',
  s_base_info decimal(24,8) comment '基准价格/收益率',
  b_anal_rduration decimal(24,8) comment '参考久期',
  price_type_code bigint comment '价格类型代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondpricingvaluation;
create table if not exists ty_ods.w_cbondpricingvaluation
(
  object_id string comment '对象ID',
  trade_dt string comment '日期',
  val_agency string comment '估值机构',
  val_agency_id string comment '估值机构id',
  credit_code bigint comment '信用评级代码',
  term decimal(20,4) comment '期限',
  valuation decimal(20,4) comment '定价估值',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondprovisionbaddebts;
create table if not exists ty_ods.w_cbondprovisionbaddebts
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  statement_type string comment '报表类型',
  aging string comment '账龄',
  extraction_ratio decimal(20,4) comment '提取比例',
  min_aging decimal(20,4) comment '最小账龄',
  max_aging decimal(20,4) comment '最大账龄',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondrateadjustment;
create table if not exists ty_ods.w_cbondrateadjustment
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  b_info_carrydate string comment '起始日期',
  b_info_enddate string comment '截止日期',
  b_info_provisiontype string comment '条款类型',
  b_info_couponrate decimal(22,6) comment '当期票面利率',
  b_info_couponadj_min decimal(20,4) comment '调整下限',
  b_info_couponadj_max decimal(20,4) comment '调整上限',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondratingcicc;
create table if not exists ty_ods.w_cbondratingcicc
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_dt string comment '评级日期',
  analyst string comment '分析师',
  b_info_rating string comment '公布评级',
  s_info_name string comment '公布证券简称',
  b_info_ratingagency string comment '机构',
  starlevel bigint comment '星级',
  memo string comment '评级内容摘要',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondrepo;
create table if not exists ty_ods.w_cbondrepo
(
  object_id string comment '对象ID',
  trade_dt string comment '交易日期',
  b_info_term decimal(20,4) comment '期限(天)',
  b_tender_interestrate decimal(20,4) comment '招标利率(%)',
  b_tender_amount decimal(20,4) comment '招标数量(亿元)',
  b_tender_method bigint comment '招标方式',
  b_info_repo_type bigint comment '操作类型代码',
  b_info_term_words string comment '期限(文字）',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondreserverate;
create table if not exists ty_ods.w_cbondreserverate
(
  object_id string comment '对象ID',
  trade_dt string comment '交易日期',
  s_info_reserveratetype string comment '准备金率品种',
  b_info_rate decimal(20,4) comment '准备金率(%)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondsalessegment;
create table if not exists ty_ods.w_cbondsalessegment
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  s_segment_item string comment '主营业务项目',
  s_segment_cost_ratio bigint comment '主营业务成本比例(%)',
  s_segment_profit_ratio bigint comment '主营业务利润比例(%)',
  s_segment_sales_ratio bigint comment '主营业务收入比例(%)',
  s_report_period string comment '报告期',
  s_crncy_code string comment '货币代码',
  s_segment_sales bigint comment '主营业务收入',
  s_segment_profit bigint comment '主营业务利润',
  s_segment_itemcode string comment '项目类别',
  s_segment_cost bigint comment '主营业务成本',
  s_grossprofitmargin bigint comment '毛利率(%)',
  s_prime_oper_rev_yoy bigint comment '主营业务收入比上年增减(%)',
  s_prime_oper_cost_yoy bigint comment '主营业务成本比上年增减(%)',
  s_gross_profit_margin_yoy bigint comment '毛利率比上年增减(%)',
  s_segment_item_code string comment '容错后主营业务项目',
  s_segment_sales_code bigint comment '主营业务收入项目代码',
  s_accounts_id string comment '科目ID',
  s_is_publishvalue bigint comment '[内部]是否公布值',
  s_gross_profit_yoy bigint comment '毛利同比增长率',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondtaxespayable;
create table if not exists ty_ods.w_cbondtaxespayable
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  vat decimal(20,4) comment '增值税',
  business_tax decimal(20,4) comment '营业税',
  corporate_income_tax decimal(20,4) comment '企业所得税',
  urban_maintenance_tax decimal(20,4) comment '城市维护建设税',
  property_tax decimal(20,4) comment '房产税',
  personal_income_tax decimal(20,4) comment '个人所得税',
  sale_tax decimal(20,4) comment '消费税',
  land_holding_tax decimal(20,4) comment '土地使用税',
  stamp_duty decimal(20,4) comment '印花税',
  vehicle_usage_tax decimal(20,4) comment '车船使用税',
  land_value_added_tax decimal(20,4) comment '土地增值税',
  resource_tax decimal(20,4) comment '资源税',
  other decimal(20,4) comment '其他',
  total decimal(20,4) comment '合计',
  memo string comment '备注',
  statement_type string comment '报表类型',
  education_surcharge decimal(20,4) comment '教育费附加',
  flood_control_fund decimal(20,4) comment '防洪基金',
  compensation_mineral_resources decimal(20,4) comment '矿产资源补偿费',
  vehicle_purchase_surcharge decimal(20,4) comment '车辆购置附加费',
  agriculture_forestry_tax decimal(20,4) comment '农林特产税',
  local_education_fee decimal(20,4) comment '地方教育费附加',
  price_control_fund decimal(20,4) comment '价格调控基金',
  statement_type_code bigint comment '报表类型代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondtenderresult;
create table if not exists ty_ods.w_cbondtenderresult
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  b_tender_object bigint comment '招标标的',
  b_tendrst_documtnumber string comment '招标书编号',
  b_tendrst_payamount decimal(20,4) comment '缴款总金额(元)',
  b_tendrst_amountad decimal(20,4) comment '追加发行总量(万元)',
  b_tendrst_underwriting decimal(20,4) comment '基本承购总额(万元)',
  b_tendrst_amountact decimal(20,4) comment '实际发行总额(万元)',
  b_tendrst_amnt decimal(20,4) comment '招标总量(万元)',
  b_tendrst_oughttender decimal(20,4) comment '应投家数',
  b_tendrst_investortendered decimal(20,4) comment '投标家数',
  b_tendrst_tenders decimal(20,4) comment '投标笔数',
  b_tendrst_effecttender decimal(20,4) comment '有效笔数',
  b_tendrst_ineffecttender decimal(20,4) comment '无效笔数',
  b_tendrst_effectamnt decimal(20,4) comment '有效投标总量(万元)',
  b_tendrst_hightest decimal(20,4) comment '最高投标价位',
  b_tendrst_lowest decimal(20,4) comment '最低投标价位',
  b_tendrst_winningamnt decimal(20,4) comment '中标总量(万元)',
  b_tendrst_winnerbidder decimal(20,4) comment '中标家数',
  b_tendrst_winningbidder decimal(20,4) comment '中标笔数',
  b_tendrst_privatetrade decimal(20,4) comment '自营中标总量(万元)',
  b_tendrst_hightprice decimal(20,4) comment '最高中标价位',
  b_tendrst_lowprice decimal(20,4) comment '最低中标价位',
  b_tendrst_margamnt decimal(20,4) comment '边际中标价位投标总量(万元)',
  b_tendrst_margwinbidder decimal(20,4) comment '边际中标价位中标总量(万元)',
  b_tendrst_finalprice decimal(20,4) comment '最终发行价格',
  b_tendrst_referyield decimal(20,4) comment '参考收益率(%)',
  b_tendrst_financoupon decimal(20,4) comment '最终票面利率(%)',
  b_tendrst_bidrate decimal(20,4) comment '全场中标利率(%)',
  b_tendrst_bidprice decimal(20,4) comment '全场中标价格(元)',
  b_tendrst_bidspread decimal(20,4) comment '全场中标利差(%)',
  s_ipo_ovrsubratio decimal(20,4) comment '超额认购倍数',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondtender;
create table if not exists ty_ods.w_cbondtender
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_dt string comment '公告日期',
  b_tender_tenderdate string comment '招投标日期',
  b_tender_method bigint comment '招标方式',
  b_tender_object bigint comment '招标标的',
  b_tender_amountplan decimal(20,4) comment '计划招标总额',
  b_tender_cmptamnt decimal(20,4) comment '竞争性招标总额',
  b_tender_underwriting decimal(20,4) comment '基本承销额度',
  b_tender_additiverights string comment '基本承销额增加权利',
  b_tender_addratio decimal(20,4) comment '基本承销额追加比例(%)',
  b_tender_threshold decimal(20,4) comment '投标价位下限',
  b_tender_ceiling decimal(20,4) comment '投标价位上限',
  b_tender_tenderunit decimal(20,4) comment '基本投标单位',
  b_tender_lowestamnt decimal(20,4) comment '每标位最低投标量',
  b_tender_highestamnt decimal(20,4) comment '每标位最高投标量',
  b_tender_paymentdate string comment '缴款日期',
  b_tender_confirmdate string comment '资金到账确认时间',
  b_tender_transferdate string comment '债券过户时间',
  b_tender_distribbegin string comment '分销起始日期',
  b_tender_distribend string comment '分销截止日期',
  b_tender_underwritingcost decimal(20,4) comment '承揽费率(%)',
  b_tender_spread string comment '标位步长',
  b_tender_concatenationornot bigint comment '是否要求标位连续',
  b_tender_time string comment '招标时间',
  b_tender_payment_enddate string comment '缴款截止日',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondtop5byaccountsreceivable;
create table if not exists ty_ods.w_cbondtop5byaccountsreceivable
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  report_period string comment '报告期',
  s_info_compname string comment '债务人名称',
  amount decimal(20,4) comment '金额',
  crncy_code string comment '货币代码',
  period string comment '拖欠时间',
  reason string comment '拖欠原因',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondttmhis;
create table if not exists ty_ods.w_cbondttmhis
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  ann_dt string comment '公告日期',
  report_period string comment '截止日期',
  statement_type string comment '报表类型',
  tot_oper_rev_ttm decimal(20,4) comment '营业总收入(TTM)',
  oper_rev_ttm decimal(20,4) comment '营业收入(TTM)',
  net_profit_ttm decimal(20,4) comment '净利润(TTM)',
  net_profit_parent_comp_ttm decimal(20,4) comment '归属于母公司的净利润(TTM)',
  net_cash_flows_oper_act_ttm decimal(20,4) comment '经营活动现金净流量(TTM)',
  net_incr_cash_cash_equ_ttm decimal(20,4) comment '现金净流量(TTM)',
  crncy_code string comment '货币代码',
  s_fa_cost_ttm decimal(20,4) comment '营业成本-非金融类(TTM)',
  s_fa_expense_ttm decimal(20,4) comment '营业支出-金融类(TTM)',
  s_fa_grossmargin_ttm decimal(20,4) comment '毛利(TTM)',
  s_fa_operateincome_ttm decimal(20,4) comment '经营活动净收益(TTM)',
  s_fa_investincome_ttm decimal(20,4) comment '价值变动净收益(TTM)',
  s_fa_op_ttm decimal(20,4) comment '营业利润(TTM)',
  s_fa_ebt_ttm decimal(20,4) comment '利润总额(TTM)',
  s_fa_gr_ttm decimal(20,4) comment '营业总收入(TTM)',
  s_fa_gc_ttm decimal(20,4) comment '营业总成本(TTM)',
  s_fa_investcashflow_ttm decimal(20,4) comment '投资活动现金净流量(TTM)',
  s_fa_financecashflow_ttm decimal(20,4) comment '筹资活动现金净流量(TTM)',
  s_fa_asset_mrq decimal(20,4) comment '资产总计(MRQ)',
  s_fa_debt_mrq decimal(20,4) comment '负债合计(MRQ)',
  s_fa_totalequity_mrq decimal(20,4) comment '股东权益(MRQ)',
  s_fa_equity_mrq decimal(20,4) comment '归属于母公司的股东权益(MRQ)',
  s_fa_netprofitmargin_ttm decimal(20,4) comment '销售净利率(TTM)',
  s_fa_grossprofitmargin_ttm decimal(20,4) comment '销售毛利率(TTM)',
  s_fa_expensetosales_ttm decimal(20,4) comment '销售期间费用率(TTM)',
  s_fa_profittogr_ttm decimal(20,4) comment '净利润/营业总收入(TTM)',
  s_fa_operateexpensetogr_ttm decimal(20,4) comment '销售费用/营业总收入(TTM)',
  s_fa_adminexpensetogr_ttm decimal(20,4) comment '管理费用/营业总收入(TTM)',
  s_fa_finaexpensetogr_ttm decimal(20,4) comment '财务费用/营业总收入(TTM)',
  s_fa_impairtogr_ttm decimal(20,4) comment '资产减值损失/营业总收入(TTM)',
  s_fa_gctogr_ttm decimal(20,4) comment '营业总成本/营业总收入(TTM)',
  s_fa_optogr_ttm decimal(20,4) comment '营业利润/营业总收入(TTM)',
  s_fa_roa_ttm decimal(20,4) comment '总资产净利率(TTM)',
  s_fa_roa2_ttm decimal(20,4) comment '总资产报酬率(TTM)',
  s_fa_roe_ttm decimal(20,4) comment '净资产收益率(TTM)',
  s_fa_operateincometoebt_ttm decimal(20,4) comment '经营活动净收益/利润总额(TTM)',
  s_fa_investincometoebt_ttm decimal(20,4) comment '价值变动净收益/利润总额(TTM)',
  s_fa_nonoperateprofittoebt_ttm decimal(20,4) comment '营业外收支净额/利润总额(TTM)',
  s_fa_salescashintoor_ttm decimal(20,4) comment '销售商品提供劳务收到的现金/营业收入(TTM)',
  s_fa_ocftoor_ttm decimal(20,4) comment '经营活动产生的现金流量净额/营业收入(TTM)',
  s_fa_ocftooperateincome_ttm decimal(20,4) comment '经营活动产生的现金流量净额/经营活动净收益(TTM)',
  s_fa_deductedprofit_ttm decimal(20,4) comment '扣除非经常性损益后的净利润(TTM)',
  s_fa_ebitda_ttm_inverse decimal(20,4) comment 'EBITDA(TTM反推法)',
  s_fa_ebitda_ttm decimal(20,4) comment 'EBITDA(TTM)',
  s_fa_ebit_ttm decimal(20,4) comment 'EBIT(TTM)',
  fa_roic_ttm decimal(20,4) comment '投入资本回报率(TTM)',
  s_fa_salescashin_ttm decimal(20,4) comment '销售商品提供劳务收到的现金(TTM)',
  s_fa_operateexpense_ttm decimal(20,4) comment '销售费用(TTM)',
  s_fa_adminexpense_ttm decimal(20,4) comment '管理费用(TTM)',
  s_fa_finaexpense_ttm decimal(20,4) comment '财务费用(TTM)',
  s_fa_expense decimal(20,4) comment '期间费用(TTM)',
  s_fa_nonoperateprofit_ttm decimal(20,4) comment '营业外收支净额(TTM)',
  s_fa_impairment_ttm decimal(20,4) comment '资产减值损失(TTM)',
  s_fa_ebit_ttm_inverse decimal(20,4) comment 'EBIT(TTM反推法)',
  s_fa_investcapital_mrq decimal(20,4) comment '全部投入资本(MRQ)',
  fa_roic_ttm2 decimal(20,4) comment '投入资本回报率ROIC(TTM)',
  s_stm_bsmrq decimal(20,4) comment '固定资产合计(MRQ)',
  s_fa_nonopprofit_ttm decimal(20,4) comment '非营业利润(TTM)',
  s_fa_prefinexp_op_ttm decimal(20,4) comment '扣除财务费用前营业利润(TTM)',
  s_fa_optoebt_ttm decimal(20,4) comment '营业利润/利润总额(TTM)',
  s_fa_noptoebt_ttm decimal(20,4) comment '非营业利润/利润总额(TTM)',
  s_fa_taxtoebt_ttm decimal(20,4) comment '税项/利润总额(TTM)',
  s_fa_optoor_ttm decimal(20,4) comment '营业利润/营业收入(TTM)',
  s_fa_ebttoor_ttm decimal(20,4) comment '利润总额/营业收入(TTM)',
  s_fa_prefinexpoptoor_ttm decimal(20,4) comment '扣除融资费用前营业利润/营业收入(TTM)',
  s_fa_netprofittoor_ttm decimal(20,4) comment '归属母公司股东的净利润/营业收入(TTM)',
  s_fa_prefinexpoptoebt_ttm decimal(20,4) comment '扣除融资费用前营业利润/利润总额(TTM)',
  s_fa_ocftoop_ttm decimal(20,4) comment '经营活动产生的现金流量净额/营业利润(TTM)',
  roa_exclminintinc_ttm decimal(20,4) comment '总资产净利率-不含少数股东损益(TTM)',
  s_fa_debttoassets_mrq decimal(20,4) comment '资产负债率(MRQ)',
  int_exp_ttm decimal(20,4) comment '利息支出(TTM)',
  inc_tax_ttm decimal(20,4) comment '所得税(TTM)',
  minority_int_ttm decimal(20,4) comment '少数股东权益(TTM)',
  continuous_net_op_ttm decimal(20,4) comment '持续经营净利润(TTM)',
  noncontinuous_net_op_ttm decimal(20,4) comment '非持续经营净利润(TTM)',
  nonnetoptotaxprofit decimal(20,4) comment '非持续经营净利润/税后利润(TTM)',
  netoptotaxprofit decimal(20,4) comment '持续经营净利润/税后利润(TTM)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cbondunderwritingmember;
create table if not exists ty_ods.w_cbondunderwritingmember
(
  member_name string comment '成员名称',
  underwriting_group_type string comment '承销团类型',
  object_id string comment '对象ID',
  b_year string comment '年度',
  member_id string comment '成员ID',
  member_type string comment '成员类型',
  member_type_num bigint comment '成员类型代码',
  underwriting_group_num bigint comment '承销团类型代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ccommodityfuturespositions;
create table if not exists ty_ods.w_ccommodityfuturespositions
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '日期',
  fs_info_membername string comment '会员简称',
  fs_info_type string comment '类型',
  fs_info_positionsnum decimal(20,4) comment '数量',
  fs_info_rank bigint comment '名次',
  s_oi_positionsnumc decimal(20,4) comment '比上交易日增减',
  s_info_compcode string comment '会员ID ',
  sec_id string comment '证券ID ',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ccstockequitystruc;
create table if not exists ty_ods.w_ccstockequitystruc
(
  object_id string,
  s_info_compcode string,
  ann_date string,
  change_date string,
  issued_shares decimal(20,4),
  mainland_outstd_shr decimal(20,4),
  hk_outstd_shr decimal(20,4),
  overseas_outstd_shr decimal(20,4),
  non_tradable_shr decimal(20,4),
  preferredshare decimal(20,4),
  outstandingshares decimal(20,4),
  changereason_code bigint,
  changereason string,
  overseas_shr_cntrycode string,
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cdragency;
create table if not exists ty_ods.w_cdragency
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_agency_name string comment '机构名称',
  s_relation_typcode string comment '关系类型代码',
  s_business_typcode bigint comment '业务类型代码',
  s_agency_nameid string comment '机构名称ID',
  begindate string comment '起始日期',
  enddate string comment '截止日期',
  sequence1 string comment '序号',
  ann_date string comment '公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cdrcompanyholdshares;
create table if not exists ty_ods.w_cdrcompanyholdshares
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  ann_dt string comment '公告日期',
  enddate string comment '截止日期',
  s_capitaloperation_companyname string comment '被参控公司名称',
  s_capitaloperation_companyid string comment '被参控公司ID',
  s_capitaloperation_comainbus string comment '被参控公司主营业务',
  relations_code string comment '关系代码',
  s_capitaloperation_pct decimal(20,4) comment '直接持股比例',
  voting_rights decimal(20,4) comment '表决权比例',
  s_capitaloperation_amount decimal(20,4) comment '投资金额(万元)',
  operationcrncy_code string comment '货币代码',
  s_capitaloperation_coregcap decimal(20,4) comment '被参股公司注册资本(万元)',
  capitalcrncy_code string comment '注册资本货币代码',
  is_consolidate bigint comment '是否合并报表',
  notconsolidate_reason string comment '未纳入合并报表原因',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cdrcomprfa;
create table if not exists ty_ods.w_cdrcomprfa
(
  object_id string comment '对象ID',
  s_info_companyid string comment '公司ID',
  regaddr string comment '注册地',
  sectors string comment '所属行业',
  sponsor string comment '保荐机构',
  spon_rep string comment '保荐代表人',
  acc_firm string comment '会计师事务所',
  cpa string comment '签字会计师',
  law_firm string comment '律师事务所',
  sol_sig string comment '签字律师',
  app_code bigint comment '申请事项代码',
  sch_code bigint comment '进度类型代码',
  tblisted bigint comment '拟上市板块代码',
  st_date string comment '状态起始日期',
  end_date string comment '状态终止日期',
  est_issueno decimal(20,4) comment '预计发行股数（万股）',
  est_issueshares decimal(20,4) comment '预计发行后总股本（万股）',
  pro_tolalinv decimal(20,4) comment '募投项目投资总额',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cdrdividend;
create table if not exists ty_ods.w_cdrdividend
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  type_code bigint comment '品种类别代码',
  clause_type_code bigint comment '条款属性类型代码',
  start_dt string comment '起始日期',
  end_dt string comment '终止日期',
  clause_content string comment '条款',
  ann_item bigint comment '是否最新',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cdrholdingoperate;
create table if not exists ty_ods.w_cdrholdingoperate
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  ann_dt string comment '公告日期',
  report_period string comment '截止日期',
  s_capitaloperation_companyname string comment '被参控公司名称',
  s_tot_assets decimal(24,8) comment '资产规模',
  s_net_profit decimal(24,8) comment '净利润',
  crncy_code string comment '货币代码',
  s_net_assets decimal(24,8) comment '净资产',
  s_tot_liab decimal(24,8) comment '负债总额',
  s_oper_rev decimal(24,8) comment '营业收入',
  s_tot_profit decimal(24,8) comment '利润总额',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cdrissuecommaudit;
create table if not exists ty_ods.w_cdrissuecommaudit
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_info_companyname string comment '公司名称',
  s_ic_year string comment '年度',
  s_ic_sessiontimes string comment '会议届次',
  s_ic_audittype string comment '审核类型',
  s_ic_type bigint comment '发审委类型',
  s_ic_announcementdate string comment '会议公告日期',
  s_ic_date string comment '会议日期',
  s_ic_auditocetype string comment '审核结果类型',
  s_ic_auditannocedate string comment '审核结果公告日期',
  s_info_expectedissueshares decimal(20,4) comment '预计发行股数(万股)',
  s_info_expectedcollection decimal(20,4) comment '预计募集资金(万元)',
  s_info_veto_reason string comment '被否原因',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cdrmanagement;
create table if not exists ty_ods.w_cdrmanagement
(
  object_id string comment '对象ID',
  s_info_codecode string comment '公司ID',
  ann_date string comment '公告日期',
  s_info_manager_name string comment '姓名',
  s_info_manager_gender string comment '性别',
  s_info_manager_education string comment '学历',
  s_info_manager_nationality string comment '国籍',
  s_info_manager_birthyear string comment '出生年份',
  s_info_manager_startdate string comment '任职日期',
  s_info_manager_leavedate string comment '离职日期',
  s_info_manager_type bigint comment '管理层类别',
  s_info_manager_post string comment '职务',
  s_info_manager_introduction string comment '个人简历',
  manid string comment '人物ID',
  display_order bigint comment '展示顺序',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cdrstaff;
create table if not exists ty_ods.w_cdrstaff
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  end_dt string comment '截止日期',
  ann_dt string comment '公告日期',
  s_info_totalemployees decimal(20,4) comment '员工人数(人)',
  s_info_totalemployees2 bigint comment '母公司员工人数(人)',
  memo string comment '特殊情况说明',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cdrstaffstructure;
create table if not exists ty_ods.w_cdrstaffstructure
(
  object_id string comment '对象ID',
  s_info_compcode string comment '交易代码',
  staff_type_code bigint comment '人数类别代码',
  end_dt string comment '截止日期',
  report_type_code bigint comment '报告类型代码',
  item_type_code bigint comment '项目分类代码',
  item_name string comment '项目',
  item_code bigint comment '项目代码',
  staff_number bigint comment '人数',
  proportion decimal(20,4) comment '所占比例',
  ann_dt string comment '公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cfundadmpermitschedule;
create table if not exists ty_ods.w_cfundadmpermitschedule
(
  object_id string comment '对象ID',
  comp_id string comment '公司ID',
  anndate string comment '公告日期',
  enddate string comment '截止日期',
  type_name string comment '申请事项',
  type_code bigint comment '审核类型代码',
  apply_pickup_date string comment '申请材料接收日',
  notice_correction_date string comment '通知补正日',
  receive_correction_material string comment '接收补正材料日',
  admissibility_date string comment '受理决定日',
  no_admissibility_date string comment '不予受理决定日',
  feedback_date1 string comment '第一次反馈意见日',
  receive_feedback_date1 string comment '接收第一次反馈材料日',
  feedback_date2 string comment '第二次反馈意见日',
  receive_feedback_date2 string comment '接收第二次反馈材料日',
  review_date string comment '审查决定日',
  memo string comment '说明',
  comp_name string comment '[内部]申请人名称',
  progress_code bigint comment '审核进度代码',
  ann_date_ndrc string comment '审结日期',
  audit_event_id string comment '审核事件ID',
  audit_channel_code bigint comment '审核通道代码',
  feedback_date string comment '反馈回复日期',
  other_comp_id string comment '其他公司ID',
  other_comp_type_code bigint comment '其他公司类型代码',
  sec_code string comment '[内部]审批产品证券ID',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cfundbankaccount;
create table if not exists ty_ods.w_cfundbankaccount
(
  object_id string comment '对象ID',
  comp_id string comment '公司ID',
  comp_name string comment '公司名称',
  name_bank_account string comment '开户银行名称',
  account_name string comment '账户名称',
  bank_account string comment '银行账号',
  bank_number string comment '开户行编号',
  exchange_number string comment '交换行号',
  line_number string comment '联行行号',
  line_payment_system string comment '人行支付系统行号',
  update1 string comment '更新日期',
  is_effective bigint comment '是否有效',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cfundeventdateinformation;
create table if not exists ty_ods.w_cfundeventdateinformation
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  event_type bigint comment '事件类型编号',
  occurrence_date string comment '发生日期',
  disclosure_date string comment '披露日期',
  memo string comment '内容说明',
  date_created string comment '创建日期',
  s_info_code string comment '交易代码',
  s_info_name string comment '证券简称',
  type_code string comment '证券类型代码',
  language1 string comment '语言',
  eqy_record_dt string comment '权益登记日',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cfundfactionalstyle;
create table if not exists ty_ods.w_cfundfactionalstyle
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  sec_ind_code string comment '所属板块代码',
  entry_dt string comment '纳入日期',
  remove_dt string comment '剔除日期',
  memo string comment '[内部]备注',
  cur_sign bigint comment '最新标志',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cfundholdersmeeting;
create table if not exists ty_ods.w_cfundholdersmeeting
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  meeting_name string comment '会议名称',
  is_new bigint comment '最新标志',
  ann_dt string comment '公告日期',
  meeting_dt string comment '会议日期',
  meeting_type string comment '会议类型',
  meeting_content string comment '会议内容',
  is_intnet bigint comment '是否可以网络投票',
  smtgrecdate string comment 'A股股权登记日',
  spotmtgstartdate string comment '会议登记起始日',
  spotmtgenddate string comment '会议登记截止日',
  votingcode bigint comment '投票通道代码',
  meetevent_id string comment '会议事件ID',
  type_code bigint comment '品种类型代码',
  meeting_place string comment '会议召开地点',
  is_notarization bigint comment '是否经公证',
  resolution_ann_dt string comment '决议公告日',
  resolution_content string comment '决议内容',
  cost_tot decimal(20,4) comment '大会费用合计',
  attend_ratio decimal(20,4) comment '持有人出席比例',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cfundmanagement;
create table if not exists ty_ods.w_cfundmanagement
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id ',
  ann_date string comment '公告日期',
  s_info_manager_name string comment '姓名',
  s_info_manager_gender string comment '性别代码',
  s_info_manager_education string comment '学历',
  s_info_manager_nationality string comment '国籍',
  s_info_manager_birthyear string comment '出生日期',
  s_info_manager_startdate string comment '任职日期',
  s_info_manager_leavedate string comment '离职日期',
  s_info_manager_type string comment '管理层类别',
  s_info_manager_post string comment '公布职务名称',
  s_info_manager_introduction string comment '个人简历',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cfundportfoliochanges;
create table if not exists ty_ods.w_cfundportfoliochanges
(
  object_id string comment '对象ID',
  f_info_windcode string comment '基金代码',
  ann_dt string comment '公告日期',
  report_period string comment '报告期',
  s_info_windcode string comment '股票代码',
  change_type string comment '变动类型',
  accumulated_amount decimal(20,4) comment '累计金额',
  begin_net_asset_ratio decimal(20,4) comment '占期初基金资产净值比例',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cfundratesensitive;
create table if not exists ty_ods.w_cfundratesensitive
(
  object_id string comment '对象ID',
  f_info_windcode string comment 'Wind代码',
  report_period string comment '报告期',
  price_fluncuation decimal(20,4) comment '价格变动',
  change_amount decimal(20,4) comment '基金资产净值相对变动额',
  type_code bigint comment '敏感分析价格类型代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cfundstylecoefficient;
create table if not exists ty_ods.w_cfundstylecoefficient
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_change_date string comment '变动日期',
  date_closing_date string comment '引用数据的截止日期',
  style_coefficient decimal(20,4) comment '风格系数',
  growth_z decimal(20,4) comment '成长性Z分值',
  value_z decimal(20,4) comment '价值因子Z分值(ZVP)',
  avg_market_value decimal(20,4) comment '1年日均市值(万元)',
  gross_oper_rev decimal(20,4) comment '营业收入增长率(%)',
  gross_oper_netprofit decimal(20,4) comment '净利润增长率(%)',
  value_coefficient decimal(20,4) comment '调整市值系数',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cfundstylethreshold;
create table if not exists ty_ods.w_cfundstylethreshold
(
  object_id string comment '对象ID',
  s_change_date string comment '变动日期',
  threshold_large_stock decimal(20,4) comment '大盘股门限值(万元)',
  threshold_mid_stock decimal(20,4) comment '中盘股门限值(万元)',
  threshold_growth_stock decimal(20,4) comment '成长型门限值',
  threshold_value_stock decimal(20,4) comment '价值型门限值',
  date_closing_date string comment '引用数据的截止日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cfundtacode;
create table if not exists ty_ods.w_cfundtacode
(
  object_id string comment '对象ID',
  comp_id string comment '品种ID',
  type_code bigint comment '业务代码类型',
  s_code string comment '业务代码',
  s_sname string comment '业务简称',
  is_common bigint comment '是否通用代码',
  memo string comment '业务说明',
  comp_type_code bigint comment '主体类别代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cfundwindindexcomponent;
create table if not exists ty_ods.w_cfundwindindexcomponent
(
  object_id string comment '对象ID',
  s_info_windcode string comment '指数Wind代码',
  s_con_code string comment '成份板块代码',
  s_con_name string comment '成份板块名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cfundwindindexmembers;
create table if not exists ty_ods.w_cfundwindindexmembers
(
  object_id string comment '对象ID',
  s_con_code string comment '板块代码',
  s_con_name string comment '板块名称',
  s_info_windcode string comment '成份万得代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cfuturesarbitragecontract;
create table if not exists ty_ods.w_cfuturesarbitragecontract
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_info_ralatedcode string comment '关联证券Wind代码',
  s_relation_typcode bigint comment '关系类型代码',
  s_info_effective_dt string comment '生效日期',
  s_info_invalid_dt string comment '失效日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cfuturescontractmapping;
create table if not exists ty_ods.w_cfuturescontractmapping
(
  object_id string comment '对象ID',
  s_info_windcode string comment '连续(主力)合约Wind代码',
  fs_mapping_windcode string comment '映射月合约Wind代码',
  startdate string comment '起始日期',
  enddate string comment '截止日期',
  contract_id string comment '合约ID',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cfutureshedgingpositions;
create table if not exists ty_ods.w_cfutureshedgingpositions
(
  object_id string comment '对象ID',
  fs_info_sccode string comment '标准合约代码',
  fs_info_date string comment '日期',
  buy_hedging_quota decimal(20,4) comment '买套保额度(元)',
  buy_hedging_hold_amount decimal(20,4) comment '期货买套保持仓量(手)',
  sell_hedging_quota decimal(20,4) comment '卖套保额度(元)',
  sell_hedging_hold_amount decimal(20,4) comment '期货卖套保持仓量(手)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cfuturesinstock;
create table if not exists ty_ods.w_cfuturesinstock
(
  object_id string comment '对象ID',
  fs_info_scname string comment '标准合约名称',
  ann_date string comment '日期',
  in_stock_total decimal(20,4) comment '库存合计',
  in_stock decimal(20,4) comment '库存（注册成仓单）',
  available_in_stock decimal(20,4) comment '可用库容量',
  unit string comment '单位',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cfuturespositionlimit;
create table if not exists ty_ods.w_cfuturespositionlimit
(
  object_id string comment '对象ID',
  s_info_windcode string comment '月合约Wind代码',
  position_limit_type bigint comment '限仓对象类型代码',
  change_dt string comment '变动日期',
  position_limit bigint comment '持仓限定数量',
  position_limit_ratio decimal(20,4) comment '持仓限定比例',
  change_reason string comment '变动原因',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cfutureswarehousestocks;
create table if not exists ty_ods.w_cfutureswarehousestocks
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_info_code string comment '标准合约代码',
  ann_date string comment '日期',
  warehouse_region string comment '地区',
  warehouse_name string comment '仓库简称',
  deliverable_w decimal(20,4) comment '本周库存合计',
  on_warrant_w decimal(20,4) comment '本周库存（注册成仓单）',
  available_warehouse_w decimal(20,4) comment '本周可用库容量',
  quantity_unit string comment '单位',
  warehouse_in decimal(20,4) comment '入仓',
  warehouse_out decimal(20,4) comment '出仓',
  cancelled_warrants decimal(20,4) comment '注销仓单量',
  effective_forecast decimal(20,4) comment '有效预报',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cgbbenchmark;
create table if not exists ty_ods.w_cgbbenchmark
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '日期',
  s_dq_close decimal(20,4) comment '利率(%)',
  s_dq_open decimal(20,4) comment '开盘利率(%)',
  s_dq_high decimal(20,4) comment '最高利率(%)',
  s_dq_low decimal(20,4) comment '最低利率(%)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cgoldspotdescription;
create table if not exists ty_ods.w_cgoldspotdescription
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_info_code string comment '交易代码',
  s_info_name string comment '证券中文简称',
  s_info_exchmarket string comment '交易所',
  s_info_punit string comment '交易单位',
  s_info_margin string comment '交易保证金',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cgoldspoteodprices;
create table if not exists ty_ods.w_cgoldspoteodprices
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '日期',
  s_dq_open decimal(20,4) comment '开盘价(元)',
  s_dq_high decimal(20,4) comment '最高价(元)',
  s_dq_low decimal(20,4) comment '最低价(元)',
  s_dq_close decimal(20,4) comment '收盘价(元)',
  s_dq_avgprice decimal(20,4) comment '均价(元)',
  s_dq_volume decimal(20,4) comment '成交量(千克)',
  s_dq_amount decimal(20,4) comment '成交金额(元)',
  s_dq_oi decimal(20,4) comment '持仓量(手)',
  del_amt decimal(20,4) comment '交收量(手)',
  s_dq_settle decimal(20,4) comment '结算价(元)
',
  delay_pay_typecode bigint comment '延期补偿费支付方式向类别代码
',
  s_pct_chg decimal(20,4) comment '涨跌幅(%)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_chfundagency;
create table if not exists ty_ods.w_chfundagency
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_agency_name string comment '机构名称',
  s_relation_typcode string comment '关系类型代码',
  s_agency_nameid string comment '机构名称ID',
  ann_dt string comment '公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_chfundfee;
create table if not exists ty_ods.w_chfundfee
(
  object_id string comment '对象ID',
  f_info_compcode string comment '基金ID',
  f_info_fullname string comment '基金名称',
  s_info_windcode string comment '子基金Wind代码',
  sec_id string comment '子基金ID',
  feetypecode string comment '费率类型',
  change_dt string comment '变动日期',
  feeratio decimal(20,4) comment '费率(%)',
  supplementary string comment '费率补充说明',
  used bigint comment '是否有效',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_chfundlist;
create table if not exists ty_ods.w_chfundlist
(
  object_id string comment '对象ID',
  f_info_compcode string comment '基金ID',
  f_info_fullname string comment '基金名称',
  f_info_corp_fundmanagementid string comment '管理人公司ID',
  f_info_corp_fundmanagementcomp string comment '基金管理人',
  registration string comment '注册地代码',
  fundtype string comment '类别',
  start_dt string comment '纳入日期',
  end_dt string comment '终止日期',
  cur_sign bigint comment '最新标志',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_chgfinyearenddt;
create table if not exists ty_ods.w_chgfinyearenddt
(
  object_id string comment '对象ID',
  s_info_compcode string comment '品种ID',
  id_typecode bigint comment '品种类别代码',
  chg_typecode bigint comment '条款属性类型代码',
  start_dt string comment '起始日期',
  end_dt string comment '终止日期',
  finyearenddt string comment '条款',
  cur_sign bigint comment '是否最新',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_chinaetfpchredmmembers;
create table if not exists ty_ods.w_chinaetfpchredmmembers
(
  object_id string comment '对象ID',
  s_info_windcode string comment '基金Wind代码',
  trade_dt string comment '交易日期',
  s_con_windcode string comment '成份股Wind代码',
  s_con_stocknumber decimal(20,4) comment '股票数量',
  f_info_cashsubsign bigint comment '现金替代标志',
  f_info_casubpremra decimal(20,4) comment '现金替代溢价比例(%)',
  f_info_casubamount decimal(20,4) comment '固定替代金额(元)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_chinamutualfundfloatshare;
create table if not exists ty_ods.w_chinamutualfundfloatshare
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '交易日期',
  f_unit_floatshare decimal(20,4) comment '场内份额(份)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_chinamutualfundindportfolio;
create table if not exists ty_ods.w_chinamutualfundindportfolio
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  f_prt_enddate string comment '截止日期',
  s_info_csrcinduscode string comment '证监会行业编号',
  f_prt_indusvalue decimal(20,4) comment '持有行业市值(元)',
  f_prt_industonav decimal(20,4) comment '持有行业市值占基金净值比例(%)',
  f_prt_indposvalue decimal(20,4) comment '积极投资持有行业市值(元)',
  f_prt_indpospro decimal(20,4) comment '积极投资持有行业比例(%)',
  f_prt_indpassivevalue decimal(20,4) comment '指数投资持有行业市值(元)',
  f_prt_indpassivepro decimal(20,4) comment '指数投资持有行业比例(%)',
  f_prt_industonavchange decimal(20,4) comment '持有行业市值比例较上期变化(%)',
  s_info_csrcindusname string comment '行业名称',
  f_ann_date string comment '公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_chinamutualfundpchredm;
create table if not exists ty_ods.w_chinamutualfundpchredm
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  f_unit_rpstartdate string comment '报告期开始日期',
  f_unit_rpenddate string comment '报告期结束日期',
  f_unit_startshares decimal(20,4) comment '期初基金总份额(份)',
  f_unit_purchase decimal(20,4) comment '本期基金总申购份额(份)',
  f_unit_redemption decimal(20,4) comment '本期基金总赎回份额(份)',
  f_unit_endshares decimal(20,4) comment '期末基金总份额(份)',
  trade_dt string comment '公告日期',
  f_unit_startshares_total decimal(20,4) comment '期初基金总份额-合计',
  f_unit_endshares_total decimal(20,4) comment '期末基金总份额-合计',
  f_unit_purchase_total decimal(20,4) comment '本期基金总申购份额-合计',
  f_unit_redemption_total decimal(20,4) comment '本期基金总赎回份额-合计',
  is_merge_data bigint comment '是否为合并数据',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_chinamutualfundposestimation;
create table if not exists ty_ods.w_chinamutualfundposestimation
(
  object_id string comment '对象ID',
  s_info_windcode string comment '基金Wind代码',
  f_est_date string comment '估算日期',
  f_est_largecapweg decimal(20,4) comment '大市值组合权重',
  f_est_midcapweg decimal(20,4) comment '中市值组合权重',
  f_est_smallcapweg decimal(20,4) comment '小市值组合权重',
  f_est_position decimal(20,4) comment '基金仓位',
  f_est_nav decimal(20,4) comment '估算收盘净值(元)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_chinamutualfundrepnavper;
create table if not exists ty_ods.w_chinamutualfundrepnavper
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_date string comment '公告日期',
  f_info_reportperiod string comment '报告期',
  period_code string comment '期间代码',
  f_nav_return decimal(20,4) comment '净值增长率',
  f_nav_stddevreturn decimal(20,4) comment '净值增长率标准差',
  f_nav_benchreturn decimal(20,4) comment '业绩比较基准收益率',
  f_nav_benchstddev decimal(20,4) comment '业绩比较基准收益率标准差',
  f_nav_benchdevreturn decimal(20,4) comment '净值增长率减基准收益率',
  f_nav_stddevnavbench decimal(20,4) comment '净值增长率标准差减基准收益率标准差',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_chinamutualfundseattrading;
create table if not exists ty_ods.w_chinamutualfundseattrading
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_info_reportperiod string comment '报告期',
  s_info_securname string comment '证券公司简称',
  f_trade_stockam decimal(20,4) comment '股票交易金额(元)',
  f_trade_stockpro decimal(20,4) comment '股票交易金额占比(%)',
  f_trade_bondam decimal(20,4) comment '债券交易金额(元)',
  f_trade_bondpro decimal(20,4) comment '债券交易金额占比(%)',
  f_trade_repoam decimal(20,4) comment '回购交易金额(元)',
  f_trade_repopro decimal(20,4) comment '回购交易金额占比(%)',
  f_trade_sbam decimal(20,4) comment '股票债券成交金额(元)',
  f_trade_sbpro decimal(20,4) comment '股票债券交易量占比(%)',
  f_trade_warrantam decimal(20,4) comment '权证交易金额(元)',
  f_trade_warrantpro decimal(20,4) comment '权证交易金额占比(%)',
  f_trade_fundam decimal(20,4) comment '基金交易金额(元)',
  f_trade_fundpro decimal(20,4) comment '基金交易金额占比(%)',
  f_commissionam decimal(20,4) comment '交易佣金(元)',
  f_commissionpro decimal(20,4) comment '交易佣金占比(%)',
  crncy_code string comment '货币代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_chinaoptiondailystatistics;
create table if not exists ty_ods.w_chinaoptiondailystatistics
(
  object_id string comment '对象ID',
  s_info_code string comment '期权Wind代码',
  s_info_name string comment '期权名称',
  trade_dt string comment '交易日期',
  item_code bigint comment '类型',
  value decimal(20,4) comment '数量',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_chinaoptionmemberstatistics;
create table if not exists ty_ods.w_chinaoptionmemberstatistics
(
  object_id string comment '对象ID',
  s_info_code string comment '期权Wind代码',
  s_info_name string comment '期权名称',
  trade_dt string comment '交易日期',
  item_code bigint comment '类型',
  value decimal(20,4) comment '数量',
  rank bigint comment '名次',
  s_info_membername string comment '会员简称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_chinaoptionpreviousname;
create table if not exists ty_ods.w_chinaoptionpreviousname
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  begindate string comment '起始日期',
  enddate string comment '截至日期',
  ann_dt string comment '公告日期',
  s_info_name string comment '证券简称',
  changereason bigint comment '变动原因代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_chinaoptionvaluation;
create table if not exists ty_ods.w_chinaoptionvaluation
(
  object_id string comment '对象ID',
  s_info_windcode string comment '月合约Wind代码',
  trade_dt string comment '交易日期',
  w_anal_underlyingimpliedvol decimal(24,8) comment '隐含波动率(%)',
  w_anal_delta decimal(24,8) comment 'Delta',
  w_anal_theta decimal(24,8) comment 'Theta',
  w_anal_gamma decimal(24,8) comment 'Gamma',
  w_anal_vega decimal(24,8) comment 'Vega',
  w_anal_rho decimal(24,8) comment 'Rho',
  surged_limit decimal(24,8) comment '涨停价格',
  decline_limit decimal(24,8) comment '跌停价格',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cindexfuturespositions;
create table if not exists ty_ods.w_cindexfuturespositions
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '交易日期',
  fs_info_membername string comment '会员简称',
  fs_info_type bigint comment '类型',
  fs_info_positionsnum decimal(20,4) comment '持仓数量',
  fs_info_rank bigint comment '名次',
  s_oi_positionsnumc decimal(20,4) comment '比上交易日增减',
  s_info_compcode string comment '会员ID ',
  sec_id string comment '证券ID',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_clientofcreditratingagency;
create table if not exists ty_ods.w_clientofcreditratingagency
(
  object_id string comment '对象ID',
  s_info_compname string comment '公司名称',
  s_info_compcode string comment '评级机构ID',
  s_info_creditratingagency string comment '评级机构代码',
  client_compname string comment '公司(客户)名称',
  client_compcode string comment '公司(客户)ID',
  ann_dt string comment '公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cmffixedinvestmentrate;
create table if not exists ty_ods.w_cmffixedinvestmentrate
(
  object_id string comment '对象ID',
  f_info_windcode string comment 'Wind代码',
  trade_dt string comment '交易日期',
  f_type_code string comment '投资类型代码',
  f_type_name string comment '基金投资类型名称',
  f_fixed_investment_cycle string comment '定投周期',
  f_fixed_amount bigint comment '定投金额',
  f_purchase_rate decimal(20,4) comment '申购费率',
  f_dividend_method string comment '分红方式',
  f_avgreturn_thisyear decimal(20,6) comment '近一年定投总收益率',
  f_sfrank_recentyeart string comment '近一年定投同类排名',
  f_annualyeild_thisyear decimal(20,6) comment '近一年定投年化收益率',
  f_recentyeart_thisyear string comment '近一年定投年化收益同类排名',
  f_avgreturn_twoyear decimal(20,6) comment '近二年定投总收益率',
  f_sfrank_recentyeart_twosyear string comment '近二年定投同类排名',
  f_annualyeild_twosyear decimal(20,6) comment '近二年定投年化收益率',
  f_annualyeild_twoyear string comment '近二年定投年化收益同类排名',
  f_avgreturn_threeyear decimal(20,6) comment '近三年定投总收益率',
  f_sfrank_threesyear string comment '近三年定投同类排名',
  f_annualyeild_threesyear decimal(20,6) comment '近三年定投年化收益率',
  f_annualyeild_threeyear string comment '近三年定投年化收益同类排名',
  f_avgreturn_fiveyear decimal(20,6) comment '近五年定投总收益率',
  f_sfrank_recentyeart_fivesyear string comment '近五年定投同类排名',
  f_annualyeild_fivesyear decimal(20,6) comment '近五年定投年化收益率',
  f_annualyeild_fiveyear string comment '近五年定投年化收益同类排名',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cmfholder;
create table if not exists ty_ods.w_cmfholder
(
  object_id string comment '对象ID',
  s_info_windcode string comment '证券ID',
  ann_dt string comment '公告日期',
  s_fa_latelyrd string comment '报告期',
  s_info_enddate string comment '截止日期',
  b_info_holder string comment '持有人',
  b_info_holdamount decimal(20,4) comment '数量(股\张\份)',
  b_issuer_sharecategory string comment '[内部]股东类型： 1 个人；2 公司',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



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



drop table if exists ty_ods.w_cmfholdingratioanomaly;
create table if not exists ty_ods.w_cmfholdingratioanomaly
(
  object_id string comment '对象ID',
  f_info_windcode string comment 'Wind代码',
  f_unit_rpstartdate string comment '报告期开始日期',
  f_unit_rpenddate string comment '报告期截止日期',
  trade_dt string comment '公告日期',
  f_inquirer_type string comment '投资者类别',
  f_inquirer_type_num bigint comment '投资者序号',
  f_holding_time string comment '持有时间区间',
  f_start_num_holder decimal(20,4) comment '期初持有份额',
  f_unit_pch decimal(20,4) comment '申购份额',
  f_unit_redm decimal(20,4) comment '赎回份额',
  f_end_num_holder decimal(20,4) comment '期末持有份额',
  f_end_num_holder_proportion decimal(20,4) comment '期末持有份额占基金份额比例',
  is_merge bigint comment '是否为合并数据',
  f_inquirer_typecode string comment '投资者类别代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cmfiopvnav;
create table if not exists ty_ods.w_cmfiopvnav
(
  object_id string comment '对象ID',
  f_info_windcode string comment 'Wind代码',
  price_date string comment '日期',
  f_iopv_nav decimal(20,8) comment 'IOPV收盘净值',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cmfissuingdatepredict;
create table if not exists ty_ods.w_cmfissuingdatepredict
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_info_compcode string comment '基金ID',
  start_dt string comment '报告起始日',
  end_dt string comment '报告截止日',
  s_stm_actual_issuingdate string comment '实际披露日期',
  s_stm_correct_num string comment '更正公告披露次数',
  s_stm_correct_issuingdate string comment '更正公告披露日期',
  s_operation_review string comment '市场与基金运作回顾',
  s_rate_ratingoutlook string comment '市场展望',
  s_ratingoutlook string comment '市场展望(精简版)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cmfnavoperationrecord;
create table if not exists ty_ods.w_cmfnavoperationrecord
(
  object_id string comment '对象ID',
  f_info_windcode string comment 'Wind代码',
  price_date string comment '净值截止日期',
  handle_date string comment '处理日期',
  handle_action string comment '处理动作',
  f_nav_old decimal(11,6) comment '调整前净值',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cmfpreferentialfee;
create table if not exists ty_ods.w_cmfpreferentialfee
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  sec_id string comment '证券ID',
  type_code bigint comment '优惠活动类型代码',
  ann_dt string comment '公告日期',
  start_dt string comment '费率优惠开始日期',
  end_dt string comment '费率优惠截止日期',
  amountdownlimit decimal(20,4) comment '申购金额下限(万元)',
  amountuplimit decimal(20,4) comment '申购金额上限(万元)',
  preferential_rate decimal(20,4) comment '优惠费率(%)',
  way_type bigint comment '优惠活动参与方式代码',
  comp_name string comment '参加优惠活动的代销机构名称',
  comp_id string comment '参加优惠活动的代销机构公司ID',
  memo string comment '备注',
  sequence bigint comment '序号',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cmfrisklevel;
create table if not exists ty_ods.w_cmfrisklevel
(
  object_id string comment '对象ID',
  f_info_windcode string comment 'Wind代码',
  risk_level string comment '基金风险等级',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cmfsellingagents;
create table if not exists ty_ods.w_cmfsellingagents
(
  object_id string comment '对象ID',
  f_info_windcode string comment 'WIND代码',
  f_ann_date string comment '公告日期',
  f_agency_nameid string comment '中介机构公司ID',
  f_agency_name string comment '机构名称',
  f_relation string comment '关系类型',
  f_begin_date string comment '起始日期',
  f_end_date string comment '终止日期',
  cur_sign bigint comment '最新标志',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cmfundoperateperiod;
create table if not exists ty_ods.w_cmfundoperateperiod
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  opr_period bigint comment '期数',
  pch_startdt string comment '开放申购起始日',
  pch_enddt string comment '开放申购截止日',
  opr_startdt string comment '运作起始日',
  opr_enddt string comment '运作结束日',
  redm_startdt string comment '开放赎回起始日',
  redm_enddt string comment '开放赎回截止日',
  anticipate_annualyeild decimal(20,4) comment '预期年化收益率',
  annualyeild decimal(20,4) comment '实际年化收益率',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cmmfportfolioptm;
create table if not exists ty_ods.w_cmmfportfolioptm
(
  object_id string comment '对象ID',
  f_info_windcode string comment 'Wind代码',
  ann_dt string comment '公告日期',
  report_period string comment '报告期',
  f_ptm_top decimal(20,4) comment '剩余期下限',
  f_ptm_bottom decimal(20,4) comment '剩余期上限',
  ratio_assert_nav decimal(20,4) comment '资产占净值比例(%)',
  ratio_liab_nav decimal(20,4) comment '负债占净值比例(%)',
  typecode string comment '类型',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



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



drop table if exists ty_ods.w_cmoneymarketdailyfincome;
create table if not exists ty_ods.w_cmoneymarketdailyfincome
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  f_info_bgndate string comment '起始日期',
  f_info_enddate string comment '截止日期',
  f_info_unityield decimal(20,4) comment '单位净值',
  f_accunitnav decimal(20,4) comment '累计单位净值',
  f_income_per_million decimal(20,5) comment '万份收益',
  f_info_yearlyroe decimal(20,4) comment '七日年化收益率',
  ann_date string comment '公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cnbdinvestorstatistics;
create table if not exists ty_ods.w_cnbdinvestorstatistics
(
  object_id string comment '对象ID',
  months string comment '月份',
  investortype string comment '投资者类型',
  trusttype string comment '托管类型',
  num_endmonths decimal(20,4) comment '月末数量',
  num_incyear decimal(20,4) comment '年增数量',
  num_endyear decimal(20,4) comment '上年末数量',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cnusdbonddesc;
create table if not exists ty_ods.w_cnusdbonddesc
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  b_info_fullname string comment '债券名称',
  b_info_issuer string comment '发行人',
  b_issue_announcement string comment '发行公告日',
  b_issue_firstissue string comment '发行起始日',
  b_issue_lastissue string comment '发行截止日',
  b_issue_amountplan decimal(20,4) comment '计划发行总量(亿元)',
  b_issue_amountact decimal(20,4) comment '实际发行总量(亿元)',
  b_info_issueprice decimal(20,4) comment '发行价格',
  b_info_par bigint comment '面值',
  b_info_couponrate decimal(20,4) comment '发行票面利率(%)',
  b_info_spread decimal(20,4) comment '利差(%)',
  b_info_carrydate string comment '计息起始日',
  b_info_enddate string comment '计息截止日',
  b_info_maturitydate string comment '到期日',
  b_info_term_year_ decimal(20,4) comment '债券期限(年)',
  b_info_term_day_ decimal(20,4) comment '债券期限(天)',
  b_info_paymentdate string comment '兑付日',
  b_info_paymenttype bigint comment '计息方式',
  b_info_interestfrequency string comment '付息频率',
  b_info_form string comment '债券形式',
  b_info_coupon bigint comment '息票品种',
  b_info_interesttype bigint comment '附息利率品种',
  b_info_act decimal(20,4) comment '特殊年计息天数',
  b_issue_fee decimal(20,4) comment '发行手续费率(%)',
  b_redemption_feeration decimal(20,4) comment '兑付手续费率(%)',
  b_info_taxrate decimal(20,4) comment '所得税率',
  crncy_code string comment '货币代码',
  s_info_name string comment '债券简称',
  s_info_exchmarket string comment '交易所',
  b_info_guarantor string comment '担保人',
  b_info_guartype bigint comment '担保方式',
  b_info_listdate string comment '上市日期',
  b_info_yearsnumber bigint comment '年内序号',
  s_div_recorddate string comment '兑付登记起始日',
  b_info_codebyplacing string comment '上网发行认购代码',
  b_info_delistdate string comment '退市日期',
  b_info_issuetype bigint comment '发行方式',
  b_info_guarintroduction string comment '担保简介',
  b_info_bgndbyplacing string comment '上网发行起始日期',
  b_info_enddbyplacing string comment '上网发行截止日期',
  b_info_amountbyplacing decimal(20,4) comment '上网发行数量(亿元)',
  b_info_underwritingcode bigint comment '承销方式代码',
  b_info_issuercode string comment '发行人编号',
  b_info_formercode string comment '原债券代码',
  b_info_coupontxt string comment '利率说明',
  is_failure bigint comment '是否发行失败',
  is_crossmarket bigint comment '是否跨市场',
  b_info_coupondatetxt string comment '付息日说明',
  b_info_subordinateornot bigint comment '是否次级债或混合资本债',
  b_tendrst_referyield decimal(20,4) comment '参考收益率',
  b_info_curpar decimal(20,4) comment '最新面值',
  s_info_formerwindcode string comment '原Wind代码',
  is_corporate_bond bigint comment '是否公司债',
  b_info_issuertype string comment '发行人类型',
  b_info_specialbondtype string comment '特殊债券类型',
  is_payadvanced string comment '是否可提前兑付',
  is_callable string comment '是否可赎回',
  is_chooseright string comment '是否有选择权',
  is_netprice bigint comment '是否净价',
  is_act_days bigint comment '是否按实际天数计息',
  is_incbonds bigint comment '是否增发债',
  issue_object string comment '发行对象',
  b_info_actualbenchmark string comment '计息基准',
  register_file_type_code bigint comment '注册文件类型代码',
  register_file_number string comment '注册文件号',
  list_ann_date string comment '上市公告日',
  reimbursement string comment '偿还方式',
  bond_rating string comment '发行时债券评级',
  ann_date string comment '公告日期',
  b_issue_amount_max decimal(24,8) comment '发行金额上限',
  b_info_guarantee_id string comment '担保人ID',
  b_info_pinyin string comment '简称拼音',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_commitprofit;
create table if not exists ty_ods.w_commitprofit
(
  object_id string comment '对象ID',
  event_id string comment '事件ID',
  targetcomp_code string comment '标的公司ID',
  targetcompname string comment '[内部]标的公司名称',
  s_info_windcode string comment 'Wind代码',
  s_info_commitann_dt string comment '承诺公告日',
  report_period string comment '报告期',
  commitnetprofit decimal(20,4) comment '承诺净利润(元)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_commitprofitsummary;
create table if not exists ty_ods.w_commitprofitsummary
(
  object_id string comment '对象ID',
  event_id string comment '事件ID',
  s_info_windcode string comment 'Wind代码',
  report_period string comment '报告期',
  s_info_commitann_dt string comment '承诺公告日',
  ann_dt string comment '最新公告日',
  targetcomp string comment '标的公司',
  commitnetprofit decimal(20,4) comment '承诺净利润(元)',
  actualnetprofit decimal(20,4) comment '实际净利润(元)',
  iscommitprofitsupply bigint comment '是否承诺利润补充',
  isneedsupply bigint comment '是否需要补充',
  supplycontent bigint comment '补偿内容代码',
  injectedassetnetprofitest decimal(20,4) comment '注入资产净利润预测(元)',
  earningest decimal(20,4) comment '上市公司盈利预测(元)',
  supplytype bigint comment '盈利补偿方法代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_companyaward;
create table if not exists ty_ods.w_companyaward
(
  object_id string comment '对象ID',
  s_info_chineseintroduction string comment '机构简称',
  s_info_compcode string comment '机构公司ID',
  s_info_award_code bigint comment '奖项代码',
  s_info_year string comment '年度',
  s_info_ranking bigint comment '排名',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_companylineofcredit;
create table if not exists ty_ods.w_companylineofcredit
(
  object_id string comment '对象ID',
  comp_id string comment '公司id',
  ann_dt string comment '公告日期',
  end_dt string comment '截止日期',
  credit_no decimal(24,8) comment '授信额度(亿元)',
  credit_used decimal(24,8) comment '已使用授信额度(亿元)',
  credit_unused decimal(24,8) comment '未使用授信额度(亿元)',
  credit_compname string comment '授信机构名称',
  credit_compid string comment '授信机构公司ID（废弃）',
  crncy_code string comment '货币代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_consensusexpectationfactor;
create table if not exists ty_ods.w_consensusexpectationfactor
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_info_compcode string comment '公司ID',
  trade_dt string comment '日期',
  s_west_netprofit_ftm_chg_1m decimal(20,6) comment '一致预测净利润（未来12个月）的变化_1M',
  s_west_netprofit_ftm_chg_3m decimal(20,6) comment '一致预测净利润（未来12个月）的变化_3M',
  s_west_netprofit_ftm_chg_6m decimal(20,6) comment '一致预测净利润（未来12个月）的变化_6M',
  s_west_eps_ftm_chg_1m decimal(20,6) comment '一致预测每股收益（未来12个月）的变化_1M',
  s_west_eps_ftm_chg_3m decimal(20,6) comment '一致预测每股收益（未来12个月）的变化_3M',
  s_west_eps_ftm_chg_6m decimal(20,6) comment '一致预测每股收益（未来12个月）的变化_6M',
  s_west_sales_ftm_chg_1m decimal(20,6) comment '一致预测营业收入（未来12个月）的变化_1M',
  s_west_sales_ftm_chg_3m decimal(20,6) comment '一致预测营业收入（未来12个月）的变化_3M',
  s_west_sales_ftm_chg_6m decimal(20,6) comment '一致预测营业收入（未来12个月）的变化_6M',
  s_west_netprofit_fy1_chg_1m decimal(20,6) comment '一致预测净利润（FY1）的变化_1M',
  s_west_netprofit_fy1_chg_3m decimal(20,6) comment '一致预测净利润（FY1）的变化_3M',
  s_west_netprofit_fy1_chg_6m decimal(20,6) comment '一致预测净利润（FY1）的变化_6M',
  s_west_eps_fy1_chg_1m decimal(20,6) comment '一致预测每股收益（FY1）的变化_1M',
  s_west_eps_fy1_chg_3m decimal(20,6) comment '一致预测每股收益（FY1）的变化_3M',
  s_west_eps_fy1_chg_6m decimal(20,6) comment '一致预测每股收益（FY1）的变化_6M',
  s_west_sales_fy1_chg_1m decimal(20,6) comment '一致预测营业收入(FY1）的变化_1M',
  s_west_sales_fy1_chg_3m decimal(20,6) comment '一致预测营业收入(FY1）的变化_3M',
  s_west_sales_fy1_chg_6m decimal(20,6) comment '一致预测营业收入(FY1）的变化_6M',
  s_west_netprofit_ftm_1m decimal(20,6) comment '一致预测净利润（未来12个月）的变化率_1M',
  s_west_netprofit_ftm_3m decimal(20,6) comment '一致预测净利润（未来12个月）的变化率_3M',
  s_west_netprofit_ftm_6m decimal(20,6) comment '一致预测净利润（未来12个月）的变化率_6M',
  s_west_eps_ftm_1m decimal(20,6) comment '一致预测每股收益（未来12个月）的变化率_1M',
  s_west_eps_ftm_3m decimal(20,6) comment '一致预测每股收益（未来12个月）的变化率_3M',
  s_west_eps_ftm_6m decimal(20,6) comment '一致预测每股收益（未来12个月）的变化率_6M',
  s_west_sales_ftm_1m decimal(20,6) comment '一致预测营业收入（未来12个月）的变化率_1M',
  s_west_sales_ftm_3m decimal(20,6) comment '一致预测营业收入（未来12个月）的变化率_3M',
  s_west_sales_ftm_6m decimal(20,6) comment '一致预测营业收入（未来12个月）的变化率_6M',
  s_west_netprofit_fy1_1m decimal(20,6) comment '一致预测净利润（FY1）变化率_1M',
  s_west_netprofit_fy1_3m decimal(20,6) comment '一致预测净利润（FY1）变化率_3M',
  s_west_netprofit_fy1_6m decimal(20,6) comment '一致预测净利润（FY1）变化率_6M',
  s_west_eps_fy1_1m decimal(20,6) comment '一致预测每股收益（FY1）变化率_1M',
  s_west_eps_fy1_3m decimal(20,6) comment '一致预测每股收益（FY1）变化率_3M',
  s_west_eps_fy1_6m decimal(20,6) comment '一致预测每股收益（FY1）变化率_6M',
  s_west_sales_fy1_1m decimal(20,6) comment '一致预测营业收入(FY1）变化率_1M',
  s_west_sales_fy1_3m decimal(20,6) comment '一致预测营业收入(FY1）变化率_3M',
  s_west_sales_fy1_6m decimal(20,6) comment '一致预测营业收入(FY1）变化率_6M',
  s_west_eps_fygrowth decimal(20,6) comment '一致预测每股收益（FY2)与一致预测每股收益(FY1)的变化率',
  s_west_netprofitmaxmin_fy1 decimal(20,6) comment '一致预测净利润（FY1）最大与一致预测净利润（FY1）最小值的变化率',
  s_west_epsmaxmin_fy1 decimal(20,6) comment '一致预测每股收益（FY1）最大与一致预测每股收益（FY1）最小值的变化率',
  s_west_salesmaxmin_fy1 decimal(20,6) comment '一致预测营业收入（FY1）最大与一致预测营业收入（FY1）最小值的变化率',
  s_west_stdnetprofit_fy1 decimal(20,6) comment '一致预测净利润（FY1）标准差',
  s_west_stdeps_fy1 decimal(20,6) comment '一致预测每股收益（FY1）标准差',
  s_west_stdsales_fy1 decimal(20,6) comment '一致预测营业收入（FY1）标准差',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
 COMMENT '一致预期因子'
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_coptioncontprochange;
create table if not exists ty_ods.w_coptioncontprochange
(
  object_id string comment '对象ID',
  contract_id string comment '合约代码',
  item string comment '变更字段名称',
  change_dt string comment '变更日期',
  s_info_old string comment '变更前',
  s_info_new string comment '变更后',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_coptiondescriptionchange;
create table if not exists ty_ods.w_coptiondescriptionchange
(
  object_id string comment '对象ID',
  s_info_windcode string comment '期权月合约代码',
  s_change_date string comment '调整日期',
  s_info_code_old string comment '原交易代码',
  s_info_name_old string comment '原合约简称',
  s_exercise_price_old decimal(20,4) comment '原行权价（元）',
  s_unit_old decimal(20,4) comment '原合约单位（股）',
  s_info_code_new string comment '新交易代码',
  s_info_name_new string comment '新合约简称',
  s_exercise_price_new decimal(20,4) comment '新行权价（元）',
  s_unit_new decimal(20,4) comment '新合约单位（股）',
  s_change_reason string comment '调整原因',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_coptionembeddedbondvaluation;
create table if not exists ty_ods.w_coptionembeddedbondvaluation
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '日期',
  price_type_code bigint comment '价格类型代码',
  price_type string comment '价格类型',
  b_anal_nxoptiondate string comment '最近行权日',
  b_anal_termifexercise decimal(22,4) comment '行权剩余期限',
  b_anal_ytm_ifexe decimal(24,8) comment '行权收益率',
  b_anal_durationifexercise decimal(24,8) comment '行权久期',
  b_anal_modiduration_ifexe decimal(24,8) comment '行权修正久期',
  b_anal_convexity_ifexe decimal(24,8) comment '行权凸性',
  b_anal_basevalue_ifexe decimal(24,8) comment '行权基点价值',
  b_anal_bduration_ifexe decimal(24,8) comment '行权基准久期',
  b_anal_bconvexity_ifexe decimal(24,8) comment '行权基准凸性',
  b_anal_sduration_ifexe decimal(24,8) comment '行权利差久期',
  b_anal_sconvexity_ifexe decimal(24,8) comment '行权利差凸性',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_countryandareacode;
create table if not exists ty_ods.w_countryandareacode
(
  object_id string comment '对象ID',
  is_valid bigint comment '是否有效',
  release_date timestamp comment '发布日期',
  country_code_3 string comment '国家及地区代码(3位)',
  continent string comment '所属洲',
  country_code_2 string comment '国家及地区代码(2位)',
  name string comment '国家及地区名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cpsagency;
create table if not exists ty_ods.w_cpsagency
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_agency_name string comment '机构名称',
  s_agency_nameid string comment '中介机构公司ID',
  s_relation_typcode string comment '关系类型代码',
  begindate string comment '起始日期',
  enddate string comment '终止日期',
  cur_sign bigint comment '最新标志',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cpsplacementdetails;
create table if not exists ty_ods.w_cpsplacementdetails
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_holder_name string comment '[内部]获配公司名称',
  s_info_compcode string comment '法人投资者ID',
  typeofinvestor string comment '法人投资者类型',
  placement decimal(20,4) comment '获配数量(万股/万张)',
  trade_dt string comment '配售截止日期',
  ann_dt string comment '公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_creditratingdescription;
create table if not exists ty_ods.w_creditratingdescription
(
  object_id string comment '对象ID',
  b_est_rating_inst string comment '信用等级',
  b_est_institute string comment '评估机构代码',
  b_typcode string comment '评级类型',
  invest_grade string comment '投资等级',
  grade_definition string comment '含义',
  grade_num decimal(20,4) comment '等级序号',
  common_grade bigint comment '通用等级',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_csindusanalysis;
create table if not exists ty_ods.w_csindusanalysis
(
  object_id string comment '对象ID',
  trade_dt string comment '交易日期',
  industriescode string comment '行业代码',
  marketcode bigint comment '市场代码',
  indust_val_pe decimal(20,4) comment '市盈率-加权平均',
  indust_val_pe_ttm decimal(20,4) comment '市盈率【TTM】-加权平均',
  indust_val_pb decimal(20,4) comment '市净率',
  sample_num decimal(20,4) comment '样本券个数',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_currencycode;
create table if not exists ty_ods.w_currencycode
(
  object_id string comment '对象ID',
  crncy_name string comment '货币名称',
  currency_code string comment '货币代码',
  main_currency_code string comment '主币货币代码',
  pip_value decimal(20,4) comment 'pip value',
  main_currency_ratio bigint comment '主辅币比例',
  latest_logo bigint comment '最新标志',
  memo string comment '备注',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_cwarrantholder;
create table if not exists ty_ods.w_cwarrantholder
(
  object_id string comment '对象ID',
  f_info_windcode string comment 'Wind代码',
  end_date string comment '日期',
  holder string comment '持有人',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_dailyvaluationfactor;
create table if not exists ty_ods.w_dailyvaluationfactor
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '交易日期',
  s_dfa_lnmv decimal(20,4) comment '对数市值（元）',
  s_dfa_lntotassets decimal(20,4) comment '对数总资产（元）',
  s_dfa_floatmv decimal(20,4) comment '自由流通市值（元）',
  s_dfa_lnfloatmv decimal(20,4) comment '对数自由流通市值（元）',
  s_dfa_opps decimal(20,4) comment '每股营业利润(TTM)（元）',
  s_dfa_pettm_deducted decimal(20,4) comment '扣非后市盈率(TTM)',
  s_dfa_mvtoebitda decimal(20,4) comment '总市值/EBITDA(TTM反推法)',
  s_dfa_profittomv decimal(20,4) comment '收益市值比(TTM)（%）',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
 COMMENT '对数及其他日估值因子'
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_financialqualification;
create table if not exists ty_ods.w_financialqualification
(
  object_id string comment '对象ID',
  organization_name string comment '机构公布名称',
  financial_type string comment '金融机构资格类型',
  acquisition_date string comment '获得日期',
  revoke_date string comment '撤销日期',
  is_effective bigint comment '是否有效',
  s_info_name string comment '公司简称',
  agency_typcode string comment '机构类型',
  s_info_compcode string comment '公司ID',
  financial_type_num bigint comment '金融机构资格类型代码',
  qualification_code string comment '资格编码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_findexperformance;
create table if not exists ty_ods.w_findexperformance
(
  object_id string,
  s_info_windcode string,
  trade_dt string,
  pct_chg_recent1m decimal(20,6),
  pct_chg_recent3m decimal(20,6),
  pct_chg_recent6m decimal(20,6),
  pct_chg_recent1y decimal(20,6),
  pct_chg_recent2y decimal(20,6),
  pct_chg_recent3y decimal(20,6),
  pct_chg_recent4y decimal(20,6),
  pct_chg_recent5y decimal(20,6),
  pct_chg_recent6y decimal(20,6),
  pct_chg_thisweek decimal(20,6),
  pct_chg_thismonth decimal(20,6),
  pct_chg_thisquarter decimal(20,6),
  pct_chg_thisyear decimal(20,6),
  si_pct_chg decimal(20,6),
  annualyeild decimal(20,6),
  std_dev_6m decimal(20,6),
  std_dev_1y decimal(20,6),
  std_dev_2y decimal(20,6),
  std_dev_3y decimal(20,6),
  sharpratio_6m decimal(20,6),
  sharpratio_1y decimal(20,6),
  sharpratio_2y decimal(20,6),
  sharpratio_3y decimal(20,6),
  pct_chg_recent1w decimal(20,6),
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_finnotesaccountspayable;
create table if not exists ty_ods.w_finnotesaccountspayable
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  item_data string comment '数据内容',
  item_type_code string comment '项目类别代码',
  ann_item string comment '项目公布名称',
  item_amount decimal(20,4) comment '项目金额',
  item_name string comment '项目容错名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_finnotesdetail;
create table if not exists ty_ods.w_finnotesdetail
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
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
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_forexoptiondelta;
create table if not exists ty_ods.w_forexoptiondelta
(
  object_id string comment '对象ID',
  crncy_code string comment '外汇品种代码',
  trade_dt string comment '交易日期',
  anal_curveterm string comment '标准期限',
  maturitydate string comment '到期日',
  maturity_day bigint comment '到期天数',
  spot_price_type_code bigint comment '即期价格类型代码',
  spot_price decimal(20,4) comment '即期价格',
  rmb_rate_type_code bigint comment '人民币利率类型代码',
  interest_rate decimal(20,4) comment '本币利率',
  volatility_type_code bigint comment '波动率类型代码',
  foreign_currency_rate decimal(20,4) comment '外币利率',
  implied_volatility decimal(20,4) comment '隐含波动率',
  foreign_swap_point decimal(20,4) comment '外汇掉期点',
  executive_price decimal(20,4) comment '执行价格',
  call_option_delta decimal(20,4) comment '看涨期权delta',
  put_option_delta decimal(20,4) comment '看跌期权delta',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_fundbondportfolio;
create table if not exists ty_ods.w_fundbondportfolio
(
  object_id string comment '对象ID',
  s_info_code string comment '基金代码',
  deadline string comment '截止日期',
  b_info_creditrating bigint comment '债券评级代码',
  rating_value_type bigint comment '评级取值类型',
  market_value decimal(20,4) comment '市值',
  net_assets_ratio decimal(20,4) comment '占净资产比例',
  currency_code string comment '市值货币代码',
  position_type_code bigint comment '持仓类型代码',
  ann_date string comment '公告日期',
  announce_rating_code string comment '公布评级代码',
  comp_id string comment '公司ID',
  rating_type_code bigint comment '评级品种类别代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_fundcreditrecord;
create table if not exists ty_ods.w_fundcreditrecord
(
  object_id string comment '对象ID',
  event_id string comment '事件ID',
  regulators_id string comment '监管机构ID',
  ann_date string comment '公告日期',
  effective_date string comment '生效日期',
  regulatory_object_name string comment '监管对象名称',
  regulatory_object_id string comment '监管对象ID',
  regulatory_object_code bigint comment '监管对象类别代码',
  regulatory_object_type bigint comment '监管对象类型代码',
  measures_disposition string comment '处分措施',
  measures_disposition_code bigint comment '处分措施代码',
  punishment_measures_code bigint comment '处罚措施代码',
  penalty_amount decimal(24,8) comment '处罚金额',
  business_restrictive_measures bigint comment '业务资格限制措施代码',
  punishment_time_code bigint comment '处分期限代码',
  debar_measures_code bigint comment '市场禁入措施代码',
  institution_id string comment '处罚时所在机构ID',
  irregularities string comment '违规事项',
  legal_basis string comment '法律依据',
  detailed_content string comment '详细内容',
  type_code bigint comment '业务类型代码',
  involving_comp_id string comment '涉及公司ID',
  is_effective bigint comment '是否生效',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_futuresexchangeproductcode;
create table if not exists ty_ods.w_futuresexchangeproductcode
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  business_type_code bigint comment '业务代码类型',
  business_code string comment '业务代码',
  business_abbreviation string comment '业务简称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_globalmarkettradingtime;
create table if not exists ty_ods.w_globalmarkettradingtime
(
  object_id string comment '对象ID',
  exchange_sname_eng string comment '交易所英文简称',
  exchange_name string comment '交易所中文名称',
  securities_type string comment '交易品种描述',
  trading_hours_code string comment '交易时段编码',
  trading_hours string comment '交易时段',
  trading_hours_2 string comment '交易时段(新)',
  exchange_eng_name string comment '交易所英文名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_globalworkingday;
create table if not exists ty_ods.w_globalworkingday
(
  object_id string comment '对象ID',
  working_date string comment '日期',
  country_code string comment '国家或地区代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_hdrinfo;
create table if not exists ty_ods.w_hdrinfo
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  end_date string comment '截止日期',
  issued_shares decimal(20,4) comment '基础证券股份数(万股)',
  share_code string comment '基础证券id',
  hdr_stand_for_shares decimal(20,4) comment 'R:O比率',
  issued_hdrs decimal(20,4) comment '已发行凭证份额数(万份)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_hkcomptypeofreportperiod;
create table if not exists ty_ods.w_hkcomptypeofreportperiod
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  enddate string comment '截止日期(报告期)',
  s_info_comptype string comment '公司类型代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_hkshareagency;
create table if not exists ty_ods.w_hkshareagency
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  sec_id string comment '证券id',
  s_info_compcode string comment '公司id',
  ann_dt string comment '公告日期',
  agencyname string comment '机构名称',
  agencycode string comment '机构公司ID',
  type_code string comment '关系类型代码',
  scp string comment '业务范围',
  start_dt string comment '起使日期',
  end_dt string comment '终止日期',
  cur_sign bigint comment '最新标志',
  op_date string comment '操作日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_hksharecompanyholdshares;
create table if not exists ty_ods.w_hksharecompanyholdshares
(
  object_id string comment '对象ID',
  relations_code string comment '关联关系代码',
  s_capitaloperation_comainbus string comment '被参控公司主营业务',
  s_info_compcode string comment '公司ID',
  s_capitaloperation_companyid string comment '被参控公司ID',
  s_capitaloperation_amount decimal(24,8) comment '投资金额(万元)',
  operationcrncy_code string comment '货币代码',
  voting_rights decimal(20,4) comment '表决权比例',
  is_consolidate bigint comment '是否纳入报表合并范围',
  enddate string comment '截止日期',
  s_capitaloperation_coregcap decimal(24,8) comment '被参股公司注册资本(万元)',
  operationcrncy_code2 string comment '货币代码2',
  s_capitaloperation_companyname string comment '被参控公司名称',
  ann_dt string comment '公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_hksharedateofboardmeeting;
create table if not exists ty_ods.w_hksharedateofboardmeeting
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  ann_dt string comment '公告日期',
  meet_dt string comment '会议日期',
  fst_meet_dt string comment '首次披露会议日期',
  meet_ctnt string comment '事项',
  period string comment '期间说明',
  end_dt string comment '截止日',
  s_months string comment '期间间隔',
  tel_meet string comment '电话会议概要',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_hksharefinancialderivative;
create table if not exists ty_ods.w_hksharefinancialderivative
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  begindate string comment '起始日期',
  enddate string comment '截止日期',
  interval_length decimal(20,4) comment '区间长度(月)',
  fiscalyear string comment '会计年度(Wind判定)',
  report_type string comment '报告类型',
  statement_type string comment '报表类型',
  crncy_code string comment '货币代码',
  tot_shr decimal(20,4) comment '期末总股本',
  opprofit1 decimal(20,4) comment '营业利润(含价值变动损益)',
  operateincome decimal(20,4) comment '经营活动净收益',
  investincome decimal(20,4) comment '价值变动净收益',
  s_stm_is decimal(20,4) comment '折旧与摊销',
  ebit decimal(20,4) comment '息税前利润',
  ebitda decimal(20,4) comment '息税折旧摊销前利润',
  fcff decimal(20,4) comment '企业自由现金流量(FCFF)',
  fcfe decimal(20,4) comment '股权自由现金流量(FCFE)',
  exinterestdebt_current decimal(20,4) comment '无息流动负债',
  exinterestdebt_noncurrent decimal(20,4) comment '无息非流动负债',
  interestdebt decimal(20,4) comment '带息债务',
  netdebt decimal(20,4) comment '净债务',
  tangibleasset decimal(20,4) comment '有形资产',
  workingcapital decimal(20,4) comment '营运资金',
  networkingcapital decimal(20,4) comment '营运流动资本',
  investcapital decimal(20,4) comment '全部投入资本',
  retainedearnings decimal(20,4) comment '留存收益',
  eps_basic decimal(20,4) comment '基本每股收益',
  eps_diluted decimal(20,4) comment '稀释每股收益',
  eps_diluted2 decimal(20,4) comment '每股收益(期末摊薄)',
  eps_diluted3 decimal(20,4) comment '每股收益(扣除／期末股本摊薄)',
  bps decimal(20,4) comment '每股净资产',
  ocfps decimal(20,4) comment '每股经营活动产生的现金流量净额',
  grps decimal(20,4) comment '每股营业总收入',
  orps decimal(20,4) comment '每股营业收入',
  surpluscapitalps decimal(20,4) comment '每股资本公积',
  retainedps decimal(20,4) comment '每股留存收益',
  cfps decimal(20,4) comment '每股现金流量净额',
  ebitps decimal(20,4) comment '每股息税前利润',
  fcffps decimal(20,4) comment '每股企业自由现金流量',
  fcfeps decimal(20,4) comment '每股股东自由现金流量',
  netprofitmargin decimal(20,4) comment '销售净利率',
  grossprofitmargin decimal(20,4) comment '销售毛利率',
  cogstosales decimal(20,4) comment '销售成本率',
  profittogr decimal(20,4) comment '净利润／营业总收入',
  saleexpensetogr decimal(20,4) comment '销售费用／营业总收入',
  adminexpensetogr decimal(20,4) comment '行政(管理)费用／营业总收入',
  finaexpensetogr decimal(20,4) comment '财务费用／营业总收入',
  gctogr decimal(20,4) comment '营业总成本／营业总收入',
  optogr decimal(20,4) comment '营业利润(含价值变动损益)／营业总收入',
  ebittogr decimal(20,4) comment '息税前利润／营业总收入',
  roe decimal(20,4) comment '净资产收益率(平均)',
  roe_deducted decimal(20,4) comment '净资产收益率(扣除平均)',
  roa2 decimal(20,4) comment '总资产报酬率(平均)',
  roa decimal(20,4) comment '总资产净利润(平均)',
  roic decimal(20,4) comment '投入资本回报率(平均)',
  roe_yearly decimal(20,4) comment '年化净资产收益率',
  roa2_yearly decimal(20,4) comment '年化总资产报酬率',
  roa_yearly decimal(20,4) comment '年化总资产净利率',
  roic_yearly decimal(20,4) comment '年化投入资本回报率',
  operateincometoebt decimal(20,4) comment '经营活动净收益／除税前利润',
  investincometoebt decimal(20,4) comment '价值变动净收益／除税前利润',
  nonoperateprofittoebt decimal(20,4) comment '营业外收支净额／除税前利润',
  taxtoebt decimal(20,4) comment '所得税／利润总额',
  continued_net_profit decimal(20,4) comment '持续经营净利润／除税后利润',
  nonnetoptotaxprofit decimal(20,4) comment '非持续经营净利润/除税后利润',
  ocftoor decimal(20,4) comment '经营活动产生的现金流量净额／营业收入',
  ocftoor1 decimal(20,4) comment '经营活动产生的现金流量净额／经营活动净收益',
  capitalizedtoda decimal(20,4) comment '资本支出／折旧和摊销',
  debttoassets decimal(20,4) comment '资产负债率',
  assetstoequity decimal(20,4) comment '权益乘数',
  dupont_assetstoequity decimal(20,4) comment '权益乘数(用于杜邦分析)',
  catoassets decimal(20,4) comment '流动资产／总资产',
  ncatoassets decimal(20,4) comment '非流动资产／总资产',
  tangibleassetstoassets decimal(20,4) comment '有形资产／总资产',
  intdebttototalcap decimal(20,4) comment '带息债务／全部投入资本',
  equitytototalcapital decimal(20,4) comment '归属于母公司的股东权益／全部投入资本',
  currentdebttodebt decimal(20,4) comment '流动负债／负债合计',
  longdebtodebt decimal(20,4) comment '非流动负债／负债合计',
  current1 decimal(20,4) comment '流动比率',
  quick decimal(20,4) comment '速动比率',
  cashratio decimal(20,4) comment '保守速动比率',
  ocftoshortdebt decimal(20,4) comment '经营活动产生的现金流量净额／流动负债',
  debttoequity decimal(20,4) comment '产权比率',
  equitytodebt decimal(20,4) comment '归属于母公司的股东权益／负债合计',
  equitytointerestdebt decimal(20,4) comment '归属于母公司的股东权益／带息债务',
  tangibleassettodebt decimal(20,4) comment '有形资产／负债合计',
  tangassettointdebt decimal(20,4) comment '有形资产／带息债务',
  tangibleassettonetdebt1 decimal(20,4) comment '有形资产／净债务',
  ocftodebt decimal(20,4) comment '经营活动产生的现金流量净额／负债合计',
  ocftointerestdebt decimal(20,4) comment '经营活动产生的现金流量净额／带息债务',
  tangibleassettonetdebt2 decimal(20,4) comment '经营活动产生的现金流量净额／净债务',
  ebittointerest decimal(20,4) comment '已获利息倍数(EBIT／利息费用)',
  longdebttoworkingcapital decimal(20,4) comment '长期债务与营运资金比率',
  ebitdatodebt decimal(20,4) comment '息税折旧摊销前利润／负债合计',
  turndays decimal(20,4) comment '营业周期',
  invturndays decimal(20,4) comment '存货周转天数',
  arturndays decimal(20,4) comment '应收账款周转天数',
  invturn decimal(20,4) comment '存货周转率',
  arturn decimal(20,4) comment '应收账款周转率',
  caturn decimal(20,4) comment '流动资产周转率',
  faturn decimal(20,4) comment '固定资产周转率',
  assetsturn decimal(20,4) comment '总资产周转率',
  ocftoprofit decimal(20,4) comment '经营活动产生的现金流量净额／营业利润(含)',
  cashtoliqdebt decimal(20,4) comment '货币资金／流动负债',
  cashtoliqdebtwithinterest decimal(20,4) comment '货币资金／带息流动负债',
  optoliqdebt decimal(20,4) comment '营业利润／流动负债',
  optodebt decimal(20,4) comment '营业利润／负债合计',
  profittoop decimal(20,4) comment '利润总额／营业总收入',
  net_profit5 decimal(20,4) comment '归属母公司的净利润／净利润',
  net_total_profit decimal(20,4) comment '净利润／利润总额',
  total_profit_ebit decimal(20,4) comment '利润总额／EBIT',
  yoyeps_basic decimal(20,4) comment '基本每股收益同比增长率',
  yoyeps_diluted decimal(20,4) comment '稀释每股收益同比增长率',
  yoyocfps decimal(20,4) comment '每股经营活动产生的现金流量净额同比增长率',
  yoy_tr decimal(20,4) comment '营业总收入同比增长率',
  yoy_or decimal(20,4) comment '营业收入同比增长率',
  yoyop decimal(20,4) comment '营业利润同比增长率(含)',
  yoyebt decimal(20,4) comment '利润总额同比增长率',
  yoynetprofit decimal(20,4) comment '归属母公司股东的净利润同比增长率',
  yoynetprofit_deducted decimal(20,4) comment '归属母公司股东的净利润-扣除非经常损益同比增长率',
  yoyocf decimal(20,4) comment '经营活动产生的现金流量净额同比增长率',
  yoyroe decimal(20,4) comment '净资产收益率(平均) 同比增长率',
  yoybps decimal(20,4) comment '每股净资产同比增长率',
  yoyassets decimal(20,4) comment '资产总计同比增长率',
  yoyequity decimal(20,4) comment '归属母公司的股东权益同比增长率',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_hkshareholdersmeeting;
create table if not exists ty_ods.w_hkshareholdersmeeting
(
  object_id string comment '对象ID',
  s_info_compcode string comment '品种ID',
  ann_dt string comment '公告日期',
  meeting_dt string comment '会议日期',
  meeting_type string comment '会议类型',
  votingcode bigint comment '投票通道代码',
  smtgrecdate string comment 'A股股权登记日',
  spotmtgstartdate string comment '会议登记起始日',
  spotmtgenddate string comment '会议登记截止日',
  is_intnet bigint comment '是否可以网络投票',
  meetevent_id string comment '会议事件ID',
  is_new bigint comment '最新标志',
  meeting_name string comment '会议名称',
  voting_type string comment '投票类型',
  is_notarization bigint comment '是否经公证',
  start_date string comment '过户起始日',
  end_date string comment '过户截止日',
  hshare_recorddate string comment 'H股股权登记日',
  meeting_place string comment '会议召开地点',
  meeting_content string comment '会议内容',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_hkshareinternetvoting;
create table if not exists ty_ods.w_hkshareinternetvoting
(
  object_id string comment '对象ID',
  s_event_id string comment '会议事件ID',
  s_event_num string comment '议案序号',
  s_event_name string comment '议案名称',
  s_info_type string comment '表决方式类型',
  s_info_price decimal(20,4) comment '申报价格',
  s_info_compcode string comment '公司ID',
  ann_dt string comment '公告日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_hksharemanagementholdreward;
create table if not exists ty_ods.w_hksharemanagementholdreward
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_date string comment '公告日期',
  end_date string comment '截止日期',
  crny_code string comment '货币代码',
  s_info_manager_name string comment '姓名',
  s_info_manager_post string comment '职务',
  s_manager_return decimal(20,4) comment '报酬',
  s_manager_quantity decimal(20,4) comment '持股数量',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_hksharemanagement;
create table if not exists ty_ods.w_hksharemanagement
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  ann_date string comment '公告日期',
  s_info_manager_name string comment '姓名',
  s_info_manager_enname string comment '英文名',
  s_info_manager_gender string comment '性别',
  s_info_manager_nationality string comment '国籍',
  s_info_manager_birthyear string comment '出生年份',
  s_info_manager_typecode bigint comment '管理层类别代码',
  s_info_manager_post string comment '职务',
  s_info_manager_enpost string comment '职务(英文)',
  s_info_manager_startdate string comment '任职日期',
  s_info_manager_leavedate string comment '离职日期',
  s_info_manager_introduction string comment '个人简历',
  s_info_manager_enintroduction string comment '个人简历(英文)',
  manid string comment '人物ID',
  op_date string comment '操作日期',
  is_in_office bigint comment '是否在任',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_hkshareparvaluelotsize;
create table if not exists ty_ods.w_hkshareparvaluelotsize
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '变动日期',
  s_info_parvalue decimal(24,8) comment '面值',
  s_info_tradeunit decimal(20,4) comment '交易单位',
  crncy_code string comment '货币代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_hkshareprosecution;
create table if not exists ty_ods.w_hkshareprosecution
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  ann_dt string comment '公告日期',
  title string comment '案件名称',
  accuser string comment '原告方',
  defendant string comment '被告方',
  pro_type string comment '诉讼类型',
  amount decimal(20,4) comment '涉案金额',
  crncy_code string comment '货币代码',
  prosecute_dt string comment '起诉日期',
  court string comment '一审受理法院',
  judge_dt string comment '判决日期',
  result9 string comment '判决内容',
  is_appeal bigint comment '是否上诉',
  appellant string comment '二审上诉方(是否原告)',
  court2 string comment '二审受理法院',
  judge_dt2 string comment '二审判决日期',
  result2 string comment '二审判决内容',
  resultamount decimal(20,4) comment '判决金额',
  briefresult string comment '诉讼结果',
  execution string comment '执行情况',
  introduction string comment '案件描述',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_hkshareshortsellingturnover;
create table if not exists ty_ods.w_hkshareshortsellingturnover
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '交易日期',
  s_info_datatype bigint comment '数据类型',
  s_ss_volume decimal(20,4) comment '成交股数',
  s_ss_turnover decimal(20,4) comment '成交金额',
  crncy_code string comment '货币代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_hksharestaff;
create table if not exists ty_ods.w_hksharestaff
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  end_dt string comment '截止日期',
  ann_dt string comment '公告日期',
  s_info_totalemployees decimal(20,4) comment '员工人数(人)',
  s_info_totalemployees2 bigint comment '母公司员工人数(人)',
  memo string comment '特殊情况说明',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_hksharettmandmrq;
create table if not exists ty_ods.w_hksharettmandmrq
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  trade_dt string comment '截止日期',
  statement_type string comment '报表类型',
  crncy_code string comment '货币代码',
  s_fa_or_ttm decimal(20,4) comment '营业收入(TTM)',
  s_fa_grossmargin_ttm decimal(22,4) comment '毛利(TTM)',
  s_fa_prefinexpop_ttm decimal(22,4) comment '扣除融资费用前营业利润(TTM)',
  s_fa_nonopprofit_ttm decimal(22,4) comment '非营业利润(TTM)',
  s_fa_pctjvprofit_ttm decimal(22,4) comment '所占联营公司业绩(TTM)',
  s_fa_profit_bef_tax_ttm decimal(22,4) comment '除税前利润(TTM)',
  s_fa_profit_aft_tax_ttm decimal(22,4) comment '除税后利润(TTM)',
  minority_int_ttm decimal(22,4) comment '少数股东权益(TTM)',
  s_fa_pctjvcprofit_ttm decimal(22,4) comment '所占共同控制实体业绩(TTM)',
  s_fa_netprofit_ttm decimal(22,4) comment '归属母公司股东净利润(TTM)',
  s_fa_finaexpense_ttm decimal(22,4) comment '财务费用(TTM)',
  net_incr_cash_cash_equ_ttm decimal(22,4) comment '现金及现金等价物净增加额(TTM)',
  net_cash_flows_oper_act_ttm decimal(22,4) comment '经营活动产生的现金流量净额(TTM)',
  s_fa_investcashflow_ttm decimal(22,4) comment '投资活动产生的现金流量净额(TTM)',
  s_fa_financecashflow_ttm decimal(22,4) comment '筹资活动产生的现金流量净额(TTM)',
  s_fa_asset_mrq decimal(22,4) comment '资产总计(MRQ)',
  s_fa_debt_mrq decimal(22,4) comment '负债合计(MRQ)',
  s_stm_bsmrq decimal(22,4) comment '固定资产合计(MRQ)',
  s_fa_totalequity_mrq decimal(22,4) comment '股东权益(MRQ)',
  tot_shrhldr_eqy_incl_min_int decimal(22,4) comment '股东权益(含少数股东权益)(MRQ)',
  s_fa_investcapital_mrq decimal(22,4) comment '投入资本(MRQ)',
  s_fa_netprofitmargin_ttm decimal(22,4) comment '销售净利率(TTM)',
  s_fa_marginalprofitrate_ttm decimal(22,4) comment '边际利润率(TTM)',
  s_fa_grossprofitmargin_ttm decimal(22,4) comment '销售毛利率(TTM)',
  s_fa_opprofit_rate decimal(22,4) comment '经营利润率(TTM)',
  s_fa_optoor_ttm decimal(22,4) comment '营业利润/营业收入(TTM)',
  s_fa_profit_bef_tax_rate decimal(22,4) comment '税前利润率(TTM)',
  s_fa_roe_ttm decimal(22,4) comment '净资产收益率(ROE)(TTM)',
  s_fa_roa_ttm decimal(22,4) comment '总资产净利率(TTM)',
  roa_exclminintinc_ttm decimal(22,4) comment '总资产净利率-不含少数股东损益(TTM)',
  fa_roic_ttm decimal(22,4) comment '投入资本回报率ROIC(TTM)',
  s_fa_prefinexpoptoebt_ttm decimal(22,4) comment '扣除融资费用前营业利润/利润总额(TTM)',
  s_fa_noptoebt_ttm decimal(22,4) comment '非营业利润/利润总额(TTM)',
  s_fa_taxtoebt_ttm decimal(22,4) comment '税项/利润总额(TTM)',
  s_fa_ocftoor_ttm decimal(22,4) comment '经营活动产生的现金流量净额／营业收入(TTM)',
  s_fa_debttoassets_mrq decimal(22,4) comment '资产负债率(MRQ)',
  s_fa_ocftoop_ttm decimal(22,4) comment '经营活动产生的现金流量净额／营业利润(TTM)?(含)',
  continuous_net_op_ttm decimal(22,4) comment '持续经营净利润(TTM)',
  noncontinuous_net_op_ttm decimal(22,4) comment '非持续经营净利润(TTM)',
  s_fa_cost_ttm decimal(22,4) comment '营业成本(TTM)',
  s_fa_operateincome_ttm decimal(22,4) comment '经营活动净收益(TTM)',
  s_fa_investincome_ttm decimal(22,4) comment '价值变动净收益(TTM)',
  s_fa_op_ttm decimal(22,4) comment '营业利润(TTM)',
  s_fa_gr_ttm decimal(22,4) comment '营业总收入(TTM)',
  s_fa_gc_ttm decimal(22,4) comment '营业总成本(TTM)',
  s_fa_profittogr_ttm decimal(22,4) comment '净利润／营业总收入(TTM)',
  s_fa_gctogr_ttm decimal(22,4) comment '营业总成本／营业总收入(TTM)',
  s_fa_roa2_ttm decimal(22,4) comment '总资产报酬率(TTM)',
  s_fa_operateincometoebt_ttm decimal(22,4) comment '经营活动净收益／利润总额(TTM)',
  s_fa_investincometoebt_ttm decimal(22,4) comment '价值变动净收益／利润总额(TTM)',
  s_fa_ocftooperateincome_ttm decimal(22,4) comment '经营活动产生的现金流量净额／经营活动净收益(TTM)',
  s_fa_eps_ttm decimal(22,4) comment '每股收益(TTM)',
  s_fa_orps_ttm decimal(22,4) comment '每股营业收入(TTM)',
  s_fa_ocfps_ttm decimal(22,4) comment '每股经营活动产生的现金流量净额(TTM)',
  s_fa_cfps_ttm decimal(22,4) comment '每股现金流量净额(TTM)',
  s_fa_operateexpensetogr_ttm decimal(22,4) comment '销售费用／营业总收入(TTM)',
  s_fa_adminexpensetogr_ttm decimal(22,4) comment '管理费用／营业总收入(TTM)',
  s_fa_finaexpensetogr_ttm decimal(22,4) comment '财务费用／营业总收入(TTM)',
  s_fa_operateexpense_ttm decimal(22,4) comment '销售费用(TTM)',
  s_fa_adminexpense_ttm decimal(22,4) comment '管理费用(TTM)',
  s_fa_ebit_ttm decimal(22,4) comment '息税前利润(TTM)',
  s_fa_totinvestcapital_mrq decimal(22,4) comment '全部投入资本(MRQ)',
  s_fa_optoebt_ttm decimal(22,4) comment '营业利润(含)／利润总额(TTM)',
  s_fa_optogr_ttm decimal(22,4) comment '营业利润(含)／营业总收入(TTM)',
  s_fa_ebttogr_ttm decimal(22,4) comment '利润总额／营业总收入(TTM)',
  nonnetoptotaxprofit decimal(22,4) comment '非持续经营净利润／税后利润(TTM)',
  netoptotaxprofit decimal(22,4) comment '持续经营净利润／税后利润(TTM)',
  tot_shr_new decimal(22,4) comment '最新总股本',
  int_exp_ttm decimal(22,4) comment '利息支出(TTM)',
  inc_tax_ttm decimal(22,4) comment '所得税(TTM)',
  s_fa_grps_ttm decimal(22,4) comment '每股营业总收入(TTM)',
  s_fa_bps_mrq decimal(22,4) comment '每股净资产(MRQ)',
  s_fa_ebitda_ttm decimal(22,4) comment '息税折旧摊销前利润(TTM)',
  s_fa_ebit_ttm_inverse decimal(22,4) comment '息税前利润(TTM反推法)',
  s_fa_ebitda_ttm_inverse decimal(22,4) comment '息税折旧摊销前利润(TTM反推法)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_hksharettmhis;
create table if not exists ty_ods.w_hksharettmhis
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  trade_dt string comment '截止日期',
  ann_dt string comment '公告日期',
  statement_type string comment '报表类型',
  crncy_code string comment '货币代码',
  tot_oper_rev_ttm decimal(20,4) comment '营业总收入(TTM)',
  oper_rev_ttm decimal(20,4) comment '营业收入(TTM)',
  net_profit_ttm decimal(20,4) comment '净利润(TTM)',
  net_profit_parent_comp_ttm decimal(20,4) comment '归属母公司净利润(TTM)',
  net_cash_flows_oper_act_ttm decimal(20,4) comment '经营活动产生的现金流量净额(TTM)',
  net_incr_cash_cash_equ_ttm decimal(20,4) comment '现金及现金等价物净增加额(TTM)',
  s_fa_ebitda_ttm decimal(22,4) comment '息税折旧摊销前利润(TTM)',
  s_fa_ebit_ttm_inverse decimal(22,4) comment '息税前利润(TTM反推法)',
  s_fa_taxtoebt_ttm decimal(22,4) comment '税项/利润总额(TTM)',
  s_fa_netprofittoor_ttm decimal(22,4) comment '归属母公司股东的净利润/营业收入(TTM)',
  s_fa_finaexpense_ttm decimal(22,4) comment '财务费用(TTM)',
  s_fa_finaexpensetogr_ttm decimal(22,4) comment '财务费用／营业总收入(TTM)',
  continuous_net_op_ttm decimal(22,4) comment '持续经营净利润(TTM)',
  netoptotaxprofit decimal(22,4) comment '持续经营净利润／税后利润(TTM)',
  s_fa_financecashflow_ttm decimal(22,4) comment '筹资活动产生的现金流量净额(TTM)',
  s_fa_profit_aft_tax_ttm decimal(22,4) comment '除税后利润(TTM)',
  s_fa_profit_bef_tax_ttm decimal(22,4) comment '除税前利润(TTM)',
  noncontinuous_net_op_ttm decimal(22,4) comment '非持续经营净利润(TTM)',
  nonnetoptotaxprofit decimal(22,4) comment '非持续经营净利润／税后利润(TTM)',
  s_fa_nonopprofit_ttm decimal(22,4) comment '非营业利润(TTM)',
  s_fa_noptoebt_ttm decimal(22,4) comment '非营业利润/利润总额(TTM)',
  s_fa_adminexpense_ttm decimal(22,4) comment '管理费用(TTM)',
  s_fa_adminexpensetogr_ttm decimal(22,4) comment '管理费用／营业总收入(TTM)',
  s_fa_netprofit_ttm decimal(22,4) comment '归属母公司股东净利润(TTM)',
  s_fa_investincome_ttm decimal(22,4) comment '价值变动净收益(TTM)',
  s_fa_investincometoebt_ttm decimal(22,4) comment '价值变动净收益／利润总额(TTM)',
  s_fa_ocftooperateincome_ttm decimal(22,4) comment '经营活动产生的现金流量净额／经营活动净收益(TTM)',
  s_fa_ocftoop_ttm decimal(22,4) comment '经营活动产生的现金流量净额／营业利润(TTM)(含)',
  s_fa_ocftoor_ttm decimal(22,4) comment '经营活动产生的现金流量净额／营业收入(TTM)',
  s_fa_operateincome_ttm decimal(22,4) comment '经营活动净收益(TTM)',
  s_fa_operateincometoebt_ttm decimal(22,4) comment '经营活动净收益／利润总额(TTM)',
  s_fa_prefinexpoptoor_ttm decimal(22,4) comment '扣除融资费用前营业利润/营业收入(TTM)',
  s_fa_profittogr_ttm decimal(22,4) comment '净利润／营业总收入(TTM)',
  s_fa_roe_ttm decimal(22,4) comment '净资产收益率(ROE)(TTM)',
  s_fa_prefinexpoptoebt_ttm decimal(22,4) comment '扣除融资费用前营业利润/利润总额(TTM)',
  s_fa_ebttogr_ttm decimal(22,4) comment '利润总额／营业总收入(TTM)',
  int_exp_ttm decimal(22,4) comment '利息支出(TTM)',
  s_fa_grossmargin_ttm decimal(22,4) comment '毛利(TTM)',
  minority_int_ttm decimal(22,4) comment '少数股东权益(TTM)',
  inc_tax_ttm decimal(22,4) comment '所得税(TTM)',
  fa_roic_ttm decimal(22,4) comment '投入资本回报率ROIC(TTM)',
  s_fa_investcashflow_ttm decimal(22,4) comment '投资活动产生的现金流量净额(TTM)',
  s_fa_operateexpense_ttm decimal(22,4) comment '销售费用(TTM)',
  s_fa_operateexpensetogr_ttm decimal(22,4) comment '销售费用／营业总收入(TTM)',
  s_fa_netprofitmargin_ttm decimal(22,4) comment '销售净利率(TTM)',
  s_fa_grossprofitmargin_ttm decimal(22,4) comment '销售毛利率(TTM)',
  s_fa_cost_ttm decimal(22,4) comment '营业成本(TTM)',
  s_fa_op_ttm decimal(22,4) comment '营业利润(TTM)',
  s_fa_optoebt_ttm decimal(22,4) comment '营业利润(含)／利润总额(TTM)',
  s_fa_optogr_ttm decimal(22,4) comment '营业利润(含)／营业总收入(TTM)',
  s_fa_optoor_ttm decimal(22,4) comment '营业利润/营业收入(TTM)',
  s_fa_gc_ttm decimal(22,4) comment '营业总成本(TTM)',
  s_fa_gctogr_ttm decimal(22,4) comment '营业总成本／营业总收入(TTM)',
  s_fa_roa2_ttm decimal(22,4) comment '总资产报酬率(TTM)',
  s_fa_roa_ttm decimal(22,4) comment '总资产净利率(TTM)',
  roa_exclminintinc_ttm decimal(22,4) comment '总资产净利率-不含少数股东损益(TTM)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_hkshareunsoldshortsale;
create table if not exists ty_ods.w_hkshareunsoldshortsale
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'WIND代码1',
  trade_dt string comment '日期',
  unflat_short_interest decimal(20,4) comment '未平仓卖空股数',
  unflat_short_selling_amount decimal(20,4) comment '未平仓卖空金额',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_hkstockindexcode;
create table if not exists ty_ods.w_hkstockindexcode
(
  object_id string comment '对象ID',
  s_info_indexwindcode string,
  s_info_name string comment '指数简称',
  s_info_industrycode string comment '板块代码',
  s_info_industryname string comment '板块名称',
  mk string comment '交易所',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_hkstockshortsellinglist;
create table if not exists ty_ods.w_hkstockshortsellinglist
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  begindate string comment '起始日期',
  enddate string comment '终止日期',
  cur_sign string comment '最新标志',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_hsharesalessegment;
create table if not exists ty_ods.w_hsharesalessegment
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司id',
  ann_dt string comment '[内部]公告日期',
  begindate string comment '起始日期',
  enddate string comment '截止日期',
  statement_typecode bigint comment '报表类型代码',
  report_typecode bigint comment '报告类型代码',
  crncy_code string comment '货币代码',
  segment_itemcode bigint comment '项目类别代码',
  resourcecode bigint comment '[内部]文件类型代码',
  segment_item string comment '主营业务项目',
  segment_sales decimal(20,4) comment '主营业务收入',
  segment_cost decimal(20,4) comment '主营业务成本',
  grossprofit decimal(20,4) comment '毛利',
  segment_sales_ratio decimal(20,4) comment '主营业务收入比例',
  segment_cost_ratio decimal(20,4) comment '主营业务成本比例',
  grossprofitmargin decimal(20,4) comment '毛利率',
  prime_oper_rev_yoy decimal(20,4) comment '主营业务收入同比增长率',
  prime_oper_cost_yoy decimal(20,4) comment '主营业务成本同比增长率',
  gross_profit_margin_yoy decimal(20,4) comment '毛利率同比增长率',
  gross_profit_yoy decimal(20,4) comment '毛利同比增长率',
  prime_oper_profit_ratio decimal(20,4) comment '主营业务利润比例',
  accounts_id string comment '科目ID',
  ispublishvalue bigint comment '[内部]是否公布值',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_iecmemberlist;
create table if not exists ty_ods.w_iecmemberlist
(
  object_id string comment '对象ID',
  term string comment '发审委届次',
  ann_dt string comment '公告日期',
  status string comment '专职/兼职',
  name string comment '姓名',
  age bigint comment '年龄',
  gender string comment '性别',
  professional string comment '专业',
  degree string comment '学历/学位',
  unit string comment '工作单位',
  post string comment '职务',
  title string comment '职称',
  typecode bigint comment '委员会类型代码',
  valid_dt string comment '有效截止日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_indexmobilitybackright;
create table if not exists ty_ods.w_indexmobilitybackright
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '日期',
  ema_5d decimal(20,8) comment '5日收盘价EMA',
  ema2_5d decimal(20,8) comment '5日收盘价二重EMA',
  ema3_5d decimal(20,8) comment '5日收盘价三重EMA',
  ema_10d decimal(20,8) comment '10日收盘价EMA',
  ema2_10d decimal(20,8) comment '10日收盘价二重EMA',
  ema3_10d decimal(20,8) comment '10日收盘价三重EMA',
  ema_20d decimal(20,8) comment '20日收盘价EMA',
  ema_60d decimal(20,8) comment '60日收盘价EMA',
  ema_120d decimal(20,8) comment '120日收盘价EMA',
  ema_12d decimal(20,8) comment '12日收盘价EMA',
  ema_26d decimal(20,8) comment '26日收盘价EMA',
  ema_13d decimal(20,8) comment '13日收盘价EMA',
  s_pvi decimal(20,8) comment '正成交量指标PVI',
  s_nvi decimal(20,8) comment '负成交量指标NVI',
  s_tr decimal(20,8) comment '均幅指标中间量TR(元)',
  s_atr6 decimal(20,8) comment '6日均幅指标ATR6',
  s_atr14 decimal(20,8) comment '14日均幅指标ATR14',
  s_dbcd decimal(20,8) comment '异同离差乖离率DBCD',
  s_ema3d decimal(20,8) comment '3日收集派发EMA',
  s_ema10d decimal(20,8) comment '10日收集派发EMA',
  s_ahl decimal(20,8) comment '梅斯线中间量AHL',
  s_bhl decimal(20,8) comment '梅斯线中间量BHL',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
 COMMENT '指数移动平均型指标(后复权)'
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_indexvaluationfactor;
create table if not exists ty_ods.w_indexvaluationfactor
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '交易日期',
  index_number decimal(20,4) comment '成份股个数',
  i_tech_uppct decimal(20,4) comment '上涨的股票占指数成份股的比例',
  i_tech_downpct decimal(20,4) comment '下跌的股票占指数成份股的比例',
  i_tech_limituppct decimal(20,4) comment '涨停的股票占指数成份股的比例',
  i_tech_limitdownpct decimal(20,4) comment '跌停的股票占指数成份股的比例',
  i_val_pe2 decimal(20,4) comment '算术平均滚动市盈率',
  i_val_pb2 decimal(20,4) comment '算术平均滚动市净率',
  i_val_pe1 decimal(20,4) comment '加权市盈率',
  i_val_pb1 decimal(20,4) comment '加权市净率',
  i_val_pe3 decimal(20,4) comment 'PE(中位数)',
  i_val_pb3 decimal(20,4) comment 'PB(中位数)',
  i_val_pe_ttm_ex_nv decimal(20,4) comment 'PE(TTM,剔除负值整体法)',
  i_div_effect decimal(20,4) comment '分红影响',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
 COMMENT '指数估值因子'
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_industryderivativefactor;
create table if not exists ty_ods.w_industryderivativefactor
(
  object_id string comment '对象ID',
  sw_industry_code string comment '申万一级行业编号',
  trade_dt string comment '日期',
  sw_industry_number bigint comment '行业成份数量',
  s_val_avgpe_sw decimal(20,4) comment '行业PE均值',
  s_val_avgpb_sw decimal(20,4) comment '行业PB均值',
  s_val_avgps_sw decimal(20,4) comment '行业PS均值',
  s_val_avgpcf_sw decimal(20,4) comment '行业PCF均值',
  s_val_avgroe_sw decimal(20,4) comment '行业ROE均值（%）',
  s_val_avgroa_sw decimal(20,4) comment '行业ROA均值（%）',
  s_val_avggp_sw decimal(20,4) comment '行业GP均值（%）',
  s_val_avgbtomv_sw decimal(20,4) comment '行业账面市值比均值',
  s_val_avgpebitda_sw decimal(20,4) comment '行业(股价/息税折旧及摊销前利润)均值',
  s_val_avgpb_mrq_sw decimal(20,4) comment '行业PB(MRQ)均值',
  s_val_avgpbusinc_sw decimal(20,4) comment '行业总市值/营业收入ttm均值',
  s_val_stdpe_sw decimal(20,4) comment '行业PE标准差',
  s_val_stdpb_sw decimal(20,4) comment '行业PB标准差',
  s_val_stdps_sw decimal(20,4) comment '行业PS标准差',
  s_val_stdpcf_sw decimal(20,4) comment '行业PCF标准差',
  s_val_stdroe_sw decimal(20,4) comment '行业ROE标准差',
  s_val_stdroa_sw decimal(20,4) comment '行业ROA标准差',
  s_val_stdgp_sw decimal(20,4) comment '行业GP标准差',
  s_val_stdbtomv_sw decimal(20,4) comment '行业账面市值比标准差',
  s_val_stdpebitda_sw decimal(20,4) comment '行业(股价/息税折旧及摊销前利润)标准差',
  s_val_stdpb_mrq_sw decimal(20,4) comment '行业PB(MRQ)标准差',
  s_val_stdpbusinc_sw decimal(20,4) comment '行业总市值/营业收入ttm标准差',
  s_val_avgrevenue5_sw decimal(20,4) comment '行业收益均值(5日)（%）',
  s_val_avgrevenue20_sw decimal(20,4) comment '行业收益均值(1月)（%）',
  sw_industries_name string comment '行业中文名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
 COMMENT '行业日衍生因子'
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ipocomprfa;
create table if not exists ty_ods.w_ipocomprfa
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_info_companyname string comment '公司名称',
  s_info_companyid string comment '公司ID',
  regaddr string comment '注册地',
  sectors string comment '所属行业',
  sponsor string comment '保荐机构',
  spon_rep string comment '保荐代表人',
  acc_firm string comment '会计师事务所',
  cpa string comment '签字会计师',
  law_firm string comment '律师事务所',
  sol_sig string comment '签字律师',
  app_code bigint comment '申请事项代码',
  sch_code bigint comment '进度类型代码',
  tblisted bigint comment '拟上市板块代码',
  st_date string comment '状态起始日期',
  end_date string comment '状态终止日期',
  est_issueno decimal(20,4) comment '预计发行股数（万股）',
  est_issueshares decimal(20,4) comment '预计发行后总股本（万股）',
  pro_tolalinv decimal(20,4) comment '募投项目投资总额',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ipodeclaredisclosuredate;
create table if not exists ty_ods.w_ipodeclaredisclosuredate
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  per_disclosuredate string comment '纳入日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ipoinquirydetails;
create table if not exists ty_ods.w_ipoinquirydetails
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_dt string comment '公告日期',
  inquirer string comment '询价对象名称',
  inquirerid string comment '询价对象名称ID',
  inquirer_typecode bigint comment '投资者类别代码',
  issuetarget string comment '配售对象名称',
  dedaredprice decimal(20,4) comment '申报价格(元/股)',
  dedaredshares decimal(20,4) comment '申购数量(万股)',
  is_valid bigint comment '是否有效报价投资者',
  issuetarget1 string comment '公布配售对象名称',
  pct_change_1m decimal(20,4) comment '配售数量',
  issuetargetid string comment '配售对象名称ID',
  reject_dedaredshares decimal(20,4) comment '被剔除申购股数(万股)',
  act_dedaredshares decimal(20,4) comment '实际申购数量(万股)',
  security_account string comment '证券账户',
  quote_type_code bigint comment '报价结果类型代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
 COMMENT 'IPO初步询价明细'
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_marketderivativefactor;
create table if not exists ty_ods.w_marketderivativefactor
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '交易日期',
  s_tech_price1m decimal(20,8) comment '当前股价除以过去1个月股价均值再减1',
  s_tech_price3m decimal(20,8) comment '当前股价除以过去3个月股价均值再减1',
  s_tech_price1y decimal(20,8) comment '当前股价除以过去1年的股价均值再减1',
  s_tech_rvi decimal(20,8) comment '相对离散指数',
  s_tech_moneyflow20 decimal(20,8) comment '20日资金流量',
  s_tech_emv14 decimal(20,8) comment '14日简易波动指标',
  s_tech_emv6 decimal(20,8) comment '6日简易波动指标',
  s_tech_aroon decimal(20,8) comment '阿隆指标',
  s_tech_aroondown decimal(20,8) comment '阿隆向下指标',
  s_tech_aroonup decimal(20,8) comment '阿隆向上指标',
  s_tech_ad6 decimal(20,8) comment '6日收集派发指标',
  s_tech_ad20 decimal(20,8) comment '20日收集派发指标',
  s_tech_ar decimal(20,8) comment 'AR人气指标',
  s_tech_br decimal(20,8) comment 'BR意愿指标',
  s_tech_arbr decimal(20,8) comment 'ARBR人气意愿指标',
  s_tech_cr20 decimal(20,8) comment 'CR能量指标',
  s_tech_bearpower decimal(20,8) comment '空头力道',
  s_tech_bullpower decimal(20,8) comment '多头力道',
  s_tech_dhilo decimal(20,8) comment '波幅中位数',
  s_tech_skewness decimal(20,8) comment '股价偏度',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
 COMMENT '行情衍生因子'
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_mergeragency;
create table if not exists ty_ods.w_mergeragency
(
  object_id string comment '对象ID',
  event_id string comment '并购事件ID',
  agency_name string comment '中介机构公司名称',
  s_info_compcode string comment '中介机构公司ID',
  agency_typcode bigint comment '中介机构类型代码',
  object_typcode bigint comment '中介机构服务对象类型代码',
  object_compname string comment '中介机构服务对象（公司）名称',
  s_info_compcode2 string comment '中介机构服务对象（公司）ID',
  start_dt string comment '起始日期',
  end_dt string comment '终止日期',
  cur_sign bigint comment '最新标志',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_mergerevent;
create table if not exists ty_ods.w_mergerevent
(
  object_id string comment '对象ID',
  event_id string comment '并购事件ID',
  ann_date string comment '首次披露日期',
  update_date string comment '最新披露日期',
  event_title string comment '并购事件标题',
  underlying string comment '交易标的',
  underlying_type_code bigint comment '标的类型代码',
  is_related_party_transac bigint comment '是否为关联交易',
  is_majorassetrestructure bigint comment '是否重大资产重组',
  is_control_change bigint comment '控制权是否变更',
  restructure_way_code bigint comment '重组形式代码',
  restructure_type_code bigint comment '重组类型代码',
  merger_type_code bigint comment '并购类型代码',
  merger_way_code bigint comment '并购方式代码',
  is_be_approval bigint comment '是否已完成审批',
  progress_code bigint comment '交易方案进度代码',
  trade_value decimal(20,4) comment '交易总价值(万元)',
  crncy_code string comment '货币代码',
  pricing_basis_code bigint comment '定价依据代码',
  evalue_method_code bigint comment '评估方法代码',
  evalue_way_code bigint comment '选用评估方法代码',
  payment_way_code bigint comment '支付方式代码',
  cash_payment decimal(20,4) comment '买方支付现金(万元)',
  evalue_value decimal(20,4) comment '评估价值',
  evalue_basis_date_ string comment '资产评估基准日',
  transfer_numbers decimal(20,4) comment '转让股数(万股)',
  transfer_price decimal(20,4) comment '转让单价',
  stockright_proportion decimal(20,4) comment '交易股权占比(%)',
  appreciation_rate decimal(20,4) comment '增值率',
  merger_aim_code bigint comment '并购目的类型代码',
  location_type_code bigint comment '并购地区类型代码',
  ecd string comment '交易预计完成日期',
  completion_date string comment '交易完成日期',
  chronicle string comment '并购大事记',
  relevantintelligence_id string comment '关联情报ID',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_mergerintelligence;
create table if not exists ty_ods.w_mergerintelligence
(
  object_id string comment '对象ID',
  intelligence_id string comment '情报ID',
  title string comment '标题',
  ann_date string comment '发布日期',
  involved_amount string comment '涉及金额',
  subject_typecode bigint comment '主题分类代码',
  wind_ind_code string comment '所属Wind行业代码',
  level_code bigint comment '情报等级代码',
  key_words string comment '情报关键字',
  data_source string comment '来源名称',
  involved_equity string comment '涉及股权',
  content string comment '正文内容',
  event_id string comment '交易事件ID',
  progress_code bigint comment '事件进度代码',
  receipt_date timestamp comment '收录时间',
  is_important bigint comment '是否重要',
  effective_date string comment '生效日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_mergerparticipant;
create table if not exists ty_ods.w_mergerparticipant
(
  object_id string comment '对象ID',
  event_id string comment '情报ID(或事件ID)',
  party_name string comment '参与方名称',
  country_code string comment '所属国家或地区代码',
  party_id string comment '参与方ID',
  s_info_windcode string comment '参与方关联证券Wind代码',
  party_type_code bigint comment '参与方类型代码',
  relationship bigint comment '参与方与关联证券代码关系',
  party_role_code bigint comment '参与方角色代码',
  pre_proportion decimal(20,4) comment '转让前持股比例',
  after_proportion decimal(20,4) comment '转让后持股比例',
  stockright_proportion decimal(20,4) comment '标的方交易股权占比',
  evalue_value decimal(20,4) comment '标的方评估价值',
  appreciation_rate decimal(20,4) comment '标的方增值率',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_neeqreginv;
create table if not exists ty_ods.w_neeqreginv
(
  object_id string comment '对象ID',
  comp_id string comment '公司ID',
  s_info_windcode string comment 'Wind代码',
  sur_institute string comment '调查机构',
  sur_reasons string comment '调查原因',
  str_anndate string comment '开始公告日期',
  end_anndate string comment '结束公告日期',
  str_date string comment '开始日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_neeqweekreportsofbrokers;
create table if not exists ty_ods.w_neeqweekreportsofbrokers
(
  object_id string comment '对象ID',
  broker_id string comment '券商ID',
  typecode bigint comment '周报类型',
  start_date string comment '起始日期',
  closing_date string comment '截止日期',
  make_market_num decimal(20,4) comment '做市企业数量',
  listed_companies_num decimal(20,4) comment '累计推荐挂牌企业数量',
  market_making_enterprise_ratio decimal(20,4) comment '当周做市企业数量占比',
  trading_volume decimal(20,4) comment '当周做市成交量',
  trading_volume_ratio decimal(20,4) comment '当周做市成交量市场占比',
  market_turnover decimal(20,4) comment '当周做市成交额',
  market_turnover_ratio decimal(20,4) comment '当周做市成交额市场占比',
  report_period string comment '披露定期报告报告期',
  supervision_company_num bigint comment '持续督导公司家数',
  this_period_disclosure_num bigint comment '本期披露定期报告的公司家数',
  accumulative_disclosure_num bigint comment '累计披露定期报告的公司家数',
  not_yet_disclosure_num bigint comment '尚未披露定期报告的公司家数',
  corrections_num bigint comment '定期报告披露后进行更正的公司家数',
  delayed_disclosure_num bigint comment '延迟披露定期报告的公司家数',
  existing_problems_num bigint comment '定期报告披露督导中存在其他问题的公司家数',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_pitfinancialfactor;
create table if not exists ty_ods.w_pitfinancialfactor
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_info_compcode string comment '公司ID',
  trade_dt string comment '交易日期',
  currency_code string comment '货币代码',
  s_dfa_or_ttm decimal(20,4) comment '营业收入(TTM)',
  s_dfa_cost_ttm decimal(20,4) comment '营业成本-非金融类(TTM)',
  s_dfa_expense_ttm decimal(20,4) comment '营业支出-金融类(TTM)',
  s_dfa_grossmargin_ttm decimal(20,4) comment '毛利(TTM)',
  s_dfa_operateincome_ttm decimal(20,4) comment '经营活动净收益(TTM)',
  s_dfa_investincome_ttm decimal(20,4) comment '价值变动净收益(TTM)',
  s_dfa_op_ttm decimal(20,4) comment '营业利润(TTM)',
  s_dfa_ebt_ttm decimal(20,4) comment '利润总额(TTM)',
  s_dfa_profit_ttm decimal(20,4) comment '净利润(TTM)',
  s_dfa_netprofit_ttm decimal(20,4) comment '归属母公司股东的净利润(TTM)',
  s_dfa_gr_ttm decimal(20,4) comment '营业总收入(TTM)',
  s_dfa_gc_ttm decimal(20,4) comment '营业总成本(TTM)',
  s_dfa_cashflow_ttm decimal(20,4) comment '现金净流量(TTM)',
  s_dfa_operatecashflow_ttm decimal(20,4) comment '经营活动现金净流量(TTM)',
  s_dfa_investcashflow_ttm decimal(20,4) comment '投资活动现金净流量(TTM)',
  s_dfa_financecashflow_ttm decimal(20,4) comment '筹资活动现金净流量(TTM)',
  s_dfa_totassets decimal(20,4) comment '资产总计(MRQ)',
  s_dfa_totliab decimal(20,4) comment '负债合计(MRQ)',
  s_dfa_totequity decimal(20,4) comment '股东权益(MRQ)',
  s_dfa_equity decimal(20,4) comment '归属于母公司的股东权益(MRQ)',
  s_dfa_netprofitmargin_ttm decimal(20,4) comment '销售净利率(TTM)',
  s_dfa_grossprofitmargin_ttm decimal(20,4) comment '销售毛利率(TTM)',
  s_dfa_expensetosales_ttm decimal(20,4) comment '销售期间费用率(TTM)',
  s_dfa_profittogr_ttm decimal(20,4) comment '净利润/营业总收入(TTM)',
  s_dfa_operateexpensetogr_ttm decimal(20,4) comment '销售费用/营业总收入(TTM)',
  s_dfa_adminexpensetogr_ttm decimal(20,4) comment '管理费用/营业总收入(TTM)',
  s_dfa_finaexpensetogr_ttm decimal(20,4) comment '财务费用/营业总收入(TTM)',
  s_dfa_impairtogr_ttm decimal(20,4) comment '资产减值损失/营业总收入(TTM)',
  s_dfa_gctogr_ttm decimal(20,4) comment '营业总成本/营业总收入(TTM)',
  s_dfa_optogr_ttm decimal(20,4) comment '营业利润/营业总收入(TTM)',
  s_dfa_roa1_ttm decimal(20,4) comment '总资产净利率(TTM)',
  s_dfa_roa2_ttm decimal(20,4) comment '总资产报酬率(TTM)',
  s_dfa_roe_ttm decimal(20,4) comment '净资产收益率(TTM)',
  s_dfa_operateincometoebt_ttm decimal(20,4) comment '经营活动净收益/利润总额(TTM)',
  s_dfa_investincometoebt_ttm decimal(20,4) comment '价值变动净收益/利润总额(TTM)',
  s_dfa_nonoperproftoebt_ttm decimal(20,4) comment '营业外收支净额/利润总额(TTM)',
  s_dfa_salescashintoor_ttm decimal(20,4) comment '销售商品提供劳务收到的现金/营业收入(TTM)',
  s_dfa_ocftoor_ttm decimal(20,4) comment '经营活动产生的现金流量净额/营业收入(TTM)',
  s_dfa_ocftooperateincome_ttm decimal(20,4) comment '经营活动产生的现金流量净额/经营活动净收益(TTM)',
  s_dfa_deductedprofit_ttm decimal(20,4) comment '扣除非经常性损益后的净利润(TTM)',
  s_dfa_ebitda_ttm decimal(20,4) comment 'EBITDA(TTM反推法)',
  s_dfa_ebitda2_ttm decimal(20,4) comment 'EBITDA(TTM)',
  s_dfa_ebit2_ttm decimal(20,4) comment 'EBIT(TTM)',
  s_dfa_roic2_ttm decimal(20,4) comment '投入资本回报率ROIC(TTM)',
  s_dfa_salescashin_ttm decimal(20,4) comment '销售商品提供劳务收到的现金(TTM)',
  s_dfa_operateexpense_ttm decimal(20,4) comment '销售费用(TTM)',
  s_dfa_adminexpense_ttm decimal(20,4) comment '管理费用(TTM)',
  s_dfa_finaexpense_ttm decimal(20,4) comment '财务费用(TTM)',
  s_dfa_periodexpense_t_ttm decimal(20,4) comment '期间费用(TTM)',
  s_dfa_nonoperateprofit_ttm decimal(20,4) comment '营业外收支净额(TTM)',
  s_dfa_impairment_ttm decimal(20,4) comment '资产减值损失(TTM)',
  s_dfa_ebit_ttm decimal(20,4) comment '息税前利润(TTM反推法)',
  s_dfa_investcapital decimal(20,4) comment '全部投入资本(MRQ)',
  s_dfa_roic_ttm decimal(20,4) comment '投入资本回报率ROIC(TTM)',
  s_dfa_fixassets decimal(20,4) comment '固定资产合计(MRQ)',
  s_dfa_nonopprofit_ttm decimal(20,4) comment '非营业利润(TTM)',
  s_dfa_prefinexp_op_ttm decimal(20,4) comment '扣除财务费用前营业利润(TTM)',
  s_dfa_taxtoor_ttm decimal(20,4) comment '营业利润/利润总额(TTM)',
  s_dfa_noptoebt_ttm decimal(20,4) comment '非营业利润/利润总额(TTM)',
  s_dfa_taxtoebt_ttm decimal(20,4) comment '税项/利润总额(TTM)',
  s_dfa_optoor_ttm decimal(20,4) comment '营业利润/营业收入(TTM)',
  s_dfa_ebttoor_ttm decimal(20,4) comment '利润总额/营业收入(TTM)',
  s_prefinexpoptoebt decimal(20,4) comment '扣除融资费用前营业利润/营业收入(TTM)',
  s_dfa_netprofittoor_ttm decimal(20,4) comment '归属母公司股东的净利润/营业收入(TTM)',
  s_operatecashflowtoop_ttm decimal(20,4) comment '扣除融资费用前营业利润/利润总额(TTM)',
  s_netprofittoassets decimal(20,4) comment '经营活动产生的现金流量净额/营业利润(TTM)',
  s_roa_exclminintinc_ttm decimal(20,4) comment '总资产净利率-不含少数股东损益(TTM)',
  s_dfa_debttoasset decimal(20,4) comment '资产负债率(MRQ)',
  s_dfa_interestexpense_ttm decimal(20,4) comment '利息支出(TTM)',
  s_dfa_tax_ttm decimal(20,4) comment '所得税(TTM)',
  s_dfa_minorityinterest_ttm decimal(20,4) comment '少数股东损益(TTM)',
  s_dfa_continue_net_op_ttm decimal(20,4) comment '持续经营净利润(TTM)',
  s_dfa_noncontinue_net_op_ttm decimal(20,4) comment '非持续经营净利润(TTM)',
  s_dfa_netoptotaxprofit decimal(20,4) comment '持续经营净利润/税后利润(TTM)',
  s_dfa_nonnetoptotaxprofit decimal(20,4) comment '非持续经营净利润/税后利润(TTM)',
  s_dfa_cce_ttm decimal(20,4) comment '期末现金及现金等价物(TTM)',
  s_dfa_opertax_ttm decimal(20,4) comment '营业税金及附加(TTM)',
  s_dfa_ttmgrowrate_cff decimal(20,4) comment '增长率-筹资活动产生的现金流量净额(TTM)',
  s_dfa_ttmgrowrate_cfo decimal(20,4) comment '增长率-投资活动产生的现金流量净额(TTM)',
  s_dfa_ttmgrowrate_cfott decimal(20,4) comment '增长率-经营活动产生的现金流量净额（TTM)',
  s_dfa_ttmgrowrate_profit decimal(20,4) comment '增长率-净利润(TTM)',
  s_dfa_ttmgrowrate_netprofit decimal(20,4) comment '同比增长率-归属母公司股东的净利润(TTM)',
  s_dfa_ttmgrowrate_op decimal(20,4) comment '增长率-营业利润(TTM)',
  s_dfa_ttmgrowrate_gm decimal(20,4) comment '同比增长率-毛利率(TTM)',
  s_dfa_cashtocurliabs decimal(20,4) comment '现金流动负债比率(TTM)',
  s_dfa_cfotocurliabs decimal(20,4) comment '现金流动负债比(TTM)',
  s_dfa_acca decimal(20,4) comment '现金流资产比-资产回报率(TTM)',
  s_dfa_currtassetstrate decimal(20,4) comment '流动资产周转率(TTM)',
  s_dfa_nat_ttm decimal(20,4) comment '净资产周转率(TTM)',
  s_dfa_roa_ttm decimal(20,4) comment '资产回报率(TTM)',
  s_dfa_roe2_ttm decimal(20,4) comment '权益回报率(TTM)',
  s_dfa_roc_ttm decimal(20,4) comment '资本报酬率(TTM)',
  s_dfa_salescostratio_ttm decimal(20,4) comment '销售成本率(TTM)',
  s_dfa_taxratio_ttm decimal(20,4) comment '销售税金率(TTM)',
  s_dfa_ebittogr decimal(20,4) comment '息税前利润/营业总收入(TTM)',
  s_dfa_earnmom decimal(20,4) comment '变化趋势-八季度净利润',
  s_dfa_profittomv_avg5y decimal(20,4) comment '5年平均收益市值比',
  s_dfa_roa_ttm_avg5y decimal(20,4) comment '5年平均资产回报率',
  s_dfa_roe_ttm_avg5y decimal(20,4) comment '5年平均权益回报率',
  s_dfa_berryratio_ttm decimal(20,4) comment '贝里比率',
  s_dfa_cashrecoveryratio decimal(20,4) comment '资金现金回收率',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
 COMMENT 'PIT财务因子(中国准则)'
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_pitindexchange;
create table if not exists ty_ods.w_pitindexchange
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  trade_dt string comment '日期',
  s_dfa_or_ttm decimal(20,4) comment '营业收入(TTM)',
  s_dfa_cost_ttm decimal(20,4) comment '营业成本-非金融类(TTM)',
  s_dfa_expense_ttm decimal(20,4) comment '营业支出-金融类(TTM)',
  s_dfa_grossmargin_ttm decimal(20,4) comment '毛利(TTM)',
  s_dfa_operateincome_ttm decimal(20,4) comment '经营活动净收益(TTM)',
  s_dfa_investincome_ttm decimal(20,4) comment '价值变动净收益(TTM)',
  s_dfa_op_ttm decimal(20,4) comment '营业利润(TTM)',
  s_dfa_ebt_ttm decimal(20,4) comment '利润总额(TTM)',
  s_dfa_profit_ttm decimal(20,4) comment '净利润(TTM)',
  s_dfa_netprofit_ttm decimal(20,4) comment '归属于母公司的净利润(TTM)',
  s_dfa_gr_ttm decimal(20,4) comment '营业总收入(TTM)',
  s_dfa_gc_ttm decimal(20,4) comment '营业总成本(TTM)',
  s_dfa_cashflow_ttm decimal(20,4) comment '现金净流量(TTM)',
  s_dfa_operatecashflow_ttm decimal(20,4) comment '经营活动现金净流量(TTM)',
  s_dfa_investcashflow_ttm decimal(20,4) comment '投资活动现金净流量(TTM)',
  s_dfa_financecashflow_ttm decimal(20,4) comment '筹资活动现金净流量(TTM)',
  s_dfa_totassets decimal(20,4) comment '资产总计(MRQ)',
  s_dfa_totliab decimal(20,4) comment '负债合计(MRQ)',
  s_dfa_totequity decimal(20,4) comment '股东权益(MRQ)',
  s_dfa_equity decimal(20,4) comment '归属于母公司的股东权益(MRQ)',
  currency_code string comment '货币代码',
  s_dfa_netprofitmargin_ttm decimal(20,4) comment '销售净利率(TTM)',
  s_dfa_grossprofitmargin_ttm decimal(20,4) comment '销售毛利率(TTM)',
  s_dfa_expensetosales_ttm decimal(20,4) comment '销售期间费用率(TTM)',
  s_dfa_profittogr_ttm decimal(20,4) comment '净利润/营业总收入(TTM)',
  s_dfa_operateexpensetogr_ttm decimal(20,4) comment '销售费用/营业总收入(TTM)',
  s_dfa_adminexpensetogr_ttm decimal(20,4) comment '管理费用/营业总收入(TTM)',
  s_dfa_finaexpensetogr_ttm decimal(20,4) comment '财务费用/营业总收入(TTM)',
  s_dfa_impairtogr_ttm decimal(20,4) comment '资产减值损失/营业总收入(TTM)',
  s_dfa_gctogr_ttm decimal(20,4) comment '营业总成本/营业总收入(TTM)',
  s_dfa_optogr_ttm decimal(20,4) comment '营业利润/营业总收入(TTM)',
  s_dfa_roa1_ttm decimal(20,4) comment '总资产净利率(TTM)',
  s_dfa_roa2_ttm decimal(20,4) comment '总资产报酬率(TTM)',
  s_dfa_net_roa_ttm decimal(20,4) comment '净资产收益率(TTM)',
  s_dfa_operateincometoebt_ttm decimal(20,4) comment '经营活动净收益/利润总额(TTM)',
  s_dfa_investincometoebt_ttm decimal(20,4) comment '价值变动净收益/利润总额(TTM)',
  s_dfa_nonoperproftoebt_ttm decimal(20,4) comment '营业外收支净额/利润总额(TTM)',
  s_dfa_salescashintoor_ttm decimal(20,4) comment '销售商品提供劳务收到的现金/营业收入(TTM)',
  s_dfa_ocftoor_ttm decimal(20,4) comment '经营活动产生的现金流量净额/营业收入(TTM)',
  s_dfa_ocftooperateincome_ttm decimal(20,4) comment '经营活动产生的现金流量净额/经营活动净收益(TTM)',
  s_dfa_deductedprofit_ttm decimal(20,4) comment '扣除非经常性损益后的净利润(TTM)',
  s_dfa_ebitda_ttm decimal(20,4) comment 'EBITDA(TTM反推法)',
  s_dfa_ebitda2_ttm decimal(20,4) comment 'EBITDA(TTM)',
  s_dfa_ebit2_ttm decimal(20,4) comment 'EBIT(TTM)',
  s_dfa_roic2_ttm decimal(20,4) comment '投入资本回报率(TTM)',
  s_dfa_salescashin_ttm decimal(20,4) comment '销售商品提供劳务收到的现金(TTM)',
  s_dfa_operateexpense_ttm decimal(20,4) comment '销售费用(TTM)',
  s_dfa_adminexpense_ttm decimal(20,4) comment '管理费用(TTM)',
  s_dfa_finaexpense_ttm decimal(20,4) comment '财务费用(TTM)',
  s_dfa_periodexpense_t_ttm decimal(20,4) comment '期间费用(TTM)',
  s_dfa_nonoperateprofit_ttm decimal(20,4) comment '营业外收支净额(TTM)',
  s_dfa_impairment_ttm decimal(20,4) comment '资产减值损失(TTM)',
  s_dfa_ebit_ttm decimal(20,4) comment 'EBIT(TTM反推法)',
  s_dfa_investcapital decimal(20,4) comment '全部投入资本(MRQ)',
  s_dfa_roic_ttm decimal(20,4) comment '投入资本回报率ROIC(TTM)',
  s_dfa_fixassets decimal(20,4) comment '固定资产合计(MRQ)',
  s_dfa_nonopprofit_ttm decimal(20,4) comment '非营业利润(TTM)',
  s_dfa_prefinexp_op_ttm decimal(20,4) comment '扣除财务费用前营业利润(TTM)',
  s_dfa_taxtoor_ttm decimal(20,4) comment '营业利润/利润总额(TTM)',
  s_dfa_noptoebt_ttm decimal(20,4) comment '非营业利润/利润总额(TTM)',
  s_dfa_taxtoebt_ttm decimal(20,4) comment '税项/利润总额(TTM)',
  s_dfa_optoor_ttm decimal(20,4) comment '营业利润/营业收入(TTM)',
  s_dfa_ebttoor_ttm decimal(20,4) comment '利润总额/营业收入(TTM)',
  s_prefinexpoptoebt decimal(20,4) comment '扣除融资费用前营业利润/营业收入(TTM)',
  s_dfa_netprofittoor_ttm decimal(20,4) comment '归属母公司股东的净利润/营业收入(TTM)',
  s_operatecashflowtoop_ttm decimal(20,4) comment '扣除融资费用前营业利润/利润总额(TTM)',
  s_netprofittoassets decimal(20,4) comment '经营活动产生的现金流量净额/营业利润(TTM)',
  s_roa_exclminintinc_ttm decimal(20,4) comment '总资产净利率-不含少数股东损益(TTM)',
  s_dfa_debttoasset decimal(20,4) comment '资产负债率(MRQ)',
  s_dfa_interestexpense_ttm decimal(20,4) comment '利息支出(TTM)',
  s_dfa_tax_ttm decimal(20,4) comment '所得税(TTM)',
  s_dfa_minorityinterest_ttm decimal(20,4) comment '少数股东权益(TTM)',
  s_dfa_continue_net_op_ttm decimal(20,4) comment '持续经营净利润(TTM)',
  s_dfa_noncontinue_net_op_ttm decimal(20,4) comment '非持续经营净利润(TTM)',
  s_dfa_nonnetoptotaxprofit decimal(20,4) comment '非持续经营净利润/税后利润(TTM)',
  s_dfa_netoptotaxprofit decimal(20,4) comment '持续经营净利润/税后利润(TTM)',
  s_dfa_cur_liab decimal(20,4) comment '流动负债(MRQ)',
  s_fa_cur_assets decimal(20,4) comment '流动资产(MRQ)',
  s_fa_long_term_liabilities decimal(20,4) comment '长期负债(MRQ)',
  s_dfa_cce_ttm decimal(20,4) comment '期末现金及现金等价物余额',
  s_dfa_opertax_ttm decimal(20,4) comment '营业税金及附加(TTM)',
  s_dfa_ttmgrowrate_cff decimal(20,4) comment '同比增长率-筹资活动产生的现金流量净额(TTM)',
  s_dfa_ttmgrowrate_cfo decimal(20,4) comment '同比增长率-投资活动产生的现金流量净额(TTM)',
  s_dfa_ttmgrowrate_profit decimal(20,4) comment '同比增长率-净利润(TTM)',
  s_dfa_ttmgrowrate_netprofit decimal(20,4) comment '同比增长率-归属母公司股东的净利润(TTM)',
  s_dfa_ttmgrowrate_gm decimal(20,4) comment '同比增长率-毛利率(TTM)',
  s_dfa_cash_ratio decimal(20,4) comment '现金比率(MRQ)',
  s_dfa_cashtocurliabs decimal(20,4) comment '现金流动负债比(TTM)',
  s_dfa_acca decimal(20,4) comment '现金流资产比-资产回报率(TTM)',
  s_dfa_currtassetstrate decimal(20,4) comment '流动资产周转率(TTM)',
  s_dfa_nat_ttm decimal(20,4) comment '净资产周转率(TTM)',
  s_dfa_roa_ttm decimal(20,4) comment '资产回报率(TTM)',
  s_dfa_roe2_ttm decimal(20,4) comment '权益回报率(TTM)',
  s_dfa_roc_ttm decimal(20,4) comment '资本报酬率(TTM)',
  s_dfa_salescostratio_ttm decimal(20,4) comment '销售成本率(TTM)',
  s_dfa_taxratio_ttm decimal(20,4) comment '销售税金率(TTM)',
  s_dfa_ebittogr decimal(20,4) comment '息税前利润/营业总收入(TTM)',
  s_dfa_earnmom decimal(20,4) comment '八季度净利润变化趋势',
  s_dfa_dividend_multiple decimal(20,4) comment '股利保障倍数(TTM)',
  s_dfa_roa_ttm_avg5y decimal(20,4) comment '5年平均资产回报率',
  s_dfa_roe_ttm_avg5y decimal(20,4) comment '5年平均权益回报率',
  s_dfa_ttmgrowrate_op decimal(20,4) comment '同比增长率-营业利润(TTM)',
  s_dfa_ttmgrowrate_cfott decimal(20,4) comment '同比增长率-经营活动产生的现金流量净额(TTM)',
  s_gross_profit_operating_cost decimal(20,4) comment '毛利/运营费用(TTM)',
  s_dfa_net_cashflow_ttm decimal(20,4) comment '同比增长率-净现金流量(TTM)',
  s_fa_yoyroe decimal(20,4) comment '同比增长率-净资产',
  s_dfa_ebt_ttm_growth_rate decimal(20,4) comment '同比增长率-利润总额(TTM)',
  s_fa_yoy_or decimal(20,4) comment '同比增长率-营业收入(TTM)',
  s_fa_invturn decimal(20,4) comment '存货周转率(TTM)',
  s_fa_faturn_ttm decimal(20,4) comment '固定资产周转率(TTM)',
  s_fa_acc_payable_turnover decimal(20,4) comment '应付账款周转率(TTM)',
  s_fa_arturn decimal(20,4) comment '应收账款周转率(TTM)',
  s_fa_assetsturn decimal(20,4) comment '总资产周转率(TTM)',
  s_fa_invturndays decimal(20,4) comment '存货周转天数',
  s_acc_payable_turnover_day decimal(20,4) comment '应付账款周转天数',
  s_fa_arturndays decimal(20,4) comment '应收账款周转天数',
  s_fa_cash_conversion_cycle decimal(20,4) comment '现金转换周期',
  s_fa_turndays decimal(20,4) comment '营业周期',
  s_fa_pretax_after_tax_profits decimal(20,4) comment '息前税后利润',
  s_fa_rpc decimal(20,4) comment '成本费用利润率(TTM)',
  s_fa_ocftodebt decimal(20,4) comment '经营活动产生的现金流量净额(TTM)/负债合计',
  s_fa_ocftointerestdebt decimal(20,4) comment '经营活动产生现金流量净额(TTM)/带息负债',
  s_fa_ocftonetdebt decimal(20,4) comment '经营活动产生现金流量净额(TTM)/净债务',
  s_fa_operateincometoebt decimal(20,4) comment '经营活动净收益/利润总额',
  s_percentage_earnings_retained decimal(20,4) comment '留存收益率(TTM)',
  s_fa_book_leverage decimal(20,4) comment '账面杠杆',
  s_dfa_totliab_tnw decimal(20,4) comment '负债合计/有形净值',
  s_fa_waa_roe3 decimal(20,4) comment '净资产收益率(加权平均，公布值)',
  s_fa_waa_roe2 decimal(20,4) comment '净资产收益率(扣除加权平均，公布值)',
  s_fa_waa_roe1 decimal(20,4) comment '净资产收益率(扣除摊薄，公布值)',
  s_fa_waa_roe decimal(20,4) comment '净资产收益率(平均)',
  s_fa_roe_deducted decimal(20,4) comment '净资产收益率(摊薄，公布值)',
  s_fa_roa2_yearly decimal(20,4) comment '同比增长率-总资产',
  s_fa_int_protection_multiple decimal(20,4) comment '利息保障倍数',
  s_fa_intdebttototalcap decimal(20,4) comment '带息负债/全部投入资本',
  s_fa_longdebtodebt decimal(20,4) comment '非流动资产比率',
  s_fa_liquidity_ratio decimal(20,4) comment '流动资产比率',
  s_fa_owner_capitalinvested decimal(20,4) comment '归属于母公司所有者权益合计/全部投入资本',
  s_fa_debttoequity decimal(20,4) comment '产权比率',
  s_fa_long_tl decimal(20,4) comment '长期负债与营运资金比率',
  s_fa_overspeed_ratio decimal(20,4) comment '超速动比率',
  s_fa_intdebttoassets decimal(20,4) comment '归属母公司股东的权益/带息负债',
  s_fa_ocftoor decimal(20,4) comment '经营活动产生的现金流量净额/营业收入',
  s_fa_current decimal(20,4) comment '流动比率',
  s_fa_quick decimal(20,4) comment '速动比率',
  s_fa_salescashintoor decimal(20,4) comment '销售商品提供劳务收到的现金/营业收入',
  s_fa_tangassettointdebt decimal(20,4) comment '有形净值/带息负债',
  s_fa_tangibleassettonetdebt decimal(20,4) comment '有形净值/净债务',
  s_fa_interestdebt decimal(20,4) comment '带息债务',
  s_fa_extraordinary decimal(20,4) comment '非经常性损益',
  s_fa_fcfe decimal(20,4) comment '股权自由现金流量',
  s_fa_eps_basic decimal(20,4) comment '基本每股收益',
  s_fa_operateincome decimal(20,4) comment '经营活动净收益',
  s_fa_netdebt decimal(20,4) comment '净债务',
  s_fa_retainedearnings decimal(20,4) comment '留存收益',
  s_fa_fcff decimal(20,4) comment '企业自由现金流量',
  s_fa_exinterestdebt_noncurrent decimal(20,4) comment '无息非流动负债',
  s_fa_exinterestdebt_current decimal(20,4) comment '无息流动负债',
  s_fa_eps_diluted decimal(20,4) comment '稀释每股收益',
  s_fa_tangibleasset decimal(20,4) comment '有形资产',
  s_fa_op_cap decimal(20,4) comment '营运资本',
  s_fa_capitalizedtoda decimal(20,4) comment '折旧和摊销',
  s_fa_cash_dividend_multiple decimal(20,4) comment '现金股利保障倍数(TTM)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
 COMMENT 'PIT财务指标变动表(中国准则)'
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_pledgecode;
create table if not exists ty_ods.w_pledgecode
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  type_code bigint comment '业务类型代码',
  pledge_code string comment '质押券代码',
  pledge_name string comment '质押券名称',
  is_valid bigint comment '是否有效',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_poolinitialstatistics;
create table if not exists ty_ods.w_poolinitialstatistics
(
  object_id string comment '对象ID',
  pool_name string comment '资产池名称',
  dt string comment '日期',
  item_code bigint comment '统计项目代码',
  type string comment '统计类别',
  type_code bigint comment '统计指标代码',
  value decimal(24,8) comment '指标数据',
  unit string comment '指标单位',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_poolstatistics;
create table if not exists ty_ods.w_poolstatistics
(
  object_id string comment '对象ID',
  pool_name string comment '资产池名称',
  ann_dt string comment '公告日期',
  start_dt string comment '收款期间起始日',
  end_dr string comment '收款期间截止日',
  laon_balance decimal(24,8) comment '贷款余额(万元)',
  laon_num decimal(24,4) comment '贷款笔数',
  wa_loanrate decimal(24,4) comment '加权平均贷款利率',
  wa_remtm decimal(24,4) comment '加权平均贷款剩余期限（年）',
  credit_num decimal(24,4) comment '信用贷款笔数',
  guarantee_num decimal(24,4) comment '保证担保贷款笔数',
  credit_pct decimal(24,4) comment '信用贷款金额占比',
  guarantee_pct decimal(24,4) comment '保证担保贷款金额占比',
  defaut_value decimal(24,8) comment '累计违约金额（万元）',
  default_backvalue decimal(24,8) comment '累计回收违约本金（万元）',
  default_rate decimal(24,4) comment '累计违约率',
  arrears_rate decimal(24,4) comment '严重拖欠率',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_qdiiindportfolio;
create table if not exists ty_ods.w_qdiiindportfolio
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  ann_dt string comment '公告日期',
  end_dt string comment '截止日期',
  ind string comment '行业类别',
  value decimal(20,4) comment '持仓市值(元)',
  pct_nav decimal(20,4) comment '占基金资产净值比例(%)',
  gics_code string comment '行业代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_qdiiscopeportfolio;
create table if not exists ty_ods.w_qdiiscopeportfolio
(
  object_id string comment '对象id',
  s_info_windcode string comment 'Wind代码',
  ann_date string comment '公告日期',
  enddate string comment '截止日期',
  scope string comment '国家（地区)代码',
  value decimal(20,4) comment '市值(元)',
  posstktonav decimal(20,4) comment '占净资产的比例(%)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_qfiiquotachange;
create table if not exists ty_ods.w_qfiiquotachange
(
  object_id string comment '对象id',
  f_info_compname string comment '公司名称',
  f_info_compcode string comment '公司ID',
  invest_amount decimal(20,4) comment '投资额度(亿)',
  change_dt string comment '变动日期',
  crncy_code string comment '货币代码',
  type bigint comment '类型代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_rcloanofthepool;
create table if not exists ty_ods.w_rcloanofthepool
(
  object_id string comment '对象ID',
  pool_name string comment '资产池名称',
  ann_dt string comment '公告日期',
  start_dt string comment '收款期间起始日',
  end_dr string comment '收款期间截止日',
  rcloan_num decimal(24,4) comment '回收贷款笔数(笔)',
  rc decimal(24,8) comment '收入回收款(万元)',
  rcprincipal decimal(24,8) comment '本金回收款(万元)',
  rcinterest decimal(24,8) comment '利息回收款(万元)',
  rcpenalty decimal(24,8) comment '违约金回收款(万元)',
  rcother decimal(24,8) comment '其他回收款(万元)',
  payip_num decimal(24,4) comment '计划内还款笔数',
  payip decimal(24,8) comment '计划内还款本金(万元)',
  prepay_num decimal(24,4) comment '提前还款笔数',
  prepay decimal(24,8) comment '提前还款本金(万元)',
  arrears_rcnum decimal(24,4) comment '拖欠回收笔数',
  arrears_rc decimal(24,8) comment '拖欠回收本金(万元)',
  default_rcnum decimal(24,4) comment '违约回收笔数',
  default_rc decimal(24,8) comment '违约回收本金(万元)',
  taxes decimal(24,8) comment '税费支出(万元)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_relatedevent;
create table if not exists ty_ods.w_relatedevent
(
  object_id string comment '对象ID',
  event_id string comment '事件ID',
  related_id string comment '关联事件ID',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_revenuetechnicalfactor;
create table if not exists ty_ods.w_revenuetechnicalfactor
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '交易日期',
  s_risk_earning_day decimal(20,8) comment '每日收益',
  s_risk_variance20 decimal(20,8) comment '20日收益方差',
  s_risk_variance30 decimal(20,8) comment '30日收益方差',
  s_risk_variance60 decimal(20,8) comment '60日收益方差',
  s_risk_variance120 decimal(20,8) comment '120日收益方差',
  s_risk_gainvariance20 decimal(20,8) comment '20日正收益方差',
  s_risk_gainvariance60 decimal(20,8) comment '60日正收益方差',
  s_risk_gainvariance120 decimal(20,8) comment '120日正收益方差',
  s_risk_lossvariance20 decimal(20,8) comment '20日损失方差',
  s_risk_lossvariance60 decimal(20,8) comment '60日损失方差',
  s_risk_lossvariance120 decimal(20,8) comment '120日损失方差',
  s_risk_glvarianceratio20 decimal(20,8) comment '20日收益损失方差比',
  s_risk_glvarianceratio60 decimal(20,8) comment '60日收益损失方差比',
  s_risk_glvarianceratio120 decimal(20,8) comment '120日收益损失方差比',
  s_risk_revsvarratio decimal(20,8) comment '30日120日回报方差比率',
  s_risk_kurtosis20 decimal(20,8) comment '个股收益的20日峰度',
  s_risk_kurtosis60 decimal(20,8) comment '个股收益的60日峰度',
  s_risk_kurtosis120 decimal(20,8) comment '个股收益的120日峰度',
  s_risk_beta20 decimal(20,8) comment '个股20日的beta值',
  s_risk_beta60 decimal(20,8) comment '个股60日的beta值',
  s_risk_beta120 decimal(20,8) comment '个股120日的beta值',
  s_risk_treynorratio20 decimal(20,8) comment '20日特诺雷比率',
  s_risk_treynorratio60 decimal(20,8) comment '60日特诺雷比率',
  s_risk_treynorratio120 decimal(20,8) comment '120日特诺雷比率',
  s_tech_revs5 decimal(20,8) comment '过去5日的价格动量',
  s_tech_revs10 decimal(20,8) comment '过去10日的价格动量',
  s_tech_revs20 decimal(20,8) comment '过去1个月的价格动量',
  s_tech_revs60 decimal(20,8) comment '过去3个月的价格动量',
  s_tech_revs120 decimal(20,8) comment '过去6个月的价格动量',
  s_tech_revs250 decimal(20,8) comment '过去1年的价格动量',
  s_tech_revs750 decimal(20,8) comment '过去3年的价格动量',
  s_tech_revs5m20 decimal(20,8) comment '过去5日的价格动量-过去1个月的价格动量',
  s_tech_revs5m60 decimal(20,8) comment '过去5日的价格动量-过去3个月的价格动量',
  s_tech_rank1m decimal(20,8) comment '1-过去一个月收益率排名/股票总数的比值',
  s_tech_revs6m20 decimal(20,8) comment '过去6个月的动量-过去1个月的动量',
  s_tech_revs12m20 decimal(20,8) comment '过去12个月的动量-过去1个月的动量',
  s_tech_revs12m6m decimal(20,8) comment '12M收益率的120D变化率',
  s_tech_revs1mmax decimal(20,8) comment '过去1个月的日收益率的最大值',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
 COMMENT '收益类技术因子'
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_scfclause;
create table if not exists ty_ods.w_scfclause
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  type_code bigint comment '条款属性类型代码',
  start_dt string comment '起始日期',
  end_dt string comment '终止日期',
  cur_sign bigint comment '是否最新',
  content string comment '条款',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_scfconvert;
create table if not exists ty_ods.w_scfconvert
(
  object_id string comment '对象ID',
  s_info_windcode string comment '基金Wind代码',
  convert_reason bigint comment '折算原因代码',
  period decimal(20,4) comment '折算周期(年)',
  convert_dt string comment '折算基准日',
  nav_typecode bigint comment '基金净值类型代码',
  nav_min decimal(20,4) comment '基金净值下限(元)',
  nav_max decimal(20,4) comment '基金净值上限(元)',
  convert_typecode bigint comment '折算方式代码',
  convert_fund_typecode bigint comment '折算母基金份额的方式代码',
  convert_feeder_typecode bigint comment '折算子基金份额的方式代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_scfreturndistribution;
create table if not exists ty_ods.w_scfreturndistribution
(
  object_id string comment '对象ID',
  s_info_windcode string comment '母基金Wind代码',
  f_info_feeder_windcode string comment '子基金Wind代码',
  rule_staretdt string comment '收益分配条约起始日期',
  rule_enddt string comment '收益分配条约截止日期',
  pri_benchreturn decimal(20,4) comment '优先份额基准收益率(%)',
  type_code bigint comment '优先份额基准收益率获取方式代码',
  returndist_code bigint comment '子基金收益方式代码',
  exreturn_share decimal(20,4) comment '子基金超额收益分成占比(%)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_securitiestypecode;
create table if not exists ty_ods.w_securitiestypecode
(
  object_id string comment '对象ID',
  type_code string comment '证券类型代码',
  type string comment '证券类型',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_sharefundstylethreshold;
create table if not exists ty_ods.w_sharefundstylethreshold
(
  object_id string comment '对象ID',
  s_change_date string comment '变动日期',
  threshold_large_stock decimal(20,4) comment '大盘股门限值(万元)',
  threshold_mid_stock decimal(20,4) comment '中盘股门限值(万元)',
  threshold_growth_stock decimal(20,4) comment '成长型门限值',
  threshold_value_stock decimal(20,4) comment '价值型门限值',
  date_closing_date string comment '引用数据的截止日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_shscchannelholdings;
create table if not exists ty_ods.w_shscchannelholdings
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'WIND代码',
  trade_dt string comment '持股日期',
  s_info_exchmarketname string comment '交易所英文简称',
  s_quantity decimal(20,4) comment '中央结算系统持股量',
  s_ratio decimal(20,4) comment '[内部]中央结算系统持股量占比',
  s_info_code string comment '[内部]股份代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_shscdailystatistics;
create table if not exists ty_ods.w_shscdailystatistics
(
  object_id string comment '对象ID',
  trade_dt string comment '日期',
  s_info_exchmarket string comment '交易所英文简称',
  value decimal(20,4) comment '数据',
  item_code bigint comment '项目代码',
  unit string comment '单位',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_shscshortselling;
create table if not exists ty_ods.w_shscshortselling
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '日期',
  short_sell_stocks_max decimal(20,4) comment '最多可供卖空的股数(股)',
  short_sell_stocks_balance decimal(20,4) comment '可供卖空的股数余额(股)',
  short_sale_num decimal(20,4) comment '卖空成交股数(股)',
  short_sale_amount decimal(20,4) comment '卖空成交金额(元)',
  short_sell_proportion decimal(20,4) comment '当天卖空比例(%)',
  short_sell_proportion_total decimal(20,4) comment '累计十天卖空比例(%)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_shsctop10activestocks;
create table if not exists ty_ods.w_shsctop10activestocks
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '日期',
  market string comment '市场',
  buytradevalue decimal(20,4) comment '买入金额',
  selltradevalue decimal(20,4) comment '卖出金额',
  totaltradevalue decimal(20,4) comment '成交金额',
  crncy_code string comment '货币代码',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_sindexperformance;
create table if not exists ty_ods.w_sindexperformance
(
  object_id string,
  s_info_windcode string,
  trade_dt string,
  pct_chg_recent1m decimal(20,6),
  pct_chg_recent3m decimal(20,6),
  pct_chg_recent6m decimal(20,6),
  pct_chg_recent1y decimal(20,6),
  pct_chg_recent2y decimal(20,6),
  pct_chg_recent3y decimal(20,6),
  pct_chg_recent4y decimal(20,6),
  pct_chg_recent5y decimal(20,6),
  pct_chg_recent6y decimal(20,6),
  pct_chg_thisweek decimal(20,6),
  pct_chg_thismonth decimal(20,6),
  pct_chg_thisquarter decimal(20,6),
  pct_chg_thisyear decimal(20,6),
  si_pct_chg decimal(20,6),
  annualyeild decimal(20,6),
  std_dev_6m decimal(20,6),
  std_dev_1y decimal(20,6),
  std_dev_2y decimal(20,6),
  std_dev_3y decimal(20,6),
  sharpratio_6m decimal(20,6),
  sharpratio_1y decimal(20,6),
  sharpratio_2y decimal(20,6),
  sharpratio_3y decimal(20,6),
  pct_chg_recent1w decimal(20,6),
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_suspendsecvaluationmethod;
create table if not exists ty_ods.w_suspendsecvaluationmethod
(
  object_id string comment '对象ID',
  s_info_compcode string comment '基金公司ID',
  s_info_compname string comment '基金公司名称',
  s_info_windcode string comment '停牌证券WIND代码',
  ann_dt string comment '公告日期',
  s_dq_suspenddate string comment '停牌日期',
  price decimal(20,4) comment '停牌价格(元)',
  type_code bigint comment '估值方法代码',
  ind_windcode string comment '跟踪指数WIND代码',
  s_dq_resumpdate string comment '复牌日期',
  val_price decimal(20,4) comment '公布估值价格',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_suspendsecvaluation;
create table if not exists ty_ods.w_suspendsecvaluation
(
  object_id string comment '对象ID',
  type_code bigint comment '估值方法代码',
  s_info_windcode string comment '停牌证券ID',
  val_dt string comment '估值日期',
  val_price decimal(20,4) comment '估值价格(元)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_top5byaccountsreceivable;
create table if not exists ty_ods.w_top5byaccountsreceivable
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_info_compcode string comment '公司ID',
  report_period string comment '报告期',
  s_info_compname string comment '债务人名称',
  amount decimal(20,4) comment '金额（元）',
  crncy_code string comment '货币代码',
  period string comment '拖欠时间',
  reason string comment '拖欠原因',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_top5bylongtermborrowing;
create table if not exists ty_ods.w_top5bylongtermborrowing
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_info_compcode string comment '公司ID',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  s_info_compname string comment '单位名称',
  s_info_compcode2 string comment '单位名称ID',
  typecode bigint comment '往来资金类别代码',
  conditioncode bigint comment '往来资金条件代码',
  start_dt string comment '起始日',
  end_dt string comment '终止日',
  amount1 decimal(20,4) comment '金额（元）',
  amount2 decimal(20,4) comment '原币金额（元）',
  crncy_code string comment '货币代码',
  rate string comment '利率(%)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_top5byoperatingincome;
create table if not exists ty_ods.w_top5byoperatingincome
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_info_compcode string comment '公司ID',
  report_period string comment '报告期',
  ann_dt string comment '公告日期',
  s_info_compname string comment '单位名称',
  s_info_compcode2 string comment '单位名称ID',
  salesamount decimal(20,4) comment '金额(元)',
  crncy_code string comment '货币代码',
  pct decimal(20,4) comment '占比(%)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_trendriskfactor;
create table if not exists ty_ods.w_trendriskfactor
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '交易日期',
  s_tech_ma10regresscoeff6 decimal(20,8) comment '12日变化率指数',
  s_tech_ma10regresscoeff12 decimal(20,8) comment '24日变化率指数',
  s_tech_plrc6 decimal(20,8) comment 'Ulcer5',
  s_tech_plrc12 decimal(20,8) comment 'Ulcer10',
  s_tech_ddncr decimal(20,8) comment '下跌相关系数',
  s_tech_ddnsr decimal(20,8) comment '下跌波动',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
 COMMENT '趋势风险因子'
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_ttmandmrqindex;
create table if not exists ty_ods.w_ttmandmrqindex
(
  object_id string comment '对象ID',
  s_info_compcode string comment '公司ID',
  report_period string comment '截止日期',
  ann_dt string comment '公告日期',
  s_fa_or_ttm decimal(20,4) comment '营业收入(TTM)',
  s_fa_cost_ttm decimal(20,4) comment '营业成本-非金融类(TTM)',
  s_fa_expense_ttm decimal(20,4) comment '营业支出-金融类(TTM)',
  s_fa_grossmargin_ttm decimal(20,4) comment '毛利(TTM)',
  s_fa_operateincome_ttm decimal(20,4) comment '经营活动净收益(TTM)',
  s_fa_investincome_ttm decimal(20,4) comment '价值变动净收益(TTM)',
  s_fa_op_ttm decimal(20,4) comment '营业利润(TTM)',
  s_fa_ebt_ttm decimal(20,4) comment '利润总额(TTM)',
  s_fa_profit_ttm decimal(20,4) comment '净利润(TTM)',
  s_fa_netprofit_ttm decimal(20,4) comment '归属于母公司的净利润(TTM)',
  s_fa_gr_ttm decimal(20,4) comment '营业总收入(TTM)',
  s_fa_gc_ttm decimal(20,4) comment '营业总成本(TTM)',
  s_fa_cashflow_ttm decimal(20,4) comment '现金净流量(TTM)',
  s_fa_operatecashflow_ttm decimal(20,4) comment '经营活动现金净流量(TTM)',
  s_fa_investcashflow_ttm decimal(20,4) comment '投资活动现金净流量(TTM)',
  s_fa_financecashflow_ttm decimal(20,4) comment '筹资活动现金净流量(TTM)',
  s_fa_asset_mrq decimal(20,4) comment '资产总计(MRQ)',
  s_fa_debt_mrq decimal(20,4) comment '负债合计(MRQ)',
  s_fa_totalequity_mrq decimal(20,4) comment '股东权益(MRQ)',
  s_fa_equity_mrq decimal(20,4) comment '归属于母公司的股东权益(MRQ)',
  currency_code string comment '货币代码',
  s_fa_netprofitmargin_ttm decimal(20,4) comment '销售净利率(TTM)',
  s_fa_grossprofitmargin_ttm decimal(20,4) comment '销售毛利率(TTM)',
  s_fa_expensetosales_ttm decimal(20,4) comment '销售期间费用率(TTM)',
  s_fa_profittogr_ttm decimal(20,4) comment '净利润/营业总收入(TTM)',
  s_fa_operateexpensetogr_ttm decimal(20,4) comment '销售费用/营业总收入(TTM)',
  s_fa_adminexpensetogr_ttm decimal(20,4) comment '管理费用/营业总收入(TTM)',
  s_fa_finaexpensetogr_ttm decimal(20,4) comment '财务费用/营业总收入(TTM)',
  s_fa_impairtogr_ttm decimal(20,4) comment '资产减值损失/营业总收入(TTM)',
  s_fa_gctogr_ttm decimal(20,4) comment '营业总成本/营业总收入(TTM)',
  s_fa_optogr_ttm decimal(20,4) comment '营业利润/营业总收入(TTM)',
  s_fa_roa_ttm decimal(20,4) comment '总资产净利率(TTM)',
  s_fa_roa2_ttm decimal(20,4) comment '总资产报酬率(TTM)',
  s_fa_roe_ttm decimal(20,4) comment '净资产收益率(TTM)',
  s_fa_operateincometoebt_ttm decimal(20,4) comment '经营活动净收益/利润总额(TTM)',
  s_fa_investincometoebt_ttm decimal(20,4) comment '价值变动净收益/利润总额(TTM)',
  s_fa_nonoperateprofittoebt_ttm decimal(20,4) comment '营业外收支净额/利润总额(TTM)',
  s_fa_salescashintoor_ttm decimal(20,4) comment '销售商品提供劳务收到的现金/营业收入(TTM)',
  s_fa_ocftoor_ttm decimal(20,4) comment '经营活动产生的现金流量净额/营业收入(TTM)',
  s_fa_ocftooperateincome_ttm decimal(20,4) comment '经营活动产生的现金流量净额/经营活动净收益(TTM)',
  s_dfa_deductedprofit_ttm decimal(20,4) comment '扣除非经常性损益后的净利润(TTM)',
  s_fa_ebitda_ttm_rev decimal(20,4) comment 'EBITDA(TTM反推法)',
  s_fa_ebitda_ttm decimal(20,4) comment 'EBITDA(TTM)',
  s_fa_ebit_ttm decimal(20,4) comment 'EBIT(TTM)',
  s_dfa_roic2_ttm decimal(20,4) comment '投入资本回报率(TTM)',
  s_fa_salescashin_ttm decimal(20,4) comment '销售商品提供劳务收到的现金(TTM)',
  s_fa_operateexpense_ttm decimal(20,4) comment '销售费用(TTM)',
  s_fa_adminexpense_ttm decimal(20,4) comment '管理费用(TTM)',
  s_fa_finaexpense_ttm decimal(20,4) comment '财务费用(TTM)',
  s_fa_expense decimal(20,4) comment '期间费用(TTM)',
  s_fa_nonoperateprofit_ttm decimal(20,4) comment '营业外收支净额(TTM)',
  s_fa_impairment_ttm decimal(20,4) comment '资产减值损失(TTM)',
  s_fa_ebit_ttm_rev decimal(20,4) comment 'EBIT(TTM反推法)',
  s_fa_investcapital_mrq decimal(20,4) comment '全部投入资本(MRQ)',
  s_fa_roic_ttm decimal(20,4) comment '投入资本回报率ROIC(TTM)',
  s_stm_bsmrq decimal(20,4) comment '固定资产合计(MRQ)',
  s_fa_nonopprofit_ttm decimal(20,4) comment '非营业利润(TTM)',
  s_fa_prefinexp_op_ttm decimal(20,4) comment '扣除财务费用前营业利润(TTM)',
  s_fa_optoebt_ttm decimal(20,4) comment '营业利润/利润总额(TTM)',
  s_fa_noptoebt_ttm decimal(20,4) comment '非营业利润/利润总额(TTM)',
  s_fa_taxtoebt_ttm decimal(20,4) comment '税项/利润总额(TTM)',
  s_fa_optoor_ttm decimal(20,4) comment '营业利润/营业收入(TTM)',
  s_fa_ebttoor_ttm decimal(20,4) comment '利润总额/营业收入(TTM)',
  s_fa_prefinexpoptoor_ttm decimal(20,4) comment '扣除融资费用前营业利润/营业收入(TTM)',
  s_fa_netprofittoor_ttm decimal(20,4) comment '归属母公司股东的净利润/营业收入(TTM)',
  s_fa_prefinexpoptoebt_ttm decimal(20,4) comment '扣除融资费用前营业利润/利润总额(TTM)',
  s_fa_ocftoop_ttm decimal(20,4) comment '经营活动产生的现金流量净额/营业利润(TTM)',
  roa_exclminintinc_ttm decimal(20,4) comment '总资产净利率-不含少数股东损益(TTM)',
  s_fa_debttoassets_mrq decimal(20,4) comment '资产负债率(MRQ)',
  s_dfa_interestexpense_ttm decimal(20,4) comment '利息支出(TTM)',
  s_dfa_tax_ttm decimal(20,4) comment '所得税(TTM)',
  s_dfa_minorityinterest_ttm decimal(20,4) comment '少数股东权益(TTM)',
  s_dfa_continue_net_op_ttm decimal(20,4) comment '持续经营净利润(TTM)',
  s_dfa_noncontinue_net_op_ttm decimal(20,4) comment '非持续经营净利润(TTM)',
  s_dfa_nonnetoptotaxprofit decimal(20,4) comment '非持续经营净利润/税后利润(TTM)',
  s_dfa_netoptotaxprofit decimal(20,4) comment '持续经营净利润/税后利润(TTM)',
  s_current_liabilities_mrq decimal(20,4) comment '流动负债(MRQ)',
  s_current_assets_mrq decimal(20,4) comment '流动资产(MRQ)',
  s_longterm_liabilities_mrq decimal(20,4) comment '长期负债(MRQ)',
  s_cash_cash_equ_end_period decimal(20,4) comment '期末现金及现金等价物余额',
  s_dfa_opertax_ttm decimal(20,4) comment '营业税金及附加(TTM)',
  s_dfa_ttmgrowrate_cff decimal(20,4) comment '同比增长率-筹资活动产生的现金流量净额(TTM)',
  s_dfa_ttmgrowrate_cfo decimal(20,4) comment '同比增长率-投资活动产生的现金流量净额(TTM)',
  s_dfa_ttmgrowrate_profit decimal(20,4) comment '同比增长率-净利润(TTM)',
  s_dfa_ttmgrowrate_netprofit decimal(20,4) comment '同比增长率-归属母公司股东的净利润(TTM)',
  s_dfa_ttmgrowrate_gm decimal(20,4) comment '同比增长率-毛利率(TTM)',
  s_cash_ratio_mrq decimal(20,4) comment '现金比率(MRQ)',
  s_dfa_cfotocurliabs decimal(20,4) comment '现金流动负债比(TTM)',
  s_dfa_acca decimal(20,4) comment '现金流资产比-资产回报率(TTM)',
  s_dfa_currtassetstrate decimal(20,4) comment '流动资产周转率(TTM)',
  s_dfa_nat_ttm decimal(20,4) comment '净资产周转率(TTM)',
  s_dfa_roa_ttm decimal(20,4) comment '资产回报率(TTM)',
  s_dfa_roe2_ttm decimal(20,4) comment '权益回报率(TTM)',
  s_dfa_roc_ttm decimal(20,4) comment '资本报酬率(TTM)',
  s_dfa_salescostratio_ttm decimal(20,4) comment '销售成本率(TTM)',
  s_dfa_taxratio_ttm decimal(20,4) comment '销售税金率(TTM)',
  s_dfa_ebittogr decimal(20,4) comment '息税前利润/营业总收入(TTM)',
  s_dfa_earnmom decimal(20,4) comment '八季度净利润变化趋势',
  s_property_right_ratio decimal(20,4) comment '产权比率',
  s_dfa_roa_ttm_avg5y decimal(20,4) comment '5年平均资产回报率',
  s_dfa_roe_ttm_avg5y decimal(20,4) comment '5年平均权益回报率',
  s_dfa_ttmgrowrate_op decimal(20,4) comment '同比增长率-营业利润(TTM)',
  s_dfa_ttmgrowrate_cfott decimal(20,4) comment '同比增长率-经营活动产生的现金流量净额(TTM)',
  s_gross_profit_opex_ttm decimal(20,4) comment '毛利/运营费用(TTM)',
  s_net_cashflow_growth_rate decimal(20,4) comment '同比增长率-净现金流量(TTM)',
  s_net_assets_growth_rate decimal(20,4) comment '同比增长率-净资产',
  s_total_profit_growth_rate decimal(20,4) comment '同比增长率-利润总额(TTM)',
  s_income_growth_rate decimal(20,4) comment '同比增长率-营业收入(TTM)',
  s_fa_invturn_ttm decimal(20,4) comment '存货周转率(TTM)',
  s_fa_faturn_ttm decimal(20,4) comment '固定资产周转率(TTM)',
  s_fa_acct_payable_ttm decimal(20,4) comment '应付账款周转率(TTM)',
  s_fa_arturn_ttm decimal(20,4) comment '应收账款周转率(TTM)',
  s_fa_assetsturn_ttm decimal(20,4) comment '总资产周转率(TTM)',
  s_fa_invturndays decimal(20,4) comment '存货周转天数',
  s_fa_acct_payable_days decimal(20,4) comment '应付账款周转天数',
  s_fa_arturndays decimal(20,4) comment '应收账款周转天数',
  s_fa_cash_conversion_cycle decimal(20,4) comment '现金转换周期',
  s_fa_turndays decimal(20,4) comment '营业周期',
  s_pre_tax_after_tax_profits decimal(20,4) comment '息前税后利润',
  s_fa_rpc decimal(20,4) comment '成本费用利润率(TTM)',
  s_fa_ocftodebt_ttm decimal(20,4) comment '经营活动产生的现金流量净额(TTM)/负债合计',
  s_fa_ocftointerestdebt_ttm decimal(20,4) comment '经营活动产生现金流量净额(TTM)/带息负债',
  s_fa_ocftonetdebt_ttm decimal(20,4) comment '经营活动产生现金流量净额(TTM)/净债务',
  s_dfa_operateincometoebt decimal(20,4) comment '经营活动净收益/利润总额',
  s_total_assets_growth_rate decimal(20,4) comment '同比增长率-总资产',
  s_fa_book_lever decimal(20,4) comment '账面杠杆',
  s_fa_tangible_net_value decimal(20,4) comment '负债合计/有形净值',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
 COMMENT 'TTM历史与MRQ指标(中国准则)'
row format delimited fields terminated by '\t'
stored as orc;



drop table if exists ty_ods.w_turnovertechnicalfactor;
create table if not exists ty_ods.w_turnovertechnicalfactor
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  trade_dt string comment '交易日期',
  s_tech_tvma6 decimal(20,8) comment '6日成交额均值(万元)',
  s_tech_tvma20 decimal(20,8) comment '20日成交额均值(万元)',
  s_tech_tvma60 decimal(20,8) comment '60日成交额均值(万元)',
  s_tech_tvstd6 decimal(20,8) comment '6日成交额标准差',
  s_tech_tvstd20 decimal(20,8) comment '20日成交额标准差',
  s_tech_vema5 decimal(20,8) comment '5日成交量EMA（手）',
  s_tech_vema10 decimal(20,8) comment '10日成交量EMA（手）',
  s_tech_vema12 decimal(20,8) comment '12日成交量EMA（手）',
  s_tech_vema26 decimal(20,8) comment '26日成交量EMA（手）',
  s_tech_vroc6 decimal(20,8) comment '6日量变动速率指标',
  s_tech_vroc12 decimal(20,8) comment '12日量变动速率指标',
  s_tech_vr decimal(20,8) comment '成交量比率',
  s_tech_turnoverrate5 decimal(20,8) comment '5日平均换手率（%）',
  s_tech_turnoverrate10 decimal(20,8) comment '10日平均换手率（%）',
  s_tech_turnoverrate20 decimal(20,8) comment '20日平均换手率（%）',
  s_tech_turnoverrate60 decimal(20,8) comment '60日平均换手率（%）',
  s_tech_turnoverrate120 decimal(20,8) comment '120日平均换手率（%）',
  s_tech_turnoverrate240 decimal(20,8) comment '240日平均换手率（%）',
  s_tech_turnoverratevol20 decimal(20,8) comment '换手率相对波动率',
  s_tech_mktfaciind decimal(20,8) comment '市场促进指数（万元）',
  s_tech_cyf decimal(20,8) comment '市场能量指标',
  s_tech_volumevolatility decimal(20,8) comment '市场交易量波动率',
  s_tech_volume1m60 decimal(20,8) comment '20日60日成交量比',
  s_tech_volumn1m decimal(20,8) comment '量比收益率',
  s_tech_turn5dturn120 decimal(20,8) comment '5日平均换手率与120日平均换手率之比',
  s_tech_turn10dturn120 decimal(20,8) comment '10日平均换手率与120日平均换手率之比',
  s_tech_turn20dturn120 decimal(20,8) comment '20日平均换手率与120日平均换手率之比',
  s_tech_amount1m60 decimal(20,8) comment '成交额惯性',
  s_tech_cry decimal(20,8) comment '市场强弱指标',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
 COMMENT '成交量换手率技术因子'
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



