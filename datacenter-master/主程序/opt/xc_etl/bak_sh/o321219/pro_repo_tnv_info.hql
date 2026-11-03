------------------------------------------------------------------------
  -- 模块名称：回购成交合约表
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

alter table ${dwd_db}.pro_repo_tnv_info drop if exists partition (sys_rs_id='O3') ;
insert into ${dwd_db}.pro_repo_tnv_info partition (sys_rs_id)
(prd_code ,
   ast_unit_code ,
   pfl_code ,
   occu_dt ,
   secu_id ,
   typ_code ,
   typ_codei ,
   typ_codeii ,
   exch_code ,
   repo_trd_mode ,
   repo_days ,
   clr_sped ,
   inta_days ,
   tnv_dt ,
   buyb_dt ,
   fir_deli_dt ,
   end_deli_dt ,
   fir_deli_mode ,
   end_deli_mode ,
   pos_id ,
   repo_rat ,
   fir_net_prc ,
   end_net_prc,
   fir_hd_intr ,
   end_hd_intr ,
   tnv_vol ,
   tnv_val ,
   buyb_val ,
   repo_intr ,
   repo_fee ,
   clr_typ,
   trd_cntp_id,
   tnv_no,
   var_secu_id,
   busi_date ,
   task_rs_id ,
   dm_created_time,
   sys_rs_id
)
           --已到期回购获取
        SELECT T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
               CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
               CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
               T0.L_DATE AS OCCU_DT, -- 发生日期
               CONCAT(T0.L_SERIAL_NO , '_' , T1.VC_FUND_CODE , '_' , T0.L_HG_DATE , '_' ,
               T5.VC_REPORT_CODE , '.REPO.' , (CASE
               WHEN T0.C_MARKET_NO = '1' THEN
                'SH'
               WHEN T0.C_MARKET_NO = '2' THEN
                'SZ' END)) AS SECU_ID, -- 证券编码
               'REPO' AS TYP_CODE, --  证券类别代码（大类），默认回购
               (CASE T0.C_STOCK_TYPE WHEN '8' THEN 'REPO101' WHEN '-' THEN 'REPO104' END) AS TYP_CODEI, -- 证券类别代码（中类）
			   (CASE T0.C_STOCK_TYPE
					WHEN '8' THEN 'REPO10101'
					WHEN '-'
						THEN 'REPO10401' END)                                                                AS TYP_CODEII,      -- 证券类别代码（细分）
               (CASE T5.C_MARKET_NO WHEN '1' THEN 'SH' WHEN '2' THEN 'SZ' END) AS EXCH_CODE, -- 交易市场代码
               (CASE T0.C_STOCK_TYPE WHEN '8' THEN '1' WHEN '-' THEN '3' END) AS REPO_TRD_MODE, -- 回购交易方式
               T0.L_REDEEM_DAYS AS REPO_DAYS, -- 回购天数
               T0.L_SETTLE_SPEED AS CLR_SPED, --  清算速度
               DATEDIFF(from_unixtime(unix_timestamp(cast(CASE T0.L_SETTLE_SPEED WHEN 0 THEN T0.L_REDEEM_LIQUIDATE WHEN 1 THEN T9.aft_1_dt END AS STRING),'yyyyMMdd'),'yyyy-MM-dd')
               ,from_unixtime(   unix_timestamp(CAST(CASE T0.L_SETTLE_SPEED WHEN 0 THEN T0.L_HG_DATE WHEN 1 THEN T8.aft_1_dt END AS STRING),'yyyyMMdd'),'yyyy-MM-dd')) AS INTA_DAYS, -- 计息天数,通过到期交割日期-首期交割日期
               T0.L_HG_DATE AS TNV_DT, --  成交日期
               T0.L_REDEEM_LIQUIDATE AS BUYB_DT, -- 购回日期
               (CASE T0.L_SETTLE_SPEED WHEN 0 THEN T0.L_HG_DATE WHEN 1 THEN  T8.aft_1_dt END) AS FIR_DELI_DT, -- 首期交割日期
               (CASE T0.L_SETTLE_SPEED WHEN 0 THEN T0.L_REDEEM_LIQUIDATE WHEN 1 THEN T9.aft_1_dt END) AS END_DELI_DT, -- 到期交割日期
               '3' AS FIR_DELI_MODE, -- 首期交割方式，默认券款兑付
               '3' AS END_DELI_MODE, -- 到期交割方式，默认券款兑付
               CASE
                 WHEN T0.C_ENTRUST_DIRECTION IN ('5', '7', '15', '17') THEN
                  'S'
                 ELSE
                  'L'
               END AS POS_ID, --  多空标志,正回购为空头，逆回购为多头
               T0.EN_DEAL_PRICE / 100 AS REPO_RAT, --  回购利率
               T0.EN_FIRST_PRICE AS FIR_NET_PRC, -- 首期净价价格
               T0.EN_MATURE_PRICE AS END_NET_PRC, -- 到期净价价格
               T0.EN_FIRST_BOND_INTEREST AS FIR_HD_INTR, -- 首期百元利息
               T0.EN_MATURE_BOND_INTEREST AS END_HD_INTR, -- 到期百元利息
               T0.L_DEAL_AMOUNT AS TNV_VOL, -- 成交数量
               T0.EN_DEAL_BALANCE AS TNV_VAL, -- 成交金额
               T0.EN_DEAL_BALANCE + T0.EN_REDEEM_INTEREST AS BUYB_VAL, --  购回金额
               T0.EN_REDEEM_INTEREST AS REPO_INTR, -- 回购利息
               T0.EN_FEE AS REPO_FEE, --  回购费用
               (CASE T0.C_STOCK_TYPE WHEN '8' THEN '2' WHEN '-' THEN '1' END) AS CLR_TYP, -- 清算类型
               T0.L_RIVAL_ID AS TRD_CNTP_ID, -- 交易对手编码
               T0.VC_DEAL_NO AS TNV_NO, --成交编号
               CONCAT(T5.VC_REPORT_CODE , '.REPO.' , (CASE
                                             WHEN T0.C_MARKET_NO = '1' THEN
                                              'SH'
                                             WHEN T0.C_MARKET_NO = '2' THEN
                                              'SZ' END)) AS VAR_SECU_ID, --品种代码
               ${end_date} as busi_date, --业务日期
               'pro_repo_tnv_info_1' AS TASK_RS_ID, --任务来源标识
               CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
               'O3' AS SYS_RS_ID --系统来源标识
          FROM ${ods_db}.O3_THISHGREGISTER T0
          LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
            ON T0.L_FUND_ID = T1.L_FUND_ID
          LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
            ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
          LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
            ON T3.L_ASSET_ID = T2.L_ASSET_ID
          LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表
            ON T0.P_DT = T5.P_DT
           AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
           AND T5.C_MARKET_NO IN ('1', '2')
           LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade T9
           ON T0.L_REDEEM_LIQUIDATE = T9.DT
           AND T5.C_MARKET_NO = T9.mkt_no
           and t9.SYS_RS_ID = 'O3'
           LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade T8
           ON T0.L_HG_DATE = T8.DT
           AND T5.C_MARKET_NO = T8.mkt_no
           and t8.SYS_RS_ID = 'O3'
         WHERE T0.C_MARKET_NO IN ('1', '2')

        UNION ALL
        --未到期回购获取
        SELECT T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
               CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
               CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
               T0.L_DATE AS OCCU_DT, -- 发生日期
               CONCAT(T0.L_SERIAL_NO , '_' , T1.VC_FUND_CODE , '_' , T0.L_HG_DATE , '_' ,
               T5.VC_REPORT_CODE , '.REPO.' , (CASE T5.C_MARKET_NO WHEN '1' THEN 'SH' WHEN '2' THEN 'SZ' END)) AS SECU_ID, -- 证券编码
               'REPO' AS TYP_CODE, --  证券类别代码（大类），默认回购
               (CASE T0.C_STOCK_TYPE WHEN '8' THEN 'REPO101' WHEN '-' THEN 'REPO104' END)  AS TYP_CODEI, -- 证券类别代码（中类）
			   (CASE T0.C_STOCK_TYPE
			   		WHEN '8' THEN 'REPO10101'
			   		WHEN '-'
			   			THEN 'REPO10401' END)                                                                       AS TYP_CODEII,      --证券类别代码（细分）
               (CASE T5.C_MARKET_NO WHEN '1' THEN 'SH' WHEN '2' THEN 'SZ' END) AS EXCH_CODE, -- 交易市场代码
               (CASE T0.C_STOCK_TYPE WHEN '8' THEN '1' WHEN '-' THEN '3' END ) AS REPO_TRD_MODE, -- 回购交易方式
               T0.L_REDEEM_DAYS AS REPO_DAYS, -- 回购天数
               T0.L_SETTLE_SPEED AS CLR_SPED, --  清算速度
               DATEDIFF(from_unixtime(unix_timestamp(CAST(CASE T0.L_SETTLE_SPEED WHEN 0 THEN T0.L_REDEEM_LIQUIDATE WHEN 1 THEN T9.aft_1_dt END AS STRING),'yyyyMMdd'),'yyyy-MM-dd')
               ,from_unixtime(   unix_timestamp(CAST(CASE T0.L_SETTLE_SPEED WHEN 0 THEN T0.L_HG_DATE WHEN 1 THEN T8.aft_1_dt END AS STRING),'yyyyMMdd'),'yyyy-MM-dd')) AS INTA_DAYS, -- 计息天数,通过到期交割日期-首期交割日期
               T0.L_HG_DATE AS TNV_DT, --  成交日期
               T0.L_REDEEM_LIQUIDATE AS BUYB_DT, -- 购回日期
               (CASE T0.L_SETTLE_SPEED WHEN 0 THEN T0.L_HG_DATE WHEN 1 THEN T8.aft_1_dt END) AS FIR_DELI_DT, -- 首期交割日期
               (CASE T0.L_SETTLE_SPEED WHEN 0 THEN T0.L_REDEEM_LIQUIDATE WHEN 1 THEN T9.aft_1_dt END)  AS END_DELI_DT, -- 到期交割日期
               '3' AS FIR_DELI_MODE, -- 首期交割方式，默认券款兑付
               '3' AS END_DELI_MODE, -- 到期交割方式，默认券款兑付
               CASE
                 WHEN T0.C_ENTRUST_DIRECTION IN ('5', '7', '15', '17') THEN
                  'S'
                 ELSE
                  'L'
               END AS POS_ID, --  多空标志,正回购为空头，逆回购为多头
               T0.EN_DEAL_PRICE / 100 AS REPO_RAT, --  回购利率
               T0.EN_FIRST_PRICE AS FIR_NET_PRC, -- 首期净价价格
               T0.EN_MATURE_PRICE AS END_NET_PRC, -- 到期净价价格
               T0.EN_FIRST_BOND_INTEREST AS FIR_HD_INTR, -- 首期百元利息
               T0.EN_MATURE_BOND_INTEREST AS END_HD_INTR, -- 到期百元利息
               T0.L_DEAL_AMOUNT AS TNV_VOL, -- 成交数量
               T0.EN_DEAL_BALANCE AS TNV_VAL, -- 成交金额
               T0.EN_DEAL_BALANCE + T0.EN_REDEEM_INTEREST AS BUYB_VAL, --  购回金额
               T0.EN_REDEEM_INTEREST AS REPO_INTR, -- 回购利息
               T0.EN_FEE AS REPO_FEE, --  回购费用
               (CASE T0.C_STOCK_TYPE WHEN '8' THEN '2' WHEN '-' THEN '1' END ) AS CLR_TYP, -- 清算类型
               T0.L_RIVAL_ID AS TRD_CNTP_ID, -- 交易对手编码
               T0.VC_DEAL_NO AS TNV_NO, --成交编号
               CONCAT(T5.VC_REPORT_CODE , '.REPO.' , (CASE
                                             WHEN T0.C_MARKET_NO = '1' THEN
                                              'SH'
                                             WHEN T0.C_MARKET_NO = '2' THEN
                                              'SZ' END)) AS VAR_SECU_ID, --品种代码
               ${current_date} as busi_date, --业务日期
               'pro_repo_tnv_info_2' AS TASK_RS_ID, --任务来源标识
               CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
               'O3' AS SYS_RS_ID --系统来源标识
          FROM ${ods_db}.O3_THGREGISTER T0
          LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
            ON T0.L_FUND_ID = T1.L_FUND_ID
          LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
            ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
          LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
            ON T3.L_ASSET_ID = T2.L_ASSET_ID
          LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，
            ON T0.L_DATE = T5.L_DATE
           AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
           AND T5.C_MARKET_NO IN ('1', '2')
         LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade T9
           ON T0.L_REDEEM_LIQUIDATE = T9.DT
           AND T5.C_MARKET_NO = T9.mkt_no
           and t9.SYS_RS_ID = 'O3'
           LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade T8
           ON T0.L_HG_DATE = T8.DT
           AND T5.C_MARKET_NO = T8.mkt_no
           and t8.SYS_RS_ID = 'O3'
         WHERE T0.C_MARKET_NO IN ('1', '2')

UNION ALL
--已到期回购信息获取
SELECT T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.L_DATE AS OCCU_DT, -- 发生日期
       CASE
         WHEN T0.C_STOCK_TYPE IN ('8', 'I') THEN
          CONCAT(T0.L_SERIAL_NO , '_' , T1.VC_FUND_CODE , '_' , T0.L_HG_DATE , '_' , T5.VC_REPORT_CODE , '.REPO.YHJ')
         WHEN T0.C_STOCK_TYPE = 'z' THEN
          CONCAT(T0.L_SERIAL_NO , '_' , T1.VC_FUND_CODE , '_' , T0.L_HG_DATE , '_' , T5.VC_REPORT_CODE , '.IB.YHJ')
		 WHEN T0.C_STOCK_TYPE = '+' THEN
		  CONCAT(T0.L_SERIAL_NO , '_' , T1.VC_FUND_CODE , '_' , T0.L_HG_DATE , '_' , T5.VC_REPORT_CODE , '.LB.YHJ')
       END AS SECU_ID, -- 证券编码
       CASE
         WHEN T0.C_STOCK_TYPE IN ('8', 'I') THEN
          'REPO'
         WHEN T0.C_STOCK_TYPE = 'z' THEN
          'IB'
		 WHEN T0.C_STOCK_TYPE = '+' THEN
          'LB'
       END AS TYP_CODE, -- 证券类别代码（大类），默认回购
       CASE
         WHEN T0.C_STOCK_TYPE = 'I' THEN
          'REPO102' --买断式回购
         WHEN T0.C_STOCK_TYPE = 'z' THEN
          'IB101' --信用拆借
         WHEN T0.C_STOCK_TYPE = '+' THEN
          'LB101' --债券借贷
         ELSE
          'REPO101' --质押式回购
       END AS TYP_CODEI, -- 证券类别代码（中类），
       CASE
         WHEN T5.C_STOCK_TYPE = 'I' THEN
          'REPO10201' --买断式回购
         WHEN T5.C_STOCK_TYPE = '8' THEN
          'REPO10101' --质押式回购
         WHEN T0.C_STOCK_TYPE = '+' THEN
          'LB10101' --债券借贷
         WHEN T0.C_STOCK_TYPE = 'z' THEN
          'IB10101' --信用拆借
       END AS TYP_CODEII, -- 证券类别代码（细分）
       'YHJ' AS EXCH_CODE, -- 交易市场代码，默认银行间
       '1' AS REPO_TRD_MODE, -- 回购交易方式，默认普通质押式回购
       T0.L_REDEEM_DAYS AS REPO_DAYS, -- 回购天数
       T0.L_SETTLE_SPEED AS CLR_SPED, --  清算速度
	   datediff(from_unixtime(unix_timestamp(cast(T0.L_REDEEM_LIQUIDATE as string),'yyyyMMdd'),'yyyy-MM-dd'),from_unixtime(unix_timestamp(cast(CASE WHEN T0.L_SETTLE_SPEED = 0 THEN T0.L_HG_DATE WHEN T0.L_SETTLE_SPEED = 1 THEN T4.aft_1_dt END as string),'yyyyMMdd'),'yyyy-MM-dd')) AS INTA_DAYS, --计息天数
       T0.L_HG_DATE AS TNV_DT, --  成交日期
       T0.L_REDEEM_LIQUIDATE AS BUYB_DT, -- 购回日期
	   CASE WHEN T0.L_SETTLE_SPEED = 0 THEN T0.L_HG_DATE WHEN T0.L_SETTLE_SPEED = 1 THEN T4.aft_1_dt END AS FIR_DELI_DT, -- 首期交割日期，银行间回购首期交割日比购回日是多一个银行间交易日，
       T0.L_REDEEM_LIQUIDATE AS END_DELI_DT, -- 到期交割日期，银行间回购到期交割日与购回日是同一天。原因：银行间清算速度是在首期考虑T+0,T+1交割,然后再算实际占款天数
       '3' AS FIR_DELI_MODE, -- 首期交割方式，默认券款兑付
       '3' AS END_DELI_MODE, -- 到期交割方式，默认券款兑付
       CASE
         WHEN T0.C_ENTRUST_DIRECTION IN ('5', '7', '15', '17') THEN
          'S'
         ELSE
          'L'
       END AS POS_ID, --  多空标志,正回购为空头，逆回购为多头
       T0.EN_DEAL_PRICE / 100 AS REPO_RAT, --  回购利率
       T0.EN_FIRST_PRICE AS FIR_NET_PRC, -- 首期净价价格
       T0.EN_MATURE_PRICE AS END_NET_PRC, -- 到期净价价格
       T0.EN_FIRST_BOND_INTEREST AS FIR_HD_INTR, -- 首期百元利息
       T0.EN_MATURE_BOND_INTEREST AS END_HD_INTR, -- 到期百元利息
       T0.L_DEAL_AMOUNT AS TNV_VOL, -- 成交数量
       T0.EN_DEAL_BALANCE AS TNV_VAL, -- 成交金额
       T0.EN_DEAL_BALANCE + T0.EN_REDEEM_INTEREST AS BUYB_VAL, --  购回金额
       T0.EN_REDEEM_INTEREST AS REPO_INTR, -- 回购利息
       T0.EN_FEE AS REPO_FEE, --  回购费用
       T0.C_CLEAR_TYPE AS CLR_TYP, -- 清算类型
       T0.L_RIVAL_ID AS TRD_CNTP_ID, -- 交易对手编码
       T0.VC_DEAL_NO AS TNV_NO, --成交编号
       CASE
        WHEN T0.C_STOCK_TYPE IN ('8', 'I') THEN
        CONCAT(T5.VC_REPORT_CODE , '.REPO.YHJ')
        WHEN T0.C_STOCK_TYPE = 'z' THEN
        CONCAT(T5.VC_REPORT_CODE , '.IB.YHJ')
       	WHEN T0.C_STOCK_TYPE = '+' THEN
       	CONCAT(T5.VC_REPORT_CODE , '.LB.YHJ')
       END AS VAR_SECU_ID, --品种代码
       ${end_date} as busi_date, --业务日期
       'pro_repo_tnv_info_3' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISHGREGISTER T0
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，筛选银行间债券和质押式回购
    ON T0.P_DT = T5.P_DT
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.C_MARKET_NO = '5'
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade T4
    ON T0.L_HG_DATE = T4.DT
   AND T5.C_MARKET_NO = T4.mkt_no
   and T4.SYS_RS_ID = 'O3'
 WHERE T0.C_MARKET_NO = '5'

UNION ALL
--未到期回购获取
SELECT T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.L_DATE AS OCCU_DT, -- 发生日期
       CASE
         WHEN T0.C_STOCK_TYPE IN ('8', 'I') THEN
          CONCAT(T0.L_SERIAL_NO , '_' , T1.VC_FUND_CODE , '_' , T0.L_HG_DATE , '_' , T5.VC_REPORT_CODE , '.REPO.YHJ')
         WHEN T0.C_STOCK_TYPE = 'z' THEN
          CONCAT(T0.L_SERIAL_NO , '_' , T1.VC_FUND_CODE , '_' , T0.L_HG_DATE , '_' , T5.VC_REPORT_CODE , '.IB.YHJ')
		 WHEN T0.C_STOCK_TYPE = '+' THEN
		  CONCAT(T0.L_SERIAL_NO , '_' , T1.VC_FUND_CODE , '_' , T0.L_HG_DATE , '_' , T5.VC_REPORT_CODE , '.LB.YHJ')
       END AS SECU_ID, -- 证券编码
       CASE
         WHEN T0.C_STOCK_TYPE IN ('8', 'I') THEN
          'REPO'
         WHEN T0.C_STOCK_TYPE = 'z' THEN
          'IB'
		 WHEN T0.C_STOCK_TYPE = '+' THEN
          'LB'
       END AS TYP_CODE, -- 证券类别代码（大类），默认回购
       CASE
         WHEN T0.C_STOCK_TYPE = 'I' THEN
          'REPO102' --买断式回购
         WHEN T0.C_STOCK_TYPE = 'z' THEN
          'IB101' --信用拆借
         WHEN T0.C_STOCK_TYPE = '+' THEN
          'LB101' --债券借贷
         ELSE
          'REPO101' --质押式回购
       END AS TYP_CODEI, -- 证券类别代码（中类），
       CASE
         WHEN T5.C_STOCK_TYPE = 'I' THEN
          'REPO10201' --买断式回购
         WHEN T5.C_STOCK_TYPE = '8' THEN
          'REPO10101' --质押式回购
         WHEN T0.C_STOCK_TYPE = '+' THEN
          'LB10101' --债券借贷
         WHEN T0.C_STOCK_TYPE = 'z' THEN
          'IB10101' --信用拆借
       END AS TYP_CODEII, -- 证券类别代码（细分）
       'YHJ' AS EXCH_CODE, -- 交易市场代码，默认银行间
       '1' AS REPO_TRD_MODE, -- 回购交易方式，默认普通质押式回购
       T0.L_REDEEM_DAYS AS REPO_DAYS, -- 回购天数
       T0.L_SETTLE_SPEED AS CLR_SPED, --  清算速度
	   datediff(from_unixtime(unix_timestamp(cast(T0.L_REDEEM_LIQUIDATE as string),'yyyyMMdd'),'yyyy-MM-dd'),from_unixtime(unix_timestamp(cast(CASE WHEN T0.L_SETTLE_SPEED = 0 THEN T0.L_HG_DATE WHEN T0.L_SETTLE_SPEED = 1 THEN T4.aft_1_dt END as string),'yyyyMMdd'),'yyyy-MM-dd')) AS INTA_DAYS, --计息天数
       T0.L_HG_DATE AS TNV_DT, --  成交日期
       T0.L_REDEEM_LIQUIDATE AS BUYB_DT, -- 购回日期
	   CASE WHEN T0.L_SETTLE_SPEED = 0 THEN T0.L_HG_DATE WHEN T0.L_SETTLE_SPEED = 1 THEN T4.aft_1_dt END AS FIR_DELI_DT, -- 首期交割日期，银行间回购首期交割日比购回日是多一个银行间交易日，
       T0.L_REDEEM_LIQUIDATE AS END_DELI_DT, -- 到期交割日期，银行间回购到期交割日与购回日是同一天。原因：银行间清算速度是在首期考虑T+0,T+1交割,然后再算实际占款天数
       '3' AS FIR_DELI_MODE, -- 首期交割方式，默认券款兑付
       '3' AS END_DELI_MODE, -- 到期交割方式，默认券款兑付
       CASE
         WHEN T0.C_ENTRUST_DIRECTION IN ('5', '7', '15', '17') THEN
          'S'
         ELSE
          'L'
       END AS POS_ID, --  多空标志,正回购为空头，逆回购为多头
       T0.EN_DEAL_PRICE / 100 AS REPO_RAT, --  回购利率
       T0.EN_FIRST_PRICE AS FIR_NET_PRC, -- 首期净价价格
       T0.EN_MATURE_PRICE AS END_NET_PRC, -- 到期净价价格
       T0.EN_FIRST_BOND_INTEREST AS FIR_HD_INTR, -- 首期百元利息
       T0.EN_MATURE_BOND_INTEREST AS END_HD_INTR, -- 到期百元利息
       T0.L_DEAL_AMOUNT AS TNV_VOL, -- 成交数量
       T0.EN_DEAL_BALANCE AS TNV_VAL, -- 成交金额
       T0.EN_DEAL_BALANCE + T0.EN_REDEEM_INTEREST AS BUYB_VAL, --  购回金额
       T0.EN_REDEEM_INTEREST AS REPO_INTR, -- 回购利息
       T0.EN_FEE AS REPO_FEE, --  回购费用
       T0.C_CLEAR_TYPE AS CLR_TYP, -- 清算类型
       T0.L_RIVAL_ID AS TRD_CNTP_ID, -- 交易对手编码
       T0.VC_DEAL_NO AS TNV_NO, --成交编号
       CASE
        WHEN T0.C_STOCK_TYPE IN ('8', 'I') THEN
        CONCAT(T5.VC_REPORT_CODE , '.REPO.YHJ')
        WHEN T0.C_STOCK_TYPE = 'z' THEN
        CONCAT(T5.VC_REPORT_CODE , '.IB.YHJ')
       	WHEN T0.C_STOCK_TYPE = '+' THEN
       	CONCAT(T5.VC_REPORT_CODE , '.LB.YHJ')
       END AS VAR_SECU_ID, --品种代码
       ${end_date} as busi_date, --业务日期
       'pro_repo_tnv_info_4' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THGREGISTER T0
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T3.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，筛选银行间债券和质押式回购
    ON T0.L_DATE = T5.L_DATE
   AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T5.C_MARKET_NO = '5'
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_trade T4
    ON T0.L_HG_DATE = T4.DT
   AND T5.C_MARKET_NO = T4.mkt_no
   and T4.SYS_RS_ID = 'O3'
 WHERE T0.C_MARKET_NO = '5'
