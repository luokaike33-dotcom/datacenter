------------------------------------------------------------------------
-- 模块名称：银行间清算流水(离线)
--银行间现券买卖、质押式回购、买断式回购
--银行间债回售到账
--债券借贷首期
--债券借贷到期
--利率互换
--利率互换冲销
------------------------------------------------------------------------
----set hive.vectorized.execution.enabled=false;
----set hive.strict.checks.type.safety=false;
----set hive.exec.dynamic.partition.mode=nonstrict;
----set hive.execution.engine=spark;
----set hive.exec.max.dynamic.partitions.pernode=10000;
----set hive.exec.max.dynamic.partitions=10000;
----set hive.exec.max.created.files=10000;
----set hive.merge.sparkfiles=true;
----set hive.optimize.sort.dynamic.partition=true;
----set hive.merge.orcfile.stripe.level=false;
----set spark.memory.fraction=0.8;
----set hive.exec.dynamic.partition=true;
----set hive.crud.dynamic.partition=true;
----set spark.driver.memory=2G; --内存默认2G,复杂任务不够时可单独设置增加
----set hive.auto.convert.join=true;

ALTER TABLE ${dwd_db}.evt_inbk_clea_jour_his DROP IF EXISTS PARTITION (p_dt>=${beg_date} , p_dt<=${end_date},sys_rs_id = 'O3');

  WITH vhispendsettle AS (
       SELECT l_serial_no,
              l_entrust_serial_no,
              l_trade_date,
              vc_original_no,
              c_entrust_direction,
              vc_deal_no,
              l_relate_no,
              vc_inter_code,
              l_basecombi_id,
              l_settle_date,
              l_busin_flag
         FROM ${ods_db}.o3_thispendsettle
        WHERE c_status = '1'
        UNION ALL
       SELECT l_serial_no,
              l_entrust_serial_no,
              l_trade_date,
              vc_original_no,
              c_entrust_direction,
              vc_deal_no,
              l_relate_no,
              vc_inter_code,
              l_basecombi_id,
              l_settle_date,
              l_busin_flag
         FROM ${ods_db}.o3_tpendsettle
        WHERE c_status = '1'),
       vhishgregister AS (
            SELECT l_date,
                   l_operator_no,
                   l_fund_id,
                   l_redeem_days,
                   l_redeem_lawdate,
                   l_redeem_liquidate,
                   c_market_no,
                   vc_seat_id,
                   vc_stockholder_id,
                   vc_inter_code,
                   c_stock_type,
                   c_entrust_direction,
                   l_deal_amount,
                   en_deal_price,
                   en_deal_balance,
                   en_redeem_interest,
                   l_report_time,
                   en_fee,
                   l_settle_date,
                   l_settle_speed,
                   c_frozen_flag,
                   l_basecombi_id,
                   c_redeal_flag,
                   l_serial_no,
                   l_redeal_date,
                   l_entrust_serial_no,
                   l_hg_date,
                   c_purpose_type,
                   c_redeal_available_flag,
                   en_first_price,
                   en_first_bond_interest,
                   en_mature_price,
                   en_mature_bond_interest,
                   en_interest_payment_balance,
                   l_busin_amount,
                   en_now_interest,
                   vc_contract_no,
                   l_year_days,
                   en_gh_balance,
                   en_extra_pay_interest,
                   en_new_rate,
                   l_new_redeem_date,
                   c_trustee,
                   vc_target_inter_code,
                   vc_target_stockholder_id,
                   vc_target_seat_id,
                   vc_summary,
                   vc_rival_seat,
                   l_rival_id,
                   en_mortgage_balance,
                   vc_rivaltrader_id,
                   l_hg_trade_date,
                   vc_basket_no,
                   c_clear_type,
                   c_status,
                   vc_deal_no
              FROM ${ods_db}.o3_thishgregister
             WHERE NVL(c_status, '1') = '1'
             UNION ALL
            SELECT l_date,
                   l_operator_no,
                   l_fund_id,
                   l_redeem_days,
                   l_redeem_lawdate,
                   l_redeem_liquidate,
                   c_market_no,
                   vc_seat_id,
                   vc_stockholder_id,
                   vc_inter_code,
                   c_stock_type,
                   c_entrust_direction,
                   l_deal_amount,
                   en_deal_price,
                   en_deal_balance,
                   en_redeem_interest,
                   l_report_time,
                   en_fee,
                   l_settle_date,
                   l_settle_speed,
                   c_frozen_flag,
                   l_basecombi_id,
                   c_redeal_flag,
                   l_serial_no,
                   l_redeal_date,
                   l_entrust_serial_no,
                   l_hg_date,
                   c_purpose_type,
                   c_redeal_available_flag,
                   en_first_price,
                   en_first_bond_interest,
                   en_mature_price,
                   en_mature_bond_interest,
                   en_interest_payment_balance,
                   l_busin_amount,
                   en_now_interest,
                   vc_contract_no,
                   l_year_days,
                   en_gh_balance,
                   en_extra_pay_interest,
                   en_new_rate,
                   l_new_redeem_date,
                   c_trustee,
                   vc_target_inter_code,
                   vc_target_stockholder_id,
                   vc_target_seat_id,
                   vc_summary,
                   vc_rival_seat,
                   l_rival_id,
                   en_mortgage_balance,
                   vc_rivaltrader_id,
                   l_hg_trade_date,
                   vc_basket_no,
                   c_clear_type,
                   c_status,
                   vc_deal_no
              FROM ${ods_db}.o3_thgregister
             WHERE NVL(c_status, '1') = '1'),
       vhisrateexchangereceipt AS (
            SELECT l_confirm_no,
                   l_date,
                   l_trade_rival_no,
                   vc_deal_no,
                   l_fund_id,
                   l_basecombi_id,
                   vc_inter_code,
                   en_first_balance,
                   en_fee,
                   l_daily_instruction_no,
                   CASE WHEN c_owner_rate_type = 0 THEN NULL ELSE c_owner_rate_type END AS c_owner_rate_type,
                   CASE WHEN c_rival_rate_type = 0 THEN NULL ELSE c_rival_rate_type END AS c_rival_rate_type,
                   vc_limit_time
              FROM ${ods_db}.o3_thisrateexchangereceipt t
             UNION ALL
            SELECT l_confirm_no,
                   l_date,
                   l_trade_rival_no,
                   vc_deal_no,
                   l_fund_id,
                   l_basecombi_id,
                   vc_inter_code,
                   en_first_balance,
                   en_fee,
                   l_daily_instruction_no,
                   CASE WHEN c_owner_rate_type = 0 THEN NULL ELSE c_owner_rate_type END AS c_owner_rate_type,
                   CASE WHEN c_rival_rate_type = 0 THEN NULL ELSE c_rival_rate_type END AS c_rival_rate_type,
                   vc_limit_time
              FROM ${ods_db}.o3_trateexchangereceipt t),
       vhisrateexchangereceiptdetail AS (
          
            SELECT l_confirm_no, l_date, c_status, l_trade_date
              FROM ${ods_db}.o3_trateexchangereceiptdetail t),
       vthisbankaffiliatesorder AS (
            SELECT vc_counterpty_acc_bank_no,
                   vc_counterpty_acc_bank_name,
                   vc_counterpty_acc_no,
                   vc_counterpty_acc_name,
                   vc_counterpty_bond_acc_no,
                   vc_counterpty_bond_acc_name,
                   en_strike_yld,
                   l_date,
                   vc_deal_no,
                   p_dt,
                   vc_self_party_id
              FROM ${ods_db}.o3_thisbankaffiliatesorder
             UNION ALL
            SELECT vc_counterpty_acc_bank_no,
                   vc_counterpty_acc_bank_name,
                   vc_counterpty_acc_no,
                   vc_counterpty_acc_name,
                   vc_counterpty_bond_acc_no,
                   vc_counterpty_bond_acc_name,
                   en_strike_yld,
                   l_date,
                   vc_deal_no,
                   l_date AS p_dt,
                   vc_self_party_id
              FROM ${ods_db}.o3_tbankaffiliatesorder
             UNION ALL
            SELECT vc_counterpty_acc_bank_no,
                   vc_counterpty_acc_bank_name,
                   vc_counterpty_acc_no,
                   vc_counterpty_acc_name,
                   vc_counterpty_bond_acc_no,
                   vc_counterpty_bond_acc_name,
                   en_strike_yld,
                   l_date,
                   vc_deal_no,
                   p_dt,
                   vc_self_party_id
              FROM ${ods_db}.o3_thisbankselforder
             UNION ALL
            SELECT vc_counterpty_acc_bank_no,
                   vc_counterpty_acc_bank_name,
                   vc_counterpty_acc_no,
                   vc_counterpty_acc_name,
                   vc_counterpty_bond_acc_no,
                   vc_counterpty_bond_acc_name,
                   en_strike_yld,
                   l_date,
                   vc_deal_no,
                   l_date AS p_dt,
                   vc_self_party_id
              FROM ${ods_db}.o3_tbankselforder)
INSERT INTO ${dwd_db}.evt_inbk_clea_jour_his PARTITION (p_dt, sys_rs_id)
(occu_dt, occu_time, busi_sys_id, trd_src_id, tnv_onum, odr_onum, excf_onum, odr_rela_onum, tnv_no, prd_code, ast_unit_code, pfl_code, sh_code, seat_code, secu_id, exch_code, secu_code, src_secu_id, src_secu_trd_id, pos_id, curr_code, busi_typ, inv_typ, busi_clas, entr_dir, clr_typ, clr_sped, tnv_vol, aft_par_vol, tnv_val, occu_val, aft_occu_val, rat, tnv_prc, net_prc, full_prc, end_yld, exer_yld, trd_chag, clea_serv_chag, oth_fee, deli_dt, selfp_id, trd_cntp_id, entr_dir_o3, entr_dir_name_o3, busi_clas_o3, oper_no, tnv_time, cntp_delr_id, cntp_delr_name, sett_fail_flag, stat, memo, buyt_repo_tnv_vol, bond_debc_tnv_vol, repo_use_clas, cntp_bnk_id, cntp_bnk_name, cntp_bnk_acc, cntp_bnk_acc_name, cntp_bond_cstd_acc, cntp_bond_cstd_acc_name, busi_date, task_rs_id, dm_created_time, p_dt, sys_rs_id)
--银行间现券买卖、质押式回购、买断式回购
SELECT t0.l_date AS occu_dt, --发生日期
       t4.l_time AS occu_time, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       CASE
            WHEN t4.l_daily_instruction_no IS NULL THEN
                 CONCAT('0|0|0', t0.l_date, '_HSO32', '_L', t0.l_serial_no)
            ELSE
                 CONCAT('0|', t4.l_date, '_HSO32', '_', t4.l_daily_instruction_no, '_',
                        t4.l_index_daily_modify, '_', t4.l_stock_serial_no, '|0|0')
       END AS trd_src_id, --交易源ID
       CASE
            WHEN t0.l_busin_no IS NULL OR t4.l_serial_no IS NULL THEN
                 CONCAT(t0.l_date, '_HSO32', '_L', t0.l_serial_no) --当天缺失成交信息,直接在流水增加成交流水, 该笔记录用L拼上流水序号作为成交序号
            WHEN t0.l_busin_flag IN ('41203', '41204', '41211', '41212')
                 THEN --41203融资购回,41204融券购回, 41211信用拆出到期, 41212信用拆入到期
                 CONCAT(t0.l_date, '_HSO32', '_', t4.l_serial_no, 'C')
            ELSE
                 CONCAT(t0.l_date, '_HSO32', '_', t4.l_serial_no)
       END AS tnv_onum, --成交序号
       CASE
            WHEN t0.l_busin_no IS NULL THEN
                 NULL --当天缺失成交信息,直接为空
            WHEN t4.l_daily_instruction_no IS NULL THEN
                 NULL --缺少指令序号,直接为空
            ELSE
                 CONCAT(t4.l_date, '_HSO32', '_', t4.l_daily_instruction_no, '_',
                        t4.l_index_daily_modify, '_', t4.l_stock_serial_no) --回购到期流水使用首次交易流水号
       END AS odr_onum, --指令序号
       CASE
            WHEN t0.l_busin_no IS NULL THEN
                 NULL --当天缺失成交信息,直接为空
            WHEN t4.l_exec_confirm_no IS NULL THEN
                 NULL --缺少执行确认序号时,为空
            ELSE
                 CONCAT(t4.l_date, '_HSO32', '_', t4.l_entrust_serial_no)
       END AS excf_onum, --执行确认序号
       CASE
            WHEN t4.l_daily_instruction_no IS NULL THEN
                 NULL
            ELSE
                 CONCAT(t4.l_date, '_HSO32', '_', t4.l_daily_instruction_no, '_', t4.l_basecombi_id, '_',
                        (CASE
                              WHEN t5.c_asset_class = '3'
                                   THEN --3债券
                                   CONCAT(t5.vc_report_code, '.BOND.YHJ')
                              WHEN t5.c_asset_class = '5' AND t5.c_stock_type IN ('8', 'I', 'z')
                                   THEN --5回购,8质押式回购, I买断式回购, z信用拆借
                                   CONCAT(t5.vc_report_code, '.REPO.YHJ')
                         END), '_',
                        (CASE
                              WHEN t4.c_invest_type IN ('1') THEN
                                   '2' --交易型金融资产
                              WHEN t4.c_invest_type IN ('2') THEN
                                   '1' --持有到期资产
                              ELSE
                                   t4.c_invest_type
                         END), '_',
                         (CASE
                               WHEN t0.l_busin_flag IN ('40901') THEN --40901债券买入
                                    '01000200' --银行间现券买入
                               WHEN t0.l_busin_flag IN ('40902') THEN --40902债券卖出
                                    '01000201' --银行间现券卖出
                               WHEN t0.l_busin_flag IN ('41201', '41202') AND t0.c_busin_class = '2'
                                    THEN --41201融券回购,41202融资回购, 2银行间业务
                                    '02000200' --银行间质押式回购首期
                               WHEN t0.l_busin_flag IN ('41203', '41204') AND t0.c_busin_class = '2'
                                    THEN --41203融资购回,41204融券购回, 2银行间业务
                                    '02000200' --银行间质押式回购到期
                               WHEN t0.l_busin_flag IN ('41201', '41202') AND t0.c_busin_class = 'O'
                                    THEN --41201融券回购,41202融资回购, O银行间买断式回购
                                    '03000200' --银行间买断式回购首期
                               WHEN t0.l_busin_flag IN ('41203', '41204') AND t0.c_busin_class = 'O'
                                    THEN --41203融资购回,41204融券购回, O银行间买断式回购
                                    '03000200' --银行间买断式回购到期
                               WHEN t0.l_busin_flag IN ('41209', '41210') THEN --41209信用拆出,41210信用拆入
                                    '24000200' --信用拆借首期
                               WHEN t0.l_busin_flag IN ('41211', '41212') THEN --41211信用拆出到期,41212信用拆入到期
                                    '24000200' --信用拆借到期
                          END))
       END AS odr_rela_onum, --指令关联序号
       TRIM(CASE
                 WHEN t0.l_busin_flag IN ('41203', '41204', '41211', '41212')
                      THEN --41203融资购回,41204融券购回, 41211信用拆出到期, 41212信用拆入到期
                      t4.vc_deal_no --回购到期流水使用首次成交编号
                 ELSE
                      t0.vc_deal_no
            END) AS tnv_no, --成交编号
       t1.vc_fund_code AS prd_code, --产品代码,清洗时需要验证产品代码与估值能否对应上
       CONCAT(t1.vc_fund_code, '_', t2.vc_asset_no) AS ast_unit_code, --资产单元代码
       CONCAT(t1.vc_fund_code, '_', t2.vc_asset_no, '_',
              t3.vc_combi_no) AS pfl_code, --投组代码
       t0.vc_stockholder_id AS sh_code, -- 股东代码
       t0.vc_seat_id AS seat_code, --席位号
       CASE
            WHEN t5.c_asset_class = '3' THEN
                 CONCAT(t5.vc_report_code, '.BOND.YHJ')
            WHEN t5.c_asset_class = '5' AND t5.c_stock_type IN ('I', '8') AND
                 t6.l_serial_no IS NOT NULL THEN
                 CONCAT(t6.l_serial_no, '_', t1.vc_fund_code, '_', t4.l_date, '_',
                        t5.vc_report_code, '.REPO.YHJ') --回购,能找到回购合约信息
            WHEN t5.c_asset_class = '5' AND t5.c_stock_type IN ('I', '8') AND
                 t6.l_serial_no IS NULL THEN
                 CONCAT('L', t0.l_serial_no, '_', t1.vc_fund_code, '_',
                        t0.l_date, '_', t5.vc_report_code, '.REPO.YHJ') --回购,找不到合约信息
            WHEN t5.c_asset_class = '5' AND t5.c_stock_type = 'z' AND
                 t6.l_serial_no IS NOT NULL THEN
                 CONCAT(t6.l_serial_no, '_', t1.vc_fund_code, '_', t4.l_date, '_',
                        t5.vc_report_code, '.IB.YHJ') --信用拆借
            WHEN t5.c_asset_class = '5' AND t5.c_stock_type = 'z' AND
                 t6.l_serial_no IS NULL THEN
                 CONCAT('L', t0.l_serial_no, '_', t1.vc_fund_code, '_',
                        t0.l_date, '_', t5.vc_report_code, '.IB.YHJ') --信用拆借
       END AS secu_id, --证券编码
       CASE
            WHEN t5.c_market_no = '5' THEN
                 'YHJ'
       END AS exch_code, --交易市场代码
       t5.vc_report_code AS secu_code, --证券代码
       t5.vc_inter_code AS src_secu_id, --源证券ID
       t5.vc_inter_code AS src_secu_trd_id, --源证券交易ID
       CASE
            WHEN t0.l_busin_flag IN ('41202', '41203', '41210', '41212') THEN
                 'S'
            ELSE
                 'L'
       END AS pos_id, --多空标志,融资回购为空头
       t0.vc_currency_no AS curr_code, --货币代码
       CASE
            WHEN t0.l_busin_flag IN ('40901', '40902') THEN
                 '010002' --银行间现券买卖
            WHEN t0.l_busin_flag IN ('41201', '41202', '41203', '41204') AND
                 t0.c_busin_class = '2' THEN
                 '020002' --银行间质押式回购
            WHEN t0.l_busin_flag IN ('41201', '41202', '41203', '41204') AND
                 t0.c_busin_class = 'O' THEN
                 '030002' --银行间买断式回购
            WHEN t0.l_busin_flag IN ('41209', '41210', '41211', '41212') THEN
                 '240002' --信用拆借
       END AS busi_typ, --业务类别
       CASE
            WHEN t0.c_invest_type IN ('1') THEN
                 '2' --交易型金融资产
            WHEN t0.c_invest_type IN ('2') THEN
                 '1' --持有到期资产
            ELSE
                 t0.c_invest_type
       END AS inv_typ, --投资类型
       CASE
            WHEN t0.l_busin_flag IN ('40901') THEN
                 '01000200' --银行间现券买入
            WHEN t0.l_busin_flag IN ('40902') THEN
                 '01000201' --银行间现券卖出
            WHEN t0.l_busin_flag IN ('41201', '41202') AND
                 t0.c_busin_class = '2' THEN
                 '02000200' --银行间质押式正回购首期
            WHEN t0.l_busin_flag IN ('41203', '41204') AND
                 t0.c_busin_class = '2' THEN
                 '02000201' --银行间质押式逆回购到期
            WHEN t0.l_busin_flag IN ('41201', '41202') AND
                 t0.c_busin_class = 'O' THEN
                 '03000200' --银行间买断式正回购首期
            WHEN t0.l_busin_flag IN ('41203', '41204') AND
                 t0.c_busin_class = 'O' THEN
                 '03000201' --银行间买断式逆回购到期
            WHEN t0.l_busin_flag IN ('41209', '41210') THEN
                 '24000200' --信用拆借首期
            WHEN t0.l_busin_flag IN ('41211', '41212') THEN
                 '24000201' --信用拆借到期
       END AS busi_clas, --业务类型
       t0.c_entrust_direction AS entr_dir, --委托方向
       '1' AS clr_typ, --清算类型,银行间市场默认全额清算
       t0.l_settle_speed AS clr_sped, --清算速度
       t0.l_busin_amount AS tnv_vol, --成交数量
       t0.l_post_amount AS aft_par_vol, --发生后数量
       (CASE
             WHEN t0.l_busin_flag IN ('41203', '41204') AND
                  t0.c_busin_class = 'O' THEN
                  NVL(t0.en_deal_balance, 0) - NVL(t0.en_subject_balance, 0)
             ELSE
                  t0.en_deal_balance
        END) AS tnv_val, --成交金额
       t0.en_occur_balance AS occu_val, --发生金额
       t0.en_post_balance AS aft_occu_val, --发生后资金金额
       CASE
            WHEN t0.l_busin_flag IN ('41201',
                                     '41202',
                                     '41203',
                                     '41204',
                                     '41209',
                                     '41210',
                                     '41211',
                                     '41212') THEN
                 t0.en_entrust_price / 100
            ELSE
                 NULL
       END AS rat, --回购利率,对于回购利率中, O32的价格存放为利率
       CASE
            WHEN t0.l_busin_flag IN ('41201',
                                     '41202',
                                     '41203',
                                     '41204',
                                     '41209',
                                     '41210',
                                     '41211',
                                     '41212') THEN
                 100
            ELSE
                 t0.en_entrust_price
       END AS tnv_prc, --成交价格,其中所有回购默认100
       t4.en_first_net_price AS net_prc, --净价价格
       t4.en_first_full_price AS full_prc, --全价价格
       t4.en_second_mature_yield AS end_yld, --到期收益率
       NVL(t10.en_strike_yld, 0) AS exer_yld, --行权收益率
       NVL(t0.en_fee_jg, 0) + NVL(t0.en_fare5, 0) AS trd_chag, --交易手续费+经手费
       NVL(t0.en_fee_js2, 0) + NVL(t0.en_fare3, 0) AS clea_serv_chag, --结算服务费+过户费
       NVL(t0.en_fare7, 0) AS oth_fee, --其他费用
       CASE
            WHEN t0.l_busin_flag IN ('40901', '40902') AND
                 t0.l_settle_speed > 0 THEN
                 t8.aft_1_dt
            WHEN t0.l_busin_flag IN ('40901', '40902') AND
                 t0.l_settle_speed = 0 THEN
                 t0.l_date
       END AS deli_dt, --交割日期
       t11.l_rival_id AS selfp_id, --本方编码
       t4.l_trade_rival_no AS trd_cntp_id, --交易对手编码
       t0.c_entrust_direction AS entr_dir_o3, --委托方向_O32
       t7.vc_entrustdir_name AS entr_dir_name_o3, --委托方向名称_O32
       t0.c_busin_class AS busi_clas_o3, --业务分类_O32
       t4.l_operator_no AS oper_no, --操作员
       t4.l_time AS tnv_time, --成交时间
       t4.vc_rivaltrader_id AS cntp_delr_id, --对手方交易员
       t4.vc_rivaltrader_name AS cntp_delr_name, --对手方交易员名称
       t4.c_settle_flag AS sett_fail_flag, --交收失败标识
       CASE WHEN t4.c_cancel_flag = 2 THEN 1 WHEN t4.c_cancel_flag = 0 THEN 1 END AS stat, --状态
       t4.vc_remark AS memo, --备注
       NULL AS buyt_repo_tnv_vol, --买断式回购成交数量
       NULL AS bond_debc_tnv_vol, --债券借贷成交数量
       NULL AS repo_use_clas, --回购用途类别
       t10.vc_counterpty_acc_bank_no AS cntp_bnk_id, --对手方银行编码
       t10.vc_counterpty_acc_bank_name AS cntp_bnk_name, --对手方银行名称
       t10.vc_counterpty_acc_no AS cntp_bnk_acc, --对手方银行账号
       t10.vc_counterpty_acc_name AS cntp_bnk_acc_name, --对手方银行账号名称
       t10.vc_counterpty_bond_acc_no AS cntp_bond_cstd_acc, --对手方债券托管账户
       t10.vc_counterpty_bond_acc_name AS cntp_bond_cstd_acc_name, --对手方债券托管账户名称
       DATE_FORMAT(DATE_ADD(CURRENT_DATE, -1), 'yyyyMMdd') AS busi_date, --业务日期
       'evt_inbk_clea_jour_his_1' AS task_rs_id, --任务来源标识
       CURRENT_TIMESTAMP AS dm_created_time, --数据中台创建时间
       t0.l_date AS p_dt,
       'O3' AS sys_rs_id --系统来源标识
  FROM ${ods_db}.o3_thiscurrents t0 --清算流水主表
       LEFT JOIN ${ods_db}.o3_tfundinfo t1 --产品基本信息表,获取产品代码
              ON t0.l_fund_id = t1.l_fund_id
       LEFT JOIN ${ods_db}.o3_tasset t2 --资产单元基本信息表,获取资产单元代码
              ON t0.l_asset_id = t2.l_asset_id
       LEFT JOIN ${ods_db}.o3_tcombi t3 --投资组合基本信息表,获取投资组合代码
              ON t0.l_basecombi_id = t3.l_combi_id
       LEFT JOIN ${dwd_db}.pub_tradeday_offset_settle t9 --交收日历偏移表
              ON t9.mkt_no = '5'
             AND t0.l_date = t9.dt
             AND t9.sys_rs_id = 'O3'
       LEFT JOIN ${ods_db}.o3_thisbankrealdeal t4 --银行间成交回报表,获取执行确认、指令序号等交易过程数据(到期的回购找到首期那笔回购)
              ON t0.l_busin_no = t4.l_serial_no
             AND t0.l_basecombi_id = t4.l_basecombi_id
             AND t0.vc_inter_code = t4.vc_inter_code
             AND t4.p_dt BETWEEN DATE_FORMAT(
                  DATE_ADD(FROM_UNIXTIME(UNIX_TIMESTAMP(CAST(${beg_date} AS STRING), 'yyyyMMdd'), 'yyyy-MM-dd'), -365),
                  'yyyyMMdd') AND ${end_date}
       LEFT JOIN vthisbankaffiliatesorder t10 --银行间交易关联机构成交表,获取银行间接口数据
              ON t4.l_date = t10.l_date
             AND NVL(t4.vc_original_deal_no, t4.vc_deal_no) = t10.vc_deal_no
       LEFT JOIN ${ods_db}.o3_ttraderival t11
              ON t10.vc_self_party_id = t11.l_bank_id
       LEFT JOIN ${ods_db}.o3_thisstockinfo t5 --证券基本信息表,筛选银行间债券和质押式回购
              ON t0.vc_inter_code = t5.vc_inter_code
             AND t0.l_date = t5.l_date
             AND t5.p_dt BETWEEN ${beg_date} AND ${end_date}
             AND t5.c_market_no = '5' --5是银行间
             AND t5.c_asset_class IN ('3', '5') --3是债券,5是回购
       LEFT JOIN (
       SELECT l_serial_no,
              l_entrust_serial_no,
              l_trade_date,
              vc_original_no,
              c_entrust_direction,
              vc_deal_no,
              l_relate_no,
              l_basecombi_id
         FROM ${ods_db}.o3_thispendsettle
        WHERE c_status = '1'
        UNION ALL
       SELECT l_serial_no,
              l_entrust_serial_no,
              l_trade_date,
              vc_original_no,
              c_entrust_direction,
              vc_deal_no,
              l_relate_no,
              l_basecombi_id
         FROM ${ods_db}.o3_tpendsettle
        WHERE c_status = '1') t6 --待交割表,获取在途回购表中的流水号
              ON t4.l_serial_no = t6.vc_original_no
             AND t4.l_date = t6.l_trade_date
             AND T4.L_BASECOMBI_ID = T6.L_BASECOMBI_ID
       --AND T4.L_ENTRUST_SERIAL_NO = T6.L_ENTRUST_SERIAL_NO
       LEFT JOIN ${ods_db}.o3_tentrustdirection t7 --委托方向表
              ON t0.c_entrust_direction = t7.c_entrust_direction
             AND t5.c_market_no = t7.c_market_no
       LEFT JOIN ${dwd_db}.pub_tradeday_offset_settle t8 --交收日历偏移表
              ON t8.mkt_no = '5' --银行间
             AND t0.l_date = t8.dt
             AND t8.sys_rs_id = 'O3'
 WHERE t0.c_busin_class IN ('O', '2', 'Z') --O银行间买断式回购,2银行间业务, Z信用拆借
   AND t0.l_busin_flag IN ('40901',
                           '40902',
                           '41201',
                           '41202',
                           '41203',
                           '41204',
                           '41209',
                           '41210',
                           '41211',
                           '41212')
   --40901债券买入,40902债券卖出, 41201融券回购, 41202融资回购, 41203融资购回, 41204融券购回, 41209信用拆出, 41210信用拆入, 41211信用拆出到期, 41212信用拆入到期
   AND t0.c_status = '1'
   AND t0.p_dt BETWEEN ${beg_date} AND ${end_date}
   AND (CASE
             WHEN t0.l_busin_flag IN ('41203', '41204', '41211', '41212') THEN
                  t4.l_second_settle_date
             ELSE
                  t4.l_date
        END) BETWEEN t9.pre_1_dt AND t0.l_date

 UNION ALL
--银行间债回售到账
SELECT t0.l_date AS occu_dt, --发生日期
       t4.l_time AS occu_time, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       CASE
            WHEN t4.l_daily_instruction_no IS NOT NULL AND t4.l_daily_instruction_no <> 0 THEN
                 CONCAT('0|', t4.l_date, '_HSO32', '_', t4.l_daily_instruction_no, '|0|0')
            WHEN t4.l_entrust_serial_no IS NOT NULL AND t4.l_entrust_serial_no <> 0 THEN
                 CONCAT('0|0|', t4.l_date, '_HSO32', '_', t4.l_entrust_serial_no, '|0')
            ELSE
                 CONCAT('0|0|0|', t0.l_date, '_HSO32', '_', t4.l_serial_no)
       END AS trd_src_id, --交易源ID
       CONCAT(t0.l_date, '_HSO32', '_', t4.l_serial_no) AS tnv_onum, --成交序号
       NULL AS odr_onum, --指令序号
       CONCAT(t7.l_date, '_HSO32', '_O', t7.l_serial_no) AS excf_onum, --执行确认序号
       CASE
            WHEN t4.l_daily_instruction_no IS NULL OR
                 t4.l_daily_instruction_no = 0 THEN
                 NULL
            ELSE
                 CONCAT(t4.l_date, '_HSO32', '_', t4.l_daily_instruction_no, '_', t0.l_basecombi_id, '_',
                        t5.vc_report_code, '.BOND.YHJ', '_',
                        (CASE
                              WHEN t0.c_invest_type = '1' THEN '2' --可交易
                              WHEN t0.c_invest_type = '2' THEN '1' --持有到期
                              WHEN t0.c_invest_type = 'a' THEN '15' --投机/交易
                              WHEN t0.c_invest_type = 'b' THEN '10' --套保
                              WHEN t0.c_invest_type = 'c' THEN '12' --套利
                              ELSE t0.c_invest_type
                         END), '_',
                        '08000200')
       END AS odr_rela_onum, --指令关联序号
       CASE WHEN t0.vc_deal_no = '0' THEN '' ELSE t4.vc_deal_no END AS tnv_no, --成交编号
       t1.vc_fund_code AS prd_code, --产品代码,清洗时需要验证产品代码与估值能否对应上
       CONCAT(t1.vc_fund_code, '_', t2.vc_asset_no) AS ast_unit_code, --资产单元代码
       CONCAT(t1.vc_fund_code, '_', t2.vc_asset_no, '_', t3.vc_combi_no) AS pfl_code, --投组代码
       t0.vc_stockholder_id AS sh_code, -- 股东代码
       t0.vc_seat_id AS seat_code, --席位号
       CONCAT(t5.vc_report_code, '.BOND.YHJ'), --证券编码
       'YHJ' AS exch_code, --交易市场代码
       t5.vc_report_code AS secu_code, --证券代码
       t5.vc_inter_code AS src_secu_id, --源证券ID
       t5.vc_inter_code AS src_secu_trd_id, --源证券交易ID
       'L' AS pos_id, --多空标志,融资回购为空头
       t0.vc_currency_no AS curr_code, --货币代码
       '080002' AS busi_typ, --业务类别
       CASE
            WHEN t0.c_invest_type = '1' THEN '2' --可交易
            WHEN t0.c_invest_type = '2' THEN '1' --持有到期
            WHEN t0.c_invest_type = 'a' THEN '15' --投机/交易
            WHEN t0.c_invest_type = 'b' THEN '10' --套保
            WHEN t0.c_invest_type = 'c' THEN '12' --套利
            ELSE t0.c_invest_type
       END AS inv_typ, --投资类型
       '08000203' AS busi_clas, --业务类型
       '11' AS entr_dir, --委托方向
       '1' AS clr_typ, --清算类型,银行间市场默认全额清算
       0 AS clr_sped, --清算速度
       t0.l_busin_amount AS tnv_vol, --成交数量
       t0.l_post_amount AS aft_par_vol, --发生后数量
       t0.en_subject_balance AS tnv_val, --成交金额
       t0.en_subject_balance AS occu_val, --发生金额
       t0.en_post_balance AS aft_occu_val, --发生后资金金额
       NULL AS rat, --回购利率,对于回购利率中, O32的价格存放为利率
       t0.en_entrust_price AS tnv_prc, --成交价格
       t4.en_first_net_price AS net_prc, --净价价格
       t4.en_first_full_price AS full_prc, --全价价格
       t4.en_second_mature_yield AS end_yld, --到期收益率
       NVL(t10.en_strike_yld, 0) AS exer_yld, --行权收益率
       NVL(t0.en_fee_jg, 0) AS trd_chag, --交易手续费
       NVL(t0.en_fee_js2, 0) AS clea_serv_chag, --结算服务费
       NVL(t0.en_fare7, 0) AS oth_fee, --其他费用
       t6.l_settle_date AS deli_dt, --交割日期
       t11.l_rival_id AS selfp_id, --本方编码
       t4.l_trade_rival_no AS trd_cntp_id, --交易对手编码
       t0.c_entrust_direction AS entr_dir_o3, --委托方向_O32
       t8.vc_entrustdir_name AS entr_dir_name_o3, --委托方向名称_O32
       t0.c_busin_class AS busi_clas_o3, --业务分类_O32
       t4.l_operator_no AS oper_no, --操作员
       t4.l_time AS tnv_time, --成交时间
       t4.vc_rivaltrader_id AS cntp_delr_id, --对手方交易员代码
       t4.vc_rivaltrader_name AS cntp_delr_name, --对手方交易员名称
       t4.c_settle_flag AS sett_fail_flag, --交收失败标识
       CASE WHEN t4.c_cancel_flag = 2 THEN 1 WHEN t4.c_cancel_flag = 0 THEN 1 END AS stat, --状态
       t4.vc_remark AS memo, --备注
       NULL AS buyt_repo_tnv_vol, --买断式回购成交数量
       NULL AS bond_debc_tnv_vol, --债券借贷成交数量
       NULL AS repo_use_clas, --回购用途类别
       NULL AS cntp_bnk_id, --对手方银行编码
       NULL AS cntp_bnk_name, --对手方银行名称
       NULL AS cntp_bnk_acc, --对手方银行账号
       NULL AS cntp_bnk_acc_name, --对手方银行账号名称
       NULL AS cntp_bond_cstd_acc, --对手方债券托管账户
       NULL AS cntp_bond_cstd_acc_name, --对手方债券托管账户名称
       DATE_FORMAT(DATE_ADD(CURRENT_DATE, -1), 'yyyyMMdd') AS busi_date, --业务日期
       'evt_inbk_clea_jour_his_2' AS task_rs_id, --任务来源标识
       CURRENT_TIMESTAMP AS dm_created_time, --数据中台创建时间
       t0.l_date AS p_dt,
       'O3' AS sys_rs_id --系统来源标识
  FROM ${ods_db}.o3_thiscurrents t0 --清算流水主表
       LEFT JOIN (
       SELECT l_serial_no,
              l_entrust_serial_no,
              l_trade_date,
              vc_original_no,
              c_entrust_direction,
              vc_deal_no,
              l_relate_no,
              l_basecombi_id,
              vc_inter_code,
              l_busin_flag,
              l_settle_date
         FROM ${ods_db}.o3_thispendsettle
        WHERE c_status = '1'
        UNION ALL
       SELECT l_serial_no,
              l_entrust_serial_no,
              l_trade_date,
              vc_original_no,
              c_entrust_direction,
              vc_deal_no,
              l_relate_no,
              l_basecombi_id,
              vc_inter_code,
              l_busin_flag,
              l_settle_date
         FROM ${ods_db}.o3_tpendsettle
        WHERE c_status = '1') t6 --待交割表,获取在途回购表中的流水号
              ON t6.l_settle_date = t0.l_date
             AND t6.l_basecombi_id = t0.l_basecombi_id
             AND t6.vc_inter_code = t0.vc_inter_code
             AND t6.l_busin_flag = t0.l_busin_flag
             AND t6.vc_original_no = t0.l_busin_no
       LEFT JOIN ${ods_db}.o3_thisbankrealdeal t4 --银行间成交表
              ON t6.vc_original_no = t4.l_serial_no
             AND t6.l_trade_date = t4.l_date
       LEFT JOIN ${ods_db}.o3_thisbankaffiliatesorder t10 --获取银行间接口数据
              ON t4.l_date = t10.l_date
             AND t4.vc_deal_no = t10.vc_deal_no
             AND t10.p_dt BETWEEN ${beg_date} AND ${end_date}
       LEFT JOIN ${ods_db}.o3_ttraderival t11 --交易对手表
              ON t10.vc_self_party_id = t11.l_bank_id
       LEFT JOIN ${ods_db}.o3_tfundinfo t1 --产品基本信息表,获取产品代码
              ON t0.l_fund_id = t1.l_fund_id
       LEFT JOIN ${ods_db}.o3_tasset t2 --资产单元基本信息表,获取资产单元代码
              ON t0.l_asset_id = t2.l_asset_id
       LEFT JOIN ${ods_db}.o3_tcombi t3 --投资组合基本信息表,获取投资组合代码
              ON t0.l_basecombi_id = t3.l_combi_id
       LEFT JOIN ${ods_db}.o3_thisbankconfirm t7 --银行间执行确认表
              ON t4.l_exec_confirm_no = t7.l_serial_no
             AND t4.l_basecombi_id = t7.l_basecombi_id
             AND t4.vc_inter_code = t7.vc_inter_code
       LEFT JOIN ${ods_db}.o3_thisstockinfo t5 --证券基本信息表
              ON t0.l_date = t5.l_date
             AND t0.vc_inter_code = t5.vc_inter_code
             AND t5.c_asset_class IN ('3', '5') --3是债券,5是回购f
             AND t5.c_market_no = '5' --5是银行间
             AND t5.p_dt BETWEEN ${beg_date} AND ${end_date}
       LEFT JOIN ${ods_db}.o3_tentrustdirection t8 --委托方向表
              ON t0.c_entrust_direction = t8.c_entrust_direction
             AND t5.c_market_no = t8.c_market_no
 WHERE t0.c_busin_class = '2' --2银行间业务
   AND t0.l_busin_flag IN ('72571') --72571银行间债回售成交确认
   AND t0.c_status IN ('1') --1-正常,2-回溯, 3-被回溯；2和3为冲减不需080
   AND t0.en_subject_balance > 0
   AND T0.L_SUBJECT_NO NOT IN ('113')
   AND t0.p_dt BETWEEN ${beg_date} AND ${end_date}

 UNION ALL
--债券借贷首期
SELECT t0.l_date AS occu_dt, --发生日期
       t4.l_time AS occu_time, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       CASE
            WHEN t4.l_daily_instruction_no IS NULL THEN
                 CONCAT('0|0|0|', t0.l_date, '_HSO32', '_L', t0.l_serial_no)
            ELSE
                 CONCAT('0|', t4.l_date, '_HSO32', '_', t4.l_daily_instruction_no, '_', t4.l_index_daily_modify, '_',
                        t4.l_stock_serial_no, '|0|0')
       END AS trd_src_id, --交易源ID
       CASE
            WHEN t0.l_busin_no IS NULL THEN
                 CONCAT(t0.l_date, '_HSO32', '_L', t0.l_serial_no) --当天缺失成交信息,直接在流水增加成交流水,该笔记录用L拼上流水序号作为成交序号
            WHEN t4.l_serial_no IS NULL THEN
                 CONCAT(t0.l_date, '_HSO32', '_L', t0.l_serial_no)
            ELSE
                 CONCAT(t0.l_date, '_HSO32', '_', t4.l_serial_no)
       END AS tnv_onum, --成交序号
       NULL AS odr_onum, --指令序号
       CASE
            WHEN t0.l_busin_no IS NULL THEN
                 NULL --当天缺失成交信息,直接为空
            WHEN t4.l_exec_confirm_no IS NULL THEN
                 NULL --缺少执行确认序号时,为空
            ELSE
                 CONCAT(t4.l_date, '_HSO32', '_', t4.l_entrust_serial_no)
       END AS excf_onum, --执行确认序号
       CASE
            WHEN t4.l_daily_instruction_no IS NULL THEN
                 NULL
            ELSE
                 CONCAT(t4.l_date, '_HSO32', '_', t4.l_daily_instruction_no, '_', t4.l_basecombi_id, '_',
                        t5.vc_report_code, '.LB.YHJ', '_',
                        (CASE
                              WHEN t4.c_invest_type IN ('1') THEN
                                   '2' --交易型金融资产
                              WHEN t4.c_invest_type IN ('2') THEN
                                   '1' --持有到期资产
                              ELSE
                                   t4.c_invest_type
                         END), '_', '33000200')
       END AS odr_rela_onum, --指令关联序号
       CASE WHEN t0.vc_deal_no = '0' THEN '' ELSE t4.vc_deal_no END AS tnv_no, --成交编号
       t1.vc_fund_code AS prd_code, --产品代码,清洗时需要验证产品代码与估值能否对应上
       CONCAT(t1.vc_fund_code, '_', t2.vc_asset_no) AS ast_unit_code, --资产单元代码
       CONCAT(t1.vc_fund_code, '_', t2.vc_asset_no, '_', t3.vc_combi_no) AS pfl_code, --投组代码
       t0.vc_stockholder_id AS sh_code, -- 股东代码
       t0.vc_seat_id AS seat_code, --席位号
       CASE
            WHEN t6.l_serial_no IS NOT NULL THEN
                 CONCAT(t6.l_serial_no, '_', t1.vc_fund_code, '_', t4.l_date, '_', t5.vc_report_code, '.LB.YHJ') --债券借贷
            WHEN t6.l_serial_no IS NULL THEN
                 CONCAT('L', t0.l_serial_no, '_', t1.vc_fund_code, '_', t0.l_date, '_', t5.vc_report_code, '.LB.YHJ')
       END AS secu_id, --证券编码
       'YHJ' AS exch_code, --交易市场代码
       t5.vc_report_code AS secu_code, --证券代码
       t5.vc_inter_code AS src_secu_id, --源证券ID
       t5.vc_inter_code AS src_secu_trd_id, --源证券交易ID
       CASE
            WHEN t0.c_entrust_direction IN ('?') THEN
                 '1'
            WHEN t0.c_entrust_direction IN ('-') THEN
                 '2'
       END AS pos_id, --多空标志,融资回购为空头
       t0.vc_currency_no AS curr_code, --货币代码
       '330002' AS busi_typ, --业务类别
       CASE
            WHEN t0.c_invest_type IN ('1') THEN
                 '2' --交易型金融资产
            WHEN t0.c_invest_type IN ('2') THEN
                 '1' --持有到期资产
            ELSE
                 t0.c_invest_type
       END AS inv_typ, --投资类型
       '33000200' AS busi_clas, --业务类型
       CASE
            WHEN t0.c_entrust_direction IN ('?') THEN
                 '151'
            WHEN t0.c_entrust_direction IN ('-') THEN
                 '152'
            WHEN t0.c_entrust_direction IN ('*') THEN
                 '170'
            WHEN t0.c_entrust_direction IN ('+') THEN
                 '171'
       END AS entr_dir, --委托方向
       '1' AS clr_typ, --清算类型,银行间市场默认全额清算
       t0.l_settle_speed AS clr_sped, --清算速度
       t0.l_busin_amount AS tnv_vol, --成交数量
       t0.l_post_amount AS aft_par_vol, --成交数量
       0 AS tnv_val, --成交金额
       0 AS occu_val, --发生金额
       t0.en_post_balance AS aft_occu_val, --发生后资金金额
       t0.en_entrust_price / 100 AS rat, --回购利率,对于回购利率中,O32的价格存放为利率
       100 AS tnv_prc, --成交价格,其中所有回购默认100
       t4.en_first_net_price AS net_prc, --净价价格
       t4.en_first_full_price AS full_prc, --全价价格
       t4.en_second_mature_yield AS end_yld, --到期收益率
       NVL(t10.en_strike_yld, 0) AS exer_yld, --行权收益率
       NVL(t0.en_fee_jg, 0) + NVL(t0.en_fare5, 0) AS trd_chag, --交易手续费+经手费
       NVL(t0.en_fee_js2, 0) + NVL(t0.en_fare3, 0) AS clea_serv_chag, --结算服务费+过户费
       NVL(t0.en_fare7, 0) AS oth_fee, --其他费用
       t6.l_settle_date AS deli_dt, --交割日期
       t11.l_rival_id AS selfp_id, --本方编码
       t4.l_trade_rival_no AS trd_cntp_id, --交易对手编码
       t0.c_entrust_direction AS entr_dir_o3, --委托方向_O32
       t8.vc_entrustdir_name AS entr_dir_name_o3, --委托方向名称_O32
       t0.c_busin_class AS busi_clas_o3, --业务分类_O32
       t4.l_operator_no AS oper_no, --操作员
       t4.l_time AS tnv_time, --成交时间
       t4.vc_rivaltrader_id AS cntp_delr_id, --对手方交易员
       t4.vc_rivaltrader_name AS cntp_delr_name, --对手方交易员名称
       t4.c_settle_flag AS sett_fail_flag, --交收失败标识
       CASE WHEN t4.c_cancel_flag = 1 THEN 2 WHEN t4.c_cancel_flag = 0 THEN 1 END AS stat, --状态
       t4.vc_remark AS memo, --备注
       NULL AS buyt_repo_tnv_vol, --买断式回购成交数量
       NULL AS bond_debc_tnv_vol, --债券借贷成交数量
       NULL AS repo_use_clas, --回购用途类别
       NULL AS cntp_bnk_id, --对手方银行编码
       NULL AS cntp_bnk_name, --对手方银行名称
       NULL AS cntp_bnk_acc, --对手方银行账号
       NULL AS cntp_bnk_acc_name, --对手方银行账号名称
       NULL AS cntp_bond_cstd_acc, --对手方债券托管账户
       NULL AS cntp_bond_cstd_acc_name, --对手方债券托管账户名称
       DATE_FORMAT(DATE_ADD(CURRENT_DATE, -1), 'yyyyMMdd') AS busi_date, --业务日期
       'evt_inbk_clea_jour_his_3' AS task_rs_id, --任务来源标识
       CURRENT_TIMESTAMP AS dm_created_time, --数据中台创建时间
       t0.l_date AS p_dt,
       'O3' AS sys_rs_id --系统来源标识
  FROM ${ods_db}.o3_thiscurrents t0 --清算流水主表
       LEFT JOIN vhispendsettle t6 --代交割表,当前表和历史表合集
              ON t0.l_busin_no = t6.vc_original_no
             AND t0.l_date = t6.l_trade_date
             AND t6.c_entrust_direction IN ('?', '-') --?债券融入,-债券融出
       LEFT JOIN ${ods_db}.o3_tfundinfo t1 --产品基本信息表,获取产品代码
              ON t0.l_fund_id = t1.l_fund_id
       LEFT JOIN ${ods_db}.o3_tasset t2 --资产单元基本信息表,获取资产单元代码
              ON t0.l_asset_id = t2.l_asset_id
       LEFT JOIN ${ods_db}.o3_tcombi t3 --投资组合基本信息表,获取投资组合代码
              ON t0.l_basecombi_id = t3.l_combi_id
       LEFT JOIN ${ods_db}.o3_thisbankrealdeal t4 --银行间成交回报表,获取执行确认、指令序号等交易过程数据(到期的回购找到首期那笔回购)
              ON t0.l_busin_no = t4.l_serial_no
             AND t0.l_date = t4.l_date
             AND t4.p_dt BETWEEN ${beg_date} AND ${end_date}
       LEFT JOIN ${ods_db}.o3_thisbankaffiliatesorder t10 --银行间交易关联机构成交表,获取银行间接口数据
              ON t4.l_date = t10.l_date
             AND t4.vc_deal_no = t10.vc_deal_no
             AND t10.p_dt BETWEEN ${beg_date} AND ${end_date}
       LEFT JOIN ${ods_db}.o3_ttraderival t11
              ON t10.vc_self_party_id = t11.l_bank_id
       LEFT JOIN ${ods_db}.o3_thisstockinfo t5 --证券基本信息表,筛选银行间债券和质押式回购
              ON t0.vc_inter_code = t5.vc_inter_code
             AND t0.l_date = t5.l_date
             AND t5.c_market_no = '5' --5是银行间
             AND t5.p_dt BETWEEN ${beg_date} AND ${end_date}
       LEFT JOIN vhishgregister t7 --回购表,当前表和历史表合集
              ON t6.l_serial_no = t7.l_serial_no
             AND t0.l_date = t7.l_hg_date
             AND t7.c_entrust_direction IN ('?', '-') --?债券融入,-债券融出
       LEFT JOIN ${ods_db}.o3_tentrustdirection t8 --委托方向表
              ON t0.c_entrust_direction = t8.c_entrust_direction
             AND t5.c_market_no = t8.c_market_no
 WHERE t0.c_busin_class IN ('2') --2银行间业务
   AND t0.l_busin_flag IN ('73003', '73005') --73003银行间债券融出,73005银行间债券融入
   AND t0.c_status = '1'
   AND t0.p_dt BETWEEN ${beg_date} AND ${end_date}

 UNION ALL
--债券借贷到期
SELECT t0.l_date AS occu_dt, --发生日期
       t4.l_time AS occu_time, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       CASE
            WHEN t4.l_daily_instruction_no IS NULL THEN
                 CONCAT('0|0|0|', t0.l_date, '_HSO32', '_L', t0.l_serial_no)
            ELSE
                 CONCAT('0|', t4.l_date, '_HSO32', '_', t4.l_daily_instruction_no, '_', t4.l_index_daily_modify, '_',
                        t4.l_stock_serial_no, '|0|0')
       END AS trd_src_id, --交易源ID
       CASE
            WHEN t0.l_busin_no IS NULL THEN
                 CONCAT(t0.l_date, '_HSO32', '_L', t0.l_serial_no) --当天缺失成交信息,直接在流水增加成交流水,该笔记录用L拼上流水序号作为成交序号
            WHEN t4.l_serial_no IS NULL THEN
                 CONCAT(t0.l_date, '_HSO32', '_L', t0.l_serial_no)
            ELSE
                 CONCAT(t0.l_date, '_HSO32', '_', t4.l_serial_no)
       END AS tnv_onum, --成交序号
       NULL AS odr_onum, --指令序号
       CASE
            WHEN t0.l_busin_no IS NULL THEN
                 NULL --当天缺失成交信息,直接为空
            WHEN t4.l_exec_confirm_no IS NULL THEN
                 NULL --缺少执行确认序号时,为空
            ELSE
                 CONCAT(t4.l_date, '_HSO32', '_', t4.l_entrust_serial_no)
       END AS excf_onum, --执行确认序号
       CASE
            WHEN t4.l_daily_instruction_no IS NULL THEN
                 NULL
            ELSE
                 CONCAT(t4.l_date, '_HSO32', '_', t4.l_daily_instruction_no, '_', t4.l_basecombi_id, '_',
                        t5.vc_report_code, '.LB.YHJ', '_',
                        (CASE
                              WHEN t4.c_invest_type IN ('1') THEN
                                   '2' --交易型金融资产
                              WHEN t4.c_invest_type IN ('2') THEN
                                   '1' --持有到期资产
                              ELSE
                                   t4.c_invest_type
                         END), '_', '33000200')
       END AS odr_rela_onum, --指令关联序号
       CASE WHEN t0.vc_deal_no = '0' THEN '' ELSE t4.vc_deal_no END AS tnv_no, --成交编号
       t1.vc_fund_code AS prd_code, --产品代码,清洗时需要验证产品代码与估值能否对应上
       CONCAT(t1.vc_fund_code, '_', t2.vc_asset_no) AS ast_unit_code, --资产单元代码
       CONCAT(t1.vc_fund_code, '_', t2.vc_asset_no, '_', t3.vc_combi_no) AS pfl_code, --投组代码
       t0.vc_stockholder_id AS sh_code, -- 股东代码
       t0.vc_seat_id AS seat_code, --席位号
       CASE
            WHEN t7.l_serial_no IS NOT NULL THEN
                 CONCAT(t7.l_serial_no, '_', t1.vc_fund_code, '_', t4.l_date, '_', t5.vc_report_code, '.LB.YHJ') --债券借贷
            WHEN t7.l_serial_no IS NULL THEN
                 CONCAT('L', t0.l_serial_no, '_', t1.vc_fund_code, '_', t0.l_date, '_', t5.vc_report_code, '.LB.YHJ')
       END AS secu_id, --证券编码
       'YHJ' AS exch_code, --交易市场代码
       t5.vc_report_code AS secu_code, --证券代码
       t5.vc_inter_code AS src_secu_id, --源证券ID
       t5.vc_inter_code AS src_secu_trd_id, --源证券交易ID
       CASE
            WHEN t0.c_entrust_direction IN ('*') THEN --*债券融入到期
                 '1'
            WHEN t0.c_entrust_direction IN ('+') THEN --+债券融出到期
                 '2'
       END AS pos_id, --多空标志,融资回购为空头
       t0.vc_currency_no AS curr_code, --货币代码
       '330002' AS busi_typ, --业务类别
       CASE
            WHEN t0.c_invest_type IN ('1') THEN
                 '2' --交易型金融资产
            WHEN t0.c_invest_type IN ('2') THEN
                 '1' --持有到期资产
            ELSE
                 t0.c_invest_type
       END AS inv_typ, --投资类型
       '33000201' AS busi_clas, --业务类型
       CASE
            WHEN t0.c_entrust_direction IN ('*') THEN --*债券融入到期
                 '170'
            WHEN t0.c_entrust_direction IN ('+') THEN --+债券融出到期
                 '171'
       END AS entr_dir, --委托方向
       '1' AS clr_typ, --清算类型,银行间市场默认全额清算
       t0.l_settle_speed AS clr_sped, --清算速度
       t0.l_busin_amount AS tnv_vol, --成交数量
       t0.l_post_amount AS aft_par_vol, --成交数量
       t0.en_deal_balance AS tnv_val, --成交金额
       t0.en_occur_balance AS occu_val, --发生金额
       t0.en_post_balance AS aft_occu_val, --发生后资金金额
       t0.en_entrust_price / 100 AS rat, --回购利率,对于回购利率中,O32的价格存放为利率
       100 AS tnv_prc, --成交价格,其中所有回购默认100
       t4.en_first_net_price AS net_prc, --净价价格
       t4.en_first_full_price AS full_prc, --全价价格
       t4.en_second_mature_yield AS end_yld, --到期收益率
       NVL(t10.en_strike_yld, 0) AS exer_yld, --行权收益率
       NVL(t0.en_fee_jg, 0) + NVL(t0.en_fare5, 0) AS trd_chag, --交易手续费+经手费
       NVL(t0.en_fee_js2, 0) + NVL(t0.en_fare3, 0) AS clea_serv_chag, --结算服务费+过户费
       NVL(t0.en_fare7, 0) AS oth_fee, --其他费用
       t6.l_settle_date AS deli_dt, --交割日期
       t11.l_rival_id AS selfp_id, --本方编码
       t4.l_trade_rival_no AS trd_cntp_id, --交易对手编码
       t0.c_entrust_direction AS entr_dir_o3, --委托方向_O32
       t8.vc_entrustdir_name AS entr_dir_name_o3, --委托方向名称_O32
       t0.c_busin_class AS busi_clas_o3, --业务分类_O32
       t4.l_operator_no AS oper_no, --操作员
       t4.l_time AS tnv_time, --成交时间
       t4.vc_rivaltrader_id AS cntp_delr_id, --对手方交易员
       t4.vc_rivaltrader_name AS cntp_delr_name, --对手方交易员名称
       t4.c_settle_flag AS sett_fail_flag, --交收失败标识
       CASE WHEN t4.c_cancel_flag = 1 THEN 2 WHEN t4.c_cancel_flag = 0 THEN 1 END AS stat, --状态
       t4.vc_remark AS memo, --备注
       NULL AS buyt_repo_tnv_vol, --买断式回购成交数量
       NULL AS bond_debc_tnv_vol, --债券借贷成交数量
       NULL AS repo_use_clas, --回购用途类别
       NULL AS cntp_bnk_id, --对手方银行编码
       NULL AS cntp_bnk_name, --对手方银行名称
       NULL AS cntp_bnk_acc, --对手方银行账号
       NULL AS cntp_bnk_acc_name, --对手方银行账号名称
       NULL AS cntp_bond_cstd_acc, --对手方债券托管账户
       NULL AS cntp_bond_cstd_acc_name, --对手方债券托管账户名称
       DATE_FORMAT(DATE_ADD(CURRENT_DATE, -1), 'yyyyMMdd') AS busi_date, --业务日期
       'evt_inbk_clea_jour_his_4' AS task_rs_id, --任务来源标识
       CURRENT_TIMESTAMP AS dm_created_time, --数据中台创建时间
       t0.l_date AS p_dt,
       'O3' AS sys_rs_id --系统来源标识
  FROM ${ods_db}.o3_thiscurrents t0 --清算流水主表
       LEFT JOIN vhispendsettle t6 --代交割表,当前表和历史表合集
              ON t0.l_busin_no = t6.vc_original_no
             AND t0.l_date = t6.l_trade_date
             AND t6.c_entrust_direction IN ('*', '+') --*债券融入到期,+债券融出到期
       LEFT JOIN ${ods_db}.o3_tfundinfo t1 --产品基本信息表,获取产品代码
              ON t0.l_fund_id = t1.l_fund_id
       LEFT JOIN ${ods_db}.o3_tasset t2 --资产单元基本信息表,获取资产单元代码
              ON t0.l_asset_id = t2.l_asset_id
       LEFT JOIN ${ods_db}.o3_tcombi t3 --投资组合基本信息表,获取投资组合代码
              ON t0.l_basecombi_id = t3.l_combi_id
       LEFT JOIN ${ods_db}.o3_thisstockinfo t5 --证券基本信息表,筛选银行间债券和质押式回购
              ON t0.vc_inter_code = t5.vc_inter_code
             AND t0.l_date = t5.l_date
             AND t5.c_market_no = '5' --5是银行间
             AND t5.p_dt BETWEEN ${beg_date} AND ${end_date}
       LEFT JOIN (
       SELECT t4.*
         FROM ${ods_db}.o3_thiscurrents t0 --清算流水主表
              INNER JOIN ${ods_db}.o3_thisbankrealdeal t4 --银行间成交回报表,获取执行确认、指令序号等交易过程数据(到期的回购找到首期那笔回购)
                      ON t0.l_busin_no = t4.l_serial_no
                     AND t0.l_basecombi_id = t4.l_basecombi_id
                     AND t0.vc_inter_code = t4.vc_inter_code
                     AND t4.c_entrust_direction IN ('?', '-') --?债券融入,-债券融出
               LEFT JOIN ${dwd_db}.pub_tradeday_offset_settle w1 --交收日历偏移表
                      ON w1.mkt_no = '5'
                     AND t0.l_date = w1.dt
                     AND w1.sys_rs_id = 'O3'
        WHERE t0.c_busin_class IN ('2') --2银行间业务
          AND t0.l_busin_flag IN ('73007', '73009') --73007银行间债券融出到期,73009银行间债券融入到期
          AND t0.c_status = '1'
          AND t0.p_dt BETWEEN ${beg_date} AND ${end_date}
          AND CASE WHEN t0.l_settle_speed = 0 THEN t0.l_date ELSE w1.aft_1_dt END = t4.l_second_settle_date) t4
              ON t0.l_busin_no = t4.l_serial_no
             AND t0.l_basecombi_id = t4.l_basecombi_id
             AND t0.vc_inter_code = t4.vc_inter_code
             AND t4.c_entrust_direction IN ('?', '-')
       LEFT JOIN ${ods_db}.o3_thisbankaffiliatesorder t10 --获取银行间接口数据
              ON t4.l_date = t10.l_date
             AND t4.vc_deal_no = t10.vc_deal_no
             AND t10.p_dt BETWEEN ${beg_date} AND ${end_date}
       LEFT JOIN ${ods_db}.o3_ttraderival t11 --交易对手表
              ON t10.vc_self_party_id = t11.l_bank_id
       LEFT JOIN vhishgregister t7 --回购表,当前表和历史表合集
              ON TRIM(t0.vc_deal_no) = TRIM(t7.vc_deal_no)
             AND t4.l_date = t7.l_hg_date
             AND t0.l_basecombi_id = t7.l_basecombi_id
             AND t0.vc_inter_code = t7.vc_inter_code
             AND t7.c_market_no = '5'
       LEFT JOIN ${ods_db}.o3_tentrustdirection t8 --委托方向表
              ON t0.c_entrust_direction = t8.c_entrust_direction
             AND t5.c_market_no = t8.c_market_no
 WHERE t0.c_busin_class IN ('2') --2银行间业务
   AND t0.l_busin_flag IN ('73007', '73009') --债券借贷融入到期、融出到期
   AND t0.c_status = '1'
   AND t0.p_dt BETWEEN ${beg_date} AND ${end_date}

 UNION ALL
--清算：利率互换
SELECT t0.l_date AS occu_dt, --发生日期
       NULL AS occu_time, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       CASE
            WHEN t0.l_daily_instruction_no IS NOT NULL AND t0.l_daily_instruction_no <> 0 THEN
                 CONCAT('0|', t0.l_date, '_HSO32', '_', t0.l_daily_instruction_no, '|0|0')
            ELSE
                 CONCAT('0|0|0|', t0.l_date, '_HSO32', '_EX', t0.l_confirm_no)
       END AS trd_src_id, --交易源ID
       CONCAT(t0.l_date, '_HSO32', '_EX', t0.l_confirm_no) AS tnv_onum, --成交序号
       NULL AS odr_onum, --指令序号
       NULL AS excf_onum, --执行确认序号
       CASE
            WHEN t0.l_daily_instruction_no IS NULL OR t0.l_daily_instruction_no = 0 THEN
                 NULL
            ELSE
                 CONCAT(t0.l_date, '_HSO32', '_', t0.l_daily_instruction_no, '_',
                        t0.l_basecombi_id, '_',
                        (CASE
                              WHEN NVL(t0.c_owner_rate_type, t0.c_rival_rate_type) = '1' THEN 'FR007.IR.OTH'
                              WHEN NVL(t0.c_owner_rate_type, t0.c_rival_rate_type) = '2' THEN 'SHIBOR1W.IR.OTH'
                              WHEN NVL(t0.c_owner_rate_type, t0.c_rival_rate_type) = '3' THEN 'SHIBOR3M.IR.OTH'
                              WHEN NVL(t0.c_owner_rate_type, t0.c_rival_rate_type) = '4' THEN 'SHIBOR1D.IR.OTH'
                              WHEN NVL(t0.c_owner_rate_type, t0.c_rival_rate_type) = '5' THEN 'DEPO1Y.IR.OTH'
                              WHEN NVL(t0.c_owner_rate_type, t0.c_rival_rate_type) = '6' THEN 'LOAN1Y.IR.OTH'
                              WHEN NVL(t0.c_owner_rate_type, t0.c_rival_rate_type) = '7' THEN 'LOAN3-5Y.IR.OTH'
                              WHEN NVL(t0.c_owner_rate_type, t0.c_rival_rate_type) = '8' THEN 'FDR001.IR.OTH'
                              WHEN NVL(t0.c_owner_rate_type, t0.c_rival_rate_type) = '9' THEN 'FDR007.IR.OTH'
                              WHEN NVL(t0.c_owner_rate_type, t0.c_rival_rate_type) = 'a' THEN 'SHIBOR1M.IR.OTH'
                              WHEN NVL(t0.c_owner_rate_type, t0.c_rival_rate_type) = 'b' THEN 'FR001.IR.OTH'
                         END), '_', t0.vc_limit_time, '.EX.YHJ', '_',
                        '2', '_', '47000200')
       END AS odr_rela_onum, --指令关联序号
       t0.vc_deal_no AS tnv_no, --成交编号
       t1.vc_fund_code AS prd_code, --产品代码
       CONCAT(t1.vc_fund_code, '_', t2.vc_asset_no) AS ast_unit_code, --资产单元代码
       CONCAT(t1.vc_fund_code, '_', t2.vc_asset_no, '_', t3.vc_combi_no) AS pfl_code, --投组代码
       NULL AS sh_code, -- 股东代码
       NULL AS seat_code, --席位号
       CONCAT(t0.l_date, '_', t0.vc_deal_no, '_',
              (CASE
                    WHEN NVL(t0.c_owner_rate_type, t0.c_rival_rate_type) = '1' THEN 'FR007.IR.OTH'
                    WHEN NVL(t0.c_owner_rate_type, t0.c_rival_rate_type) = '2' THEN 'SHIBOR1W.IR.OTH'
                    WHEN NVL(t0.c_owner_rate_type, t0.c_rival_rate_type) = '3' THEN 'SHIBOR3M.IR.OTH'
                    WHEN NVL(t0.c_owner_rate_type, t0.c_rival_rate_type) = '4' THEN 'SHIBOR1D.IR.OTH'
                    WHEN NVL(t0.c_owner_rate_type, t0.c_rival_rate_type) = '5' THEN 'DEPO1Y.IR.OTH'
                    WHEN NVL(t0.c_owner_rate_type, t0.c_rival_rate_type) = '6' THEN 'LOAN1Y.IR.OTH'
                    WHEN NVL(t0.c_owner_rate_type, t0.c_rival_rate_type) = '7' THEN 'LOAN3-5Y.IR.OTH'
                    WHEN NVL(t0.c_owner_rate_type, t0.c_rival_rate_type) = '8' THEN 'FDR001.IR.OTH'
                    WHEN NVL(t0.c_owner_rate_type, t0.c_rival_rate_type) = '9' THEN 'FDR007.IR.OTH'
                    WHEN NVL(t0.c_owner_rate_type, t0.c_rival_rate_type) = 'a' THEN 'SHIBOR1M.IR.OTH'
                    WHEN NVL(t0.c_owner_rate_type, t0.c_rival_rate_type) = 'b' THEN 'FR001.IR.OTH'
               END), '_', t0.vc_limit_time, '.EX.YHJ') AS secu_id, --证券编码
       'YHJ' AS exch_code, --交易市场代码
       CONCAT((CASE
                    WHEN NVL(t0.c_owner_rate_type, t0.c_rival_rate_type) = '1' THEN 'FR007.IR.OTH'
                    WHEN NVL(t0.c_owner_rate_type, t0.c_rival_rate_type) = '2' THEN 'SHIBOR1W.IR.OTH'
                    WHEN NVL(t0.c_owner_rate_type, t0.c_rival_rate_type) = '3' THEN 'SHIBOR3M.IR.OTH'
                    WHEN NVL(t0.c_owner_rate_type, t0.c_rival_rate_type) = '4' THEN 'SHIBOR1D.IR.OTH'
                    WHEN NVL(t0.c_owner_rate_type, t0.c_rival_rate_type) = '5' THEN 'DEPO1Y.IR.OTH'
                    WHEN NVL(t0.c_owner_rate_type, t0.c_rival_rate_type) = '6' THEN 'LOAN1Y.IR.OTH'
                    WHEN NVL(t0.c_owner_rate_type, t0.c_rival_rate_type) = '7' THEN 'LOAN3-5Y.IR.OTH'
                    WHEN NVL(t0.c_owner_rate_type, t0.c_rival_rate_type) = '8' THEN 'FDR001.IR.OTH'
                    WHEN NVL(t0.c_owner_rate_type, t0.c_rival_rate_type) = '9' THEN 'FDR007.IR.OTH'
                    WHEN NVL(t0.c_owner_rate_type, t0.c_rival_rate_type) = 'a' THEN 'SHIBOR1M.IR.OTH'
                    WHEN NVL(t0.c_owner_rate_type, t0.c_rival_rate_type) = 'b' THEN 'FR001.IR.OTH'
               END), '_', t0.vc_limit_time) AS secu_code, --证券代码
       t5.vc_inter_code AS src_secu_id, --源证券ID
       t5.vc_inter_code AS src_secu_trd_id, --源证券交易ID
       'L' AS pos_id, --多空标志,融资回购为空头
       'CNY' AS curr_code, --货币代码
       '470002' AS busi_typ, --业务类别
       '2' AS inv_typ, --投资类型
       '47000200' AS busi_clas, --业务类型
       '48' AS entr_dir, --委托方向
       '1' AS clr_typ, --清算类型,银行间市场默认全额清算
       0 AS clr_sped, --清算速度
       0 AS tnv_vol, --成交数量
       0 AS aft_par_vol, --发生后数量
       t0.en_first_balance AS tnv_val, --成交金额
       t0.en_fee AS occu_val, --发生金额
       0 AS aft_occu_val, --发生后资金金额
       NULL AS rat, --回购利率,对于回购利率中,O32的价格存放为利率
       0 AS tnv_prc, --成交价格,其中所有回购默认100
       NULL AS net_prc, --净价价格
       NULL AS full_prc, --全价价格
       NULL AS end_yld, --到期收益率
       NULL AS exer_yld, --行权收益率
       t0.en_fee AS trd_chag, --交易手续费+经手费
       0 AS clea_serv_chag, --结算服务费+过户费
       0 AS oth_fee, --其他费用
       t0.l_date AS deli_dt, --交割日期
       NULL AS selfp_id, --本方编码
       t0.l_trade_rival_no AS trd_cntp_id, --交易对手编码
       'k' AS entr_dir_o3, --委托方向_O32
       t8.vc_entrustdir_name AS entr_dir_name_o3, --委托方向名称_O32
       'P' AS busi_clas_o3, --业务分类_O32
       NULL AS oper_no, --操作员
       NULL AS tnv_time, --成交时间
       NULL AS cntp_delr_id, --对手方交易员
       NULL AS cntp_delr_name, --对手方交易员名称
       '0' AS sett_fail_flag, --交收失败标识
       1 AS stat, --状态
       NULL AS memo, --备注
       NULL AS buyt_repo_tnv_vol, --买断式回购成交数量
       NULL AS bond_debc_tnv_vol, --债券借贷成交数量
       NULL AS repo_use_clas, --回购用途类别
       NULL AS cntp_bnk_id, --对手方银行编码
       NULL AS cntp_bnk_name, --对手方银行名称
       NULL AS cntp_bnk_acc, --对手方银行账号
       NULL AS cntp_bnk_acc_name, --对手方银行账号名称
       NULL AS cntp_bond_cstd_acc, --对手方债券托管账户
       NULL AS cntp_bond_cstd_acc_name, --对手方债券托管账户名称
       DATE_FORMAT(DATE_ADD(CURRENT_DATE, -1), 'yyyyMMdd') AS busi_date, --业务日期
       'evt_inbk_clea_jour_his_5' AS task_rs_id, --任务来源标识
       CURRENT_TIMESTAMP AS dm_created_time, --数据中台创建时间
       t0.l_date AS p_dt,
       'O3' AS sys_rs_id --系统来源标识
  FROM vhisrateexchangereceipt t0 --在途利率互换信息表,当前表和历史表合集
       LEFT JOIN ${ods_db}.o3_tfundinfo t1 --产品基本信息表,获取产品代码
              ON t0.l_fund_id = t1.l_fund_id
       LEFT JOIN ${ods_db}.o3_tcombi t3 --投资组合基本信息表,获取投资组合代码
              ON t0.l_basecombi_id = t3.l_combi_id
       LEFT JOIN ${ods_db}.o3_tasset t2 --资产单元基本信息表,获取资产单元代码
              ON t3.l_asset_id = t2.l_asset_id
       LEFT JOIN ${ods_db}.o3_thisstockinfo t5 --证券信息表
              ON t0.vc_inter_code = t5.vc_inter_code
             AND t0.l_date = t5.l_date
             AND t5.p_dt BETWEEN ${beg_date} AND ${end_date}
       LEFT JOIN ${ods_db}.o3_tentrustdirection t8 --委托方向表
              ON t8.c_entrust_direction = 'k' --k利率互换
             AND t5.c_market_no = t8.c_market_no
 WHERE t0.l_date BETWEEN ${beg_date} AND ${end_date}

 UNION ALL
--利率互换冲销
SELECT t0.l_date AS occu_dt, --发生日期
       NULL AS occu_time, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       CONCAT('0|0|0|', t0.l_date, '_HSO32', '_L', t0.l_serial_no) AS trd_src_id, --交易源ID
       CONCAT(t0.l_date, '_HSO32', '_L', t0.l_serial_no) AS tnv_onum, --成交序号
       NULL AS odr_onum, --指令序号
       NULL AS excf_onum, --执行确认序号
       NULL AS odr_rela_onum, --指令关联序号
       t8.vc_deal_no AS tnv_no, --成交编号
       t1.vc_fund_code AS prd_code, --产品代码,清洗时需要验证产品代码与估值能否对应上
       CONCAT(t1.vc_fund_code, '_', t2.vc_asset_no) AS ast_unit_code, --资产单元代码
       CONCAT(t1.vc_fund_code, '_', t2.vc_asset_no, '_', t3.vc_combi_no) AS pfl_code, --投组代码
       t0.vc_stockholder_id AS sh_code, -- 股东代码
       t0.vc_seat_id AS seat_code, --席位号
       CONCAT(t8.l_date, '_', t8.vc_deal_no, '_',
              (CASE
                    WHEN NVL(t8.c_owner_rate_type, t8.c_rival_rate_type) = '1'
                         THEN 'FR007.IR.OTH'
                    WHEN NVL(t8.c_owner_rate_type, t8.c_rival_rate_type) = '2'
                         THEN 'SHIBOR1W.IR.OTH'
                    WHEN NVL(t8.c_owner_rate_type, t8.c_rival_rate_type) = '3'
                         THEN 'SHIBOR3M.IR.OTH'
                    WHEN NVL(t8.c_owner_rate_type, t8.c_rival_rate_type) = '4'
                         THEN 'SHIBOR1D.IR.OTH'
                    WHEN NVL(t8.c_owner_rate_type, t8.c_rival_rate_type) = '5'
                         THEN 'DEPO1Y.IR.OTH'
                    WHEN NVL(t8.c_owner_rate_type, t8.c_rival_rate_type) = '6'
                         THEN 'LOAN1Y.IR.OTH'
                    WHEN NVL(t8.c_owner_rate_type, t8.c_rival_rate_type) = '7'
                         THEN 'LOAN3-5Y.IR.OTH'
                    WHEN NVL(t8.c_owner_rate_type, t8.c_rival_rate_type) = '8'
                         THEN 'FDR001.IR.OTH'
                    WHEN NVL(t8.c_owner_rate_type, t8.c_rival_rate_type) = '9'
                         THEN 'FDR007.IR.OTH'
                    WHEN NVL(t8.c_owner_rate_type, t8.c_rival_rate_type) = 'a'
                         THEN 'SHIBOR1M.IR.OTH'
                    WHEN NVL(t8.c_owner_rate_type, t8.c_rival_rate_type) = 'b'
                         THEN 'FR001.IR.OTH'
               END), '_', t8.vc_limit_time, '.EX.YHJ') AS secu_id, --证券编码
       'YHJ' AS exch_code, --交易市场代码
       CONCAT((CASE
                    WHEN NVL(t8.c_owner_rate_type, t8.c_rival_rate_type) = '1'
                         THEN 'FR007.IR.OTH'
                    WHEN NVL(t8.c_owner_rate_type, t8.c_rival_rate_type) = '2'
                         THEN 'SHIBOR1W.IR.OTH'
                    WHEN NVL(t8.c_owner_rate_type, t8.c_rival_rate_type) = '3'
                         THEN 'SHIBOR3M.IR.OTH'
                    WHEN NVL(t8.c_owner_rate_type, t8.c_rival_rate_type) = '4'
                         THEN 'SHIBOR1D.IR.OTH'
                    WHEN NVL(t8.c_owner_rate_type, t8.c_rival_rate_type) = '5'
                         THEN 'DEPO1Y.IR.OTH'
                    WHEN NVL(t8.c_owner_rate_type, t8.c_rival_rate_type) = '6'
                         THEN 'LOAN1Y.IR.OTH'
                    WHEN NVL(t8.c_owner_rate_type, t8.c_rival_rate_type) = '7'
                         THEN 'LOAN3-5Y.IR.OTH'
                    WHEN NVL(t8.c_owner_rate_type, t8.c_rival_rate_type) = '8'
                         THEN 'FDR001.IR.OTH'
                    WHEN NVL(t8.c_owner_rate_type, t8.c_rival_rate_type) = '9'
                         THEN 'FDR007.IR.OTH'
                    WHEN NVL(t8.c_owner_rate_type, t8.c_rival_rate_type) = 'a'
                         THEN 'SHIBOR1M.IR.OTH'
                    WHEN NVL(t8.c_owner_rate_type, t8.c_rival_rate_type) = 'b'
                         THEN 'FR001.IR.OTH'
               END), '_', t8.vc_limit_time) AS secu_code, --证券代码
       t5.vc_inter_code AS src_secu_id, --源证券ID
       t5.vc_inter_code AS src_secu_trd_id, --源证券交易ID
       'L' AS pos_id, --多空标志,融资回购为空头
       t0.vc_currency_no AS curr_code, --货币代码
       '470002' AS busi_typ, --业务类别
       CASE
            WHEN t0.c_invest_type = '1' THEN '2'
            WHEN t0.c_invest_type = '2' THEN '1'
            WHEN t0.c_invest_type = 'a' THEN '15'
            WHEN t0.c_invest_type = 'b' THEN '10'
            WHEN t0.c_invest_type = 'c' THEN '12'
            ELSE t0.c_invest_type
       END AS inv_typ, --投资类型
       '47000201' AS busi_clas, --业务类型
       '48' AS entr_dir, --委托方向
       '1' AS clr_typ, --清算类型,银行间市场默认全额清算
       t0.l_settle_speed AS clr_sped, --清算速度
       0 AS tnv_vol, --成交数量
       t0.l_post_amount AS aft_par_vol, --成交数量
       CASE
            WHEN t0.l_busin_flag = '72544' THEN - t0.en_subject_balance --72544利率互换冲销增加其他应付款
            WHEN t0.l_busin_flag = '72543' THEN t0.en_subject_balance --72543利率互换冲销增加其他应收款
       END AS tnv_val, --成交金额
       CASE
            WHEN t0.l_busin_flag = '72544' THEN - t0.en_subject_balance
            WHEN t0.l_busin_flag = '72543' THEN t0.en_subject_balance
       END AS occu_val, --发生金额
       t0.en_post_balance AS aft_occu_val, --发生后资金金额
       NULL AS rat, --回购利率,对于回购利率中,O32的价格存放为利率
       0 AS tnv_prc, --成交价格,其中所有回购默认100
       NULL AS net_prc, --净价价格
       NULL AS full_prc, --全价价格
       NULL AS end_yld, --到期收益率
       NULL AS exer_yld, --行权收益率
       0 AS trd_chag, --交易手续费+经手费
       0 AS clea_serv_chag, --结算服务费+过户费
       0 AS oth_fee, --其他费用
       t4.l_settle_date AS deli_dt, --交割日期
       NULL AS selfp_id, --本方编码
       t8.l_trade_rival_no AS trd_cntp_id, --交易对手编码
       'k' AS entr_dir_o3, --委托方向_O32
       t9.vc_entrustdir_name AS entr_dir_name_o3, --委托方向名称_O32
       'P' AS busi_clas_o3, --业务分类_O32
       NULL AS oper_no, --操作员
       NULL AS tnv_time, --成交时间
       NULL AS cntp_delr_id, --对手方交易员
       NULL AS cntp_delr_name, --对手方交易员名称
       '0' AS sett_fail_flag, --交收失败标识
       1 AS stat, --状态
       NULL AS memo, --备注
       NULL AS buyt_repo_tnv_vol, --买断式回购成交数量
       NULL AS bond_debc_tnv_vol, --债券借贷成交数量
       NULL AS repo_use_clas, --回购用途类别
       NULL AS cntp_bnk_id, --对手方银行编码
       NULL AS cntp_bnk_name, --对手方银行名称
       NULL AS cntp_bnk_acc, --对手方银行账号
       NULL AS cntp_bnk_acc_name, --对手方银行账号名称
       NULL AS cntp_bond_cstd_acc, --对手方债券托管账户
       NULL AS cntp_bond_cstd_acc_name, --对手方债券托管账户名称
       DATE_FORMAT(DATE_ADD(CURRENT_DATE, -1), 'yyyyMMdd') AS busi_date, --业务日期
       'evt_inbk_clea_jour_his_6' AS task_rs_id, --任务来源标识
       CURRENT_TIMESTAMP AS dm_created_time, --数据中台创建时间
       t0.l_date AS p_dt,
       'O3' AS sys_rs_id --系统来源标识
  FROM ${ods_db}.o3_thiscurrents t0 --清算流水表
       LEFT JOIN vhispendsettle t4 --待交割表,当前和历史的合集
              ON t0.l_date = t4.l_trade_date
             AND t0.l_basecombi_id = t4.l_basecombi_id
             AND t0.vc_inter_code = t4.vc_inter_code
             AND t0.l_busin_flag = t4.l_busin_flag
             AND t0.l_busin_no = t4.vc_original_no
       LEFT JOIN vhisrateexchangereceiptdetail t7 --利率互换冲销明细表
              ON t0.l_busin_no = t7.l_confirm_no
             AND t0.l_date = t7.l_date
             AND t7.c_status NOT IN ('4')
       LEFT JOIN vhisrateexchangereceipt t8 --利率互换合约,当前表和历史表合集
              ON t0.l_busin_no = t8.l_confirm_no
             AND t7.l_trade_date = t8.l_date
       LEFT JOIN ${ods_db}.o3_tfundinfo t1 --产品基本信息表,获取产品代码
              ON t0.l_fund_id = t1.l_fund_id
       LEFT JOIN ${ods_db}.o3_tasset t2 --资产单元基本信息表,获取资产单元代码
              ON t0.l_asset_id = t2.l_asset_id
       LEFT JOIN ${ods_db}.o3_tcombi t3 --投资组合基本信息表,获取投资组合代码
              ON t0.l_basecombi_id = t3.l_combi_id
       LEFT JOIN ${ods_db}.o3_thisstockinfo t5 --证券信息表
              ON t0.vc_inter_code = t5.vc_inter_code
             AND t0.l_date = t5.l_date
             AND t5.p_dt BETWEEN ${beg_date} AND ${end_date}
       LEFT JOIN ${ods_db}.o3_tentrustdirection t9 --委托方向表
              ON t0.c_entrust_direction = t9.c_entrust_direction
             AND t5.c_market_no = t9.c_market_no
 WHERE t0.l_busin_flag IN ('72543', '72544')
   -- 72543利率互换冲销增加其他应收款,72544利率互换冲销增加其他应付款
   AND t0.c_status IN ('1')
   AND t0.p_dt BETWEEN ${beg_date} AND ${end_date}