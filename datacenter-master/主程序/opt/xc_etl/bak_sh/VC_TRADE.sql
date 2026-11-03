CREATE OR REPLACE VIEW FA45.VC_TRADE AS
SELECT CAST(N_ID AS VARCHAR2(30)) AS N_ID,
       CAST(N_ID_SUB AS VARCHAR2(30)) AS N_ID_SUB,
       CAST(C_PORT_CODE AS VARCHAR2(20)) AS C_PORT_CODE,
       CAST(C_ASSET_COselect * from fa45.Vc_TradeDE AS VARCHAR2(20)) AS C_ASSET_CODE,
       CAST(C_TD_NUMBER AS VARCHAR2(50)) AS C_TD_NUMBER,
       CAST(C_TD_TYPE AS VARCHAR2(20)) AS C_TD_TYPE,
       CAST(D_BIZ AS DATE) AS D_BIZ,
       CAST(D_TRADE_DATE AS DATE) AS D_TRADE_DATE,
       CAST(D_TRADE_OUTER AS DATE) AS D_TRADE_OUTER,
       CAST(C_DV_TYPE_SUB AS VARCHAR2(20)) AS C_DV_TYPE_SUB,
       CAST(C_SEC_CODE AS VARCHAR2(200)) AS C_SEC_CODE,
       CAST(C_SEC_CODE_TAG AS VARCHAR2(200)) AS C_SEC_CODE_TAG,
       C_DV_VAR_DUR,
       C_SEC_VAR_MX,
       CAST(N_NH_DAYS AS NUMBER(18,4)) AS N_NH_DAYS,
       c_Dt_Code,
       C_CURY_CODE,
       C_MKT_CODE,
       C_TD_PLAT,
       C_TDCHAN_CODE,
       C_TD_CODE,
       C_IM_CODE,
       C_IVT_CLSS,
       C_HLD_ATTR,
       C_TD_ATTR,
       C_ML_ATTR,
       C_TD_RELAPARTY,
       C_SETT_MODE,
       CAST(N_TD_AMOUNT AS NUMBER(18,4)) AS N_TD_AMOUNT,
       CAST(N_TD_PRICE AS NUMBER(30,15)) AS N_TD_PRICE,
       CAST(N_TD_MONEY AS NUMBER(18,4)) AS N_TD_MONEY,
       CAST(N_Days AS NUMBER(6)) AS N_Days,
       CAST(N_HG_RATE AS NUMBER(30,15)) AS N_HG_RATE,
       CAST(N_HGLL_TD AS NUMBER(30,15)) AS N_HGLL_TD,
       CAST(N_REF_RATE AS NUMBER(30,15)) AS N_REF_RATE,
       CAST(N_TD_INCOME AS NUMBER(30,15)) AS N_TD_INCOME,
       CAST(C_SEC_CODE_I AS VARCHAR2(200)) AS C_SEC_CODE_I,
       C_IVT_CLSS_I,
       C_TD_ATTR_I,
       CAST(N_TD_AMOUNT_I AS NUMBER(18,4)) AS N_TD_AMOUNT_I,
       CAST(N_TD_MONEY_I AS NUMBER(18,4)) AS N_TD_MONEY_I,
       C_DV_SETT,
       D_SETT_FIRST,
       C_CA_CODE_SETT_FIRST,
       CAST(N_SETT_MONEY_FIRST AS NUMBER(18,4)) AS N_SETT_MONEY_FIRST,
       CAST(N_SETT_MONEY_DUE AS NUMBER(18,4)) AS N_SETT_MONEY_DUE,
       CAST(N_SETT_MONEY_FACT AS NUMBER(18,4)) AS N_SETT_MONEY_FACT,
       D_SETT_DUE,
       C_CA_CODE_SETT_DUE,
       D_SETT_FACT,
       D_BIZ_FIRST,
       C_CA_CODE_BAIL,
       C_CA_CODE_OT,
       C_DV_STATE,
       C_OPEN_ADDR,
       C_OPEN_ACC_NO,
       C_OPEN_ACC_NAME,
       CAST(N_TD_YHS AS NUMBER(18,4)) AS N_TD_YHS,
       CAST(N_TD_JSF AS NUMBER(18,4)) AS N_TD_JSF,
       CAST(N_TD_GHF AS NUMBER(18,4)) AS N_TD_GHF,
       CAST(N_TD_ZGF AS NUMBER(18,4)) AS N_TD_ZGF,
       CAST(N_TD_JSFWF AS NUMBER(18,4)) AS N_TD_JSFWF,
       CAST(N_TD_FEE AS NUMBER(18,4)) AS N_TD_FEE,
       CAST(N_BK_HHF AS NUMBER(18,4)) AS N_BK_HHF,
       CAST(N_STFXJ AS NUMBER(18,4)) AS N_STFXJ,
       CAST(N_TD_COMM AS NUMBER(18,4)) AS N_TD_COMM,
       CAST(N_RGF AS NUMBER(18,4)) AS N_RGF,
       CAST(N_SGF AS NUMBER(18,4)) AS N_SGF,
       CAST(N_SHF AS NUMBER(18,4)) AS N_SHF,
       CAST(N_QTF AS NUMBER(18,4)) AS N_QTF,
       CAST(N_TD_YF_COMM AS NUMBER(18,4)) AS N_TD_YF_COMM,
       D_TD_BACK,
       CAST(N_RATE AS NUMBER(30,15)) AS N_RATE,
       C_SETT_ORG,
       C_PORT_CODE_SUB,
       C_CXS_NAME,
       CAST(N_TD_MONEY_LOCL AS NUMBER(18,4)) AS N_TD_MONEY_LOCL,
       CAST(N_PAWN_MONEY AS NUMBER(18,4)) AS N_PAWN_MONEY,
       C_SS_CHAN,
       D_APPLY,
       C_DATA_IDF,
       C_DEVALUE_STAGE,
	     C_ORG_CODE,--STORY #121486
       C_UPDATE_TIME,
       C_UPDATE_BY,
       C_CHECK_BY,
       C_CHECK_TIME,
       C_TIMESTAMP FROM(
SELECT A.c_Iden AS N_ID,
       A.C_IDEN_SUB as N_ID_SUB,
       A.C_PORT_CODE AS C_PORT_CODE,
       E.C_ASS_CODE AS C_ASSET_CODE,
       NVL(A.C_TD_NO, ' ') AS C_TD_NUMBER,
       A.C_TD_TYPE AS C_TD_TYPE,
       A.D_TRADE AS D_BIZ,
       A.D_TRADE AS D_TRADE_DATE,
       A.D_WBCJRQ AS D_TRADE_OUTER, --STORY #68781
       A.C_DV_TYPE_SUB AS C_DV_TYPE_SUB,
       A.C_SEC_CODE,
       A.C_SEC_CODE_TAG,
       A.C_DV_VAR_DUR,
       D.C_SEC_VAR_CODE AS C_SEC_VAR_MX,
       (CASE
         WHEN D.C_SEC_VAR_CODE LIKE 'CK%' THEN
          D.N_AMOUNT_HD
         WHEN D.C_SEC_VAR_CODE LIKE 'JJ%' THEN
          D.N_RATIO
         WHEN D.C_SEC_VAR_CODE LIKE 'LC%' THEN
          D.N_RATIO
         WHEN D.C_SEC_VAR_CODE LIKE 'HG%' THEN
          TO_NUMBER(NVL(D.C_DV_QUT_MOD,0))
         WHEN D.C_SEC_VAR_CODE LIKE 'CJ%' THEN
          TO_NUMBER(NVL(D.C_DV_QUT_MOD,0))
         ELSE
          NULL
       END) AS N_NH_DAYS,--20170704 利率年化天数
       A.c_Dt_Code,
       D.C_DC_CODE AS C_CURY_CODE,
       D.C_MKT_CODE,
       A.C_DV_PLAT AS C_TD_PLAT,
       A.C_TD_CHAN_CODE AS C_TDCHAN_CODE,
       A.C_SH_ACC_CODE AS C_TD_CODE,
       ' ' AS C_IM_CODE, --投资经理
       A.C_DV_INVEST_CLS AS C_IVT_CLSS,
       ' ' AS C_HLD_ATTR, --持有属性
       A.C_DTA_CODE AS C_TD_ATTR,
       A.C_DV_ISSUE_MODE AS C_ML_ATTR, --受限流通类别
       CASE WHEN  A.C_DT_CODE IN ('ZQJY_FX','ZQJY_CX') THEN A.C_FX_ORG  /*易方达需求44251*/
        WHEN  A.C_SEC_VAR_CODE LIKE 'ZQ%' OR A.C_SEC_VAR_CODE LIKE 'HG%' THEN case when trim(A.C_ORG_CODE) is null then NVL(G.C_TD_CHAN_NAME,ORG.C_ORG_NAME) else trim(ORG1.C_ORG_NAME) end ELSE
       NVL(G.C_TD_CHAN_NAME,ORG.C_ORG_NAME) end AS C_TD_RELAPARTY, --交易对手方
     A.C_SETT_MODE,--交收方式 STORY #68340
       case
         when A.C_MKT_CODE = 'XCFE' AND A.C_SEC_VAR_CODE LIKE 'HG_%' then
          round(A.N_TD_AMOUNT / 100, 2)
         else
          A.N_TD_AMOUNT
       end as N_TD_AMOUNT,
       A.N_TD_PRICE,
       A.N_TD_MONEY,
       (case
         when a.c_sec_var_code like 'HG%' then
          to_number(nvl(d.c_dv_var_dur, 0))
       end) as N_Days,
        (CASE
         WHEN  A.C_DV_TYPE_SUB ='HGJY_SQ' AND A.C_TD_TYPE = 'HGJY' THEN
     /*BUG #268303 针对平安资产上交所的回购流水中的回购利率保存到C_HGLL字段的特殊场景，将回购利率的取值改成先判断C_HGLL，再判断N_TD_PRICE，哪个字段取到值就使用哪个字段*/
      (CASE WHEN TRIM(A.C_HGLL) IS NOT NULL AND TO_NUMBER(TRIM(A.C_HGLL)) <> 0 THEN TO_NUMBER(A.C_HGLL) / 100
                 WHEN TRIM(A.N_TD_PRICE) IS NOT NULL AND TRIM(A.N_TD_PRICE) <> 0 THEN A.N_TD_PRICE ELSE 0 END)
      --(CASE WHEN TRIM(A.C_HGLL) IS NULL THEN NULL ELSE TO_NUMBER(A.C_HGLL) / 100 END)
         WHEN  A.C_DV_TYPE_SUB ='HGJY_DQ' AND A.C_TD_TYPE = 'HGJY' THEN
     /*BUG #268303 针对平安资产上交所的回购流水中的回购利率保存到C_HGLL字段的特殊场景，将回购利率的取值改成先判断C_HGLL，再判断N_TD_PRICE，哪个字段取到值就使用哪个字段*/
      (CASE WHEN TRIM(H.C_HGLL) IS NOT NULL AND TO_NUMBER(TRIM(H.C_HGLL)) <> 0 THEN TO_NUMBER(H.C_HGLL) / 100
              WHEN TRIM(H.N_TD_PRICE) IS NOT NULL AND TRIM(H.N_TD_PRICE) <> 0 THEN H.N_TD_PRICE ELSE 0 END)
      --(CASE WHEN TRIM(H.C_HGLL) IS NULL THEN NULL ELSE TO_NUMBER(H.C_HGLL) / 100 END)
     WHEN  A.C_DV_TYPE_SUB ='HGJY_CSHG' AND A.C_TD_TYPE = 'HGJY_GP' THEN
      A.N_TD_PRICE
     WHEN  A.C_DV_TYPE_SUB ='HGJY_GHJY' AND A.C_TD_TYPE = 'HGJY_GP' THEN
      H.N_TD_PRICE
         ELSE
          NULL
       END) AS N_HG_RATE,
     CASE WHEN D.C_SEC_VAR_CODE LIKE 'HG%' and trim(A.C_HGLL) is not null THEN
       TO_NUMBER(A.C_HGLL) ELSE 0 END AS N_HGLL_TD,--交易流水回购利率STORY #64491
       0 AS N_REF_RATE, --参考基准利率
       A.N_INCOME as N_TD_INCOME,
       ' ' as C_SEC_CODE_I,
       ' ' as C_IVT_CLSS_I,
       ' ' as C_TD_ATTR_I,
       0 as N_TD_AMOUNT_I,
       0 as N_TD_MONEY_I,
       '' as C_DV_SETT,
       A.D_SETT_FIRST,
       A.C_CA_CODE_SETT_FIRST,
       A.N_SETT_MONEY_FIRST,
       A.N_SETT_MONEY_DUE,
       A.N_SETT_MONEY_FACT,
       A.D_SETT_DUE,
       A.C_CA_CODE_SETT_DUE,
       A.D_SETT_FACT,
       (CASE
         WHEN A.C_DV_TYPE_SUB = 'HGJY_DQ' THEN
          H.D_TRADE
         ELSE
          A.D_TRADE
       END) AS D_BIZ_FIRST,
       a.C_CA_CODE_BAIL,
       a.C_CA_CODE_OT,
       a.C_DV_STATE,
       a.C_OPEN_ADDR,
       a.C_OPEN_ACC_NO,
       a.C_OPEN_ACC_NAME,
       NVL(N_TD_YHS, 0) AS N_TD_YHS,
       NVL(N_TD_JSF, 0) AS N_TD_JSF,
       NVL(N_TD_GHF, 0) AS N_TD_GHF,
       NVL(N_TD_ZGF, 0) AS N_TD_ZGF,
       NVL(N_TD_JSFWF, 0) AS N_TD_JSFWF,
       NVL(N_TD_FEE, 0) AS N_TD_FEE,
       NVL(N_BK_HHF, 0) as N_BK_HHF,
       NVL(N_STFXJ, 0) AS N_STFXJ,
       NVL(N_TD_COMM, 0) AS N_TD_COMM,
       0 as N_RGF,
       0 as N_SGF,
       0 as N_SHF,
       NVL(C.N_QTF,0) AS N_QTF,
       NVL(N_TD_YF_COMM,0) AS N_TD_YF_COMM,
       A.D_TD_BACK,
       a.N_RATE,
       A.C_SETT_ORG,
       A.C_PORT_CODE_SUB,
       ' ' AS C_CXS_NAME,
       A.N_TD_MONEY_PORT AS N_TD_MONEY_LOCL,
     (CASE
         WHEN D.c_sec_var_code like 'ZQ%' THEN
          A.N_PAWN_MONEY
         ELSE
          0
       END) AS N_PAWN_MONEY,
     A.C_SSTD_WAY as C_SS_CHAN,
     A.D_APPLY,
     A.C_DEVALUE_STAGE,
	   A.C_ORG_CODE,--STORY #121486
       A.C_DATA_IDF,
       A.C_UPDATE_TIME,
       A.C_UPDATE_BY,
       A.C_CHECK_BY,
       A.C_CHECK_TIME,
       TO_CHAR(SYSDATE, 'yyyyMMdd HH24:mi:ss') AS C_TIMESTAMP
  FROM T_D_AC_TRADE_IVT A
  LEFT JOIN (SELECT C_IDEN_RELA,
                    NVL(SUM(CASE
                              WHEN C_FEE_CODE = 'ZQL_YHS' THEN
                               NVL(N_FEE_MONEY,0) ELSE 0
                            END),
                        0) AS N_TD_YHS,
                    NVL(SUM(CASE
                              WHEN C_FEE_CODE = 'ZQL_JSF' OR C_FEE_CODE = 'ZQL_JSOF' THEN
                               NVL(N_FEE_MONEY,0) ELSE 0
                            END),
                        0) AS N_TD_JSF,
                    NVL(SUM(CASE
                              WHEN C_FEE_CODE = 'ZQL_GHF' THEN
                               NVL(N_FEE_MONEY,0) ELSE 0
                            END),
                        0) AS N_TD_GHF,
                    NVL(SUM(CASE
                              WHEN C_FEE_CODE = 'ZQL_ZGF' THEN
                               NVL(N_FEE_MONEY,0) ELSE 0
                            END),
                        0) AS N_TD_ZGF,
                    NVL(SUM(CASE
                              WHEN C_FEE_CODE IN ('ZQL_JSFWF' , 'ZQL_JSUF' , 'ZQL_JSFWF_SQS', 'ZQL_JSFWF_HG' , 'ZQL_JSFWF_SQS_HG') THEN
                               NVL(N_FEE_MONEY,0) ELSE 0
                            END),
                        0) AS N_TD_JSFWF, --交易所的结算费或者银行间的结算服务费
                    NVL(SUM(CASE
                              WHEN C_FEE_CODE IN ('ZQL_JYF','ZQL_JYSXF','ZQL_JYSXF_SQS','ZQL_YHSXF','ZQL_JYSXF_HG') THEN
                               NVL(N_FEE_MONEY,0) ELSE 0
                            END),
                        0) AS N_TD_FEE, --交易所的交易费或者银行间的交易手续费
                    NVL(SUM(CASE
                              WHEN C_FEE_CODE = 'ZQL_FXJ' THEN
                               NVL(N_FEE_MONEY,0) ELSE 0
                            END),
                        0) AS N_STFXJ,
                    NVL(SUM(CASE
                              WHEN C_FEE_CODE IN ('YJL_JYJ','ZQL_JSDLYJ_HG') THEN
                               NVL(N_FEE_MONEY,0) ELSE 0
                            END),
                        0) AS N_TD_COMM,
                    NVL(SUM(CASE
                              WHEN C_FEE_CODE = 'QTL_HKF' THEN
                               NVL(N_FEE_MONEY,0) ELSE 0
                            END),
                        0) AS N_BK_HHF,
                    NVL(SUM(CASE
                              WHEN C_FEE_CODE = 'YFL_YJ' THEN
                               NVL(N_FEE_MONEY,0) ELSE 0
                            END),
                        0) AS N_TD_YF_COMM,
                    NVL(SUM(CASE
                              WHEN C_FEE_CODE = 'ZQL_QTF' THEN
                               NVL(N_FEE_MONEY,0) ELSE 0
                            END),
                        0) AS N_QTF
               FROM T_D_AC_TRADE_IVT_FEE
              GROUP BY C_IDEN_RELA) C
    ON A.C_IDEN = C.C_IDEN_RELA
  LEFT JOIN T_P_SV_SEC_BASE D
    ON A.C_SEC_CODE = D.C_SEC_CODE
  LEFT JOIN (SELECT C_PORT_CODE, C_ASS_CODE FROM T_P_AB_PORT) E
    ON A.C_PORT_CODE = E.C_PORT_CODE
  /*LEFT JOIN (SELECT F1.TRADEDATE,
                    F1.SECURITYID,
                    F2.C_T_CODE,
                    F1.EXECID,
                    F1.PRICE
               FROM T_D_OD_API F1
               LEFT JOIN (SELECT C_T_CODE, C_S_CODE
                           FROM T_V_D_GROUP_DETAIL
                          WHERE C_GROUP_CODE = 'API'
                            AND N_CHECK_STATE = 1) F2
               LEFT JOIN (SELECT f11.C_T_CODE, f11.C_S_CODE
                           FROM T_V_D_GROUP_DETAIL f11, T_V_D_GROUP f12
                           WHERE f12.C_DV_SCENE = 'SCENE_EX'
                           AND f11.C_GROUP_CODE = f12.C_GROUP_CODE
                           AND f11.N_CHECK_STATE = 1
                           AND f12.N_CHECK_STATE = 1) F2 --BUG #236086
                 ON F1.FUNDNAME = F2.C_S_CODE
              WHERE MKTINDCT IN ('9', '10') and f1.state in ('0', '1')) F
    ON A.C_PORT_CODE = F.C_T_CODE
   AND A.C_TD_NO = F.EXECID*/
  LEFT JOIN T_P_AB_TD_CHAN G
    ON A.C_TD_CHAN_CODE = G.C_TD_CHAN_CODE
   AND A.C_MKT_CODE = G.C_MKT_CODE
   AND G.C_DV_CHAN_TYPE = 'CHAN_ORG'
   AND G.N_CHECK_STATE = 1
   LEFT JOIN  (SELECT MAX(C_ORG_NAME) AS C_ORG_NAME,C_ORG_CODE FROM T_P_BI_ORG WHERE N_CHECK_STATE=1 GROUP BY C_ORG_CODE) ORG
   ON ORG.C_ORG_CODE=A.C_TD_CHAN_CODE
   LEFT JOIN  (SELECT MAX(C_ORG_NAME) AS C_ORG_NAME,C_ORG_CODE FROM T_P_BI_ORG WHERE N_CHECK_STATE=1 GROUP BY C_ORG_CODE) ORG1
   ON ORG1.C_ORG_CODE=A.C_ORG_CODE
  LEFT JOIN (SELECT C_IDEN,
                    D_TRADE,
                    C_TD_TYPE,
                    N_CHECK_STATE,
                    D_SETT_FIRST,
                    N_INCOME,
                    N_TD_MONEY,C_HGLL,N_TD_PRICE
               FROM T_D_AC_TRADE_IVT
              WHERE C_TD_TYPE in ('HGJY', 'HGJY_GP')
                AND N_CHECK_STATE = 1) H
    ON A.C_IDEN_SUB = H.C_IDEN
 WHERE A.N_CHECK_STATE = 1
   /*AND A.C_TD_TYPE in ('GPJY',
                       'ZQJY',
                       'JJJY',
                       'QZJY',
                       'HGJY',
                       'HGJY_GP',
                       'QHJY',
                       'QQJY',
                       'CNSS',
                       'RZRQ',
                       'ZRT')
   and d.n_check_state = 1*/
--新股、新债
union all
SELECT 'A' || A.c_Iden AS N_ID,
        CASE WHEN C_IDEN_SUB ='[root]' THEN
      C_IDEN_SUB
    ELSE
       'A' || A.C_IDEN_SUB
     END AS N_ID_SUB,
       A.C_PORT_CODE AS C_PORT_CODE,
       E.C_ASS_CODE AS C_ASSET_CODE,
       NVL(A.C_TD_NO, ' ') AS C_TD_NUMBER,
       A.C_TD_TYPE AS C_TD_TYPE,
       A.D_TRADE AS D_BIZ,
       A.D_TRADE AS D_TRADE_DATE,
       NULL AS D_TRADE_OUTER, --STORY #68781
       A.C_DV_TYPE_SUB AS C_DV_TYPE_SUB,
       A.C_SEC_CODE,
       ' ' as C_SEC_CODE_TAG,
       ' ' as C_DV_VAR_DUR,
       D.C_SEC_VAR_CODE AS C_SEC_VAR_MX,
       (CASE
         WHEN D.C_SEC_VAR_CODE LIKE 'CK%' THEN
          D.N_AMOUNT_HD
         WHEN D.C_SEC_VAR_CODE LIKE 'JJ%' THEN
          D.N_RATIO
         WHEN D.C_SEC_VAR_CODE LIKE 'LC%' THEN
          D.N_RATIO
         WHEN D.C_SEC_VAR_CODE LIKE 'HG%' THEN
          TO_NUMBER(NVL(D.C_DV_QUT_MOD,0))
         WHEN D.C_SEC_VAR_CODE LIKE 'CJ%' THEN
          TO_NUMBER(NVL(D.C_DV_QUT_MOD,0))
         ELSE
          NULL
       END) AS N_NH_DAYS,--20170704 利率年化天数
       A.c_Dt_Code,
       D.C_DC_CODE AS C_CURY_CODE,
       D.C_MKT_CODE,
       A.C_DV_PLAT AS C_TD_PLAT,
       A.C_TD_CHAN_CODE AS C_TDCHAN_CODE,
       A.C_SH_ACC_CODE AS C_TD_CODE,
       ' ' AS C_IM_CODE, --投资经理
       A.C_DV_INVEST_CLS AS C_IVT_CLSS,
       ' ' AS C_HLD_ATTR, --持有属性
       A.C_DTA_CODE AS C_TD_ATTR,
       A.C_DV_ISSUE_MODE AS C_ML_ATTR, --受限流通类别
       G.C_TD_CHAN_NAME AS C_TD_RELAPARTY, --交易对手方
     ' ' AS C_SETT_MODE,--交收方式 STORY #68340
       A.N_TD_AMOUNT,
       A.N_TD_PRICE,
       A.N_TD_MONEY,
       null as N_Days,
       NULL AS N_HG_RATE,
     0 AS N_HGLL_TD,--交易流水回购利率STORY #64491
       0 AS N_REF_RATE, --参考基准利率
       0 as N_TD_INCOME,
       ' ' as C_SEC_CODE_I,
       ' ' as C_IVT_CLSS_I,
       ' ' as C_TD_ATTR_I,
       0 as N_TD_AMOUNT_I,
       0 as N_TD_MONEY_I,
       '' as C_DV_SETT,
       null as D_SETT_FIRST,
       ' ' as C_CA_CODE_SETT_FIRST,
       0 as N_SETT_MONEY_FIRST,
       A.N_TD_MONEY AS N_SETT_MONEY_DUE,
       A.N_SETT_MONEY_DUE as N_SETT_MONEY_FACT,
       A.D_SETT_DUE,
       A.C_CA_CODE_SETT_DUE,
       A.D_SETT_FACT,
       A.D_TRADE AS D_BIZ_FIRST,
       ' ' as C_CA_CODE_BAIL,
       ' ' as C_CA_CODE_OT,
       a.C_DV_STATE,
       a.C_OPEN_ADDR,
       a.C_OPEN_ACC_NO,
       a.C_OPEN_ACC_NAME,
       0 AS N_TD_YHS,
       0 AS N_TD_JSF,
       0 AS N_TD_GHF,
       0 AS N_TD_ZGF,
       0 AS N_TD_JSFWF,
       0 AS N_TD_FEE,
       0 as N_BK_HHF,
       0 AS N_STFXJ,
     NVL(N_TD_COMM, 0) AS N_TD_COMM,
       0 as N_RGF,
       0 as N_SGF,
       0 as N_SHF,
       0 as N_QTF,
     NVL(N_TD_YF_COMM,0) AS N_TD_YF_COMM,
       null as D_TD_BACK,
       0 as N_RATE,
       ' ' as C_SETT_ORG,
       A.C_PORT_CODE_SUB,
       A.C_CXS_NAME,
       0 as N_TD_MONEY_LOCL,
     0 as N_PAWN_MONEY,
     ' ' as C_SS_CHAN,
     null as D_APPLY,
       A.C_DATA_IDF,
       ' ' as C_DEVALUE_STAGE,
	   '' as C_ORG_CODE,--STORY #121486
       A.C_UPDATE_TIME,
       A.C_UPDATE_BY,
       A.C_CHECK_BY,
       A.C_CHECK_TIME,
       TO_CHAR(SYSDATE, 'yyyyMMdd HH24:mi:ss') AS C_TIMESTAMP
  FROM T_D_AC_TRADE_IPO A
  /*增加费用表关联，STORY76325*/
  LEFT JOIN (SELECT C_IDEN_RELA,
                    NVL(SUM(CASE
                              WHEN C_FEE_CODE = 'YJL_JYJ' THEN
                               NVL(N_FEE_MONEY,0) ELSE 0
                            END),
                        0) AS N_TD_COMM,
                    NVL(SUM(CASE
                              WHEN C_FEE_CODE = 'YFL_YJ' THEN
                               NVL(N_FEE_MONEY,0) ELSE 0
                            END),
                        0) AS N_TD_YF_COMM
               FROM T_D_AC_TRADE_IPO_FEE
              GROUP BY C_IDEN_RELA) C
    ON A.C_IDEN = C.C_IDEN_RELA
  LEFT JOIN T_P_SV_SEC_BASE D
    ON A.C_SEC_CODE = D.C_SEC_CODE
  LEFT JOIN (SELECT C_PORT_CODE, C_ASS_CODE FROM T_P_AB_PORT) E
    ON A.C_PORT_CODE = E.C_PORT_CODE
    LEFT JOIN T_P_AB_TD_CHAN G
    ON A.C_TD_CHAN_CODE = G.C_TD_CHAN_CODE
   AND A.C_MKT_CODE = G.C_MKT_CODE
   AND G.C_DV_CHAN_TYPE = 'CHAN_ORG'
   AND G.N_CHECK_STATE = 1
 WHERE A.N_CHECK_STATE = 1
   AND (D.C_SEC_VAR_CODE LIKE 'GP%' or D.C_SEC_VAR_CODE LIKE 'ZQ%')
  /* and d.n_check_state = 1*/
--场外申赎
UNION ALL
SELECT 'B' || A.c_Iden AS N_ID,
    CASE WHEN C_IDEN_SUB ='[root]' THEN
      C_IDEN_SUB
    ELSE
       'B' || A.C_IDEN_SUB
     END AS N_ID_SUB,
       A.C_PORT_CODE AS C_PORT_CODE,
       E.C_ASS_CODE AS C_ASSET_CODE,
       NVL(A.C_TD_NO, ' ') AS C_TD_NUMBER,
       A.C_TD_TYPE AS C_TD_TYPE,
       A.D_TRADE AS D_BIZ,
       A.D_TRADE AS D_TRADE_DATE,
       NULL AS D_TRADE_OUTER, --STORY #68781
       A.C_DV_TYPE_SUB AS C_DV_TYPE_SUB,
       A.C_SEC_CODE,
       ' ' AS C_SEC_CODE_TAG,
       ' ' AS C_DV_VAR_DUR,
       D.C_SEC_VAR_CODE AS C_SEC_VAR_MX,
       (CASE
         WHEN D.C_SEC_VAR_CODE LIKE 'CK%' THEN
          D.N_AMOUNT_HD
         WHEN D.C_SEC_VAR_CODE LIKE 'JJ%' THEN
          D.N_RATIO
         WHEN D.C_SEC_VAR_CODE LIKE 'LC%' THEN
          D.N_RATIO
         WHEN D.C_SEC_VAR_CODE LIKE 'HG%' THEN
          TO_NUMBER(NVL(D.C_DV_QUT_MOD,0))
         WHEN D.C_SEC_VAR_CODE LIKE 'CJ%' THEN
          TO_NUMBER(NVL(D.C_DV_QUT_MOD,0))
         ELSE
          NULL
       END) AS N_NH_DAYS,--20170704 利率年化天数
       A.c_Dt_Code,
       D.C_DC_CODE AS C_CURY_CODE,
       D.C_MKT_CODE,
       ' ' AS C_TD_PLAT,
       A.C_TD_CHAN_CODE AS C_TDCHAN_CODE,
       A.C_SH_ACC_CODE AS C_TD_CODE,
       ' ' AS C_IM_CODE, --投资经理
       A.C_DV_INVEST_CLS AS C_IVT_CLSS,
       ' ' AS C_HLD_ATTR, --持有属性
       A.C_DTA_CODE AS C_TD_ATTR,
       A.C_DV_ISSUE_MODE AS C_ML_ATTR, --受限流通类别
       G.C_TD_CHAN_NAME AS C_TD_RELAPARTY, --交易对手方
     ' ' AS C_SETT_MODE,--交收方式 STORY #68340
       A.N_TD_AMOUNT,
       A.N_TD_PRICE,
       A.N_TD_MONEY,
       (case
         when a.c_sec_var_code like 'HG%' then
          to_number(nvl(d.c_dv_var_dur, 0))
       end) as N_Days,
       NULL AS N_HG_RATE,
     0 AS N_HGLL_TD,--交易流水回购利率STORY #64491
       0 AS N_REF_RATE, --参考基准利率
       N_INCOME as N_TD_INCOME,
       ' ' as C_SEC_CODE_I,
       ' ' as C_IVT_CLSS_I,
       ' ' as C_TD_ATTR_I,
       0 as N_TD_AMOUNT_I,
       0 as N_TD_MONEY_I,
       '' as C_DV_SETT,
       NULL AS D_SETT_FIRST,
       ' ' AS C_CA_CODE_SETT_FIRST,
       0 AS N_SETT_MONEY_FIRST,
       A.N_SETT_MONEY_DUE,
       0 AS N_SETT_MONEY_FACT,
       A.D_SETT_DUE,
       A.C_CA_CODE_SETT_DUE,
       A.D_SETT_FACT,
       A.D_TRADE AS D_BIZ_FIRST,
       ' ' AS C_CA_CODE_BAIL,
       ' ' AS C_CA_CODE_OT,
       a.C_DV_STATE,
       a.C_OPEN_ADDR,
       a.C_OPEN_ACC_NO,
       a.C_OPEN_ACC_NAME,
       0 AS N_TD_YHS,
       0 AS N_TD_JSF,
       0 AS N_TD_GHF,
       0 AS N_TD_ZGF,
       0 AS N_TD_JSFWF,
       0 AS N_TD_FEE,
       0 as N_BK_HHF,
       0 AS N_STFXJ,
       0 AS N_TD_COMM,
       NVL(XSL_RGF, 0) as N_RGF,
       NVL(XSL_SGF, 0) as N_SGF,
       NVL(XSL_SHF, 0) as N_SHF,
       0 AS N_QTF,
       0 AS N_TD_YF_COMM,
       NULL AS D_TD_BACK,
       0 AS N_RATE,
       ' ' AS C_SETT_ORG,
       A.C_PORT_CODE_SUB,
       ' ' AS C_CXS_NAME,
       0 AS N_TD_MONEY_LOCL,
     0 as N_PAWN_MONEY,
     ' ' as C_SS_CHAN,
     null as D_APPLY,
       A.C_DATA_IDF,
       ' ' as C_DEVALUE_STAGE,
	   '' as C_ORG_CODE,--STORY #121486
       A.C_UPDATE_TIME,
       A.C_UPDATE_BY,
       A.C_CHECK_BY,
       A.C_CHECK_TIME,
       TO_CHAR(SYSDATE, 'yyyyMMdd HH24:mi:ss') AS C_TIMESTAMP
  FROM T_D_AC_TRADE_SALE A
  LEFT JOIN (SELECT C_IDEN_RELA,
                    NVL(SUM(CASE
                              WHEN C_FEE_CODE = 'XSL_RGF' THEN
                               NVL(N_FEE_MONEY,0) ELSE 0
                            END),
                        0) AS XSL_RGF,
                    NVL(SUM(CASE
                              WHEN C_FEE_CODE = 'XSL_SGF' THEN
                               NVL(N_FEE_MONEY,0) ELSE 0
                            END),
                        0) AS XSL_SGF,
                    NVL(SUM(CASE
                              WHEN C_FEE_CODE = 'XSL_SHF' THEN
                               NVL(N_FEE_MONEY,0) ELSE 0
                            END),
                        0) AS XSL_SHF
               FROM T_D_AC_TRADE_SALE_FEE
              GROUP BY C_IDEN_RELA) C
    ON A.C_IDEN = C.C_IDEN_RELA
  LEFT JOIN T_P_SV_SEC_BASE D
    ON A.C_SEC_CODE = D.C_SEC_CODE
  LEFT JOIN (SELECT C_PORT_CODE, C_ASS_CODE FROM T_P_AB_PORT) E
    ON A.C_PORT_CODE = E.C_PORT_CODE
    LEFT JOIN T_P_AB_TD_CHAN G
    ON A.C_TD_CHAN_CODE = G.C_TD_CHAN_CODE
   AND A.C_MKT_CODE = G.C_MKT_CODE
   AND G.C_DV_CHAN_TYPE = 'CHAN_ORG'
   AND G.N_CHECK_STATE = 1
 WHERE A.N_CHECK_STATE = 1
   AND A.C_TD_TYPE = 'CWSS'
  /* and d.n_check_state = 1*/
--证券流通
union all
SELECT 'F' || A.c_Iden AS N_ID,
       '' as N_ID_SUB,
       A.C_PORT_CODE AS C_PORT_CODE,
       E.C_ASS_CODE AS C_ASSET_CODE,
       NVL(A.C_TD_NO, ' ') AS C_TD_NUMBER,
       A.C_TD_TYPE AS C_TD_TYPE,
       A.D_TRADE AS D_BIZ,
       A.D_TRADE AS D_TRADE_DATE,
       NULL AS D_TRADE_OUTER, --STORY #68781
       ' ' as C_DV_TYPE_SUB,
       A.C_SEC_CODE,
       ' ' as C_SEC_CODE_TAG,
       ' ' as C_DV_VAR_DUR,
       D.C_SEC_VAR_CODE AS C_SEC_VAR_MX,
       (CASE
         WHEN D.C_SEC_VAR_CODE LIKE 'CK%' THEN
          D.N_AMOUNT_HD
         WHEN D.C_SEC_VAR_CODE LIKE 'JJ%' THEN
          D.N_RATIO
         WHEN D.C_SEC_VAR_CODE LIKE 'LC%' THEN
          D.N_RATIO
         WHEN D.C_SEC_VAR_CODE LIKE 'HG%' THEN
          TO_NUMBER(NVL(D.C_DV_QUT_MOD,0))
         WHEN D.C_SEC_VAR_CODE LIKE 'CJ%' THEN
          TO_NUMBER(NVL(D.C_DV_QUT_MOD,0))
         ELSE
          NULL
       END) AS N_NH_DAYS,--20170704 利率年化天数
       A.c_Dt_Code,
       D.C_DC_CODE AS C_CURY_CODE,
       D.C_MKT_CODE,
       ' ' as C_TD_PLAT,
       A.C_TD_CHAN_CODE AS C_TDCHAN_CODE,
       A.C_SH_ACC_CODE AS C_TD_CODE,
       ' ' AS C_IM_CODE, --投资经理
       A.C_DV_INVEST_CLS AS C_IVT_CLSS,
       ' ' AS C_HLD_ATTR, --持有属性
       A.C_DTA_CODE AS C_TD_ATTR,
       A.C_DV_ISSUE_MODE AS C_ML_ATTR, --受限流通类别
       G.C_TD_CHAN_NAME AS C_TD_RELAPARTY, --交易对手方
     ' ' AS C_SETT_MODE,--交收方式 STORY #68340
       A.N_TD_AMOUNT,
       0 as N_TD_PRICE,
       0 as N_TD_MONEY,
       (case
         when a.c_sec_var_code like 'HG%' then
          to_number(nvl(d.c_dv_var_dur, 0))
       end) as N_Days,
       NULL AS N_HG_RATE,
     0 AS N_HGLL_TD,--交易流水回购利率STORY #64491
       0 AS N_REF_RATE, --参考基准利率
       0 as N_TD_INCOME,
       ' ' as C_SEC_CODE_I,
       ' ' as C_IVT_CLSS_I,
       ' ' as C_TD_ATTR_I,
       0 as N_TD_AMOUNT_I,
       0 as N_TD_MONEY_I,
       '' as C_DV_SETT,
       null as D_SETT_FIRST,
       ' ' as C_CA_CODE_SETT_FIRST,
       0 as N_SETT_MONEY_FIRST,
       0 as N_SETT_MONEY_DUE,
       0 as N_SETT_MONEY_FACT,
       null as D_SETT_DUE,
       ' ' as C_CA_CODE_SETT_DUE,
       null as D_SETT_FACT,
       A.D_TRADE AS D_BIZ_FIRST,
       ' ' as C_CA_CODE_BAIL,
       ' ' as C_CA_CODE_OT,
       ' ' as C_DV_STATE,
       ' ' as C_OPEN_ADDR,
       ' ' as C_OPEN_ACC_NO,
       ' ' as C_OPEN_ACC_NAME,
       0 AS N_TD_YHS,
       0 AS N_TD_JSF,
       0 AS N_TD_GHF,
       0 AS N_TD_ZGF,
       0 AS N_TD_JSFWF,
       0 AS N_TD_FEE,
       0 as N_BK_HHF,
       0 AS N_STFXJ,
       0 AS N_TD_COMM,
       0 as N_RGF,
       0 as N_SGF,
       0 as N_SHF,
       0 AS N_QTF,
       0 AS N_TD_YF_COMM,
       null as D_TD_BACK,
       0 as N_RATE,
       ' ' as C_SETT_ORG,
       ' ' as C_PORT_CODE_SUB,
       ' ' AS C_CXS_NAME,
       0 as N_TD_MONEY_LOCL,
     0 as N_PAWN_MONEY,
     ' ' as C_SS_CHAN,
     null as D_APPLY,
       A.C_DATA_IDF,
       ' ' as C_DEVALUE_STAGE,
	   '' as C_ORG_CODE,--STORY #121486
       A.C_UPDATE_TIME,
       A.C_UPDATE_BY,
       A.C_CHECK_BY,
       A.C_CHECK_TIME,
       TO_CHAR(SYSDATE, 'yyyyMMdd HH24:mi:ss') AS C_TIMESTAMP
  FROM T_D_AC_TRADE_SL A
  LEFT JOIN T_P_SV_SEC_BASE D
    ON A.C_SEC_CODE = D.C_SEC_CODE
  LEFT JOIN (SELECT C_PORT_CODE, C_ASS_CODE FROM T_P_AB_PORT) E
    ON A.C_PORT_CODE = E.C_PORT_CODE
    LEFT JOIN T_P_AB_TD_CHAN G
    ON A.C_TD_CHAN_CODE = G.C_TD_CHAN_CODE
   AND A.C_MKT_CODE = G.C_MKT_CODE
   AND G.C_DV_CHAN_TYPE = 'CHAN_ORG'
   AND G.N_CHECK_STATE = 1
 WHERE A.N_CHECK_STATE = 1
   AND (D.C_SEC_VAR_CODE LIKE 'GP%' or D.C_SEC_VAR_CODE LIKE 'ZQ%')
  /* and d.n_check_state = 1*/
--权证行权，期权行权
union all
SELECT 'D' || A.c_Iden AS N_ID,
       '' as N_ID_SUB,
       A.C_PORT_CODE AS C_PORT_CODE,
       E.C_ASS_CODE AS C_ASSET_CODE,
       NVL(A.C_TD_NO, ' ') AS C_TD_NUMBER,
       A.C_TD_TYPE AS C_TD_TYPE,
       A.D_TRADE AS D_BIZ,
       A.D_TRADE AS D_TRADE_DATE,
       NULL AS D_TRADE_OUTER, --STORY #68781
       ' ' as C_DV_TYPE_SUB,
       A.C_SEC_CODE,
       ' ' as C_SEC_CODE_TAG,
       ' ' as C_DV_VAR_DUR,
       D.C_SEC_VAR_CODE AS C_SEC_VAR_MX,
       (CASE
         WHEN D.C_SEC_VAR_CODE LIKE 'CK%' THEN
          D.N_AMOUNT_HD
         WHEN D.C_SEC_VAR_CODE LIKE 'JJ%' THEN
          D.N_RATIO
         WHEN D.C_SEC_VAR_CODE LIKE 'LC%' THEN
          D.N_RATIO
         WHEN D.C_SEC_VAR_CODE LIKE 'HG%' THEN
          TO_NUMBER(NVL(D.C_DV_QUT_MOD,0))
         WHEN D.C_SEC_VAR_CODE LIKE 'CJ%' THEN
          TO_NUMBER(NVL(D.C_DV_QUT_MOD,0))
         ELSE
          NULL
       END) AS N_NH_DAYS,--20170704 利率年化天数
       A.c_Dt_Code,
       D.C_DC_CODE AS C_CURY_CODE,
       D.C_MKT_CODE,
       ' ' AS C_TD_PLAT,
       A.C_TD_CHAN_CODE AS C_TDCHAN_CODE,
       A.C_SH_ACC_CODE AS C_TD_CODE,
       ' ' AS C_IM_CODE, --投资经理
       A.C_DV_INVEST_CLS AS C_IVT_CLSS,
       ' ' AS C_HLD_ATTR, --持有属性
       A.C_DTA_CODE AS C_TD_ATTR,
       A.C_DV_ISSUE_MODE AS C_ML_ATTR, --受限流通类别
       'NA' AS C_TD_RELAPARTY, --交易对手方
     ' ' AS C_SETT_MODE,--交收方式 STORY #68340
       A.N_TD_AMOUNT,
       A.N_TD_PRICE,
       A.N_TD_MONEY,
       null as N_Days,
       NULL AS N_HG_RATE,
     0 AS N_HGLL_TD,--交易流水回购利率STORY #64491
       0 AS N_REF_RATE, --参考基准利率
       0 as N_TD_INCOME,
       a.C_SEC_CODE_I,
       a. C_DV_INVEST_CLS_I AS C_IVT_CLSS_I,
       a.C_DTA_CODE_I AS C_TD_ATTR_I,
       a.N_TD_AMOUNT_I,
       a.N_TD_MONEY_I,
       '' as C_DV_SETT,
       null as D_SETT_FIRST,
       ' ' as C_CA_CODE_SETT_FIRST,
       0 as N_SETT_MONEY_FIRST,
       A.N_SETT_MONEY_DUE,
       A.N_SETT_MONEY_FACT,
       A.D_SETT_DUE,
       A.C_CA_CODE_SETT_DUE,
       A.D_SETT_FACT,
       A.D_TRADE AS D_BIZ_FIRST,
       ' ' as C_CA_CODE_BAIL,
       ' ' as C_CA_CODE_OT,
       a.C_DV_STATE,
       ' ' as C_OPEN_ADDR,
       ' ' as C_OPEN_ACC_NO,
       ' ' as C_OPEN_ACC_NAME,
       0 AS N_TD_YHS,
       NVL(N_TD_JSF, 0) AS N_TD_JSF,
       NVL(N_TD_GHF, 0) AS N_TD_GHF,
       0 AS N_TD_ZGF,
       NVL(N_TD_JSFWF, 0) AS N_TD_JSFWF,
       NVL(N_TD_FEE, 0) AS N_TD_FEE,
       0 as N_BK_HHF,
       0 AS N_STFXJ,
       NVL(N_TD_COMM, 0) AS N_TD_COMM,
       0 as N_RGF,
       0 as N_SGF,
       0 as N_SHF,
       NVL(C.N_QTF,0) AS N_QTF,
       0 AS N_TD_YF_COMM,
       A.D_TD_BACK,
       0 as N_RATE,
       ' ' as C_SETT_ORG,
       ' ' as C_PORT_CODE_SUB,
       ' ' AS C_CXS_NAME,
       0 as N_TD_MONEY_LOCL,
     0 as N_PAWN_MONEY,
     ' ' as C_SS_CHAN,
     null as D_APPLY,
       A.C_DATA_IDF,
       ' ' as C_DEVALUE_STAGE,
	   A.C_ORG_CODE,--STORY #121486
       A.C_UPDATE_TIME,
       A.C_UPDATE_BY,
       A.C_CHECK_BY,
       A.C_CHECK_TIME,
       TO_CHAR(SYSDATE, 'yyyyMMdd HH24:mi:ss') AS C_TIMESTAMP
  FROM T_D_AC_TRADE_EX A
  LEFT JOIN (SELECT C_IDEN_RELA,
                    NVL(SUM(CASE
                              WHEN C_FEE_CODE = 'ZQL_GHF' THEN
                               NVL(N_FEE_MONEY,0) ELSE 0
                            END),
                        0) AS N_TD_GHF,
                    NVL(SUM(CASE
                              WHEN C_FEE_CODE = 'ZQL_JGSXF' THEN
                               NVL(N_FEE_MONEY,0) ELSE 0
                            END),
                        0) AS N_TD_JSF,
                    NVL(SUM(CASE
                              WHEN C_FEE_CODE = 'ZQL_JYSXF' or
                                   C_FEE_CODE = 'ZQL_JSUF' THEN
                               NVL(N_FEE_MONEY,0) ELSE 0
                            END),
                        0) AS N_TD_JSFWF,
                    NVL(SUM(CASE
                              WHEN C_FEE_CODE = 'ZQL_JGYJ' THEN
                               NVL(N_FEE_MONEY,0) ELSE 0
                            END),
                        0) AS N_TD_COMM,
                    NVL(SUM(CASE
                              WHEN C_FEE_CODE = 'ZQL_JYYJ' OR
                                   C_FEE_CODE = 'ZQL_YHSXF' THEN
                               NVL(N_FEE_MONEY,0) ELSE 0
                            END),
                        0) AS N_TD_FEE,
                    NVL(SUM(CASE
                              WHEN C_FEE_CODE = 'ZQL_QTF' THEN
                               NVL(N_FEE_MONEY,0) ELSE 0
                            END),
                        0) AS N_QTF
               FROM T_D_AC_TRADE_SALE_FEE
              GROUP BY C_IDEN_RELA) C
    ON A.C_IDEN = C.C_IDEN_RELA
  LEFT JOIN T_P_SV_SEC_BASE D
    ON A.C_SEC_CODE = D.C_SEC_CODE
  LEFT JOIN (SELECT C_PORT_CODE, C_ASS_CODE FROM T_P_AB_PORT) E
    ON A.C_PORT_CODE = E.C_PORT_CODE
 WHERE A.N_CHECK_STATE = 1
   AND A.C_TD_TYPE in ('QQXQ', 'QZXQ')
   /*and d.n_check_state = 1*/
--证券送配
UNION ALL
SELECT 'E' || A.c_Iden AS N_ID,
       '' as N_ID_SUB,
       A.C_PORT_CODE AS C_PORT_CODE,
       E.C_ASS_CODE AS C_ASSET_CODE,
       NVL(A.C_TD_NO, ' ') AS C_TD_NUMBER,
       A.C_TD_TYPE AS C_TD_TYPE,
       A.D_TRADE AS D_BIZ,
       A.D_TRADE AS D_TRADE_DATE,
       NULL AS D_TRADE_OUTER, --STORY #68781
       ' ' as C_DV_TYPE_SUB,
       A.C_SEC_CODE,
       ' ' as C_SEC_CODE_TAG,
       ' ' as C_DV_VAR_DUR,
       D.C_SEC_VAR_CODE AS C_SEC_VAR_MX,
       (CASE
         WHEN D.C_SEC_VAR_CODE LIKE 'CK%' THEN
          D.N_AMOUNT_HD
         WHEN D.C_SEC_VAR_CODE LIKE 'JJ%' THEN
          D.N_RATIO
         WHEN D.C_SEC_VAR_CODE LIKE 'LC%' THEN
          D.N_RATIO
         WHEN D.C_SEC_VAR_CODE LIKE 'HG%' THEN
          TO_NUMBER(NVL(D.C_DV_QUT_MOD,0))
         WHEN D.C_SEC_VAR_CODE LIKE 'CJ%' THEN
          TO_NUMBER(NVL(D.C_DV_QUT_MOD,0))
         ELSE
          NULL
       END) AS N_NH_DAYS,--20170704 利率年化天数
       A.c_Dt_Code,
       D.C_DC_CODE AS C_CURY_CODE,
       D.C_MKT_CODE,
       A.C_DV_PLAT AS C_TD_PLAT,
       A.C_TD_CHAN_CODE AS C_TDCHAN_CODE,
       A.C_SH_ACC_CODE AS C_TD_CODE,
       ' ' AS C_IM_CODE, --投资经理
       A.C_DV_INVEST_CLS AS C_IVT_CLSS,
       ' ' AS C_HLD_ATTR, --持有属性
       A.C_DTA_CODE AS C_TD_ATTR,
       A.C_DV_ISSUE_MODE AS C_ML_ATTR, --受限流通类别
       G.C_TD_CHAN_NAME AS C_TD_RELAPARTY, --交易对手方
     ' ' AS C_SETT_MODE,--交收方式 STORY #68340
       A.N_TD_AMOUNT,
       0 as N_TD_PRICE,
       A.N_TD_MONEY,
       (case
         when a.c_sec_var_code like 'HG%' then
          to_number(nvl(d.c_dv_var_dur, 0))
       end) as N_Days,
       NULL AS N_HG_RATE,
     0 AS N_HGLL_TD,--交易流水回购利率STORY #64491
       0 AS N_REF_RATE, --参考基准利率
       0 as N_TD_INCOME,
       A.C_SEC_CODE_I as C_SEC_CODE_I,
       A.C_DV_INVEST_CLS_I as C_IVT_CLSS_I,
       A.C_DTA_CODE_I as C_TD_ATTR_I,
       0 as N_TD_AMOUNT_I,
       0 as N_TD_MONEY_I,
       '' as C_DV_SETT,
       null as D_SETT_FIRST,
       ' ' as C_CA_CODE_SETT_FIRST,
       0 as N_SETT_MONEY_FIRST,
       A.N_SETT_MONEY_DUE,
       A.N_SETT_MONEY_FACT,
       A.D_SETT_DUE,
       A.C_CA_CODE_SETT_DUE,
       A.D_SETT_FACT,
       A.D_TRADE AS D_BIZ_FIRST,
       ' ' as C_CA_CODE_BAIL,
       ' ' as C_CA_CODE_OT,
       a.C_DV_STATE,
       ' ' as C_OPEN_ADDR,
       ' ' as C_OPEN_ACC_NO,
       ' ' as C_OPEN_ACC_NAME,
       0 AS N_TD_YHS,
       0 AS N_TD_JSF,
       0 AS N_TD_GHF,
       0 AS N_TD_ZGF,
       0 AS N_TD_JSFWF,
       0 AS N_TD_FEE,
       0 as N_BK_HHF,
       0 AS N_STFXJ,
       0 AS N_TD_COMM,
       0 as N_RGF,
       0 as N_SGF,
       0 as N_SHF,
       0 AS N_QTF,
       0 AS N_TD_YF_COMM,
       A.D_TD_BACK,
       0 as N_RATE,
       A.C_SETT_ORG,
       A.C_PORT_CODE_SUB,
       ' ' AS C_CXS_NAME,
       0 as N_TD_MONEY_LOCL,
     0 as N_PAWN_MONEY,
     ' ' as C_SS_CHAN,
     null as D_APPLY,
       A.C_DATA_IDF,
        ' ' as C_DEVALUE_STAGE,
	   '' AS C_ORG_CODE,--STORY #121486
       A.C_UPDATE_TIME,
       A.C_UPDATE_BY,
       A.C_CHECK_BY,
       A.C_CHECK_TIME,
       TO_CHAR(SYSDATE, 'yyyyMMdd HH24:mi:ss') AS C_TIMESTAMP
  FROM T_D_AC_TRADE_DS A
  LEFT JOIN T_P_SV_SEC_BASE D
    ON A.C_SEC_CODE = D.C_SEC_CODE
  LEFT JOIN (SELECT C_PORT_CODE, C_ASS_CODE FROM T_P_AB_PORT) E
    ON A.C_PORT_CODE = E.C_PORT_CODE
    LEFT JOIN T_P_AB_TD_CHAN G
    ON A.C_TD_CHAN_CODE = G.C_TD_CHAN_CODE
   AND A.C_MKT_CODE = G.C_MKT_CODE
   AND G.C_DV_CHAN_TYPE = 'CHAN_ORG'
   AND G.N_CHECK_STATE = 1
 WHERE A.N_CHECK_STATE = 1
   AND A.C_TD_TYPE = 'ZQSP'
   /*and d.n_check_state = 1*/
--远期交易
UNION ALL
SELECT 'C' || A.c_Iden AS N_ID,
    CASE WHEN C_IDEN_SUB ='[root]' THEN
      C_IDEN_SUB
    ELSE
       'C' || A.C_IDEN_SUB
     END AS N_ID_SUB,
       A.C_PORT_CODE AS C_PORT_CODE,
       E.C_ASS_CODE AS C_ASSET_CODE,
       NVL(A.C_TD_NO, ' ') AS C_TD_NUMBER,
       A.C_TD_TYPE AS C_TD_TYPE,
       A.D_TRADE AS D_BIZ,
       A.D_TRADE AS D_TRADE_DATE,
       NULL AS D_TRADE_OUTER, --STORY #68781
       A.C_DV_TYPE_SUB AS C_DV_TYPE_SUB,
       A.C_SEC_CODE,
       A.C_SEC_CODE_TAG,
       ' ' as C_DV_VAR_DUR,
       D.C_SEC_VAR_CODE AS C_SEC_VAR_MX,
       (CASE
         WHEN D.C_SEC_VAR_CODE LIKE 'CK%' THEN
          D.N_AMOUNT_HD
         WHEN D.C_SEC_VAR_CODE LIKE 'JJ%' THEN
          D.N_RATIO
         WHEN D.C_SEC_VAR_CODE LIKE 'LC%' THEN
          D.N_RATIO
         WHEN D.C_SEC_VAR_CODE LIKE 'HG%' THEN
          TO_NUMBER(NVL(D.C_DV_QUT_MOD,0))
         WHEN D.C_SEC_VAR_CODE LIKE 'CJ%' THEN
          TO_NUMBER(NVL(D.C_DV_QUT_MOD,0))
         ELSE
          NULL
       END) AS N_NH_DAYS,--20170704 利率年化天数
       A.c_Dt_Code,
       D.C_DC_CODE AS C_CURY_CODE,
       D.C_MKT_CODE,
       A.C_DV_PLAT AS C_TD_PLAT,
       A.C_TD_CHAN_CODE AS C_TDCHAN_CODE,
       A.C_SH_ACC_CODE AS C_TD_CODE,
       ' ' AS C_IM_CODE, --投资经理
       A.C_DV_INVEST_CLS AS C_IVT_CLSS,
       ' ' AS C_HLD_ATTR, --持有属性
       A.C_DTA_CODE AS C_TD_ATTR,
       A.C_DV_ISSUE_MODE AS C_ML_ATTR, --受限流通类别
       G.C_TD_CHAN_NAME AS C_TD_RELAPARTY, --交易对手方
     ' ' AS C_SETT_MODE,--交收方式 STORY #68340
       A.N_TD_AMOUNT,
       A.N_TD_PRICE,
       A.N_TD_MONEY,
       (case
         when a.c_sec_var_code like 'HG%' then
          to_number(nvl(d.c_dv_var_dur, 0))
       end) as N_Days,
       NULL AS N_HG_RATE,
     0 AS N_HGLL_TD,--交易流水回购利率STORY #64491
       0 AS N_REF_RATE, --参考基准利率
       N_INCOME as N_TD_INCOME,
       ' ' as C_SEC_CODE_I,
       ' ' as C_IVT_CLSS_I,
       ' ' as C_TD_ATTR_I,
       0 as N_TD_AMOUNT_I,
       0 as N_TD_MONEY_I,
       A.C_DV_SETT,
       null as D_SETT_FIRST,
       A.C_CA_CODE_SETT_FIRST,
       0 as N_SETT_MONEY_FIRST,
       A.N_SETT_MONEY_DUE,
       0 as N_SETT_MONEY_FACT,
       A.D_SETT_DUE,
       A.C_CA_CODE_SETT_DUE,
       A.D_SETT_FACT,
       A.D_TRADE AS D_BIZ_FIRST,
       a.C_CA_CODE_BAIL,
       a.C_CA_CODE_OT,
       a.C_DV_STATE,
       a.C_OPEN_ADDR,
       a.C_OPEN_ACC_NO,
       a.C_OPEN_ACC_NAME,
       NVL(N_TD_YHS, 0) AS N_TD_YHS,
       NVL(N_TD_JSF, 0) AS N_TD_JSF,
       0 AS N_TD_GHF,
       0 AS N_TD_ZGF,
       NVL(N_TD_JSFWF, 0) AS N_TD_JSFWF,
       NVL(N_TD_FEE, 0) AS N_TD_FEE,
       NVL(N_BK_HHF, 0) as N_BK_HHF,
       0 AS N_STFXJ,
       NVL(N_TD_COMM, 0) AS N_TD_COMM,
       0 as N_RGF,
       0 as N_SGF,
       0 as N_SHF,
       NVL(C.N_QTF,0) AS N_QTF,
       0 AS N_TD_YF_COMM,
       null as D_TD_BACK,
       0 as N_RATE,
       ' ' as C_SETT_ORG,
       ' ' as C_PORT_CODE_SUB,
       ' ' AS C_CXS_NAME,
       0 as N_TD_MONEY_LOCL,
     0 as N_PAWN_MONEY,
     ' ' as C_SS_CHAN,
     null as D_APPLY,
       A.C_DATA_IDF,
       ' ' as C_DEVALUE_STAGE,
	   A.C_ORG_CODE,--STORY #121486
       A.C_UPDATE_TIME,
       A.C_UPDATE_BY,
       A.C_CHECK_BY,
       A.C_CHECK_TIME,
       TO_CHAR(SYSDATE, 'yyyyMMdd HH24:mi:ss') AS C_TIMESTAMP
  FROM T_D_AC_TRADE_FW A
  LEFT JOIN (SELECT C_IDEN_RELA,
                    NVL(SUM(CASE
                              WHEN C_FEE_CODE = 'ZQL_YHS' THEN
                               NVL(N_FEE_MONEY,0) ELSE 0
                            END),
                        0) AS N_TD_YHS,
                    NVL(SUM(CASE
                              WHEN C_FEE_CODE = 'ZQL_JSOF' THEN
                               NVL(N_FEE_MONEY,0) ELSE 0
                            END),
                        0) AS N_TD_JSF,
                    NVL(SUM(CASE
                              WHEN C_FEE_CODE = 'ZQL_JSUF' THEN
                               NVL(N_FEE_MONEY,0) ELSE 0
                            END),
                        0) AS N_TD_JSFWF,
                    NVL(SUM(CASE
                              WHEN C_FEE_CODE = 'ZQL_JYF' OR
                                   C_FEE_CODE = 'ZQL_YHSXF' THEN
                               NVL(N_FEE_MONEY,0) ELSE 0
                            END),
                        0) AS N_TD_FEE,
                    NVL(SUM(CASE
                              WHEN C_FEE_CODE = 'YJL_JYJ' THEN
                               NVL(N_FEE_MONEY,0) ELSE 0
                            END),
                        0) AS N_TD_COMM,
                    NVL(SUM(CASE
                              WHEN C_FEE_CODE = 'QTL_HKF' THEN
                               NVL(N_FEE_MONEY,0) ELSE 0
                            END),
                        0) AS N_BK_HHF,
                    NVL(SUM(CASE
                              WHEN C_FEE_CODE = 'ZQL_QTF' THEN
                               NVL(N_FEE_MONEY,0) ELSE 0
                            END),
                        0) AS N_QTF
               FROM T_D_AC_TRADE_FW_FEE
              GROUP BY C_IDEN_RELA) C
    ON A.C_IDEN = C.C_IDEN_RELA
  LEFT JOIN T_P_SV_SEC_BASE D
    ON A.C_SEC_CODE = D.C_SEC_CODE
  LEFT JOIN (SELECT C_PORT_CODE, C_ASS_CODE FROM T_P_AB_PORT) E
    ON A.C_PORT_CODE = E.C_PORT_CODE
    LEFT JOIN T_P_AB_TD_CHAN G
    ON A.C_TD_CHAN_CODE = G.C_TD_CHAN_CODE
   AND A.C_MKT_CODE = G.C_MKT_CODE
   AND G.C_DV_CHAN_TYPE = 'CHAN_ORG'
   AND G.N_CHECK_STATE = 1
 WHERE A.N_CHECK_STATE = 1
   AND A.C_TD_TYPE = 'YQJY'
   /*and d.n_check_state = 1*/
--ETF申赎业务(子记录)
UNION ALL
SELECT 'G' || A.c_Iden AS N_ID,
       A.C_IDEN_RELA as N_ID_SUB,
       A.C_PORT_CODE AS C_PORT_CODE,
       E.C_ASS_CODE AS C_ASSET_CODE,
       NVL(A.C_TD_NO, ' ') AS C_TD_NUMBER,
       A.C_TD_TYPE AS C_TD_TYPE,
       A.D_TRADE AS D_BIZ,
       A.D_TRADE AS D_TRADE_DATE,
       NULL AS D_TRADE_OUTER, --STORY #68781
       A.C_DV_TYPE_SUB AS C_DV_TYPE_SUB,
       A.C_SEC_CODE,
       A.C_SEC_CODE_TAG,
       ' ' AS C_DV_VAR_DUR,
       D.C_SEC_VAR_CODE AS C_SEC_VAR_MX,
       (CASE
         WHEN D.C_SEC_VAR_CODE LIKE 'CK%' THEN
          D.N_AMOUNT_HD
         WHEN D.C_SEC_VAR_CODE LIKE 'JJ%' THEN
          D.N_RATIO
         WHEN D.C_SEC_VAR_CODE LIKE 'LC%' THEN
          D.N_RATIO
         WHEN D.C_SEC_VAR_CODE LIKE 'HG%' THEN
          TO_NUMBER(NVL(D.C_DV_QUT_MOD,0))
         WHEN D.C_SEC_VAR_CODE LIKE 'CJ%' THEN
          TO_NUMBER(NVL(D.C_DV_QUT_MOD,0))
         ELSE
          NULL
       END) AS N_NH_DAYS,--20170704 利率年化天数
       A.c_Dt_Code,
       D.C_DC_CODE AS C_CURY_CODE,
       D.C_MKT_CODE,
       A.C_DV_PLAT AS C_TD_PLAT,
       A.C_TD_CHAN_CODE AS C_TDCHAN_CODE,
       A.C_SH_ACC_CODE AS C_TD_CODE,
       ' ' AS C_IM_CODE, --投资经理
       A.C_DV_INVEST_CLS AS C_IVT_CLSS,
       ' ' AS C_HLD_ATTR, --持有属性
       A.C_DTA_CODE AS C_TD_ATTR,
       A.C_DV_ISSUE_MODE AS C_ML_ATTR, --受限流通类别
       'NA' AS C_TD_RELAPARTY, --交易对手方
     ' ' AS C_SETT_MODE,--交收方式 STORY #68340
       A.N_TD_AMOUNT,
       A.N_TD_PRICE,
       A.N_TD_MONEY,
       NULL as N_Days,
       NULL AS N_HG_RATE,
     0 AS N_HGLL_TD,--交易流水回购利率STORY #64491
       0 AS N_REF_RATE, --参考基准利率
       0 AS N_TD_INCOME,
       ' ' as C_SEC_CODE_I,
       ' ' as C_IVT_CLSS_I,
       ' ' as C_TD_ATTR_I,
       0 as N_TD_AMOUNT_I,
       0 as N_TD_MONEY_I,
       '' as C_DV_SETT,
       NULL AS D_SETT_FIRST,
       ' ' AS C_CA_CODE_SETT_FIRST,
       0 AS N_SETT_MONEY_FIRST,
       A.N_SETT_MONEY_DUE,
       0 AS N_SETT_MONEY_FACT,
       A.D_SETT_DUE,
       A.C_CA_CODE_SETT_DUE,
       A.D_SETT_FACT,
       A.D_TRADE AS D_BIZ_FIRST,
       ' ' C_CA_CODE_BAIL,
       ' ' C_CA_CODE_OT,
       ' ' AS C_DV_STATE,
       ' ' AS C_OPEN_ADDR,
       ' ' AS C_OPEN_ACC_NO,
       ' ' AS C_OPEN_ACC_NAME,
       0 AS N_TD_YHS,
       0 AS N_TD_JSF,
       0 AS N_TD_GHF,
       0 AS N_TD_ZGF,
       0 AS N_TD_JSFWF,
       0 AS N_TD_FEE,
       0 as N_BK_HHF,
       0 AS N_STFXJ,
       0 AS N_TD_COMM,
       0 as N_RGF,
       0 as N_SGF,
       0 as N_SHF,
       0 AS N_QTF,
       0 AS N_TD_YF_COMM,
       NULL AS D_TD_BACK,
       0 AS N_RATE,
       ' ' AS C_SETT_ORG,
       ' ' AS C_PORT_CODE_SUB,
       ' ' AS C_CXS_NAME,
       0 AS N_TD_MONEY_LOCL,
     0 AS N_PAWN_MONEY,
     A.C_SSTD_WAY as C_SS_CHAN,
     A.D_APPLY,
       A.C_DATA_IDF,
        ' ' as C_DEVALUE_STAGE,
	   '' AS C_ORG_CODE,--STORY #121486
       A.C_UPDATE_TIME,
       A.C_UPDATE_BY,
       A.C_CHECK_BY,
       A.C_CHECK_TIME,
       TO_CHAR(SYSDATE, 'yyyyMMdd HH24:mi:ss') AS C_TIMESTAMP
  FROM t_d_Ac_Trade_Etf A
  LEFT JOIN T_P_SV_SEC_BASE D
    ON A.C_SEC_CODE = D.C_SEC_CODE
  LEFT JOIN (SELECT C_PORT_CODE, C_ASS_CODE FROM T_P_AB_PORT) E
    ON A.C_PORT_CODE = E.C_PORT_CODE
 WHERE A.N_CHECK_STATE = 1
   AND A.C_TD_TYPE = 'CNSS')
;
comment on column FA45.VC_TRADE.N_ID is '流水编号';
comment on column FA45.VC_TRADE.N_ID_SUB is '子流水编号';
comment on column FA45.VC_TRADE.C_PORT_CODE is '组合内码';
comment on column FA45.VC_TRADE.C_ASSET_CODE is '产品代码';
comment on column FA45.VC_TRADE.C_TD_NUMBER is '成交编号';
comment on column FA45.VC_TRADE.C_TD_TYPE is '交易类型';
comment on column FA45.VC_TRADE.D_BIZ is '业务日期';
comment on column FA45.VC_TRADE.D_TRADE_DATE is '交易日期';
comment on column FA45.VC_TRADE.D_TRADE_OUTER is '外部成交日期';
comment on column FA45.VC_TRADE.C_DV_TYPE_SUB is '业务类型';
comment on column FA45.VC_TRADE.C_SEC_CODE is '证券内码';
comment on column FA45.VC_TRADE.C_SEC_CODE_TAG is '标的证券';
comment on column FA45.VC_TRADE.C_DV_VAR_DUR is '锁定期限';
comment on column FA45.VC_TRADE.C_SEC_VAR_MX is '证券品种明细';
comment on column FA45.VC_TRADE.N_NH_DAYS is '利率年化天数';
comment on column FA45.VC_TRADE.C_DT_CODE is '交易方式';
comment on column FA45.VC_TRADE.C_CURY_CODE is '交易币种';
comment on column FA45.VC_TRADE.C_MKT_CODE is '交易市场';
comment on column FA45.VC_TRADE.C_TD_PLAT is '交易平台';
comment on column FA45.VC_TRADE.C_TDCHAN_CODE is '交易渠道';
comment on column FA45.VC_TRADE.C_TD_CODE is '交易账户';
comment on column FA45.VC_TRADE.C_IM_CODE is '投资经理';
comment on column FA45.VC_TRADE.C_IVT_CLSS is '投资分类';
comment on column FA45.VC_TRADE.C_HLD_ATTR is '持有属性';
comment on column FA45.VC_TRADE.C_TD_ATTR is '交易属性';
comment on column FA45.VC_TRADE.C_ML_ATTR is '受限流通类别';
comment on column FA45.VC_TRADE.C_TD_RELAPARTY is '交易对手方';
comment on column FA45.VC_TRADE.C_SETT_MODE is '交收方式';
comment on column FA45.VC_TRADE.N_TD_AMOUNT is '成交数量';
comment on column FA45.VC_TRADE.N_TD_MONEY is '成交金额';
comment on column FA45.VC_TRADE.N_DAYS is '回购天数';
comment on column FA45.VC_TRADE.N_HG_RATE is '回购利率';
comment on column FA45.VC_TRADE.N_HGLL_TD is '交易流水回购利率';
comment on column FA45.VC_TRADE.N_REF_RATE is '参考基准利率';
comment on column FA45.VC_TRADE.N_TD_INCOME is '附带收益';
comment on column FA45.VC_TRADE.C_SEC_CODE_I is '标的交易证券';
comment on column FA45.VC_TRADE.C_IVT_CLSS_I is '标的投资分类';
comment on column FA45.VC_TRADE.C_TD_ATTR_I is '标的交易属性';
comment on column FA45.VC_TRADE.N_TD_AMOUNT_I is '标的成交数量';
comment on column FA45.VC_TRADE.N_TD_MONEY_I is '标的成交金额';
comment on column FA45.VC_TRADE.C_DV_SETT is '结算方式';
comment on column FA45.VC_TRADE.D_SETT_FIRST is '首期结算日期';
comment on column FA45.VC_TRADE.C_CA_CODE_SETT_FIRST is '首期结算现金账户';
comment on column FA45.VC_TRADE.N_SETT_MONEY_FIRST is '首期证券清算款';
comment on column FA45.VC_TRADE.N_SETT_MONEY_DUE is '到期证券清算款';
comment on column FA45.VC_TRADE.N_SETT_MONEY_FACT is '实际结算金额';
comment on column FA45.VC_TRADE.D_SETT_DUE is '到期结算日期';
comment on column FA45.VC_TRADE.C_CA_CODE_SETT_DUE is '到期结算现金账户';
comment on column FA45.VC_TRADE.D_SETT_FACT is '实际结算日期';
comment on column FA45.VC_TRADE.D_BIZ_FIRST is '回购首期日期';
comment on column FA45.VC_TRADE.C_CA_CODE_BAIL is '保证金账户';
comment on column FA45.VC_TRADE.C_CA_CODE_OT is '其他账户';
comment on column FA45.VC_TRADE.C_DV_STATE is '结算状态（S-已结算';
comment on column FA45.VC_TRADE.C_OPEN_ADDR is '开户地址';
comment on column FA45.VC_TRADE.C_OPEN_ACC_NO is '开户账号';
comment on column FA45.VC_TRADE.C_OPEN_ACC_NAME is '开户名称';
comment on column FA45.VC_TRADE.N_TD_YHS is '印花税';
comment on column FA45.VC_TRADE.N_TD_JSF is '经手费';
comment on column FA45.VC_TRADE.N_TD_GHF is '过户费';
comment on column FA45.VC_TRADE.N_TD_ZGF is '征管费';
comment on column FA45.VC_TRADE.N_TD_JSFWF is '结算(服务)费';
comment on column FA45.VC_TRADE.N_TD_FEE is '交易费用';
comment on column FA45.VC_TRADE.N_BK_HHF is '汇划费';
comment on column FA45.VC_TRADE.N_STFXJ is '结算风险金';
comment on column FA45.VC_TRADE.N_TD_COMM is '代理费(佣金)';
comment on column FA45.VC_TRADE.N_RGF is '认购费';
comment on column FA45.VC_TRADE.N_SGF is '申购费';
comment on column FA45.VC_TRADE.N_SHF is '赎回费';
comment on column FA45.VC_TRADE.N_QTF is '证券其他费';
comment on column FA45.VC_TRADE.N_TD_YF_COMM is '应付佣金';
comment on column FA45.VC_TRADE.D_TD_BACK is '回转日期';
comment on column FA45.VC_TRADE.N_RATE is '汇率';
comment on column FA45.VC_TRADE.C_SETT_ORG is '结算机构';
comment on column FA45.VC_TRADE.C_PORT_CODE_SUB is '分级组合';
comment on column FA45.VC_TRADE.C_CXS_NAME is '承销商名称';
comment on column FA45.VC_TRADE.N_TD_MONEY_LOCL is '本币成交金额';
comment on column FA45.VC_TRADE.N_PAWN_MONEY is '留存质押金额';
comment on column FA45.VC_TRADE.C_SS_CHAN is '申赎通道';
comment on column FA45.VC_TRADE.D_APPLY is '申请日期';
comment on column FA45.VC_TRADE.C_DATA_IDF is '数据来源';
comment on column FA45.VC_TRADE.C_UPDATE_TIME is '更新时间';
comment on column FA45.VC_TRADE.C_UPDATE_BY is '更新人';
comment on column FA45.VC_TRADE.C_CHECK_BY is '审核人';
comment on column FA45.VC_TRADE.C_CHECK_TIME is '审核时间';
comment on column FA45.VC_TRADE.C_TIMESTAMP is '时间戳';
