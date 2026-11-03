------------------------------------------------------------------------
  -- 模块名称：银行间成交抵押品
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

alter table ${dwd_db}.evt_inbk_tnv_mort drop if exists partition (p_dt>=${beg_date} , p_dt<=${end_date},sys_rs_id='O3') ;

insert into ${dwd_db}.evt_inbk_tnv_mort partition(p_dt,sys_rs_id)
--(occu_dt,agmt_tnv_no,tnv_onum,prd_code,ast_unit_code,pfl_code,secu_id,pldg_secu_id,pldg_src_secu_id,prov_side,pldg_rati,pldg_vol,pldg_vol,pldg_typ,inv_typ,busi_date,task_rs_id,dm_created_time,p_dt,sys_rs_id)
--已到期回购获取
SELECT T0.L_DATE AS OCCU_DT, --发生日期
			nvl(T0.VC_DEAL_NO,t10.VC_DEAL_NO) AS AGMT_TNV_NO, --合约成交编号
			concat(nvl(T8.L_DATE,t10.l_date) , '_HSO32' , '_' , nvl(T8.L_SERIAL_NO,t10.L_SERIAL_NO)) AS tnv_onum, --成交序号
             T1.VC_FUND_CODE AS PRD_CODE, --产品代码
			concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
             CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
             CASE
               WHEN T0.C_STOCK_TYPE IN ('8', 'I') THEN  --8质押式回购, I买断式回购
                CONCAT(T0.L_SERIAL_NO , '_' , T1.VC_FUND_CODE , '_' , T0.L_HG_DATE , '_' , T5.VC_REPORT_CODE , '.REPO.YHJ')
               WHEN T0.C_STOCK_TYPE = 'z' THEN  --z信用拆借
                CONCAT(T0.L_SERIAL_NO , '_' , T1.VC_FUND_CODE , '_' , T0.L_HG_DATE , '_' , T5.VC_REPORT_CODE , '.IB.YHJ')
               WHEN T0.C_STOCK_TYPE = '+' THEN  --+债券借贷
                CONCAT(T0.L_SERIAL_NO , '_' , T1.VC_FUND_CODE , '_' , T0.L_HG_DATE , '_' , T5.VC_REPORT_CODE , '.LB.YHJ')
             END AS SECU_ID, --证券编码
             CONCAT(T6.VC_REPORT_CODE , '.BOND.YHJ') AS PLDG_SECU_ID, --质押物证券编码
			T4.VC_INTER_CODE AS PLDG_SRC_SECU_ID, --质押物源证券ID
             cast(T4.C_MORTAGAGE_SIDE  as String) AS PROV_SIDE, --提供方,字典
              T4.en_ratio / 100  AS PLDG_RATI, --质押比例
			T4.L_MORTAGAGE_AMOUNT AS PLDG_VOL, --质押物数量
              cast(T4.L_MORTAGAGE_AMOUNT as double) * cast(T7.EN_CURR_FACE_PRICE as double) AS PLDG_PAR_GAMT, --抵押品券面总额
              cast(T4.C_BAIL_TYPE as String) AS PLDG_TYP, --质押物类别,字典
              CASE
               WHEN cast(T4.C_INVEST_TYPE  as String)= '1' THEN
                '2' --交易型金融资产
               WHEN cast(T4.C_INVEST_TYPE  as String) ='2' THEN
                '1' --持有到期资产
               ELSE
                cast(T4.C_INVEST_TYPE  as String)
             END AS INV_TYP, --投资类型
             DATE_FORMAT(DATE_ADD(current_date,-1),'yyyyMMdd') AS BUSI_DATE, --业务日期
             'evt_inbk_tnv_mort_1' AS TASK_RS_ID, --任务来源标识
             CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
             T0.L_DATE AS P_DT,
             'O3' AS SYS_RS_ID --系统来源标识
        FROM ${ods_db}.O3_THISHGREGISTER T0  --在途回购历史表
        LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
          ON T0.L_FUND_ID = T1.L_FUND_ID
        LEFT JOIN ${ods_db}.O3_THISHGMORTAGAGE T4  --在途回购质押债券历史表
          ON T0.L_SERIAL_NO = T4.L_SERIAL_NO
         AND T0.L_HG_DATE = T4.L_DATE
         AND T4.C_STATUS = '1' --有效
         AND T4.C_EFFECT_STATUS = '1' --正常
		 AND T4.p_dt BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-365),'yyyyMMdd') and ${end_date}
        LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
          ON T4.L_BASECOMBI_ID = T3.L_COMBI_ID
        LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
          ON T3.L_ASSET_ID = T2.L_ASSET_ID
        LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T5 --证券基本信息表，筛选银行间债券和质押式回购
          ON T0.L_DATE = T5.L_DATE
         AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
         AND T5.C_ASSET_CLASS IN ('5','6')
         AND T5.C_MARKET_NO = '5'
         AND T5.p_dt BETWEEN ${beg_date} AND ${end_date}
        LEFT JOIN ${ods_db}.O3_THISSTOCKINFO T6 --证券基本信息表，筛选银行间债券
          ON T0.L_DATE = T6.L_DATE
         AND T4.VC_INTER_CODE = T6.VC_INTER_CODE
         AND T6.C_ASSET_CLASS IN ('3')
         AND T6.C_MARKET_NO = '5'
         AND T6.p_dt BETWEEN ${beg_date} AND ${end_date}
        LEFT JOIN ${ods_db}.O3_THISBONDPROPERTY T7 --债券基本信息表，获取面值
          ON T0.L_DATE = T7.L_DATE
         AND T4.VC_INTER_CODE = T7.VC_INTER_CODE
         AND T7.C_MARKET_NO = '5'
         AND T7.p_dt BETWEEN ${beg_date} AND ${end_date}
		LEFT JOIN ${ods_db}.O3_THISBANKREALDEAL T8 --银行间成交回报表，获取执行确认、指令序号等交易过程数据(到期的回购找到首期那笔回购)
		  ON TRIM(T0.VC_DEAL_NO) = TRIM(T8.VC_DEAL_NO)
		 AND T0.L_HG_DATE = T8.L_DATE
		 AND T8.C_ENTRUST_DIRECTION IN ('5','6', '?', '-')  --5融资回购, 6融券回购, ?债券融入, -债券融出
         AND T8.p_dt BETWEEN ${beg_date} AND ${end_date}
        LEFT JOIN ${ods_db}.O3_THISPENDSETTLE T9  --当前表和历史表的合集
          ON T0.L_HG_DATE = T9.L_TRADE_DATE
         AND T0.L_SERIAL_NO = T9.L_SERIAL_NO
         AND T9.C_STATUS IN ('1')
         AND t9.p_dt BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-360),'yyyyMMdd') and ${end_date}
        LEFT JOIN ${ods_db}.O3_THISBANKREALDEAL T10
          ON T9.VC_ORIGINAL_NO = T10.L_SERIAL_NO
         AND T0.L_HG_DATE = T10.L_DATE
         AND T10.C_ENTRUST_DIRECTION IN ('5','6', '?', '-')
         AND T10.p_dt BETWEEN date_format(date_add(from_unixtime(unix_timestamp(cast(${beg_date} AS string),'yyyyMMdd'),'yyyy-MM-dd'),-360),'yyyyMMdd') and ${end_date}
       WHERE T0.C_MARKET_NO = '5'  --银行间
         AND T0.p_dt BETWEEN ${beg_date} AND ${end_date}

 UNION ALL
      --未到期回购获取
SELECT T0.L_DATE AS OCCU_DT, --发生日期
			T0.VC_DEAL_NO AS AGMT_TNV_NO, --合约成交编号
			concat(T8.L_DATE , '_HSO32' , '_' , T8.L_SERIAL_NO) AS tnv_onum, --成交序号
             T1.VC_FUND_CODE AS PRD_CODE, --产品代码
			concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
             CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
            CASE
              WHEN T0.C_STOCK_TYPE IN ('8', 'I') THEN
               CONCAT(T0.L_SERIAL_NO , '_' , T1.VC_FUND_CODE , '_' , T0.L_HG_DATE , '_' , T5.VC_REPORT_CODE , '.REPO.YHJ')
              WHEN T0.C_STOCK_TYPE = 'z' THEN
               CONCAT(T0.L_SERIAL_NO , '_' , T1.VC_FUND_CODE , '_' , T0.L_HG_DATE , '_' , T5.VC_REPORT_CODE , '.IB.YHJ')
             WHEN T0.C_STOCK_TYPE = '+' THEN
               CONCAT(T0.L_SERIAL_NO , '_' , T1.VC_FUND_CODE , '_' , T0.L_HG_DATE , '_' , T5.VC_REPORT_CODE , '.LB.YHJ')
            END AS SECU_ID, --证券编码
             CONCAT(T6.VC_REPORT_CODE , '.BOND.YHJ') AS PLDG_SECU_ID, --质押物证券编码
			T4.VC_INTER_CODE AS PLDG_SRC_SECU_ID, --质押物源证券ID
             cast(T4.C_MORTAGAGE_SIDE  as String) AS PROV_SIDE, --提供方,字典
              T4.en_ratio / 100  AS PLDG_RATI, --质押比例
			T4.L_MORTAGAGE_AMOUNT AS PLDG_VOL, --质押物数量
              cast(T4.L_MORTAGAGE_AMOUNT as double) * cast(T7.EN_CURR_FACE_PRICE as double) AS PLDG_PAR_GAMT, --抵押品券面总额
              cast(T4.C_BAIL_TYPE as String) AS PLDG_TYP, --质押物类别,字典
              CASE
               WHEN cast(T4.C_INVEST_TYPE  as String)= '1' THEN
                '2' --交易型金融资产
               WHEN cast(T4.C_INVEST_TYPE  as String) ='2' THEN
                '1' --持有到期资产
               ELSE
                cast(T4.C_INVEST_TYPE  as String)
             END AS INV_TYP, --投资类型
             DATE_FORMAT(DATE_ADD(current_date,-1),'yyyyMMdd') AS BUSI_DATE, --业务日期
             'evt_inbk_tnv_mort_2' AS TASK_RS_ID, --任务来源标识
             CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
             T0.L_DATE AS P_DT,
             'O3' AS SYS_RS_ID --系统来源标识
        FROM ${ods_db}.O3_THGREGISTER T0 --在途回购历史表
        LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
          ON T0.L_FUND_ID = T1.L_FUND_ID
        LEFT JOIN ${ods_db}.O3_THGMORTAGAGE T4 --在途回购质押债券历史表
          ON T0.L_SERIAL_NO = T4.L_SERIAL_NO
         AND T0.L_HG_DATE = T4.L_DATE
         AND T4.C_STATUS = '1' --有效
         AND T4.C_EFFECT_STATUS = '1' --正常
        LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
          ON T4.L_BASECOMBI_ID = T3.L_COMBI_ID
        LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
          ON T3.L_ASSET_ID = T2.L_ASSET_ID
        LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，筛选银行间债券和质押式回购
          ON T0.L_DATE = T5.L_DATE
         AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
         AND T5.C_ASSET_CLASS IN ('5')
         AND T5.C_MARKET_NO = '5'
        LEFT JOIN ${ods_db}.O3_TSTOCKINFO T6 --证券基本信息表，筛选银行间债券
          ON T0.L_DATE = T6.L_DATE
         AND T4.VC_INTER_CODE = T6.VC_INTER_CODE
         AND T6.C_ASSET_CLASS IN ('3')
         AND T6.C_MARKET_NO = '5'
        LEFT JOIN ${ods_db}.O3_TBONDPROPERTY T7 --债券基本信息表，获取面值
          ON T0.L_DATE = T7.L_DATE
         AND T4.VC_INTER_CODE = T7.VC_INTER_CODE
         AND T7.C_MARKET_NO = '5'
        LEFT JOIN ${ods_db}.O3_TBANKREALDEAL T8 --银行间成交回报表，获取执行确认、指令序号等交易过程数据(到期的回购找到首期那笔回购)
          ON TRIM(T0.VC_DEAL_NO) = TRIM(T8.VC_DEAL_NO)
         AND T0.L_HG_DATE = T8.L_DATE
         AND T8.C_ENTRUST_DIRECTION IN ('5','6', '?', '-')  --5融资回购, 6融券回购, ?债券融入, -债券融出
        LEFT JOIN ${ods_db}.O3_TPENDSETTLE T9  --当前表和历史表的合集
          ON T0.L_HG_DATE = T9.L_TRADE_DATE
         AND T0.L_SERIAL_NO = T9.L_SERIAL_NO
         AND T9.C_STATUS IN ('1')
        LEFT JOIN ${ods_db}.O3_TBANKREALDEAL T10
          ON T9.VC_ORIGINAL_NO = T10.L_SERIAL_NO
         AND T0.L_HG_DATE = T10.L_DATE
         AND T10.C_ENTRUST_DIRECTION IN ('5','6', '?', '-')
       WHERE T0.C_MARKET_NO = '5'
 ;