------------------------------------------------------------------------
  -- 模块名称：产品资金流明细信息--剔除冲现2条数据都是缺省单元的数据
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

insert overwrite table ${dwd_db}.fin_prd_capi_chg_detail partition(p_dt,sys_rs_id)

select
     TT1.PRD_CODE, --产品代码
     TT1.CHG_DT, --变动日期
     TT1.CAPI_CHG_TYP, --资金变动类型
     TT1.SHR_ADD, --份额增加
     TT1.CAPI_ADD, --资金增加
     TT1.CAPI_ADD_FEE, --资金增加_费用支出
     TT1.SHR_REDUCE, --份额减少
     TT1.CAPI_REDUCE, --资金减少
     TT1.CAPI_REDUCE_FEE, --资金减少_费用支出
     TT1.busi_date, --业务日期
     TT1.TASK_RS_ID, --任务来源标识
     TT1.DM_CREATED_TIME, --数据中台创建时间
     TT1.dm_src_info, --数据来源
     TT1.p_dt,  --日分区
     TT1.sys_rs_id --系统来源标识
from ${dwd_db}.fin_prd_capi_chg_detail TT1
where TT1.dm_src_info not in 
(
select
t1.dm_src_info
from ${dwd_db}.fin_prd_capi_chg_detail t1
inner join ${dwd_db}.fin_prd_capi_chg_detail t2
on t1.PRD_CODE = t2.PRD_CODE
and t1.p_dt = t2.p_dt
and t2.CAPI_CHG_TYP in ('SGCX','SHCX')
and t2.p_dt between ${beg_date} and ${end_date}
INNER JOIN ${dwd_db}.PTY_PRD_BASE_INFO t3 --产品基本信息，获取产品层产品
ON t1.PRD_CODE = t3.PRD_CODE
AND t3.PRD_TYP = '2'
INNER JOIN ${ods_db}.O3_TFUNDINFO t4  --O32产品信息
ON t3.FOFS_CODE = t4.VC_FUND_CODE
INNER JOIN ${ods_db}.O3_TASSET t5 --032缺省单元,如果未找到直接找缺省单元
ON t4.L_DEFAULT_ASSET = t5.L_ASSET_ID
where t1.CAPI_CHG_TYP in ('SGCX','SHCX')
and t1.p_dt between ${beg_date} and ${end_date}
AND T1.PRD_CODE = CONCAT(T4.VC_FUND_CODE, '_', T5.VC_ASSET_NO)
and (t1.CAPI_ADD = t2.CAPI_REDUCE
or t1.CAPI_REDUCE = t2.CAPI_ADD)
)
AND TT1.P_DT between ${beg_date} and ${end_date}
AND TT1.sys_rs_id IN ('DYCF_TA','DYCF_HB')
