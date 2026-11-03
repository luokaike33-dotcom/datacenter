table:o3_thisrateexchangereceiptdetail  


新表注释 | 旧表注释  
---------------- | -------------------  
| 利率互换冲销明细历史表  


新表字段 | 旧表字段  
---------------- | -------------------  
|l_serial_no decimal(10) 流水号  
|l_date decimal(8) 日期  
|l_confirm_no decimal(10) 确认序号  
|l_trade_date decimal(8) 确认日期  
|vc_deal_no string 成交编号  
|c_exchange_type string 互换方向  
|l_fund_id decimal(8) 基金序号  
|l_basecombi_id decimal(12) 影响持仓的组合编号  
|vc_inter_code string 证券内码  
|vc_limit_time string 期限  
|en_first_balance decimal(16,2) 首次金额  
|en_now_balance decimal(16,2) 冲销金额  
|en_remain_balance decimal(16,2) 冲销剩余金额  
|en_real_value decimal(16,2) 实际冲销价值  
|en_sys_value decimal(16,2) 系统冲销价值  
|c_status string 状态  
|l_begin_date decimal(8) 开始日期  
|l_end_date decimal(8) 结束日期  
|l_first_begin_date decimal(8) 首期起息日  
|l_daily_instruction_no decimal(10) 指令号  
|l_index_daily_modify decimal(10) 指令修改序  
|l_trade_rival_no decimal(10) 交易对手  
|l_operator_no decimal(8) 操作员代码  
|c_owner_rate_type string 本方利率类型  
|en_owner_rate decimal(9,8) 本方利率  
|vc_owner_pay_period string 本支付周期  
|c_owner_calc_method string 本计息方法  
|c_owner_day_type string 本计息基准  
|vc_owner_rate_period string 本重置频率  
|l_owner_first_rate_date decimal(8) 本首利确日  
|l_owner_first_pay_date decimal(8) 本首支付日  
|c_owner_calc_days_type string 本计息调整  
|c_owner_pay_date_type string 本支付调整  
|c_owner_bail_changeflag string 本方保证品变动标识  
|l_owner_bail_submit_date decimal(8) 本方保证品提交日  
|c_rival_rate_type string 对手方利率类型  
|en_rival_rate decimal(9,8) 对手方利率  
|vc_rival_pay_period string 对支付周期  
|c_rival_calc_method string 对计息方法  
|c_rival_day_type string 对计息基准  
|vc_rival_rate_period string 对重置频率  
|l_rival_first_rate_date decimal(8) 对首利确日  
|l_rival_first_pay_date decimal(8) 对首支付日  
|c_rival_calc_days_type string 对计息调整  
|c_rival_pay_date_type string 对支付调整  
|c_rival_bail_changeflag string 对手方保证品变动标识  
|l_rival_bail_submit_date decimal(8) 对手方保证品提交日  
|vc_frozen_serial_nos string 保证品冻结序号串  
|l_contra_rival_no decimal(10) 冲销对手  
|l_basic_date decimal(8) 基准日期  
|vc_contra_no string 合同编号  
|bath_dt string 日期  
|data_ins_time timestamp 数据来源时间  
|task_rs_id string 任务来源标识  
|p_dt bigint 日分区字段  



新表分区 | 旧表分区  
---------------- | -------------------  
|p_dt


新表索引 | 旧表索引  
---------------- | -------------------  
