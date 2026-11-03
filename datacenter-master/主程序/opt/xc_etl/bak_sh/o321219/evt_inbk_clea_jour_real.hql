------------------------------------------------------------------------
  -- 模块名称：银行间清算流水(盘后)
  --银行间现券买卖、质押式回购、买断式回购
  --银行间债回售到账
  --债券借贷首期
  --债券借贷到期
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

alter table ${dwd_db}.evt_inbk_clea_jour_his drop if exists partition (p_dt =${current_date},sys_rs_id='O3') ;

insert into ${dwd_db}.evt_inbk_clea_jour_his partition(p_dt,sys_rs_id)
(occu_dt,occu_time,busi_sys_id,trd_src_id,tnv_onum,odr_onum,excf_onum,odr_rela_onum,tnv_no,prd_code,ast_unit_code,pfl_code,sh_code,seat_code,secu_id,exch_code,secu_code,src_secu_id,src_secu_trd_id,pos_id,curr_code,busi_typ,inv_typ,busi_clas,entr_dir,clr_typ,clr_sped,tnv_vol,aft_par_vol,tnv_val,occu_val,aft_occu_val,rat,tnv_prc,net_prc,full_prc,end_yld,trd_chag,clea_serv_chag,oth_fee,deli_dt,trd_cntp_id,entr_dir_o3,entr_dir_name_o3,busi_clas_o3,oper_no,tnv_time,cntp_delr_id,cntp_delr_name,sett_fail_flag,stat,memo,buyt_repo_tnv_vol,bond_debc_tnv_vol,repo_use_clas,busi_date,task_rs_id,dm_created_time,p_dt,sys_rs_id)
--银行间现券买卖、质押式回购、买断式回购
SELECT T0.L_DATE AS OCCU_DT, --发生日期
       T4.L_TIME AS OCCU_TIME, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       CASE
         WHEN T4.L_DAILY_INSTRUCTION_NO IS NULL THEN
           concat('0|0|0' , T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO )
         ELSE
          concat('0|' , T4.L_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO , '_' ,
          T4.L_INDEX_DAILY_MODIFY , '_' , T4.L_STOCK_SERIAL_NO , '|0|0')
       END AS TRD_SRC_ID, --交易源ID
             CASE
               WHEN T0.L_BUSIN_NO IS NULL OR T4.L_SERIAL_NO IS NULL THEN
                CONCAT(T0.L_DATE ,'_HSO32' , '_L' , T0.L_SERIAL_NO) --当天缺失成交信息, 直接在流水增加成交流水, 该笔记录用L拼上流水序号作为成交序号
               WHEN T0.L_BUSIN_FLAG IN ('41203', '41204', '41211', '41212') THEN
                CONCAT(T0.L_DATE , '_HSO32' , '_' , T0.L_SERIAL_NO,'C') --有8条融资购回没有找到回购成交和合约信息
               ELSE
                CONCAT(T0.L_DATE , '_HSO32' , '_' , T4.L_SERIAL_NO)
             END AS TNV_ONUM, --成交序号
             CASE
               WHEN T0.L_BUSIN_NO IS NULL THEN
                NULL --当天缺失成交信息, 直接为空
               WHEN T4.L_DAILY_INSTRUCTION_NO IS NULL THEN
                NULL --缺少指令序号, 直接为空
               ELSE
                CONCAT(T4.L_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO , '_' ,
                T4.L_INDEX_DAILY_MODIFY , '_' , T4.L_STOCK_SERIAL_NO) --回购到期流水使用首次交易流水号
             END AS ODR_ONUM, --指令序号
             CASE
               WHEN T0.L_BUSIN_NO IS NULL THEN
                NULL --当天缺失成交信息, 直接为空
               WHEN T4.L_EXEC_CONFIRM_NO IS NULL THEN
                NULL --缺少执行确认序号时, 为空
               ELSE
                CONCAT(T4.L_DATE , '_HSO32' , '_' , T4.L_ENTRUST_SERIAL_NO)
             END AS EXCF_ONUM, --执行确认序号
       CASE
         WHEN T4.L_DAILY_INSTRUCTION_NO IS NULL THEN
           NULL
         ELSE
           concat(T4.L_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO , '_' , T4.L_BASECOMBI_ID , '_' , (CASE
         WHEN T5.C_ASSET_CLASS = '3' THEN
          concat(T5.VC_REPORT_CODE , '.BOND.YHJ') --债券
         WHEN T5.C_ASSET_CLASS = '5' AND T5.C_STOCK_TYPE IN ('8','I', 'z') THEN
		  concat(T5.VC_REPORT_CODE , '.REPO.YHJ') --回购
       END) , '_' , (CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T4.C_INVEST_TYPE
       END) , '_' , (CASE
         WHEN T0.L_BUSIN_FLAG IN ('40901') THEN
          '01000200' --银行间现券买入
         WHEN T0.L_BUSIN_FLAG IN ('40902') THEN
          '01000200' --银行间现券卖出
         WHEN T0.L_BUSIN_FLAG IN ('41201', '41202') AND T0.C_BUSIN_CLASS = '2' THEN
          '02000200' --银行间质押式回购首期
         WHEN T0.L_BUSIN_FLAG IN ('41203', '41204') AND T0.C_BUSIN_CLASS = '2' THEN
          '02000200' --银行间质押式回购到期
         WHEN T0.L_BUSIN_FLAG IN ('41201', '41202') AND T0.C_BUSIN_CLASS = 'O' THEN
          '03000200' --银行间买断式回购首期
         WHEN T0.L_BUSIN_FLAG IN ('41203', '41204') AND T0.C_BUSIN_CLASS = 'O' THEN
          '03000200' --银行间买断式回购到期
         WHEN T0.L_BUSIN_FLAG IN ('41209', '41210')  THEN
          '24000200' --信用拆借首期
         WHEN T0.L_BUSIN_FLAG IN ('41211', '41212')  THEN
          '24000200' --信用拆借到期
       END))
       END AS ODR_RELA_ONUM, --指令关联序号
             trim(CASE
                    WHEN T0.L_BUSIN_FLAG IN ('41203', '41204', '41211', '41212') THEN
                     T4.VC_DEAL_NO --回购到期流水使用首次成交编号
                    ELSE
                     T0.VC_DEAL_NO
                  END) AS tnv_no, --成交编号
             T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
             CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
             CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' ,
             T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
             T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
             T0.VC_SEAT_ID AS SEAT_CODE, --席位号
             CASE
               WHEN T5.C_ASSET_CLASS = '3' THEN
                CONCAT(T5.VC_REPORT_CODE , '.BOND.YHJ') --债券
               WHEN T5.C_ASSET_CLASS = '5' AND T5.C_STOCK_TYPE IN('I', '8') AND
                    T6.L_SERIAL_NO IS NOT NULL THEN
                CONCAT(T6.L_SERIAL_NO , '_' , T1.VC_FUND_CODE , '_' , T4.L_DATE , '_' ,
                T5.VC_REPORT_CODE , '.REPO.YHJ') --回购, 能找到回购合约信息
               WHEN T5.C_ASSET_CLASS = '5' AND T5.C_STOCK_TYPE IN('I', '8') AND
                    T6.L_SERIAL_NO IS NULL THEN
                CONCAT('L' , T0.L_SERIAL_NO , '_' , T1.VC_FUND_CODE , '_' ,
                T0.L_DATE , '_' , T5.VC_REPORT_CODE , '.REPO.YHJ') --回购, 找不到合约信息
               WHEN T5.C_ASSET_CLASS = '5' AND T5.C_STOCK_TYPE = 'z' AND
                    T6.L_SERIAL_NO IS NOT NULL THEN
                CONCAT(T6.L_SERIAL_NO , '_' , T1.VC_FUND_CODE , '_' , T4.L_DATE , '_' ,
                T5.VC_REPORT_CODE , '.IB.YHJ') --信用拆借
               WHEN T5.C_ASSET_CLASS = '5' AND T5.C_STOCK_TYPE = 'z' AND
                    T6.L_SERIAL_NO IS NULL THEN
                CONCAT('L' , T0.L_SERIAL_NO , '_' , T1.VC_FUND_CODE , '_' ,
                T0.L_DATE , '_' , T5.VC_REPORT_CODE , '.IB.YHJ') --信用拆借
             END AS SECU_ID, --证券编码
             CASE
               WHEN T5.C_MARKET_NO = '5' THEN
                'YHJ'
             END AS EXCH_CODE, --交易市场代码
             T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
             T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
             T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
             CASE
               WHEN T0.L_BUSIN_FLAG IN ('41202', '41203', '41210', '41212') THEN
                'S'
               ELSE
                'L'
             END AS POS_ID, --多空标志,融资回购为空头
             T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
             CASE
               WHEN T0.L_BUSIN_FLAG IN ('40901', '40902') THEN
                '010002' --银行间现券买卖
               WHEN T0.L_BUSIN_FLAG IN ('41201', '41202', '41203', '41204') AND
                    T0.C_BUSIN_CLASS = '2' THEN
                '020002' --银行间质押式回购
               WHEN T0.L_BUSIN_FLAG IN ('41201', '41202', '41203', '41204') AND
                    T0.C_BUSIN_CLASS = 'O' THEN
                '030002' --银行间买断式回购
               WHEN T0.L_BUSIN_FLAG IN ('41209', '41210', '41211', '41212') THEN
                '240002' --信用拆借
             END AS BUSI_TYP, --业务类别
             CASE
               WHEN T0.C_INVEST_TYPE IN ('1') THEN
                '2' --交易型金融资产
               WHEN T0.C_INVEST_TYPE IN ('2') THEN
                '1' --持有到期资产
               ELSE
                T0.C_INVEST_TYPE
             END AS INV_TYP, --投资类型
             CASE
               WHEN T0.L_BUSIN_FLAG IN ('40901') THEN
                '01000200' --银行间现券买入
               WHEN T0.L_BUSIN_FLAG IN ('40902') THEN
                '01000201' --银行间现券卖出
               WHEN T0.L_BUSIN_FLAG IN ('41201', '41202') AND
                    T0.C_BUSIN_CLASS = '2' THEN
                '02000200' --银行间质押式正回购首期
               WHEN T0.L_BUSIN_FLAG IN ('41203', '41204') AND
                    T0.C_BUSIN_CLASS = '2' THEN
                '02000201' --银行间质押式逆回购到期
               WHEN T0.L_BUSIN_FLAG IN ('41201', '41202') AND
                    T0.C_BUSIN_CLASS = 'O' THEN
                '03000200' --银行间买断式正回购首期
               WHEN T0.L_BUSIN_FLAG IN ('41203', '41204') AND
                    T0.C_BUSIN_CLASS = 'O' THEN
                '03000201' --银行间买断式逆回购到期
               WHEN T0.L_BUSIN_FLAG IN ('41209', '41210') THEN
                '24000200' --信用拆借首期
               WHEN T0.L_BUSIN_FLAG IN ('41211', '41212') THEN
                '24000201' --信用拆借到期
             END AS busi_clas, --业务类型
             T4.C_ENTRUST_DIRECTION AS ENTR_DIR, --委托方向
             '1' AS CLR_TYP, --清算类型, 银行间市场默认全额清算
             T0.L_SETTLE_SPEED AS CLR_SPED, --清算速度
             T0.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
             T0.L_POST_AMOUNT AS AFT_PAR_VOL, --发生后数量
             (CASE WHEN T0.L_BUSIN_FLAG IN ('41203', '41204') AND
                    T0.C_BUSIN_CLASS = 'O' THEN
                    NVL(T0.EN_DEAL_BALANCE,0) - NVL(T0.EN_SUBJECT_BALANCE,0)
                    ELSE
                    T0.EN_DEAL_BALANCE
              END) AS TNV_VAL, --成交金额
             T0.EN_OCCUR_BALANCE AS OCCU_VAL, --发生金额
             T0.EN_POST_BALANCE AS AFT_OCCU_VAL, --发生后资金金额
             CASE
               WHEN T0.L_BUSIN_FLAG IN ('41201',
                                        '41202',
                                        '41203',
                                        '41204',
                                        '41209',
                                        '41210',
                                        '41211',
                                        '41212') THEN
                T0.EN_ENTRUST_PRICE / 100
               ELSE
                NULL
             END AS rat, --回购利率,对于回购利率中, O32的价格存放为利率
             CASE
               WHEN T0.L_BUSIN_FLAG IN ('41201',
                                        '41202',
                                        '41203',
                                        '41204',
                                        '41209',
                                        '41210',
                                        '41211',
                                        '41212') THEN
                100
               ELSE
                T0.EN_ENTRUST_PRICE
             END AS TNV_PRC, --成交价格, 其中所有回购默认100
             T4.EN_FIRST_NET_PRICE AS NET_PRC, --净价价格
             T4.EN_FIRST_FULL_PRICE AS FULL_PRC, --全价价格
             T4.EN_SECOND_MATURE_YIELD AS END_YLD, --到期收益率
             NVL(T0.EN_FEE_JG, 0) + NVL(T0.EN_FARE5, 0) AS TRD_CHAG, --交易手续费+经手费
             NVL(T0.EN_FEE_JS2, 0) + NVL(T0.EN_FARE3, 0) AS CLEA_SERV_CHAG, --结算服务费+过户费
             NVL(T0.EN_FARE7, 0) AS OTH_FEE, --其他费用
             CASE
               WHEN T0.L_BUSIN_FLAG IN ('40901', '40902') AND
                    T0.L_SETTLE_SPEED > 0 THEN
                T8.aft_1_dt
               WHEN T0.L_BUSIN_FLAG IN ('40901', '40902') AND
                    T0.L_SETTLE_SPEED = 0 THEN
                T0.L_DATE
             END AS DELI_DT, --交割日期
             T4.L_trade_RIVAL_NO AS TRD_CNTP_ID, --交易对手编码
             T0.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, --委托方向_O32
             T7.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
             T0.C_BUSIN_CLASS AS BUSI_CLAS_O3, --业务分类_O32
             T4.L_OPERATOR_NO AS OPER_NO, --操作员
             T4.L_TIME AS TNV_TIME, --成交时间
             T4.VC_RIVALtradeR_ID AS CNTP_DELR_ID, --对手方交易员
             T4.VC_RIVALtradeR_NAME AS CNTP_DELR_NAME, --对手方交易员名称
             T4.C_SETTLE_FLAG AS SETT_FAIL_FLAG, --交收失败标识
             CASE WHEN T4.C_CANCEL_FLAG = 2 THEN 1 WHEN T4.C_CANCEL_FLAG = 0 THEN 1 END AS STAT, --状态
             T4.VC_REMARK AS MEMO, --备注
             NULL AS BUYT_REPO_TNV_VOL, --买断式回购成交数量
             NULL AS BOND_DEBC_TNV_VOL, --债券借贷成交数量
             NULL AS REPO_USE_CLAS, --回购用途类别
            ${current_date} AS BUSI_DATE, --业务日期
             'evt_inbk_clea_jour_real_1' AS TASK_RS_ID, --任务来源标识
             CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
	     T0.L_DATE,             'O3' AS SYS_RS_ID --系统来源标识
        FROM ${ods_db}.O3_TCURRENTS T0 --清算流水主表
        LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表, 获取产品代码
          ON T0.L_FUND_ID = T1.L_FUND_ID
        LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表, 获取资产单元代码
          ON T0.L_ASSET_ID = T2.L_ASSET_ID
        LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表, 获取投资组合代码
          ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
        LEFT JOIN ${dwd_db}.pub_tradeday_offset_settle T9
          ON T9.mkt_no = '5'
         AND T0.L_DATE = t9.dt
         AND T9.SYS_RS_ID = 'O3'
        LEFT JOIN ${ods_db}.O3_TBANKREALDEAL T4 --获取执行确认、指令序号等交易过程数据(到期的回购找到首期那笔回购)
          ON T0.L_BUSIN_NO = T4.L_SERIAL_NO
         AND T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
         AND T0.VC_INTER_CODE = T4.VC_INTER_CODE
        LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表, 筛选银行间债券和质押式回购
          ON T0.VC_INTER_CODE = T5.VC_INTER_CODE
         AND T0.L_DATE = T5.L_DATE
         AND T5.C_MARKET_NO = '5' --5是银行间
         AND T5.C_ASSET_CLASS IN ('3', '5') --3是债券, 5是回购
        LEFT JOIN (SELECT L_SERIAL_NO,
                          L_ENTRUST_SERIAL_NO,
                          L_trade_DATE,
                          VC_ORIGINAL_NO,
                          C_ENTRUST_DIRECTION,
                          VC_DEAL_NO,
                          l_Relate_No
                     FROM ${ods_db}.O3_TPENDSETTLE
                    WHERE C_STATUS = '1'
                   ) T6 --获取在途回购表中的流水号
          ON T4.L_SERIAL_NO = T6.VC_ORIGINAL_NO
         AND T4.L_DATE=T6.L_trade_DATE
         --AND T4.L_ENTRUST_SERIAL_NO = T6.L_ENTRUST_SERIAL_NO
        LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T7
          ON T0.C_ENTRUST_DIRECTION = T7.C_ENTRUST_DIRECTION
         AND T5.C_MARKET_NO = T7.C_MARKET_NO
        LEFT JOIN ${dwd_db}.pub_tradeday_offset_settle T8
          ON T8.mkt_no = '5'
         AND T0.L_DATE = T8.dt
         AND T8.SYS_RS_ID = 'O3'
       WHERE T0.C_BUSIN_CLASS IN ('O', '2', 'Z') --筛选银行间流水、买断式回购
         AND T0.L_BUSIN_FLAG IN ('40901',
                                 '40902',
                                 '41201',
                                 '41202',
                                 '41203',
                                 '41204',
                                 '41209',
                                 '41210',
                                 '41211',
                                 '41212') --现券买卖、质押式回购、买断式回购
         AND T0.C_STATUS = '1'
         AND T0.L_DATE = ${current_date}
		 AND ((CASE
         WHEN T0.L_BUSIN_FLAG IN ('41203', '41204', '41211', '41212') THEN
          T4.L_SECOND_SETTLE_DATE
         ELSE
          T4.L_DATE
       END) BETWEEN t9.pre_1_dt AND T0.L_DATE or T4.L_SERIAL_NO is null)
       AND T0.L_DATE= ${current_date}

UNION ALL
--银行间债回售到账
SELECT T0.L_DATE AS OCCU_DT, --发生日期
       T4.L_TIME AS OCCU_TIME, --发生时间
       '1' AS busi_sys_id, --业务系统编码
       CASE
         WHEN T4.L_DAILY_INSTRUCTION_NO IS NOT NULL AND T4.L_DAILY_INSTRUCTION_NO <> 0 THEN
        concat('0|' , T4.L_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO , '|0|0')
         WHEN T4.L_ENTRUST_SERIAL_NO IS NOT NULL AND T4.L_ENTRUST_SERIAL_NO <> 0 THEN
        concat('0|0|' , T4.L_DATE , '_HSO32' , '_' , T4.L_ENTRUST_SERIAL_NO , '|0')
         ELSE
        concat('0|0|0|' , T0.L_DATE , '_HSO32' , '_' , T4.L_SERIAL_NO)
       END AS TRD_SRC_ID, --交易源ID
       concat(T0.L_DATE , '_HSO32' , '_' , T4.L_SERIAL_NO) AS TNV_ONUM, --成交序号
       NULL AS ODR_ONUM, --指令序号
       concat(T7.L_DATE , '_HSO32' , '_O' , T7.L_SERIAL_NO) AS EXCF_ONUM, --执行确认序号

       CASE
         WHEN T4.L_DAILY_INSTRUCTION_NO IS NULL OR
              T4.L_DAILY_INSTRUCTION_NO = 0 THEN
          NULL
         ELSE
          concat(T4.L_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO , '_' , T0.L_BASECOMBI_ID , '_' ,
          T5.VC_REPORT_CODE , '.BOND.YHJ' , '_' ,
          (CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2'
				WHEN T0.C_INVEST_TYPE = '2' THEN '1'
				WHEN T0.C_INVEST_TYPE = 'a' THEN '15'
				WHEN T0.C_INVEST_TYPE = 'b' THEN '10'
				WHEN T0.C_INVEST_TYPE =	'c' THEN '12'
				ELSE T0.C_INVEST_TYPE END) , '_' ,
          '08000200')
       END AS ODR_RELA_ONUM, --指令关联序号
                     case when T0.VC_DEAL_NO = '0' then '' else T4.VC_DEAL_NO end  AS TNV_NO, --成交编号
                     T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
                     concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
                     concat(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
                     T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
                     T0.VC_SEAT_ID AS SEAT_CODE, --席位号
                     concat(T5.VC_REPORT_CODE , '.BOND.YHJ'), --证券编码
                     'YHJ' AS EXCH_CODE, --交易市场代码
                     T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
					T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
					T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
                     'L' AS POS_ID, --多空标志,融资回购为空头
                     T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
                     '080002' AS BUSI_TYP, --业务类别
                     case when T0.C_INVEST_TYPE = '1' then '2'
						  when T0.C_INVEST_TYPE = '2' then '1'
						  when T0.C_INVEST_TYPE = 'a' then '15'
						  when T0.C_INVEST_TYPE = 'b' then '10'
						  when T0.C_INVEST_TYPE = 'c' then '12'
					 else T0.C_INVEST_TYPE end AS INV_TYP, --投资类型
                     '08000203' AS BUSI_CLAS, --业务类型
					'11' AS ENTR_DIR, --委托方向
                     '1' AS CLR_TYP, --清算类型, 银行间市场默认全额清算
                     0 AS CLR_SPED, --清算速度
					T0.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
					T0.L_POST_AMOUNT AS AFT_PAR_VOL, --发生后数量
                    T0.EN_SUBJECT_BALANCE AS TNV_VAL, --成交金额
                     T0.EN_SUBJECT_BALANCE AS OCCU_VAL, --发生金额
                     T0.EN_POST_BALANCE AS AFT_OCCU_VAL, --发生后资金金额
                     NULL AS rat, --回购利率,对于回购利率中, O32的价格存放为利率
                     T0.EN_ENTRUST_PRICE AS TNV_PRC, --成交价格
                     T4.EN_FIRST_NET_PRICE AS NET_PRC, --净价价格
                     T4.EN_FIRST_FULL_PRICE AS FULL_PRC, --全价价格
                     T4.EN_SECOND_MATURE_YIELD AS END_YLD, --到期收益率
                     NVL(T0.EN_FEE_JG, 0) AS TRD_CHAG, --交易手续费
                     NVL(T0.EN_FEE_JS2, 0) AS CLEA_SERV_CHAG, --结算服务费
                     NVL(T0.EN_FARE7, 0) AS OTH_FEE, --其他费用
                     T6.L_SETTLE_DATE AS DELI_DT, --交割日期
                     T4.L_TRADE_RIVAL_NO AS TRD_CNTP_ID, --交易对手编码
                     T0.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, --委托方向_O32
                     T8.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
                     T0.C_BUSIN_CLASS AS BUSI_CLAS_O3, --业务分类_O32
                     T4.L_OPERATOR_NO AS OPER_NO, --操作员
                     T4.L_TIME AS TNV_TIME, --成交时间
                     T4.VC_RIVALTRADER_ID AS CNTP_DELR_ID, --对手方交易员代码
                     T4.VC_RIVALTRADER_NAME AS CNTP_DELR_NAME, --对手方交易员名称
                     T4.C_SETTLE_FLAG AS SETT_FAIL_FLAG, --交收失败标识
                     CASE WHEN T4.C_CANCEL_FLAG = 2 THEN 1 WHEN T4.C_CANCEL_FLAG = 0 THEN 1 END AS STAT, --状态
                     T4.VC_REMARK AS MEMO, --备注
					NULL AS BUYT_REPO_TNV_VOL, --买断式回购成交数量
					NULL AS BOND_DEBC_TNV_VOL, --债券借贷成交数量
					NULL AS REPO_USE_CLAS, --回购用途类别
                    ${current_date} AS BUSI_DATE, --业务日期
                     'evt_inbk_clea_jour_real_2' AS TASK_RS_ID, --任务来源标识
                     CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
	     T0.L_DATE,             'O3' AS SYS_RS_ID --系统来源标识
        FROM ${ods_db}.O3_TCURRENTS T0 --清算流水主表
        LEFT JOIN (SELECT L_SERIAL_NO,
                          L_ENTRUST_SERIAL_NO,
                          L_trade_DATE,
                          VC_ORIGINAL_NO,
                          C_ENTRUST_DIRECTION,
                          VC_DEAL_NO,
                          l_Relate_No,L_BASECOMBI_ID,VC_INTER_CODE,L_BUSIN_FLAG,L_SETTLE_DATE
                     FROM ${ods_db}.O3_TPENDSETTLE
                    WHERE C_STATUS = '1'
                   ) T6 --获取在途回购表中的流水号
			ON T6.L_TRADE_DATE = T0.L_DATE
		AND T6.L_BASECOMBI_ID = T0.L_BASECOMBI_ID
		AND T6.VC_INTER_CODE = T0.VC_INTER_CODE
		AND T6.L_BUSIN_FLAG = T0.L_BUSIN_FLAG
		AND T6.VC_ORIGINAL_NO = T0.L_BUSIN_NO
        LEFT JOIN ${ods_db}.O3_TBANKREALDEAL T4 --银行间成交表
		ON T6.VC_ORIGINAL_NO = T4.L_SERIAL_NO
		AND T6.L_TRADE_DATE = T4.L_DATE
        LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表, 获取产品代码
        ON T0.L_FUND_ID = T1.L_FUND_ID
        LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表, 获取资产单元代码
        ON T0.L_ASSET_ID = T2.L_ASSET_ID
        LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表, 获取投资组合代码
        ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
        LEFT JOIN ${ods_db}.O3_TBANKCONFIRM T7 --银行间执行确认表
        ON T4.L_EXEC_CONFIRM_NO = T7.L_SERIAL_NO
		AND T4.L_BASECOMBI_ID = T7.L_BASECOMBI_ID
		AND T4.VC_INTER_CODE = T7.VC_INTER_CODE
        LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表
        ON T0.L_DATE = T5.L_DATE
        AND T0.VC_INTER_CODE = T5.VC_INTER_CODE
        AND T5.C_ASSET_CLASS IN ('3', '5') --3是债券, 5是回购
        AND T5.C_MARKET_NO = '5' --5是银行间
        LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T8
        ON T0.C_ENTRUST_DIRECTION = T8.C_ENTRUST_DIRECTION
        AND T5.C_MARKET_NO = T8.C_MARKET_NO
        WHERE T0.C_BUSIN_CLASS = '2'--筛选银行间流水、买断式回购
        AND T0.L_BUSIN_FLAG IN ('72571')
        AND T0.C_STATUS IN ('1') --1-正常, 2-回溯, 3-被回溯；2和3为冲减不需080
        AND T0.EN_SUBJECT_BALANCE > 0
        AND T0.L_DATE = ${current_date}

UNION ALL
--债券借贷首期
SELECT T0.L_DATE AS OCCU_DT, --发生日期
       T4.L_TIME AS OCCU_TIME, --发生时间
       '1' AS BUSI_SYS_ID, --业务系统编码
       CASE
         WHEN T4.L_DAILY_INSTRUCTION_NO IS NULL THEN
           CONCAT('0|0|0|' , T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO)
         ELSE
          CONCAT('0|' , T4.L_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO , '_' , T4.L_INDEX_DAILY_MODIFY , '_' , T4.L_STOCK_SERIAL_NO , '|0|0')
       END AS TRD_SRC_ID, --交易源ID
       CASE
         WHEN T0.L_BUSIN_NO IS NULL THEN
          CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) --当天缺失成交信息，直接在流水增加成交流水，该笔记录用L拼上流水序号作为成交序号
         WHEN T4.L_SERIAL_NO IS NULL THEN
          CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO)
         ELSE
          CONCAT(T0.L_DATE , '_HSO32' , '_' , T4.L_SERIAL_NO)
       END AS TNV_ONUM, --成交序号
       NULL AS ODR_ONUM, --指令序号
       CASE
         WHEN T0.L_BUSIN_NO IS NULL THEN
          NULL --当天缺失成交信息，直接为空
         WHEN T4.L_EXEC_CONFIRM_NO IS NULL THEN
          NULL --缺少执行确认序号时，为空
         ELSE
          CONCAT(T4.L_DATE , '_HSO32' , '_' , T4.L_ENTRUST_SERIAL_NO)
       END AS EXCF_ONUM, --执行确认序号
       CASE
         WHEN T4.L_DAILY_INSTRUCTION_NO IS NULL THEN
           NULL
         ELSE
           CONCAT(T4.L_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO , '_' , T4.L_BASECOMBI_ID , '_' , T5.VC_REPORT_CODE , '.LB.YHJ' , '_' ,
		 (CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T4.C_INVEST_TYPE
       END) , '_' , '33000200')
       END AS ODR_RELA_ONUM, --指令关联序号
       CASE WHEN T0.VC_DEAL_NO = '0' THEN '' ELSE T4.VC_DEAL_NO END AS tnv_no, --成交编号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CASE
         WHEN T6.L_SERIAL_NO IS NOT NULL THEN
          CONCAT(T6.L_SERIAL_NO , '_' , T1.VC_FUND_CODE , '_' , T4.L_DATE , '_' , T5.VC_REPORT_CODE , '.LB.YHJ') --债券借贷
         WHEN T6.L_SERIAL_NO IS NULL THEN
          CONCAT('L' , T0.L_SERIAL_NO , '_' , T1.VC_FUND_CODE , '_' , T0.L_DATE , '_' , T5.VC_REPORT_CODE , '.LB.YHJ')
       END AS SECU_ID, --证券编码
       'YHJ' AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       CASE
         WHEN T0.C_ENTRUST_DIRECTION IN ('?') THEN
          '1'
         WHEN T0.C_ENTRUST_DIRECTION IN ('-') THEN
          '2'
       END AS POS_ID, --多空标志,融资回购为空头
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       '330002' AS BUSI_TYP, --业务类别
       CASE
         WHEN T0.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T0.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       '33000200' AS busi_clas, --业务类型
       CASE
         WHEN T0.C_ENTRUST_DIRECTION IN ('?') THEN
          '151'
         WHEN T0.C_ENTRUST_DIRECTION IN ('-') THEN
          '152'
         WHEN T0.C_ENTRUST_DIRECTION IN ('*') THEN
          '170'
         WHEN T0.C_ENTRUST_DIRECTION IN ('+') THEN
          '171'
       END AS ENTR_DIR, --委托方向
       '1' AS CLR_TYP, --清算类型，银行间市场默认全额清算
       T0.L_SETTLE_SPEED AS CLR_SPED, --清算速度
       T0.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
       T0.L_POST_AMOUNT AS AFT_PAR_VOL, --成交数量
       0 AS TNV_VAL, --成交金额
       0 AS OCCU_VAL, --发生金额
       T0.EN_POST_BALANCE AS AFT_OCCU_VAL, --发生后资金金额
       T0.EN_ENTRUST_PRICE / 100 AS RAT, --回购利率,对于回购利率中，O32的价格存放为利率
       100 AS TNV_PRC, --成交价格，其中所有回购默认100
       T4.EN_FIRST_NET_PRICE AS NET_PRC, --净价价格
       T4.EN_FIRST_FULL_PRICE AS FULL_PRC, --全价价格
       T4.EN_SECOND_MATURE_YIELD AS END_YLD, --到期收益率
       NVL(T0.EN_FEE_JG, 0) + NVL(T0.EN_FARE5, 0) AS TRD_CHAG, --交易手续费+经手费
       NVL(T0.EN_FEE_JS2, 0) + NVL(T0.EN_FARE3, 0) AS CLEA_SERV_CHAG, --结算服务费+过户费
       NVL(T0.EN_FARE7, 0) AS OTH_FEE, --其他费用
       T6.L_SETTLE_DATE AS DELI_DT, --交割日期
       T4.L_TRADE_RIVAL_NO AS TRD_CNTP_ID, --交易对手编码
       T0.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, --委托方向_O32
       T8.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
       T0.C_BUSIN_CLASS AS BUSI_CLAS_O3, --业务分类_O32
       T4.L_OPERATOR_NO AS OPER_NO, --操作员
       T4.L_TIME AS TNV_TIME, --成交时间
       T4.VC_RIVALTRADER_ID AS CNTP_DELR_ID, --对手方交易员
       T4.VC_RIVALTRADER_NAME AS CNTP_DELR_NAME, --对手方交易员名称
       T4.C_SETTLE_FLAG AS SETT_FAIL_FLAG, --交收失败标识
       CASE WHEN T4.C_CANCEL_FLAG = 1 THEN 2 WHEN T4.C_CANCEL_FLAG = 0 THEN 1 END AS STAT, --状态
       T4.VC_REMARK AS MEMO, --备注
       NULL AS BUYT_REPO_TNV_VOL, --买断式回购成交数量
       NULL AS BOND_DEBC_TNV_VOL, --债券借贷成交数量
       NULL AS REPO_USE_CLAS, --回购用途类别
       ${current_date} AS BUSI_DATE, --业务日期
       'evt_inbk_clea_jour_real_3' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
	   T0.L_DATE,
	   'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TCURRENTS T0 --清算流水主表
  LEFT JOIN ${ods_db}.O3_TPENDSETTLE T6 --代交割表，当前表和历史表合集
    ON T0.L_BUSIN_NO = T6.VC_ORIGINAL_NO
   AND T0.L_DATE = T6.L_TRADE_DATE
   AND T6.C_ENTRUST_DIRECTION IN ('?', '-')
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T0.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TBANKREALDEAL T4 --获取执行确认、指令序号等交易过程数据(到期的回购找到首期那笔回购)
    ON T0.L_BUSIN_NO = T4.L_SERIAL_NO
   AND T0.L_DATE = T4.L_DATE
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，筛选银行间债券和质押式回购
    ON T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T0.L_DATE = T5.L_DATE
   AND T5.C_MARKET_NO = '5' --5是银行间
  LEFT JOIN ${ods_db}.O3_THGREGISTER T7  --回购表，当前表和历史表合集
    ON T6.L_SERIAL_NO = T7.L_SERIAL_NO
   AND T0.L_DATE = T7.L_HG_DATE
   AND T7.C_ENTRUST_DIRECTION IN ('?','-')
  LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T8
    ON T0.C_ENTRUST_DIRECTION = T8.C_ENTRUST_DIRECTION
   AND T5.C_MARKET_NO = T8.C_MARKET_NO
 WHERE T0.C_BUSIN_CLASS IN ('2')
   AND T0.L_BUSIN_FLAG IN ('73003', '73005') --债券借贷融入、融出
   AND T0.C_STATUS = '1'
   AND T0.L_DATE = ${current_date}

UNION ALL
--债券借贷到期
SELECT T0.L_DATE AS OCCU_DT, --发生日期
       T4.L_TIME AS OCCU_TIME, --发生时间
       '1' AS BUSI_SYS_ID, --业务系统编码
       CASE
         WHEN T4.L_DAILY_INSTRUCTION_NO IS NULL THEN
           CONCAT('0|0|0|' , T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO)
         ELSE
           CONCAT('0|' , T4.L_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO , '_' , T4.L_INDEX_DAILY_MODIFY , '_' , T4.L_STOCK_SERIAL_NO , '|0|0' )
       END AS TRD_SRC_ID, --交易源ID
       CASE
         WHEN T0.L_BUSIN_NO IS NULL THEN
          CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) --当天缺失成交信息，直接在流水增加成交流水，该笔记录用L拼上流水序号作为成交序号
         WHEN T4.L_SERIAL_NO IS NULL THEN
          CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO)
         ELSE
          CONCAT(T0.L_DATE , '_HSO32' , '_' , T4.L_SERIAL_NO)
       END AS TNV_ONUM, --成交序号
       NULL AS ODR_ONUM, --指令序号
       CASE
         WHEN T0.L_BUSIN_NO IS NULL THEN
          NULL --当天缺失成交信息，直接为空
         WHEN T4.L_EXEC_CONFIRM_NO IS NULL THEN
          NULL --缺少执行确认序号时，为空
         ELSE
          CONCAT(T4.L_DATE , '_HSO32' , '_' , T4.L_ENTRUST_SERIAL_NO)
       END AS EXCF_ONUM, --执行确认序号
       CASE
         WHEN T4.L_DAILY_INSTRUCTION_NO IS NULL THEN
           NULL
         ELSE
           CONCAT(T4.L_DATE , '_HSO32' , '_' , T4.L_DAILY_INSTRUCTION_NO , '_' , T4.L_BASECOMBI_ID , '_' , T5.VC_REPORT_CODE , '.LB.YHJ' , '_' ,
		   (CASE
         WHEN T4.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T4.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T4.C_INVEST_TYPE
       END) , '_' , '33000200')
       END AS ODR_RELA_ONUM, --指令关联序号
       CASE WHEN T0.VC_DEAL_NO = '0' THEN '' ELSE T4.VC_DEAL_NO END AS tnv_no, --成交编号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO , '_' , T3.VC_COMBI_NO) AS PFL_CODE, --投组代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, -- 股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       CASE
         WHEN T7.L_SERIAL_NO IS NOT NULL THEN
          CONCAT(T7.L_SERIAL_NO , '_' , T1.VC_FUND_CODE , '_' , T4.L_DATE , '_' , T5.VC_REPORT_CODE , '.LB.YHJ') --债券借贷
         WHEN T7.L_SERIAL_NO IS NULL THEN
          CONCAT('L' , T0.L_SERIAL_NO , '_' , T1.VC_FUND_CODE , '_' , T0.L_DATE , '_' , T5.VC_REPORT_CODE , '.LB.YHJ')
       END AS SECU_ID, --证券编码
       'YHJ' AS EXCH_CODE, --交易市场代码
       T5.VC_REPORT_CODE AS SECU_CODE, --证券代码
       T5.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
       T5.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
       CASE
         WHEN T0.C_ENTRUST_DIRECTION IN ('*') THEN
          '1'
         WHEN T0.C_ENTRUST_DIRECTION IN ('+') THEN
          '2'
       END AS POS_ID, --多空标志,融资回购为空头
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       '330002' AS BUSI_TYP, --业务类别
       CASE
         WHEN T0.C_INVEST_TYPE IN ('1') THEN
          '2' --交易型金融资产
         WHEN T0.C_INVEST_TYPE IN ('2') THEN
          '1' --持有到期资产
         ELSE
          T0.C_INVEST_TYPE
       END AS INV_TYP, --投资类型
       '33000201' AS busi_clas, --业务类型
       CASE
         WHEN T0.C_ENTRUST_DIRECTION IN ('*') THEN
          '170'
         WHEN T0.C_ENTRUST_DIRECTION IN ('+') THEN
          '171'
       END AS ENTR_DIR, --委托方向
       '1' AS CLR_TYP, --清算类型，银行间市场默认全额清算
       T0.L_SETTLE_SPEED AS CLR_SPED, --清算速度
       T0.L_BUSIN_AMOUNT AS TNV_VOL, --成交数量
       T0.L_POST_AMOUNT AS AFT_PAR_VOL, --成交数量
       T0.EN_DEAL_BALANCE AS TNV_VAL, --成交金额
       T0.EN_OCCUR_BALANCE AS OCCU_VAL, --发生金额
       T0.EN_POST_BALANCE AS AFT_OCCU_VAL, --发生后资金金额
       T0.EN_ENTRUST_PRICE / 100 AS RAT, --回购利率,对于回购利率中，O32的价格存放为利率
       100 AS TNV_PRC, --成交价格，其中所有回购默认100
       T4.EN_FIRST_NET_PRICE AS NET_PRC, --净价价格
       T4.EN_FIRST_FULL_PRICE AS FULL_PRC, --全价价格
       T4.EN_SECOND_MATURE_YIELD AS END_YLD, --到期收益率
       NVL(T0.EN_FEE_JG, 0) + NVL(T0.EN_FARE5, 0) AS TRD_CHAG, --交易手续费+经手费
       NVL(T0.EN_FEE_JS2, 0) + NVL(T0.EN_FARE3, 0) AS CLEA_SERV_CHAG, --结算服务费+过户费
       NVL(T0.EN_FARE7, 0) AS OTH_FEE, --其他费用
       T6.L_SETTLE_DATE AS DELI_DT, --交割日期
       T4.L_TRADE_RIVAL_NO AS TRD_CNTP_ID, --交易对手编码
       T0.C_ENTRUST_DIRECTION AS ENTR_DIR_O3, --委托方向_O32
       T8.VC_ENTRUSTDIR_NAME AS ENTR_DIR_NAME_O3, --委托方向名称_O32
       T0.C_BUSIN_CLASS AS BUSI_CLAS_O3, --业务分类_O32
       T4.L_OPERATOR_NO AS OPER_NO, --操作员
       T4.L_TIME AS TNV_TIME, --成交时间
       T4.VC_RIVALTRADER_ID AS CNTP_DELR_ID, --对手方交易员
       T4.VC_RIVALTRADER_NAME AS CNTP_DELR_NAME, --对手方交易员名称
       T4.C_SETTLE_FLAG AS SETT_FAIL_FLAG, --交收失败标识
       CASE WHEN T4.C_CANCEL_FLAG = 1 THEN 2 WHEN T4.C_CANCEL_FLAG = 0 THEN 1 END AS STAT, --状态
       T4.VC_REMARK AS MEMO, --备注
       NULL AS BUYT_REPO_TNV_VOL, --买断式回购成交数量
       NULL AS BOND_DEBC_TNV_VOL, --债券借贷成交数量
       NULL AS REPO_USE_CLAS, --回购用途类别
       ${current_date} AS BUSI_DATE, --业务日期
       'evt_inbk_clea_jour_real_4' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
	   T0.L_DATE,
	   'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_TCURRENTS T0 --清算流水主表
  LEFT JOIN ${ods_db}.O3_TPENDSETTLE T6 --代交割表，当前表和历史表合集
    ON T0.L_BUSIN_NO = T6.VC_ORIGINAL_NO
   AND T0.L_DATE = T6.L_TRADE_DATE
   AND T6.C_ENTRUST_DIRECTION IN ('*', '+')
  LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
    ON T0.L_FUND_ID = T1.L_FUND_ID
  LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
    ON T0.L_ASSET_ID = T2.L_ASSET_ID
  LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
    ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
  LEFT JOIN ${ods_db}.O3_TSTOCKINFO T5 --证券基本信息表，筛选银行间债券和质押式回购
    ON T0.VC_INTER_CODE = T5.VC_INTER_CODE
   AND T0.L_DATE = T5.L_DATE
   AND T5.C_MARKET_NO = '5' --5是银行间
  LEFT JOIN (
  select t4.*
  from ${ods_db}.O3_TCURRENTS t0
  inner join ${ods_db}.O3_TBANKREALDEAL T4 --获取执行确认、指令序号等交易过程数据(到期的回购找到首期那笔回购)
    ON T0.L_BUSIN_NO = T4.L_SERIAL_NO
   AND T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
   AND T0.VC_INTER_CODE = T4.VC_INTER_CODE
   AND T4.C_ENTRUST_DIRECTION IN ('?', '-')
  LEFT JOIN ${dwd_db}.pub_tradeday_offset_settle W1
    ON W1.mkt_no = '5'
   AND T0.L_DATE = W1.dt
   AND W1.SYS_RS_ID = 'O3'
 WHERE T0.C_BUSIN_CLASS IN ('2')
   AND T0.L_BUSIN_FLAG IN ('73007', '73009') --债券借贷融入到期、融出到期
   AND T0.C_STATUS = '1'
   AND CASE WHEN T0.L_SETTLE_SPEED = 0 THEN T0.L_DATE ELSE w1.aft_1_dt end = T4.L_SECOND_SETTLE_DATE
   ) T4
    ON T0.L_BUSIN_NO = T4.L_SERIAL_NO
   AND T0.L_BASECOMBI_ID = T4.L_BASECOMBI_ID
   AND T0.VC_INTER_CODE = T4.VC_INTER_CODE
   AND T4.C_ENTRUST_DIRECTION IN ('?', '-')
  LEFT JOIN ${ods_db}.O3_THGREGISTER T7  --回购表，当前表和历史表合集
    ON TRIM(T0.VC_DEAL_NO) = TRIM(T7.VC_DEAL_NO)
   AND T4.L_DATE = T7.L_HG_DATE
   AND T0.L_BASECOMBI_ID = T7.L_BASECOMBI_ID
   AND T0.VC_INTER_CODE = T7.VC_INTER_CODE
   AND T7.C_MARKET_NO = '5'
  LEFT JOIN ${ods_db}.O3_TENTRUSTDIRECTION T8
    ON T0.C_ENTRUST_DIRECTION = T8.C_ENTRUST_DIRECTION
   AND T5.C_MARKET_NO = T8.C_MARKET_NO
 WHERE T0.C_BUSIN_CLASS IN ('2')
   AND T0.L_BUSIN_FLAG IN ('73007', '73009') --债券借贷融入到期、融出到期
   AND T0.C_STATUS = '1'
   AND T0.L_DATE = ${current_date}