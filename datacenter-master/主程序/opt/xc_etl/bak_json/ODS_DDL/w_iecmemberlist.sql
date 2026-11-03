drop table if exists ty_ods.w_iecmemberlist;
create table if not exists ty_ods.w_iecmemberlist
(
  object_id string comment '对象ID',
  term string comment '发审委届次',
  ann_dt string comment '公告日期',
  status string comment '专职/兼职',
  name string comment '姓名',
  age bigint comment '年龄',
  gender string comment '性别',
  professional string comment '专业',
  degree string comment '学历/学位',
  unit string comment '工作单位',
  post string comment '职务',
  title string comment '职称',
  typecode bigint comment '委员会类型代码',
  valid_dt string comment '有效截止日期',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



