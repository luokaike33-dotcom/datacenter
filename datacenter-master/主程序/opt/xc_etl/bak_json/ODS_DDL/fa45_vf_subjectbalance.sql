drop table if exists ty_ods.fa45_vf_subjectbalance;
create table if not exists ty_ods.fa45_vf_subjectbalance
(
  n_id string comment '自动ID',
  d_hold timestamp comment '字段名称',
  c_port_code string comment '组合代码',
  c_asset_code string comment '字段名称',
  c_port_class string comment '字段名称',
  c_subj_code string comment '字段名称',
  c_subj_name string comment '字段名称',
  c_cury_code string comment '字段名称',
  c_pa_code string comment '字段名称',
  c_tdchan_code string comment '字段名称',
  c_mkt_code string comment '市场代码',
  c_sec_var_mx string comment '字段名称',
  c_subj_type string comment '科目类别',
  c_ivt_clss string comment '字段名称',
  c_hld_attr string comment '持有属性',
  c_td_attr string comment '字段名称',
  c_ml_attr string comment '受限流通类别',
  c_sec_code string comment '证券代码',
  c_ca_code string comment '现金账户',
  c_pi_code string comment '收支项目',
  c_ds_code string comment '销售方式',
  n_hldamt decimal(38,16) comment '字段名称',
  n_hldmny decimal(32,12) comment '字段名称',
  n_hldmny_l decimal(32,12) comment '字段名称',
  n_way smallint comment '字段名称',
  c_subj_code_t string comment '字段名称',
  c_dv_fee_type string comment '字段名称',
  c_update_time string comment '更新时间',
  c_ca_type string comment '现金账户类型',
  c_view_version string comment '视图版本',
  c_timestamp string comment '日期',
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
 COMMENT '会计科目余额'
partitioned by(p_dt bigint)
row format delimited fields terminated by '\t'
stored as orc;



