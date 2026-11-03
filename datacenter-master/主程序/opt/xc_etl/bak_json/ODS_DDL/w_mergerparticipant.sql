drop table if exists ty_ods.w_mergerparticipant;
create table if not exists ty_ods.w_mergerparticipant
(
  object_id string comment '对象ID',
  event_id string comment '情报ID(或事件ID)',
  party_name string comment '参与方名称',
  country_code string comment '所属国家或地区代码',
  party_id string comment '参与方ID',
  s_info_windcode string comment '参与方关联证券Wind代码',
  party_type_code bigint comment '参与方类型代码',
  relationship bigint comment '参与方与关联证券代码关系',
  party_role_code bigint comment '参与方角色代码',
  pre_proportion decimal(20,4) comment '转让前持股比例',
  after_proportion decimal(20,4) comment '转让后持股比例',
  stockright_proportion decimal(20,4) comment '标的方交易股权占比',
  evalue_value decimal(20,4) comment '标的方评估价值',
  appreciation_rate decimal(20,4) comment '标的方增值率',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



