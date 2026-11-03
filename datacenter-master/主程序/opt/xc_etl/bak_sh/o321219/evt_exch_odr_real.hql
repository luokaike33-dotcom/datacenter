------------------------------------------------------------------------
-- 模块名称：交易所指令表(盘后)
--业务：
--交易所现券买卖
--指令：质押出入库
--指令：质押式回购
--指令：配股/债/上交所老股东配售（通过识别当天有无增发代码）
--指令：网上新股\新债
--指令：预受要约\预受要约撤销
--指令：债回售申报
--离线指令：股指期货\国债期货\商品期货
--指令：跨市场转托管转出（基金）
--指令：转融券成交/展期/提前了结
--离线指令：债转股
--指令：指定\撤指
--指令：议案投票
--供股权(公开配售)申报\申报撤销
--指令：分销买入\分销卖出
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
----set spark.driver.memory=2G; --内存默认2G，复杂任务不够时可单独设置增加
----set hive.auto.convert.join=true;
alter table ${dwd_db}.evt_exch_odr_his drop if exists partition (p_dt=${end_date},sys_rs_id='O3') ;

insert into ${dwd_db}.evt_exch_odr_his partition(p_dt,sys_rs_id)
(busi_sys_id,trd_src_id,occu_dt,occu_time,odr_onum,odr_clas,odr_rela_dt,odr_strt_dt,odr_end_dt,odr_strt_time,odr_end_time,odr_ctrl_clas,odr_secu_onum,odr_rela_onum,prd_code,ast_unit_code,pfl_code,sh_code,inv_typ,busi_typ,busi_clas,secu_id,exch_code,secu_code,src_secu_id,src_secu_trd_id,pos_id,curr_code,clr_sped,trd_plfm,trd_mode,entr_dir,odr_prc_clas,odr_prc,rat,odr_vol,odr_val,bgng_has_entr_vol,bgng_has_entr_val,bgng_has_tnv_vol,bgng_has_tnv_val,entr_vol,entr_val,tnv_vol,tnv_val,trd_cntp_id,appt_num,guar_sett_flag,deli_dt,rela_rrsn,agt_rela_rrsn,memo,cont_days,inta_days,cont_tnv_dt,cont_end_dt,fir_deli_dt,end_deli_dt,fir_deli_mode,end_deli_mode,buyb_val,intr,in_prd_code,in_ast_unit_code,in_pfl_code,in_inv_typ,in_secu_id,in_src_secu_id,in_odr_vol,in_odr_prc,in_odr_val,cntp_seat_code,res_flag,lock_lmt_clas,lmt_clas_onum,agmt_num,bons_mode,pay_dt,cont_mult,arbi_flag,esti_cash_diff,etf_fnd_clas,odr_stat,busi_date,task_rs_id,dm_created_time,delr_id,p_dt,sys_rs_id)
--交易所现券买卖
SELECT T.BUSI_SYS_ID, --业务系统编码
T.TRD_SRC_ID, --交易源ID
T.OCCU_DT, --发生日期
T.OCCU_TIME, --发生时间
T.ODR_ONUM, --指令序号
T.ODR_CLAS, --指令类型
T.ODR_RELA_DT, --指令下达日期
T.ODR_STRT_DT, --指令开始日期
T.ODR_END_DT, --指令结束日期
T.ODR_STRT_TIME, --指令开始时间
T.ODR_END_TIME, --指令结束时间
T.ODR_CTRL_CLAS, --指令控制类型
T.ODR_SECU_ONUM, --指令证券序号
T.ODR_RELA_ONUM, --指令关联序号
T.PRD_CODE, --产品代码
T.AST_UNIT_CODE, --资产单元代码
T.PFL_CODE, --投组代码
T.SH_CODE, --股东代码
T.INV_TYP, --投资类型
T.BUSI_TYP, --业务类别
T.BUSI_CLAS, --业务类型
case when T.EXCH_CODE in ('SHSC','SZSC') then nvl(t1.NEW_SECU_ID,t.SECU_ID) else t.SECU_ID end as SECU_ID, --证券编码
T.EXCH_CODE, --交易市场代码
T.SECU_CODE, --证券代码
T.SRC_SECU_ID, --源证券ID
T.SRC_SECU_TRD_ID, --源证券交易ID
T.POS_ID, --多空标志
T.CURR_CODE, --货币代码
T.CLR_SPED, --清算速度
T.TRD_PLFM, --交易平台
T.TRD_MODE,--交易方式
T.ENTR_DIR, --委托方向
T.ODR_PRC_CLAS, --指令价格类型
T.ODR_PRC, --指令价格
T.RAT, --利率
T.ODR_VOL, --指令数量
T.ODR_VAL, --指令金额
T.BGNG_HAS_ENTR_VOL, --期初已委托数量
T.BGNG_HAS_ENTR_VAL, --期初已委托金额
T.BGNG_HAS_TNV_VOL, --期初已成交数量
T.BGNG_HAS_TNV_VAL, --期初已成交金额
T.ENTR_VOL, --当日委托数量
T.ENTR_VAL, --当日委托金额
T.TNV_VOL, --当日成交数量
T.TNV_VAL, --当日成交金额
T.TRD_CNTP_ID, --交易对手编码
T.APPT_NUM, --约定号
T.GUAR_SETT_FLAG, --担保交收标识
T.DELI_DT, --交割日期
T.RELA_RRSN, --下达人
T.AGT_RELA_RRSN, --代下达人
T.MEMO, --备注
T.CONT_DAYS, --合约天数
T.INTA_DAYS, --计息天数
T.CONT_TNV_DT, --合约成交日期
T.CONT_END_DT, --合约到期日期
T.FIR_DELI_DT, --首期交割日期
T.END_DELI_DT, --到期交割日期
T.FIR_DELI_MODE, --首期交割方式
T.END_DELI_MODE, --到期交割方式
T.BUYB_VAL, --购回金额
T.INTR, --利息
T.IN_PRD_CODE, --转入产品代码
T.IN_AST_UNIT_CODE, --转入资产单元代码
T.IN_PFL_CODE, --转入投组代码
T.IN_INV_TYP, --转入投资类型
T.IN_SECU_ID, --转入证券编码
T.IN_SRC_SECU_ID, --转入源证券ID
T.IN_ODR_VOL, --转入指令数量
T.IN_ODR_PRC, --转入指令价格
T.IN_ODR_VAL, --转入指令金额
T.CNTP_SEAT_CODE, --对手方席位号
T.RES_FLAG, --限售标识
T.LOCK_LMT_CLAS, --锁定受限类型
T.LMT_CLAS_ONUM, --受限类型序号
T.AGMT_NUM, --合同号
T.BONS_MODE, --分红方式
T.PAY_DT, --缴款日期
T.CONT_MULT, --合约乘数
T.ARBI_FLAG, --套利标志
T.ESTI_CASH_DIFF, --预估现金差额
T.ETF_FND_CLAS, --ETF基金类型
T.ODR_STAT, --指令状态
T.BUSI_DATE, --业务日期
T.TASK_RS_ID, --任务来源标识
T.DM_CREATED_TIME, --数据中台创建时间
T.DELR_ID, --交易员
T.P_DT,
T.SYS_RS_ID --系统来源标识
FROM (
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       concat('0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '|0|0') AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY) AS ODR_ONUM, --指令序号
       T0.C_INSTRUCTION_TYPE AS ODR_CLAS, --指令类型
       T0.L_DIRECT_DATE AS ODR_RELA_DT, --指令下达日期
       T0.L_BEGIN_DATE AS ODR_STRT_DT, --指令开始日期
       T0.L_END_DATE AS ODR_END_DT, --指令结束日期
       T0.L_BEGIN_TIME AS ODR_STRT_TIME, --指令开始时间
       T0.L_END_TIME AS ODR_END_TIME, --指令结束时间
       T0.C_STOCK_TARGET_TYPE AS ODR_CTRL_CLAS, --指令控制类型
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY , '_' , T4.L_STOCK_SERIAL_NO) AS ODR_SECU_ONUM, --指令证券序号
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T4.L_BASECOMBI_ID , '_' , (CASE
         WHEN T5.C_ASSET_CLASS = '2' THEN
          concat(T5.VC_REPORT_CODE , '.STK.' , --股票
          (case when T5.C_MARKET_NO = '1' then 'SH'
                when T5.C_MARKET_NO = '2' then 'SZ'
                when T5.C_MARKET_NO = 'n' then 'SHSC'
                when T5.C_MARKET_NO = 'o' then 'SZSC'
				when T5.C_MARKET_NO = 'j' then (case when NVL(T5.VC_LAYERING,0) = 2 then 'BJ' else 'SB' end)
				when T5.C_MARKET_NO = 'r' then 'BJ'
			end))
         WHEN T5.C_ASSET_CLASS = '3' THEN --债券
          concat(T5.VC_REPORT_CODE , '.BOND.' , (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end))
         WHEN T5.C_ASSET_CLASS = '4' THEN --基金
          concat(T5.VC_REPORT_CODE , '.FUND.' , (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end))
         WHEN T5.C_STOCK_TYPE = '15' THEN --供股权
          concat(T5.VC_REPORT_CODE , '.WRNT.' , (case when T5.C_MARKET_NO = 'n' then 'SHSC' when T5.C_MARKET_NO = 'o' then 'SZSC' end))
       END) , '_' , (CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T4.C_INVEST_TYPE
       END) , '_' , (CASE
         WHEN T4.C_ENTRUST_DIRECTION in ('1', '3') THEN
          '01000100'
         WHEN T4.C_ENTRUST_DIRECTION in ('2', '4') THEN
          '01000101'
       END)) AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T4.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T4.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       '010001' AS BUSI_TYP, --业务类别
       CASE
         WHEN T4.C_ENTRUST_DIRECTION in ('1', '3') THEN
          '01000100'
         WHEN T4.C_ENTRUST_DIRECTION in ('2', '4') THEN
          '01000101'
       END AS BUSI_CLAS, --业务类型
       CASE
         WHEN T5.C_ASSET_CLASS = '2' THEN
          concat(T5.VC_REPORT_CODE , '.STK.' , --股票
          (case when T5.C_MARKET_NO = '1' then 'SH'
                when T5.C_MARKET_NO = '2' then 'SZ'
                when T5.C_MARKET_NO = 'n' then 'SHSC'
                when T5.C_MARKET_NO = 'o' then 'SZSC'
				when T5.C_MARKET_NO = 'j' then (case when NVL(T5.VC_LAYERING,0) = 2 then 'BJ' else 'SB' end)
				when T5.C_MARKET_NO = 'r' then 'BJ'
			end))
         WHEN T5.C_ASSET_CLASS = '3' THEN --债券
          concat(T5.VC_REPORT_CODE , '.BOND.' , (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end))
         WHEN T5.C_ASSET_CLASS = '4' THEN --基金
          concat(T5.VC_REPORT_CODE , '.FUND.' , (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end))
         WHEN T5.C_STOCK_TYPE = '15' THEN --供股权
          concat(T5.VC_REPORT_CODE , '.WRNT.' , (case when T5.C_MARKET_NO = 'n' then 'SHSC' when T5.C_MARKET_NO = 'o' then 'SZSC' end))
       END AS SECU_ID, --证券编码
       CASE
         WHEN T5.C_MARKET_NO = '1' THEN
          'SH'
         WHEN T5.C_MARKET_NO = '2' THEN
          'SZ'
         WHEN T5.C_MARKET_NO = 'n' THEN
          'SHSC'
         WHEN T5.C_MARKET_NO = 'o' THEN
          'SZSC'
         WHEN T5.C_MARKET_NO = 'j' THEN
          (case when NVL(T5.VC_LAYERING,0) = 2 then 'BJ' else 'SB' end)
         WHEN T5.C_MARKET_NO = 'r' THEN
          'BJ'
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       CASE
         WHEN T5.C_MARKET_NO IN ('n', 'o') THEN
          'HKD'
         ELSE
          'CNY'
       END AS CURR_CODE, --货币代码
       T4.L_SETTLE_SPEED AS CLR_SPED, --清算速度
       CASE
         WHEN T5.C_MARKET_NO = '2' AND T5.C_ASSET_CLASS = '3' AND T5.C_STOCK_TYPE <> '5' AND T5.L_DATE >= '20220512' THEN  --新债平台切换
          'PLAT_FIXINC' --深圳固收平台
         WHEN T5.C_MARKET_NO = '1' AND T5.C_ASSET_CLASS = '3' AND T0.C_BUSIN_CLASS = '1' AND T5.L_DATE >= '20220512' THEN  --新债平台切换
          'PLAT_NEW_BOND' --上海新债平台
         WHEN T5.C_MARKET_NO = '1' AND T5.C_ASSET_CLASS = '3' AND T0.C_BUSIN_CLASS IN ('I', 'E')  AND T5.L_DATE >= '20220512' THEN  --新债平台切换
          'PLAT_FIXINC' --上海固收平台
         WHEN T0.C_BUSIN_CLASS IN ('1') AND T5.C_MARKET_NO IN ('1','n') THEN
          'PLAT_BID' -- 上海竞价
         WHEN T0.C_BUSIN_CLASS IN ('1') AND T5.C_MARKET_NO IN ('2','o') THEN
          'PLAT_BID' --深圳竞价
         WHEN T0.C_BUSIN_CLASS IN ('1') AND T5.C_MARKET_NO IN ('j','r') THEN
          'PLAT_BID' --股转竞价
         WHEN T0.C_BUSIN_CLASS = 'I' THEN
          'PLAT_FIXINC' --上海固收
         WHEN T0.C_BUSIN_CLASS = 'E' AND T5.C_MARKET_NO = '1' THEN
          'PLAT_BULK' --上海大宗
         WHEN T0.C_BUSIN_CLASS = 'E' AND T5.C_MARKET_NO = '2' THEN
          'PLAT_BULK' --深圳大宗
       END AS TRD_PLFM, --交易平台
       CASE
         WHEN T5.C_MARKET_NO = '2' AND T5.C_ASSET_CLASS = '3' AND T5.C_STOCK_TYPE <> '5' AND T0.C_BUSIN_CLASS = '1' AND T5.L_DATE >= '20220512' THEN  --新债平台切换
          1 --匹配成交
         WHEN T5.C_MARKET_NO = '1' AND T5.C_ASSET_CLASS = '3' AND T0.C_BUSIN_CLASS = '1' AND T5.L_DATE >= '20220512' THEN  --新债平台切换
          1 --匹配成交
         WHEN T5.C_MARKET_NO = '2' AND T5.C_ASSET_CLASS = '3' AND T5.C_STOCK_TYPE <> '5' AND T5.L_DATE >= '20220512' THEN  --新债平台切换
          99 --其他成交方式
         WHEN T5.C_MARKET_NO = '1' AND T5.C_ASSET_CLASS = '3'  AND T5.L_DATE >= '20220512' THEN  --新债平台切换
          99 --其他成交方式
         ELSE
          NULL
       END AS TRD_MODE,--交易方式
       T4.C_ENTRUST_DIRECTION AS ENTR_DIR, --委托方向
       CASE
         WHEN T4.C_PRICE_TYPE IN ('4', '5', '6') THEN
          '2'
         ELSE
          '1'
       END AS ODR_PRC_CLAS, --指令价格类型
       (case when T4.EN_PRICE1 = 0 then T4.EN_FACT_PRICE else T4.EN_PRICE1 end) AS ODR_PRC, --指令价格
       NULL AS RAT, --利率
       T4.L_AMOUNT AS ODR_VOL, --指令数量
       T4.EN_BALANCE AS ODR_VAL, --指令金额
       T4.L_TOTAL_ENTRUST_AMOUNT AS BGNG_HAS_ENTR_VOL, --期初已委托数量
       T4.EN_TOTAL_ENTRUST_BALANCE AS BGNG_HAS_ENTR_VAL, --期初已委托金额
       T4.L_TOTAL_DEAL_AMOUNT AS BGNG_HAS_TNV_VOL, --期初已成交数量
       T4.EN_TOTAL_DEAL_BALANCE AS BGNG_HAS_TNV_VAL, --期初已成交金额
       T4.L_TODAY_ENTRUST_AMOUNT AS ENTR_VOL, --当日委托数量
       T4.EN_TODAY_ENTRUST_BALANCE AS ENTR_VAL, --当日委托金额
       T4.L_TODAY_DEAL_AMOUNT AS TNV_VOL, --当日成交数量
       T4.EN_TODAY_DEAL_BALANCE AS TNV_VAL, --当日成交金额
       T0.L_TRADE_RIVAL_NO AS TRD_CNTP_ID, --交易对手编码
       NULL AS APPT_NUM, --约定号
       CASE
         WHEN T5.VC_MIXED_TYPE = 'p' AND T4.C_BUSIN_CLASS = 'I' AND
              T4.L_SETTLE_SPEED = 1 THEN --上海固收平台、非净额结算并且清算速度1，为非担保债券
          '0'
         WHEN T4.C_BUSIN_CLASS = 'I' AND T4.L_SETTLE_SPEED = 0 THEN --上海固收平台、清算速度0，为非担保债券
          '0'
         WHEN T4.C_BUSIN_CLASS = 'E' AND T5.C_MARKET_NO = '2' AND
              T4.L_SETTLE_SPEED = 0 THEN --深圳综合协议平台并且清算速度0，为非担保债券
          '0'
         ELSE
          '1' --其余为担保债券；
       END AS GUAR_SETT_FLAG, --担保交收标识
       CASE
         WHEN T4.C_ENTRUST_DIRECTION in ('1', '2') AND
              T5.C_MARKET_NO IN ('n', 'o') THEN --股票、基金、港股通买卖
          W2.aft_2_dt
         WHEN T4.C_ENTRUST_DIRECTION in ('1', '2') AND
              T5.C_MARKET_NO IN ('1', '2', 'j', 'r') THEN --股票、基金、港股通买卖
          W1.aft_1_dt
         WHEN T4.C_ENTRUST_DIRECTION IN ('3', '4') AND T0.L_SETTLE_SPEED = 0 THEN --债券买卖，清算速度为0
          T0.L_DATE
         WHEN T4.C_ENTRUST_DIRECTION IN ('3', '4') AND T0.L_SETTLE_SPEED = 1 THEN --债券买卖，清算速度为1
          W1.aft_1_dt
       END AS DELI_DT, --交割日期
       T0.L_DIRECT_OPERATOR AS RELA_RRSN, --下达人
       T0.L_DIRECT_INSTEAD_OPERATOR AS AGT_RELA_RRSN, --代下达人
       T0.VC_SUMMARY AS MEMO, --备注
       NULL AS CONT_DAYS, --合约天数
       NULL AS INTA_DAYS, --计息天数
       NULL AS CONT_TNV_DT, --合约成交日期
       NULL AS CONT_END_DT, --合约到期日期
       NULL AS FIR_DELI_DT, --首期交割日期
       NULL AS END_DELI_DT, --到期交割日期
       NULL AS FIR_DELI_MODE, --首期交割方式
       NULL AS END_DELI_MODE, --到期交割方式
       NULL AS BUYB_VAL, --购回金额
       NULL AS INTR, --利息
       NULL AS IN_PRD_CODE, --转入产品代码
       NULL AS IN_AST_UNIT_CODE, --转入资产单元代码
       NULL AS IN_PFL_CODE, --转入投组代码
       NULL AS IN_INV_TYP, --转入投资类型
       NULL AS IN_SECU_ID, --转入证券编码
       NULL AS IN_SRC_SECU_ID, --转入源证券ID
       NULL AS IN_ODR_VOL, --转入指令数量
       NULL AS IN_ODR_PRC, --转入指令价格
       NULL AS IN_ODR_VAL, --转入指令金额
       T4.VC_RIVAL_SEAT AS CNTP_SEAT_CODE, --对手方席位号
       CASE
         WHEN T0.C_BUSIN_CLASS = 'E' AND
              NVL(T4.C_BULKUNDERWEIGHT_FLAG, 0) <> 0 THEN
          1 --大宗交易限售
         ELSE
          0 --非限售
       END AS RES_FLAG, --限售标识
       CASE
         WHEN T0.C_BUSIN_CLASS = 'E' AND
              NVL(T4.C_BULKUNDERWEIGHT_FLAG, 0) <> 0 THEN
          3 --大宗交易买入限售
         ELSE
          0 --非限售
       END AS LOCK_LMT_CLAS, --锁定受限类型
       NULL AS LMT_CLAS_ONUM, --受限类型序号
       NULL AS AGMT_NUM, --合同号
       NULL AS BONS_MODE, --分红方式
       NULL AS PAY_DT, --缴款日期
       NULL AS CONT_MULT, --合约乘数
       NULL AS ARBI_FLAG, --套利标志
       NULL AS ESTI_CASH_DIFF, --预估现金差额
       NULL AS ETF_FND_CLAS, --ETF基金类型
       CASE
         WHEN T0.C_INSTRUCTION_STATUS IN ('5') THEN --审批拒绝
          '4'
         WHEN T0.C_INSTRUCTION_STATUS IN ('6') THEN --分发拒绝
          '5'
         ELSE
          T0.C_INSTRUCTION_STATUS
       END AS ODR_STAT, --指令状态
       ${current_date} AS BUSI_DATE, --业务日期
       'evt_exch_odr_real_1' AS TASK_RS_ID, --任务来源标识
	   CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_OPERATOR_NO AS DELR_ID, --交易员
	     T0.L_DATE	AS P_DT,
	     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TINSTRUCTION T0
 INNER JOIN ${ods_db}.O3_TINSTRUCTIONSTOCK T4
    ON T0.L_DATE = T4.L_DATE
   AND T0.L_DAILY_INSTRUCTION_NO = T4.L_DAILY_INSTRUCTION_NO
   AND T0.L_INDEX_DAILY_MODIFY = T4.L_INDEX_DAILY_MODIFY
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T4.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T4.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5
    ON T4.L_DATE = T5.L_DATE
   AND T4.VC_INTER_CODE = T5.VC_INTER_CODE
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
    ON GREATEST(T0.L_BEGIN_DATE, T0.L_DATE) = w1.dt
   AND T5.C_MARKET_NO = w1.mkt_no
   AND W1.SYS_RS_ID = 'O3'
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_settle W2
    ON GREATEST(T0.L_BEGIN_DATE, T0.L_DATE) = w2.dt
   AND T5.C_MARKET_NO = w2.mkt_no
   AND W2.SYS_RS_ID = 'O3'
 WHERE T0.C_BUSIN_CLASS IN ('1', 'I', 'E')
   AND T4.C_CASH_CONTROL_TYPE NOT IN ('a') --排除港股通的风险资金部分
   AND T4.C_ENTRUST_DIRECTION IN ('1', '2', '3', '4')
   AND T0.C_INSTRUCTION_STATUS IN ('1', '2', '3', '5', '6') --1:有效；2:已修改；3:已撤销；5:审批拒绝；6:分发拒绝
   AND T0.L_DATE = ${current_date}
) t
left join ${dwd_db}.VAR_SECU_CODE_CHG t1
on t.secu_id = t1.secu_id
     where (t.OCCU_DT between t1.NEW_SECU_ID_BGN_DT and t1.NEW_SECU_ID_END_DT) or t1.secu_id is null

UNION ALL
--指令：质押出入库
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       concat('0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '|0|0') AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY) AS ODR_ONUM, --指令序号
       T0.C_INSTRUCTION_TYPE AS ODR_CLAS, --指令类型
       T0.L_DIRECT_DATE AS ODR_RELA_DT, --指令下达日期
       T0.L_BEGIN_DATE AS ODR_STRT_DT, --指令开始日期
       T0.L_END_DATE AS ODR_END_DT, --指令结束日期
       T0.L_BEGIN_TIME AS ODR_STRT_TIME, --指令开始时间
       T0.L_END_TIME AS ODR_END_TIME, --指令结束时间
       T0.C_STOCK_TARGET_TYPE AS ODR_CTRL_CLAS, --指令控制类型
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY , '_' , T4.L_STOCK_SERIAL_NO) AS ODR_SECU_ONUM, --指令证券序号
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T4.L_BASECOMBI_ID , '_' , (CASE
         WHEN T6.C_ASSET_CLASS = '3' THEN --债券
          concat(T6.VC_REPORT_CODE , '.BOND.' , (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end))
         WHEN T6.C_ASSET_CLASS = '4' THEN --基金
          concat(T6.VC_REPORT_CODE , '.FUND.' , (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end))
       END) , '_' , (CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T4.C_INVEST_TYPE
       END) , '_' , (CASE
         WHEN T4.C_ENTRUST_DIRECTION in ('T') THEN
          '04000100'
         WHEN T4.C_ENTRUST_DIRECTION in ('U') THEN
          '04000101'
       END)) AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T4.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T4.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       '040001' AS BUSI_TYP, --业务类别
       CASE
         WHEN T4.C_ENTRUST_DIRECTION in ('T') THEN
          '04000100'
         WHEN T4.C_ENTRUST_DIRECTION in ('U') THEN
          '04000101'
       END AS BUSI_CLAS, --业务类型
       CASE
         WHEN T6.C_ASSET_CLASS = '3' THEN --债券
          concat(T6.VC_REPORT_CODE , '.BOND.' , (case when T6.C_MARKET_NO = '1' then 'SH' when T6.C_MARKET_NO = '2' then 'SZ' end))
         WHEN T6.C_ASSET_CLASS = '4' THEN --基金
          concat(T6.VC_REPORT_CODE , '.FUND.' , (case when T6.C_MARKET_NO = '1' then 'SH' when T6.C_MARKET_NO = '2' then 'SZ' end))
       END AS SECU_ID, --证券编码
       CASE
         WHEN T5.C_MARKET_NO = '1' THEN
          'SH'
         WHEN T5.C_MARKET_NO = '2' THEN
          'SZ'
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T6.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       T4.L_SETTLE_SPEED AS CLR_SPED, --清算速度
       CASE
         WHEN T0.C_BUSIN_CLASS IN ('1') THEN
          'PLAT_BID'
         WHEN T0.C_BUSIN_CLASS = 'I' THEN
          'PLAT_FIXINC'
       END AS TRD_PLFM, --交易平台
	   NULL AS TRD_MODE,--交易方式
       CASE
         WHEN T4.C_ENTRUST_DIRECTION in ('T') THEN
          '30'
         WHEN T4.C_ENTRUST_DIRECTION in ('U') THEN
          '31'
       END  AS ENTR_DIR, --委托方向
       CASE
         WHEN T4.C_PRICE_TYPE IN ('4', '5', '6') THEN
          '2'
         ELSE
          '1'
       END AS ODR_PRC_CLAS, --指令价格类型
       0 AS ODR_PRC, --指令价格
       NULL AS RAT, --利率
       T4.L_AMOUNT AS ODR_VOL, --指令数量
       0 AS ODR_VAL, --指令金额
       T4.L_TOTAL_ENTRUST_AMOUNT AS BGNG_HAS_ENTR_VOL, --期初已委托数量
       T4.EN_TOTAL_ENTRUST_BALANCE AS BGNG_HAS_ENTR_VAL, --期初已委托金额
       T4.L_TOTAL_DEAL_AMOUNT AS BGNG_HAS_TNV_VOL, --期初已成交数量
       T4.EN_TOTAL_DEAL_BALANCE AS BGNG_HAS_TNV_VAL, --期初已成交金额
       T4.L_TODAY_ENTRUST_AMOUNT AS ENTR_VOL, --当日委托数量
       T4.EN_TODAY_ENTRUST_BALANCE AS ENTR_VAL, --当日委托金额
       T4.L_TODAY_DEAL_AMOUNT AS TNV_VOL, --当日成交数量
       T4.EN_TODAY_DEAL_BALANCE AS TNV_VAL, --当日成交金额
       T0.L_TRADE_RIVAL_NO AS TRD_CNTP_ID, --交易对手编码
       NULL AS APPT_NUM, --约定号
       NULL AS GUAR_SETT_FLAG, --担保交收标识
       GREATEST(T0.L_BEGIN_DATE,T0.L_DATE) AS DELI_DT, --交割日期
       T0.L_DIRECT_OPERATOR AS RELA_RRSN, --下达人
       T0.L_DIRECT_INSTEAD_OPERATOR AS AGT_RELA_RRSN, --代下达人
       T0.VC_SUMMARY AS MEMO, --备注
       NULL AS CONT_DAYS, --合约天数
       NULL AS INTA_DAYS, --计息天数
       NULL AS CONT_TNV_DT, --合约成交日期
       NULL AS CONT_END_DT, --合约到期日期
       NULL AS FIR_DELI_DT, --首期交割日期
       NULL AS END_DELI_DT, --到期交割日期
       NULL AS FIR_DELI_MODE, --首期交割方式
       NULL AS END_DELI_MODE, --到期交割方式
       NULL AS BUYB_VAL, --购回金额
       NULL AS INTR, --利息
       NULL AS IN_PRD_CODE, --转入产品代码
       NULL AS IN_AST_UNIT_CODE, --转入资产单元代码
       NULL AS IN_PFL_CODE, --转入投组代码
       NULL AS IN_INV_TYP, --转入投资类型
       NULL AS IN_SECU_ID, --转入证券编码
       NULL AS IN_SRC_SECU_ID, --转入源证券ID
       NULL AS IN_ODR_VOL, --转入指令数量
       NULL AS IN_ODR_PRC, --转入指令价格
       NULL AS IN_ODR_VAL, --转入指令金额
       T4.VC_RIVAL_SEAT AS CNTP_SEAT_CODE, --对手方席位号
       0 AS RES_FLAG, --限售标识
       NULL AS LOCK_LMT_CLAS, --锁定受限类型
       NULL AS LMT_CLAS_ONUM, --受限类型序号
       NULL AS AGMT_NUM, --合同号
       NULL AS BONS_MODE, --分红方式
       NULL AS PAY_DT, --缴款日期
       NULL AS CONT_MULT, --合约乘数
       NULL AS ARBI_FLAG, --套利标志
       NULL AS ESTI_CASH_DIFF, --预估现金差额
       NULL AS ETF_FND_CLAS, --ETF基金类型
       CASE
         WHEN T0.C_INSTRUCTION_STATUS IN ('5') THEN --审批拒绝
          '4'
         WHEN T0.C_INSTRUCTION_STATUS IN ('6') THEN --分发拒绝
          '5'
         ELSE
          T0.C_INSTRUCTION_STATUS
       END AS ODR_STAT, --指令状态
       ${current_date} AS BUSI_DATE, --业务日期
       'evt_exch_odr_real_2' AS TASK_RS_ID, --任务来源标识
	   CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_OPERATOR_NO AS DELR_ID, --交易员
	     T0.L_DATE	AS P_DT,
	     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TINSTRUCTION T0
 INNER JOIN ${ods_db}.O3_TINSTRUCTIONSTOCK T4
    ON T0.L_DATE = T4.L_DATE
   AND T0.L_DAILY_INSTRUCTION_NO = T4.L_DAILY_INSTRUCTION_NO
   AND T0.L_INDEX_DAILY_MODIFY = T4.L_INDEX_DAILY_MODIFY
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T4.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T4.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5
    ON T4.L_DATE = T5.L_DATE
   AND T4.VC_INTER_CODE = T5.VC_INTER_CODE
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T6
    ON T4.L_DATE = T6.L_DATE
   AND T5.VC_MATCH_RELATIVE2_CODE = T6.VC_INTER_CODE
 WHERE T0.C_BUSIN_CLASS IN ('1', 'I')
   AND T4.C_ENTRUST_DIRECTION IN ('U', 'T')
   AND T0.C_INSTRUCTION_STATUS IN ('1', '2', '3', '5', '6') --1:有效；2:已修改；3:已撤销；5:审批拒绝；6:分发拒绝
   AND T0.L_DATE = ${current_date}

UNION ALL
--指令：质押式回购
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       concat('0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '|0|0') AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY) AS ODR_ONUM, --指令序号
       T0.C_INSTRUCTION_TYPE AS ODR_CLAS, --指令类型
       T0.L_DIRECT_DATE AS ODR_RELA_DT, --指令下达日期
       T0.L_BEGIN_DATE AS ODR_STRT_DT, --指令开始日期
       T0.L_END_DATE AS ODR_END_DT, --指令结束日期
       T0.L_BEGIN_TIME AS ODR_STRT_TIME, --指令开始时间
       T0.L_END_TIME AS ODR_END_TIME, --指令结束时间
       T0.C_STOCK_TARGET_TYPE AS ODR_CTRL_CLAS, --指令控制类型
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY , '_' , T4.L_STOCK_SERIAL_NO) AS ODR_SECU_ONUM, --指令证券序号
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T4.L_BASECOMBI_ID , '_' , T5.VC_REPORT_CODE , '.REPO.' ,
       (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end) , '_' , (CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T4.C_INVEST_TYPE
       END) , '_' , '02000100') AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T4.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T4.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       '020001' AS BUSI_TYP, --业务类别
       '02000100' AS BUSI_CLAS, --业务类型
       concat(T5.VC_REPORT_CODE , '.REPO.' , (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end)) AS SECU_ID, --证券编码
       CASE
         WHEN T5.C_MARKET_NO = '1' THEN
          'SH'
         WHEN T5.C_MARKET_NO = '2' THEN
          'SZ'
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       CASE
         WHEN T4.C_ENTRUST_DIRECTION IN ('5') THEN
          'S'
         WHEN T4.C_ENTRUST_DIRECTION IN ('6') THEN
          'L'
       END AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       T4.L_SETTLE_SPEED AS CLR_SPED, --清算速度
       CASE
         WHEN T0.C_BUSIN_CLASS IN ('1', 'E') AND T5.C_MARKET_NO = '1' AND T0.L_DATE >= '20220512' THEN
	      'PLAT_NEW_BOND' --上海新债平台
         WHEN T0.C_BUSIN_CLASS IN ('1', 'E') AND T5.C_MARKET_NO = '2' AND T0.L_DATE >= '20220512' THEN
	      'PLAT_FIXINC' --深圳固收平台
         WHEN T0.C_BUSIN_CLASS IN ('1') AND T5.C_MARKET_NO = '1' THEN
          'PLAT_BID' --上海竞价平台
         WHEN T0.C_BUSIN_CLASS IN ('1') AND T5.C_MARKET_NO = '2' THEN
          'PLAT_BID' --深圳竞价平台
         WHEN T0.C_BUSIN_CLASS = 'E' AND T5.C_MARKET_NO = '1' THEN
          'PLAT_BULK' --上海大宗平台
         WHEN T0.C_BUSIN_CLASS = 'E' AND T5.C_MARKET_NO = '5' THEN
          'PLAT_BULK' --深圳大宗平台
       END AS TRD_PLFM, --交易平台
       NULL AS TRD_MODE,--交易方式
       T4.C_ENTRUST_DIRECTION AS ENTR_DIR, --委托方向
       CASE
         WHEN T4.C_PRICE_TYPE IN ('4', '5', '6') THEN
          '2'
         ELSE
          '1'
       END AS ODR_PRC_CLAS, --指令价格类型
       T4.EN_FACT_PRICE AS ODR_PRC, --指令价格
       CASE
         WHEN T4.C_PRICE_TYPE IN ('4', '5', '6') THEN
          T4.EN_DAY_AVG_PRICE / 100
         ELSE
          T4.EN_PRICE1 / 100
       END AS RAT, --利率
       T4.L_AMOUNT AS ODR_VOL, --指令数量
       T4.EN_BALANCE AS ODR_VAL, --指令金额
       T4.L_TOTAL_ENTRUST_AMOUNT AS BGNG_HAS_ENTR_VOL, --期初已委托数量
       T4.EN_TOTAL_ENTRUST_BALANCE AS BGNG_HAS_ENTR_VAL, --期初已委托金额
       T4.L_TOTAL_DEAL_AMOUNT AS BGNG_HAS_TNV_VOL, --期初已成交数量
       T4.EN_TOTAL_DEAL_BALANCE AS BGNG_HAS_TNV_VAL, --期初已成交金额
       T4.L_TODAY_ENTRUST_AMOUNT AS ENTR_VOL, --当日委托数量
       T4.EN_TODAY_ENTRUST_BALANCE AS ENTR_VAL, --当日委托金额
       T4.L_TODAY_DEAL_AMOUNT AS TNV_VOL, --当日成交数量
       T4.EN_TODAY_DEAL_BALANCE AS TNV_VAL, --当日成交金额
       T0.L_TRADE_RIVAL_NO AS TRD_CNTP_ID, --交易对手编码
       NULL AS APPT_NUM, --约定号
       NULL AS GUAR_SETT_FLAG, --担保交收标识
       NULL AS DELI_DT, --交割日期
       T0.L_DIRECT_OPERATOR AS RELA_RRSN, --下达人
       T0.L_DIRECT_INSTEAD_OPERATOR AS AGT_RELA_RRSN, --代下达人
       T0.VC_SUMMARY AS MEMO, --备注
       T0.L_HG_DAYS AS CONT_DAYS, --合约天数
       datediff(from_unixtime(unix_timestamp(cast(T0.L_SECOND_SETTLE_DATE as string),'yyyyMMdd'),'yyyy-MM-dd'),from_unixtime(unix_timestamp(cast(T0.L_FIRST_SETTLE_DATE as string),'yyyyMMdd'),'yyyy-MM-dd')) AS INTA_DAYS, --计息天数
       T0.L_DATE AS CONT_TNV_DT, --合约成交日期
       w1.pre_1_dt AS CONT_END_DT, --合约到期日期
       T0.L_FIRST_SETTLE_DATE AS FIR_DELI_DT, --首期交割日期
       T0.L_SECOND_SETTLE_DATE AS END_DELI_DT, --到期交割日期
       '3' AS FIR_DELI_MODE, --首期交割方式
       '3' AS END_DELI_MODE, --到期交割方式
       ROUND(T4.EN_BALANCE +
             (datediff(from_unixtime(unix_timestamp(cast(T0.L_SECOND_SETTLE_DATE as string),'yyyyMMdd'),'yyyy-MM-dd'),from_unixtime(unix_timestamp(cast(T0.L_FIRST_SETTLE_DATE as string),'yyyyMMdd'),'yyyy-MM-dd'))
			 ) * (CASE
               WHEN T4.C_PRICE_TYPE IN ('4', '5', '6') THEN
                cast(T4.EN_DAY_AVG_PRICE as double)
               ELSE
                cast(T4.EN_PRICE1 as double)
             END) / 100 / 365 * cast(T4.EN_BALANCE as double),
             2) AS BUYB_VAL, --购回金额
       ROUND((datediff(from_unixtime(unix_timestamp(cast(T0.L_SECOND_SETTLE_DATE as string),'yyyyMMdd'),'yyyy-MM-dd'),from_unixtime(unix_timestamp(cast(T0.L_FIRST_SETTLE_DATE as string),'yyyyMMdd'),'yyyy-MM-dd'))
			 ) * (CASE
               WHEN T4.C_PRICE_TYPE IN ('4', '5', '6') THEN
                    cast(T4.EN_DAY_AVG_PRICE as double)
               ELSE
                    cast(T4.EN_PRICE1 as double)
             END) / 100 / 365 * cast(T4.EN_BALANCE as double),
             2) AS INTR, --利息
       NULL AS IN_PRD_CODE, --转入产品代码
       NULL AS IN_AST_UNIT_CODE, --转入资产单元代码
       NULL AS IN_PFL_CODE, --转入投组代码
       NULL AS IN_INV_TYP, --转入投资类型
       NULL AS IN_SECU_ID, --转入证券编码
       NULL AS IN_SRC_SECU_ID, --转入源证券ID
       NULL AS IN_ODR_VOL, --转入指令数量
       NULL AS IN_ODR_PRC, --转入指令价格
       NULL AS IN_ODR_VAL, --转入指令金额
       T4.VC_RIVAL_SEAT AS CNTP_SEAT_CODE, --对手方席位号
       0 AS RES_FLAG, --限售标识
       NULL AS LOCK_LMT_CLAS, --锁定受限类型
       NULL AS LMT_CLAS_ONUM, --受限类型序号
       NULL AS AGMT_NUM, --合同号
       NULL AS BONS_MODE, --分红方式
       NULL AS PAY_DT, --缴款日期
       NULL AS CONT_MULT, --合约乘数
       NULL AS ARBI_FLAG, --套利标志
       NULL AS ESTI_CASH_DIFF, --预估现金差额
       NULL AS ETF_FND_CLAS, --ETF基金类型
       CASE
         WHEN T0.C_INSTRUCTION_STATUS IN ('5') THEN --审批拒绝
          '4'
         WHEN T0.C_INSTRUCTION_STATUS IN ('6') THEN --分发拒绝
          '5'
         ELSE
          T0.C_INSTRUCTION_STATUS
       END AS ODR_STAT, --指令状态
       ${current_date} AS BUSI_DATE, --业务日期
       'evt_exch_odr_real_3' AS TASK_RS_ID, --任务来源标识
	   CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_OPERATOR_NO AS DELR_ID, --交易员
	     T0.L_DATE	AS P_DT,
	     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TINSTRUCTION T0
 INNER JOIN ${ods_db}.O3_TINSTRUCTIONSTOCK T4
    ON T0.L_DATE = T4.L_DATE
   AND T0.L_DAILY_INSTRUCTION_NO = T4.L_DAILY_INSTRUCTION_NO
   AND T0.L_INDEX_DAILY_MODIFY = T4.L_INDEX_DAILY_MODIFY
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T4.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T4.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5
    ON T4.L_DATE = T5.L_DATE
   AND T4.VC_INTER_CODE = T5.VC_INTER_CODE
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
    ON T0.L_SECOND_SETTLE_DATE = w1.dt
   AND T5.C_MARKET_NO = w1.mkt_no
   AND W1.SYS_RS_ID = 'O3'
 WHERE T0.C_BUSIN_CLASS IN ('1', 'I')
   AND T4.C_ENTRUST_DIRECTION IN ('5', '6', '7', '8')
   AND T0.C_INSTRUCTION_STATUS IN ('1', '2', '3', '5', '6') --1:有效；2:已修改；3:已撤销；5:审批拒绝；6:分发拒绝
   AND T0.L_DATE = ${current_date}

UNION ALL
--指令：配股/债/上交所老股东配售（通过识别当天有无增发代码）
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       concat('0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '|0|0') AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY) AS ODR_ONUM, --指令序号
       T0.C_INSTRUCTION_TYPE AS ODR_CLAS, --指令类型
       T0.L_DIRECT_DATE AS ODR_RELA_DT, --指令下达日期
       T0.L_BEGIN_DATE AS ODR_STRT_DT, --指令开始日期
       T0.L_END_DATE AS ODR_END_DT, --指令结束日期
       T0.L_BEGIN_TIME AS ODR_STRT_TIME, --指令开始时间
       T0.L_END_TIME AS ODR_END_TIME, --指令结束时间
       T0.C_STOCK_TARGET_TYPE AS ODR_CTRL_CLAS, --指令控制类型
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY , '_' , T4.L_STOCK_SERIAL_NO) AS ODR_SECU_ONUM, --指令证券序号
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T4.L_BASECOMBI_ID , '_' , (CASE
         WHEN T6.C_ASSET_CLASS = '2' or T6.C_STOCK_TYPE IN ('a') THEN --股票
          concat(T6.VC_REPORT_CODE , '.STK.' , (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end))
         WHEN T6.C_ASSET_CLASS = '3' THEN --债券
          concat(T6.VC_REPORT_CODE , '.BOND.' , (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end))
       END) , '_' , (CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T4.C_INVEST_TYPE
       END) , '_' , (CASE
         WHEN T7.L_DATE IS NULL THEN
          '06000100' --配股\配债
         ELSE
          '05070100' --老股东配售
       END)) AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T4.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T4.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       CASE
         WHEN T7.L_DATE IS NULL THEN
          '060001' --配股\配债
         ELSE
          '050701' --老股东配售
       END AS BUSI_TYP, --业务类别
       CASE
         WHEN T7.L_DATE IS NULL THEN
          '06000100' --配股\配债
         ELSE
          '05070100' --老股东配售
       END AS BUSI_CLAS, --业务类型
       CASE
         WHEN T6.C_ASSET_CLASS = '2' or T6.C_STOCK_TYPE IN ('a') THEN --股票
          concat(T6.VC_REPORT_CODE , '.STK.' , (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end))
         WHEN T6.C_ASSET_CLASS = '3' THEN --债券
          concat(T6.VC_REPORT_CODE , '.BOND.' , (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end))
       END AS SECU_ID, --证券编码
       CASE
         WHEN T5.C_MARKET_NO = '1' THEN
          'SH'
         WHEN T5.C_MARKET_NO = '2' THEN
          'SZ'
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T6.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       CASE
         WHEN SUBSTR(T6.VC_INTER_CODE, 1, 1) NOT IN ('0', '3', '6') AND
              T5.C_MARKET_NO = '1' THEN
          2 --上交所配债
         ELSE
          1 --深交所配债、深交所配股、上交所老股东配售，由于上交所配股推算交割日期，暂定1
       END AS CLR_SPED, --清算速度
       'PLAT_BID' AS TRD_PLFM, --交易平台
	   NULL AS TRD_MODE,--交易方式
       CASE
         WHEN T7.L_DATE IS NULL THEN
          '9' --配股\配债
         ELSE
          '12' --老股东配售
       END AS ENTR_DIR, --委托方向
       CASE
         WHEN T4.C_PRICE_TYPE IN ('4', '5', '6') THEN
          '2'
         ELSE
          '1'
       END AS ODR_PRC_CLAS, --指令价格类型
       case when T4.EN_PRICE1 = 0 then T4.EN_FACT_PRICE else T4.EN_PRICE1 end AS ODR_PRC, --指令价格
       NULL AS RAT, --利率
       T4.L_AMOUNT AS ODR_VOL, --指令数量
       T4.EN_BALANCE AS ODR_VAL, --指令金额
       T4.L_TOTAL_ENTRUST_AMOUNT AS BGNG_HAS_ENTR_VOL, --期初已委托数量
       T4.EN_TOTAL_ENTRUST_BALANCE AS BGNG_HAS_ENTR_VAL, --期初已委托金额
       T4.L_TOTAL_DEAL_AMOUNT AS BGNG_HAS_TNV_VOL, --期初已成交数量
       T4.EN_TOTAL_DEAL_BALANCE AS BGNG_HAS_TNV_VAL, --期初已成交金额
       T4.L_TODAY_ENTRUST_AMOUNT AS ENTR_VOL, --当日委托数量
       T4.EN_TODAY_ENTRUST_BALANCE AS ENTR_VAL, --当日委托金额
       T4.L_TODAY_DEAL_AMOUNT AS TNV_VOL, --当日成交数量
       T4.EN_TODAY_DEAL_BALANCE AS TNV_VAL, --当日成交金额
       T0.L_TRADE_RIVAL_NO AS TRD_CNTP_ID, --交易对手编码
       NULL AS APPT_NUM, --约定号
       NULL AS GUAR_SETT_FLAG, --担保交收标识
       CASE
         WHEN SUBSTR(T6.VC_INTER_CODE, 1, 1) NOT IN ('0', '3', '6') AND
              T5.C_MARKET_NO = '1' THEN --上交所配债
          w1.aft_2_dt
         WHEN T5.C_MARKET_NO = '2' THEN --深交所配股/债
          w1.aft_1_dt
         WHEN T7.L_DATE IS NULL THEN --上交所老股东配售
          w1.aft_1_dt
         ELSE --上交所配股
          GREATEST(T0.L_BEGIN_DATE, T0.L_DATE)
       END AS DELI_DT, --交割日期
       T0.L_DIRECT_OPERATOR AS RELA_RRSN, --下达人
       T0.L_DIRECT_INSTEAD_OPERATOR AS AGT_RELA_RRSN, --代下达人
       T0.VC_SUMMARY AS MEMO, --备注
       NULL AS CONT_DAYS, --合约天数
       NULL AS INTA_DAYS, --计息天数
       NULL AS CONT_TNV_DT, --合约成交日期
       NULL AS CONT_END_DT, --合约到期日期
       NULL AS FIR_DELI_DT, --首期交割日期
       NULL AS END_DELI_DT, --到期交割日期
       NULL AS FIR_DELI_MODE, --首期交割方式
       NULL AS END_DELI_MODE, --到期交割方式
       NULL AS BUYB_VAL, --购回金额
       NULL AS INTR, --利息
       NULL AS IN_PRD_CODE, --转入产品代码
       NULL AS IN_AST_UNIT_CODE, --转入资产单元代码
       NULL AS IN_PFL_CODE, --转入投组代码
       NULL AS IN_INV_TYP, --转入投资类型
       NULL AS IN_SECU_ID, --转入证券编码
       NULL AS IN_SRC_SECU_ID, --转入源证券ID
       NULL AS IN_ODR_VOL, --转入指令数量
       NULL AS IN_ODR_PRC, --转入指令价格
       NULL AS IN_ODR_VAL, --转入指令金额
       T4.VC_RIVAL_SEAT AS CNTP_SEAT_CODE, --对手方席位号
       0 AS RES_FLAG, --限售标识
       NULL AS LOCK_LMT_CLAS, --锁定受限类型
       NULL AS LMT_CLAS_ONUM, --受限类型序号
       NULL AS AGMT_NUM, --合同号
       NULL AS BONS_MODE, --分红方式
       CASE
         WHEN SUBSTR(T6.VC_INTER_CODE, 1, 1) NOT IN ('0', '3', '6') AND
              T5.C_MARKET_NO = '1' THEN --上交所配债
          w1.aft_1_dt
         WHEN T5.C_MARKET_NO = '2' THEN --深交所配股/债
          GREATEST(T0.L_BEGIN_DATE, T0.L_DATE)
         WHEN T7.L_DATE IS NULL THEN --上交所老股东配售
          GREATEST(T0.L_BEGIN_DATE, T0.L_DATE)
         ELSE --上交所配股
          GREATEST(T0.L_BEGIN_DATE, T0.L_DATE)
       END AS PAY_DT, --缴款日期
       NULL AS CONT_MULT, --合约乘数
       NULL AS ARBI_FLAG, --套利标志
       NULL AS ESTI_CASH_DIFF, --预估现金差额
       NULL AS ETF_FND_CLAS, --ETF基金类型
       CASE
         WHEN T0.C_INSTRUCTION_STATUS IN ('5') THEN --审批拒绝
          '4'
         WHEN T0.C_INSTRUCTION_STATUS IN ('6') THEN --分发拒绝
          '5'
         ELSE
          T0.C_INSTRUCTION_STATUS
       END AS ODR_STAT, --指令状态
       ${current_date} AS BUSI_DATE, --业务日期
       'evt_exch_odr_real_4' AS TASK_RS_ID, --任务来源标识
	   CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_OPERATOR_NO AS DELR_ID, --交易员
	     T0.L_DATE	AS P_DT,
	     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TINSTRUCTION T0
 INNER JOIN ${ods_db}.O3_TINSTRUCTIONSTOCK T4
    ON T0.L_DATE = T4.L_DATE
   AND T0.L_DAILY_INSTRUCTION_NO = T4.L_DAILY_INSTRUCTION_NO
   AND T0.L_INDEX_DAILY_MODIFY = T4.L_INDEX_DAILY_MODIFY
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T4.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T4.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5
    ON T4.L_DATE = T5.L_DATE
   AND T4.VC_INTER_CODE = T5.VC_INTER_CODE
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T6 --证券基本信息表，获取正式代码
    ON T5.L_DATE = T6.L_DATE
   AND T5.VC_ASSET_RELATIVE_CODE = T6.VC_INTER_CODE
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T7 --证券基本信息表,判断是否有增发代码
    ON T4.L_DATE = T7.L_DATE
   AND T5.VC_ASSET_RELATIVE_CODE = T7.VC_ASSET_RELATIVE_CODE
   AND T7.C_STOCK_TYPE IN ('d')
   AND T7.C_STOP_FLAG = '2'
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
    ON GREATEST(T0.L_BEGIN_DATE, T0.L_DATE) = w1.dt
   AND T5.C_MARKET_NO = w1.mkt_no
   AND W1.SYS_RS_ID = 'O3'
 WHERE T0.C_BUSIN_CLASS IN ('1')
   AND T4.C_ENTRUST_DIRECTION IN ('9')
   AND T0.C_INSTRUCTION_STATUS IN ('1', '2', '3', '5', '6') --1:有效；2:已修改；3:已撤销；5:审批拒绝；6:分发拒绝
   AND T0.L_DATE = ${current_date}

 UNION ALL
--指令：网上新股\新债
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       concat('0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '|0|0') AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY) AS ODR_ONUM, --指令序号
       T0.C_INSTRUCTION_TYPE AS ODR_CLAS, --指令类型
       T0.L_DIRECT_DATE AS ODR_RELA_DT, --指令下达日期
       T0.L_BEGIN_DATE AS ODR_STRT_DT, --指令开始日期
       T0.L_END_DATE AS ODR_END_DT, --指令结束日期
       T0.L_BEGIN_TIME AS ODR_STRT_TIME, --指令开始时间
       T0.L_END_TIME AS ODR_END_TIME, --指令结束时间
       T0.C_STOCK_TARGET_TYPE AS ODR_CTRL_CLAS, --指令控制类型
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY , '_' , T4.L_STOCK_SERIAL_NO) AS ODR_SECU_ONUM, --指令证券序号
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T4.L_BASECOMBI_ID , '_' , (CASE
         WHEN T6.C_ASSET_CLASS IN ('2') OR T6.C_STOCK_TYPE = 'a' THEN --股票
          concat(T6.VC_REPORT_CODE , '.STK.' , (case when T6.C_MARKET_NO = '1' then 'SH' when T6.C_MARKET_NO = '2' then 'SZ' end))
         WHEN T6.C_ASSET_CLASS = '3'  OR T6.C_STOCK_TYPE = 'k' THEN --债券
          concat(T6.VC_REPORT_CODE , '.BOND.' , (case when T6.C_MARKET_NO = '1' then 'SH' when T6.C_MARKET_NO = '2' then 'SZ' end))
       END) , '_' , (CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T4.C_INVEST_TYPE
       END) , '_' , '05000100') AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T4.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T4.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       '050001' AS BUSI_TYP, --业务类别
       '05000100' AS BUSI_CLAS, --业务类型
       CASE
         WHEN T6.C_ASSET_CLASS IN ('2') OR T6.C_STOCK_TYPE = 'a' THEN --股票
          concat(T6.VC_REPORT_CODE , '.STK.' , (case when T6.C_MARKET_NO = '1' then 'SH' when T6.C_MARKET_NO = '2' then 'SZ' end))
         WHEN T6.C_ASSET_CLASS = '3'  OR T6.C_STOCK_TYPE = 'k' THEN --债券
          concat(T6.VC_REPORT_CODE , '.BOND.' , (case when T6.C_MARKET_NO = '1' then 'SH' when T6.C_MARKET_NO = '2' then 'SZ' end))
       END AS SECU_ID, --证券编码
       CASE
         WHEN T5.C_MARKET_NO = '1' THEN
          'SH'
         WHEN T5.C_MARKET_NO = '2' THEN
          'SZ'
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T6.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       3 AS CLR_SPED, --清算速度
       CASE
         WHEN T0.C_BUSIN_CLASS IN ('1') THEN
          'PLAT_BID'
       END AS TRD_PLFM, --交易平台
	   NULL AS TRD_MODE, --交易方式
       '12' AS ENTR_DIR, --委托方向
       CASE
         WHEN T4.C_PRICE_TYPE IN ('4', '5', '6') THEN
          '2'
         ELSE
          '1'
       END AS ODR_PRC_CLAS, --指令价格类型
       case when T4.EN_PRICE1 = 0 then T4.EN_FACT_PRICE else T4.EN_PRICE1 end AS ODR_PRC, --指令价格
       NULL AS RAT, --利率
       T4.L_AMOUNT AS ODR_VOL, --指令数量
       T4.EN_BALANCE AS ODR_VAL, --指令金额
       T4.L_TOTAL_ENTRUST_AMOUNT AS BGNG_HAS_ENTR_VOL, --期初已委托数量
       T4.EN_TOTAL_ENTRUST_BALANCE AS BGNG_HAS_ENTR_VAL, --期初已委托金额
       T4.L_TOTAL_DEAL_AMOUNT AS BGNG_HAS_TNV_VOL, --期初已成交数量
       T4.EN_TOTAL_DEAL_BALANCE AS BGNG_HAS_TNV_VAL, --期初已成交金额
       T4.L_TODAY_ENTRUST_AMOUNT AS ENTR_VOL, --当日委托数量
       T4.EN_TODAY_ENTRUST_BALANCE AS ENTR_VAL, --当日委托金额
       T4.L_TODAY_DEAL_AMOUNT AS TNV_VOL, --当日成交数量
       T4.EN_TODAY_DEAL_BALANCE AS TNV_VAL, --当日成交金额
       T0.L_TRADE_RIVAL_NO AS TRD_CNTP_ID, --交易对手编码
       NULL AS APPT_NUM, --约定号
       NULL AS GUAR_SETT_FLAG, --担保交收标识
       w1.aft_3_dt AS DELI_DT, --交割日期
       T0.L_DIRECT_OPERATOR AS RELA_RRSN, --下达人
       T0.L_DIRECT_INSTEAD_OPERATOR AS AGT_RELA_RRSN, --代下达人
       T0.VC_SUMMARY AS MEMO, --备注
       NULL AS CONT_DAYS, --合约天数
       NULL AS INTA_DAYS, --计息天数
       NULL AS CONT_TNV_DT, --合约成交日期
       NULL AS CONT_END_DT, --合约到期日期
       NULL AS FIR_DELI_DT, --首期交割日期
       NULL AS END_DELI_DT, --到期交割日期
       NULL AS FIR_DELI_MODE, --首期交割方式
       NULL AS END_DELI_MODE, --到期交割方式
       NULL AS BUYB_VAL, --购回金额
       NULL AS INTR, --利息
       NULL AS IN_PRD_CODE, --转入产品代码
       NULL AS IN_AST_UNIT_CODE, --转入资产单元代码
       NULL AS IN_PFL_CODE, --转入投组代码
       NULL AS IN_INV_TYP, --转入投资类型
       NULL AS IN_SECU_ID, --转入证券编码
       NULL AS IN_SRC_SECU_ID, --转入源证券ID
       NULL AS IN_ODR_VOL, --转入指令数量
       NULL AS IN_ODR_PRC, --转入指令价格
       NULL AS IN_ODR_VAL, --转入指令金额
       T4.VC_RIVAL_SEAT AS CNTP_SEAT_CODE, --对手方席位号
       0 AS RES_FLAG, --限售标识
       NULL AS LOCK_LMT_CLAS, --锁定受限类型
       NULL AS LMT_CLAS_ONUM, --受限类型序号
       NULL AS AGMT_NUM, --合同号
       NULL AS BONS_MODE, --分红方式
       w1.aft_2_dt AS PAY_DT, --缴款日期
       NULL AS CONT_MULT, --合约乘数
       NULL AS ARBI_FLAG, --套利标志
       NULL AS ESTI_CASH_DIFF, --预估现金差额
       NULL AS ETF_FND_CLAS, --ETF基金类型
       CASE
         WHEN T0.C_INSTRUCTION_STATUS IN ('5') THEN --审批拒绝
          '4'
         WHEN T0.C_INSTRUCTION_STATUS IN ('6') THEN --分发拒绝
          '5'
         ELSE
          T0.C_INSTRUCTION_STATUS
       END AS ODR_STAT, --指令状态
       ${current_date} AS BUSI_DATE, --业务日期
       'evt_exch_odr_real_5' AS TASK_RS_ID, --任务来源标识
	   CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_OPERATOR_NO AS DELR_ID, --交易员
	     T0.L_DATE	AS P_DT,
	     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TINSTRUCTION T0
 INNER JOIN ${ods_db}.O3_TINSTRUCTIONSTOCK T4
    ON T0.L_DATE = T4.L_DATE
   AND T0.L_DAILY_INSTRUCTION_NO = T4.L_DAILY_INSTRUCTION_NO
   AND T0.L_INDEX_DAILY_MODIFY = T4.L_INDEX_DAILY_MODIFY
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T4.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T4.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5
    ON T4.L_DATE = T5.L_DATE
   AND T4.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.C_ASSET_CLASS IN ('2', '3', '6')
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T6 --证券基本信息表，获取正式代码
    ON T5.L_DATE = T6.L_DATE
   AND T5.VC_ASSET_RELATIVE_CODE = T6.VC_INTER_CODE
   AND T6.C_ASSET_CLASS IN ('2', '3','6')
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
    ON GREATEST(T0.L_BEGIN_DATE, T0.L_DATE) = w1.dt
   AND T5.C_MARKET_NO = w1.mkt_no
   AND W1.SYS_RS_ID = 'O3'
 WHERE T0.C_BUSIN_CLASS IN ('1', 'I')
   AND T4.C_ENTRUST_DIRECTION IN ('C')
   AND T0.C_INSTRUCTION_STATUS IN ('1', '2', '3', '5', '6') --1:有效；2:已修改；3:已撤销；5:审批拒绝；6:分发拒绝
   AND T5.C_STOCK_TYPE NOT IN ('d','27') --d:普通股增发\27：存托凭证增发
   AND T0.L_DATE = ${current_date}

UNION ALL
--指令：预受要约\预受要约撤销
SELECT '1' AS BUSI_SYS_ID,--业务系统编码
       concat('0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '|0|0') AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY) AS ODR_ONUM, --指令序号
       T0.C_INSTRUCTION_TYPE AS ODR_CLAS, --指令类型
       T0.L_DIRECT_DATE AS ODR_RELA_DT, --指令下达日期
       T0.L_BEGIN_DATE AS ODR_STRT_DT, --指令开始日期
       T0.L_END_DATE AS ODR_END_DT, --指令结束日期
       T0.L_BEGIN_TIME AS ODR_STRT_TIME, --指令开始时间
       T0.L_END_TIME AS ODR_END_TIME, --指令结束时间
       T0.C_STOCK_TARGET_TYPE AS ODR_CTRL_CLAS, --指令控制类型
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY , '_' , T4.L_STOCK_SERIAL_NO) AS ODR_SECU_ONUM, --指令证券序号
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T4.L_BASECOMBI_ID , '_' , T6.VC_REPORT_CODE , '.STK.' ,
       (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end) , '_' , (CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T4.C_INVEST_TYPE
       END) , '_' , (CASE
         WHEN T4.C_ENTRUST_DIRECTION = '0' THEN
          '07000100'
         WHEN T4.C_ENTRUST_DIRECTION = 'b' THEN
          '07000101'
       END)) AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T4.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T4.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       '070001' AS BUSI_TYP, --业务类别
       CASE
         WHEN T4.C_ENTRUST_DIRECTION = '0' THEN
          '07000100'
         WHEN T4.C_ENTRUST_DIRECTION = 'b' THEN
          '07000101'
       END AS BUSI_CLAS, --业务类型
       concat(T6.VC_REPORT_CODE , '.STK.' , (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end)) AS SECU_ID, --证券编码
       CASE
         WHEN T5.C_MARKET_NO = '1' THEN
          'SH'
         WHEN T5.C_MARKET_NO = '2' THEN
          'SZ'
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T6.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       0 AS CLR_SPED, --清算速度
       'PLAT_BID' AS TRD_PLFM, --交易平台
	   NULL AS TRD_MODE,--交易方式
       CASE
         WHEN T4.C_ENTRUST_DIRECTION = '0' THEN
          '66'
         WHEN T4.C_ENTRUST_DIRECTION = 'b' THEN
          '38'
       END AS ENTR_DIR, --委托方向
       CASE
         WHEN T4.C_PRICE_TYPE IN ('4', '5', '6') THEN
          '2'
         ELSE
          '1'
       END AS ODR_PRC_CLAS, --指令价格类型
       CASE
         WHEN T5.C_MARKET_NO = '1' THEN
          T4.EN_PRICE1
         WHEN T5.C_MARKET_NO = '2' THEN
          T7.EN_OFFERINGPRICE
       END AS ODR_PRC, --指令价格
       NULL AS RAT, --利率
       T4.L_AMOUNT AS ODR_VOL, --指令数量
       CASE
         WHEN T5.C_MARKET_NO = '1' THEN
          cast(T4.EN_PRICE1 as double) * cast(T4.L_AMOUNT as double)
         WHEN T5.C_MARKET_NO = '2' THEN
          cast(T7.EN_OFFERINGPRICE as double) * cast(T4.L_AMOUNT as double)
       END AS ODR_VAL, --指令金额
       T4.L_TOTAL_ENTRUST_AMOUNT AS BGNG_HAS_ENTR_VOL, --期初已委托数量
       T4.EN_TOTAL_ENTRUST_BALANCE AS BGNG_HAS_ENTR_VAL, --期初已委托金额
       T4.L_TOTAL_DEAL_AMOUNT AS BGNG_HAS_TNV_VOL, --期初已成交数量
       T4.EN_TOTAL_DEAL_BALANCE AS BGNG_HAS_TNV_VAL, --期初已成交金额
       T4.L_TODAY_ENTRUST_AMOUNT AS ENTR_VOL, --当日委托数量
       T4.EN_TODAY_ENTRUST_BALANCE AS ENTR_VAL, --当日委托金额
       T4.L_TODAY_DEAL_AMOUNT AS TNV_VOL, --当日成交数量
       T4.EN_TODAY_DEAL_BALANCE AS TNV_VAL, --当日成交金额
       CASE
         WHEN T5.C_MARKET_NO = '1' THEN
          T0.L_TRADE_RIVAL_NO
         WHEN T5.C_MARKET_NO = '2' THEN
          cast(T7.VC_TENDERER_ID as bigint)
       END AS TRD_CNTP_ID, --交易对手编码
       NULL AS APPT_NUM, --约定号
       NULL AS GUAR_SETT_FLAG, --担保交收标识
       GREATEST(T0.L_BEGIN_DATE, T0.L_DATE) AS DELI_DT, --交割日期
       T0.L_DIRECT_OPERATOR AS RELA_RRSN, --下达人
       T0.L_DIRECT_INSTEAD_OPERATOR AS AGT_RELA_RRSN, --代下达人
       T0.VC_SUMMARY AS MEMO, --备注
       NULL AS CONT_DAYS, --合约天数
       NULL AS INTA_DAYS, --计息天数
       NULL AS CONT_TNV_DT, --合约成交日期
       NULL AS CONT_END_DT, --合约到期日期
       NULL AS FIR_DELI_DT, --首期交割日期
       NULL AS END_DELI_DT, --到期交割日期
       NULL AS FIR_DELI_MODE, --首期交割方式
       NULL AS END_DELI_MODE, --到期交割方式
       NULL AS BUYB_VAL, --购回金额
       NULL AS INTR, --利息
       NULL AS IN_PRD_CODE, --转入产品代码
       NULL AS IN_AST_UNIT_CODE, --转入资产单元代码
       NULL AS IN_PFL_CODE, --转入投组代码
       NULL AS IN_INV_TYP, --转入投资类型
       NULL AS IN_SECU_ID, --转入证券编码
       NULL AS IN_SRC_SECU_ID, --转入源证券ID
       NULL AS IN_ODR_VOL, --转入指令数量
       NULL AS IN_ODR_PRC, --转入指令价格
       NULL AS IN_ODR_VAL, --转入指令金额
       T4.VC_RIVAL_SEAT AS CNTP_SEAT_CODE, --对手方席位号
       0 AS RES_FLAG, --限售标识
       NULL AS LOCK_LMT_CLAS, --锁定受限类型
       NULL AS LMT_CLAS_ONUM, --受限类型序号
       NULL AS AGMT_NUM, --合同号
       NULL AS BONS_MODE, --分红方式
       NULL AS PAY_DT, --缴款日期
       NULL AS CONT_MULT, --合约乘数
       NULL AS ARBI_FLAG, --套利标志
       NULL AS ESTI_CASH_DIFF, --预估现金差额
       NULL AS ETF_FND_CLAS, --ETF基金类型
       CASE
         WHEN T0.C_INSTRUCTION_STATUS IN ('5') THEN --审批拒绝
          '4'
         WHEN T0.C_INSTRUCTION_STATUS IN ('6') THEN --分发拒绝
          '5'
         ELSE
          T0.C_INSTRUCTION_STATUS
       END AS ODR_STAT, --指令状态
       ${current_date} AS BUSI_DATE, --业务日期
       'evt_exch_odr_real_6' AS TASK_RS_ID, --任务来源标识
	   CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_OPERATOR_NO AS DELR_ID, --交易员
	     T0.L_DATE	AS P_DT,
	      'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TINSTRUCTION T0
 INNER JOIN ${ods_db}.O3_TINSTRUCTIONSTOCK T4
    ON T0.L_DATE = T4.L_DATE
   AND T0.L_DAILY_INSTRUCTION_NO = T4.L_DAILY_INSTRUCTION_NO
   AND T0.L_INDEX_DAILY_MODIFY = T4.L_INDEX_DAILY_MODIFY
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T4.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T4.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5
    ON T4.L_DATE = T5.L_DATE
   AND T4.VC_INTER_CODE = T5.VC_INTER_CODE
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T6
    ON T4.L_DATE = T6.L_DATE
   AND T5.VC_ASSET_RELATIVE_CODE = T6.VC_INTER_CODE
  LEFT JOIN ${ods_db}.O3_TPREACCEPTEDOFFERS T7
    ON cast(T4.EN_PRICE1 as string) = T7.VC_TENDERER_ID
   AND T4.VC_INTER_CODE = T7.VC_INTER_CODE
 WHERE T0.C_BUSIN_CLASS IN ('1')
   AND T4.C_ENTRUST_DIRECTION IN ('b', '0')
   AND T0.C_INSTRUCTION_STATUS IN ('1', '2', '3', '5', '6') --1:有效；2:已修改；3:已撤销；5:审批拒绝；6:分发拒绝
   AND T0.L_DATE = ${current_date}

UNION ALL
--指令：债回售申报
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       concat('0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '|0|0') AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY) AS ODR_ONUM, --指令序号
       T0.C_INSTRUCTION_TYPE AS ODR_CLAS, --指令类型
       T0.L_DIRECT_DATE AS ODR_RELA_DT, --指令下达日期
       T0.L_BEGIN_DATE AS ODR_STRT_DT, --指令开始日期
       T0.L_END_DATE AS ODR_END_DT, --指令结束日期
       T0.L_BEGIN_TIME AS ODR_STRT_TIME, --指令开始时间
       T0.L_END_TIME AS ODR_END_TIME, --指令结束时间
       T0.C_STOCK_TARGET_TYPE AS ODR_CTRL_CLAS, --指令控制类型
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY , '_' , T4.L_STOCK_SERIAL_NO) AS ODR_SECU_ONUM, --指令证券序号
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T4.L_BASECOMBI_ID , '_' , T6.VC_REPORT_CODE , '.BOND.' ,
       (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end) , '_' , (CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T4.C_INVEST_TYPE
       END) , '_' , ('08000100')) AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T4.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T4.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       '080001' AS BUSI_TYP, --业务类别
       '08000100' AS BUSI_CLAS, --业务类型
       concat(T6.VC_REPORT_CODE , '.BOND.' , (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end)) AS SECU_ID, --证券编码
       CASE
         WHEN T5.C_MARKET_NO = '1' THEN
          'SH'
         WHEN T5.C_MARKET_NO = '2' THEN
          'SZ'
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T6.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       0 AS CLR_SPED, --清算速度
       CASE
         WHEN T0.C_BUSIN_CLASS IN ('1') THEN
          'PLAT_BID'
         WHEN T0.C_BUSIN_CLASS = 'I' THEN
          'PLAT_FIXINC'
         WHEN T0.C_BUSIN_CLASS = 'E' AND T5.C_MARKET_NO = '1' THEN
          'PLAT_BULK'
         WHEN T0.C_BUSIN_CLASS = 'E' AND T5.C_MARKET_NO = '2' THEN
          'PLAT_INTS'
       END AS TRD_PLFM, --交易平台
	   NULL AS TRD_MODE,--交易方式
       '11' AS ENTR_DIR, --委托方向
       CASE
         WHEN T4.C_PRICE_TYPE IN ('4', '5', '6') THEN
          '2'
         ELSE
          '1'
       END AS ODR_PRC_CLAS, --指令价格类型
       T7.EN_CURR_FACE_PRICE AS ODR_PRC, --指令价格
       NULL AS RAT, --利率
       T4.L_AMOUNT AS ODR_VOL, --指令数量
       cast(T4.L_AMOUNT as double) * cast(T7.EN_CURR_FACE_PRICE as double) AS ODR_VAL, --指令金额
       T4.L_TOTAL_ENTRUST_AMOUNT AS BGNG_HAS_ENTR_VOL, --期初已委托数量
       T4.EN_TOTAL_ENTRUST_BALANCE AS BGNG_HAS_ENTR_VAL, --期初已委托金额
       T4.L_TOTAL_DEAL_AMOUNT AS BGNG_HAS_TNV_VOL, --期初已成交数量
       T4.EN_TOTAL_DEAL_BALANCE AS BGNG_HAS_TNV_VAL, --期初已成交金额
       T4.L_TODAY_ENTRUST_AMOUNT AS ENTR_VOL, --当日委托数量
       T4.EN_TODAY_ENTRUST_BALANCE AS ENTR_VAL, --当日委托金额
       T4.L_TODAY_DEAL_AMOUNT AS TNV_VOL, --当日成交数量
       T4.EN_TODAY_DEAL_BALANCE AS TNV_VAL, --当日成交金额
       T0.L_TRADE_RIVAL_NO AS TRD_CNTP_ID, --交易对手编码
       NULL AS APPT_NUM, --约定号
       NULL AS GUAR_SETT_FLAG, --担保交收标识
       GREATEST(T0.L_BEGIN_DATE,T0.L_DATE) AS DELI_DT, --交割日期
       T0.L_DIRECT_OPERATOR AS RELA_RRSN, --下达人
       T0.L_DIRECT_INSTEAD_OPERATOR AS AGT_RELA_RRSN, --代下达人
       T0.VC_SUMMARY AS MEMO, --备注
       NULL AS CONT_DAYS, --合约天数
       NULL AS INTA_DAYS, --计息天数
       NULL AS CONT_TNV_DT, --合约成交日期
       NULL AS CONT_END_DT, --合约到期日期
       NULL AS FIR_DELI_DT, --首期交割日期
       NULL AS END_DELI_DT, --到期交割日期
       NULL AS FIR_DELI_MODE, --首期交割方式
       NULL AS END_DELI_MODE, --到期交割方式
       NULL AS BUYB_VAL, --购回金额
       NULL AS INTR, --利息
       NULL AS IN_PRD_CODE, --转入产品代码
       NULL AS IN_AST_UNIT_CODE, --转入资产单元代码
       NULL AS IN_PFL_CODE, --转入投组代码
       NULL AS IN_INV_TYP, --转入投资类型
       NULL AS IN_SECU_ID, --转入证券编码
       NULL AS IN_SRC_SECU_ID, --转入源证券ID
       NULL AS IN_ODR_VOL, --转入指令数量
       NULL AS IN_ODR_PRC, --转入指令价格
       NULL AS IN_ODR_VAL, --转入指令金额
       T4.VC_RIVAL_SEAT AS CNTP_SEAT_CODE, --对手方席位号
       0 AS RES_FLAG, --限售标识
       NULL AS LOCK_LMT_CLAS, --锁定受限类型
       NULL AS LMT_CLAS_ONUM, --受限类型序号
       NULL AS AGMT_NUM, --合同号
       NULL AS BONS_MODE, --分红方式
       NULL AS PAY_DT, --缴款日期
       NULL AS CONT_MULT, --合约乘数
       NULL AS ARBI_FLAG, --套利标志
       NULL AS ESTI_CASH_DIFF, --预估现金差额
       NULL AS ETF_FND_CLAS, --ETF基金类型
       CASE
         WHEN T0.C_INSTRUCTION_STATUS IN ('5') THEN --审批拒绝
          '4'
         WHEN T0.C_INSTRUCTION_STATUS IN ('6') THEN --分发拒绝
          '5'
         ELSE
          T0.C_INSTRUCTION_STATUS
       END AS ODR_STAT, --指令状态
       ${current_date} AS BUSI_DATE, --业务日期
       'evt_exch_odr_real_7' AS TASK_RS_ID, --任务来源标识
	   CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_OPERATOR_NO AS DELR_ID, --交易员
	     T0.L_DATE	AS P_DT,
	     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TINSTRUCTION T0
 INNER JOIN ${ods_db}.O3_TINSTRUCTIONSTOCK T4
    ON T0.L_DATE = T4.L_DATE
   AND T0.L_DAILY_INSTRUCTION_NO = T4.L_DAILY_INSTRUCTION_NO
   AND T0.L_INDEX_DAILY_MODIFY = T4.L_INDEX_DAILY_MODIFY
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T4.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T4.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5
    ON T4.L_DATE = T5.L_DATE
   AND T4.VC_INTER_CODE = T5.VC_INTER_CODE
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T6 --证券基本信息表，获取正式代码
    ON T5.L_DATE = T6.L_DATE
   AND T5.VC_ASSET_RELATIVE_CODE = T6.VC_INTER_CODE
   AND T6.C_ASSET_CLASS IN ('2', '3','6')
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
    ON T0.L_DATE = w1.dt
   AND T5.C_MARKET_NO = w1.mkt_no
   AND W1.SYS_RS_ID = 'O3'
  LEFT JOIN ${ods_db}.O3_TBONDPROPERTY T7
    ON W1.pre_1_dt = T7.L_DATE
   AND T6.VC_INTER_CODE = T7.VC_INTER_CODE
 WHERE T0.C_BUSIN_CLASS IN ('1', 'I' , 'E')
   AND T4.C_ENTRUST_DIRECTION NOT IN ('a') --排除港股通的风险资金部分
   AND T4.C_ENTRUST_DIRECTION IN ('1', '2', '3', '4')
   AND NVL(T4.C_ORIGINAL_DIRECTION, '0') NOT IN ('A')
   AND T0.C_INSTRUCTION_STATUS IN ('1', '3', '5', '6', 'a')
   AND T0.L_DATE = ${current_date}

UNION ALL
--离线指令：股指期货\国债期货\商品期货
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       concat('0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '|0|0') AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY) AS ODR_ONUM, --指令序号
       T0.C_INSTRUCTION_TYPE AS ODR_CLAS, --指令类型
       T0.L_DIRECT_DATE AS ODR_RELA_DT, --指令下达日期
       T0.L_BEGIN_DATE AS ODR_STRT_DT, --指令开始日期
       T0.L_END_DATE AS ODR_END_DT, --指令结束日期
       T0.L_BEGIN_TIME AS ODR_STRT_TIME, --指令开始时间
       T0.L_END_TIME AS ODR_END_TIME, --指令结束时间
       T0.C_STOCK_TARGET_TYPE AS ODR_CTRL_CLAS, --指令控制类型
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY , '_' , T4.L_STOCK_SERIAL_NO) AS ODR_SECU_ONUM, --指令证券序号
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T4.L_BASECOMBI_ID , '_' , T5.VC_REPORT_CODE , '.FUT.' ,
       (case when T5.C_MARKET_NO = '1' then 'SH'
             when T5.C_MARKET_NO = '2' then 'SZ'
             when T5.C_MARKET_NO = '7' then 'CFFEX'
             when T5.C_MARKET_NO = '3' then 'SHFE'
             when T5.C_MARKET_NO = '4' then 'CZCE'
             when T5.C_MARKET_NO = '9' then 'DCE'
			 end) , '_' , (CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         WHEN T4.C_INVEST_TYPE IN ('c') THEN
          '12' --套利交易
         WHEN T4.C_INVEST_TYPE IN ('b') THEN
          '10' --套期工具
         WHEN T4.C_INVEST_TYPE IN ('a') THEN
          '15' --投机
         ELSE
          T4.C_INVEST_TYPE
       END) , '_' , (CASE
         WHEN T4.C_ENTRUST_DIRECTION in ('V') THEN
          '22000100'
         WHEN T4.C_ENTRUST_DIRECTION in ('W') THEN
          '22000101'
         WHEN T4.C_ENTRUST_DIRECTION in ('X') THEN
          '22000103'
         WHEN T4.C_ENTRUST_DIRECTION in ('Y') THEN
          '22000104'
       END)) AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T4.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         WHEN T4.C_INVEST_TYPE IN ('c') THEN
          '12' --套利交易
         WHEN T4.C_INVEST_TYPE IN ('b') THEN
          '10' --套期工具
         WHEN T4.C_INVEST_TYPE IN ('a') THEN
          '15' --投机
         ELSE
          T4.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       '220001' AS BUSI_TYP, --业务类别
       CASE
         WHEN T4.C_ENTRUST_DIRECTION in ('V') THEN
          '22000100'
         WHEN T4.C_ENTRUST_DIRECTION in ('W') THEN
          '22000101'
         WHEN T4.C_ENTRUST_DIRECTION in ('X') THEN
          '22000103'
         WHEN T4.C_ENTRUST_DIRECTION in ('Y') THEN
          '22000104'
       END AS BUSI_CLAS, --业务类型
       concat(T5.VC_REPORT_CODE , '.FUT.' , (case when T5.C_MARKET_NO = '1' then 'SH'
             when T5.C_MARKET_NO = '2' then 'SZ'
             when T5.C_MARKET_NO = '7' then 'CFFEX'
             when T5.C_MARKET_NO = '3' then 'SHFE'
             when T5.C_MARKET_NO = '4' then 'CZCE'
             when T5.C_MARKET_NO = '9' then 'DCE'
			 end)) AS SECU_ID, --证券编码
       case when T5.C_MARKET_NO = '1' then 'SH'
             when T5.C_MARKET_NO = '2' then 'SZ'
             when T5.C_MARKET_NO = '7' then 'CFFEX'
             when T5.C_MARKET_NO = '3' then 'SHFE'
             when T5.C_MARKET_NO = '4' then 'CZCE'
             when T5.C_MARKET_NO = '9' then 'DCE'
			 end AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       CASE
         WHEN T4.C_ENTRUST_DIRECTION in ('X', 'Y') THEN
          'S'
         ELSE
          'L'
       END AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       0 AS CLR_SPED, --清算速度
       NULL AS TRD_PLFM, --交易平台
	   NULL AS TRD_MODE,--交易方式
       CASE
         WHEN T4.C_ENTRUST_DIRECTION in ('V') THEN
          '32'
         WHEN T4.C_ENTRUST_DIRECTION in ('W') THEN
          '33'
         WHEN T4.C_ENTRUST_DIRECTION in ('X') THEN
          '34'
         WHEN T4.C_ENTRUST_DIRECTION in ('Y') THEN
          '35'
       END AS ENTR_DIR, --委托方向
       CASE
         WHEN T4.C_PRICE_TYPE IN ('4', '5', '6') THEN
          '2'
         ELSE
          '1'
       END AS ODR_PRC_CLAS, --指令价格类型
       case when T4.EN_PRICE1 = 0 then T4.EN_FACT_PRICE else T4.EN_PRICE1 end AS ODR_PRC, --指令价格
       NULL AS RAT, --利率
       T4.L_AMOUNT AS ODR_VOL, --指令数量
       T4.EN_BALANCE AS ODR_VAL, --指令金额
       T4.L_TOTAL_ENTRUST_AMOUNT AS BGNG_HAS_ENTR_VOL, --期初已委托数量
       T4.EN_TOTAL_ENTRUST_BALANCE AS BGNG_HAS_ENTR_VAL, --期初已委托金额
       T4.L_TOTAL_DEAL_AMOUNT AS BGNG_HAS_TNV_VOL, --期初已成交数量
       T4.EN_TOTAL_DEAL_BALANCE AS BGNG_HAS_TNV_VAL, --期初已成交金额
       T4.L_TODAY_ENTRUST_AMOUNT AS ENTR_VOL, --当日委托数量
       T4.EN_TODAY_ENTRUST_BALANCE AS ENTR_VAL, --当日委托金额
       T4.L_TODAY_DEAL_AMOUNT AS TNV_VOL, --当日成交数量
       T4.EN_TODAY_DEAL_BALANCE AS TNV_VAL, --当日成交金额
       T0.L_TRADE_RIVAL_NO AS TRD_CNTP_ID, --交易对手编码
       NULL AS APPT_NUM, --约定号
       NULL AS GUAR_SETT_FLAG, --担保交收标识
       GREATEST(T0.L_BEGIN_DATE, T0.L_DATE) AS DELI_DT, --交割日期
       T0.L_DIRECT_OPERATOR AS RELA_RRSN, --下达人
       T0.L_DIRECT_INSTEAD_OPERATOR AS AGT_RELA_RRSN, --代下达人
       T0.VC_SUMMARY AS MEMO, --备注
       NULL AS CONT_DAYS, --合约天数
       NULL AS INTA_DAYS, --计息天数
       NULL AS CONT_TNV_DT, --合约成交日期
       NULL AS CONT_END_DT, --合约到期日期
       NULL AS FIR_DELI_DT, --首期交割日期
       NULL AS END_DELI_DT, --到期交割日期
       NULL AS FIR_DELI_MODE, --首期交割方式
       NULL AS END_DELI_MODE, --到期交割方式
       NULL AS BUYB_VAL, --购回金额
       NULL AS INTR, --利息
       NULL AS IN_PRD_CODE, --转入产品代码
       NULL AS IN_AST_UNIT_CODE, --转入资产单元代码
       NULL AS IN_PFL_CODE, --转入投组代码
       NULL AS IN_INV_TYP, --转入投资类型
       NULL AS IN_SECU_ID, --转入证券编码
       NULL AS IN_SRC_SECU_ID, --转入源证券ID
       NULL AS IN_ODR_VOL, --转入指令数量
       NULL AS IN_ODR_PRC, --转入指令价格
       NULL AS IN_ODR_VAL, --转入指令金额
       T4.VC_RIVAL_SEAT AS CNTP_SEAT_CODE, --对手方席位号
       0 AS RES_FLAG, --限售标识
       NULL AS LOCK_LMT_CLAS, --锁定受限类型
       NULL AS LMT_CLAS_ONUM, --受限类型序号
       NULL AS AGMT_NUM, --合同号
       NULL AS BONS_MODE, --分红方式
       NULL AS PAY_DT, --缴款日期
       cast(T4.EN_BALANCE as double) /
       (cast(T4.L_AMOUNT as double) * cast((case when T4.EN_PRICE1 = 0 then T4.EN_FACT_PRICE else T4.EN_PRICE1 end) as double)) AS CONT_MULT, --合约乘数
       CASE
         WHEN T0.C_BUSIN_CLASS IN ('j', 'k') THEN
          '1'
         ELSE
          '0'
       END AS ARBI_FLAG, --套利标志
       NULL AS ESTI_CASH_DIFF, --预估现金差额
       NULL AS ETF_FND_CLAS, --ETF基金类型
       CASE
         WHEN T0.C_INSTRUCTION_STATUS IN ('5') THEN --审批拒绝
          '4'
         WHEN T0.C_INSTRUCTION_STATUS IN ('6') THEN --分发拒绝
          '5'
         ELSE
          T0.C_INSTRUCTION_STATUS
       END AS ODR_STAT, --指令状态
       ${current_date} AS BUSI_DATE, --业务日期
       'evt_exch_odr_real_8' AS TASK_RS_ID, --任务来源标识
	   CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_OPERATOR_NO AS DELR_ID, --交易员
	     T0.L_DATE	AS P_DT,
	     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TINSTRUCTION T0
 INNER JOIN ${ods_db}.O3_TINSTRUCTIONSTOCK T4
    ON T0.L_DATE = T4.L_DATE
   AND T0.L_DAILY_INSTRUCTION_NO = T4.L_DAILY_INSTRUCTION_NO
   AND T0.L_INDEX_DAILY_MODIFY = T4.L_INDEX_DAILY_MODIFY
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T4.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T4.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5
    ON T4.L_DATE = T5.L_DATE
   AND T4.VC_INTER_CODE = T5.VC_INTER_CODE
 WHERE T0.C_BUSIN_CLASS IN ('4', 'j', 'k', 'y', 'z')
   AND T4.C_ENTRUST_DIRECTION IN ('V', 'W', 'X', 'Y')
      --V买入开仓,W卖出平仓,X卖出开仓,Y买入平仓
   AND T0.C_INSTRUCTION_STATUS IN ('1', '2', '3', '5', '6') --1:有效；2:已修改；3:已撤销；5:审批拒绝；6:分发拒绝
   AND T0.L_DATE = ${current_date}

UNION ALL
--指令：跨市场转托管转出（基金）
SELECT '1' AS BUSI_SYS_ID,--业务系统编码
       concat('0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '|0|0') AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY) AS ODR_ONUM, --指令序号
       T0.C_INSTRUCTION_TYPE AS ODR_CLAS, --指令类型
       T0.L_DIRECT_DATE AS ODR_RELA_DT, --指令下达日期
       T0.L_BEGIN_DATE AS ODR_STRT_DT, --指令开始日期
       T0.L_END_DATE AS ODR_END_DT, --指令结束日期
       T0.L_BEGIN_TIME AS ODR_STRT_TIME, --指令开始时间
       T0.L_END_TIME AS ODR_END_TIME, --指令结束时间
       T0.C_STOCK_TARGET_TYPE AS ODR_CTRL_CLAS, --指令控制类型
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY , '_' , T4.L_STOCK_SERIAL_NO) AS ODR_SECU_ONUM, --指令证券序号
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T4.L_BASECOMBI_ID , '_' , T5.VC_REPORT_CODE , '.FUND.' ,
       (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end) , '_' , (CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T4.C_INVEST_TYPE
       END) , '_' , '21000102') AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T4.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T4.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       '210001' AS BUSI_TYP, --业务类别
       '21000102' AS BUSI_CLAS, --业务类型
       concat(T5.VC_REPORT_CODE , '.FUND.' , (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end)) AS SECU_ID, --证券编码
       CASE
         WHEN T5.C_MARKET_NO = '1' THEN
          'SH'
         WHEN T5.C_MARKET_NO = '2' THEN
          'SZ'
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       CASE WHEN T5.C_MARKET_NO = '1' THEN
            1
            ELSE
            0
       END AS CLR_SPED, --清算速度
       NULL AS TRD_PLFM, --交易平台
	   NULL AS TRD_MODE,--交易方式
       '43' AS ENTR_DIR, --委托方向
       CASE
         WHEN T4.C_PRICE_TYPE IN ('4', '5', '6') THEN
          '2'
         ELSE
          '1'
       END AS ODR_PRC_CLAS, --指令价格类型
       0 AS ODR_PRC, --指令价格
       NULL AS RAT, --利率
       T4.L_AMOUNT AS ODR_VOL, --指令数量
       0 AS ODR_VAL, --指令金额
       T4.L_TOTAL_ENTRUST_AMOUNT AS BGNG_HAS_ENTR_VOL, --期初已委托数量
       T4.EN_TOTAL_ENTRUST_BALANCE AS BGNG_HAS_ENTR_VAL, --期初已委托金额
       T4.L_TOTAL_DEAL_AMOUNT AS BGNG_HAS_TNV_VOL, --期初已成交数量
       T4.EN_TOTAL_DEAL_BALANCE AS BGNG_HAS_TNV_VAL, --期初已成交金额
       T4.L_TODAY_ENTRUST_AMOUNT AS ENTR_VOL, --当日委托数量
       T4.EN_TODAY_ENTRUST_BALANCE AS ENTR_VAL, --当日委托金额
       T4.L_TODAY_DEAL_AMOUNT AS TNV_VOL, --当日成交数量
       T4.EN_TODAY_DEAL_BALANCE AS TNV_VAL, --当日成交金额
       T0.L_TRADE_RIVAL_NO AS TRD_CNTP_ID, --交易对手编码
       NULL AS APPT_NUM, --约定号
       NULL AS GUAR_SETT_FLAG, --担保交收标识
       CASE WHEN T5.C_MARKET_NO = '1' THEN W1.aft_1_dt ELSE GREATEST(T0.L_BEGIN_DATE,T0.L_DATE) END AS DELI_DT, --交割日期
       T0.L_DIRECT_OPERATOR AS RELA_RRSN, --下达人
       T0.L_DIRECT_INSTEAD_OPERATOR AS AGT_RELA_RRSN, --代下达人
       T0.VC_SUMMARY AS MEMO, --备注
       NULL AS CONT_DAYS, --合约天数
       NULL AS INTA_DAYS, --计息天数
       NULL AS CONT_TNV_DT, --合约成交日期
       NULL AS CONT_END_DT, --合约到期日期
       NULL AS FIR_DELI_DT, --首期交割日期
       NULL AS END_DELI_DT, --到期交割日期
       NULL AS FIR_DELI_MODE, --首期交割方式
       NULL AS END_DELI_MODE, --到期交割方式
       NULL AS BUYB_VAL, --购回金额
       NULL AS INTR, --利息
       NULL AS IN_PRD_CODE, --转入产品代码
       NULL AS IN_AST_UNIT_CODE, --转入资产单元代码
       NULL AS IN_PFL_CODE, --转入投组代码
       NULL AS IN_INV_TYP, --转入投资类型
       NULL AS IN_SECU_ID, --转入证券编码
       NULL AS IN_SRC_SECU_ID, --转入源证券ID
       NULL AS IN_ODR_VOL, --转入指令数量
       NULL AS IN_ODR_PRC, --转入指令价格
       NULL AS IN_ODR_VAL, --转入指令金额
       T4.VC_RIVAL_SEAT AS CNTP_SEAT_CODE, --对手方席位号
       0 AS RES_FLAG, --限售标识
       NULL AS LOCK_LMT_CLAS, --锁定受限类型
       NULL AS LMT_CLAS_ONUM, --受限类型序号
       NULL AS AGMT_NUM, --合同号
       NULL AS BONS_MODE, --分红方式
       NULL AS PAY_DT, --缴款日期
       NULL AS CONT_MULT, --合约乘数
       NULL AS ARBI_FLAG, --套利标志
       NULL AS ESTI_CASH_DIFF, --预估现金差额
       NULL AS ETF_FND_CLAS, --ETF基金类型
       CASE
         WHEN T0.C_INSTRUCTION_STATUS IN ('5') THEN --审批拒绝
          '4'
         WHEN T0.C_INSTRUCTION_STATUS IN ('6') THEN --分发拒绝
          '5'
         ELSE
          T0.C_INSTRUCTION_STATUS
       END AS ODR_STAT, --指令状态
       ${current_date} AS BUSI_DATE, --业务日期
       'evt_exch_odr_real_9' AS TASK_RS_ID, --任务来源标识
	   CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_OPERATOR_NO AS DELR_ID, --交易员
	     T0.L_DATE	AS P_DT,
	     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TINSTRUCTION T0
 INNER JOIN ${ods_db}.O3_TINSTRUCTIONSTOCK T4
    ON T0.L_DATE = T4.L_DATE
   AND T0.L_DAILY_INSTRUCTION_NO = T4.L_DAILY_INSTRUCTION_NO
   AND T0.L_INDEX_DAILY_MODIFY = T4.L_INDEX_DAILY_MODIFY
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T4.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T4.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5
    ON T4.L_DATE = T5.L_DATE
   AND T4.VC_INTER_CODE = T5.VC_INTER_CODE
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
    ON GREATEST(T0.L_BEGIN_DATE,T0.L_DATE) = w1.dt
   AND T5.C_MARKET_NO = w1.mkt_no
   AND W1.SYS_RS_ID = 'O3'
 WHERE T0.C_BUSIN_CLASS IN ('5', 'v')
   AND T4.C_ENTRUST_DIRECTION IN ('G', 'g')
   AND T0.C_INSTRUCTION_STATUS IN ('1', '2', '3', '5', '6') --1:有效；2:已修改；3:已撤销；5:审批拒绝；6:分发拒绝
   AND T0.L_DATE = ${current_date}

UNION ALL
--指令：转融券成交/展期/提前了结
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       concat('0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '|0|0') AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY) AS ODR_ONUM, --指令序号
       T0.C_INSTRUCTION_TYPE AS ODR_CLAS, --指令类型
       T0.L_DIRECT_DATE AS ODR_RELA_DT, --指令下达日期
       T0.L_BEGIN_DATE AS ODR_STRT_DT, --指令开始日期
       T0.L_END_DATE AS ODR_END_DT, --指令结束日期
       T0.L_BEGIN_TIME AS ODR_STRT_TIME, --指令开始时间
       T0.L_END_TIME AS ODR_END_TIME, --指令结束时间
       T0.C_STOCK_TARGET_TYPE AS ODR_CTRL_CLAS, --指令控制类型
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY , '_' , T4.L_STOCK_SERIAL_NO) AS ODR_SECU_ONUM, --指令证券序号
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T4.L_BASECOMBI_ID , '_' , T5.VC_REPORT_CODE , '.REFC.' ,
          (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end) , '_' , (CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T4.C_INVEST_TYPE
       END) , '_' , (CASE
         WHEN T4.C_ENTRUST_DIRECTION = 'l' THEN
          '23000100'
         WHEN T4.C_ENTRUST_DIRECTION = 'M' THEN
          '23000102'
         WHEN T4.C_ENTRUST_DIRECTION = '98' THEN
          '23000103'
       END)) AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T4.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T4.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       '230001' AS BUSI_TYP, --业务类别
       CASE
         WHEN T4.C_ENTRUST_DIRECTION = 'l' THEN
          '23000100'
         WHEN T4.C_ENTRUST_DIRECTION = 'M' THEN
          '23000102'
         WHEN T4.C_ENTRUST_DIRECTION = '98' THEN
          '23000103'
       END AS BUSI_CLAS, --业务类型
       CASE
         WHEN T4.C_ENTRUST_DIRECTION = 'l' THEN
          concat(T5.VC_REPORT_CODE , '.REFC.' , (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end))
         WHEN T4.C_ENTRUST_DIRECTION = 'M' THEN
          concat(T7.VC_CONTRACT_NO , '.REFC.' , (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end))
         WHEN T4.C_ENTRUST_DIRECTION = '98' THEN
          concat(T7.VC_CONTRACT_NO , '.REFC.' , (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end))
       END AS SECU_ID, --证券编码
       CASE
         WHEN T5.C_MARKET_NO = '1' THEN
          'SH'
         WHEN T5.C_MARKET_NO = '2' THEN
          'SZ'
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       0 AS CLR_SPED, --清算速度
       NULL AS TRD_PLFM, --交易平台
	   NULL AS TRD_MODE,--交易方式
       CASE
         WHEN T4.C_ENTRUST_DIRECTION = 'l' THEN
          '49'
         WHEN T4.C_ENTRUST_DIRECTION = 'M' THEN
          '23'
         WHEN T4.C_ENTRUST_DIRECTION = '98' THEN
          '210'
       END AS ENTR_DIR, --委托方向
       CASE
         WHEN T4.C_PRICE_TYPE IN ('4', '5', '6') THEN
          '2'
         ELSE
          '1'
       END AS ODR_PRC_CLAS, --指令价格类型
       T4.EN_FACT_PRICE AS ODR_PRC, --指令价格
       T4.EN_PRICE1 / 100 AS RAT, --利率
       T4.L_AMOUNT AS ODR_VOL, --指令数量
       T4.EN_BALANCE AS ODR_VAL, --指令金额
       T4.L_TOTAL_ENTRUST_AMOUNT AS BGNG_HAS_ENTR_VOL, --期初已委托数量
       T4.EN_TOTAL_ENTRUST_BALANCE AS BGNG_HAS_ENTR_VAL, --期初已委托金额
       T4.L_TOTAL_DEAL_AMOUNT AS BGNG_HAS_TNV_VOL, --期初已成交数量
       T4.EN_TOTAL_DEAL_BALANCE AS BGNG_HAS_TNV_VAL, --期初已成交金额
       T4.L_TODAY_ENTRUST_AMOUNT AS ENTR_VOL, --当日委托数量
       T4.EN_TODAY_ENTRUST_BALANCE AS ENTR_VAL, --当日委托金额
       T4.L_TODAY_DEAL_AMOUNT AS TNV_VOL, --当日成交数量
       T4.EN_TODAY_DEAL_BALANCE AS TNV_VAL, --当日成交金额
       T0.L_TRADE_RIVAL_NO AS TRD_CNTP_ID, --交易对手编码
       T4.VC_ENGAGED_NO AS APPT_NUM, --约定号
       NULL AS GUAR_SETT_FLAG, --担保交收标识
       GREATEST(T0.L_BEGIN_DATE, T0.L_DATE) AS DELI_DT, --交割日期
       T0.L_DIRECT_OPERATOR AS RELA_RRSN, --下达人
       T0.L_DIRECT_INSTEAD_OPERATOR AS AGT_RELA_RRSN, --代下达人
       T0.VC_SUMMARY AS MEMO, --备注
       T0.L_HG_DAYS AS CONT_DAYS, --合约天数
       datediff(from_unixtime(unix_timestamp(cast(CASE WHEN T4.C_ENTRUST_DIRECTION = '98' THEN T4.L_SECOND_SETTLE_DATE ELSE w1.aft_0_dt END as string),'yyyyMMdd'),'yyyy-MM-dd'),
       from_unixtime(unix_timestamp(cast(GREATEST(T0.L_BEGIN_DATE,T0.L_DATE) as string),'yyyyMMdd'),'yyyy-MM-dd'))  AS INTA_DAYS, --计息天数
       GREATEST(T0.L_BEGIN_DATE, T0.L_DATE) AS CONT_TNV_DT, --合约成交日期
       CASE
          WHEN T4.C_ENTRUST_DIRECTION = '98' THEN
               T4.L_SECOND_SETTLE_DATE
          ELSE
               w1.aft_0_dt
       END AS CONT_END_DT, --合约到期日期
       GREATEST(T0.L_BEGIN_DATE, T0.L_DATE) AS FIR_DELI_DT, --首期交割日期
       CASE
         WHEN T4.C_ENTRUST_DIRECTION = '98' THEN
          T4.L_SECOND_SETTLE_DATE
         ELSE
          w1.aft_0_dt
       END AS END_DELI_DT, --到期交割日期
       '3' AS FIR_DELI_MODE, --首期交割方式
       '3' AS END_DELI_MODE, --到期交割方式
       T4.EN_BALANCE +
       ROUND((datediff(from_unixtime(unix_timestamp(cast(CASE WHEN T4.C_ENTRUST_DIRECTION = '98' THEN T4.L_SECOND_SETTLE_DATE ELSE w1.aft_0_dt END as string),'yyyyMMdd'),'yyyy-MM-dd'),
       from_unixtime(unix_timestamp(cast(GREATEST(T0.L_BEGIN_DATE,T0.L_DATE) as string),'yyyyMMdd'),'yyyy-MM-dd')) ) *
             cast(T4.EN_BALANCE as double) * cast(T4.EN_PRICE1 as double) / 100 / 360,
             2) AS BUYB_VAL, --购回金额
       ROUND((datediff(from_unixtime(unix_timestamp(cast(CASE WHEN T4.C_ENTRUST_DIRECTION = '98' THEN T4.L_SECOND_SETTLE_DATE ELSE w1.aft_0_dt END as string),'yyyyMMdd'),'yyyy-MM-dd'),
       from_unixtime(unix_timestamp(cast(GREATEST(T0.L_BEGIN_DATE,T0.L_DATE) as string),'yyyyMMdd'),'yyyy-MM-dd')) ) *
             cast(T4.EN_BALANCE as double) * cast(T4.EN_PRICE1 as double) / 100 / 360,
             2) AS INTR, --利息
       NULL AS IN_PRD_CODE, --转入产品代码
       NULL AS IN_AST_UNIT_CODE, --转入资产单元代码
       NULL AS IN_PFL_CODE, --转入投组代码
       NULL AS IN_INV_TYP, --转入投资类型
       NULL AS IN_SECU_ID, --转入证券编码
       NULL AS IN_SRC_SECU_ID, --转入源证券ID
       NULL AS IN_ODR_VOL, --转入指令数量
       NULL AS IN_ODR_PRC, --转入指令价格
       NULL AS IN_ODR_VAL, --转入指令金额
       T4.VC_RIVAL_SEAT AS CNTP_SEAT_CODE, --对手方席位号
       CASE WHEN T4.C_STRATEGY_PLACING = '1' THEN
          1  --战略配售限售出借
         ELSE
          0  --非限售
       END AS RES_FLAG, --限售标识
       CASE WHEN T4.C_STRATEGY_PLACING = '1' THEN
          4  --战略配售限售出借
         ELSE
          0  --非限售
       END AS LOCK_LMT_CLAS, --锁定受限类型
       NULL AS LMT_CLAS_ONUM, --受限类型序号
       T7.VC_CONTRACT_NO AS AGMT_NUM, --合同号
       NULL AS BONS_MODE, --分红方式
       NULL AS PAY_DT, --缴款日期
       NULL AS CONT_MULT, --合约乘数
       NULL AS ARBI_FLAG, --套利标志
       NULL AS ESTI_CASH_DIFF, --预估现金差额
       NULL AS ETF_FND_CLAS, --ETF基金类型
       CASE
         WHEN T0.C_INSTRUCTION_STATUS IN ('5') THEN --审批拒绝
          '4'
         WHEN T0.C_INSTRUCTION_STATUS IN ('6') THEN --分发拒绝
          '5'
         ELSE
          T0.C_INSTRUCTION_STATUS
       END AS ODR_STAT, --指令状态
       ${current_date} AS BUSI_DATE, --业务日期
       'evt_exch_odr_real_10' AS TASK_RS_ID, --任务来源标识
	   CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_OPERATOR_NO AS DELR_ID, --交易员
	     T0.L_DATE	AS P_DT,
	     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TINSTRUCTION T0
 INNER JOIN ${ods_db}.O3_TINSTRUCTIONSTOCK T4
    ON T0.L_DATE = T4.L_DATE
   AND T0.L_DAILY_INSTRUCTION_NO = T4.L_DAILY_INSTRUCTION_NO
   AND T0.L_INDEX_DAILY_MODIFY = T4.L_INDEX_DAILY_MODIFY
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T4.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T4.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5
    ON T4.L_DATE = T5.L_DATE
   AND T4.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.C_ASSET_CLASS IN ('2', '3', '6')
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T6 --证券基本信息表，获取正式代码
    ON T5.L_DATE = T6.L_DATE
   AND T5.VC_ASSET_RELATIVE_CODE = T6.VC_INTER_CODE
   AND T6.C_ASSET_CLASS IN ('2', '3', '6')
  LEFT JOIN ${ods_db}.O3_TSECURITYLOAN T7 --证券借贷表，当前和历史表合集
    ON T4.L_CONTRACT_NO = T7.L_SERIAL_NO
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
    ON cast(date_format(date_add(from_unixtime(unix_timestamp(cast(GREATEST(T0.L_BEGIN_DATE,T0.L_DATE) as string),'yyyyMMdd'),'yyyy-MM-dd'),cast(T0.L_HG_DAYS as int)),'yyyyMMdd') as bigint) = w1.dt
   AND T5.C_MARKET_NO = w1.mkt_no
   AND W1.SYS_RS_ID = 'O3'
 WHERE T0.C_BUSIN_CLASS IN ('E')
   AND T4.C_ENTRUST_DIRECTION IN ('l', 'M', '98') --l转融券新开、M转融券展期、98转融券提前了解
   AND T0.C_INSTRUCTION_STATUS IN ('1', '2', '3', '5', '6') --1:有效；2:已修改；3:已撤销；5:审批拒绝；6:分发拒绝
   AND T0.L_DATE = ${current_date}

UNION ALL
--离线指令：债转股
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       concat('0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '|0|0') AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY) AS ODR_ONUM, --指令序号
       T0.C_INSTRUCTION_TYPE AS ODR_CLAS, --指令类型
       T0.L_DIRECT_DATE AS ODR_RELA_DT, --指令下达日期
       T0.L_BEGIN_DATE AS ODR_STRT_DT, --指令开始日期
       T0.L_END_DATE AS ODR_END_DT, --指令结束日期
       T0.L_BEGIN_TIME AS ODR_STRT_TIME, --指令开始时间
       T0.L_END_TIME AS ODR_END_TIME, --指令结束时间
       T0.C_STOCK_TARGET_TYPE AS ODR_CTRL_CLAS, --指令控制类型
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY , '_' , T4.L_STOCK_SERIAL_NO) AS ODR_SECU_ONUM, --指令证券序号
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T4.L_BASECOMBI_ID , '_' , T6.VC_REPORT_CODE , '.BOND.' ,
       (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end) , '_' , (CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T4.C_INVEST_TYPE
       END) , '_' , ('26000100')) AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T4.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T4.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       '260001' AS BUSI_TYP, --业务类别
       '26000100' AS BUSI_CLAS, --业务类型
       concat(T6.VC_REPORT_CODE , '.BOND.' , (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end)) AS SECU_ID, --证券编码
       CASE
         WHEN T5.C_MARKET_NO = '1' THEN
          'SH'
         WHEN T5.C_MARKET_NO = '2' THEN
          'SZ'
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T6.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       1 AS CLR_SPED, --清算速度
       CASE
         WHEN T0.C_BUSIN_CLASS IN ('1') THEN
          'PLAT_BID'
       END AS TRD_PLFM, --交易平台
	   NULL AS TRD_MODE,--交易方式
       '10' AS ENTR_DIR, --委托方向
       CASE
         WHEN T4.C_PRICE_TYPE IN ('4', '5', '6') THEN
          '2'
         ELSE
          '1'
       END AS ODR_PRC_CLAS, --指令价格类型
       case when SUBSTR(T4.VC_INTER_CODE,-2) = 'SS' then T4.EN_PRICE1 else 100 end AS ODR_PRC, --指令价格
       NULL AS RAT, --利率
       T4.L_AMOUNT AS ODR_VOL, --指令数量
       case when T4.EN_BALANCE = 0 then cast((case when SUBSTR(T4.VC_INTER_CODE,-2) = 'SS' then T4.EN_PRICE1 else 100 end) as double) * cast(T4.L_AMOUNT as double) else T4.EN_BALANCE end AS ODR_VAL, --指令金额
       T4.L_TOTAL_ENTRUST_AMOUNT AS BGNG_HAS_ENTR_VOL, --期初已委托数量
       T4.EN_TOTAL_ENTRUST_BALANCE AS BGNG_HAS_ENTR_VAL, --期初已委托金额
       T4.L_TOTAL_DEAL_AMOUNT AS BGNG_HAS_TNV_VOL, --期初已成交数量
       T4.EN_TOTAL_DEAL_BALANCE AS BGNG_HAS_TNV_VAL, --期初已成交金额
       T4.L_TODAY_ENTRUST_AMOUNT AS ENTR_VOL, --当日委托数量
       T4.EN_TODAY_ENTRUST_BALANCE AS ENTR_VAL, --当日委托金额
       T4.L_TODAY_DEAL_AMOUNT AS TNV_VOL, --当日成交数量
       T4.EN_TODAY_DEAL_BALANCE AS TNV_VAL, --当日成交金额
       T0.L_TRADE_RIVAL_NO AS TRD_CNTP_ID, --交易对手编码
       NULL AS APPT_NUM, --约定号
       NULL AS GUAR_SETT_FLAG, --担保交收标识
       W1.aft_1_dt AS DELI_DT, --交割日期
       T0.L_DIRECT_OPERATOR AS RELA_RRSN, --下达人
       T0.L_DIRECT_INSTEAD_OPERATOR AS AGT_RELA_RRSN, --代下达人
       T0.VC_SUMMARY AS MEMO, --备注
       NULL AS CONT_DAYS, --合约天数
       NULL AS INTA_DAYS, --计息天数
       NULL AS CONT_TNV_DT, --合约成交日期
       NULL AS CONT_END_DT, --合约到期日期
       NULL AS FIR_DELI_DT, --首期交割日期
       NULL AS END_DELI_DT, --到期交割日期
       NULL AS FIR_DELI_MODE, --首期交割方式
       NULL AS END_DELI_MODE, --到期交割方式
       NULL AS BUYB_VAL, --购回金额
       NULL AS INTR, --利息
       T10.VC_FUND_CODE AS IN_PRD_CODE, --转入产品代码
       concat(T10.VC_FUND_CODE , '_' , T12.VC_ASSET_NO) AS IN_AST_UNIT_CODE, --转入资产单元代码
       concat(T10.VC_FUND_CODE , '_' , T12.VC_ASSET_NO , '_' , T11.VC_COMBI_NO) AS IN_PFL_CODE, --转入投组代码
       case when T4.C_INVEST_TYPE = '1' then '2'
	        when T4.C_INVEST_TYPE = '2' then '1'
			when T4.C_INVEST_TYPE = 'a' then '15'
			when T4.C_INVEST_TYPE = 'b' then '10'
			when T4.C_INVEST_TYPE = 'c' then '12'
		else T4.C_INVEST_TYPE end AS IN_INV_TYP, --转入投资类型
       concat(T8.VC_REPORT_CODE , '.STK.' , (case when T8.C_MARKET_NO = '1' then 'SH' when T8.C_MARKET_NO = '2' then 'SZ' end)) AS IN_SECU_ID, --转入证券编码
       T7.VC_INTER_CODE AS IN_SRC_SECU_ID, --转入源证券ID
       T7.L_AMOUNT AS IN_ODR_VOL, --转入指令数量
       T7.EN_FACT_PRICE AS IN_ODR_PRC, --转入指令价格
       T7.EN_BALANCE AS IN_ODR_VAL, --转入指令金额
       T4.VC_RIVAL_SEAT AS CNTP_SEAT_CODE, --对手方席位号
       CASE
         WHEN NVL(T4.L_RESTRICTED_NO, 0) <> 0 THEN
          1 --限售
         ELSE
          0 --非限售
       END AS RES_FLAG, --限售标识
       CASE
         WHEN NVL(T4.L_RESTRICTED_NO, 0) <> 0 THEN
          7 --定向可转债转股受限
         ELSE
          NULL --非限售
       END AS LOCK_LMT_CLAS, --锁定受限类型
       NVL(T4.L_RESTRICTED_NO, 0) AS LMT_CLAS_ONUM, --限售类型序号
       NULL AS AGMT_NUM, --合同号
       NULL AS BONS_MODE, --分红方式
       NULL AS PAY_DT, --缴款日期
       NULL AS CONT_MULT, --合约乘数
       NULL AS ARBI_FLAG, --套利标志
       NULL AS ESTI_CASH_DIFF, --预估现金差额
       NULL AS ETF_FND_CLAS, --ETF基金类型
       CASE
         WHEN T0.C_INSTRUCTION_STATUS IN ('5') THEN --审批拒绝
          '4'
         WHEN T0.C_INSTRUCTION_STATUS IN ('6') THEN --分发拒绝
          '5'
         ELSE
          T0.C_INSTRUCTION_STATUS
       END AS ODR_STAT, --指令状态
       ${current_date} AS BUSI_DATE, --业务日期
       'evt_exch_odr_real_11' AS TASK_RS_ID, --任务来源标识
	   CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_OPERATOR_NO AS DELR_ID, --交易员
	     T0.L_DATE	AS P_DT,
	     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TINSTRUCTION T0
 INNER JOIN ${ods_db}.O3_TINSTRUCTIONSTOCK T4
    ON T0.L_DATE = T4.L_DATE
   AND T0.L_DAILY_INSTRUCTION_NO = T4.L_DAILY_INSTRUCTION_NO
   AND T0.L_INDEX_DAILY_MODIFY = T4.L_INDEX_DAILY_MODIFY
 INNER JOIN ${ods_db}.O3_TINSTRUCTIONSTOCK T7  --买入股票
         ON T0.L_DATE = T7.L_DATE
                AND T0.L_DAILY_INSTRUCTION_NO = T7.L_DAILY_INSTRUCTION_NO
                AND T0.L_INDEX_DAILY_MODIFY = T7.L_INDEX_DAILY_MODIFY
                AND T0.L_FUND_ID = T7.L_FUND_ID
                AND SUBSTR(T7.VC_INTER_CODE, 1, 1) IN ('0', '3', '6')
                AND T7.C_ENTRUST_DIRECTION = '1'
                AND T7.C_ORIGINAL_DIRECTION = 'A'
                AND T7.C_INSTRUCTION_STATUS IN ('1', '3', '5', '6', 'a')
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T4.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T4.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5
    ON T4.L_DATE = T5.L_DATE
   AND T4.VC_INTER_CODE = T5.VC_INTER_CODE
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T6 --证券基本信息表，获取正式代码
    ON T5.L_DATE = T6.L_DATE
   AND T5.VC_ASSET_RELATIVE_CODE = T6.VC_INTER_CODE
   AND T6.C_ASSET_CLASS IN ('2', '3','6')
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T8
    ON T7.L_DATE = T8.L_DATE
   AND T7.VC_INTER_CODE = T8.VC_INTER_CODE
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T10 --产品基本信息表，获取产品代码
    ON T7.L_FUND_ID = T10.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T11 --投资组合基本信息表，获取投资组合代码
    ON T7.L_BASECOMBI_ID = T11.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T12 --资产单元基本信息表，获取资产单元代码
    ON T11.L_ASSET_ID = T12.L_ASSET_ID
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
    ON GREATEST(T0.L_BEGIN_DATE, T0.L_DATE) = w1.dt
   AND T5.C_MARKET_NO = w1.mkt_no
   AND W1.SYS_RS_ID = 'O3'
 WHERE T0.C_BUSIN_CLASS IN ('1')
   AND T4.C_ENTRUST_DIRECTION IN ('A')
   AND T0.C_INSTRUCTION_STATUS IN ('1', '2', '3', '5', '6') --1:有效；2:已修改；3:已撤销；5:审批拒绝；6:分发拒绝
   AND T0.L_DATE = ${current_date}

UNION ALL
--指令：指定\撤指
SELECT '1' AS BUSI_SYS_ID,--业务系统编码
       concat('0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '|0|0') AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY) AS ODR_ONUM, --指令序号
       T0.C_INSTRUCTION_TYPE AS ODR_CLAS, --指令类型
       T0.L_DIRECT_DATE AS ODR_RELA_DT, --指令下达日期
       T0.L_BEGIN_DATE AS ODR_STRT_DT, --指令开始日期
       T0.L_END_DATE AS ODR_END_DT, --指令结束日期
       T0.L_BEGIN_TIME AS ODR_STRT_TIME, --指令开始时间
       T0.L_END_TIME AS ODR_END_TIME, --指令结束时间
       T0.C_STOCK_TARGET_TYPE AS ODR_CTRL_CLAS, --指令控制类型
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY , '_' , T4.L_STOCK_SERIAL_NO) AS ODR_SECU_ONUM, --指令证券序号
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T4.L_BASECOMBI_ID , '_' , T5.VC_REPORT_CODE , '.QT.SH' , '_' ,
	   (CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T4.C_INVEST_TYPE
       END) , '_' , (CASE
         WHEN T4.C_ENTRUST_DIRECTION in ('H') THEN
          '25000200'
         WHEN T4.C_ENTRUST_DIRECTION in ('I') THEN
          '25000201'
       END)) AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T4.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T4.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       '250002' AS BUSI_TYP, --业务类别
       (CASE
         WHEN T4.C_ENTRUST_DIRECTION in ('H') THEN
          '25000200'
         WHEN T4.C_ENTRUST_DIRECTION in ('I') THEN
          '25000201'
       END) AS BUSI_CLAS, --业务类型
       concat(T5.VC_REPORT_CODE , '.QT.SH') AS SECU_ID, --证券编码
       CASE
         WHEN T5.C_MARKET_NO = '1' THEN
          'SH'
         WHEN T5.C_MARKET_NO = '2' THEN
          'SZ'
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       0 AS CLR_SPED, --清算速度
       'PLAT_BID' AS TRD_PLFM, --交易平台
	   NULL AS TRD_MODE,--交易方式
       CASE
         WHEN T4.C_ENTRUST_DIRECTION in ('H') THEN
          '18'
         WHEN T4.C_ENTRUST_DIRECTION in ('I') THEN
          '19'
       END AS ENTR_DIR, --委托方向
       CASE
         WHEN T4.C_PRICE_TYPE IN ('4', '5', '6') THEN
          '2'
         ELSE
          '1'
       END AS ODR_PRC_CLAS, --指令价格类型
       case when T4.EN_PRICE1 = 0 then T4.EN_FACT_PRICE else T4.EN_PRICE1 end AS ODR_PRC, --指令价格
       NULL AS RAT, --利率
       T4.L_AMOUNT AS ODR_VOL, --指令数量
       0 AS ODR_VAL, --指令金额
       T4.L_TOTAL_ENTRUST_AMOUNT AS BGNG_HAS_ENTR_VOL, --期初已委托数量
       T4.EN_TOTAL_ENTRUST_BALANCE AS BGNG_HAS_ENTR_VAL, --期初已委托金额
       T4.L_TOTAL_DEAL_AMOUNT AS BGNG_HAS_TNV_VOL, --期初已成交数量
       T4.EN_TOTAL_DEAL_BALANCE AS BGNG_HAS_TNV_VAL, --期初已成交金额
       T4.L_TODAY_ENTRUST_AMOUNT AS ENTR_VOL, --当日委托数量
       T4.EN_TODAY_ENTRUST_BALANCE AS ENTR_VAL, --当日委托金额
       T4.L_TODAY_DEAL_AMOUNT AS TNV_VOL, --当日成交数量
       T4.EN_TODAY_DEAL_BALANCE AS TNV_VAL, --当日成交金额
       T0.L_TRADE_RIVAL_NO AS TRD_CNTP_ID, --交易对手编码
       NULL AS APPT_NUM, --约定号
       NULL AS GUAR_SETT_FLAG, --担保交收标识
       GREATEST(T0.L_BEGIN_DATE,T0.L_DATE) AS DELI_DT, --交割日期
       T0.L_DIRECT_OPERATOR AS RELA_RRSN, --下达人
       T0.L_DIRECT_INSTEAD_OPERATOR AS AGT_RELA_RRSN, --代下达人
       T0.VC_SUMMARY AS MEMO, --备注
       NULL AS CONT_DAYS, --合约天数
       NULL AS INTA_DAYS, --计息天数
       NULL AS CONT_TNV_DT, --合约成交日期
       NULL AS CONT_END_DT, --合约到期日期
       NULL AS FIR_DELI_DT, --首期交割日期
       NULL AS END_DELI_DT, --到期交割日期
       NULL AS FIR_DELI_MODE, --首期交割方式
       NULL AS END_DELI_MODE, --到期交割方式
       NULL AS BUYB_VAL, --购回金额
       NULL AS INTR, --利息
       NULL AS IN_PRD_CODE, --转入产品代码
       NULL AS IN_AST_UNIT_CODE, --转入资产单元代码
       NULL AS IN_PFL_CODE, --转入投组代码
       NULL AS IN_INV_TYP, --转入投资类型
       NULL AS IN_SECU_ID, --转入证券编码
       NULL AS IN_SRC_SECU_ID, --转入源证券ID
       NULL AS IN_ODR_VOL, --转入指令数量
       NULL AS IN_ODR_PRC, --转入指令价格
       NULL AS IN_ODR_VAL, --转入指令金额
       T4.VC_RIVAL_SEAT AS CNTP_SEAT_CODE, --对手方席位号
       0 AS RES_FLAG, --限售标识
       NULL AS LOCK_LMT_CLAS, --锁定受限类型
       NULL AS LMT_CLAS_ONUM, --受限类型序号
       NULL AS AGMT_NUM, --合同号
       NULL AS BONS_MODE, --分红方式
       NULL AS PAY_DT, --缴款日期
       NULL AS CONT_MULT, --合约乘数
       NULL AS ARBI_FLAG, --套利标志
       NULL AS ESTI_CASH_DIFF, --预估现金差额
       NULL AS ETF_FND_CLAS, --ETF基金类型
       CASE
         WHEN T0.C_INSTRUCTION_STATUS IN ('5') THEN --审批拒绝
          '4'
         WHEN T0.C_INSTRUCTION_STATUS IN ('6') THEN --分发拒绝
          '5'
         ELSE
          T0.C_INSTRUCTION_STATUS
       END AS ODR_STAT, --指令状态
       ${current_date} AS BUSI_DATE, --业务日期
       'evt_exch_odr_real_12' AS TASK_RS_ID, --任务来源标识
	   CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_OPERATOR_NO AS DELR_ID, --交易员
	     T0.L_DATE	AS P_DT,
	     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TINSTRUCTION T0
 INNER JOIN ${ods_db}.O3_TINSTRUCTIONSTOCK T4
    ON T0.L_DATE = T4.L_DATE
   AND T0.L_DAILY_INSTRUCTION_NO = T4.L_DAILY_INSTRUCTION_NO
   AND T0.L_INDEX_DAILY_MODIFY = T4.L_INDEX_DAILY_MODIFY
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T4.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T4.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5
    ON T4.L_DATE = T5.L_DATE
   AND T4.VC_INTER_CODE = T5.VC_INTER_CODE
 WHERE T0.C_BUSIN_CLASS IN ('1')
   AND T4.C_ENTRUST_DIRECTION IN ('H', 'I')
   AND T0.C_INSTRUCTION_STATUS IN ('1', '2', '3', '5', '6') --1:有效；2:已修改；3:已撤销；5:审批拒绝；6:分发拒绝
   AND T0.L_DATE = ${current_date}

UNION ALL
--指令：议案投票
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       concat('0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '|0|0') AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY) AS ODR_ONUM, --指令序号
       T0.C_INSTRUCTION_TYPE AS ODR_CLAS, --指令类型
       T0.L_DIRECT_DATE AS ODR_RELA_DT, --指令下达日期
       T0.L_BEGIN_DATE AS ODR_STRT_DT, --指令开始日期
       T0.L_END_DATE AS ODR_END_DT, --指令结束日期
       T0.L_BEGIN_TIME AS ODR_STRT_TIME, --指令开始时间
       T0.L_END_TIME AS ODR_END_TIME, --指令结束时间
       T0.C_STOCK_TARGET_TYPE AS ODR_CTRL_CLAS, --指令控制类型
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY , '_' , T4.L_STOCK_SERIAL_NO) AS ODR_SECU_ONUM, --指令证券序号
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T4.L_BASECOMBI_ID , '_' , T6.VC_REPORT_CODE , '.STK.' , --股票
       (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end) , '_' , (CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T4.C_INVEST_TYPE
       END) , '_' , '29000100') AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T4.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T4.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       '290001' AS BUSI_TYP, --业务类别
       '29000100' AS BUSI_CLAS, --业务类型
       concat(T6.VC_REPORT_CODE , '.STK.' , --股票
       (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end)) AS SECU_ID, --证券编码
       CASE
         WHEN T5.C_MARKET_NO = '1' THEN
          'SH'
         WHEN T5.C_MARKET_NO = '2' THEN
          'SZ'
       END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T6.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       0 AS CLR_SPED, --清算速度
       'PLAT_BID' AS TRD_PLFM, --交易平台
	   NULL AS TRD_MODE,--交易方式
       '25' AS ENTR_DIR, --委托方向
       CASE
         WHEN T4.C_PRICE_TYPE IN ('4', '5', '6') THEN
          '2'
         ELSE
          '1'
       END AS ODR_PRC_CLAS, --指令价格类型
       T4.EN_PRICE1 AS ODR_PRC, --指令价格
       NULL AS RAT, --利率
       T4.L_AMOUNT AS ODR_VOL, --指令数量
       T4.EN_BALANCE AS ODR_VAL, --指令金额
       0 AS BGNG_HAS_ENTR_VOL, --期初已委托数量
       0 AS BGNG_HAS_ENTR_VAL, --期初已委托金额
       0 AS BGNG_HAS_TNV_VOL, --期初已成交数量
       0 AS BGNG_HAS_TNV_VAL, --期初已成交金额
       0 AS ENTR_VOL, --当日委托数量
       0 AS ENTR_VAL, --当日委托金额
       0 AS TNV_VOL, --当日成交数量
       0 AS TNV_VAL, --当日成交金额
       T0.L_TRADE_RIVAL_NO AS TRD_CNTP_ID, --交易对手编码
       NULL AS APPT_NUM, --约定号
       NULL AS GUAR_SETT_FLAG, --担保交收标识
       GREATEST(T0.L_BEGIN_DATE, T0.L_DATE) AS DELI_DT, --交割日期
       T0.L_DIRECT_OPERATOR AS RELA_RRSN, --下达人
       T0.L_DIRECT_INSTEAD_OPERATOR AS AGT_RELA_RRSN, --代下达人
       T0.VC_SUMMARY AS MEMO, --备注
       NULL AS CONT_DAYS, --合约天数
       NULL AS INTA_DAYS, --计息天数
       NULL AS CONT_TNV_DT, --合约成交日期
       NULL AS CONT_END_DT, --合约到期日期
       NULL AS FIR_DELI_DT, --首期交割日期
       NULL AS END_DELI_DT, --到期交割日期
       NULL AS FIR_DELI_MODE, --首期交割方式
       NULL AS END_DELI_MODE, --到期交割方式
       NULL AS BUYB_VAL, --购回金额
       NULL AS INTR, --利息
       NULL AS IN_PRD_CODE, --转入产品代码
       NULL AS IN_AST_UNIT_CODE, --转入资产单元代码
       NULL AS IN_PFL_CODE, --转入投组代码
       NULL AS IN_INV_TYP, --转入投资类型
       NULL AS IN_SECU_ID, --转入证券编码
       NULL AS IN_SRC_SECU_ID, --转入源证券ID
       NULL AS IN_ODR_VOL, --转入指令数量
       NULL AS IN_ODR_PRC, --转入指令价格
       NULL AS IN_ODR_VAL, --转入指令金额
       T4.VC_RIVAL_SEAT AS CNTP_SEAT_CODE, --对手方席位号
       0 AS RES_FLAG, --限售标识
       NULL AS LOCK_LMT_CLAS, --锁定受限类型
       NULL AS LMT_CLAS_ONUM, --受限类型序号
       NULL AS AGMT_NUM, --合同号
       NULL AS BONS_MODE, --分红方式
       NULL AS PAY_DT, --缴款日期
       NULL AS CONT_MULT, --合约乘数
       NULL AS ARBI_FLAG, --套利标志
       NULL AS ESTI_CASH_DIFF, --预估现金差额
       NULL AS ETF_FND_CLAS, --ETF基金类型
       CASE
         WHEN T0.C_INSTRUCTION_STATUS IN ('5') THEN --审批拒绝
          '4'
         WHEN T0.C_INSTRUCTION_STATUS IN ('6') THEN --分发拒绝
          '5'
         ELSE
          T0.C_INSTRUCTION_STATUS
       END AS ODR_STAT, --指令状态
       ${current_date} AS BUSI_DATE, --业务日期
       'evt_exch_odr_real_13' AS TASK_RS_ID, --任务来源标识
	   CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_OPERATOR_NO AS DELR_ID, --交易员
	     T0.L_DATE	AS P_DT,
	     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TINSTRUCTION T0
 INNER JOIN ${ods_db}.O3_TINSTRUCTIONSTOCK T4
    ON T0.L_DATE = T4.L_DATE
   AND T0.L_DAILY_INSTRUCTION_NO = T4.L_DAILY_INSTRUCTION_NO
   AND T0.L_INDEX_DAILY_MODIFY = T4.L_INDEX_DAILY_MODIFY
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T4.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T4.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5
    ON T4.L_DATE = T5.L_DATE
   AND T4.VC_INTER_CODE = T5.VC_INTER_CODE
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T6
    ON T4.L_DATE = T6.L_DATE
   AND T5.VC_ASSET_RELATIVE_CODE = T6.VC_INTER_CODE
  LEFT JOIN ${ods_db}.O3_TPREACCEPTEDOFFERS T7
    ON cast(T4.EN_PRICE1 as string) = T7.VC_TENDERER_ID
   AND T4.VC_INTER_CODE = T7.VC_INTER_CODE
 WHERE T0.C_BUSIN_CLASS IN ('1')
   AND T4.C_ENTRUST_DIRECTION IN ('O')
   AND T0.C_INSTRUCTION_STATUS IN ('1', '2', '3', '5', '6') --1:有效；2:已修改；3:已撤销；5:审批拒绝；6:分发拒绝
   AND T0.L_DATE = ${current_date}

UNION ALL
--供股权(公开配售)申报\申报撤销
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       concat('0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '|0|0') AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY) AS ODR_ONUM, --指令序号
       T0.C_INSTRUCTION_TYPE AS ODR_CLAS, --指令类型
       T0.L_DIRECT_DATE AS ODR_RELA_DT, --指令下达日期
       T0.L_BEGIN_DATE AS ODR_STRT_DT, --指令开始日期
       T0.L_END_DATE AS ODR_END_DT, --指令结束日期
       T0.L_BEGIN_TIME AS ODR_STRT_TIME, --指令开始时间
       T0.L_END_TIME AS ODR_END_TIME, --指令结束时间
       T0.C_STOCK_TARGET_TYPE AS ODR_CTRL_CLAS, --指令控制类型
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_INDEX_DAILY_MODIFY , '_' , T4.L_STOCK_SERIAL_NO) AS ODR_SECU_ONUM, --指令证券序号
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T4.L_BASECOMBI_ID , '_' , T6.VC_REPORT_CODE , '.WRNT.' , --权证
       (case when T5.C_MARKET_NO = 'n' then 'SHSC' when T5.C_MARKET_NO = 'o' then 'SZSC' end) , '_' , (CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T4.C_INVEST_TYPE
       END) , '_' , (CASE
         WHEN T4.C_ENTRUST_DIRECTION = '9' THEN
          '06000103'
         WHEN T4.C_ENTRUST_DIRECTION = '19' THEN
          '06000104'
       END)) AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T4.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T4.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       '060001' AS BUSI_TYP, --业务类别
       CASE
         WHEN T4.C_ENTRUST_DIRECTION = '9' THEN
          '06000103'
         WHEN T4.C_ENTRUST_DIRECTION = '19' THEN
          '06000104'
       END AS BUSI_CLAS, --业务类型
       concat(T6.VC_REPORT_CODE , '.WRNT.' , --权证
       (case when T5.C_MARKET_NO = 'n' then 'SHSC' when T5.C_MARKET_NO = 'o' then 'SZSC' end)) AS SECU_ID, --证券编码
       case when T5.C_MARKET_NO = 'n' then 'SHSC' when T5.C_MARKET_NO = 'o' then 'SZSC' end AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T6.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       T4.L_SETTLE_SPEED AS CLR_SPED, --清算速度
       NULL AS TRD_PLFM, --交易平台
	   NULL AS TRD_MODE,--交易方式
       CASE
         WHEN T4.C_ENTRUST_DIRECTION = '9' THEN
          '9'
         WHEN T4.C_ENTRUST_DIRECTION = '19' THEN
          '96'
       END AS ENTR_DIR, --委托方向
       CASE
         WHEN T4.C_PRICE_TYPE IN ('4', '5', '6') THEN
          '2'
         ELSE
          '1'
       END AS ODR_PRC_CLAS, --指令价格类型
       case when T4.EN_PRICE1 = 0 then T4.EN_FACT_PRICE else T4.EN_PRICE1 end AS ODR_PRC, --指令价格
       NULL AS RAT, --利率
       T4.L_AMOUNT AS ODR_VOL, --指令数量
       T4.EN_BALANCE AS ODR_VAL, --指令金额
       T4.L_TOTAL_ENTRUST_AMOUNT AS BGNG_HAS_ENTR_VOL, --期初已委托数量
       T4.EN_TOTAL_ENTRUST_BALANCE AS BGNG_HAS_ENTR_VAL, --期初已委托金额
       T4.L_TOTAL_DEAL_AMOUNT AS BGNG_HAS_TNV_VOL, --期初已成交数量
       T4.EN_TOTAL_DEAL_BALANCE AS BGNG_HAS_TNV_VAL, --期初已成交金额
       T4.L_TODAY_ENTRUST_AMOUNT AS ENTR_VOL, --当日委托数量
       T4.EN_TODAY_ENTRUST_BALANCE AS ENTR_VAL, --当日委托金额
       T4.L_TODAY_DEAL_AMOUNT AS TNV_VOL, --当日成交数量
       T4.EN_TODAY_DEAL_BALANCE AS TNV_VAL, --当日成交金额
       T0.L_TRADE_RIVAL_NO AS TRD_CNTP_ID, --交易对手编码
       NULL AS APPT_NUM, --约定号
       NULL AS GUAR_SETT_FLAG, --担保交收标识
       W2.aft_1_dt AS DELI_DT, --交割日期
       T0.L_DIRECT_OPERATOR AS RELA_RRSN, --下达人
       T0.L_DIRECT_INSTEAD_OPERATOR AS AGT_RELA_RRSN, --代下达人
       T0.VC_SUMMARY AS MEMO, --备注
       NULL AS CONT_DAYS, --合约天数
       NULL AS INTA_DAYS, --计息天数
       NULL AS CONT_TNV_DT, --合约成交日期
       NULL AS CONT_END_DT, --合约到期日期
       NULL AS FIR_DELI_DT, --首期交割日期
       NULL AS END_DELI_DT, --到期交割日期
       NULL AS FIR_DELI_MODE, --首期交割方式
       NULL AS END_DELI_MODE, --到期交割方式
       NULL AS BUYB_VAL, --购回金额
       NULL AS INTR, --利息
       NULL AS IN_PRD_CODE, --转入产品代码
       NULL AS IN_AST_UNIT_CODE, --转入资产单元代码
       NULL AS IN_PFL_CODE, --转入投组代码
       NULL AS IN_INV_TYP, --转入投资类型
       concat(T8.VC_REPORT_CODE , '.STK.' , --股票
       case when T5.C_MARKET_NO = 'n' then 'SHSC' when T5.C_MARKET_NO = 'o' then 'SZSC' end) AS IN_SECU_ID, --转入证券编码
       T8.VC_INTER_CODE AS IN_SRC_SECU_ID, --转入源证券ID
       NULL AS IN_ODR_VOL, --转入指令数量
       NULL AS IN_ODR_PRC, --转入指令价格
       NULL AS IN_ODR_VAL, --转入指令金额
       T4.VC_RIVAL_SEAT AS CNTP_SEAT_CODE, --对手方席位号
       0 AS RES_FLAG, --限售标识
       NULL AS LOCK_LMT_CLAS, --锁定受限类型
       NULL AS LMT_CLAS_ONUM, --受限类型序号
       NULL AS AGMT_NUM, --合同号
       NULL AS BONS_MODE, --分红方式
       W1.aft_1_dt AS PAY_DT, --缴款日期
       NULL AS CONT_MULT, --合约乘数
       NULL AS ARBI_FLAG, --套利标志
       NULL AS ESTI_CASH_DIFF, --预估现金差额
       NULL AS ETF_FND_CLAS, --ETF基金类型
       CASE
         WHEN T0.C_INSTRUCTION_STATUS IN ('5') THEN --审批拒绝
          '4'
         WHEN T0.C_INSTRUCTION_STATUS IN ('6') THEN --分发拒绝
          '5'
         ELSE
          T0.C_INSTRUCTION_STATUS
       END AS ODR_STAT, --指令状态
       ${current_date} AS BUSI_DATE, --业务日期
       'evt_exch_odr_real_14' AS TASK_RS_ID, --任务来源标识
	   CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_OPERATOR_NO AS DELR_ID, --交易员
	     T0.L_DATE	AS P_DT,
	     'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TINSTRUCTION T0
 INNER JOIN ${ods_db}.O3_TINSTRUCTIONSTOCK T4
    ON T0.L_DATE = T4.L_DATE
   AND T0.L_DAILY_INSTRUCTION_NO = T4.L_DAILY_INSTRUCTION_NO
   AND T0.L_INDEX_DAILY_MODIFY = T4.L_INDEX_DAILY_MODIFY
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T4.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T4.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5
    ON T4.L_DATE = T5.L_DATE
   AND T4.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.C_ASSET_CLASS IN ('7','6', '3', '2')
   AND T5.C_MARKET_NO IN ('n', 'o') --1是上交所、2深交所
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T6 --证券基本信息表，获取权证代码
    ON T5.L_DATE = T6.L_DATE
   AND T5.VC_FROZEN_CODE = T6.VC_INTER_CODE
   AND T6.C_MARKET_NO IN ('n', 'o') --1是上交所、2深交所
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T8 --证券基本信息表，获取股票代码
    ON T5.L_DATE = T8.L_DATE
   AND T5.VC_ASSET_RELATIVE_CODE = T8.VC_INTER_CODE
   AND T8.C_ASSET_CLASS IN ('2', '3', '6')
   AND T8.C_MARKET_NO IN ('n', 'o') --1是上交所、2深交所
  LEFT JOIN (
       SELECT ZQDM,TZLB,RQ2,RQ3
         FROM ${ods_db}.O3_THISHKTZXXINFO
        UNION ALL
       SELECT ZQDM,TZLB,RQ2,RQ3
         FROM ${ods_db}.O3_THKTZXXINFO
  ) T7 --当前表和历史表取合集
    ON T8.VC_REPORT_CODE = T7.ZQDM
   AND T7.TZLB IN ('H13', 'H14')
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
    ON T7.RQ3 = w1.dt
   AND T5.C_MARKET_NO = w1.mkt_no
   AND W1.SYS_RS_ID = 'O3'
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_settle W2
    ON W1.aft_1_dt = w2.dt
   AND T5.C_MARKET_NO = w2.mkt_no
   AND W2.SYS_RS_ID = 'O3'
 WHERE T0.C_BUSIN_CLASS IN ('1')
   AND T4.C_ENTRUST_DIRECTION IN ('9', '19')
   AND T5.C_MARKET_NO IN ('n', 'o')
   AND T0.C_INSTRUCTION_STATUS IN ('1', '2', '3', '5', '6') --1:有效；2:已修改；3:已撤销；5:审批拒绝；6:分发拒绝
   AND T0.L_BEGIN_DATE >= T7.RQ2
   AND T0.L_BEGIN_DATE <= T7.RQ3
   AND T0.L_DATE = ${current_date}

UNION ALL
--指令：分销买入\分销卖出
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       CONCAT('0|', T0.L_DATE, '_HSO32', '_', T0.L_DAILY_INSTRUCTION_NO, '|0|0') AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       date_format(D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
       CONCAT(T0.L_DATE, '_HSO32', '_', T0.L_DAILY_INSTRUCTION_NO, '_', T0.L_INDEX_DAILY_MODIFY) AS ODR_ONUM, --指令序号
       T0.C_INSTRUCTION_TYPE AS ODR_CLAS, --指令类型
       T0.L_DIRECT_DATE AS ODR_RELA_DT, --指令下达日期
       T0.L_BEGIN_DATE AS ODR_STRT_DT, --指令开始日期
       T0.L_END_DATE AS ODR_END_DT, --指令结束日期
       T0.L_BEGIN_TIME AS ODR_STRT_TIME, --指令开始时间
       T0.L_END_TIME AS ODR_END_TIME, --指令结束时间
       T0.C_STOCK_TARGET_TYPE AS ODR_CTRL_CLAS, --指令控制类型
       CONCAT(T0.L_DATE, '_HSO32', '_', T0.L_DAILY_INSTRUCTION_NO, '_', T0.L_INDEX_DAILY_MODIFY, '_', T4.L_STOCK_SERIAL_NO) AS ODR_SECU_ONUM, --指令证券序号
       CONCAT(T0.L_DATE, '_HSO32', '_', T0.L_DAILY_INSTRUCTION_NO, '_', T4.L_BASECOMBI_ID, '_',
              (CASE
                   WHEN T6.C_ASSET_CLASS = '3' THEN --债券
                       CONCAT(T6.VC_REPORT_CODE, '.BOND.', (CASE WHEN T6.C_MARKET_NO = '1' THEN 'SH' WHEN T6.C_MARKET_NO = '2' THEN 'SZ' END))
                  END), '_',
              (CASE
                   WHEN T4.C_INVEST_TYPE IN ('1') THEN
                       '2' --交易型金融资产
                   WHEN T4.C_INVEST_TYPE IN ('2') THEN
                       '1' --持有到期资产
                   ELSE
                       T4.C_INVEST_TYPE
                  END), '_',
              (CASE
                   WHEN T4.C_ENTRUST_DIRECTION in ('r') THEN
                       '01000102'
                   WHEN T4.C_ENTRUST_DIRECTION in ('L') THEN
                       '01000103'
                  END)
           ) AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       CONCAT(T1.VC_FUND_CODE, '_', T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE, '_', T2.VC_ASSET_NO, '_', T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T4.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       CASE
           WHEN T4.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
           WHEN T4.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
           ELSE
               T4.C_INVEST_TYPE
           END AS INV_TYP, --投资类型
       '010001' AS BUSI_TYP, --业务类别
       CASE
           WHEN T4.C_ENTRUST_DIRECTION in ('r') THEN
               '01000102'
           WHEN T4.C_ENTRUST_DIRECTION in ('L') THEN
               '01000103'
           END AS BUSI_CLAS, --业务类型
       CASE
           WHEN T6.C_ASSET_CLASS = '3' THEN --债券
               CONCAT(T6.VC_REPORT_CODE, '.BOND.', (CASE WHEN T6.C_MARKET_NO = '1' THEN 'SH' WHEN T6.C_MARKET_NO = '2' THEN 'SZ' END))
           END AS SECU_ID, --证券编码
       CASE
           WHEN T5.C_MARKET_NO = '1' THEN
               'SH'
           WHEN T5.C_MARKET_NO = '2' THEN
               'SZ'
           END AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T6.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       T4.L_SETTLE_SPEED AS CLR_SPED, --清算速度
       CASE
           WHEN T0.C_BUSIN_CLASS IN ('1') THEN
               'PLAT_BID'
           END AS TRD_PLFM, --交易平台
       NULL AS TRD_MODE, --交易方式
       CASE
           WHEN T4.C_ENTRUST_DIRECTION in ('r') THEN
               '21'
           WHEN T4.C_ENTRUST_DIRECTION in ('L') THEN
               '22'
           END AS ENTR_DIR, --委托方向
       CASE
           WHEN T4.C_PRICE_TYPE IN ('4', '5', '6') THEN
               '2'
           ELSE
               '1'
           END AS ODR_PRC_CLAS, --指令价格类型
       CASE WHEN T4.EN_PRICE1 = 0 THEN T4.EN_FACT_PRICE ELSE T4.EN_PRICE1 END AS ODR_PRC, --指令价格
       NULL AS RAT, --利率
       T4.L_AMOUNT AS ODR_VOL, --指令数量
       T4.EN_BALANCE AS ODR_VAL, --指令金额
       T4.L_TOTAL_ENTRUST_AMOUNT AS BGNG_HAS_ENTR_VOL, --期初已委托数量
       T4.EN_TOTAL_ENTRUST_BALANCE AS BGNG_HAS_ENTR_VAL, --期初已委托金额
       T4.L_TOTAL_DEAL_AMOUNT AS BGNG_HAS_TNV_VOL, --期初已成交数量
       T4.EN_TOTAL_DEAL_BALANCE AS BGNG_HAS_TNV_VAL, --期初已成交金额
       T4.L_TODAY_ENTRUST_AMOUNT AS ENTR_VOL, --当日委托数量
       T4.EN_TODAY_ENTRUST_BALANCE AS ENTR_VAL, --当日委托金额
       T4.L_TODAY_DEAL_AMOUNT AS TNV_VOL, --当日成交数量
       T4.EN_TODAY_DEAL_BALANCE AS TNV_VAL, --当日成交金额
       T0.L_TRADE_RIVAL_NO AS TRD_CNTP_ID, --交易对手编码
       NULL AS APPT_NUM, --约定号
       NULL AS GUAR_SETT_FLAG, --担保交收标识
       --SF_OFFSET_TRADEDAY(GREATEST(T0.L_BEGIN_DATE,T0.L_DATE), 1, 2, T5.C_MARKET_NO, 2) AS DELI_DT, --交割日期
       T7.AFT_1_DT AS DELI_DT, --交割日期
       T0.L_DIRECT_OPERATOR AS RELA_RRSN, --下达人
       T0.L_DIRECT_INSTEAD_OPERATOR AS AGT_RELA_RRSN, --代下达人
       T0.VC_SUMMARY AS MEMO, --备注
       NULL AS CONT_DAYS, --合约天数
       NULL AS INTA_DAYS, --计息天数
       NULL AS CONT_TNV_DT, --合约成交日期
       NULL AS CONT_END_DT, --合约到期日期
       NULL AS FIR_DELI_DT, --首期交割日期
       NULL AS END_DELI_DT, --到期交割日期
       NULL AS FIR_DELI_MODE, --首期交割方式
       NULL AS END_DELI_MODE, --到期交割方式
       NULL AS BUYB_VAL, --购回金额
       NULL AS INTR, --利息
       NULL AS IN_PRD_CODE, --转入产品代码
       NULL AS IN_AST_UNIT_CODE, --转入资产单元代码
       NULL AS IN_PFL_CODE, --转入投组代码
       NULL AS IN_INV_TYP, --转入投资类型
       NULL AS IN_SECU_ID, --转入证券编码
       NULL AS IN_SRC_SECU_ID, --转入源证券ID
       NULL AS IN_ODR_VOL, --转入指令数量
       NULL AS IN_ODR_PRC, --转入指令价格
       NULL AS IN_ODR_VAL, --转入指令金额
       T4.VC_RIVAL_SEAT AS CNTP_SEAT_CODE, --对手方席位号
       0 AS RES_FLAG, --限售标识
       NULL AS LOCK_LMT_CLAS, --锁定受限类型
       NULL AS LMT_CLAS_ONUM, --受限类型序号
       NULL AS AGMT_NUM, --合同号
       NULL AS BONS_MODE, --分红方式
       NULL AS PAY_DT, --缴款日期
       NULL AS CONT_MULT, --合约乘数
       NULL AS ARBI_FLAG, --套利标志
       NULL AS ESTI_CASH_DIFF, --预估现金差额
       NULL AS ETF_FND_CLAS, --ETF基金类型
       CASE
           WHEN T0.C_INSTRUCTION_STATUS IN ('5') THEN --审批拒绝
               '4'
           WHEN T0.C_INSTRUCTION_STATUS IN ('6') THEN --分发拒绝
               '5'
           ELSE
               T0.C_INSTRUCTION_STATUS
           END AS ODR_STAT, --指令状态
       ${current_date} AS BUSI_DATE, --业务日期
       'evt_exch_odr_real_15' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_OPERATOR_NO AS DELR_ID, --交易员
       T0.L_DATE AS P_DT,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TINSTRUCTION T0
       INNER JOIN ${ods_db}.O3_TINSTRUCTIONSTOCK T4
               ON T0.L_DATE = T4.L_DATE
              AND T0.L_DAILY_INSTRUCTION_NO = T4.L_DAILY_INSTRUCTION_NO
              AND T0.L_INDEX_DAILY_MODIFY = T4.L_INDEX_DAILY_MODIFY
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
              ON T4.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
              ON T4.L_BASECOMBI_ID = T3.L_COMBI_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
              ON T3.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5
              ON T4.L_DATE = T5.L_DATE
             AND T4.VC_INTER_CODE = T5.VC_INTER_CODE
       LEFT JOIN ${ods_db}.O3_TSTOCKINFO T6
              ON T4.L_DATE = T6.L_DATE
             AND T5.VC_MATCH_RELATIVE2_CODE = T6.VC_INTER_CODE
       LEFT JOIN ${dwd_db}.PUB_TRADEDAY_OFFSET_TRADE T7
              ON GREATEST(T0.L_BEGIN_DATE,T0.L_DATE) = T7.DT
             AND T5.C_MARKET_NO = T7.MKT_NO
             AND T7.SYS_RS_ID = 'O3'
 WHERE T0.C_BUSIN_CLASS IN ('1')
   AND T4.C_ENTRUST_DIRECTION IN ('r', 'L')
   AND T0.C_INSTRUCTION_STATUS IN ('1', '2', '3', '5', '6') --1:有效；2:已修改；3:已撤销；5:审批拒绝；6:分发拒绝
   AND T0.L_DATE = ${current_date}
