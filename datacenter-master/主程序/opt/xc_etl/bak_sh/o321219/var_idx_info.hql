------------------------------------------------------------------------
-- 模块名称：指数基本信息
-- 模块编号：
-- 开发人员：sa,Bert,Travis
-- 目前版本：
-- 创建时间：20201204,20220613,20221021
-- 版    权：
-- 功    能：
-- 修改记录：
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

alter table ${dwd_db}.var_idx_info drop if exists partition(sys_rs_id='WIND');
insert into table ${dwd_db}.var_idx_info partition(sys_rs_id)
(secu_id,                --证券编码
trd_code,               --交易代码
chi_name,               --中文名称
pub_com_id,             --发布机构代码
pub_com_name,           --发布机构名称
crt_com_id,     -- 编制机构代码
crt_com_name,       -- 编制机构名称
typ_code,               --指数类别代码
typ_code_desc,               --指数类别代码描述
typ_codeii,             --指数类型2
typ_codeii_desc,             --指数类型2描述
exch_code,              --交易市场代码
exch_name,              --交易市场名称
curr_code,              --货币代码
pub_dt,                 --发布日期
end_dt,                 --停用日期
bas_dt,                 --基准日期
bas_pnt,                --基点
compo_num,          -- 样本数量
wt_meth,                --加权方式
wt_typ_name,            --权重类型名称
styl,                   --指数风格
idx_syn,            -- 指数简介
idx_rela_typ,-- 指数关联类型
main_secu_id,-- 证券主编码
coms_type, -- 成分类型
busi_date,              --业务日期
sys_rs_id,              --系统来源标识
task_rs_id,             --任务来源标识
dm_created_time) --数据中台创建时
select a.secu_id,                                   --证券编码
       a.trd_code,                                  --交易代码
       a.chi_name,                                  --中文名称
       a.pub_com_id,                                --发布机构代码
       a.pub_com_name,                              --发布机构名称
       null                     as crt_com_id,      -- 编制机构代码
       null                     as crt_com_name,    -- 编制机构名称
       a.typ_code,                                  --指数类别代码
       b.para_name              as typ_code_desc,   --指数类别代码描述
       a.typ_codeii,                                --指数类型2
       c.para_name              as typ_codeii_desc, --指数类型2描述
       nvl(a.exch_code, 'OTH'),                     --交易市场代码
       nvl(a.exch_name, '其他'),                      --交易市场名称
       a.curr_code,                                 --货币代码
       a.pub_dt,                                    --发布日期
       a.end_dt,                                    --停用日期
       a.bas_dt,                                    --基准日期
       a.bas_pnt,                                   --基点
       null                     as compo_num,       -- 样本数量
       NVL(T5.para_hcode, '99') AS wt_meth,--加权方式
       a.wt_typ_name,                               --权重类型名称
       a.styl,                                      --指数风格
       a.idx_syn                     as idx_syn,         -- 指数简介
       '5'                      as idx_rela_typ,-- 指数关联类型
       a.secu_id                as main_secu_id,-- 证券主编码
       a.coms_type                     as coms_type,       -- 成分类型
       a.busi_date,                                 --业务日期
       a.sys_rs_id,                                 --系统来源标识
       a.task_rs_id,                                --任务来源标识
       a.dm_created_time                            --数据中台创建时
from (select t3.secu_id                                             as secu_id,--证券编码
             t.s_info_code                                          as trd_code,--交易代码
             t.s_info_name                                          as chi_name,--中文名称
             t1.s_info_compcode                                     as pub_com_id, --发布机构代码
             t4.comp_name                                           as pub_com_name,--发布机构名称
             case t1.s_info_sectypescode
                 when '100007001' then 'IDX101' --股票
                 when '100007002' then 'IDX103' --基金
                 when '100007003' then 'IDX102' --债券
                 else 'IDX109' end                                  as typ_code, --指数类别代码
             case
                 when t.S_INFO_INDEXCODE = '647009000' then '10' --综合指数
                 when t.S_INFO_INDEXCODE = '647002000' then '30' --行业指数
                 when t.S_INFO_INDEXCODE = '647003000' then '42' --策略指数
                 when t.S_INFO_INDEXCODE = '647004000' then '43' --风格指数
                 when t.S_INFO_INDEXCODE = '647005000' then '44' --主题指数
                 when t.S_INFO_INDEXCODE = '647006000' then '45' --基金指数
                 when t.S_INFO_INDEXCODE = '647007000' then '46' --债券指数
                 when t.S_INFO_INDEXCODE = '647001000' then '47' --规模指数
                 when t.S_INFO_INDEXCODE = '647002001' then '54' --一级行业指数
                 when t.S_INFO_INDEXCODE = '647002002' then '55' --二级行业指数
                 when t.S_INFO_INDEXCODE in
                      ('647008001', '647008010', '647008009', '647008008', '647008007', '647008006', '647008005',
                       '647008004', '647008003', '647008002') then '50' --期货类指数
                 else '57' --其他指数
                 end                                                as typ_codeii,--指数类型2
             t2.para_hcode                                          as exch_code,--交易市场代码
             t2.para_name                                           as exch_name,--交易市场名称
             nvl(t1.crncy_code, 'CNY')                              as curr_code,--货币代码
             cast(t.s_info_listdate as int)                         as pub_dt,--发布日期
             cast(t.expire_date as int)                             as end_dt,--停用日期
             cast(t.s_info_index_baseper as int)                    as bas_dt,--基准日期
             cast(t.s_info_index_basept as decimal(32, 16))         as bas_pnt, --基点
             t.s_info_index_weightsrule                             as wt_meth,--加权方式
             t.weight_type_name                                     as wt_typ_name,--权重类型名称
             t.s_info_indexstyle                                    as styl,--指数风格
             t.index_intro  as  idx_syn,         -- 指数简介
              t1.s_info_sectypescode as coms_type,       -- 成分类型
             cast(regexp_replace(current_date, '-', '') as decimal) as busi_date,--业务日期
             'WIND'                                                 as sys_rs_id,--系统来源标识
             'var_idx_info1.hql'                                     as task_rs_id,--任务来源标识
             current_timestamp()                                    as dm_created_time --数据中台创建时间
      from ${ods_db}.w_aindexdescription t --指数信息
               inner join ${ods_db}.w_windcustomcode t1
                          on t.s_info_windcode = t1.s_info_windcode
                              and t1.s_info_securitiestypes in ('S', 'IND')
                              and t.s_info_windcode not like '%!%'
               left join(select *
                         from (select row_number() over(partition by comp_id order by opdate desc ) rn ,a.*
                               from ${ods_db}.w_compintroduction a) t4
                         where t4.rn = 1) t4
                        on t1.s_info_compcode = t4.comp_id
               left join ${dwd_db}.pub_para_mapping t2
                         on t2.para_class_hcode = '4'
                             and t2.orisys_hcode = 'WIND'
                             and t.s_info_exchmarket = t2.orisys_para_code
               inner join ${dwd_db}.var_secu_ass_rela t3
                          on t.s_info_windcode = t3.src_secu_id and t3.sys_rs_id = 'WIND'

      union all
      select t3.secu_id                                             as secu_id,
             t.s_info_code                                          as trd_code,
             t.s_info_name                                          as chi_name,
             t1.s_info_compcode                                     as pub_com_id,
             t4.comp_name                                           as pub_com_name,
             (case t1.s_info_sectypescode
                  when '100007001' then 'IDX101' --股票
                  when '100007002' then 'IDX103' --基金
                  when '100007003' then 'IDX102' --债券
                  else 'IDX109' --其他
                 end)                                               as typ_code,
             (case
                  when t.INDEX_CATEGORY_CODE = '647009000' then '10' --综合指数
                  when t.INDEX_CATEGORY_CODE = '647002000' then '30' --行业指数
                  when t.INDEX_CATEGORY_CODE = '647003000' then '42' --策略指数
                  when t.INDEX_CATEGORY_CODE = '647004000' then '43' --风格指数
                  when t.INDEX_CATEGORY_CODE = '647005000' then '44' --主题指数
                  when t.INDEX_CATEGORY_CODE = '647006000' then '45' --基金指数
                  when t.INDEX_CATEGORY_CODE = '647007000' then '46' --债券指数
                  when t.INDEX_CATEGORY_CODE = '647001000' then '47' --规模指数
                  when t.INDEX_CATEGORY_CODE = '647002001' then '54' --一级行业指数
                  when t.INDEX_CATEGORY_CODE = '647002002' then '55' --二级行业指数
                  when t.INDEX_CATEGORY_CODE in
                       ('647008001', '647008010', '647008009', '647008008', '647008007', '647008006', '647008005',
                        '647008004', '647008003', '647008002') then '50' --期货类指数
                  else '57' --其他指数
                 end)                                               as typ_codeii,--指数类型2
             t2.para_hcode                                          as exch_code,
             t2.para_name                                           as exch_name,
             nvl(t1.crncy_code, 'CNY')                              as curr_code,
             cast(t.s_info_listdate as int)                         as pub_dt,
             null                                                   as end_dt,
             cast(t.s_info_index_baseper as int)                    as bas_dt,
             t.s_info_index_basept                                  as bas_pnt,
             null                                                   as wt_meth,
             null                                                   as wt_typ_name,
             null                                                   as styl,
             null  as  idx_syn,         -- 指数简介 目前源库wind  w_hkindexdescription 没有 index_intro字段
            t1.s_info_sectypescode as coms_type,       -- 成分类型
             cast(regexp_replace(current_date, '-', '') as decimal) as busi_date,
             'WIND'                                                 as sys_rs_id,--系统来源标识
             'var_idx_info2.hql'                                     as task_rs_id,--任务来源标识
             current_timestamp()                                    as dm_created_time --数据中台创建时间
      from ${ods_db}.w_hkindexdescription t --香港指数
               inner join ${ods_db}.w_windcustomcode t1
                          on t.s_info_windcode = t1.s_info_windcode
                              and t1.s_info_securitiestypes in ('S', 'IND')
                              and t.s_info_windcode not like '%!%'
               left join(select *
                         from (select row_number() over(partition by comp_id order by opdate desc ) rn ,a.*
                               from ${ods_db}.w_compintroduction a) t4
                         where t4.rn = 1) t4
                        on t1.s_info_compcode = t4.comp_id
               left join ${dwd_db}.pub_para_mapping t2
                         on t2.para_class_hcode = '4'
                             and t2.orisys_hcode = 'WIND'
                             and t.s_info_exchmarket = t2.orisys_para_code
               inner join ${dwd_db}.var_secu_ass_rela t3
                          on t.s_info_windcode = t3.src_secu_id and t3.sys_rs_id = 'WIND'
      where not exists(SELECT 1
                       FROM ${ods_db}.w_aindexdescription t5
                       WHERE t.s_info_windcode = t5.s_info_windcode)
      union ALL
      select t3.secu_id                                             as secu_id,
             t.s_info_code                                          as trd_code,
             -- t.s_info_name as secu_sht,
             t.s_info_name                                          as chi_name,
             t1.s_info_compcode                                     as pub_com_id,
             t4.comp_name                                           as pub_com_name,
             (case t1.s_info_sectypescode
                  when '100007001' then 'IDX101' --股票
                  when '100007002' then 'IDX103' --基金
                  when '100007003' then 'IDX102' --债券
                  else 'IDX109' end)                                as typ_code,
             (case
                  when t.INDEX_CATEGORY_CODE = '647009000' then '10' --综合指数
                  when t.INDEX_CATEGORY_CODE = '647002000' then '30' --行业指数
                  when t.INDEX_CATEGORY_CODE = '647003000' then '42' --策略指数
                  when t.INDEX_CATEGORY_CODE = '647004000' then '43' --风格指数
                  when t.INDEX_CATEGORY_CODE = '647005000' then '44' --主题指数
                  when t.INDEX_CATEGORY_CODE = '647006000' then '45' --基金指数
                  when t.INDEX_CATEGORY_CODE = '647007000' then '46' --债券指数
                  when t.INDEX_CATEGORY_CODE = '647001000' then '47' --规模指数
                  when t.INDEX_CATEGORY_CODE = '647002001' then '54' --一级行业指数
                  when t.INDEX_CATEGORY_CODE = '647002002' then '55' --二级行业指数
                  when t.INDEX_CATEGORY_CODE in
                       ('647008001', '647008010', '647008009', '647008008', '647008007', '647008006', '647008005',
                        '647008004', '647008003', '647008002') then '50' --期货类指数
                  else '57' --其他指数
                 end)                                               as typ_codeii,--指数类型2
             t2.para_hcode                                          as exch_code,
             t2.para_name                                           as exch_name,
             nvl(t1.crncy_code, 'CNY')                              as curr_code,
             cast(t.s_info_listdate as int)                         as pub_dt,
             cast(t.expire_date as int)                             as end_dt,
             cast(t.s_info_index_baseper as int)                    as bas_dt,
             cast(t.s_info_index_basept as decimal(32, 16))         as bas_pnt,
             t.s_info_index_weightsrule                             as wt_meth,
             t.weight_type                                          as wt_typ_name,
             t.s_info_indexstyle                                    as styl,
             t.index_intro  as  idx_syn,         -- 指数简介
             t1.s_info_sectypescode as coms_type,       -- 成分类型
             cast(regexp_replace(current_date, '-', '') as decimal) as busi_date,
             'WIND'                                                 as sys_rs_id,--系统来源标识
             'var_idx_info3.hql'                                     as task_rs_id,--任务来源标识
             current_timestamp()                                    as dm_created_time --数据中台创建时间
      from ${ods_db}.w_cbindexdescription t --指数信息
               inner join ${ods_db}.w_windcustomcode t1
                          on t.s_info_windcode = t1.s_info_windcode
                              and t1.s_info_securitiestypes in ('S', 'IND')
                              and t.s_info_windcode not like '%!%'
               left join(
          select *
          from (select row_number() over(partition by comp_id order by opdate desc ) rn ,a.*
                from ${ods_db}.w_compintroduction a) t4
          where t4.rn = 1) t4
                        on t1.s_info_compcode = t4.comp_id
               left join ${dwd_db}.pub_para_mapping t2
                         on t2.para_class_hcode = '4'
                             and t2.orisys_hcode = 'WIND'
                             and t.s_info_exchmarket = t2.orisys_para_code
               inner join ${dwd_db}.var_secu_ass_rela t3
                          on t.s_info_windcode = t3.src_secu_id and t3.sys_rs_id = 'WIND'
               left join ${ods_db}.w_hkindexdescription t5
                         on t.s_info_windcode = t5.s_info_windcode
      WHERE t5.s_info_windcode is null
             and NOT EXISTS(SELECT 1
                       FROM ${ods_db}.w_aindexdescription t4
                       WHERE t.s_info_windcode = t4.s_info_windcode)
      
      
                    ) a
         left join (select para_hcode, para_name
                    from ${dwd_db}.pub_para_mapping w
                    where para_class_hcode = '2'
                      and orisys_hcode = 'WIND'
                    group by para_hcode, para_name) b
                   on a.typ_code = b.para_hcode
         left join (select para_hcode, para_name
                    from ${dwd_db}.pub_para_mapping w
                    where para_class_hcode = '528'
                      and orisys_hcode = 'WIND'
                    group by para_hcode, para_name) c
                   on a.typ_codeii = c.para_hcode
         left join ${dwd_db}.pub_para_mapping t5
                   on t5.para_class_hcode = '118'
                       and t5.orisys_hcode = 'WIND'
                       and a.wt_meth = t5.orisys_para_code
;


insert into table ${dwd_db}.var_idx_info partition(sys_rs_id)
(secu_id,                --证券编码
trd_code,               --交易代码
chi_name,               --中文名称
pub_com_id,             --发布机构代码
pub_com_name,           --发布机构名称
crt_com_id,     -- 编制机构代码
crt_com_name,       -- 编制机构名称
typ_code,               --指数类别代码
typ_code_desc,               --指数类别代码描述
typ_codeii,             --指数类型2
typ_codeii_desc,             --指数类型2描述
exch_code,              --交易市场代码
exch_name,              --交易市场名称
curr_code,              --货币代码
pub_dt,                 --发布日期
end_dt,                 --停用日期
bas_dt,                 --基准日期
bas_pnt,                --基点
compo_num,          -- 样本数量
wt_meth,                --加权方式
wt_typ_name,            --权重类型名称
styl,                   --指数风格
idx_syn,            -- 指数简介
idx_rela_typ,-- 指数关联类型
main_secu_id,-- 证券主编码
coms_type, -- 成分类型
busi_date,              --业务日期
sys_rs_id,              --系统来源标识
task_rs_id,             --任务来源标识
dm_created_time) --数据中台创建时
select a.secu_id,                                   --证券编码
       a.trd_code,                                  --交易代码
       a.chi_name,                                  --中文名称
       a.pub_com_id,                                --发布机构代码
       a.pub_com_name,                              --发布机构名称
       null                     as crt_com_id,      -- 编制机构代码
       null                     as crt_com_name,    -- 编制机构名称
       a.typ_code,                                  --指数类别代码
       null              as typ_code_desc,   --指数类别代码描述
       a.typ_codeii,                                --指数类型2
       null              as typ_codeii_desc, --指数类型2描述
       nvl(a.exch_code, 'OTH'),                     --交易市场代码
       nvl(a.exch_name, '其他'),                      --交易市场名称
       a.curr_code,                                 --货币代码
       a.pub_dt,                                    --发布日期
       a.end_dt,                                    --停用日期
       a.bas_dt,                                    --基准日期
       a.bas_pnt,                                   --基点
       null                     as compo_num,       -- 样本数量
       NVL(T5.para_hcode, '99') AS wt_meth,--加权方式
       a.wt_typ_name,                               --权重类型名称
       a.styl,                                      --指数风格
       a.idx_syn                     as idx_syn,         -- 指数简介
       '5'                      as idx_rela_typ,-- 指数关联类型
       a.secu_id                as main_secu_id,-- 证券主编码
       a.coms_type                     as coms_type,       -- 成分类型
       a.busi_date,                                 --业务日期
       a.sys_rs_id,                                 --系统来源标识
       a.task_rs_id,                                --任务来源标识
       a.dm_created_time                            --数据中台创建时
from (
      select t3.secu_id                                             as secu_id,
                   t.s_info_code                                          as trd_code,
                   t.s_info_name                                          as chi_name,
                   t1.s_info_compcode                                     as pub_com_id,
                   t4.comp_name                                           as pub_com_name,
                   (case t1.s_info_sectypescode
                        when '100007001' then 'IDX101' --股票
                        when '100007002' then 'IDX103' --基金
                        when '100007003' then 'IDX102' --债券
                        else 'IDX109' --其他
                       end)                                               as typ_code,
                      null                                                as typ_codeii,--指数类型2
                   t2.para_hcode                                          as exch_code,
                   t2.para_name                                           as exch_name,
                   nvl(t1.crncy_code, 'CNY')                              as curr_code,
                   cast(t.s_info_listdate as int)                         as pub_dt,
                   null                                                   as end_dt,
                   cast(t.s_info_index_baseper as int)                    as bas_dt,
                   t.s_info_index_basept                                  as bas_pnt,
                   t.s_info_index_weightsrule                             as wt_meth,
                   null                                                    as wt_typ_name,
                   t.s_info_indexstyle                                    as styl,
                   null  as  idx_syn,         -- 指数简介 目前源库wind  w_hkindexdescription 没有 index_intro字段
                   t1.s_info_sectypescode as coms_type,       -- 成分类型
                   cast(regexp_replace(current_date, '-', '') as decimal) as busi_date,
                   'WIND'                                                 as sys_rs_id,--系统来源标识
                   'var_idx_info4.hql'                                     as task_rs_id,--任务来源标识
                   current_timestamp()                                    as dm_created_time --数据中台创建时间
            from ${ods_db}.w_cmfindexdescription t --基金指数
                     inner join ${ods_db}.w_windcustomcode t1
                                on t.s_info_windcode = t1.s_info_windcode
                                    and t1.s_info_securitiestypes in ('S', 'IND')
                                    and t.s_info_windcode not like '%!%'
                     left join(select *
                               from (select row_number() over(partition by comp_id order by opdate desc ) rn ,a.*
                                     from ${ods_db}.w_compintroduction a) t4
                               where t4.rn = 1) t4
                              on t1.s_info_compcode = t4.comp_id
                     left join ${dwd_db}.pub_para_mapping t2
                               on t2.para_class_hcode = '4'
                                   and t2.orisys_hcode = 'WIND'
                                   and t.s_info_exchmarket = t2.orisys_para_code
                     inner join ${dwd_db}.var_secu_ass_rela t3
                                on t.s_info_windcode = t3.src_secu_id and t3.sys_rs_id = 'WIND'
            where not exists(SELECT 1
                             FROM ${ods_db}.w_aindexdescription t5
                             WHERE t.s_info_windcode = t5.s_info_windcode)
      
                    ) a
         where not exists(SELECT 1
                             FROM ${dwd_db}.var_idx_info t5
                             WHERE a.trd_code = t5.trd_code)
							 ;
