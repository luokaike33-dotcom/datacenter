drop table if exists ty_ods.w_ashareleadunderwriter;
create table if not exists ty_ods.w_ashareleadunderwriter
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  s_lu_annissuedate string comment '发行公告日',
  s_lu_issuedate string comment '发行日期',
  s_lu_issuetype string comment '发行类型',
  s_lu_totalissuecollection decimal(20,4) comment '募集资金合计(万元)',
  s_lu_totalissueexpenses decimal(20,4) comment '发行费用合计(万元)',
  s_lu_totaluderandsponefee decimal(20,4) comment '承销与保荐费用(万元)',
  s_lu_number string comment '参与主承销商个数',
  s_lu_name string comment '参与主承销商名称',
  s_lu_institype string comment '主承销商类型',
  s_lu_aux_type string comment '辅助类型',
  s_info_compcode string comment '主承销商id',
  all_lu string comment '全部参与主承销商名称',
  meeting_dt string comment '发审委会议日期',
  pass_dt string comment '发审委通过公告日',
  s_info_listdate string comment '上市日期',
  type string comment '发行类型',
  netcollection decimal(20,4) comment '募资净额合计(万元)',
  avg_totalcoll decimal(20,4) comment '募集总额算术平均 (万元)',
  avg_netcoll decimal(20,4) comment '募资净额算术平均 (万元)',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



