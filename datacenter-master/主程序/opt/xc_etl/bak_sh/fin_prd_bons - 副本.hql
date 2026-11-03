--set hive.vectorized.execution.enabled=false;
--set hive.strict.checks.type.safety=false;
--set hive.exec.dynamic.partition.mode=nonstrict;
--set hive.execution.engine=spark;
--set hive.exec.max.dynamic.partitions.pernode=10000;
--set hive.exec.max.dynamic.partitions=10000;
--set hive.exec.max.created.files=10000;
--set hive.merge.sparkfiles=true;
--set hive.optimize.sort.dynamic.partition=true;
--set hive.merge.orcfile.stripe.level=false;
--set spark.memory.fraction=0.8;
--set hive.exec.dynamic.partition=true;
--set hive.crud.dynamic.partition=true;
--set spark.driver.memory=2G;
--set hive.auto.convert.join=true;

alter table ty_dwd.fin_prd_bons drop if exists partition (sys_rs_id='yssgz25');

insert into ty_dwd.fin_prd_bons partition(sys_rs_id)
  (prd_code, --产品代码
   rt_reg_dt, --股权登记日期
   ex_rd_dt, --除权除息日期
   unit_shr_bons, --每份分红
   spli_cnv_rat, --拆分折算比例
   bons_shr, --分红份额
   bons_val, --分红金额
   busi_date, --业务日期
   task_rs_id, --任务来源标识
   dm_created_time, --数据中台创建时间
   sys_rs_id, --系统来源标识
   dm_src_info   --来源信息
 )
--母基金
select
b.fsetid as prd_code,--产品代码
from_unixtime(unix_timestamp(a.fh_rq), 'yyyyMMdd')   as rt_reg_dt,--股权登记日期
--replace(a.fh_rq,'-','') as ex_rd_dt,--除权除息日期
from_unixtime(unix_timestamp(a.fh_rq), 'yyyyMMdd')   as ex_rd_dt,--除权除息日期
sum(case when a.fh_type = 0 then a.fh_dwje else 0 end) as unit_shr_bons,--每份分红
sum(case when a.fh_type = 1 then a.fh_dwje+1 else 0 end) as spli_cnv_rat,--拆分折算比例
sum(a.fh_fe) as bons_shr,--分红份额
sum(a.fh_je) as bons_val,--分红金额
regexp_replace(substr(date_sub(from_unixtime(unix_timestamp()),1),1,10),'-','') as busi_date, --业务日期
'fin_prd_bons' as task_rs_id,--系统来源标识
current_timestamp() as dm_created_time,--数据中台创建时间
'yssgz25' as sys_rs_id,--系统来源标识
'fa25_jjhz_fh' as dm_src_info --系统来源标识
from ty_ods.fa25_jjhz_fh a, (select distinct  fsetcode, fsetid from ty_ods.fa25_lsetlist) b
where  a.fh_type in (0, 1)
  and (a.fjjdm = 'A'||b.fsetcode )
  and from_unixtime(unix_timestamp(a.fh_rq), 'yyyyMMdd')<=20191231
group by b.fsetid, a.fh_rq
union all
--分级基金
select
b.fjjdm||b.ffundjb as prd_code,--产品代码
from_unixtime(unix_timestamp(a.fh_rq), 'yyyyMMdd') as rt_reg_dt,--股权登记日期
--replace(a.fh_rq,'-','') as ex_rd_dt,--除权除息日期
from_unixtime(unix_timestamp(a.fh_rq), 'yyyyMMdd')   as ex_rd_dt,--除权除息日期
sum(case when a.fh_type = 0 then a.fh_dwje else 0 end) as unit_shr_bons,--每份分红
sum(case when a.fh_type = 1 then a.fh_dwje+1 else 0 end) as spli_cnv_rat,--拆分折算比例
sum(a.fh_fe) as bons_shr,--分红份额
sum(a.fh_je) as bons_val,--分红金额
regexp_replace(substr(date_sub(from_unixtime(unix_timestamp()),1),1,10),'-','') as busi_date, --业务日期
'fin_prd_bons' as task_rs_id,--系统来源标识
current_timestamp() as dm_created_time,--数据中台创建时间
'yssgz25' as sys_rs_id,--系统来源标识
'fa25_jjhz_fh_2' as dm_src_info--系统来源标识
from ty_ods.fa25_jjhz_fh a, ty_ods.fa25_fxsflv b
where  a.fh_type in (0, 1)
  and (a.fjjdm = b.fzjjdm||b.fjjdm )
  and from_unixtime(unix_timestamp(a.fh_rq), 'yyyyMMdd')<=20191231
group by b.fjjdm, a.fh_rq,b.ffundjb
;