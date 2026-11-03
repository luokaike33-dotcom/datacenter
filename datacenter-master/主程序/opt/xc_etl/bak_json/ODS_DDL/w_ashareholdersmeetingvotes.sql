drop table if exists ty_ods.w_ashareholdersmeetingvotes;
create table if not exists ty_ods.w_ashareholdersmeetingvotes
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'WIND代码',
  s_info_compcode string comment '公司ID',
  ann_dt string comment '公告日期',
  meeting_dt string comment '会议日期',
  motion_title string comment '议案标题',
  is_classified_vote bigint comment '是否需要分类表决',
  favor_share decimal(20,4) comment '赞成股数',
  favor_share_radio decimal(20,4) comment '赞成股数比重(%)',
  oppose_share decimal(20,4) comment '反对股数',
  oppose_share_radio decimal(20,4) comment '反对股数比重(%)',
  abstained_share decimal(20,4) comment '弃权股数',
  abstained_share_radio decimal(20,4) comment '弃权股数比重(%)',
  non_tradable_favor_share decimal(20,4) comment '非流通股(限售流通股)赞成股数',
  non_tradable_oppose_share decimal(20,4) comment '非流通股(限售流通股)反对股数',
  non_tradable_abstain_share decimal(20,4) comment '非流通股(限售流通股)弃权股数',
  tradable_favor_share decimal(20,4) comment '流通股赞成股数',
  tradable_favor_share_radio decimal(20,4) comment '流通股赞成股数比重(%)',
  tradable_oppose_share decimal(20,4) comment '流通股反对股数',
  tradable_oppose_share_radio decimal(20,4) comment '流通股反对股数比重(%)',
  tradable_abstain_share decimal(20,4) comment '流通股弃权股数',
  tradable_abstain_share_radio decimal(20,4) comment '流通股弃权股数比重(%)',
  is_passed bigint comment '是否通过',
  is_shareholder_avoid bigint comment '关联股东是否回避',
  avoid_share decimal(20,4) comment '回避股数',
  avoid_share_radio decimal(20,4) comment '回避股数比重(%)',
  motion_type string comment '议案类型',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



