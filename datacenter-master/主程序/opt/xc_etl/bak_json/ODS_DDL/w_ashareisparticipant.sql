drop table if exists ty_ods.w_ashareisparticipant;
create table if not exists ty_ods.w_ashareisparticipant
(
  object_id string comment '对象ID',
  event_id string comment '事件ID',
  s_institutionname string comment '机构投资者名称',
  s_institutioncode string comment '机构投资者ID',
  s_institutiontype bigint comment '机构投资者类型',
  s_analystname string comment '机构参与人员姓名',
  s_institutiontypecode bigint comment '参与者类型代码',
  manager_post string comment '机构参与人员公布职务',
  s_analyst_id string comment '机构参与人员ID',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



