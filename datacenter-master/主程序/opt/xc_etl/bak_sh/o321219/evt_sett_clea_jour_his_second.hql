------------------------------------------------------------------------
--模块名称：结算类清算
--全部库外兑付/场景1：只有债券库外
--全部库内未占用/场景2：债券库内未占用
--部分库内未占用部分库外场景库外部分/场景3 债券兑付(库外+库内未占用) 库外部分
--部分库内未占用部分库外场景库内未占用部分/场景3 债券兑付(库外+库内未占用) 库内未占用部分
--库内出库日数据/场景7 隔天库内占用(本金兑付日/本金利息兑付日) 对场景④⑤⑥的补充
--全部库内部分占用部分未占用库内未占用部分/场景④⑤⑥ 需要兜底（需要兜底的字段：成交数量，成交金额，发生金额，利息金额）
--场景4-1 债券库内未占用+库内占用：库内未占用
--全部库内部分占用部分未占用库内占用部分/场景4-2 债券库内未占用+库内占用：库内占用
--部分库内全部占用部分库外库外部分/场景5-1 债券库外+库内占用：库外部分
--部分库内全部占用部分库外库内占用部分/场景5-2 债券库外+库内占用：库内占用
--部分库外部分库内未占用部分库内占用库外部分/场景6-1 债券 库外+库内未占用+库内占用：库外部分
--部分库外部分库内未占用部分库内占用库内未占用部分/场景6-2 债券 库外+库内未占用+库内占用：库内未占用部分
--部分库外部分库内未占用部分库内占用库内占用部分/场景6-3 债券 库外+库内未占用+库内占用：库内占用部分
--期货保证金增加/减少
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

--交易日历生成
WITH VDAY_SHIFT AS
       (SELECT t1.C_MARKET_NO,
               T0.L_DATE,
               LAG(T0.L_DATE) OVER(PARTITION BY t1.C_MARKET_NO ORDER BY T0.L_DATE) SETT_DT,
               LAG(T0.L_DATE, 2) OVER(PARTITION BY t1.C_MARKET_NO ORDER BY T0.L_DATE) S_L_DATE
          FROM ${ods_db}.O3_TMARKETtradeDAY T0
          JOIN ${ods_db}.O3_Tmarketinfo t1
            ON T0.VC_tradeDAY_TYPE = t1.VC_tradeDAY_TYPE
         WHERE t1.C_MARKET_NO IN ('1', '2', '5')
           AND T0.C_trade_FLAG = '1'
           AND T0.L_DATE BETWEEN
	   DATE_FORMAT(DATE_ADD(from_unixtime(unix_timestamp(cast(${beg_date} as string),'yyyyMMdd'),'yyyy-MM-dd'),-30),'yyyyMMdd')
	 AND ${end_date}),
         mid_table as (
         select t8.l_unit_id,
                        t4.l_date,
                        t8.vc_stockholder_id,
                        t8.vc_bind_seat,
                        t8.vc_inter_code,
                        t8.l_fund_id,
                        t8.l_asset_id,
                        t8.l_basecombi_id,
                        t8.c_invest_type,
                        t8.l_current_amount,
                        (nvl(t8.en_current_impawn_amount, 0) +
                        nvl(t8.en_impawn_amount, 0) - nvl(t8.en_return_amount, 0)) as l_curr_impawn_amount
                   from ${ods_db}.O3_Thisunitstock t8
                   join VDAY_SHIFT t4
                     on t8.c_market_no = t4.c_market_no
                    and t8.l_date = t4.SETT_DT
                    and t4.C_MARKET_NO IN ('1', '2')
                    and t8.p_dt BETWEEN
         	   DATE_FORMAT(DATE_ADD(from_unixtime(unix_timestamp(cast(${beg_date} as string),'yyyyMMdd'),'yyyy-MM-dd'),-30),'yyyyMMdd')
         	 AND ${end_date}
                  where t8.C_MARKET_NO IN ('1', '2')
         ),
--有兑付的持仓
      vhisunitstock as
       (select *
          from mid_table A
         where CONCAT(a.l_date,a.vc_stockholder_id,a.vc_bind_seat,a.vc_inter_code) in
                        (select CONCAT(t0.l_date,t0.vc_stockholder_id,t0.vc_seat_id,t0.vc_inter_code) from ${ods_db}.O3_thisliquidatedetail t0
                         where t0.p_dt BETWEEN ${beg_date} AND ${end_date}
                                           AND (T0.L_BUSIN_FLAG IN ('41701', '73397') OR
                                               (T0.L_BUSIN_FLAG = '72915' AND T0.L_DEAL_AMOUNT <> 0 AND
                                               T0.EN_OCCUR_BALANCE / T0.L_DEAL_AMOUNT > 100))
     )),
      TMP_EVT_SETT_JOUR as
       (SELECT t0.l_date,
               t0.vc_stockholder_id,
               t0.vc_bind_seat,
               t0.vc_inter_code,
               t0.l_serial_no,
               t1.vc_fund_code,
               t2.vc_asset_no,
               t3.vc_combi_no,
               t8.l_fund_id,
               t8.l_asset_id,
               t8.l_basecombi_id,
               t8.l_unit_id,
               t8.c_invest_type,
               t5.vc_report_code,
               t5.c_market_no,
               t5.vc_currency_no,
               t0.en_occur_balance,
               cast(t0.l_deal_amount as decimal(20,4)) as l_redem_amount,
               cast(nvl(t7.l_current_amount, 0) as decimal(20,4)) as l_hold_amount,
               cast(nvl(t7.l_curr_impawn_amount, 0) as decimal(20,4)) as l_impawn_amount,
               cast(nvl(t6.en_curr_face_price, 0) as decimal(20,4)) as en_curr_face_price,
               cast(nvl(t8.l_current_amount, 0) as decimal(20,4)) as l_current_amount,
               cast(nvl(t8.l_curr_impawn_amount, 0) as decimal(20,4)) as l_curr_impawn_amount,
               cast(nvl(t7.l_current_amount, 0) - nvl(t7.l_curr_impawn_amount, 0) as decimal(20,4)) as l_out_amount,
               cast(nvl(t7.l_curr_impawn_amount, 0) -
               (nvl(t7.l_current_amount, 0) - t0.l_deal_amount) as decimal(20,4)) as l_in_amount,
               (case
                 when t7.l_current_amount = 0 then
                  0
                 else
                  nvl((t0.en_occur_balance -
                      t0.l_deal_amount * t6.en_curr_face_price) /
                      t7.l_current_amount,
                      0)
               end) en_intr
          FROM (select t0.l_date,
                       t0.vc_stockholder_id,
                       t0.vc_seat_id as vc_bind_seat,
                       t0.vc_inter_code,
                       max(t0.l_serial_no) as l_serial_no,
                       sum(CASE
                             WHEN T0.L_BUSIN_FLAG = '72915' THEN
                              CASE
                                WHEN T0.EN_DEAL_PRICE = 0 THEN
                                 0
                                ELSE
                                 T0.EN_FEE_JG / T0.EN_DEAL_PRICE
                              END
                             ELSE
                              t0.l_deal_amount
                           END) AS l_deal_amount,
                       sum(t0.en_occur_balance) as en_occur_balance
                  from ${ods_db}.O3_thisliquidatedetail t0
                 where t0.p_dt  BETWEEN ${beg_date} AND ${end_date}
                   AND (T0.L_BUSIN_FLAG IN ('41701', '73397') OR
                       (T0.L_BUSIN_FLAG = '72915' AND T0.L_DEAL_AMOUNT <> 0 AND
                       T0.EN_OCCUR_BALANCE / T0.L_DEAL_AMOUNT > 100))
                 group by t0.l_date,
                          t0.vc_stockholder_id,
                          t0.vc_seat_id,
                          t0.vc_inter_code) T0
          left join (select t7.l_date,
                           t7.vc_stockholder_id,
                           t7.vc_bind_seat,
                           t7.vc_inter_code,
                           sum(t7.l_current_amount) as l_current_amount,
                           sum(t7.l_curr_impawn_amount) as l_curr_impawn_amount
                      from vhisunitstock t7
                     where l_date BETWEEN ${beg_date} AND ${end_date}
                     group by t7.l_date,
                              t7.vc_stockholder_id,
                              t7.vc_bind_seat,
                              t7.vc_inter_code) t7
            on t0.l_date = t7.l_date
           and t0.vc_stockholder_id = t7.vc_stockholder_id
           and t0.vc_bind_seat = t7.vc_bind_seat
           and t0.vc_inter_code = t7.vc_inter_code
          left join (select t4.l_date,
                           t6.vc_inter_code,
                           t6.en_curr_face_price
                      from ${ods_db}.O3_thisbondproperty t6
                      join VDAY_SHIFT t4
                        on t6.c_market_no = t4.c_market_no
                       and t6.l_date = t4.S_L_DATE
                       and t4.C_MARKET_NO IN ('1', '2')
                     where t6.p_dt between
		     	   DATE_FORMAT(DATE_ADD(from_unixtime(unix_timestamp(cast(${beg_date} as string),'yyyyMMdd'),'yyyy-MM-dd'),-20),'yyyyMMdd')
                       and ${end_date}) t6
            on t0.l_date = t6.l_Date
           and t0.vc_inter_code = t6.vc_inter_code
          left join vhisunitstock t8
            on t0.l_date = t8.l_date
           and t0.vc_stockholder_id = t8.vc_stockholder_id
           and t0.vc_bind_seat = t8.vc_bind_seat
           and t0.vc_inter_code = t8.vc_inter_code
           and t8.l_date BETWEEN ${beg_date} AND ${end_date}
          left join ${ods_db}.O3_tfundinfo t1
            on t8.l_fund_id = t1.l_fund_id
          left join ${ods_db}.O3_tasset t2
            on t8.l_asset_id = t2.l_asset_id
          left join ${ods_db}.O3_tcombi t3
            on t8.l_basecombi_id = t3.l_combi_id
          left join ${ods_db}.O3_thisstockinfo t5
            on t8.l_date = t5.l_date
           and t8.vc_inter_code = t5.vc_inter_code
           and t5.p_dt BETWEEN ${beg_date} AND ${end_date}),
      TMP_EVT_SETT_JOUR_PRE as
       (SELECT t0.l_date,
               t0.vc_stockholder_id,
               t0.vc_bind_seat,
               t0.vc_inter_code,
               t0.l_serial_no,
               t8.l_fund_id,
               t8.l_asset_id,
               t8.l_basecombi_id,
               cast((case
                 when nvl(t7.l_current_amount, 0) -
                      nvl(t7.l_curr_impawn_amount, 0) = 0 and
                      t7.l_curr_impawn_amount <> 0 then
                  t8.l_curr_impawn_amount -
                  t8.l_curr_impawn_amount * t0.l_deal_amount /
                  t7.l_curr_impawn_amount
                 when nvl(t7.l_current_amount, 0) -
                      nvl(t7.l_curr_impawn_amount, 0) <> 0 and
                      nvl(t7.l_curr_impawn_amount, 0) -
                      (nvl(t7.l_current_amount, 0) - t0.l_deal_amount) = 0 then
                  t8.l_curr_impawn_amount
                 when nvl(t7.l_current_amount, 0) -
                      nvl(t7.l_curr_impawn_amount, 0) <> 0 and
                      nvl(t7.l_curr_impawn_amount, 0) -
                      (nvl(t7.l_current_amount, 0) - t0.l_deal_amount) <> 0 and
                      t7.l_curr_impawn_amount <> 0 then
                  t8.l_curr_impawn_amount -
                  t8.l_curr_impawn_amount *
                  (t0.l_deal_amount -
                  (t7.l_current_amount - t7.l_curr_impawn_amount)) /
                  t7.l_curr_impawn_amount
               end) as decimal(20,4)) as l_deal_amount
          FROM (select t0.l_date,
                       t0.vc_stockholder_id,
                       t0.vc_seat_id as vc_bind_seat,
                       t0.vc_inter_code,
                       max(t0.l_serial_no) as l_serial_no,
                       sum(CASE
                             WHEN T0.L_BUSIN_FLAG = '72915' THEN
                              CASE
                                WHEN T0.EN_DEAL_PRICE = 0 THEN
                                 0
                                ELSE
                                 T0.EN_FEE_JG / T0.EN_DEAL_PRICE
                              END
                             ELSE
                              t0.l_deal_amount
                           END) AS l_deal_amount,
                       sum(t0.en_occur_balance) as en_occur_balance
                  from ${ods_db}.O3_thisliquidatedetail t0
                 where t0.p_dt BETWEEN
	   DATE_FORMAT(DATE_ADD(from_unixtime(unix_timestamp(cast(${beg_date} as string),'yyyyMMdd'),'yyyy-MM-dd'),-30),'yyyyMMdd')
	 AND
             ${end_date}
                   AND (T0.L_BUSIN_FLAG IN ('41701', '73397') OR
                       (T0.L_BUSIN_FLAG = '72915' AND T0.L_DEAL_AMOUNT <> 0 AND
                       T0.EN_OCCUR_BALANCE / T0.L_DEAL_AMOUNT > 100))
                 group by t0.l_date,
                          t0.vc_stockholder_id,
                          t0.vc_seat_id,
                          t0.vc_inter_code) T0
          left join (select t7.l_date,
                           t7.vc_stockholder_id,
                           t7.vc_bind_seat,
                           t7.vc_inter_code,
                           sum(t7.l_current_amount) as l_current_amount,
                           sum(t7.l_curr_impawn_amount) as l_curr_impawn_amount
                      from vhisunitstock t7
                     group by t7.l_date,
                              t7.vc_stockholder_id,
                              t7.vc_bind_seat,
                              t7.vc_inter_code) t7
            on t0.l_date = t7.l_date
           and t0.vc_stockholder_id = t7.vc_stockholder_id
           and t0.vc_bind_seat = t7.vc_bind_seat
           and t0.vc_inter_code = t7.vc_inter_code
          left join vhisunitstock t8
            on t0.l_date = t8.l_date
           and t0.vc_stockholder_id = t8.vc_stockholder_id
           and t0.vc_bind_seat = t8.vc_bind_seat
           and t0.vc_inter_code = t8.vc_inter_code
            inner join TMP_EVT_SETT_JOUR tt0
                      on t8.l_fund_id=tt0.l_fund_id
                      and t8.l_basecombi_id=tt0.l_basecombi_id
                      and t0.vc_stockholder_id=tt0.vc_stockholder_id
                      and t0.vc_bind_seat=tt0.vc_bind_seat
                      and t0.vc_inter_code=tt0.vc_inter_code
                      and tt0.l_hold_amount = 0
         where t7.l_current_amount <> 0
           and t7.l_current_amount <> t7.l_curr_impawn_amount
          )

insert into ${dwd_db}.evt_sett_clea_jour_his partition(p_dt,sys_rs_id)
(occu_dt,occu_time,busi_sys_id,trd_src_id,tnv_onum,prd_code,ast_unit_code,pfl_code,sh_code,seat_code,secu_id,exch_code,secu_code,src_secu_id,src_secu_trd_id,pos_id,curr_code,busi_typ,inv_typ,busi_clas,tnv_vol,aft_par_vol,tnv_prc,tnv_val,occu_val,aft_occu_val,intr_val,deli_dt,intr_tran_dpsi,pnlt_val,cont_id,res_flag,busi_date,task_rs_id,dm_created_time,p_dt,sys_rs_id)
--全部库外兑付/场景1：只有债券库外
SELECT
			T0.L_DATE AS OCCU_DT, --发生日
			NULL AS OCCU_TIME, --发生时间
			'1' AS busi_sys_id, --业务系统编码
			CONCAT('0|0|' , T0.L_DATE , '_HSO32_' , T0.l_serial_no , 'U' , t0.l_unit_id , 'P' , t0.l_basecombi_id , 'L1' , '|0') AS TRD_SRC_ID, --交易源ID
            CONCAT(T0.L_DATE , '_HSO32_' , T0.l_serial_no , 'U' , t0.l_unit_id , 'P' , t0.l_basecombi_id , 'L1') AS TNV_ONUM, --成交序号 库外1 库内未占用2 库内占用3
            T0.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
            CONCAT(T0.VC_FUND_CODE , '_' , T0.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
            CONCAT(T0.VC_FUND_CODE , '_' , T0.VC_ASSET_NO , '_' , T0.VC_COMBI_NO) AS PFL_CODE, --投组代码
			T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
			T0.vc_bind_seat AS SEAT_CODE, --席位号
            CONCAT(T0.VC_REPORT_CODE , '.BOND.' , (CASE
              WHEN T0.C_MARKET_NO = '1' THEN
               'SH'
              WHEN T0.C_MARKET_NO = '2' THEN
               'SZ'
            END)) --债券
            AS SECU_ID, --证券编码
            CASE
              WHEN T0.C_MARKET_NO = '1' THEN
               'SH'
              WHEN T0.C_MARKET_NO = '2' THEN
               'SZ'
            END AS EXCH_CODE, --交易市场代码
            T0.VC_REPORT_CODE AS SECU_CODE, --证券代码
			T0.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
			T0.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
            'L' AS POS_ID, --多空标志,默认多头
            T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
            '140001' AS BUSI_TYP, --业务类别
            CASE
              WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
              WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
              ELSE
               T0.C_INVEST_TYPE
            END AS INV_TYP, --投资类型
            '14000100' AS BUSI_CLAS, --业务类型
            T0.l_current_amount AS TNV_VOL, --成交数量
            null AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
            t0.en_curr_face_price AS TNV_PRC, --成交价格
            (case
              when t0.l_redem_amount = 0 then
               0
              else
               T0.en_occur_balance * t0.l_current_amount /
               t0.l_redem_amount
            end) AS TNV_VAL, --成交金额
            (case
              when t0.l_redem_amount = 0 then
               0
              else
               T0.en_occur_balance * t0.l_current_amount /
               t0.l_redem_amount
            end) AS OCCU_VAL, --发生金额
            null AS AFT_OCCU_VAL, --发生后资金金额
            (case
              when t0.l_redem_amount = 0 then
               0
              else
               T0.en_occur_balance * t0.l_current_amount /
               t0.l_redem_amount
            end) - t0.l_current_amount * t0.en_curr_face_price AS INTR_VAL, --利息金额
            T0.L_DATE AS DELI_DT, --交割日期
			NULL AS INTR_TRAN_DPSI, --存款利息转存
			NULL AS PNLT_VAL, --存款罚息金额
			NULL AS CONT_ID, --合约编码
            NULL AS RES_FLAG, --限售标志
            ${end_date} AS BUSI_DATE, --业务日期
            'evt_sett_clea_jour_his_second_1' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
		    T0.L_DATE as p_dt,
            'O3' AS SYS_RS_ID --系统来源标识
       from TMP_EVT_SETT_JOUR t0
       WHERE T0.L_HOLD_AMOUNT <> 0 --股东层上一交易日持有数量A <> 0
           AND T0.L_REDEM_AMOUNT = T0.L_HOLD_AMOUNT --交易所兑付数量 = 上衣交易日持有数量
           AND T0.L_IMPAWN_AMOUNT = 0 --股东：上一交易日质押数量 = 0
           AND T0.L_CURRENT_AMOUNT <> 0 --投资组合：上个交易日当前持有数量 <> 0

     union all
--全部库内未占用/场景2：债券库内未占用
     SELECT T0.L_DATE AS OCCU_DT, --发生日期
			NULL AS OCCU_TIME, --发生时间
			'1' AS busi_sys_id, --业务系统编码
			concat('0|0|' , T0.L_DATE , '_HSO32_' , T0.l_serial_no , 'U' , t0.l_unit_id , 'P' , t0.l_basecombi_id , 'L2' , '|0') AS TRD_SRC_ID, --交易源ID
            CONCAT(T0.L_DATE , '_HSO32_' , T0.l_serial_no , 'U' , t0.l_unit_id , 'P' , t0.l_basecombi_id , 'L2') AS TNV_ONUM, --成交序号 库外1 库内未占用2 库内占用3
            T0.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
            CONCAT(T0.VC_FUND_CODE , '_' , T0.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
            CONCAT(T0.VC_FUND_CODE , '_' , T0.VC_ASSET_NO , '_' , T0.VC_COMBI_NO) AS PFL_CODE, --投组代码
			T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
			T0.vc_bind_seat AS SEAT_CODE, --席位号
            CONCAT(T0.VC_REPORT_CODE , '.BOND.' , (CASE
              WHEN T0.C_MARKET_NO = '1' THEN
               'SH'
              WHEN T0.C_MARKET_NO = '2' THEN
               'SZ'
            END)) --债券
            AS SECU_ID, --证券编码
            CASE
              WHEN T0.C_MARKET_NO = '1' THEN
               'SH'
              WHEN T0.C_MARKET_NO = '2' THEN
               'SZ'
            END AS EXCH_CODE, --交易市场代码
            T0.VC_REPORT_CODE AS SECU_CODE, --证券代码
			T0.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
			T0.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
            'L' AS POS_ID, --多空标志,默认多头
            T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
            '140001' AS BUSI_TYP, --业务类别
            CASE
              WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
              WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
              ELSE
               T0.C_INVEST_TYPE
            END AS INV_TYP, --投资类型
            '14000101' AS BUSI_CLAS,
            T0.l_current_amount AS TNV_VOL, --成交数量
            null AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
            t0.en_curr_face_price AS TNV_PRC, --成交价格
            (case
              when t0.l_redem_amount = 0 then
               0
              else
               T0.en_occur_balance * t0.l_current_amount /
               t0.l_redem_amount
            end) AS TNV_VAL, --成交金额
            (case
              when t0.l_redem_amount = 0 then
               0
              else
               T0.en_occur_balance * t0.l_current_amount /
               t0.l_redem_amount
            end) AS OCCU_VAL, --发生金额
            null AS AFT_OCCU_VAL, --发生后资金金额
            (case
              when t0.l_redem_amount = 0 then
               0
              else
               T0.en_occur_balance * t0.l_current_amount /
               t0.l_redem_amount
            end) - t0.l_current_amount * t0.en_curr_face_price AS INTR_VAL, --利息金额
            T0.L_DATE AS DELI_DT, --交割日期
			NULL AS INTR_TRAN_DPSI, --存款利息转存
			NULL AS PNLT_VAL, --存款罚息金额
			NULL AS CONT_ID, --合约编码
            NULL AS RES_FLAG, --限售标志
            ${end_date} AS BUSI_DATE, --业务日期
            'evt_sett_clea_jour_his_second_2' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
		    T0.L_DATE as p_dt,
            'O3' AS SYS_RS_ID --系统来源标识
       from TMP_EVT_SETT_JOUR t0
        WHERE T0.L_HOLD_AMOUNT <> 0 --股东上一交易日持有债券数量 <> 0
            AND T0.L_REDEM_AMOUNT = T0.L_HOLD_AMOUNT --全天兑付
            AND T0.L_IMPAWN_AMOUNT <> 0 --股东层质押数量 <> 0
            AND T0.L_OUT_AMOUNT = 0 --库外数量为0
            AND T0.L_CURRENT_AMOUNT <> 0 --投资组合：上个交易日当前持有数量 <> 0

     union all
--部分库内未占用部分库外场景库外部分/场景3 债券兑付(库外+库内未占用) 库外部分
     SELECT T0.L_DATE AS OCCU_DT, --发生日期
			NULL AS OCCU_TIME, --发生时间
			'1' AS busi_sys_id, --业务系统编码
			concat('0|0|' , T0.L_DATE , '_HSO32_' , T0.l_serial_no , 'U' , t0.l_unit_id , 'P' , t0.l_basecombi_id , 'L1' , '|0') AS TRD_SRC_ID, --交易源ID
            CONCAT(T0.L_DATE , '_HSO32_' , T0.l_serial_no , 'U' , t0.l_unit_id , 'P' , t0.l_basecombi_id , 'L1') AS TNV_ONUM, --成交序号 库外1 库内未占用2 库内占用3
            T0.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
            CONCAT(T0.VC_FUND_CODE , '_' , T0.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
            CONCAT(T0.VC_FUND_CODE , '_' , T0.VC_ASSET_NO , '_' , T0.VC_COMBI_NO) AS PFL_CODE, --投组代码
			T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
			T0.vc_bind_seat AS SEAT_CODE, --席位号
            CONCAT(T0.VC_REPORT_CODE , '.BOND.' , (CASE
              WHEN T0.C_MARKET_NO = '1' THEN
               'SH'
              WHEN T0.C_MARKET_NO = '2' THEN
               'SZ'
            END)) --债券
            AS SECU_ID, --证券编码
            CASE
              WHEN T0.C_MARKET_NO = '1' THEN
               'SH'
              WHEN T0.C_MARKET_NO = '2' THEN
               'SZ'
            END AS EXCH_CODE, --交易市场代码
            T0.VC_REPORT_CODE AS SECU_CODE, --证券代码
			T0.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
			T0.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
            'L' AS POS_ID, --多空标志,默认多头
            T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
            '140001' AS BUSI_TYP, --业务类别
            CASE
              WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
              WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
              ELSE
               T0.C_INVEST_TYPE
            END AS INV_TYP, --投资类型
            '14000100' AS BUSI_CLAS,
            (t0.l_current_amount - t0.l_curr_impawn_amount) AS TNV_VOL, --成交数量
            null AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
            t0.en_curr_face_price AS TNV_PRC, --成交价格
            (case
              when t0.l_redem_amount = 0 then
               0
              else
               (nvl((t0.en_occur_balance -
                    t0.l_redem_amount * t0.en_curr_face_price) /
                    t0.l_redem_amount,
                    0) + t0.en_curr_face_price) *
               (t0.l_current_amount - t0.l_curr_impawn_amount)
            end) AS TNV_VAL, --成交金额
            (case
              when t0.l_redem_amount = 0 then
               0
              else
               (nvl((t0.en_occur_balance -
                    t0.l_redem_amount * t0.en_curr_face_price) /
                    t0.l_redem_amount,
                    0) + t0.en_curr_face_price) *
               (t0.l_current_amount - t0.l_curr_impawn_amount)
            end) AS OCCU_VAL, --发生金额
            null AS AFT_OCCU_VAL, --发生后资金金额
            (case
              when t0.l_redem_amount = 0 then
               0
              else
               nvl((t0.en_occur_balance -
                   t0.l_redem_amount * t0.en_curr_face_price) /
                   t0.l_redem_amount,
                   0) * (t0.l_current_amount - t0.l_curr_impawn_amount)
            end) AS INTR_VAL, --利息金额
            T0.L_DATE AS DELI_DT, --交割日期
			NULL AS INTR_TRAN_DPSI, --存款利息转存
			NULL AS PNLT_VAL, --存款罚息金额
			NULL AS CONT_ID, --合约编码
            NULL AS RES_FLAG, --限售标志
            ${end_date} AS BUSI_DATE, --业务日期
            'evt_sett_clea_jour_his_second_3' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
		    T0.L_DATE as p_dt,
            'O3' AS SYS_RS_ID --系统来源标识
       from TMP_EVT_SETT_JOUR t0
        WHERE T0.L_HOLD_AMOUNT <> 0 --股东上一交易日持有债券数量 <> 0
          AND T0.L_REDEM_AMOUNT = T0.L_HOLD_AMOUNT --全天兑付
          AND T0.L_IMPAWN_AMOUNT <> 0 --股东层质押数量 <> 0
          AND T0.L_OUT_AMOUNT <> 0 --库外数量 <> 0
          AND T0.L_CURRENT_AMOUNT <> 0 --投资组合：上个交易日当前持有数量 <> 0

     union all
--部分库内未占用部分库外场景库内未占用部分/场景3 债券兑付(库外+库内未占用) 库内未占用部分
     SELECT T0.L_DATE AS OCCU_DT, --发生日期
			NULL AS OCCU_TIME, --发生时间
			'1' AS busi_sys_id, --业务系统编码
			concat('0|0|' , T0.L_DATE , '_HSO32_' , T0.l_serial_no , 'U' , t0.l_unit_id , 'P' , t0.l_basecombi_id , 'L2' , '|0') AS TRD_SRC_ID, --交易源ID
            CONCAT(T0.L_DATE , '_HSO32_' , T0.l_serial_no , 'U' , t0.l_unit_id , 'P' , t0.l_basecombi_id , 'L2') AS TNV_ONUM, --成交序号 库外1 库内未占用2 库内占用3
            T0.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
            CONCAT(T0.VC_FUND_CODE , '_' , T0.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
            CONCAT(T0.VC_FUND_CODE , '_' , T0.VC_ASSET_NO , '_' , T0.VC_COMBI_NO) AS PFL_CODE, --投组代码
			T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
			T0.vc_bind_seat AS SEAT_CODE, --席位号
            CONCAT(T0.VC_REPORT_CODE , '.BOND.' , (CASE
              WHEN T0.C_MARKET_NO = '1' THEN
               'SH'
              WHEN T0.C_MARKET_NO = '2' THEN
               'SZ'
            END)) --债券
            AS SECU_ID, --证券编码
            CASE
              WHEN T0.C_MARKET_NO = '1' THEN
               'SH'
              WHEN T0.C_MARKET_NO = '2' THEN
               'SZ'
            END AS EXCH_CODE, --交易市场代码
            T0.VC_REPORT_CODE AS SECU_CODE, --证券代码
			T0.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
			T0.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
            'L' AS POS_ID, --多空标志,默认多头
            T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
            '140001' AS BUSI_TYP, --业务类别
            CASE
              WHEN T0.C_INVEST_TYPE IN ('1') THEN
               '2' --交易型金融资产
              WHEN T0.C_INVEST_TYPE IN ('2') THEN
               '1' --持有到期资产
              ELSE
               T0.C_INVEST_TYPE
            END AS INV_TYP, --投资类型
            '14000101' AS BUSI_CLAS,
            t0.l_curr_impawn_amount AS TNV_VOL, --成交数量
            null AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
            t0.en_curr_face_price AS TNV_PRC, --成交价格
            (case
              when t0.l_redem_amount = 0 then
               0
              else
               (nvl((t0.en_occur_balance -
                    t0.l_redem_amount * t0.en_curr_face_price) /
                    t0.l_redem_amount,
                    0) + t0.en_curr_face_price) * t0.l_curr_impawn_amount
            end) AS TNV_VAL, --成交金额
            (case
              when t0.l_redem_amount = 0 then
               0
              else
               (nvl((t0.en_occur_balance -
                    t0.l_redem_amount * t0.en_curr_face_price) /
                    t0.l_redem_amount,
                    0) + t0.en_curr_face_price) * t0.l_curr_impawn_amount
            end) AS OCCU_VAL, --发生金额
            null AS AFT_OCCU_VAL, --发生后资金金额
            (case
              when t0.l_redem_amount = 0 then
               0
              else
               nvl((t0.en_occur_balance -
                   t0.l_redem_amount * t0.en_curr_face_price) /
                   t0.l_redem_amount,
                   0) * t0.l_curr_impawn_amount
            end) AS INTR_VAL, --利息金额
            T0.L_DATE AS DELI_DT, --交割日期
			NULL AS INTR_TRAN_DPSI, --存款利息转存
			NULL AS PNLT_VAL, --存款罚息金额
			NULL AS CONT_ID, --合约编码
            NULL AS RES_FLAG, --限售标志
            ${end_date} AS BUSI_DATE, --业务日期
            'evt_sett_clea_jour_his_second_4' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
		    T0.L_DATE as p_dt,
            'O3' AS SYS_RS_ID --系统来源标识
       from TMP_EVT_SETT_JOUR t0
WHERE T0.L_HOLD_AMOUNT <> 0 --股东上一交易日持有债券数量 <> 0
  AND T0.L_REDEM_AMOUNT = T0.L_HOLD_AMOUNT --全天兑付
  AND T0.L_IMPAWN_AMOUNT <> 0 --股东层质押数量 <> 0
  AND T0.L_OUT_AMOUNT <> 0 --库外数量 <> 0
  AND T0.L_CURRENT_AMOUNT <> 0 --投资组合：上个交易日当前持有数量 <> 0

 union all
--库内出库日数据/场景7 隔天库内占用(本金兑付日/本金利息兑付日) 对场景④⑤⑥的补充
 SELECT T0.L_DATE AS OCCU_DT, --发生日期
 		NULL AS OCCU_TIME, --发生时间
		'1' AS busi_sys_id, --业务系统编码
		concat('0|0|' , T0.L_DATE , '_HSO32_' , T0.l_serial_no , 'U' , t0.l_unit_id , 'P' , t0.l_basecombi_id , 'L3' , '|0') AS TRD_SRC_ID, --交易源ID
        CONCAT(T0.L_DATE , '_HSO32_' , T0.l_serial_no , 'U' , t0.l_unit_id , 'P' , t0.l_basecombi_id , 'L3') AS TNV_ONUM, --成交序号 库外1 库内未占用2 库内占用3
        T0.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
        CONCAT(T0.VC_FUND_CODE , '_' , T0.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
        CONCAT(T0.VC_FUND_CODE , '_' , T0.VC_ASSET_NO , '_' , T0.VC_COMBI_NO) AS PFL_CODE, --投组代码
		T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
		T0.vc_bind_seat AS SEAT_CODE, --席位号
        CONCAT(T0.VC_REPORT_CODE , '.BOND.' , (CASE
          WHEN T0.C_MARKET_NO = '1' THEN
           'SH'
          WHEN T0.C_MARKET_NO = '2' THEN
           'SZ'
        END)) --债券
        AS SECU_ID, --证券编码
        CASE
          WHEN T0.C_MARKET_NO = '1' THEN
           'SH'
          WHEN T0.C_MARKET_NO = '2' THEN
           'SZ'
        END AS EXCH_CODE, --交易市场代码
        T0.VC_REPORT_CODE AS SECU_CODE, --证券代码
		T0.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
		T0.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
        'L' AS POS_ID, --多空标志,默认多头
        T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
        '140001' AS BUSI_TYP, --业务类别
        CASE
          WHEN T0.C_INVEST_TYPE IN ('1') THEN
           '2' --交易型金融资产
          WHEN T0.C_INVEST_TYPE IN ('2') THEN
           '1' --持有到期资产
          ELSE
           T0.C_INVEST_TYPE
        END AS INV_TYP, --投资类型
        '14000103' AS BUSI_CLAS,
        tt0.l_deal_amount AS TNV_VOL, --成交数量
        null AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
        t0.en_curr_face_price AS TNV_PRC, --成交价格
        nvl((case
              when t0.l_redem_amount <> 0 and T0.C_MARKET_NO = '1' then
               (nvl((t0.en_occur_balance -
                    t0.l_redem_amount * t0.en_curr_face_price) /
                    t0.l_redem_amount,
                    0))
              else
               0
            end + t0.en_curr_face_price) * tt0.l_deal_amount,
            0) AS TNV_VAL, --成交金额
        nvl((case
              when t0.l_redem_amount <> 0 and T0.C_MARKET_NO = '1' then
               (nvl((t0.en_occur_balance -
                    t0.l_redem_amount * t0.en_curr_face_price) /
                    t0.l_redem_amount,
                    0))
              else
               0
            end + t0.en_curr_face_price) * tt0.l_deal_amount,
            0) AS OCCU_VAL, --发生金额
        null AS AFT_OCCU_VAL, --发生后资金金额
        (case
          when T0.C_MARKET_NO = '2' then
           0
          when t0.l_redem_amount <> 0 and T0.C_MARKET_NO = '1' then
           (nvl((t0.en_occur_balance -
                t0.l_redem_amount * t0.en_curr_face_price) /
                t0.l_redem_amount,
                0)) * tt0.l_deal_amount
          else
           0
        end) AS INTR_VAL, --利息金额
        T0.L_DATE AS DELI_DT, --交割日期
			NULL AS INTR_TRAN_DPSI, --存款利息转存
			NULL AS PNLT_VAL, --存款罚息金额
			NULL AS CONT_ID, --合约编码
            NULL AS RES_FLAG, --限售标志
            ${end_date} AS BUSI_DATE, --业务日期
            'evt_sett_clea_jour_his_second_5' AS TASK_RS_ID, --任务来源标识
            CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
		    T0.L_DATE as p_dt,
            'O3' AS SYS_RS_ID --系统来源标识
   from TMP_EVT_SETT_JOUR t0
   join TMP_EVT_SETT_JOUR_PRE tt0
     on t0.vc_stockholder_id = tt0.vc_stockholder_id
    and t0.vc_bind_seat = tt0.vc_bind_seat
    and t0.vc_inter_code = tt0.vc_inter_code
    and t0.l_fund_id = tt0.l_fund_id
    and t0.l_basecombi_id = tt0.l_basecombi_id
  where t0.l_hold_amount = 0

 union all
--全部库内部分占用部分未占用库内未占用部分/场景④⑤⑥ 需要兜底（需要兜底的字段：成交数量，成交金额，发生金额，利息金额）
select T0.OCCU_DT,
		NULL AS OCCU_TIME, --发生时间
		'1' AS busi_sys_id, --业务系统编码
		concat('0|0|' , TNV_ONUM , '|0') AS TRD_SRC_ID, --交易源ID
        T0.TNV_ONUM,
        T0.PRD_CODE,
        T0.AST_UNIT_CODE,
        T0.PFL_CODE,
		T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
		T0.vc_bind_seat as SEAT_CODE, --席位号
        T0.SECU_ID,
        T0.EXCH_CODE,
        T0.SECU_CODE,
		T0.VC_INTER_CODE AS SRC_SECU_ID, --源证券ID
		T0.VC_INTER_CODE AS SRC_SECU_TRD_ID, --源证券交易ID
        T0.POS_ID,
        T0.CURR_CODE,
        T0.BUSI_TYP,
        T0.INV_TYP,
        T0.BUSI_CLAS,
        T0.TNV_VOL,
        T0.AFT_PAR_VOL,
        T0.TNV_PRC,
        round(T0.TNV_VAl, 2) + nvl((case
                                     when row_number()
                                      over(partition by t0.occu_dt,
                                               t0.l_basecombi_id,
                                               t0.vc_inter_code order by t0.busi_clas,t0.pfl_code) = 1 then
                                      t1.en_occur_balance - sum(round(t0.tnv_val, 2))
                                      over(partition by t0.occu_dt,
                                           t0.l_basecombi_id,
                                           t0.vc_inter_code)
                                   end),
                                   0) as tnv_val,
        round(T0.OCCU_VAL, 2) + nvl((case
                                      when row_number()
                                       over(partition by t0.occu_dt,
                                                t0.l_basecombi_id,
                                                t0.vc_inter_code order by t0.busi_clas,t0.pfl_code) = 1 then
                                       t1.en_occur_balance - sum(round(t0.tnv_val, 2))
                                       over(partition by t0.occu_dt,
                                            t0.l_basecombi_id,
                                            t0.vc_inter_code)
                                    end),
                                    0) as OCCU_VAL,
        T0.AFT_OCCU_VAL,
        round(T0.INTR_VAL, 2) + nvl((case
                                      when row_number()
                                       over(partition by t0.occu_dt,
                                                t0.l_basecombi_id,
                                                t0.vc_inter_code order by t0.busi_clas,t0.pfl_code) = 1 then
                                       t1.en_occur_balance - sum(round(t0.tnv_val, 2))
                                       over(partition by t0.occu_dt,
                                            t0.l_basecombi_id,
                                            t0.vc_inter_code)
                                    end),
                                    0) as INTR_VAL,
        T0.DELI_DT,
		NULL AS INTR_TRAN_DPSI, --存款利息转存
		NULL AS PNLT_VAL, --存款罚息金额
		NULL AS CONT_ID, --合约编码
        NULL AS RES_FLAG, --限售标志
		${end_date} AS BUSI_DATE, --业务日期
		'evt_sett_clea_jour_his_second_6' AS TASK_RS_ID, --任务来源标识
		CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
		T0.OCCU_DT as p_dt,
		'O3' AS SYS_RS_ID --系统来源标识
            from (
--场景4-1 债券库内未占用+库内占用：库内未占用
            SELECT T0.L_DATE AS OCCU_DT, --发生日期
                         CONCAT(T0.L_DATE , '_HSO32_' , T0.l_serial_no , 'U' , t0.l_unit_id , 'P' ,
                         t0.l_basecombi_id , 'L2') AS TNV_ONUM, --成交序号 库外1 库内未占用2 库内占用3
                         T0.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
                         CONCAT(T0.VC_FUND_CODE , '_' , T0.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
                         CONCAT(T0.VC_FUND_CODE , '_' , T0.VC_ASSET_NO , '_' ,
                         T0.VC_COMBI_NO) AS PFL_CODE, --投组代码
                         CONCAT(T0.VC_REPORT_CODE , '.BOND.' , (CASE
                           WHEN T0.C_MARKET_NO = '1' THEN
                            'SH'
                           WHEN T0.C_MARKET_NO = '2' THEN
                            'SZ'
                         END)) --债券
                         AS SECU_ID, --证券编码
                         CASE
                           WHEN T0.C_MARKET_NO = '1' THEN
                            'SH'
                           WHEN T0.C_MARKET_NO = '2' THEN
                            'SZ'
                         END AS EXCH_CODE, --交易市场代码
                         T0.VC_REPORT_CODE AS SECU_CODE, --证券代码
                         'L' AS POS_ID, --多空标志,默认多头
                         T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
                         '140001' AS BUSI_TYP, --业务类别
                         CASE
                           WHEN T0.C_INVEST_TYPE IN ('1') THEN
                            '2' --交易型金融资产
                           WHEN T0.C_INVEST_TYPE IN ('2') THEN
                            '1' --持有到期资产
                           ELSE
                            T0.C_INVEST_TYPE
                         END AS INV_TYP, --投资类型
                         '14000101' AS BUSI_CLAS,
                         (case
                           when t0.l_impawn_amount = 0 then
                            0
                           else
                            t0.l_curr_impawn_amount * t0.l_redem_amount /
                            t0.l_impawn_amount
                         end) AS TNV_VOL, --成交数量
                         null AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
                         t0.en_curr_face_price AS TNV_PRC, --成交价格
                         (case
                           when (t0.l_impawn_amount = 0 or t0.l_hold_amount = 0) and
                                T0.C_MARKET_NO = '2' then
                            0
                           when (t0.l_impawn_amount = 0 or t0.l_hold_amount = 0) and
                                T0.C_MARKET_NO = '1' then
                            0
                           else
                            (nvl((t0.en_occur_balance -
                                 t0.l_redem_amount * t0.en_curr_face_price) /
                                 (case
                                   when T0.C_MARKET_NO = '1' then
                                    t0.l_redem_amount
                                   else
                                    t0.l_hold_amount
                                 end),
                                 0) + t0.en_curr_face_price) *
                            (t0.l_curr_impawn_amount * t0.l_redem_amount /
                            t0.l_impawn_amount)
                         end) AS TNV_VAL, --成交金额
                         (case
                           when (t0.l_impawn_amount = 0 or t0.l_hold_amount = 0) and
                                T0.C_MARKET_NO = '2' then
                            0
                           when (t0.l_impawn_amount = 0 or t0.l_hold_amount = 0) and
                                T0.C_MARKET_NO = '1' then
                            0
                           else
                            (nvl((t0.en_occur_balance -
                                 t0.l_redem_amount * t0.en_curr_face_price) /
                                 (case
                                   when T0.C_MARKET_NO = '1' then
                                    t0.l_redem_amount
                                   else
                                    t0.l_hold_amount
                                 end),
                                 0) + t0.en_curr_face_price) *
                            (t0.l_curr_impawn_amount * t0.l_redem_amount /
                            t0.l_impawn_amount)
                         end) AS OCCU_VAL, --发生金额
                         null AS AFT_OCCU_VAL, --发生后资金金额
                         (case
                           when (t0.l_impawn_amount = 0 or t0.l_hold_amount = 0) and
                                T0.C_MARKET_NO = '2' then
                            0
                           when (t0.l_impawn_amount = 0 or t0.l_hold_amount = 0) and
                                T0.C_MARKET_NO = '1' then
                            0
                           else
                            (nvl((t0.en_occur_balance -
                                 t0.l_redem_amount * t0.en_curr_face_price) /
                                 (case
                                   when T0.C_MARKET_NO = '1' then
                                    t0.l_redem_amount
                                   else
                                    t0.l_hold_amount
                                 end),
                                 0)) * (t0.l_curr_impawn_amount *
                            t0.l_redem_amount / t0.l_impawn_amount)
                         end) AS INTR_VAL, --利息金额
                         T0.L_DATE AS DELI_DT, --交割日期
                         t0.l_date AS BUSI_DATE, --业务日期
                         NULL AS UPD_TIME, --源数据更新时间
                         'O3' AS SYS_RS_ID, --系统来源标识
                         'evt_sett_clea_jour_his_second_7' AS TASK_RS_ID, --任务来源标识
                         'thisliquidatedetail5' AS DM_SRC_INFO, --来源信息
                         CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
                         'OUTLINE' AS DM_CREATED_BY, --数据中台创建者
                         CURRENT_TIMESTAMP AS DM_UPDATED_TIME, --数据中台更新时间
                         'OUTLINE' AS DM_UPDATED_BY,
                         t0.l_basecombi_id,
                         t0.vc_inter_code,
						 t0.vc_stockholder_id,
						 t0.vc_bind_seat
                    from TMP_EVT_SETT_JOUR t0
            WHERE T0.L_HOLD_AMOUNT <> 0 --a持有数量<>0
                AND T0.L_REDEM_AMOUNT <> T0.L_HOLD_AMOUNT--c <> a 即交易所兑付的数量<> c 股东持有的数量（当天未全兑付，存在库内）
                AND T0.L_OUT_AMOUNT = 0 --库外数量 = 0
                AND T0.L_CURRENT_AMOUNT <> 0 --组合的持有数量<>0

                  union all
--全部库内部分占用部分未占用库内占用部分/场景4-2 债券库内未占用+库内占用：库内占用
                  SELECT T0.L_DATE AS OCCU_DT, --发生日期
                         CONCAT(T0.L_DATE , '_HSO32_' , T0.l_serial_no , 'U' , t0.l_unit_id , 'P' ,
                         t0.l_basecombi_id , 'L3') AS TNV_ONUM, --成交序号 库外1 库内未占用2 库内占用3
                         T0.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
                         CONCAT(T0.VC_FUND_CODE , '_' , T0.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
                         CONCAT(T0.VC_FUND_CODE , '_' , T0.VC_ASSET_NO , '_' ,
                         T0.VC_COMBI_NO) AS PFL_CODE, --投组代码
                         CONCAT(T0.VC_REPORT_CODE , '.BOND.' , (CASE
                           WHEN T0.C_MARKET_NO = '1' THEN
                            'SH'
                           WHEN T0.C_MARKET_NO = '2' THEN
                            'SZ'
                         END)) --债券
                         AS SECU_ID, --证券编码
                         CASE
                           WHEN T0.C_MARKET_NO = '1' THEN
                            'SH'
                           WHEN T0.C_MARKET_NO = '2' THEN
                            'SZ'
                         END AS EXCH_CODE, --交易市场代码
                         T0.VC_REPORT_CODE AS SECU_CODE, --证券代码
                         'L' AS POS_ID, --多空标志,默认多头
                         T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
                         '140001' AS BUSI_TYP, --业务类别
                         CASE
                           WHEN T0.C_INVEST_TYPE IN ('1') THEN
                            '2' --交易型金融资产
                           WHEN T0.C_INVEST_TYPE IN ('2') THEN
                            '1' --持有到期资产
                           ELSE
                            T0.C_INVEST_TYPE
                         END AS INV_TYP, --投资类型
                         '14000102' AS BUSI_CLAS,
                         (case
                           when t0.l_impawn_amount = 0 then
                            0
                           else
                            t0.l_curr_impawn_amount -
                            t0.l_curr_impawn_amount * t0.l_redem_amount /
                            t0.l_impawn_amount
                         end) AS TNV_VOL, --成交数量
                         null AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
                         t0.en_curr_face_price AS TNV_PRC, --成交价格
                         (case
                           when T0.C_MARKET_NO = '1' then
                            0
                           when (t0.l_impawn_amount = 0 or t0.l_hold_amount = 0) and
                                T0.C_MARKET_NO = '2' then
                            0
                           else
                            (nvl((t0.en_occur_balance -
                                 t0.l_redem_amount * t0.en_curr_face_price) /
                                 t0.l_hold_amount,
                                 0)) * (t0.l_curr_impawn_amount -
                            t0.l_curr_impawn_amount *
                            t0.l_redem_amount / t0.l_impawn_amount)
                         end) AS TNV_VAL, --成交金额
                         (case
                           when T0.C_MARKET_NO = '1' then
                            0
                           when (t0.l_impawn_amount = 0 or t0.l_hold_amount = 0) and
                                T0.C_MARKET_NO = '2' then
                            0
                           else
                            (nvl((t0.en_occur_balance -
                                 t0.l_redem_amount * t0.en_curr_face_price) /
                                 t0.l_hold_amount,
                                 0)) * (t0.l_curr_impawn_amount -
                            t0.l_curr_impawn_amount *
                            t0.l_redem_amount / t0.l_impawn_amount)
                         end) AS OCCU_VAL, --发生金额
                         null AS AFT_OCCU_VAL, --发生后资金金额
                         (case
                           when T0.C_MARKET_NO = '1' then
                            0
                           when (t0.l_impawn_amount = 0 or t0.l_hold_amount = 0) and
                                T0.C_MARKET_NO = '2' then
                            0
                           else
                            (nvl((t0.en_occur_balance -
                                 t0.l_redem_amount * t0.en_curr_face_price) /
                                 t0.l_hold_amount,
                                 0)) * (t0.l_curr_impawn_amount -
                            t0.l_curr_impawn_amount *
                            t0.l_redem_amount / t0.l_impawn_amount)
                         end) AS INTR_VAL, --利息金额
                         T0.L_DATE AS DELI_DT, --交割日期
                         t0.l_date AS BUSI_DATE, --业务日期
                         NULL AS UPD_TIME, --源数据更新时间
                         'O3' AS SYS_RS_ID, --系统来源标识
                         'evt_sett_clea_jour_his_second_8' AS TASK_RS_ID, --任务来源标识
                         'thisliquidatedetail6' AS DM_SRC_INFO, --来源信息
                         CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
                         'OUTLINE' AS DM_CREATED_BY, --数据中台创建者
                         CURRENT_TIMESTAMP AS DM_UPDATED_TIME, --数据中台更新时间
                         'OUTLINE' AS DM_UPDATED_BY,
                         t0.l_basecombi_id,
                         t0.vc_inter_code,
						 t0.vc_stockholder_id,
						 t0.vc_bind_seat
                    from TMP_EVT_SETT_JOUR t0
            WHERE T0.L_HOLD_AMOUNT <> 0 --a持有数量<>0
              AND T0.L_REDEM_AMOUNT <> T0.L_HOLD_AMOUNT--c <> a 即交易所兑付的数量<> c 股东持有的数量（当天未全兑付，存在库内）
              AND T0.L_OUT_AMOUNT = 0 --库外数量 = 0
              AND T0.L_CURRENT_AMOUNT <> 0 --组合的持有数量<>0

                  union all
--部分库内全部占用部分库外库外部分/场景5-1 债券库外+库内占用：库外部分
                  SELECT T0.L_DATE AS OCCU_DT, --发生日期
                         CONCAT(T0.L_DATE , '_HSO32_' , T0.l_serial_no , 'U' , t0.l_unit_id , 'P' ,
                         t0.l_basecombi_id , 'L1') AS TNV_ONUM, --成交序号 库外1 库内未占用2 库内占用3
                         T0.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
                         CONCAT(T0.VC_FUND_CODE , '_' , T0.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
                         CONCAT(T0.VC_FUND_CODE , '_' , T0.VC_ASSET_NO , '_' ,
                         T0.VC_COMBI_NO) AS PFL_CODE, --投组代码
                         CONCAT(T0.VC_REPORT_CODE , '.BOND.' , (CASE
                           WHEN T0.C_MARKET_NO = '1' THEN
                            'SH'
                           WHEN T0.C_MARKET_NO = '2' THEN
                            'SZ'
                         END)) --债券
                         AS SECU_ID, --证券编码
                         CASE
                           WHEN T0.C_MARKET_NO = '1' THEN
                            'SH'
                           WHEN T0.C_MARKET_NO = '2' THEN
                            'SZ'
                         END AS EXCH_CODE, --交易市场代码
                         T0.VC_REPORT_CODE AS SECU_CODE, --证券代码
                         'L' AS POS_ID, --多空标志,默认多头
                         T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
                         '140001' AS BUSI_TYP, --业务类别
                         CASE
                           WHEN T0.C_INVEST_TYPE IN ('1') THEN
                            '2' --交易型金融资产
                           WHEN T0.C_INVEST_TYPE IN ('2') THEN
                            '1' --持有到期资产
                           ELSE
                            T0.C_INVEST_TYPE
                         END AS INV_TYP, --投资类型
                         '14000100' AS BUSI_CLAS,
                         t0.l_current_amount - t0.L_CURR_IMPAWN_AMOUNT AS TNV_VOL, --成交数量
                         null AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
                         t0.en_curr_face_price AS TNV_PRC, --成交价格
                         (case
                           when t0.l_hold_amount = 0 and T0.C_MARKET_NO = '2' then
                            0
                           when t0.l_redem_amount = 0 and T0.C_MARKET_NO = '1' then
                            0
                           else
                            (nvl((t0.en_occur_balance -
                                 t0.l_redem_amount * t0.en_curr_face_price) /
                                 (case
                                   when t0.C_MARKET_NO = '1' then
                                    t0.l_redem_amount
                                   else
                                    t0.l_hold_amount
                                 end),
                                 0) + t0.en_curr_face_price) *
                            (t0.l_current_amount - t0.L_CURR_IMPAWN_AMOUNT)
                         end) AS TNV_VAL, --成交金额
                         (case
                           when t0.l_hold_amount = 0 and T0.C_MARKET_NO = '2' then
                            0
                           when t0.l_redem_amount = 0 and T0.C_MARKET_NO = '1' then
                            0
                           else
                            (nvl((t0.en_occur_balance -
                                 t0.l_redem_amount * t0.en_curr_face_price) /
                                 (case
                                   when t0.C_MARKET_NO = '1' then
                                    t0.l_redem_amount
                                   else
                                    t0.l_hold_amount
                                 end),
                                 0) + t0.en_curr_face_price) *
                            (t0.l_current_amount - t0.L_CURR_IMPAWN_AMOUNT)
                         end) AS OCCU_VAL, --发生金额
                         null AS AFT_OCCU_VAL, --发生后资金金额
                         (case
                           when t0.l_hold_amount = 0 and T0.C_MARKET_NO = '2' then
                            0
                           when t0.l_redem_amount = 0 and T0.C_MARKET_NO = '1' then
                            0
                           else
                            (nvl((t0.en_occur_balance -
                                 t0.l_redem_amount * t0.en_curr_face_price) /
                                 (case
                                   when t0.C_MARKET_NO = '1' then
                                    t0.l_redem_amount
                                   else
                                    t0.l_hold_amount
                                 end),
                                 0)) * (t0.l_current_amount - t0.L_CURR_IMPAWN_AMOUNT)
                         end) AS INTR_VAL, --利息金额
                         T0.L_DATE AS DELI_DT, --交割日期
                         t0.l_date AS BUSI_DATE, --业务日期
                         NULL AS UPD_TIME, --源数据更新时间
                         'O3' AS SYS_RS_ID, --系统来源标识
                         'evt_sett_clea_jour_his_second_9' AS TASK_RS_ID, --任务来源标识
                         'thisliquidatedetail7' AS DM_SRC_INFO, --来源信息
                         CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
                         'OUTLINE' AS DM_CREATED_BY, --数据中台创建者
                         CURRENT_TIMESTAMP AS DM_UPDATED_TIME, --数据中台更新时间
                         'OUTLINE' AS DM_UPDATED_BY,
                         t0.l_basecombi_id,
                         t0.vc_inter_code,
						 t0.vc_stockholder_id,
						 t0.vc_bind_seat
                    from TMP_EVT_SETT_JOUR t0
            WHERE T0.L_HOLD_AMOUNT <> 0 -- a 持有数量<>0
                AND T0.L_REDEM_AMOUNT <> T0.L_HOLD_AMOUNT
                AND T0.L_OUT_AMOUNT <> 0 --c <> a 即交易所兑付的数量<> c 股东持有的数量（当天未全兑付，存在库内）
                AND T0.L_IN_AMOUNT = 0 --库内未占用数量
                AND T0.L_CURRENT_AMOUNT <> 0 --组合的持有数量不为0

                  union all
--部分库内全部占用部分库外库内占用部分/场景5-2 债券库外+库内占用：库内占用
                  SELECT T0.L_DATE AS OCCU_DT, --发生日期
                         CONCAT(T0.L_DATE , '_HSO32_' , T0.l_serial_no , 'U' , t0.l_unit_id , 'P' ,
                         t0.l_basecombi_id , 'L3') AS TNV_ONUM, --成交序号 库外1 库内未占用2 库内占用3
                         T0.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
                         CONCAT(T0.VC_FUND_CODE , '_' , T0.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
                         CONCAT(T0.VC_FUND_CODE , '_' , T0.VC_ASSET_NO , '_' ,
                         T0.VC_COMBI_NO) AS PFL_CODE, --投组代码
                         CONCAT(T0.VC_REPORT_CODE , '.BOND.' , (CASE
                           WHEN T0.C_MARKET_NO = '1' THEN
                            'SH'
                           WHEN T0.C_MARKET_NO = '2' THEN
                            'SZ'
                         END)) --债券
                         AS SECU_ID, --证券编码
                         CASE
                           WHEN T0.C_MARKET_NO = '1' THEN
                            'SH'
                           WHEN T0.C_MARKET_NO = '2' THEN
                            'SZ'
                         END AS EXCH_CODE, --交易市场代码
                         T0.VC_REPORT_CODE AS SECU_CODE, --证券代码
                         'L' AS POS_ID, --多空标志,默认多头
                         T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
                         '140001' AS BUSI_TYP, --业务类别
                         CASE
                           WHEN T0.C_INVEST_TYPE IN ('1') THEN
                            '2' --交易型金融资产
                           WHEN T0.C_INVEST_TYPE IN ('2') THEN
                            '1' --持有到期资产
                           ELSE
                            T0.C_INVEST_TYPE
                         END AS INV_TYP, --投资类型
                         '14000102' AS BUSI_CLAS,
                         t0.l_curr_impawn_amount AS TNV_VOL, --成交数量
                         null AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
                         t0.en_curr_face_price AS TNV_PRC, --成交价格
                         (case
                           when T0.C_MARKET_NO = '1' then
                            0
                           when t0.l_hold_amount = 0 and T0.C_MARKET_NO = '2' then
                            0
                           else
                            (nvl((t0.en_occur_balance -
                                 t0.l_redem_amount * t0.en_curr_face_price) /
                                 t0.l_hold_amount,
                                 0)) * t0.l_curr_impawn_amount
                         end) AS TNV_VAL, --成交金额
                         (case
                           when T0.C_MARKET_NO = '1' then
                            0
                           when t0.l_hold_amount = 0 and T0.C_MARKET_NO = '2' then
                            0
                           else
                            (nvl((t0.en_occur_balance -
                                 t0.l_redem_amount * t0.en_curr_face_price) /
                                 t0.l_hold_amount,
                                 0)) * t0.l_curr_impawn_amount
                         end) AS OCCU_VAL, --发生金额
                         null AS AFT_OCCU_VAL, --发生后资金金额
                         (case
                           when T0.C_MARKET_NO = '1' then
                            0
                           when t0.l_hold_amount = 0 and T0.C_MARKET_NO = '2' then
                            0
                           else
                            (nvl((t0.en_occur_balance -
                                 t0.l_redem_amount * t0.en_curr_face_price) /
                                 t0.l_hold_amount,
                                 0)) * t0.l_curr_impawn_amount
                         end) AS INTR_VAL, --利息金额
                         T0.L_DATE AS DELI_DT, --交割日期
                         t0.l_date AS BUSI_DATE, --业务日期
                         NULL AS UPD_TIME, --源数据更新时间
                         'O3' AS SYS_RS_ID, --系统来源标识
                         'evt_sett_clea_jour_his_second_10' AS TASK_RS_ID, --任务来源标识
                         'thisliquidatedetail8' AS DM_SRC_INFO, --来源信息
                         CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
                         'OUTLINE' AS DM_CREATED_BY, --数据中台创建者
                         CURRENT_TIMESTAMP AS DM_UPDATED_TIME, --数据中台更新时间
                         'OUTLINE' AS DM_UPDATED_BY,
                         t0.l_basecombi_id,
                         t0.vc_inter_code,
						 t0.vc_stockholder_id,
						 t0.vc_bind_seat
                    from TMP_EVT_SETT_JOUR t0
            WHERE T0.L_HOLD_AMOUNT <> 0 -- a 持有数量<>0
              AND T0.L_REDEM_AMOUNT <> T0.L_HOLD_AMOUNT
              AND T0.L_OUT_AMOUNT <> 0 --c <> a 即交易所兑付的数量<> c 股东持有的数量（当天未全兑付，存在库内）
              AND T0.L_IN_AMOUNT = 0 --库内未占用数量
              AND T0.L_CURRENT_AMOUNT <> 0 --组合的持有数量不为0

                  union all
--部分库外部分库内未占用部分库内占用库外部分/场景6-1 债券 库外+库内未占用+库内占用：库外部分
                  SELECT T0.L_DATE AS OCCU_DT, --发生日期
                         CONCAT(T0.L_DATE , '_HSO32_' , T0.l_serial_no , 'U' , t0.l_unit_id , 'P' ,
                         t0.l_basecombi_id , 'L1') AS TNV_ONUM, --成交序号 库外1 库内未占用2 库内占用3
                         T0.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
                         CONCAT(T0.VC_FUND_CODE , '_' , T0.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
                         CONCAT(T0.VC_FUND_CODE , '_' , T0.VC_ASSET_NO , '_' ,
                         T0.VC_COMBI_NO) AS PFL_CODE, --投组代码
                         CONCAT(T0.VC_REPORT_CODE , '.BOND.' , (CASE
                           WHEN T0.C_MARKET_NO = '1' THEN
                            'SH'
                           WHEN T0.C_MARKET_NO = '2' THEN
                            'SZ'
                         END)) --债券
                         AS SECU_ID, --证券编码
                         CASE
                           WHEN T0.C_MARKET_NO = '1' THEN
                            'SH'
                           WHEN T0.C_MARKET_NO = '2' THEN
                            'SZ'
                         END AS EXCH_CODE, --交易市场代码
                         T0.VC_REPORT_CODE AS SECU_CODE, --证券代码
                         'L' AS POS_ID, --多空标志,默认多头
                         T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
                         '140001' AS BUSI_TYP, --业务类别
                         CASE
                           WHEN T0.C_INVEST_TYPE IN ('1') THEN
                            '2' --交易型金融资产
                           WHEN T0.C_INVEST_TYPE IN ('2') THEN
                            '1' --持有到期资产
                           ELSE
                            T0.C_INVEST_TYPE
                         END AS INV_TYP, --投资类型
                         '14000100' AS BUSI_CLAS,
                         t0.l_current_amount - t0.L_CURR_IMPAWN_AMOUNT AS TNV_VOL, --成交数量
                         null AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
                         t0.en_curr_face_price AS TNV_PRC, --成交价格
                         (case
                           when t0.l_hold_amount = 0 and T0.C_MARKET_NO = '2' then
                            0
                           when t0.l_redem_amount = 0 and T0.C_MARKET_NO = '1' then
                            0
                           else
                            (nvl((t0.en_occur_balance -
                                 t0.l_redem_amount * t0.en_curr_face_price) /
                                 (case
                                   when t0.C_MARKET_NO = '1' then
                                    t0.l_redem_amount
                                   else
                                    t0.l_hold_amount
                                 end),
                                 0) + t0.en_curr_face_price) *
                            (t0.l_current_amount - t0.L_CURR_IMPAWN_AMOUNT)
                         end) AS TNV_VAL, --成交金额
                         (case
                           when t0.l_hold_amount = 0 and T0.C_MARKET_NO = '2' then
                            0
                           when t0.l_redem_amount = 0 and T0.C_MARKET_NO = '1' then
                            0
                           else
                            (nvl((t0.en_occur_balance -
                                 t0.l_redem_amount * t0.en_curr_face_price) /
                                 (case
                                   when t0.C_MARKET_NO = '1' then
                                    t0.l_redem_amount
                                   else
                                    t0.l_hold_amount
                                 end),
                                 0) + t0.en_curr_face_price) *
                            (t0.l_current_amount - t0.L_CURR_IMPAWN_AMOUNT)
                         end) AS OCCU_VAL, --发生金额
                         null AS AFT_OCCU_VAL, --发生后资金金额
                         (case
                           when t0.l_hold_amount = 0 and T0.C_MARKET_NO = '2' then
                            0
                           when t0.l_redem_amount = 0 and T0.C_MARKET_NO = '1' then
                            0
                           else
                            (nvl((t0.en_occur_balance -
                                 t0.l_redem_amount * t0.en_curr_face_price) /
                                 (case
                                   when t0.C_MARKET_NO = '1' then
                                    t0.l_redem_amount
                                   else
                                    t0.l_hold_amount
                                 end),
                                 0) ) * (t0.l_current_amount - t0.L_CURR_IMPAWN_AMOUNT)
                         end) AS INTR_VAL, --利息金额
                         T0.L_DATE AS DELI_DT, --交割日期
                         t0.l_date AS BUSI_DATE, --业务日期
                         NULL AS UPD_TIME, --源数据更新时间
                         'O3' AS SYS_RS_ID, --系统来源标识
                         'evt_sett_clea_jour_his_second_11' AS TASK_RS_ID, --任务来源标识
                         'thisliquidatedetail9' AS DM_SRC_INFO, --来源信息
                         CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
                         'OUTLINE' AS DM_CREATED_BY, --数据中台创建者
                         CURRENT_TIMESTAMP AS DM_UPDATED_TIME, --数据中台更新时间
                         'OUTLINE' AS DM_UPDATED_BY,
                         t0.l_basecombi_id,
                         t0.vc_inter_code,
						 t0.vc_stockholder_id,
						 t0.vc_bind_seat
                    from TMP_EVT_SETT_JOUR t0
            WHERE T0.L_HOLD_AMOUNT <> 0 --a 上一日持有数量 <> 0
              AND T0.L_REDEM_AMOUNT <> T0.L_HOLD_AMOUNT --a <> c 说明有库内占用的部分
              AND T0.L_OUT_AMOUNT <> 0 -- 库外数量 <> 0
              AND T0.L_IN_AMOUNT <> 0 --库内未占用数量 <> 0
              AND T0.L_CURRENT_AMOUNT <> 0 --组合的持有数量不为0

                  union all
--部分库外部分库内未占用部分库内占用库内未占用部分/场景6-2 债券 库外+库内未占用+库内占用：库内未占用部分
                  SELECT T0.L_DATE AS OCCU_DT, --发生日期
                         CONCAT(T0.L_DATE , '_HSO32_' , T0.l_serial_no , 'U' , t0.l_unit_id , 'P' ,
                         t0.l_basecombi_id , 'L2') AS TNV_ONUM, --成交序号 库外1 库内未占用2 库内占用3
                         T0.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
                         CONCAT(T0.VC_FUND_CODE , '_' , T0.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
                         CONCAT(T0.VC_FUND_CODE , '_' , T0.VC_ASSET_NO , '_' ,
                         T0.VC_COMBI_NO) AS PFL_CODE, --投组代码
                         CONCAT(T0.VC_REPORT_CODE , '.BOND.' , (CASE
                           WHEN T0.C_MARKET_NO = '1' THEN
                            'SH'
                           WHEN T0.C_MARKET_NO = '2' THEN
                            'SZ'
                         END)) --债券
                         AS SECU_ID, --证券编码
                         CASE
                           WHEN T0.C_MARKET_NO = '1' THEN
                            'SH'
                           WHEN T0.C_MARKET_NO = '2' THEN
                            'SZ'
                         END AS EXCH_CODE, --交易市场代码
                         T0.VC_REPORT_CODE AS SECU_CODE, --证券代码
                         'L' AS POS_ID, --多空标志,默认多头
                         T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
                         '140001' AS BUSI_TYP, --业务类别
                         CASE
                           WHEN T0.C_INVEST_TYPE IN ('1') THEN
                            '2' --交易型金融资产
                           WHEN T0.C_INVEST_TYPE IN ('2') THEN
                            '1' --持有到期资产
                           ELSE
                            T0.C_INVEST_TYPE
                         END AS INV_TYP, --投资类型
                         '14000101' AS BUSI_CLAS,
                         (case
                           when t0.l_impawn_amount = 0 then
                            0
                           else
                            t0.l_curr_impawn_amount *
                            (t0.l_redem_amount -
                            (t0.l_hold_amount - t0.l_impawn_amount)) /
                            t0.l_impawn_amount
                         end) AS TNV_VOL, --成交数量
                         null AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
                         t0.en_curr_face_price AS TNV_PRC, --成交价格
                         (case
                           when t0.l_hold_amount = 0 and T0.C_MARKET_NO = '2' then
                            0
                           when t0.l_redem_amount = 0 and T0.C_MARKET_NO = '1' then
                            0
                           else
                            (nvl((t0.en_occur_balance -
                                 t0.l_redem_amount * t0.en_curr_face_price) /
                                 (case
                                   when t0.C_MARKET_NO = '1' then
                                    t0.l_redem_amount
                                   else
                                    t0.l_hold_amount
                                 end),
                                 0) + t0.en_curr_face_price) * (case
                              when t0.l_impawn_amount = 0 then
                               0
                              else
                               t0.l_curr_impawn_amount *
                               (t0.l_redem_amount -
                               (t0.l_hold_amount - t0.l_impawn_amount)) /
                               t0.l_impawn_amount
                            end)
                         end) AS TNV_VAL, --成交金额
                         (case
                           when t0.l_hold_amount = 0 and T0.C_MARKET_NO = '2' then
                            0
                           when t0.l_redem_amount = 0 and T0.C_MARKET_NO = '1' then
                            0
                           else
                            (nvl((t0.en_occur_balance -
                                 t0.l_redem_amount * t0.en_curr_face_price) /
                                 (case
                                   when t0.C_MARKET_NO = '1' then
                                    t0.l_redem_amount
                                   else
                                    t0.l_hold_amount
                                 end),
                                 0) + t0.en_curr_face_price) * (case
                              when t0.l_impawn_amount = 0 then
                               0
                              else
                               t0.l_curr_impawn_amount *
                               (t0.l_redem_amount -
                               (t0.l_hold_amount - t0.l_impawn_amount)) /
                               t0.l_impawn_amount
                            end)
                         end) AS OCCU_VAL, --发生金额
                         null AS AFT_OCCU_VAL, --发生后资金金额
                         (case
                           when t0.l_hold_amount = 0 and T0.C_MARKET_NO = '2' then
                            0
                           when t0.l_redem_amount = 0 and T0.C_MARKET_NO = '1' then
                            0
                           else
                            (nvl((t0.en_occur_balance -
                                 t0.l_redem_amount * t0.en_curr_face_price) /
                                 (case
                                   when t0.C_MARKET_NO = '1' then
                                    t0.l_redem_amount
                                   else
                                    t0.l_hold_amount
                                 end),
                                 0)) * (case
                              when t0.l_impawn_amount = 0 then
                               0
                              else
                               t0.l_curr_impawn_amount *
                               (t0.l_redem_amount -
                               (t0.l_hold_amount - t0.l_impawn_amount)) /
                               t0.l_impawn_amount
                            end)
                         end) AS INTR_VAL, --利息金额
                         T0.L_DATE AS DELI_DT, --交割日期
                         t0.l_date AS BUSI_DATE, --业务日期
                         NULL AS UPD_TIME, --源数据更新时间
                         'O3' AS SYS_RS_ID, --系统来源标识
                         'evt_sett_clea_jour_his_second_12' AS TASK_RS_ID, --任务来源标识
                         'thisliquidatedetail10' AS DM_SRC_INFO, --来源信息
                         CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
                         'OUTLINE' AS DM_CREATED_BY, --数据中台创建者
                         CURRENT_TIMESTAMP AS DM_UPDATED_TIME, --数据中台更新时间
                         'OUTLINE' AS DM_UPDATED_BY,
                         t0.l_basecombi_id,
                         t0.vc_inter_code,
						 t0.vc_stockholder_id,
						 t0.vc_bind_seat
                    from TMP_EVT_SETT_JOUR t0
            WHERE T0.L_HOLD_AMOUNT <> 0 --a 上一日持有数量 <> 0
              AND T0.L_REDEM_AMOUNT <> T0.L_HOLD_AMOUNT --a <> c 说明有库内占用的部分
              AND T0.L_OUT_AMOUNT <> 0 -- 库外数量 <> 0
              AND T0.L_IN_AMOUNT <> 0 --库内未占用数量 <> 0
              AND T0.L_CURRENT_AMOUNT <> 0 --组合的持有数量不为0

                  union all
--部分库外部分库内未占用部分库内占用库内占用部分/场景6-3 债券 库外+库内未占用+库内占用：库内占用部分
                  SELECT T0.L_DATE AS OCCU_DT, --发生日期
                         CONCAT(T0.L_DATE , '_HSO32_' , T0.l_serial_no , 'U' , t0.l_unit_id , 'P' ,
                         t0.l_basecombi_id , 'L3') AS TNV_ONUM, --成交序号 库外1 库内未占用2 库内占用3
                         T0.VC_FUND_CODE AS PRD_CODE, --产品代码,清洗时需要验证产品代码与估值能否对应上
                         CONCAT(T0.VC_FUND_CODE , '_' , T0.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
                         CONCAT(T0.VC_FUND_CODE , '_' , T0.VC_ASSET_NO , '_' ,
                         T0.VC_COMBI_NO) AS PFL_CODE, --投组代码
                         CONCAT(T0.VC_REPORT_CODE , '.BOND.' , (CASE
                           WHEN T0.C_MARKET_NO = '1' THEN
                            'SH'
                           WHEN T0.C_MARKET_NO = '2' THEN
                            'SZ'
                         END)) --债券
                         AS SECU_ID, --证券编码
                         CASE
                           WHEN T0.C_MARKET_NO = '1' THEN
                            'SH'
                           WHEN T0.C_MARKET_NO = '2' THEN
                            'SZ'
                         END AS EXCH_CODE, --交易市场代码
                         T0.VC_REPORT_CODE AS SECU_CODE, --证券代码
                         'L' AS POS_ID, --多空标志,默认多头
                         T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
                         '140001' AS BUSI_TYP, --业务类别
                         CASE
                           WHEN T0.C_INVEST_TYPE IN ('1') THEN
                            '2' --交易型金融资产
                           WHEN T0.C_INVEST_TYPE IN ('2') THEN
                            '1' --持有到期资产
                           ELSE
                            T0.C_INVEST_TYPE
                         END AS INV_TYP, --投资类型
                         '14000102' AS BUSI_CLAS,
                         (case
                           when t0.l_impawn_amount = 0 then
                            0
                           else
                            t0.l_curr_impawn_amount -
                            t0.l_curr_impawn_amount *
                            (t0.l_redem_amount -
                            (t0.l_hold_amount - t0.l_impawn_amount)) /
                            t0.l_impawn_amount
                         end) AS TNV_VOL, --成交数量
                         null AS AFT_PAR_VOL, --发生后数量,数据不准，暂不使用
                         t0.en_curr_face_price AS TNV_PRC, --成交价格
                         (case
                           when t0.l_hold_amount = 0 and T0.C_MARKET_NO = '2' then
                            0
                           when T0.C_MARKET_NO = '1' then
                            0
                           else
                            (nvl((t0.en_occur_balance -
                                 t0.l_redem_amount * t0.en_curr_face_price) /
                                 t0.l_hold_amount,
                                 0)) * (case
                              when t0.l_impawn_amount = 0 then
                               0
                              else
                               t0.l_curr_impawn_amount -
                               t0.l_curr_impawn_amount *
                               (t0.l_redem_amount -
                               (t0.l_hold_amount - t0.l_impawn_amount)) /
                               t0.l_impawn_amount
                            end)
                         end) AS TNV_VAL, --成交金额
                         (case
                           when t0.l_hold_amount = 0 and T0.C_MARKET_NO = '2' then
                            0
                           when T0.C_MARKET_NO = '1' then
                            0
                           else
                            (nvl((t0.en_occur_balance -
                                 t0.l_redem_amount * t0.en_curr_face_price) /
                                 t0.l_hold_amount,
                                 0)) * (case
                              when t0.l_impawn_amount = 0 then
                               0
                              else
                               t0.l_curr_impawn_amount -
                               t0.l_curr_impawn_amount *
                               (t0.l_redem_amount -
                               (t0.l_hold_amount - t0.l_impawn_amount)) /
                               t0.l_impawn_amount
                            end)
                         end) AS OCCU_VAL, --发生金额
                         null AS AFT_OCCU_VAL, --发生后资金金额
                         (case
                           when t0.l_hold_amount = 0 and T0.C_MARKET_NO = '2' then
                            0
                           when T0.C_MARKET_NO = '1' then
                            0
                           else
                            (nvl((t0.en_occur_balance -
                                 t0.l_redem_amount * t0.en_curr_face_price) /
                                 t0.l_hold_amount,
                                 0)) * (case
                              when t0.l_impawn_amount = 0 then
                               0
                              else
                               t0.l_curr_impawn_amount -
                               t0.l_curr_impawn_amount *
                               (t0.l_redem_amount -
                               (t0.l_hold_amount - t0.l_impawn_amount)) /
                               t0.l_impawn_amount
                            end)
                         end) AS INTR_VAL, --利息金额
                         T0.L_DATE AS DELI_DT, --交割日期
                         t0.l_date AS BUSI_DATE, --业务日期
                         NULL AS UPD_TIME, --源数据更新时间
                         'O3' AS SYS_RS_ID, --系统来源标识
                         'evt_sett_clea_jour_his_second_13' AS TASK_RS_ID, --任务来源标识
                         'thisliquidatedetail11' AS DM_SRC_INFO, --来源信息
                         CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
                         'OUTLINE' AS DM_CREATED_BY, --数据中台创建者
                         CURRENT_TIMESTAMP AS DM_UPDATED_TIME, --数据中台更新时间
                         'OUTLINE' AS DM_UPDATED_BY,
                         t0.l_basecombi_id,
                         t0.vc_inter_code,
						 t0.vc_stockholder_id,
						 t0.vc_bind_seat
                    from TMP_EVT_SETT_JOUR t0
            WHERE T0.L_HOLD_AMOUNT <> 0 --a 上一日持有数量 <> 0
              AND T0.L_REDEM_AMOUNT <> T0.L_HOLD_AMOUNT --a <> c 说明有库内占用的部分
              AND T0.L_OUT_AMOUNT <> 0 -- 库外数量 <> 0
              AND T0.L_IN_AMOUNT <> 0 --库内未占用数量 <> 0
              AND T0.L_CURRENT_AMOUNT <> 0 --组合的持有数量不为0
					) t0
        left join TMP_EVT_SETT_JOUR t1
          on t0.occu_dt = t1.l_date
         and t0.l_basecombi_id = t1.l_basecombi_id
         and t0.vc_inter_code = t1.vc_inter_code
         and t1.l_hold_amount <> 0
         and t1.l_redem_amount <> t1.l_hold_amount

 union all
--离线清算：期货保证金
SELECT T0.L_DATE AS OCCU_DT, --发生日期
       T0.L_TIME AS OCCU_TIME, --发生时间
       '1' AS BUSI_SYS_ID, --业务系统编码
       CONCAT('0|0|0|' , T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TRD_SRC_ID, --交易源ID
       CONCAT(T0.L_DATE , '_HSO32' , '_L' , T0.L_SERIAL_NO) AS TNV_ONUM, --成交序号
       T1.VC_FUND_CODE AS PRD_CODE, --产品代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS AST_UNIT_CODE, --资产单元代码
       CONCAT(T1.VC_FUND_CODE , '_' , T2.VC_ASSET_NO) AS PFL_CODE, --投组代码，该业务没有到投资组合层，存放资产单元代码
       T0.VC_STOCKHOLDER_ID AS SH_CODE, --股东代码
       T0.VC_SEAT_ID AS SEAT_CODE, --席位号
       'QHBZJ.CASH.NONE' AS SECU_ID, --证券编码
       'NONE' AS EXCH_CODE, --交易市场代码
       'QHBZJ' AS SECU_CODE, --证券代码
       NULL AS SRC_SECU_ID, --源证券ID
       NULL AS SRC_SECU_TRD_ID, --源证券交易ID
       'L' AS POS_ID, --多空标志
       T0.VC_CURRENCY_NO AS CURR_CODE, --货币代码
       '460003' AS BUSI_TYP, --业务类别
       (CASE WHEN T0.C_INVEST_TYPE = '1' THEN '2'
             WHEN T0.C_INVEST_TYPE = '2' THEN '1'
             WHEN T0.C_INVEST_TYPE = 'a' THEN '15'
             WHEN T0.C_INVEST_TYPE = 'b' THEN '10'
             WHEN T0.C_INVEST_TYPE = 'c' THEN '12'
             ELSE T0.C_INVEST_TYPE
        END) AS INV_TYP, --投资类型
       CASE WHEN T0.L_BUSIN_FLAG = '40203' THEN '46000300'  --期货保证金增加
            WHEN T0.L_BUSIN_FLAG = '40204' THEN '46000301'  --期货保证金减少
       END AS BUSI_CLAS, --业务类型
       0 AS TNV_VOL, --成交数量
       0 AS AFT_PAR_VOL, --发生后数量
       0 AS TNV_PRC, --成交价格
       T0.EN_OCCUR_BALANCE AS TNV_VAL, --成交金额
       T0.EN_OCCUR_BALANCE AS OCCU_VAL, --发生金额
       0 AS AFT_OCCU_VAL, --发生后资金金额
       0 AS INTR_VAL, --利息金额
       T0.L_DATE AS DELI_DT, --交割日期,可能不准，可能并非按照这个日期进行交收
       NULL AS INTR_TRAN_DPSI, --存款利息转存
       NULL AS PNLT_VAL, --存款罚息金额
       NULL AS CONT_ID, --合约编码
       NULL AS RES_FLAG, --限售标志
       ${end_date} AS BUSI_DATE, --业务日期.
       'evt_sett_clea_jour_his_second_14' AS TASK_RS_ID, --任务来源标识
       CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
       T0.L_DATE as P_DT,
       'O3' AS SYS_RS_ID --系统来源标识
  FROM ${ods_db}.O3_THISCURRENTS T0 --清算流水主表
       LEFT JOIN ${ods_db}.O3_TFUNDINFO T1 --产品基本信息表，获取产品代码
              ON T0.L_FUND_ID = T1.L_FUND_ID
       LEFT JOIN ${ods_db}.O3_TASSET T2 --资产单元基本信息表，获取资产单元代码
              ON T0.L_ASSET_ID = T2.L_ASSET_ID
       LEFT JOIN ${ods_db}.O3_TCOMBI T3 --投资组合基本信息表，获取投资组合代码
              ON T0.L_BASECOMBI_ID = T3.L_COMBI_ID
 WHERE T0.L_BUSIN_FLAG IN ('40203', '40204')  --期货保证金增加、期货保证金减少
   AND T0.C_STATUS = '1'
   AND T0.P_DT BETWEEN ${beg_date} AND ${end_date}