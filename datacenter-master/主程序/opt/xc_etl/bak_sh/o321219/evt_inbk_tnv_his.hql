------------------------------------------------------------------------
-- 模块名称：银行间成交信息
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

ALTER TABLE ${dwd_db}.evt_inbk_tnv_his DROP IF EXISTS PARTITION (p_dt>=${beg_date} , p_dt<=${end_date},sys_rs_id = 'O3');

INSERT INTO ${dwd_db}.evt_inbk_tnv_his PARTITION (p_dt, sys_rs_id)
(occu_dt, occu_time, busi_sys_id, trd_src_id, tnv_onum, odr_onum, excf_onum, odr_rela_onum, tnv_no, prd_code, ast_unit_code, pfl_code, sh_code, seat_code, secu_id, exch_code, secu_code, src_secu_id, src_secu_trd_id, pos_id, curr_code, busi_typ, inv_typ, busi_clas, entr_dir, clr_typ, clr_sped, par_gamt, tnv_vol, aft_par_vol, tnv_val, occu_val, aft_occu_val, rat, tnv_prc, net_prc, full_prc, end_yld, exer_yld, trd_chag, clea_serv_chag, oth_fee, cont_days, inta_days, cont_tnv_dt, cont_end_dt, fir_deli_dt, end_deli_dt, fir_deli_mode, end_deli_mode, fir_net_prc, end_net_prc, fir_hd_intr, end_hd_intr, buyb_val, intr, deli_dt, selfp_id, trd_cntp_id, entr_dir_o3, entr_dir_name_o3, busi_clas_o3, oper_no, tnv_time, cntp_delr_id, cntp_delr_name, sett_fail_flag, stat, memo, buyt_repo_tnv_vol, bond_debc_tnv_vol, repo_use_clas, in_prd_code, in_ast_unit_code, in_pfl_code, in_sh_code, in_seat_code, in_inv_typ, in_secu_id, in_par_gamt, in_tnv_prc, in_tnv_val, in_occu_val, in_fee, cntp_bnk_id, cntp_bnk_name, cntp_bnk_acc, cntp_bnk_acc_name, cntp_bond_cstd_acc, cntp_bond_cstd_acc_name, busi_date, task_rs_id, dm_created_time, p_dt, sys_rs_id)
SELECT t0.occu_dt, --发生日期
       t0.occu_time,--发生时间
       t0.busi_sys_id,--业务系统编码
       t0.trd_src_id,--交易源ID
       t0.tnv_onum, --成交序号
       t0.odr_onum, --指令序号
       t0.excf_onum, --执行确认序号
       t0.odr_rela_onum,--指令关联序号
       t0.tnv_no,--成交编号
       t0.prd_code, --产品代码
       t0.ast_unit_code, --资产单元代码
       t0.pfl_code, --投组代码
       t0.sh_code, --股东代码
       t0.seat_code, --席位号
       t0.secu_id, --证券编码
       t0.exch_code, --交易市场代码
       t0.secu_code, --证券代码
       t0.src_secu_id,--源证券ID
       t0.src_secu_trd_id,--源证券交易ID
       t0.pos_id, --多空标志
       t0.curr_code, --货币代码
       t0.busi_typ, --业务类别
       t0.inv_typ, --投资类型
       t0.busi_clas,--业务类型
       t0.entr_dir,--委托方向
       t0.clr_typ, --清算类型
       t0.clr_sped, --清算速度
       NULL AS par_gamt, --券面总额
       t0.tnv_vol,--成交数量
       t0.aft_par_vol,--发生后数量
       t0.tnv_val, --成交金额
       t0.occu_val, --发生金额
       t0.aft_occu_val, --发生后资金金额
       t0.rat, --回购利率
       t0.tnv_prc, --成交价格
       t0.net_prc, --净价价格
       t0.full_prc, --全价价格
       t0.end_yld, --到期收益率
       t0.exer_yld, --行权收益率
       t0.trd_chag, --交易手续费
       t0.clea_serv_chag, --结算服务费
       t0.oth_fee, --其他费用
       t1.repo_days AS cont_days, --合约天数
       t1.inta_days, --计息天数
       t1.tnv_dt AS cont_tnv_dt, --合约成交日期
       t1.buyb_dt AS cont_end_dt, --合约到期日期
       t1.fir_deli_dt, --首期交割日期
       t1.end_deli_dt, --到期交割日期
       t1.fir_deli_mode, --首期交割方式
       t1.end_deli_mode, --到期交割方式
       t1.fir_net_prc, --首期净价价格
       t1.end_net_prc, --到期净价价格
       t1.fir_hd_intr, --首期百元利息
       t1.end_hd_intr, --到期百元利息
       t1.buyb_val, -- 购回金额
       t1.repo_intr AS intr, --利息
       t0.deli_dt, --交割日期
       t0.selfp_id, --本方编码
       CASE
            WHEN t0.busi_typ = '020002' THEN --020002银行间质押式回购
                 t1.trd_cntp_id
            ELSE t0.trd_cntp_id
       END AS trd_cntp_id,--交易对手编码
       t0.entr_dir_o3, --委托方向_O32
       t0.entr_dir_name_o3, --委托方向名称_O32
       t0.busi_clas_o3, --业务分类_O32
       t0.oper_no, --操作员
       t0.tnv_time, --成交时间
       t0.cntp_delr_id,--对手方交易员代码
       t0.cntp_delr_name, --对手方交易员名称
       t0.sett_fail_flag, --交收失败标识
       t0.stat, --状态
       t0.memo, --备注
       t0.buyt_repo_tnv_vol,--买断式回购成交数量
       t0.bond_debc_tnv_vol,--债券借贷成交数量
       t0.repo_use_clas, --回购用途类别
       NULL AS in_prd_code,--转入产品代码
       NULL AS in_ast_unit_code,--转入资产单元代码
       NULL AS in_pfl_code,--转入投组代码
       NULL AS in_sh_code,--转入股东代码
       NULL AS in_seat_code,--转入席位号
       NULL AS in_inv_typ,--转入投资类型
       NULL AS in_secu_id,--转入证券编码
       NULL AS in_par_gamt,--转入券面总额
       NULL AS in_tnv_prc,--转入成交价格
       NULL AS in_tnv_val,--转入成交金额
       NULL AS in_occu_val,--转入发生金额
       NULL AS in_fee,--转入费用
       t0.cntp_bnk_id, --对手方银行编码
       t0.cntp_bnk_name, --对手方银行名称
       t0.cntp_bnk_acc, --对手方银行账号
       t0.cntp_bnk_acc_name, --对手方银行账号名称
       t0.cntp_bond_cstd_acc, --对手方债券托管账户
       t0.cntp_bond_cstd_acc_name, --对手方债券托管账户名称
       DATE_FORMAT(DATE_ADD(CURRENT_DATE, -1), 'yyyyMMdd') AS busi_date, --业务日期
       CASE WHEN t0.TASK_RS_ID LIKE '%spcl%' then t0.TASK_RS_ID else 'evt_inbk_tnv_his_1' end AS task_rs_id,--  'evt_inbk_tnv_his_1' AS task_rs_id, 任务来源标识
       CURRENT_TIMESTAMP AS dm_created_time, --数据中台创建时间
       t0.occu_dt AS p_dt,
       'O3' AS sys_rs_id --系统来源标识
  FROM ${dwd_db}.evt_inbk_clea_jour_his t0 --银行间银行间清算流水(离线)
       LEFT JOIN ${dwd_db}.pro_repo_tnv_info t1 --回购成交合约表
              ON t0.secu_id = t1.secu_id
             AND t1.sys_rs_id = 'O3'
 WHERE t0.sys_rs_id = 'O3'
   AND t0.p_dt BETWEEN ${beg_date} AND ${end_date}
;