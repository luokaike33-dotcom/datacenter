------------------------------------------------------------------------
-- 模块名称：产品基本信息
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
----set spark.driver.memory=2G;
----set hive.auto.convert.join=true;

alter table ${dwd_db}.pty_prd_base_info drop if exists partition (sys_rs_id='DYCF');

insert into ${dwd_db}.pty_prd_base_info partition(sys_rs_id)
  (prd_code, --产品代码
   sub_code, --子基金代码
   fofs_code, --母基金代码
   prd_name, --产品名称
   prd_typ, --组合类型
   prd_cald, --产品日历
   impt_crt_dt, --引进/创设日期
   found_dt, --成立日期
   prod_sht_py, --产品英文名称
   prd_full_name, --产品全称
   prod_name_py, --产品英文全称
   prod_intr, --产品简介
   crrc, --币种
   parv_unit, --每份面值
   iss_lmt, --发行额度
   dqr_end, --预计到期日
   end_dt, --终止日期
   clr_dt, --清算日期
   is_citd_amor, --是否分期/分级产品
   is_fcode, --是否母产品
   valu_cnfm_dt, --最新估值确认日
   busi_date, --业务日期
   task_rs_id, --任务来源标识
   dm_created_time, --数据中台创建时间
   bgng_unit_nav ,-- 期初单位净值
   is_cross, --是否穿透
   dm_src_info,  --来源信息
   sys_rs_id --系统来源标识   
   )
select
t1.AST_UNIT_CODE as prd_code, --产品代码
null as sub_code, --子基金代码
t1.prd_code as fofs_code, --母基金代码  --不取
CONCAT(nvl(T2.PRD_NAME,''), '_' , nvl(t1.AST_UNIT_NAME,'')) as prd_name, --产品名称
'2' as prd_typ, --组合类型
'1' as prd_cald, --产品日历
t2.impt_crt_dt as impt_crt_dt, --引进/创设日期
t2.impt_crt_dt as found_dt, --成立日期
null as prod_sht_py, --产品英文名称
CONCAT(T2.PRD_FULL_NAME, '_' , t1.AST_UNIT_NAME) as prd_full_name, --产品全称
null as prod_name_py, --产品英文全称
null as prod_intr, --产品简介
null as crrc, --币种
null as parv_unit, --每份面值
null as iss_lmt, --发行额度
t2.dqr_end as dqr_end,
t2.end_dt as end_dt, --终止日期
t2.clr_dt as clr_dt, --清算日期
null as is_citd_amor, --是否分期/分级产品
null as is_fcode, --是否母产品
t2.valu_cnfm_dt as valu_cnfm_dt, --最新估值确认日
date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
'pty_prd_base_info_1' as task_rs_id, --任务来源标识
current_timestamp as dm_created_time, --数据中台创建时间
null as bgng_unit_nav ,-- 期初单位净值
null as is_cross, --是否穿透
'acc_asset_unit_info' as dm_src_info, --来源信息
'DYCF' sys_rs_id --系统来源标识
from ${dwd_db}.acc_asset_unit_info t1
INNER join ${dwd_db}.pty_prd_base_info t2
on t1.prd_code = t2.prd_code
and t2.prd_typ = '1'