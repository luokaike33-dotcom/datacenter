drop table if exists ty_ods.w_chinamfmperformance;
create table if not exists ty_ods.w_chinamfmperformance
(
  object_id string comment '对象ID',
  fundmanager_id string comment '基金经理ID',
  trade_date string comment '日期',
  fmindex_type bigint comment '基金经理指数类型',
  fmindex_point decimal(20,8) comment '基金经理指数点位',
  totreturn_ytd decimal(20,8) comment '今年以来回报',
  ranking_ytd string comment '今年以来同类排名',
  totreturn_1w decimal(20,8) comment '最近1周回报',
  ranking_1w string comment '最近1周同类排名',
  totreturn_1m decimal(20,8) comment '最近1月回报',
  ranking_1m string comment '最近1月同类排名',
  totreturn_3m decimal(20,8) comment '最近3月回报',
  ranking_3m string comment '最近3月同类排名',
  totreturn_6m decimal(20,8) comment '最近6月回报',
  ranking_6m string comment '最近6月同类排名',
  totreturn_1y decimal(20,8) comment '最近1年回报',
  ranking_1y string comment '最近1年同类排名',
  totreturn_2y decimal(20,8) comment '最近2年回报',
  ranking_2y string comment '最近2年同类排名',
  totreturn_3y decimal(20,8) comment '最近3年回报',
  ranking_3y string comment '最近3年同类排名',
  totreturn_5y decimal(20,8) comment '最近5年回报',
  ranking_5y string comment '最近5年同类排名',
  totreturn_10y decimal(20,8) comment '最近10年回报',
  ranking_10y string comment '最近10年同类排名',
  totreturn_es decimal(20,8) comment '履任以来回报',
  annreturnes decimal(20,8) comment '履任以来年化回报',
  ranking_es string comment '履任以来同类排名',
  worsttotreturn_6m decimal(20,8) comment '最差连续六月回报',
  besttotreturn_6m decimal(20,8) comment '最高连续六月回报',
  sucbasereturn_ytd decimal(20,8) comment '今年以来超越基准回报',
  sucbasereturn_1w decimal(20,8) comment '最近1周超越基准回报',
  sucbasereturn_1m decimal(20,8) comment '最近1月超越基准回报',
  sucbasereturn_3m decimal(20,8) comment '最近3月超越基准回报',
  sucbasereturn_6m decimal(20,8) comment '最近6月超越基准回报',
  sucbasereturn_1y decimal(20,8) comment '最近1年超越基准回报',
  sucbasereturn_2y decimal(20,8) comment '最近2年超越基准回报',
  sucbasereturn_3y decimal(20,8) comment '最近3年超越基准回报',
  sucbasereturn_5y decimal(20,8) comment '最近5年超越基准回报',
  sucbasereturn_10y decimal(20,8) comment '最近10年超越基准回报',
  sucbasereturn_es decimal(20,8) comment '履任以来超越基准回报',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(p_dt bigint)
row format delimited fields terminated by '\t'
stored as orc;



