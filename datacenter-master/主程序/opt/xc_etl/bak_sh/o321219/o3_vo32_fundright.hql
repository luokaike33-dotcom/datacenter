------------------------------------------------------------------------
  -- 模块名称：资产单元基金经理权限
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




truncate  table ${dwd_db}.o3_vo32_fundright  ;

insert into ${dwd_db}.o3_vo32_fundright 
(
  l_date           ,
  l_operator_no   ,
  vc_operator_name ,
  l_fund_id        ,
  vc_fund_code     ,
  vc_fund_name     ,
  l_asset_id       ,
  vc_asset_name    ,
  is_temp          
)

SELECT   date_format(date_sub(current_date(), 1), 'yyyyMMdd') as    L_DATE,
       A.L_OPERATOR_NO,
       B.VC_OPERATOR_NAME,
      
       A.L_FUND_ID,
       C.VC_FUND_CODE,
       C.VC_FUND_NAME,
       A.L_ASSET_ID,
       D.VC_ASSET_NAME,
       0 as is_temp
  FROM `ty_ods`.o3_TOPFUNDRIGHT A,
       `ty_ods`.o3_TOPERATOR    B,
       `ty_ods`.o3_TFUNDINFO    C,
       `ty_ods`.o3_TASSET       D,
       `ty_ods`.o3_toprolerights E
 WHERE (A.L_OPERATOR_NO LIKE '70%' OR A.L_OPERATOR_NO LIKE '86%' OR
       A.L_OPERATOR_NO = '8208')
   AND A.L_OPERATOR_NO <> '8616'
   AND A.L_OPERATOR_NO = B.L_OPERATOR_NO
   AND A.L_FUND_ID = C.L_FUND_ID
   AND A.L_BASECOMBI_ID <> -1
   AND D.L_ASSET_ID = A.L_ASSET_ID
   AND C.C_FUND_STATUS = '2'
   AND A.L_BASECOMBI_ID IN (SELECT L_COMBI_ID FROM ty_ods.o3_TCOMBI)
      ---去除指数基金旧组合
   AND A.L_BASECOMBI_ID NOT IN ('25', '27', '942')
   AND A.VC_RIGHTS LIKE '%2%'
   AND B.C_OPERATOR_STATUS = '1'
   AND e.l_operator_no = a.l_operator_no
   and e.l_role_id in (4,14) -- 基金经理和专户经理	
;