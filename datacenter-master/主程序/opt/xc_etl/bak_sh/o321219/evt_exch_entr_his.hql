------------------------------------------------------------------------
  -- 模块名称：交易所委托表(离线)
  --交易所现券买卖
  --委托：质押入库\出库
  --委托：质押式回购
  --离线委托：配股/债/上交所老股东配售（通过识别当天有无增发代码）
  --委托：网上新股/新债业务
  --委托：预受要约\预受要约撤销
  --委托：债回售申报
  --离线委托：股指期货\国债期货\商品期货
  --离线委托：场内转托管
  --离线委托：跨市场转托管转出（基金）
  --离线委托：转融券成交/展期/提前了结
  --离线委托：债转股
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

alter table ${dwd_db}.evt_exch_entr_his drop if exists partition (p_dt>=${beg_date} , p_dt<=${end_date},sys_rs_id='O3') ;

insert into ${dwd_db}.evt_exch_entr_his partition(p_dt,sys_rs_id)
(busi_sys_id,trd_src_id,occu_dt,occu_time,entr_onum,entr_btno,whdw_entr_onum,rep_id,odr_rela_onum,prd_code,ast_unit_code,pfl_code,sh_code,seat_code,inv_typ,secu_id,exch_code,secu_code,src_secu_id,src_secu_trd_id,pos_id,curr_code,clr_sped,trd_plfm,trd_mode,entr_dir,entr_prc_clas,entr_vol,whdw_vol,entr_prc,busi_typ,busi_clas,rat,entr_val,entr_tot_fee,oper_no,trd_cntp_id,appt_num,guar_sett_flag,deli_dt,cont_days,inta_days,cont_tnv_dt,cont_end_dt,fir_deli_dt,end_deli_dt,fir_deli_mode,end_deli_mode,buyb_val,intr,in_prd_code,in_ast_unit_code,in_pfl_code,in_sh_code,in_seat_code,in_inv_typ,in_secu_id,in_src_secu_id,in_entr_vol,in_entr_prc,in_entr_val,cntp_seat_code,res_flag,lock_lmt_clas,lmt_clas_onum,agmt_num,bons_mode,pay_dt,cont_mult,covr_dir,arbi_flag,etf_onum,esti_cash_diff,etf_fnd_clas,entr_stat,busi_date,task_rs_id,dm_created_time,p_dt,sys_rs_id)
--交易所现券买卖
SELECT T.BUSI_SYS_ID, --业务系统编码
T.TRD_SRC_ID, --交易源ID
T.OCCU_DT, --发生日期
T.OCCU_TIME, --发生时间
T.ENTR_ONUM, --委托序号
T.ENTR_BTNO, --委托批号
T.WHDW_ENTR_ONUM, --被撤单委托序号
T.REP_ID, --申报编号
T.ODR_RELA_ONUM, --指令关联序号
T.PRD_CODE, --产品代码
T.AST_UNIT_CODE, --资产单元代码
T.PFL_CODE, --投组代码
T.SH_CODE, --股东代码
T.SEAT_CODE, --席位号
T.INV_TYP, --投资类型
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
T.ENTR_PRC_CLAS, --委托价格类型
T.ENTR_VOL, --委托数量
T.WHDW_VOL, --撤单数量
T.ENTR_PRC, --委托价格
T.BUSI_TYP, --业务类别
T.BUSI_CLAS, --业务类型
T.RAT, --利率
T.ENTR_VAL, --委托金额
T.ENTR_TOT_FEE, --委托总费用
T.OPER_NO, --操作员编码
T.TRD_CNTP_ID, --交易对手编码
T.APPT_NUM, --约定号
T.GUAR_SETT_FLAG, --担保交收标志
T.DELI_DT, --交割日期
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
T.IN_SH_CODE, --转入股东代码
T.IN_SEAT_CODE, --转入席位号
T.IN_INV_TYP, --转入投资类型
T.IN_SECU_ID, --转入证券编码
T.IN_SRC_SECU_ID, --转入源证券ID
T.IN_ENTR_VOL, --转入委托数量
T.IN_ENTR_PRC, --转入委托价格
T.IN_ENTR_VAL, --转入委托金额
T.CNTP_SEAT_CODE, --对手方席位号
T.RES_FLAG, --限售标识
T.LOCK_LMT_CLAS, --锁定受限类型
T.LMT_CLAS_ONUM, --受限类型序号
T.AGMT_NUM, --合同号
T.BONS_MODE, --分红方式
T.PAY_DT, --缴款日期
T.CONT_MULT, --合约乘数
T.COVR_DIR, --平仓方向
T.ARBI_FLAG, --套利标志
T.ETF_ONUM, --ETF序号
T.ESTI_CASH_DIFF, --预估现金差额
T.ETF_FND_CLAS, --ETF基金类型
T.ENTR_STAT, --委托状态
T.BUSI_DATE, --业务日期
T.TASK_RS_ID, --任务来源标识
T.DM_CREATED_TIME, --数据中台创建时间
T.P_DT,
T.SYS_RS_ID --系统来源标识
FROM (
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       CASE
         WHEN T0.L_DAILY_INSTRUCTION_NO IS NULL OR
              T0.L_DAILY_INSTRUCTION_NO = 0 THEN
          concat('0|0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_ENTRUST_SERIAL_NO , '|0')
         ELSE
          concat('0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '|0|0')
       END AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_ENTRUST_SERIAL_NO) AS ENTR_ONUM, --委托序号
       T0.L_BATCH_SERIAL_NO AS ENTR_BTNO, --委托批号
       CASE
         WHEN T0.L_CANCEL_SERIAL_NO IS NULL THEN
          NULL
         ELSE
          concat(T0.L_DATE , '_HSO32' , '_' , T0.L_CANCEL_SERIAL_NO)
       END AS WHDW_ENTR_ONUM, --被撤单委托序号
       T0.L_REPORT_SERIAL_NO AS REP_ID, --申报编号
       CASE WHEN T0.L_DAILY_INSTRUCTION_NO IS NULL OR
              T0.L_DAILY_INSTRUCTION_NO = 0 THEN
			  NULL
			ELSE
	   concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_BASECOMBI_ID , '_' , (CASE
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
         WHEN T0.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T0.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T0.C_INVEST_TYPE
       END) , '_' , (CASE
         WHEN T0.C_ENTRUST_DIRECTION in ('1', '3') THEN
          '01000100'
         WHEN T0.C_ENTRUST_DIRECTION in ('2', '4') THEN
          '01000101'
       END))
	   END AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_REPORT_SEAT AS SEAT_CODE, --席位号
       CASE
         WHEN T0.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T0.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
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
       T0.L_SETTLE_SPEED AS CLR_SPED, --清算速度
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
         WHEN T5.C_MARKET_NO = '2' AND T0.C_PRICE_TYPE IN ('I', 'K') THEN
          2 --点击成交
         WHEN T5.C_MARKET_NO = '2' AND T0.C_PRICE_TYPE IN ('J', 'V') THEN
          3 --协商成交
         WHEN T5.C_MARKET_NO = '2' AND T0.C_PRICE_TYPE IN ('X', 'Y') THEN
          5 --竞买成交
         WHEN T5.C_MARKET_NO = '1' AND T0.C_PRICE_TYPE IN ('c', 'd', 'e', 'h') THEN
          3 --协商成交
         WHEN T5.C_MARKET_NO = '1' AND T0.C_PRICE_TYPE IN ('f') THEN
          5 --竞买成交
         ELSE
          NULL --其他成交方式
       END AS TRD_MODE,--交易方式
       T0.C_ENTRUST_DIRECTION AS ENTR_DIR, --委托方向
       CASE
         WHEN T7.C_MARKET_NO = '1' AND T7.C_PRICE_TYPE = 'P' THEN
          '31'
         WHEN T7.C_MARKET_NO = 'j' AND T7.C_PRICE_TYPE = '4' THEN
          '14'
         ELSE
          (case when T7.C_LIMIT_PRICE = 0 then '2' else T7.C_LIMIT_PRICE end)
       END AS ENTR_PRC_CLAS, --委托价格类型
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          T0.L_ENTRUST_AMOUNT
       END AS ENTR_VOL, --委托数量
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          T0.L_CANCEL_AMOUNT
       END AS WHDW_VOL, --撤单数量
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          (case when T0.EN_ENTRUST_PRICE = 0 then T0.EN_FACT_PRICE else T0.EN_ENTRUST_PRICE end)
       END AS ENTR_PRC, --委托价格
       '010001' AS BUSI_TYP, --业务类别
       CASE
         WHEN T0.C_ENTRUST_DIRECTION in ('1', '3') THEN
          '01000100'
         WHEN T0.C_ENTRUST_DIRECTION in ('2', '4') THEN
          '01000101'
       END AS BUSI_CLAS, --业务类型
       NULL AS RAT, --利率
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          T0.EN_BALANCE
       END AS ENTR_VAL, --委托金额
       0 AS ENTR_TOT_FEE, --委托总费用
       T0.L_OPERATOR_NO AS OPER_NO, --操作员编码
       T0.L_RIVAL_ID AS TRD_CNTP_ID, --交易对手编码
       NULL AS APPT_NUM, --约定号
       CASE
         WHEN T5.VC_MIXED_TYPE = 'p' AND T0.C_BUSIN_CLASS = 'I' AND
              T0.L_SETTLE_SPEED = 1 THEN --上海固收平台、非净额结算并且清算速度1，为非担保债券
          '0'
         WHEN T0.C_BUSIN_CLASS = 'I' AND T0.L_SETTLE_SPEED = 0 THEN --上海固收平台、清算速度0，为非担保债券
          '0'
         WHEN T0.C_BUSIN_CLASS = 'E' AND T5.C_MARKET_NO = '2' AND
              T0.L_SETTLE_SPEED = 0 THEN --深圳综合协议平台并且清算速度0，为非担保债券
          '0'
         ELSE
          '1' --其余为担保债券；
       END AS GUAR_SETT_FLAG, --担保交收标志
       CASE
         WHEN T0.C_ENTRUST_DIRECTION in ('1', '2') AND
              T5.C_MARKET_NO IN ('n', 'o') THEN --股票、基金、港股通买卖
          w2.aft_3_dt
         WHEN T0.C_ENTRUST_DIRECTION in ('1', '2', 'j', 'r') AND
              T5.C_MARKET_NO IN ('1', '2') THEN --股票、基金、港股通买卖
          w1.aft_2_dt
         WHEN T0.C_ENTRUST_DIRECTION IN ('3', '4') AND T0.L_SETTLE_SPEED = 0 THEN --债券买卖，清算速度为0
          T0.L_DATE
         WHEN T0.C_ENTRUST_DIRECTION IN ('3', '4') AND T0.L_SETTLE_SPEED = 1 THEN --债券买卖，清算速度为1
          w1.aft_2_dt
       END AS DELI_DT, --交割日期
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
       NULL AS IN_SH_CODE, --转入股东代码
       NULL AS IN_SEAT_CODE, --转入席位号
       NULL AS IN_INV_TYP, --转入投资类型
       NULL AS IN_SECU_ID, --转入证券编码
       NULL AS IN_SRC_SECU_ID, --转入源证券ID
       NULL AS IN_ENTR_VOL, --转入委托数量
       NULL AS IN_ENTR_PRC, --转入委托价格
       NULL AS IN_ENTR_VAL, --转入委托金额
       T0.VC_RIVAL_SEAT AS CNTP_SEAT_CODE, --对手方席位号
       CASE
         WHEN T0.C_BUSIN_CLASS = 'E' AND
              NVL(T0.C_BULKUNDERWEIGHT_FLAG, 0) <> 0 THEN
          1 --大宗交易限售
         ELSE
          0 --非限售
       END AS RES_FLAG, --限售标识
       CASE
         WHEN T0.C_BUSIN_CLASS = 'E' AND
              NVL(T0.C_BULKUNDERWEIGHT_FLAG, 0) <> 0 THEN
          3 --大宗交易买入限售
         ELSE
          0 --非限售
       END AS LOCK_LMT_CLAS, --锁定受限类型
       NULL AS LMT_CLAS_ONUM, --受限类型序号
       NULL AS AGMT_NUM, --合同号
       NULL AS BONS_MODE, --分红方式
       NULL AS PAY_DT, --缴款日期
       NULL AS CONT_MULT, --合约乘数
       NULL AS COVR_DIR, --平仓方向
	   NULL AS ARBI_FLAG, --套利标志
	   NULL AS ETF_ONUM, --ETF序号
       NULL AS ESTI_CASH_DIFF, --预估现金差额
       NULL AS ETF_FND_CLAS, --ETF基金类型
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('1') --1：未报
          THEN
          '1'
         WHEN T0.C_ENTRUST_STATUS IN ('4') --4：已报
          THEN
          '2'
         WHEN T0.C_ENTRUST_STATUS IN ('5') --5：废单
          THEN
          '3'
         WHEN T0.C_ENTRUST_STATUS IN ('6') --6：部成
          THEN
          '4'
         WHEN T0.C_ENTRUST_STATUS IN ('7') --7：已成
          THEN
          '5'
         WHEN T0.C_ENTRUST_STATUS IN ('F', '9') --F：已撤
          THEN
          '6'
         WHEN T0.C_ENTRUST_STATUS IN ('8') --8：部撤
          THEN
          '7'
         WHEN T0.C_ENTRUST_STATUS IN ('E') --E：撤废，是撤单委托的
          THEN
          '8'
       END AS ENTR_STAT, --委托状态
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_exch_entr_his_1' AS TASK_RS_ID, --任务来源标识
	   CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
	     T0.L_DATE AS P_DT,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISENTRUSTS T0
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5
    ON T0.L_DATE = T5.L_DATE
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.P_DT BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTIONDETAIL T7
    ON T0.C_ENTRUST_DIRECTION = T7.C_ENTRUST_DIRECTION
   AND T0.C_MARKET_NO = T7.C_MARKET_NO
   AND T0.C_PRICE_TYPE = T7.C_PRICE_TYPE
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
    ON T0.L_DATE = w1.dt
   AND T5.C_MARKET_NO = w1.mkt_no
   AND W1.SYS_RS_ID = 'O3'
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_settle W2
    ON T0.L_DATE = w2.dt
   AND T5.C_MARKET_NO = w2.mkt_no
   AND W2.SYS_RS_ID = 'O3'
 WHERE T0.C_BUSIN_CLASS IN ('1', 'I', 'E')
   AND T0.C_ENTRUST_DIRECTION IN ('1', '2', '3', '4')
   AND T0.C_ENTRUST_STATUS IN ('1', '4', '5', '6', '7', 'F', '8', 'E', '9')
   AND T0.P_DT BETWEEN ${beg_date} and ${end_date}
) t
left join ${dwd_db}.VAR_SECU_CODE_CHG t1
on t.secu_id = t1.secu_id
     where (t.OCCU_DT between t1.NEW_SECU_ID_BGN_DT and t1.NEW_SECU_ID_END_DT) or t1.secu_id is null

UNION ALL
--委托：质押入库\出库
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       CASE
         WHEN T0.L_DAILY_INSTRUCTION_NO IS NULL OR
              T0.L_DAILY_INSTRUCTION_NO = 0 THEN
          concat('0|0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_ENTRUST_SERIAL_NO , '|0')
         ELSE
          concat('0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '|0|0')
       END AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_ENTRUST_SERIAL_NO) AS ENTR_ONUM, --委托序号
       T0.L_BATCH_SERIAL_NO AS ENTR_BTNO, --委托批号
       CASE
         WHEN T0.L_CANCEL_SERIAL_NO IS NULL THEN
          NULL
         ELSE
          concat(T0.L_DATE , '_HSO32' , '_' , T0.L_CANCEL_SERIAL_NO)
       END AS WHDW_ENTR_ONUM, --被撤单委托序号
       T0.L_REPORT_SERIAL_NO AS REP_ID, --申报编号
       CASE WHEN T0.L_DAILY_INSTRUCTION_NO IS NULL OR
              T0.L_DAILY_INSTRUCTION_NO = 0 THEN
			  NULL
			ELSE
	   concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_BASECOMBI_ID , '_' , (CASE
         WHEN T6.C_ASSET_CLASS = '3' THEN --债券
          concat(T6.VC_REPORT_CODE , '.BOND.' , (case when T6.C_MARKET_NO = '1' then 'SH' when T6.C_MARKET_NO = '2' then 'SZ' end))
         WHEN T6.C_ASSET_CLASS = '4' THEN --基金
          concat(T6.VC_REPORT_CODE , '.FUND.' , (case when T6.C_MARKET_NO = '1' then 'SH' when T6.C_MARKET_NO = '2' then 'SZ' end))
       END) , '_' , (CASE
         WHEN T0.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T0.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T0.C_INVEST_TYPE
       END) , '_' , (CASE
         WHEN T0.C_ENTRUST_DIRECTION in ('T') THEN
          '04000100'
         WHEN T0.C_ENTRUST_DIRECTION in ('U') THEN
          '04000101'
       END))
	   END AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_REPORT_SEAT AS SEAT_CODE, --席位号
       CASE
         WHEN T0.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T0.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
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
       T0.L_SETTLE_SPEED AS CLR_SPED, --清算速度
       CASE
         WHEN T0.C_BUSIN_CLASS IN ('1') THEN
          'PLAT_BID'
         WHEN T0.C_BUSIN_CLASS = 'I' THEN
          'PLAT_FIXINC'
       END AS TRD_PLFM, --交易平台
	   NULL AS TRD_MODE,--交易方式
       CASE
         WHEN T0.C_ENTRUST_DIRECTION in ('T') THEN
          '30'
         WHEN T0.C_ENTRUST_DIRECTION in ('U') THEN
          '31'
       END AS ENTR_DIR, --委托方向
       CASE
         WHEN T7.C_MARKET_NO = '1' AND T7.C_PRICE_TYPE = 'P' THEN
          '31'
         WHEN T7.C_MARKET_NO = 'j' AND T7.C_PRICE_TYPE = '4' THEN
          '14'
         ELSE
          (case when T7.C_LIMIT_PRICE = 0 then '2' else T7.C_LIMIT_PRICE end)
       END AS ENTR_PRC_CLAS, --委托价格类型
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          T0.L_ENTRUST_AMOUNT
       END AS ENTR_VOL, --委托数量
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          T0.L_CANCEL_AMOUNT
       END AS WHDW_VOL, --撤单数量
       0 AS ENTR_PRC, --委托价格
       '040001' AS BUSI_TYP, --业务类别
       CASE
         WHEN T0.C_ENTRUST_DIRECTION in ('T') THEN
          '04000100'
         WHEN T0.C_ENTRUST_DIRECTION in ('U') THEN
          '04000101'
       END AS BUSI_CLAS, --业务类型
       NULL AS RAT, --利率
       0 AS ENTR_VAL, --委托金额
       0 AS ENTR_TOT_FEE, --委托总费用
       T0.L_OPERATOR_NO AS OPER_NO, --操作员编码
       T0.L_RIVAL_ID AS TRD_CNTP_ID, --交易对手编码
       NULL AS APPT_NUM, --约定号
       NULL AS GUAR_SETT_FLAG, --担保交收标志
       T0.L_DATE AS DELI_DT, --交割日期
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
       NULL AS IN_SH_CODE, --转入股东代码
       NULL AS IN_SEAT_CODE, --转入席位号
       NULL AS IN_INV_TYP, --转入投资类型
       NULL AS IN_SECU_ID, --转入证券编码
       NULL AS IN_SRC_SECU_ID, --转入源证券ID
       NULL AS IN_ENTR_VOL, --转入委托数量
       NULL AS IN_ENTR_PRC, --转入委托价格
       NULL AS IN_ENTR_VAL, --转入委托金额
       T0.VC_RIVAL_SEAT AS CNTP_SEAT_CODE, --对手方席位号
       0 AS RES_FLAG, --限售标识
       NULL AS LOCK_LMT_CLAS, --锁定受限类型
       NULL AS LMT_CLAS_ONUM, --受限类型序号
       NULL AS AGMT_NUM, --合同号
       NULL AS BONS_MODE, --分红方式
       NULL AS PAY_DT, --缴款日期
       NULL AS CONT_MULT, --合约乘数
       NULL AS COVR_DIR, --平仓方向
	   NULL AS ARBI_FLAG, --套利标志
	   NULL AS ETF_ONUM, --ETF序号
       NULL AS ESTI_CASH_DIFF, --预估现金差额
       NULL AS ETF_FND_CLAS, --ETF基金类型
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('1') --1：未报
          THEN
          '1'
         WHEN T0.C_ENTRUST_STATUS IN ('4') --4：已报
          THEN
          '2'
         WHEN T0.C_ENTRUST_STATUS IN ('5') --5：废单
          THEN
          '3'
         WHEN T0.C_ENTRUST_STATUS IN ('6') --6：部成
          THEN
          '4'
         WHEN T0.C_ENTRUST_STATUS IN ('7') --7：已成
          THEN
          '5'
         WHEN T0.C_ENTRUST_STATUS IN ('F', '9') --F：已撤
          THEN
          '6'
         WHEN T0.C_ENTRUST_STATUS IN ('8') --8：部撤
          THEN
          '7'
         WHEN T0.C_ENTRUST_STATUS IN ('E') --E：撤废，是撤单委托的
          THEN
          '8'
       END AS ENTR_STAT, --委托状态
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_exch_entr_his_2' AS TASK_RS_ID, --任务来源标识
	   CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
	     T0.L_DATE	 as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISENTRUSTS T0
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5
    ON T0.L_DATE = T5.L_DATE
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.P_DT BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T6
    ON T0.L_DATE = T6.L_DATE
   AND T5.VC_MATCH_RELATIVE2_CODE = T6.VC_INTER_CODE
   AND T6.P_DT BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTIONDETAIL T7
    ON T0.C_ENTRUST_DIRECTION = T7.C_ENTRUST_DIRECTION
   AND T0.C_MARKET_NO = T7.C_MARKET_NO
   AND T0.C_PRICE_TYPE = T7.C_PRICE_TYPE
 WHERE T0.C_BUSIN_CLASS IN ('1', 'I')
   AND T0.C_ENTRUST_DIRECTION IN ('U', 'T')
   AND T0.C_ENTRUST_STATUS IN ('1', '4', '5', '6', '7', 'F', '8', 'E', '9')
   AND T0.P_DT BETWEEN ${beg_date} and ${end_date}

UNION ALL
--委托：质押式回购
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       CASE
         WHEN T0.L_DAILY_INSTRUCTION_NO IS NULL OR
              T0.L_DAILY_INSTRUCTION_NO = 0 THEN
          concat('0|0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_ENTRUST_SERIAL_NO , '|0')
         ELSE
          concat('0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '|0|0')
       END AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_ENTRUST_SERIAL_NO) AS ENTR_ONUM, --委托序号
       T0.L_BATCH_SERIAL_NO AS ENTR_BTNO, --委托批号
       CASE
         WHEN T0.L_CANCEL_SERIAL_NO IS NULL THEN
          NULL
         ELSE
          concat(T0.L_DATE , '_HSO32' , '_' , T0.L_CANCEL_SERIAL_NO)
       END AS WHDW_ENTR_ONUM, --被撤单委托序号
       T0.L_REPORT_SERIAL_NO AS REP_ID, --申报编号
       CASE WHEN T0.L_DAILY_INSTRUCTION_NO IS NULL OR
              T0.L_DAILY_INSTRUCTION_NO = 0 THEN
			  NULL
			ELSE
	   concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_BASECOMBI_ID , '_' , T5.VC_REPORT_CODE , '.REPO.' ,
       (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end) , '_' , (CASE
         WHEN T0.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T0.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T0.C_INVEST_TYPE
       END) , '_' , '02000100' )
	   END AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_REPORT_SEAT AS SEAT_CODE, --席位号
       CASE
         WHEN T0.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T0.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       concat(T5.VC_REPORT_CODE , '.REPO.' , (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ'end)) AS SECU_ID, --证券编码
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
         WHEN T0.C_ENTRUST_DIRECTION IN ('5') THEN
          '2'
         WHEN T0.C_ENTRUST_DIRECTION IN ('6') THEN
          '1'
       END AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       T0.L_SETTLE_SPEED AS CLR_SPED, --清算速度
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
       T0.C_ENTRUST_DIRECTION AS ENTR_DIR, --委托方向
       CASE
         WHEN T8.C_MARKET_NO = '1' AND T8.C_PRICE_TYPE = 'P' THEN
          '31'
         WHEN T8.C_MARKET_NO = '4' AND T8.C_PRICE_TYPE = 'j' THEN
          '14'
         ELSE
          (case when T8.C_LIMIT_PRICE = 0 then '2' else T8.C_LIMIT_PRICE end)
       END AS ENTR_PRC_CLAS, --委托价格类型
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          T0.L_ENTRUST_AMOUNT
       END AS ENTR_VOL, --委托数量
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          T0.L_CANCEL_AMOUNT
       END AS WHDW_VOL, --撤单数量
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          T0.EN_FACT_PRICE
       END AS ENTR_PRC, --委托价格
       '020001' AS BUSI_TYP, --业务类别
       '02000100' AS BUSI_CLAS, --业务类型
       T0.EN_ENTRUST_PRICE AS RAT, --利率
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          T0.EN_BALANCE
       END AS ENTR_VAL, --委托金额
       0 AS ENTR_TOT_FEE, --委托总费用
       T0.L_OPERATOR_NO AS OPER_NO, --操作员编码
       T0.L_RIVAL_ID AS TRD_CNTP_ID, --交易对手编码
       NULL AS APPT_NUM, --约定号
       NULL AS GUAR_SETT_FLAG, --担保交收标志
       NULL AS DELI_DT, --交割日期
       T7.L_RATIO AS CONT_DAYS, --合约天数
	   datediff(from_unixtime(unix_timestamp(cast(w1.aft_2_dt as string),'yyyyMMdd'),'yyyy-MM-dd'),from_unixtime(unix_timestamp(cast(w2.aft_2_dt as string),'yyyyMMdd'),'yyyy-MM-dd')) AS INTA_DAYS, --计息天数
       T0.L_DATE AS CONT_TNV_DT, --合约成交日期
       w1.aft_1_dt AS CONT_END_DT, --合约到期日期
       w2.aft_2_dt AS FIR_DELI_DT, --首期交割日期
       w1.aft_2_dt AS END_DELI_DT, --到期交割日期
       '3' AS FIR_DELI_MODE, --首期交割方式
       '3' AS END_DELI_MODE, --到期交割方式
       ROUND(T0.EN_BALANCE + (datediff(from_unixtime(unix_timestamp(cast(w1.aft_2_dt as string),'yyyyMMdd'),'yyyy-MM-dd'),from_unixtime(unix_timestamp(cast(w2.aft_2_dt as string),'yyyyMMdd'),'yyyy-MM-dd'))
	   ) * cast(T0.EN_ENTRUST_PRICE as double) /100 /365 * cast(T0.EN_BALANCE as double),2) AS BUYB_VAL, --购回金额
       ROUND((datediff(from_unixtime(unix_timestamp(cast(w1.aft_2_dt as string),'yyyyMMdd'),'yyyy-MM-dd'),from_unixtime(unix_timestamp(cast(w2.aft_2_dt as string),'yyyyMMdd'),'yyyy-MM-dd'))
	   ) * cast(T0.EN_ENTRUST_PRICE as double) /100 /365 * cast(T0.EN_BALANCE as double),2) AS INTR, --利息
       NULL AS IN_PRD_CODE, --转入产品代码
       NULL AS IN_AST_UNIT_CODE, --转入资产单元代码
       NULL AS IN_PFL_CODE, --转入投组代码
       NULL AS IN_SH_CODE, --转入股东代码
       NULL AS IN_SEAT_CODE, --转入席位号
       NULL AS IN_INV_TYP, --转入投资类型
       NULL AS IN_SECU_ID, --转入证券编码
       NULL AS IN_SRC_SECU_ID, --转入源证券ID
       NULL AS IN_ENTR_VOL, --转入委托数量
       NULL AS IN_ENTR_PRC, --转入委托价格
       NULL AS IN_ENTR_VAL, --转入委托金额
       T0.VC_RIVAL_SEAT AS CNTP_SEAT_CODE, --对手方席位号
       0 AS RES_FLAG, --限售标识
       NULL AS LOCK_LMT_CLAS, --锁定受限类型
       NULL AS LMT_CLAS_ONUM, --受限类型序号
       NULL AS AGMT_NUM, --合同号
       NULL AS BONS_MODE, --分红方式
       NULL AS PAY_DT, --缴款日期
       NULL AS CONT_MULT, --合约乘数
       NULL AS COVR_DIR, --平仓方向
	   NULL AS ARBI_FLAG, --套利标志
       NULL AS ETF_ONUM, --ETF序号
       NULL AS ESTI_CASH_DIFF, --预估现金差额
       NULL AS ETF_FND_CLAS, --ETF基金类型
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('1') --1：未报
          THEN
          '1'
         WHEN T0.C_ENTRUST_STATUS IN ('4') --4：已报
          THEN
          '2'
         WHEN T0.C_ENTRUST_STATUS IN ('5') --5：废单
          THEN
          '3'
         WHEN T0.C_ENTRUST_STATUS IN ('6') --6：部成
          THEN
          '4'
         WHEN T0.C_ENTRUST_STATUS IN ('7') --7：已成
          THEN
          '5'
         WHEN T0.C_ENTRUST_STATUS IN ('F', '9') --F：已撤
          THEN
          '6'
         WHEN T0.C_ENTRUST_STATUS IN ('8') --8：部撤
          THEN
          '7'
         WHEN T0.C_ENTRUST_STATUS IN ('E') --E：撤废，是撤单委托的
          THEN
          '8'
       END AS ENTR_STAT, --委托状态
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_exch_entr_his_3' AS TASK_RS_ID, --任务来源标识
	   CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
	     T0.L_DATE	 as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISENTRUSTS T0
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5
    ON T0.L_DATE = T5.L_DATE
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.P_DT BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_THGRATIO  T7
    ON T0.VC_INTER_CODE = T7.VC_INTER_CODE
   AND T7.C_PARAMETER_TYPE = '1'
  LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTIONDETAIL T8
    ON T0.C_ENTRUST_DIRECTION = T8.C_ENTRUST_DIRECTION
   AND T0.C_MARKET_NO = T8.C_MARKET_NO
   AND T0.C_PRICE_TYPE = T8.C_PRICE_TYPE
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
    ON cast(date_format(date_add(from_unixtime(unix_timestamp(cast(T0.L_DATE as string),'yyyyMMdd'),'yyyy-MM-dd'),cast(T7.L_RATIO as int)),'yyyyMMdd') as bigint) = w1.dt
   AND T5.C_MARKET_NO = w1.mkt_no
   AND W1.SYS_RS_ID = 'O3'
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W2
    ON T0.L_DATE = w2.dt
   AND T5.C_MARKET_NO = w2.mkt_no
   AND W2.SYS_RS_ID = 'O3'
 WHERE T0.C_BUSIN_CLASS IN ('1', 'I')
   AND T0.C_ENTRUST_DIRECTION IN ('5', '6')
   AND T0.C_ENTRUST_STATUS IN ('1', '4', '5', '6', '7', 'F', '8', 'E', '9')
   AND T0.P_DT BETWEEN ${beg_date} and ${end_date}

UNION ALL
--离线委托：配股/债/上交所老股东配售（通过识别当天有无增发代码）
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       CASE
         WHEN T0.L_DAILY_INSTRUCTION_NO IS NULL OR
              T0.L_DAILY_INSTRUCTION_NO = 0 THEN
          concat('0|0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_ENTRUST_SERIAL_NO , '|0')
         ELSE
          concat('0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '|0|0')
       END AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_ENTRUST_SERIAL_NO) AS ENTR_ONUM, --委托序号
       T0.L_BATCH_SERIAL_NO AS ENTR_BTNO, --委托批号
       CASE
         WHEN T0.L_CANCEL_SERIAL_NO IS NULL THEN
          NULL
         ELSE
          concat(T0.L_DATE , '_HSO32' , '_' , T0.L_CANCEL_SERIAL_NO)
       END AS WHDW_ENTR_ONUM, --被撤单委托序号
       T0.L_REPORT_SERIAL_NO AS REP_ID, --申报编号
       CASE
         WHEN T0.L_DAILY_INSTRUCTION_NO IS NULL OR
              T0.L_DAILY_INSTRUCTION_NO = 0 THEN
          NULL
         ELSE
          concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_BASECOMBI_ID , '_' , (CASE
            WHEN T6.C_ASSET_CLASS = '2' or T6.C_STOCK_TYPE IN ('a') THEN
             concat(T6.VC_REPORT_CODE , '.STK.' , --股票
             (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end))
            WHEN T6.C_ASSET_CLASS = '3' THEN --债券
             concat(T6.VC_REPORT_CODE , '.BOND.' ,
             (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end))
          END) , '_' , (CASE
            WHEN T0.C_INVEST_TYPE IN ('1') THEN
             '2' --交易型金融资产
            WHEN T0.C_INVEST_TYPE IN ('2') THEN
             '1' --持有到期资产
            ELSE
             T0.C_INVEST_TYPE
          END) , '_' , (CASE
            WHEN T8.L_DATE IS NULL THEN
             '06000100' --配股\配债
            ELSE
             '05070100' --老股东配售
          END))
       END AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_REPORT_SEAT AS SEAT_CODE, --席位号
       CASE
         WHEN T0.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T0.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       CASE
         WHEN T6.C_ASSET_CLASS = '2' or T6.C_STOCK_TYPE IN ('a') THEN
          concat(T6.VC_REPORT_CODE , '.STK.' , --股票
          (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end))
         WHEN T6.C_ASSET_CLASS = '3' THEN --债券
          concat(T6.VC_REPORT_CODE , '.BOND.' ,
          (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end))
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
         WHEN T8.L_DATE IS NULL THEN
          '9' --配股\配债
         ELSE
          '12' --老股东配售
       END AS ENTR_DIR, --委托方向
       CASE
         WHEN T7.C_MARKET_NO = '1' AND T7.C_PRICE_TYPE = 'P' THEN
          '31'
         WHEN T7.C_MARKET_NO = 'j' AND T7.C_PRICE_TYPE = '4' THEN
          '14'
         ELSE
          (case when T7.C_LIMIT_PRICE = 0 then '2' else T7.C_LIMIT_PRICE end)
       END AS ENTR_PRC_CLAS, --委托价格类型
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          T0.L_ENTRUST_AMOUNT
       END AS ENTR_VOL, --委托数量
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          T0.L_CANCEL_AMOUNT
       END AS WHDW_VOL, --撤单数量
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          (case when T0.EN_ENTRUST_PRICE = 0 then T0.EN_FACT_PRICE else T0.EN_ENTRUST_PRICE end)
       END AS ENTR_PRC, --委托价格
       CASE
         WHEN T8.L_DATE IS NULL THEN
          '060001' --配股\配债
         ELSE
          '050701' --老股东配售
       END AS BUSI_TYP, --业务类别
       CASE
         WHEN T8.L_DATE IS NULL THEN
          '06000100' --配股\配债
         ELSE
          '05070100' --老股东配售
       END AS BUSI_CLAS, --业务类型
       NULL AS RAT, --利率
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          T0.EN_BALANCE
       END AS ENTR_VAL, --委托金额
       0 AS ENTR_TOT_FEE, --委托总费用
       T0.L_OPERATOR_NO AS OPER_NO, --操作员编码
       T0.L_RIVAL_ID AS TRD_CNTP_ID, --交易对手编码
       NULL AS APPT_NUM, --约定号
       NULL AS GUAR_SETT_FLAG, --担保交收标志
       CASE
         WHEN SUBSTR(T6.VC_INTER_CODE, 1, 1) NOT IN ('0', '3', '6') AND
              T5.C_MARKET_NO = '1' THEN --上交所配债
          w1.aft_3_dt
         WHEN T5.C_MARKET_NO = '2' THEN --深交所配股/债
          w1.aft_2_dt
         WHEN T8.L_DATE IS NULL THEN --上交所老股东配售
          w1.aft_2_dt
         ELSE --上交所配股
          T0.L_DATE
       END AS DELI_DT, --交割日期
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
       NULL AS IN_SH_CODE, --转入股东代码
       NULL AS IN_SEAT_CODE, --转入席位号
       NULL AS IN_INV_TYP, --转入投资类型
       NULL AS IN_SECU_ID, --转入证券编码
       NULL AS IN_SRC_SECU_ID, --转入源证券ID
       NULL AS IN_ENTR_VOL, --转入委托数量
       NULL AS IN_ENTR_PRC, --转入委托价格
       NULL AS IN_ENTR_VAL, --转入委托金额
       T0.VC_RIVAL_SEAT AS CNTP_SEAT_CODE, --对手方席位号
       0 AS RES_FLAG, --限售标识
       NULL AS LOCK_LMT_CLAS, --锁定受限类型
       NULL AS LMT_CLAS_ONUM, --受限类型序号
       NULL AS AGMT_NUM, --合同号
       NULL AS BONS_MODE, --分红方式
       CASE
         WHEN SUBSTR(T6.VC_INTER_CODE, 1, 1) NOT IN ('0', '3', '6') AND
              T5.C_MARKET_NO = '1' THEN --上交所配债
          w1.aft_2_dt
         WHEN T5.C_MARKET_NO = '2' THEN --深交所配股/债
          T0.L_DATE
         WHEN T8.L_DATE IS NULL THEN --上交所老股东配售
          T0.L_DATE
         ELSE --上交所配股
          T0.L_DATE
       END AS PAY_DT, --缴款日期
       NULL AS CONT_MULT, --合约乘数
       NULL AS COVR_DIR, --平仓方向
	   NULL AS ARBI_FLAG, --套利标志
	   NULL AS ETF_ONUM, --ETF序号
       NULL AS ESTI_CASH_DIFF, --预估现金差额
       NULL AS ETF_FND_CLAS, --ETF基金类型
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('1') --1：未报
          THEN
          '1'
         WHEN T0.C_ENTRUST_STATUS IN ('4') --4：已报
          THEN
          '2'
         WHEN T0.C_ENTRUST_STATUS IN ('5') --5：废单
          THEN
          '3'
         WHEN T0.C_ENTRUST_STATUS IN ('6') --6：部成
          THEN
          '4'
         WHEN T0.C_ENTRUST_STATUS IN ('7') --7：已成
          THEN
          '5'
         WHEN T0.C_ENTRUST_STATUS IN ('F', '9') --F：已撤
          THEN
          '6'
         WHEN T0.C_ENTRUST_STATUS IN ('8') --8：部撤
          THEN
          '7'
         WHEN T0.C_ENTRUST_STATUS IN ('E') --E：撤废，是撤单委托的
          THEN
          '8'
       END AS ENTR_STAT, --委托状态
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_exch_entr_his_4' AS TASK_RS_ID, --任务来源标识
	   CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
	     T0.L_DATE	 as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISENTRUSTS T0
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5
    ON T0.L_DATE = T5.L_DATE
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.P_DT BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T6 --证券基本信息表，获取正式代码
    ON T5.L_DATE = T6.L_DATE
   AND T5.VC_ASSET_RELATIVE_CODE = T6.VC_INTER_CODE
   AND T6.P_DT BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T8
    ON T0.L_DATE = T8.L_DATE
   AND T5.VC_ASSET_RELATIVE_CODE = T8.VC_ASSET_RELATIVE_CODE
   AND T8.C_STOCK_TYPE IN ('d')
   AND T8.C_STOP_FLAG = '2'
   AND T8.P_DT BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTIONDETAIL T7
    ON T0.C_ENTRUST_DIRECTION = T7.C_ENTRUST_DIRECTION
   AND T0.C_MARKET_NO = T7.C_MARKET_NO
   AND T0.C_PRICE_TYPE = T7.C_PRICE_TYPE
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
    ON T0.L_DATE = w1.dt
   AND T5.C_MARKET_NO = w1.mkt_no
   AND W1.SYS_RS_ID = 'O3'
 WHERE T0.C_BUSIN_CLASS IN ('1')
   AND T0.C_ENTRUST_DIRECTION IN ('9')
   AND T0.C_ENTRUST_STATUS IN ('1', '4', '5', '6', '7', 'F', '8', 'E', '9')
   AND T0.P_DT BETWEEN ${beg_date} and ${end_date}

UNION ALL
--委托：网上新股/新债业务
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       CASE
         WHEN T0.L_DAILY_INSTRUCTION_NO IS NULL OR
              T0.L_DAILY_INSTRUCTION_NO = 0 THEN
          concat('0|0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_ENTRUST_SERIAL_NO , '|0')
         ELSE
          concat('0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '|0|0')
       END AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_ENTRUST_SERIAL_NO) AS ENTR_ONUM, --委托序号
       T0.L_BATCH_SERIAL_NO AS ENTR_BTNO, --委托批号
       CASE
         WHEN T0.L_CANCEL_SERIAL_NO IS NULL THEN
          NULL
         ELSE
          concat(T0.L_DATE , '_HSO32' , '_' , T0.L_CANCEL_SERIAL_NO)
       END AS WHDW_ENTR_ONUM, --被撤单委托序号
       T0.L_REPORT_SERIAL_NO AS REP_ID, --申报编号
       CASE WHEN T0.L_DAILY_INSTRUCTION_NO IS NULL OR
              T0.L_DAILY_INSTRUCTION_NO = 0 THEN
        NULL
      ELSE
     concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_BASECOMBI_ID , '_' , (CASE
         WHEN T6.C_ASSET_CLASS IN ('2') OR T6.C_STOCK_TYPE = 'a' THEN --股票
          concat(T6.VC_REPORT_CODE , '.STK.' , (case when T6.C_MARKET_NO = '1' then 'SH' when T6.C_MARKET_NO = '2' then 'SZ' end))
         WHEN T6.C_ASSET_CLASS = '3'  OR T6.C_STOCK_TYPE = 'k' THEN --债券
          concat(T6.VC_REPORT_CODE , '.BOND.' , (case when T6.C_MARKET_NO = '1' then 'SH' when T6.C_MARKET_NO = '2' then 'SZ' end))
       END) , '_' , (CASE
         WHEN T0.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T0.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T0.C_INVEST_TYPE
       END) , '_' , '05000100')
     END AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_REPORT_SEAT AS SEAT_CODE, --席位号
       CASE
         WHEN T0.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T0.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
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
         WHEN T0.C_BUSIN_CLASS = 'I' THEN
          'PLAT_FIXINC'
       END AS TRD_PLFM, --交易平台
	   NULL AS TRD_MODE,--交易方式
       '12' AS ENTR_DIR, --委托方向
       CASE
         WHEN T7.C_MARKET_NO = '1' AND T7.C_PRICE_TYPE = 'P' THEN
          '31'
         WHEN T7.C_MARKET_NO = 'j' AND T7.C_PRICE_TYPE = '4' THEN
          '14'
         ELSE
          (case when T7.C_LIMIT_PRICE = 0 then '2' else T7.C_LIMIT_PRICE end)
       END AS ENTR_PRC_CLAS, --委托价格类型
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          T0.L_ENTRUST_AMOUNT
       END AS ENTR_VOL, --委托数量
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          T0.L_CANCEL_AMOUNT
       END AS WHDW_VOL, --撤单数量
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          (case when T0.EN_ENTRUST_PRICE = 0 then T0.EN_FACT_PRICE else T0.EN_ENTRUST_PRICE end)
       END AS ENTR_PRC, --委托价格
       '050001' AS BUSI_TYP, --业务类别
       '05000100' AS BUSI_CLAS, --业务类型
       NULL AS RAT, --利率
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          T0.EN_BALANCE
       END AS ENTR_VAL, --委托金额
       0 AS ENTR_TOT_FEE, --委托总费用
       T0.L_OPERATOR_NO AS OPER_NO, --操作员编码
       T0.L_RIVAL_ID AS TRD_CNTP_ID, --交易对手编码
       NULL AS APPT_NUM, --约定号
       NULL AS GUAR_SETT_FLAG, --担保交收标志
       w1.aft_3_dt AS DELI_DT, --交割日期
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
       NULL AS IN_SH_CODE, --转入股东代码
       NULL AS IN_SEAT_CODE, --转入席位号
       NULL AS IN_INV_TYP, --转入投资类型
       NULL AS IN_SECU_ID, --转入证券编码
       NULL AS IN_SRC_SECU_ID, --转入源证券ID
       NULL AS IN_ENTR_VOL, --转入委托数量
       NULL AS IN_ENTR_PRC, --转入委托价格
       NULL AS IN_ENTR_VAL, --转入委托金额
       T0.VC_RIVAL_SEAT AS CNTP_SEAT_CODE, --对手方席位号
       0 AS RES_FLAG, --限售标识
       NULL AS LOCK_LMT_CLAS, --锁定受限类型
       NULL AS LMT_CLAS_ONUM, --受限类型序号
       NULL AS AGMT_NUM, --合同号
       NULL AS BONS_MODE, --分红方式
       w1.aft_2_dt AS PAY_DT, --缴款日期
       NULL AS CONT_MULT, --合约乘数
       NULL AS COVR_DIR, --平仓方向
	   NULL AS ARBI_FLAG, --套利标志
	   NULL AS ETF_ONUM, --ETF序号
	   NULL AS ESTI_CASH_DIFF, --预估现金差额
	   NULL AS ETF_FND_CLAS,--ETF基金类型
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('1') --1：未报
          THEN
          '1'
         WHEN T0.C_ENTRUST_STATUS IN ('4') --4：已报
          THEN
          '2'
         WHEN T0.C_ENTRUST_STATUS IN ('5') --5：废单
          THEN
          '3'
         WHEN T0.C_ENTRUST_STATUS IN ('6') --6：部成
          THEN
          '4'
         WHEN T0.C_ENTRUST_STATUS IN ('7') --7：已成
          THEN
          '5'
         WHEN T0.C_ENTRUST_STATUS IN ('F', '9') --F：已撤
          THEN
          '6'
         WHEN T0.C_ENTRUST_STATUS IN ('8') --8：部撤
          THEN
          '7'
         WHEN T0.C_ENTRUST_STATUS IN ('E') --E：撤废，是撤单委托的
          THEN
          '8'
       END AS ENTR_STAT, --委托状态
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_exch_entr_his_5' AS TASK_RS_ID, --任务来源标识
	   CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
	     T0.L_DATE	 as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISENTRUSTS T0
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5
    ON T0.L_DATE = T5.L_DATE
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.P_DT BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T6 --证券基本信息表，获取正式代码
    ON T5.L_DATE = T6.L_DATE
   AND T5.VC_ASSET_RELATIVE_CODE = T6.VC_INTER_CODE
   AND T6.C_ASSET_CLASS IN ('2', '3','6')
   AND T6.C_MARKET_NO IN ('1', '2') --1是上交所、2深交所
   AND T6.P_DT BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTIONDETAIL T7
    ON T0.C_ENTRUST_DIRECTION = T7.C_ENTRUST_DIRECTION
   AND T0.C_MARKET_NO = T7.C_MARKET_NO
   AND T0.C_PRICE_TYPE = T7.C_PRICE_TYPE
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
    ON T0.L_DATE = w1.dt
   AND T5.C_MARKET_NO = w1.mkt_no
   AND W1.SYS_RS_ID = 'O3'
 WHERE T0.C_BUSIN_CLASS IN ('1', 'I')
   AND T0.C_ENTRUST_DIRECTION IN ('C')
   AND T0.C_ENTRUST_STATUS IN ('1', '4', '5', '6', '7', 'F', '8', 'E', '9')
   AND T5.C_STOCK_TYPE NOT IN ('d','27')
   AND T0.P_DT BETWEEN ${beg_date} and ${end_date}

UNION ALL
--委托：预受要约\预受要约撤销
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       CASE
         WHEN T0.L_DAILY_INSTRUCTION_NO IS NULL OR
              T0.L_DAILY_INSTRUCTION_NO = 0 THEN
          concat('0|0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_ENTRUST_SERIAL_NO , '|0')
         ELSE
          concat('0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '|0|0')
       END AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_ENTRUST_SERIAL_NO) AS ENTR_ONUM, --委托序号
       T0.L_BATCH_SERIAL_NO AS ENTR_BTNO, --委托批号
       CASE
         WHEN T0.L_CANCEL_SERIAL_NO IS NULL THEN
          NULL
         ELSE
          concat(T0.L_DATE , '_HSO32' , '_' , T0.L_CANCEL_SERIAL_NO)
       END AS WHDW_ENTR_ONUM, --被撤单委托序号
       T0.L_REPORT_SERIAL_NO AS REP_ID, --申报编号
       CASE WHEN T0.L_DAILY_INSTRUCTION_NO IS NULL OR
              T0.L_DAILY_INSTRUCTION_NO = 0 THEN
        NULL
      ELSE
     concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_BASECOMBI_ID , '_' , T6.VC_REPORT_CODE , '.STK.' ,
       (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end) , '_' , (CASE
         WHEN T0.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T0.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T0.C_INVEST_TYPE
       END) , '_' , (CASE
	     WHEN T0.C_ENTRUST_DIRECTION = '0' THEN
          '07000100'
         WHEN T0.C_ENTRUST_DIRECTION = 'b' THEN
          '07000101'
	   END))
     END AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_REPORT_SEAT AS SEAT_CODE, --席位号
       CASE
         WHEN T0.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T0.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
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
         WHEN T0.C_ENTRUST_DIRECTION = '0' THEN
          '66'
         WHEN T0.C_ENTRUST_DIRECTION = 'b' THEN
          '38'
       END AS ENTR_DIR, --委托方向
       CASE
         WHEN T7.C_MARKET_NO = '1' AND T7.C_PRICE_TYPE = 'P' THEN
          '31'
         WHEN T7.C_MARKET_NO = 'j' AND T7.C_PRICE_TYPE = '4' THEN
          '14'
         ELSE
          (case when T7.C_LIMIT_PRICE = 0 then '2' else T7.C_LIMIT_PRICE end)
       END AS ENTR_PRC_CLAS, --委托价格类型
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          T0.L_ENTRUST_AMOUNT
       END AS ENTR_VOL, --委托数量
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          T0.L_CANCEL_AMOUNT
       END AS WHDW_VOL, --撤单数量
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         WHEN T5.C_MARKET_NO = '1' THEN T0.EN_ENTRUST_PRICE
	     WHEN T5.C_MARKET_NO = '2' THEN T8.EN_OFFERINGPRICE
       END AS ENTR_PRC, --委托价格
       '070001' AS BUSI_TYP, --业务类别
       CASE
	     WHEN T0.C_ENTRUST_DIRECTION = '0' THEN
          '07000100'
         WHEN T0.C_ENTRUST_DIRECTION = 'b' THEN
          '07000101'
	     END AS BUSI_CLAS, --业务类型
       NULL AS RAT, --利率
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         WHEN T5.C_MARKET_NO = '1' THEN T0.EN_BALANCE
	     WHEN T5.C_MARKET_NO = '2' THEN cast(T8.EN_OFFERINGPRICE as double) * cast(T0.L_ENTRUST_AMOUNT as double)
       END AS ENTR_VAL, --委托金额
       0 AS ENTR_TOT_FEE, --委托总费用
       T0.L_OPERATOR_NO AS OPER_NO, --操作员编码
       CASE WHEN T5.C_MARKET_NO = '1' THEN T0.L_RIVAL_ID
	        WHEN T5.C_MARKET_NO = '2' THEN cast(T8.VC_TENDERER_ID as bigint)
	     END AS TRD_CNTP_ID, --交易对手编码
       NULL AS APPT_NUM, --约定号
       NULL AS GUAR_SETT_FLAG, --担保交收标志
       T0.L_DATE AS DELI_DT, --交割日期
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
       NULL AS IN_SH_CODE, --转入股东代码
       NULL AS IN_SEAT_CODE, --转入席位号
       NULL AS IN_INV_TYP, --转入投资类型
       NULL AS IN_SECU_ID, --转入证券编码
       NULL AS IN_SRC_SECU_ID, --转入源证券ID
       NULL AS IN_ENTR_VOL, --转入委托数量
       NULL AS IN_ENTR_PRC, --转入委托价格
       NULL AS IN_ENTR_VAL, --转入委托金额
       T0.VC_RIVAL_SEAT AS CNTP_SEAT_CODE, --对手方席位号
       0 AS RES_FLAG, --限售标识
       NULL AS LOCK_LMT_CLAS, --锁定受限类型
       NULL AS LMT_CLAS_ONUM, --受限类型序号
       NULL AS AGMT_NUM, --合同号
       NULL AS BONS_MODE, --分红方式
       NULL AS PAY_DT, --缴款日期
       NULL AS CONT_MULT, --合约乘数
       NULL AS COVR_DIR, --平仓方向
	   NULL AS ARBI_FLAG, --套利标志
	   NULL AS ETF_ONUM, --ETF序号
       NULL AS ESTI_CASH_DIFF, --预估现金差额
       NULL AS ETF_FND_CLAS, --ETF基金类型
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('1') --1：未报
          THEN
          '1'
         WHEN T0.C_ENTRUST_STATUS IN ('4') --4：已报
          THEN
          '2'
         WHEN T0.C_ENTRUST_STATUS IN ('5') --5：废单
          THEN
          '3'
         WHEN T0.C_ENTRUST_STATUS IN ('6') --6：部成
          THEN
          '4'
         WHEN T0.C_ENTRUST_STATUS IN ('7') --7：已成
          THEN
          '5'
         WHEN T0.C_ENTRUST_STATUS IN ('F', '9') --F：已撤
          THEN
          '6'
         WHEN T0.C_ENTRUST_STATUS IN ('8') --8：部撤
          THEN
          '7'
         WHEN T0.C_ENTRUST_STATUS IN ('E') --E：撤废，是撤单委托的
          THEN
          '8'
       END AS ENTR_STAT, --委托状态
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_exch_entr_his_6' AS TASK_RS_ID, --任务来源标识
	   CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
	     T0.L_DATE	 as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISENTRUSTS T0
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5
    ON T0.L_DATE = T5.L_DATE
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.P_DT BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T6
    ON T0.L_DATE = T6.L_DATE
   AND T5.VC_ASSET_RELATIVE_CODE = T6.VC_INTER_CODE
   AND T6.P_DT BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTIONDETAIL T7
    ON T0.C_ENTRUST_DIRECTION = T7.C_ENTRUST_DIRECTION
   AND T0.C_MARKET_NO = T7.C_MARKET_NO
   AND T0.C_PRICE_TYPE = T7.C_PRICE_TYPE
  LEFT JOIN ${ods_db}.O3_THISPREACCEPTEDOFFERS T8
    ON cast(cast(T0.EN_ENTRUST_PRICE as bigint) as string) = T8.VC_TENDERER_ID
   AND T0.VC_INTER_CODE = T8.VC_INTER_CODE
   AND T8.P_DT BETWEEN ${beg_date} and ${end_date}
 WHERE T0.C_BUSIN_CLASS IN ('1')
   AND T0.C_ENTRUST_DIRECTION IN ('b', '0')
   AND T0.C_ENTRUST_STATUS IN ('1', '4', '5', '6', '7', 'F', '8', 'E', '9')
   AND T0.P_DT BETWEEN ${beg_date} and ${end_date}

UNION ALL
--委托：债回售申报
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       CASE
         WHEN T0.L_DAILY_INSTRUCTION_NO IS NULL OR
              T0.L_DAILY_INSTRUCTION_NO = 0 THEN
          concat('0|0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_ENTRUST_SERIAL_NO , '|0')
         ELSE
          concat('0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '|0|0')
       END AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_ENTRUST_SERIAL_NO) AS ENTR_ONUM, --委托序号
       T0.L_BATCH_SERIAL_NO AS ENTR_BTNO, --委托批号
       CASE
         WHEN T0.L_CANCEL_SERIAL_NO IS NULL THEN
          NULL
         ELSE
          concat(T0.L_DATE , '_HSO32' , '_' , T0.L_CANCEL_SERIAL_NO)
       END AS WHDW_ENTR_ONUM, --被撤单委托序号
       T0.L_REPORT_SERIAL_NO AS REP_ID, --申报编号
       CASE WHEN T0.L_DAILY_INSTRUCTION_NO IS NULL OR
              T0.L_DAILY_INSTRUCTION_NO = 0 THEN
        NULL
      ELSE
     concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_BASECOMBI_ID , '_' , T6.VC_REPORT_CODE , '.BOND.' ,
       (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end) , '_' , (CASE
         WHEN T0.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T0.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T0.C_INVEST_TYPE
       END) , '_' , ('08000100') )
     END AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_REPORT_SEAT AS SEAT_CODE, --席位号
       CASE
         WHEN T0.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T0.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       concat(T6.VC_REPORT_CODE , '.BOND.' , (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end))  AS SECU_ID, --证券编码
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
         WHEN T8.C_MARKET_NO = '1' AND T8.C_PRICE_TYPE = 'P' THEN
          '31'
         WHEN T8.C_MARKET_NO = 'j' AND T8.C_PRICE_TYPE = '4' THEN
          '14'
         ELSE
          (case when T8.C_LIMIT_PRICE = 0 then '2' else T8.C_LIMIT_PRICE end)
       END AS ENTR_PRC_CLAS, --委托价格类型
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          T0.L_ENTRUST_AMOUNT
       END AS ENTR_VOL, --委托数量
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          T0.L_CANCEL_AMOUNT
       END AS WHDW_VOL, --撤单数量
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          T7.EN_CURR_FACE_PRICE
       END AS ENTR_PRC, --委托价格
       '080001' AS BUSI_TYP, --业务类别
       '08000100' AS BUSI_CLAS, --业务类型
       NULL AS RAT, --利率
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          cast(T0.L_ENTRUST_AMOUNT as double) * cast(T7.EN_CURR_FACE_PRICE as double)
       END AS ENTR_VAL, --委托金额
       0 AS ENTR_TOT_FEE, --委托总费用
       T0.L_OPERATOR_NO AS OPER_NO, --操作员编码
       T0.L_RIVAL_ID AS TRD_CNTP_ID, --交易对手编码
       NULL AS APPT_NUM, --约定号
       NULL AS GUAR_SETT_FLAG, --担保交收标志
       T0.L_DATE AS DELI_DT, --交割日期
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
       NULL AS IN_SH_CODE, --转入股东代码
       NULL AS IN_SEAT_CODE, --转入席位号
       NULL AS IN_INV_TYP, --转入投资类型
       NULL AS IN_SECU_ID, --转入证券编码
       NULL AS IN_SRC_SECU_ID, --转入源证券ID
       NULL AS IN_ENTR_VOL, --转入委托数量
       NULL AS IN_ENTR_PRC, --转入委托价格
       NULL AS IN_ENTR_VAL, --转入委托金额
       T0.VC_RIVAL_SEAT AS CNTP_SEAT_CODE, --对手方席位号
       0 AS RES_FLAG, --限售标识
       NULL AS LOCK_LMT_CLAS, --锁定受限类型
       NULL AS LMT_CLAS_ONUM, --受限类型序号
       NULL AS AGMT_NUM, --合同号
       NULL AS BONS_MODE, --分红方式
       NULL AS PAY_DT, --缴款日期
       NULL AS CONT_MULT, --合约乘数
       NULL AS COVR_DIR, --平仓方向
	   NULL AS ARBI_FLAG, --套利标志
	   NULL AS ETF_ONUM, --ETF序号
       NULL AS ESTI_CASH_DIFF, --预估现金差额
       NULL AS ETF_FND_CLAS, --ETF基金类型
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('1') --1：未报
          THEN
          '1'
         WHEN T0.C_ENTRUST_STATUS IN ('4') --4：已报
          THEN
          '2'
         WHEN T0.C_ENTRUST_STATUS IN ('5') --5：废单
          THEN
          '3'
         WHEN T0.C_ENTRUST_STATUS IN ('6') --6：部成
          THEN
          '4'
         WHEN T0.C_ENTRUST_STATUS IN ('7') --7：已成
          THEN
          '5'
         WHEN T0.C_ENTRUST_STATUS IN ('F', '9') --F：已撤
          THEN
          '6'
         WHEN T0.C_ENTRUST_STATUS IN ('8') --8：部撤
          THEN
          '7'
         WHEN T0.C_ENTRUST_STATUS IN ('E') --E：撤废，是撤单委托的
          THEN
          '8'
       END AS ENTR_STAT, --委托状态
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_exch_entr_his_7' AS TASK_RS_ID, --任务来源标识
	   CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
	     T0.L_DATE	 as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISENTRUSTS T0
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5
    ON T0.L_DATE = T5.L_DATE
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.P_DT BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T6 --证券基本信息表，获取正式代码
    ON T5.L_DATE = T6.L_DATE
   AND T5.VC_ASSET_RELATIVE_CODE = T6.VC_INTER_CODE
   AND T6.C_ASSET_CLASS IN ('2', '3','6')
   AND T6.P_DT BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
    ON T0.L_DATE = w1.dt
   AND T5.C_MARKET_NO = w1.mkt_no
   AND W1.SYS_RS_ID = 'O3'
  LEFT JOIN ${ods_db}.O3_THISBONDPROPERTY T7
    ON W1.pre_2_dt = T7.L_DATE
   AND T6.VC_INTER_CODE = T7.VC_INTER_CODE
   AND T7.P_DT BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-10),'yyyyMMdd') and ${end_date}
  LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTIONDETAIL T8
    ON T0.C_ENTRUST_DIRECTION = T8.C_ENTRUST_DIRECTION
   AND T0.C_MARKET_NO = T8.C_MARKET_NO
   AND T0.C_PRICE_TYPE = T8.C_PRICE_TYPE
 WHERE T0.C_BUSIN_CLASS IN ('1', 'I', 'E')
   AND T0.C_ENTRUST_DIRECTION IN ('B')
   AND T0.C_ENTRUST_STATUS IN ('1', '4', '5', '6', '7', 'F', '8', 'E', '9')
   AND T0.P_DT BETWEEN ${beg_date} and ${end_date}

UNION ALL
--离线委托：股指期货\国债期货\商品期货
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       CASE
         WHEN T0.L_DAILY_INSTRUCTION_NO IS NULL OR
              T0.L_DAILY_INSTRUCTION_NO = 0 THEN
          concat('0|0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_ENTRUST_SERIAL_NO , '|0')
         ELSE
          concat('0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '|0|0')
       END AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_ENTRUST_SERIAL_NO) AS ENTR_ONUM, --委托序号
       T0.L_BATCH_SERIAL_NO AS ENTR_BTNO, --委托批号
       CASE
         WHEN T0.L_CANCEL_SERIAL_NO IS NULL THEN
          NULL
         ELSE
          concat(T0.L_DATE , '_HSO32' , '_' , T0.L_CANCEL_SERIAL_NO)
       END AS WHDW_ENTR_ONUM, --被撤单委托序号
       T0.L_REPORT_SERIAL_NO AS REP_ID, --申报编号
       CASE WHEN T0.L_DAILY_INSTRUCTION_NO IS NULL OR
              T0.L_DAILY_INSTRUCTION_NO = 0 THEN
        NULL
      ELSE
     concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_BASECOMBI_ID , '_' , T5.VC_REPORT_CODE , '.FUT.' ,
       (case when T5.C_MARKET_NO = '1' then 'SH'
             when T5.C_MARKET_NO = '2' then 'SZ'
             when T5.C_MARKET_NO = '7' then 'CFFEX'
             when T5.C_MARKET_NO = '3' then 'SHFE'
             when T5.C_MARKET_NO = '4' then 'CZCE'
             when T5.C_MARKET_NO = '9' then 'DCE'
			 end) , '_' , (CASE
         WHEN T0.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T0.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         WHEN T0.C_INVEST_TYPE IN ('c') THEN
          '12' --套利交易
         WHEN T0.C_INVEST_TYPE IN ('b') THEN
          '10' --套期工具
         WHEN T0.C_INVEST_TYPE IN ('a') THEN
          '15' --投机
         ELSE
          T0.C_INVEST_TYPE
       END) , '_' , (CASE
         WHEN T0.C_ENTRUST_DIRECTION in ('V') THEN
          '22000100'
         WHEN T0.C_ENTRUST_DIRECTION in ('W') THEN
          '22000101'
         WHEN T0.C_ENTRUST_DIRECTION in ('X') THEN
          '22000103'
         WHEN T0.C_ENTRUST_DIRECTION in ('Y') THEN
          '22000104'
       END))
     END AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_REPORT_SEAT AS SEAT_CODE, --席位号
       CASE
         WHEN T0.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T0.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         WHEN T0.C_INVEST_TYPE IN ('c') THEN
          '12' --套利交易
         WHEN T0.C_INVEST_TYPE IN ('b') THEN
          '10' --套期工具
         WHEN T0.C_INVEST_TYPE IN ('a') THEN
          '15' --投机
         ELSE
          T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       concat(T5.VC_REPORT_CODE , '.FUT.' ,
       (case when T5.C_MARKET_NO = '1' then 'SH'
             when T5.C_MARKET_NO = '2' then 'SZ'
             when T5.C_MARKET_NO = '7' then 'CFFEX'
             when T5.C_MARKET_NO = '3' then 'SHFE'
             when T5.C_MARKET_NO = '4' then 'CZCE'
             when T5.C_MARKET_NO = '9' then 'DCE'
			 end))  AS SECU_ID, --证券编码
       (case when T5.C_MARKET_NO = '1' then 'SH'
             when T5.C_MARKET_NO = '2' then 'SZ'
             when T5.C_MARKET_NO = '7' then 'CFFEX'
             when T5.C_MARKET_NO = '3' then 'SHFE'
             when T5.C_MARKET_NO = '4' then 'CZCE'
             when T5.C_MARKET_NO = '9' then 'DCE'
			 end) AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       CASE
         WHEN T0.C_ENTRUST_DIRECTION in ('X', 'Y') THEN
          'S'
         ELSE
          'L'
       END AS POS_ID, --多空标志
       'CNY' AS CURR_CODE, --货币代码
       0 AS CLR_SPED, --清算速度
       NULL AS TRD_PLFM, --交易平台
	   NULL AS TRD_MODE,--交易方式
       CASE
         WHEN T0.C_ENTRUST_DIRECTION in ('V') THEN
          '32'
         WHEN T0.C_ENTRUST_DIRECTION in ('W') THEN
          '33'
         WHEN T0.C_ENTRUST_DIRECTION in ('X') THEN
          '34'
         WHEN T0.C_ENTRUST_DIRECTION in ('Y') THEN
          '35'
        END AS ENTR_DIR, --委托方向
		CASE
         WHEN T7.C_MARKET_NO = '1' AND T7.C_PRICE_TYPE = 'P' THEN
          '31'
         WHEN T7.C_MARKET_NO = 'j' AND T7.C_PRICE_TYPE = '4' THEN
          '14'
         ELSE
          (case when T7.C_LIMIT_PRICE = 0 then '2' else T7.C_LIMIT_PRICE end)
       END AS ENTR_PRC_CLAS, --委托价格类型
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          T0.L_ENTRUST_AMOUNT
       END AS ENTR_VOL, --委托数量
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          T0.L_CANCEL_AMOUNT
       END AS WHDW_VOL, --撤单数量
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          (case when T0.EN_ENTRUST_PRICE = 0 then T0.EN_FACT_PRICE else T0.EN_ENTRUST_PRICE end)
       END AS ENTR_PRC, --委托价格
       '220001' AS BUSI_TYP, --业务类别
       CASE
         WHEN T0.C_ENTRUST_DIRECTION in ('V') THEN
          '22000100'
         WHEN T0.C_ENTRUST_DIRECTION in ('W') THEN
          '22000101'
         WHEN T0.C_ENTRUST_DIRECTION in ('X') THEN
          '22000103'
         WHEN T0.C_ENTRUST_DIRECTION in ('Y') THEN
          '22000104'
       END AS BUSI_CLAS, --业务类型
       NULL AS RAT, --利率
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'C','E','F') THEN
          0
         ELSE
          T0.EN_BALANCE
       END AS ENTR_VAL, --委托金额
       0 AS ENTR_TOT_FEE, --委托总费用
       T0.L_OPERATOR_NO AS OPER_NO, --操作员编码
       T0.L_RIVAL_ID AS TRD_CNTP_ID, --交易对手编码
       NULL AS APPT_NUM, --约定号
       NULL AS GUAR_SETT_FLAG, --担保交收标志
       T0.L_DATE AS DELI_DT, --交割日期
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
       NULL AS IN_SH_CODE, --转入股东代码
       NULL AS IN_SEAT_CODE, --转入席位号
       NULL AS IN_INV_TYP, --转入投资类型
       NULL AS IN_SECU_ID, --转入证券编码
       NULL AS IN_SRC_SECU_ID, --转入源证券ID
       NULL AS IN_ENTR_VOL, --转入委托数量
       NULL AS IN_ENTR_PRC, --转入委托价格
       NULL AS IN_ENTR_VAL, --转入委托金额
       T0.VC_RIVAL_SEAT AS CNTP_SEAT_CODE, --对手方席位号
       0 AS RES_FLAG, --限售标识
       NULL AS LOCK_LMT_CLAS, --锁定受限类型
       NULL AS LMT_CLAS_ONUM, --受限类型序号
       NULL AS AGMT_NUM, --合同号
       NULL AS BONS_MODE, --分红方式
       NULL AS PAY_DT, --缴款日期
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          T0.EN_BALANCE / (T0.L_ENTRUST_AMOUNT *
          (case when T0.EN_ENTRUST_PRICE = 0 then T0.EN_FACT_PRICE else T0.EN_ENTRUST_PRICE end))
       END AS CONT_MULT, --合约乘数
       CASE
         WHEN T0.C_ENTRUST_DIRECTION IN ('W','Y') AND
              T0.C_MARKET_NO = '7' THEN --中金所 期货买入/卖出平仓,默认普通平仓 先开先平
          '1'
         ELSE
          '0'
       END AS COVR_DIR, --平仓方向
	   CASE WHEN T0.C_BUSIN_CLASS IN ('j', 'k') THEN
            '1'
            ELSE
			'0'
	   END AS ARBI_FLAG, --套利标志
	   NULL AS ETF_ONUM, --ETF序号
       NULL AS ESTI_CASH_DIFF, --预估现金差额
       NULL AS ETF_FND_CLAS, --ETF基金类型
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('1') --1：未报
          THEN
          '1'
         WHEN T0.C_ENTRUST_STATUS IN ('4') --4：已报
          THEN
          '2'
         WHEN T0.C_ENTRUST_STATUS IN ('5') --5：废单
          THEN
          '3'
         WHEN T0.C_ENTRUST_STATUS IN ('6') --6：部成
          THEN
          '4'
         WHEN T0.C_ENTRUST_STATUS IN ('7') --7：已成
          THEN
          '5'
         WHEN T0.C_ENTRUST_STATUS IN ('F', '9') --F：已撤
          THEN
          '6'
         WHEN T0.C_ENTRUST_STATUS IN ('8') --8：部撤
          THEN
          '7'
         WHEN T0.C_ENTRUST_STATUS IN ('E') --E：撤废，是撤单委托的
          THEN
          '8'
       END AS ENTR_STAT, --委托状态
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_exch_entr_his_8' AS TASK_RS_ID, --任务来源标识
	   CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
	     T0.L_DATE	 as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISENTRUSTS T0
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T0.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5
    ON T0.L_DATE = T5.L_DATE
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.P_DT BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTIONDETAIL T7
    ON T0.C_ENTRUST_DIRECTION = T7.C_ENTRUST_DIRECTION
   AND T0.C_MARKET_NO = T7.C_MARKET_NO
   AND T0.C_PRICE_TYPE = T7.C_PRICE_TYPE
 WHERE T0.C_BUSIN_CLASS IN ('4', 'j', 'k', 'y', 'z')
   AND T0.C_ENTRUST_DIRECTION IN ('V','W','X','Y')
   AND T0.C_ENTRUST_STATUS IN ('1', '3','4', '5','6','7','8','9','a','A', 'F', 'C', 'E')
   AND T0.P_DT BETWEEN ${beg_date} and ${end_date}

UNION ALL

--离线委托：场内转托管
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
concat('0|0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_ENTRUST_SERIAL_NO , '|0') AS TRD_SRC_ID, --交易源ID
T0.L_DATE AS OCCU_DT, --发生日期
date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
concat(T0.L_DATE , '_HSO32' , '_' , T0.L_ENTRUST_SERIAL_NO) AS ENTR_ONUM, --委托序号
T0.L_BATCH_SERIAL_NO AS ENTR_BTNO, --委托批号
CASE
  WHEN T0.L_CANCEL_SERIAL_NO IS NULL THEN
   NULL
  ELSE
   concat(T0.L_DATE , '_HSO32' , '_' , T0.L_CANCEL_SERIAL_NO)
END AS WHDW_ENTR_ONUM, --被撤单委托序号
T0.L_REPORT_SERIAL_NO AS REP_ID, --申报编号
NULL AS ODR_RELA_ONUM, --指令关联序号
T1.VC_FUND_CODE AS PRD_CODE, --产品代码
concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
T0.VC_REPORT_SEAT AS SEAT_CODE, --席位号
CASE
  WHEN T0.C_INVEST_TYPE IN ('1') THEN
   '2' --交易型金融资产
  WHEN T0.C_INVEST_TYPE IN ('2') THEN
   '1' --持有到期资产
  ELSE
   T0.C_INVEST_TYPE
END AS INV_TYP, --投资类型
CASE
  WHEN T5.C_ASSET_CLASS = '2' THEN
   concat(T5.VC_REPORT_CODE , '.STK.' , --股票
   (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end))
  WHEN T5.C_ASSET_CLASS = '3' THEN --债券
   concat(T5.VC_REPORT_CODE , '.BOND.' ,
   (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end))
  WHEN T5.C_ASSET_CLASS = '4' THEN --基金
   concat(T5.VC_REPORT_CODE , '.FUND.' ,
   (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end))
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
CASE
  WHEN T0.C_BUSIN_CLASS IN ('1') THEN
   'PLAT_BID'
END AS TRD_PLFM, --交易平台
NULL AS TRD_MODE,--交易方式
'17' AS ENTR_DIR, --委托方向
CASE
  WHEN T7.C_MARKET_NO = '1' AND T7.C_PRICE_TYPE = 'P' THEN
   '31'
  WHEN T7.C_MARKET_NO = 'j' AND T7.C_PRICE_TYPE = '4' THEN
   '14'
  ELSE
   (case when T7.C_LIMIT_PRICE = 0 then '2' else T7.C_LIMIT_PRICE end)
END AS ENTR_PRC_CLAS, --委托价格类型
CASE
  WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
   0
  ELSE
   T0.L_ENTRUST_AMOUNT
END AS ENTR_VOL, --委托数量
CASE
  WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
   0
  ELSE
   T0.L_CANCEL_AMOUNT
END AS WHDW_VOL, --撤单数量
0 AS ENTR_PRC, --委托价格
'200001' AS BUSI_TYP, --业务类别
'20000100' AS BUSI_CLAS, --业务类型
NULL AS RAT, --利率
0 AS ENTR_VAL, --委托金额
0 AS ENTR_TOT_FEE, --委托总费用
T0.L_OPERATOR_NO AS OPER_NO, --操作员编码
T0.L_RIVAL_ID AS TRD_CNTP_ID, --交易对手编码
NULL AS APPT_NUM, --约定号
NULL AS GUAR_SETT_FLAG, --担保交收标志
T0.L_DATE AS DELI_DT, --交割日期
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
cast(T0.L_FUND_ID as string) AS IN_PRD_CODE, --转入产品代码
cast(T3.L_ASSET_ID as string) AS IN_AST_UNIT_CODE, --转入资产单元代码
cast(T0.L_TARGET_COMBI_ID as string) AS IN_PFL_CODE, --转入投组代码
T0.VC_RIVAL_HOLDERID AS IN_SH_CODE, --转入股东代码
T0.VC_RIVAL_SEAT AS IN_SEAT_CODE, --转入席位号
case when NVL(T0.C_TARGET_INVEST_TYPE,T0.C_INVEST_TYPE) = '2' then '5' else T0.C_INVEST_TYPE end AS IN_INV_TYP, --转入投资类型
CASE
  WHEN T5.C_ASSET_CLASS = '2' THEN
   concat(T5.VC_REPORT_CODE , '.STK.' , --股票
   (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end))
  WHEN T5.C_ASSET_CLASS = '3' THEN --债券
   concat(T5.VC_REPORT_CODE , '.BOND.' ,
   (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end))
  WHEN T5.C_ASSET_CLASS = '4' THEN --基金
   concat(T5.VC_REPORT_CODE , '.FUND.' ,
   (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end))
END AS IN_SECU_ID, --转入证券编码
T5.VC_INTER_CODE AS IN_SRC_SECU_ID, --转入源证券ID
CASE
  WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
   0
  ELSE
   T0.L_ENTRUST_AMOUNT
END AS IN_ENTR_VOL, --转入委托数量
0 AS IN_ENTR_PRC, --转入委托价格
0 AS IN_ENTR_VAL, --转入委托金额
T0.VC_RIVAL_SEAT AS CNTP_SEAT_CODE, --对手方席位号
0 AS RES_FLAG, --限售标识
NULL AS LOCK_LMT_CLAS, --锁定受限类型
NULL AS LMT_CLAS_ONUM, --受限类型序号
NULL AS AGMT_NUM, --合同号
NULL AS BONS_MODE, --分红方式
NULL AS PAY_DT, --缴款日期
NULL AS CONT_MULT, --合约乘数
NULL AS COVR_DIR, --平仓方向
NULL AS ARBI_FLAG, --套利标志
NULL AS ETF_ONUM, --ETF序号
NULL AS ESTI_CASH_DIFF, --预估现金差额
NULL AS ETF_FND_CLAS, --ETF基金类型
CASE
  WHEN T0.C_ENTRUST_STATUS IN ('1') --1：未报
   THEN
   '1'
  WHEN T0.C_ENTRUST_STATUS IN ('4') --4：已报
   THEN
   '2'
  WHEN T0.C_ENTRUST_STATUS IN ('5') --5：废单
   THEN
   '3'
  WHEN T0.C_ENTRUST_STATUS IN ('6') --6：部成
   THEN
   '4'
  WHEN T0.C_ENTRUST_STATUS IN ('7') --7：已成
   THEN
   '5'
  WHEN T0.C_ENTRUST_STATUS IN ('F', '9') --F：已撤
   THEN
   '6'
  WHEN T0.C_ENTRUST_STATUS IN ('8') --8：部撤
   THEN
   '7'
  WHEN T0.C_ENTRUST_STATUS IN ('E') --E：撤废，是撤单委托的
   THEN
   '8'
END AS ENTR_STAT, --委托状态
${end_date} AS BUSI_DATE, --业务日期
'evt_exch_entr_his_9' AS TASK_RS_ID, --任务来源标识
CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
  T0.L_DATE	 as p_dt,
'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISENTRUSTS T0
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5
    ON T0.L_DATE = T5.L_DATE
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.P_DT BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTIONDETAIL T7
    ON T0.C_ENTRUST_DIRECTION = T7.C_ENTRUST_DIRECTION
   AND T0.C_MARKET_NO = T7.C_MARKET_NO
   AND T0.C_PRICE_TYPE = T7.C_PRICE_TYPE
 WHERE T0.C_BUSIN_CLASS IN ('1')
   AND T0.C_ENTRUST_DIRECTION IN ('G')
   AND T0.C_ENTRUST_STATUS IN ('1', '4', '5', '6', '7', 'F', '8', 'E', '9')
   AND T0.P_DT BETWEEN ${beg_date} and ${end_date}

UNION ALL
--离线委托：跨市场转托管转出（基金）
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       CASE
         WHEN T0.L_DAILY_INSTRUCTION_NO IS NULL OR
              T0.L_DAILY_INSTRUCTION_NO = 0 THEN
          concat('0|0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_ENTRUST_SERIAL_NO , '|0')
         ELSE
          concat('0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '|0|0')
       END AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_ENTRUST_SERIAL_NO) AS ENTR_ONUM, --委托序号
       T0.L_BATCH_SERIAL_NO AS ENTR_BTNO, --委托批号
       CASE
         WHEN T0.L_CANCEL_SERIAL_NO IS NULL THEN
          NULL
         ELSE
          concat(T0.L_DATE , '_HSO32' , '_' , T0.L_CANCEL_SERIAL_NO)
       END AS WHDW_ENTR_ONUM, --被撤单委托序号
       T0.L_REPORT_SERIAL_NO AS REP_ID, --申报编号
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_BASECOMBI_ID , '_' , T5.VC_REPORT_CODE , '.FUND.' ,
       (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end) , '_' ,
       (CASE
         WHEN T0.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T0.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T0.C_INVEST_TYPE
       END) , '_' ,
       '21000102') AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_REPORT_SEAT AS SEAT_CODE, --席位号
       CASE
         WHEN T0.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T0.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       CASE
         WHEN T5.C_ASSET_CLASS = '4' THEN --基金
          concat(T5.VC_REPORT_CODE , '.FUND.' , (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end))
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
       CASE WHEN T5.C_MARKET_NO = '1' THEN
            1
            ELSE
            0
       END AS CLR_SPED, --清算速度
       NULL AS TRD_PLFM, --交易平台
	   NULL AS TRD_MODE,--交易方式
       '43' AS ENTR_DIR, --委托方向
       CASE
         WHEN T7.C_MARKET_NO = '1' AND T7.C_PRICE_TYPE = 'P' THEN
          '31'
         WHEN T7.C_MARKET_NO = 'j' AND T7.C_PRICE_TYPE = '4' THEN
          '14'
         ELSE
          (case when T7.C_LIMIT_PRICE = 0 then '2' else T7.C_LIMIT_PRICE end)
       END AS ENTR_PRC_CLAS, --委托价格类型
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          T0.L_ENTRUST_AMOUNT
       END AS ENTR_VOL, --委托数量
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          T0.L_CANCEL_AMOUNT
       END AS WHDW_VOL, --撤单数量
       0 AS ENTR_PRC, --委托价格
       '200001' AS BUSI_TYP, --业务类别
       '21000102' AS BUSI_CLAS, --业务类型
       NULL AS RAT, --利率
       0 AS ENTR_VAL, --委托金额
       0 AS ENTR_TOT_FEE, --委托总费用
       T0.L_OPERATOR_NO AS OPER_NO, --操作员编码
       T0.L_RIVAL_ID AS TRD_CNTP_ID, --交易对手编码
       NULL AS APPT_NUM, --约定号
       NULL AS GUAR_SETT_FLAG, --担保交收标志
       T0.L_DATE AS DELI_DT, --交割日期
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
       NULL AS IN_SH_CODE, --转入股东代码
       NULL AS IN_SEAT_CODE, --转入席位号
       NULL AS IN_INV_TYP, --转入投资类型
       NULL AS IN_SECU_ID, --转入证券编码
       NULL AS IN_SRC_SECU_ID, --转入源证券ID
       NULL AS IN_ENTR_VOL, --转入委托数量
       NULL AS IN_ENTR_PRC, --转入委托价格
       NULL AS IN_ENTR_VAL, --转入委托金额
       T0.VC_RIVAL_SEAT AS CNTP_SEAT_CODE, --对手方席位号
       0 AS RES_FLAG, --限售标识
       NULL AS LOCK_LMT_CLAS, --锁定受限类型
       NULL AS LMT_CLAS_ONUM, --受限类型序号
       NULL AS AGMT_NUM, --合同号
       NULL AS BONS_MODE, --分红方式
       NULL AS PAY_DT, --缴款日期
       NULL AS CONT_MULT, --合约乘数
       NULL AS COVR_DIR, --平仓方向
       NULL AS ARBI_FLAG, --套利标志
	   NULL AS ETF_ONUM, --ETF序号
       NULL AS ESTI_CASH_DIFF, --预估现金差额
       NULL AS ETF_FND_CLAS, --ETF基金类型
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('1') --1：未报
          THEN
          '1'
         WHEN T0.C_ENTRUST_STATUS IN ('4') --4：已报
          THEN
          '2'
         WHEN T0.C_ENTRUST_STATUS IN ('5') --5：废单
          THEN
          '3'
         WHEN T0.C_ENTRUST_STATUS IN ('6') --6：部成
          THEN
          '4'
         WHEN T0.C_ENTRUST_STATUS IN ('7') --7：已成
          THEN
          '5'
         WHEN T0.C_ENTRUST_STATUS IN ('F', '9') --F：已撤
          THEN
          '6'
         WHEN T0.C_ENTRUST_STATUS IN ('8') --8：部撤
          THEN
          '7'
         WHEN T0.C_ENTRUST_STATUS IN ('E') --E：撤废，是撤单委托的
          THEN
          '8'
       END AS ENTR_STAT, --委托状态
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_exch_entr_his_10' AS TASK_RS_ID, --任务来源标识
	   CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
	     T0.L_DATE  as p_dt	,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISENTRUSTS T0
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5
    ON T0.L_DATE = T5.L_DATE
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.P_DT BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTIONDETAIL T7
    ON T0.C_ENTRUST_DIRECTION = T7.C_ENTRUST_DIRECTION
   AND T0.C_MARKET_NO = T7.C_MARKET_NO
   AND T0.C_PRICE_TYPE = T7.C_PRICE_TYPE
 WHERE T0.C_BUSIN_CLASS IN ('5', 'v')
   AND T0.C_ENTRUST_DIRECTION IN ('G', 'g')
   AND T0.C_ENTRUST_STATUS IN ('1', '4', '5', '6', '7', 'F', '8', 'E', '9')
   AND T0.P_DT BETWEEN ${beg_date} and ${end_date}

 UNION ALL
--离线委托：转融券成交/展期/提前了结
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       CASE
         WHEN T0.L_DAILY_INSTRUCTION_NO IS NULL OR
              T0.L_DAILY_INSTRUCTION_NO = 0 THEN
          concat('0|0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_ENTRUST_SERIAL_NO , '|0')
         ELSE
          concat('0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '|0|0')
       END AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_ENTRUST_SERIAL_NO) AS ENTR_ONUM, --委托序号
       T0.L_BATCH_SERIAL_NO AS ENTR_BTNO, --委托批号
       CASE
         WHEN T0.L_CANCEL_SERIAL_NO IS NULL THEN
          NULL
         ELSE
          concat(T0.L_DATE , '_HSO32' , '_' , T0.L_CANCEL_SERIAL_NO)
       END AS WHDW_ENTR_ONUM, --被撤单委托序号
       T0.L_REPORT_SERIAL_NO AS REP_ID, --申报编号
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_BASECOMBI_ID , '_' , T5.VC_REPORT_CODE , '.REFC.' ,
          (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end) , '_' ,
       (CASE
         WHEN T0.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T0.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T0.C_INVEST_TYPE
       END) , '_' ,
       (CASE
         WHEN T0.C_ENTRUST_DIRECTION = 'l' THEN
          '23000100'
         WHEN T0.C_ENTRUST_DIRECTION = 'M' THEN
          '23000102'
         WHEN T0.C_ENTRUST_DIRECTION = '98' THEN
          '23000103'
       END)) AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_REPORT_SEAT AS SEAT_CODE, --席位号
       CASE
         WHEN T0.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T0.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       CASE
         WHEN T0.C_ENTRUST_DIRECTION = 'l' THEN
          concat(T5.VC_REPORT_CODE , '.REFC.' , (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end))
         WHEN T0.C_ENTRUST_DIRECTION = 'M' THEN
          concat(T0.VC_CONTRACT_NO , '.REFC.' , (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end))
         WHEN T0.C_ENTRUST_DIRECTION = '98' THEN
          concat(T0.VC_CONTRACT_NO , '.REFC.' , (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end))
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
         WHEN T0.C_ENTRUST_DIRECTION = 'l' THEN
          '49'
         WHEN T0.C_ENTRUST_DIRECTION = 'M' THEN
          '23'
         WHEN T0.C_ENTRUST_DIRECTION = '98' THEN
          '210'
       END AS ENTR_DIR, --委托方向
       CASE
         WHEN T7.C_MARKET_NO = '1' AND T7.C_PRICE_TYPE = 'P' THEN
          '31'
         WHEN T7.C_MARKET_NO = 'j' AND T7.C_PRICE_TYPE = '4' THEN
          '14'
         ELSE
          (case when T7.C_LIMIT_PRICE = 0 then '2' else T7.C_LIMIT_PRICE end)
       END AS ENTR_PRC_CLAS, --委托价格类型
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          T0.L_ENTRUST_AMOUNT
       END AS ENTR_VOL, --委托数量
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          T0.L_CANCEL_AMOUNT
       END AS WHDW_VOL, --撤单数量
       T0.EN_FACT_PRICE AS ENTR_PRC, --委托价格
       '230001' AS BUSI_TYP, --业务类别
       CASE
         WHEN T0.C_ENTRUST_DIRECTION = 'l' THEN
          '23000100'
         WHEN T0.C_ENTRUST_DIRECTION = 'M' THEN
          '23000102'
         WHEN T0.C_ENTRUST_DIRECTION = '98' THEN
          '23000103'
       END AS BUSI_CLAS, --业务类型
       T0.EN_ENTRUST_PRICE AS RAT, --利率
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          T0.EN_BALANCE
       END AS ENTR_VAL, --委托金额
       0 AS ENTR_TOT_FEE, --委托总费用
       T0.L_OPERATOR_NO AS OPER_NO, --操作员编码
       T0.L_RIVAL_ID AS TRD_CNTP_ID, --交易对手编码
       T0.VC_ENGAGED_NO AS APPT_NUM, --约定号
       NULL AS GUAR_SETT_FLAG, --担保交收标志
       T0.L_DATE AS DELI_DT, --交割日期
       T0.L_HG_DAYS AS CONT_DAYS, --合约天数
       datediff(from_unixtime(unix_timestamp(cast(w1.aft_0_dt as string),'yyyyMMdd'),'yyyy-MM-dd'), from_unixtime(unix_timestamp(cast(T0.L_DATE as string),'yyyyMMdd'),'yyyy-MM-dd')) AS INTA_DAYS, --计息天数
       T0.L_DATE AS CONT_TNV_DT, --合约成交日期
       CASE WHEN T0.C_ENTRUST_DIRECTION = '98' THEN
           T0.L_SECOND_SETTLE_DATE
       ELSE
       	   w1.aft_0_dt
       END AS CONT_END_DT, --合约到期日期
       T0.L_DATE AS FIR_DELI_DT, --首期交割日期
       CASE WHEN T0.C_ENTRUST_DIRECTION = '98' THEN
          T0.L_SECOND_SETTLE_DATE
	   ELSE
		  w1.aft_0_dt
        END AS END_DELI_DT, --到期交割日期
       '3' AS FIR_DELI_MODE, --首期交割方式
       '3' AS END_DELI_MODE, --到期交割方式
       T0.EN_BALANCE + ROUND((
					datediff(from_unixtime(unix_timestamp(cast(CASE WHEN T0.C_ENTRUST_DIRECTION = '98' THEN T0.L_SECOND_SETTLE_DATE ELSE w1.aft_0_dt END as string),'yyyyMMdd'),'yyyy-MM-dd')
					, from_unixtime(unix_timestamp(cast(T0.L_DATE as string),'yyyyMMdd'),'yyyy-MM-dd')) ) *
             T0.EN_BALANCE * T0.EN_ENTRUST_PRICE / 100 / 360,
             2) AS BUYB_VAL, --购回金额
       ROUND((datediff(from_unixtime(unix_timestamp(cast(CASE WHEN T0.C_ENTRUST_DIRECTION = '98' THEN T0.L_SECOND_SETTLE_DATE ELSE w1.aft_0_dt END as string),'yyyyMMdd'),'yyyy-MM-dd')
					, from_unixtime(unix_timestamp(cast(T0.L_DATE as string),'yyyyMMdd'),'yyyy-MM-dd')) ) *
             T0.EN_BALANCE * T0.EN_ENTRUST_PRICE / 100 / 360,
             2) AS INTR, --利息
       NULL AS IN_PRD_CODE, --转入产品代码
       NULL AS IN_AST_UNIT_CODE, --转入资产单元代码
       NULL AS IN_PFL_CODE, --转入投组代码
       NULL AS IN_SH_CODE, --转入股东代码
       NULL AS IN_SEAT_CODE, --转入席位号
       NULL AS IN_INV_TYP, --转入投资类型
       NULL AS IN_SECU_ID, --转入证券编码
       NULL AS IN_SRC_SECU_ID, --转入源证券ID
       NULL AS IN_ENTR_VOL, --转入委托数量
       NULL AS IN_ENTR_PRC, --转入委托价格
       NULL AS IN_ENTR_VAL, --转入委托金额
       T0.VC_RIVAL_SEAT AS CNTP_SEAT_CODE, --对手方席位号
       CASE WHEN T0.C_STRATEGY_PLACING = '1' THEN
          1  --战略配售限售出借
         ELSE
          0  --非限售
       END AS RES_FLAG, --限售标识
       CASE WHEN T0.C_STRATEGY_PLACING = '1' THEN
          4  --战略配售限售出借
         ELSE
          0  --非限售
       END AS LOCK_LMT_CLAS, --锁定受限类型
       NULL AS LMT_CLAS_ONUM, --受限类型序号
       T0.VC_CONTRACT_NO AS AGMT_NUM, --合同号
       NULL AS BONS_MODE, --分红方式
       NULL AS PAY_DT, --缴款日期
       NULL AS CONT_MULT, --合约乘数
       NULL AS COVR_DIR, --平仓方向
       NULL AS ARBI_FLAG, --套利标志
	   NULL AS ETF_ONUM, --ETF序号
       NULL AS ESTI_CASH_DIFF, --预估现金差额
       NULL AS ETF_FND_CLAS, --ETF基金类型
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('1') --1：未报
          THEN
          '1'
         WHEN T0.C_ENTRUST_STATUS IN ('4') --4：已报
          THEN
          '2'
         WHEN T0.C_ENTRUST_STATUS IN ('5') --5：废单
          THEN
          '3'
         WHEN T0.C_ENTRUST_STATUS IN ('6') --6：部成
          THEN
          '4'
         WHEN T0.C_ENTRUST_STATUS IN ('7') --7：已成
          THEN
          '5'
         WHEN T0.C_ENTRUST_STATUS IN ('F', '9') --F：已撤
          THEN
          '6'
         WHEN T0.C_ENTRUST_STATUS IN ('8') --8：部撤
          THEN
          '7'
         WHEN T0.C_ENTRUST_STATUS IN ('E') --E：撤废，是撤单委托的
          THEN
          '8'
       END AS ENTR_STAT, --委托状态
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_exch_entr_his_11' AS TASK_RS_ID, --任务来源标识
	   CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
	     T0.L_DATE	 as p_dt,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISENTRUSTS T0
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5
    ON T0.L_DATE = T5.L_DATE
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.P_DT BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTIONDETAIL T7
    ON T0.C_ENTRUST_DIRECTION = T7.C_ENTRUST_DIRECTION
   AND T0.C_MARKET_NO = T7.C_MARKET_NO
   AND T0.C_PRICE_TYPE = T7.C_PRICE_TYPE
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
    ON cast(date_add(from_unixtime(unix_timestamp(cast(T0.L_DATE as string),'yyyyMMdd'),'yyyy-MM-dd'),cast(T0.L_HG_DAYS as int)) as bigint) = w1.dt
   AND T5.C_MARKET_NO = w1.mkt_no
   AND W1.SYS_RS_ID = 'O3'
 WHERE T0.C_BUSIN_CLASS IN ('E')
   AND T0.C_ENTRUST_DIRECTION IN ('l', 'M', '98')
   AND T0.C_ENTRUST_STATUS IN ('1', '4', '5', '6', '7', 'F', '8', 'E', '9')
   AND T0.P_DT BETWEEN ${beg_date} and ${end_date}

UNION ALL
--离线委托：债转股
SELECT '1' AS BUSI_SYS_ID, --业务系统编码
       CASE
         WHEN T0.L_DAILY_INSTRUCTION_NO IS NULL OR
              T0.L_DAILY_INSTRUCTION_NO = 0 THEN
          concat('0|0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_ENTRUST_SERIAL_NO , '|0')
         ELSE
          concat('0|' , T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '|0|0')
       END AS TRD_SRC_ID, --交易源ID
       T0.L_DATE AS OCCU_DT, --发生日期
       date_format(T0.D_DATETIME,'HHmmss') AS OCCU_TIME, --发生时间
       concat(T0.L_DATE , '_HSO32' , '_' , T0.L_ENTRUST_SERIAL_NO) AS ENTR_ONUM, --委托序号
       T0.L_BATCH_SERIAL_NO AS ENTR_BTNO, --委托批号
       CASE
         WHEN T0.L_CANCEL_SERIAL_NO IS NULL THEN
          NULL
         ELSE
          concat(T0.L_DATE , '_HSO32' , '_' , T0.L_CANCEL_SERIAL_NO)
       END AS WHDW_ENTR_ONUM, --被撤单委托序号
       T0.L_REPORT_SERIAL_NO AS REP_ID, --申报编号
       CASE WHEN T0.L_DAILY_INSTRUCTION_NO IS NULL OR
              T0.L_DAILY_INSTRUCTION_NO = 0 THEN
        NULL
      ELSE
     concat(T0.L_DATE , '_HSO32' , '_' , T0.L_DAILY_INSTRUCTION_NO , '_' , T0.L_BASECOMBI_ID , '_' , T6.VC_REPORT_CODE , '.BOND.' ,
       (case when T5.C_MARKET_NO = '1' then 'SH' when T5.C_MARKET_NO = '2' then 'SZ' end) , '_' , (CASE
         WHEN T0.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T0.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T0.C_INVEST_TYPE
       END) , '_' , ('26000100'))
     END AS ODR_RELA_ONUM, --指令关联序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_REPORT_SEAT AS SEAT_CODE, --席位号
       CASE
         WHEN T0.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T0.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
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
         WHEN T9.C_MARKET_NO = '1' AND T9.C_PRICE_TYPE = 'P' THEN
          '31'
         WHEN T9.C_MARKET_NO = 'j' AND T9.C_PRICE_TYPE = '4' THEN
          '14'
         ELSE
          (case when T9.C_LIMIT_PRICE = 0 then '2' else T9.C_LIMIT_PRICE end)
       END AS ENTR_PRC_CLAS, --委托价格类型
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          T0.L_ENTRUST_AMOUNT
       END AS ENTR_VOL, --委托数量
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          T0.L_CANCEL_AMOUNT
       END AS WHDW_VOL, --撤单数量
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          (case when SUBSTR(T0.VC_INTER_CODE,-2) = 'SS' then T0.EN_ENTRUST_PRICE else 100 end)
       END AS ENTR_PRC, --委托价格
       '260001' AS BUSI_TYP, --业务类别
       '26000100' AS BUSI_CLAS, --业务类型
       NULL AS RAT, --利率
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          (case when SUBSTR(T0.VC_INTER_CODE,-2) = 'SS' then T0.EN_BALANCE else 100 * T0.L_ENTRUST_AMOUNT end)
       END AS ENTR_VAL, --委托金额
       0 AS ENTR_TOT_FEE, --委托总费用
       T0.L_OPERATOR_NO AS OPER_NO, --操作员编码
       T0.L_RIVAL_ID AS TRD_CNTP_ID, --交易对手编码
       NULL AS APPT_NUM, --约定号
       NULL AS GUAR_SETT_FLAG, --担保交收标志
       w1.aft_1_dt AS DELI_DT, --交割日期
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
       T0.VC_STOCKHOLDER_ID AS IN_SH_CODE, --转入股东代码
       T0.VC_SEAT_ID AS IN_SEAT_CODE, --转入席位号
       (case when T0.C_INVEST_TYPE = '1' then '2'
		     when T0.C_INVEST_TYPE = '2' then '1'
             when T0.C_INVEST_TYPE = 'a' then '15'
             when T0.C_INVEST_TYPE = 'b' then '10'
             when T0.C_INVEST_TYPE = 'c' then '12'
		else T0.C_INVEST_TYPE end) AS IN_INV_TYP, --转入投资类型
       concat(T8.VC_REPORT_CODE , '.STK.' , (case when T8.C_MARKET_NO = '1' then 'SH' when T8.C_MARKET_NO = '2' then 'SZ' end)) AS IN_SECU_ID, --转入证券编码
       T7.VC_INTER_CODE AS IN_SRC_SECU_ID, --转入源证券ID
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          T7.L_AMOUNT
       END AS IN_ENTR_VOL, --转入委托数量
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          T7.EN_FACT_PRICE
       END AS IN_ENTR_PRC, --转入委托价格
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('A', 'E') THEN
          0
         ELSE
          T7.EN_BALANCE
       END AS IN_ENTR_VAL, --转入委托金额
       T0.VC_RIVAL_SEAT AS CNTP_SEAT_CODE, --对手方席位号
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
       NVL(T4.L_RESTRICTED_NO, 0) AS LMT_CLAS_ONUM, --受限类型序号
       NULL AS AGMT_NUM, --合同号
       NULL AS BONS_MODE, --分红方式
       NULL AS PAY_DT, --缴款日期
       NULL AS CONT_MULT, --合约乘数
       NULL AS COVR_DIR, --平仓方向
       NULL AS ARBI_FLAG, --套利标志
	   NULL AS ETF_ONUM, --ETF序号
       NULL AS ESTI_CASH_DIFF, --预估现金差额
       NULL AS ETF_FND_CLAS, --ETF基金类型
       CASE
         WHEN T0.C_ENTRUST_STATUS IN ('1') --1：未报
          THEN
          '1'
         WHEN T0.C_ENTRUST_STATUS IN ('4') --4：已报
          THEN
          '2'
         WHEN T0.C_ENTRUST_STATUS IN ('5') --5：废单
          THEN
          '3'
         WHEN T0.C_ENTRUST_STATUS IN ('6') --6：部成
          THEN
          '4'
         WHEN T0.C_ENTRUST_STATUS IN ('7') --7：已成
          THEN
          '5'
         WHEN T0.C_ENTRUST_STATUS IN ('F', '9') --F：已撤
          THEN
          '6'
         WHEN T0.C_ENTRUST_STATUS IN ('8') --8：部撤
          THEN
          '7'
         WHEN T0.C_ENTRUST_STATUS IN ('E') --E：撤废，是撤单委托的
          THEN
          '8'
       END AS ENTR_STAT, --委托状态
       ${end_date} AS BUSI_DATE, --业务日期
       'evt_exch_entr_his_12' AS TASK_RS_ID, --任务来源标识
	   CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
	     T0.L_DATE as p_dt	,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISENTRUSTS T0
  LEFT JOIN ${ods_db}.O3_THISINSTRUCTIONSTOCK T4  --债转股
    ON T0.L_DATE = T4.L_DATE
   AND T0.L_DAILY_INSTRUCTION_NO = T4.L_DAILY_INSTRUCTION_NO
   AND T0.L_INDEX_DAILY_MODIFY = T4.L_INDEX_DAILY_MODIFY
   AND T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
   AND T4.C_ENTRUST_DIRECTION = 'A'
   AND T4.C_INSTRUCTION_STATUS IN ('1', '3', '5', '6', 'a')
   AND T4.P_DT BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_THISINSTRUCTIONSTOCK T7  --买入股票
         ON T0.L_DATE = T7.L_DATE
                AND T0.L_DAILY_INSTRUCTION_NO = T7.L_DAILY_INSTRUCTION_NO
                AND T0.L_INDEX_DAILY_MODIFY = T7.L_INDEX_DAILY_MODIFY
                AND T0.L_FUND_ID = T7.L_FUND_ID
                AND SUBSTR(T7.VC_INTER_CODE, 1, 1) IN ('0', '3', '6')
                AND T7.C_ENTRUST_DIRECTION = '1'
                AND T7.C_ORIGINAL_DIRECTION = 'A'
                AND T7.C_INSTRUCTION_STATUS IN ('1', '3', '5', '6', 'a')
   AND T7.P_DT BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5
    ON T0.L_DATE = T5.L_DATE
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.P_DT BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T6 --证券基本信息表，获取正式代码
    ON T5.L_DATE = T6.L_DATE
   AND T5.VC_ASSET_RELATIVE_CODE = T6.VC_INTER_CODE
   AND T6.C_ASSET_CLASS IN ('2', '3','6')
   AND T6.P_DT BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T8
    ON T7.L_DATE = T8.L_DATE
   AND T7.VC_INTER_CODE = T8.VC_INTER_CODE
   AND T8.P_DT BETWEEN ${beg_date} and ${end_date}
  LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTIONDETAIL T9
    ON T0.C_ENTRUST_DIRECTION = T9.C_ENTRUST_DIRECTION
   AND T0.C_MARKET_NO = T9.C_MARKET_NO
   AND T0.C_PRICE_TYPE = T9.C_PRICE_TYPE
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T10 --产品基本信息表，获取产品代码
    ON T7.L_FUND_ID = T10.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T11 --投资组合基本信息表，获取投资组合代码
    ON T7.L_BASECOMBI_ID = T11.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T12 --资产单元基本信息表，获取资产单元代码
    ON T11.L_ASSET_ID = T12.L_ASSET_ID
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade W1
    ON T0.L_DATE = w1.dt
   AND T5.C_MARKET_NO = w1.mkt_no
   AND W1.SYS_RS_ID = 'O3'
 WHERE T0.C_BUSIN_CLASS IN ('1')
   AND T0.C_ENTRUST_DIRECTION IN ('A')
   AND T0.C_ENTRUST_STATUS IN ('1', '4', '5', '6', '7', 'F', '8', 'E', '9')
   AND T0.P_DT BETWEEN ${beg_date} and ${end_date}
