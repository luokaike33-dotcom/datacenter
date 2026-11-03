------------------------------------------------------------------------
  -- 模块名称：资产单元基本信息表
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

alter table ${dwd_db}.acc_asset_unit_info drop if exists partition (sys_rs_id='O3') ;

insert into ${dwd_db}.acc_asset_unit_info partition(sys_rs_id)
(
ast_unit_code,
prd_code,
ast_unit_name,
cptl_acct,
compt_dept,
cptl_acct_pasw,
oact_bnk_name,
oact_name,
cstd_bnk,
bnk_acct,
bnk_conp,
bnk_tel,
bnk_fax,
is_cstd,
futr_dept,
futr_dept_cptl_acct,
futr_dept_cptl_acct_pasw,
ast_unit_stat,
ast_unit_dim,
is_depo,
src_sys_code,
rmk,
busi_date,
task_rs_id,
dm_created_time,
sys_rs_id
)
select DISTINCT
        CONCAT(T1.VC_FUND_CODE , '_' , T.VC_ASSET_NO) as ast_unit_code, --资产单元代码
        t1.VC_FUND_CODE as prd_code, --产品代码
        t.vc_asset_name as ast_unit_name, --资产单元名称
        t.vc_capital_account as cptl_acct, --资金账号
        t.l_securities_branch as compt_dept, --分仓营业部
        t.vc_capital_password as cptl_acct_pasw, --资金账号密码
        t.vc_bank_name as oact_bnk_name, --开户行名称
        t.vc_account_name as oact_name, --开户名
        t.l_local_custodian as cstd_bnk, --托管行
        t.vc_bank_account as bnk_acct, --银行帐号
        t.vc_bank_linkman as bnk_conp, --银行联系人
        t.vc_bank_phone as bnk_tel, --银行联系电话
        t.vc_bank_fax as bnk_fax, --银行传真
        t.c_trust as is_cstd, --是否托管
        t.l_securities_branch_qh as futr_dept, --期货营业部
        t.vc_capital_account_qh as futr_dept_cptl_acct, --期货营业部资金账号
        t.vc_capital_password_qh as futr_dept_cptl_acct_pasw, --期货营业部资金帐号密码
        t.c_asset_status as ast_unit_stat, --资产单元状态
        t.c_credit_asset as ast_unit_dim, --资产单元属性
        t.c_third_party_custody as is_depo, --是否三方存管
        t.L_ASSET_ID AS SRC_SYS_CODE, --源系统代码
        t.vc_remarks as rmk, --备注
		date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
        'acc_asset_unit_info_1' AS TASK_RS_ID, --任务来源标识
        CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
        'O3' AS sys_rs_id --系统来源标识
FROM ${ods_db}.O3_TASSET T
LEFT JOIN ${ods_db}.O3_TFUNDINFO T1
  ON T.L_FUND_ID = T1.L_FUND_ID

union all
--补充估值比交易早做账的产品
select DISTINCT
        CONCAT(prd_code , '_XC') as ast_unit_code, --资产单元代码
        prd_code as prd_code, --产品代码
        null as ast_unit_name, --资产单元名称
        null as cptl_acct, --资金账号
        null as compt_dept, --分仓营业部
        null as cptl_acct_pasw, --资金账号密码
        null as oact_bnk_name, --开户行名称
        null as oact_name, --开户名
        null as cstd_bnk, --托管行
        null as bnk_acct, --银行帐号
        null as bnk_conp, --银行联系人
        null as bnk_tel, --银行联系电话
        null as bnk_fax, --银行传真
        null as is_cstd, --是否托管
        null as futr_dept, --期货营业部
        null as futr_dept_cptl_acct, --期货营业部资金账号
        null as futr_dept_cptl_acct_pasw, --期货营业部资金帐号密码
        null as ast_unit_stat, --资产单元状态
        null as ast_unit_dim, --资产单元属性
        null as is_depo, --是否三方存管
        null as SRC_SYS_CODE, --源系统代码
        null as rmk, --备注
		date_format(date_sub(current_date(), 1), 'yyyyMMdd') as busi_date, --业务日期
        'acc_asset_unit_info_2' AS TASK_RS_ID, --任务来源标识
        CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
        'O3' AS sys_rs_id --系统来源标识
from ${dwd_db}.pty_prd_diff_info 		
;