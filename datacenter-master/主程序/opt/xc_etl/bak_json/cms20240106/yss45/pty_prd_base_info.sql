create table data_mart.pty_prd_base_info ( 
  prd_code varchar2(32),
  sub_code varchar2(32),
  fofs_code varchar2(32),
  prd_name varchar2(50),
  prd_typ varchar2(10),
  prd_cald varchar2(20),
  impt_crt_dt number(10),
  found_dt number(10),
  prod_sht_py varchar2(50),
  prd_full_name varchar2(200),
  prod_name_py varchar2(50),
  prod_intr varchar2(1000),
  crrc varchar2(10),
  parv_unit number(32,16),
  iss_lmt number(32,16),
  dqr_end number(10),
  end_dt number(10),
  clr_dt number(10),
  is_citd_amor varchar2(1),
  is_fcode varchar2(1),
  valu_cnfm_dt number(10),
  is_intr_tax_free varchar2(20),
  valu_sped varchar2(20),
  busi_date number(10),
  task_rs_id varchar2(100),
  dm_created_time timestamp,
  bgng_unit_nav number(32,16),
  is_cross varchar2(100),
  dm_src_info varchar2(100),
  sys_rs_id varchar2(20)
);
comment on table data_mart.pty_prd_base_info is '产品基本信息';
comment on column data_mart.pty_prd_base_info.prd_code is '产品代码';
comment on column data_mart.pty_prd_base_info.sub_code is '子产品代码';
comment on column data_mart.pty_prd_base_info.fofs_code is '母产品代码';
comment on column data_mart.pty_prd_base_info.prd_name is '产品名称';
comment on column data_mart.pty_prd_base_info.prd_typ is '组合类型';
comment on column data_mart.pty_prd_base_info.prd_cald is '产品日历';
comment on column data_mart.pty_prd_base_info.impt_crt_dt is '引进/创设日期';
comment on column data_mart.pty_prd_base_info.found_dt is '成立日期';
comment on column data_mart.pty_prd_base_info.prod_sht_py is '产品英文名称';
comment on column data_mart.pty_prd_base_info.prd_full_name is '产品全称';
comment on column data_mart.pty_prd_base_info.prod_name_py is '产品英文全称';
comment on column data_mart.pty_prd_base_info.prod_intr is '产品简介';
comment on column data_mart.pty_prd_base_info.crrc is '币种';
comment on column data_mart.pty_prd_base_info.parv_unit is '每份面值';
comment on column data_mart.pty_prd_base_info.iss_lmt is '发行额度';
comment on column data_mart.pty_prd_base_info.dqr_end is '预计到期日';
comment on column data_mart.pty_prd_base_info.end_dt is '终止日期';
comment on column data_mart.pty_prd_base_info.clr_dt is '清算日期';
comment on column data_mart.pty_prd_base_info.is_citd_amor is '是否分期/分级产品';
comment on column data_mart.pty_prd_base_info.is_fcode is '是否母产品';
comment on column data_mart.pty_prd_base_info.valu_cnfm_dt is '最新估值确认日';
comment on column data_mart.pty_prd_base_info.is_intr_tax_free is '是否免利息税';
comment on column data_mart.pty_prd_base_info.valu_sped is '估值速度';
comment on column data_mart.pty_prd_base_info.busi_date is '业务日期';
comment on column data_mart.pty_prd_base_info.task_rs_id is '任务来源标识';
comment on column data_mart.pty_prd_base_info.dm_created_time is '数据中台创建时间';
comment on column data_mart.pty_prd_base_info.bgng_unit_nav is '期初单位净值';
comment on column data_mart.pty_prd_base_info.is_cross is '是否穿透(1穿透前,2穿透后,3子产品)';
comment on column data_mart.pty_prd_base_info.dm_src_info is '来源信息';
comment on column data_mart.pty_prd_base_info.sys_rs_id is '系统来源标识';



