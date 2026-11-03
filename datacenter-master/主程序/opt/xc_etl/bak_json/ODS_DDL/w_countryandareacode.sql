drop table if exists ty_ods.w_countryandareacode;
create table if not exists ty_ods.w_countryandareacode
(
  object_id string comment '对象ID',
  is_valid bigint comment '是否有效',
  release_date timestamp comment '发布日期',
  country_code_3 string comment '国家及地区代码(3位)',
  continent string comment '所属洲',
  country_code_2 string comment '国家及地区代码(2位)',
  name string comment '国家及地区名称',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



