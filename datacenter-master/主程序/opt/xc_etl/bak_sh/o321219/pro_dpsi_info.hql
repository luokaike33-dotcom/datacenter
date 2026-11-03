------------------------------------------------------------------------
  -- 模块名称：存款合约表
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


alter table ${dwd_db}.pro_dpsi_info drop if exists partition (sys_rs_id='O3') ;

insert into ${dwd_db}.pro_dpsi_info partition(sys_rs_id)
(prd_code,ast_unit_code,pfl_code,occu_dt,secu_id,secu_code,dpsi_typ,dpsi_no,dpsi_name,oact_name,bnk_hbnk_id,bnk_hbnk_name,bnk_bach_id,tnv_dt,srte_dt,end_dt,next_intp_day,dpsi_maty,dpsi_val,curr_code,rat_typ,dpsi_rat,accr_intr,aggr_intr_incm,flot_rat,basi_rat_code,basi_spr,rat_topl,rat_lowl,inta_basi,rset_freq,rset_adj,inta_rule,intp_freq,fst_intp_mode,last_intp_mode,intp_role_desc,is_remt,ahed_coll_lim,ahed_coll_tims,ahed_coll_noty_days,has_draw_tims,ahed_coll_dt,ahed_coll_rat,dpsi_stat,dpsi_site,memo,busi_date,task_rs_id,dm_created_time,sys_rs_id)
SELECT T1.VC_FUND_CODE AS PRD_CODE, --产品代码,
             CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
             CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' ,T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
             T0.L_DATE AS OCCU_DT, --发生日期
             CONCAT(T0.L_CONFIRM_NO , LPAD(T0.L_DEPOSIT_CONFIRM_NO, 2, '0') , '-' , T1.VC_FUND_CODE , '-' , T0.L_DATE , '-' , (CASE
               WHEN T5.VC_REPORT_CODE = '890890' THEN
                'DPSI103'
               WHEN T5.VC_REPORT_CODE = '870870' THEN
                'DPSI102'
               WHEN T5.VC_REPORT_CODE = '860860' THEN
                'DPSI104'
               WHEN T5.VC_REPORT_CODE = '880880' THEN
                'DPSI106'
               WHEN T5.VC_REPORT_CODE = '850850' THEN
                'DPSI107'
             END) , '.DPSI.NONE') AS SECU_ID, --证券编码
             CONCAT(T0.L_CONFIRM_NO , LPAD(T0.L_DEPOSIT_CONFIRM_NO, 2, '0') , '-' ,T1.VC_FUND_CODE , '-' , T0.L_DATE , '-' , (CASE
               WHEN T5.VC_REPORT_CODE = '890890' THEN
                'DPSI103'
               WHEN T5.VC_REPORT_CODE = '870870' THEN
                'DPSI102'
               WHEN T5.VC_REPORT_CODE = '860860' THEN
                'DPSI104'
               WHEN T5.VC_REPORT_CODE = '880880' THEN
                'DPSI106'
               WHEN T5.VC_REPORT_CODE = '850850' THEN
                'DPSI107'
             END)) AS SECU_CODE, --证券代码
             CASE
               WHEN T5.VC_REPORT_CODE = '890890' THEN
                '2' --协议存款
               WHEN T5.VC_REPORT_CODE = '870870' THEN
                '1' --定期存款
               WHEN T5.VC_REPORT_CODE = '860860' THEN
                '3' --通知存款
               WHEN T5.VC_REPORT_CODE = '880880' THEN
                '6' --次级债务
               WHEN T5.VC_REPORT_CODE = '850850' THEN
                '4' --活期存款
             END AS DPSI_TYP, --存款类型
             T0.VC_INTER_NO AS DPSI_NO, --存款编号，只有协议存款和次级债务才有
             CASE
               WHEN T5.VC_REPORT_CODE IN ('890890') THEN
                NVL(T4.VC_CONTRACT_NAME,'协议存款')
               WHEN T5.VC_REPORT_CODE IN ('880880') THEN
                NVL(T4.VC_CONTRACT_NAME,'次级债务')
               WHEN T5.VC_REPORT_CODE IN ('870870') THEN
                '定期存款'
               WHEN T5.VC_REPORT_CODE IN ('860860') THEN
                '通知存款'
             END AS DPSI_NAME, --存款名称
             CASE
               WHEN T5.VC_REPORT_CODE IN ('890890', '880880') THEN
                T4.VC_ACCOUNT_NAME
               ELSE
                T0.VC_ACCOUNT_NAME
             END AS OACT_NAME, --开户名称
             CASE
               WHEN T5.VC_REPORT_CODE IN ('890890', '880880') THEN
                T4.L_BANK
               ELSE
                T0.L_BANK
             END AS BNK_HBNK_ID, --银行总行编码
             T6.VC_BANK_NAME AS BNK_HBNK_NAME, --银行总行名称
             T0.VC_MINOR_BANK AS BNK_BACH_ID, --银行分行名称
             T0.L_DATE AS TNV_DT, --成交日期
             T0.L_BEGIN_DATE AS SRTE_DT, --起息日期
             CASE WHEN NVL(T0.L_PAY_SETTLE_DATE, 0) = 0 THEN T0.L_END_DATE ELSE T0.L_PAY_SETTLE_DATE END AS END_DT, --到期日期
             NULL AS NEXT_INTP_DAY ,--下一个付息日
             CONCAT(cast(T0.L_LIMIT_TIME as int)  , (CASE
               WHEN T0.C_LIMIT_UNIT = '1' THEN
                'D'
               WHEN T0.C_LIMIT_UNIT = '2' THEN
                'W'
               WHEN T0.C_LIMIT_UNIT = '3' THEN
                'M'
               WHEN T0.C_LIMIT_UNIT = '5' THEN
                'Y'
             END)) AS DPSI_MATY, --存款期限
             T0.EN_BALANCE AS DPSI_VAL, --存款金额
             'CNY' AS CURR_CODE, --货币代码
             T0.C_RATE_TYPE AS RAT_TYP, --利率类型
             T0.EN_RATE AS DPSI_RAT, --存款利率
             T0.EN_RECEIVABLE_INTEREST + T0.EN_INTEREST AS ACCR_INTR, --应计利息(2022-05-10调整为当日计提利息+应收利息)
             T0.EN_TOTAL_INTEREST AS AGGR_INTR_INCM, --累计利息收入
             T4.EN_FLOAT_RATE / 100 AS FLOT_RAT, --浮动比例,协议存款和次级债务才有浮动
             T4.C_FLOAT_TYPE AS BASI_RAT_CODE, --基准利率代码,协议存款和次级债务才有浮动    需要与我们利率信息映射
             T4.EN_BASIC_RATE AS BASI_SPR, --基本利差，协议存款和次级债务才有浮动
             T4.EN_HIGHEST_RATE AS RAT_TOPL, --利率上限，协议存款和次级债务才有浮动
             T4.EN_LEAST_RATE AS RAT_LOWL, --利率下限，协议存款和次级债务才有浮动
             (CASE
               WHEN T4.C_DAY_TYPE = '1' THEN
                'A/365'
               WHEN T4.C_DAY_TYPE = '2' THEN
                'A/360'
               WHEN T4.C_DAY_TYPE = '3' THEN
                '30/360'
               WHEN T4.C_DAY_TYPE = '4' THEN
                'A/A'
               WHEN T4.C_DAY_TYPE = '7' THEN
                'A/365F'
               WHEN T4.C_DAY_TYPE = '8' THEN
                '30/360'
             END) AS INTA_BASI, --计息基准，协议存款和次级债务才有浮动
             NULL AS RSET_FREQ, --重置频率，协议存款和次级债务才有浮动  ??
             NULL AS RSET_ADJ, --重置调整，协议存款和次级债务才有浮动   ??
             CASE
               WHEN T5.VC_REPORT_CODE IN ('890890', '880880') THEN
                T4.C_CAL_TYPE
             END AS INTA_RULE, --计息规则，协议存款和次级债务才有浮动
             CASE
               WHEN T5.VC_REPORT_CODE IN ('890890', '880880') THEN
                (CASE
                  WHEN T4.L_PAY_INTEVAL = 0 THEN
                   0
                  WHEN T4.L_PAY_INTEVAL > 12 THEN
                   null
                  ELSE
                   floor(12 / T4.L_PAY_INTEVAL)
                END)
             END AS INTP_FREQ, --付息频率(N/年)，协议存款和次级债务才有浮动
             CASE
               WHEN T5.VC_REPORT_CODE IN ('890890', '880880') THEN
                T4.C_BEGIN_PAY_TYPE
             END AS FST_INTP_MODE, --首次付息方式，协议存款和次级债务才有浮动
             CASE
               WHEN T5.VC_REPORT_CODE IN ('890890', '880880') THEN
                T4.C_END_PAY_TYPE
             END AS LAST_INTP_MODE, --最后付息方式，协议存款和次级债务才有浮动
             T7.VC_ITEM_NAME AS INTP_ROLE_DESC, --付息规则描述
             NVL(T4.C_CANCEL_TYPE, 0) AS IS_REMT, --是否可解约，协议存款和次级债务才有浮动
             T0.C_ADVANCE_LIMIT_FLAG AS AHED_COLL_LIM, --提前支取限制
             NVL(T4.L_ADVANCE_COUNT, 0) AS AHED_COLL_TIMS, --提前支取次数
             T0.L_NOTIFY_DAYS AS AHED_COLL_NOTY_DAYS, --提前支取通知天数
             NVL(T4.L_ADVANCE_DEAL_COUNT, 0) AS HAS_DRAW_TIMS, --已取次数
             T0.L_ADVANCE_DATE AS AHED_COLL_DT, --可提前支取日期
             T0.EN_ADVANCE_RATE AS AHED_COLL_RAT, --提前支取利率
             T0.C_STATUS AS DPSI_STAT, --存款状态
             T0.VC_PLACE AS DPSI_SITE, --存款地方
             T0.VC_REMARK AS MEMO, --备注
             DATE_FORMAT(DATE_ADD(current_date,-1),'yyyyMMdd') AS BUSI_DATE, --业务日期
             'pro_dpsi_info_1' AS TASK_RS_ID, --任务来源标识
             CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
             'O3' AS SYS_RS_ID--系统来源标识
        FROM ${ods_db}.O3_TDEPOSITRECEIPT T0
        LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
          ON T0.L_FUND_ID = T1.L_FUND_ID
        LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
          ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
        LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
          ON T3.L_ASSET_ID = T2.L_ASSET_ID
        LEFT JOIN ${ods_db}.O3_TDEPOSITCONTRACT T4 --合同信息，只有协议存款和次级债务才有
          ON T0.VC_INTER_NO = T4.VC_INTER_NO
        LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，
          ON T0.VC_INTER_CODE = T5.VC_INTER_CODE
         AND T5.C_ASSET_CLASS IN ('8') --存款
        LEFT JOIN ${ods_db}.O3_tbankinfo T6
          ON CASE
               WHEN T5.VC_REPORT_CODE IN ('890890', '880880') THEN
                T4.L_BANK
               ELSE
                T0.L_BANK
             END = T6.L_BANK_NO
        LEFT JOIN ${ods_db}.O3_TDICTIONARY T7
          ON T0.C_INTEREST_PAY_TYPE = T7.C_LEMMA_ITEM
         AND T7.L_DICTIONARY_NO = '60031'
       WHERE T0.C_STATUS NOT IN ( '7');