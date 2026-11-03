drop table if exists ty_ods.w_cbondtenderresult;
create table if not exists ty_ods.w_cbondtenderresult
(
  object_id string comment '对象ID',
  s_info_windcode string comment 'Wind代码',
  b_tender_object bigint comment '招标标的',
  b_tendrst_documtnumber string comment '招标书编号',
  b_tendrst_payamount decimal(20,4) comment '缴款总金额(元)',
  b_tendrst_amountad decimal(20,4) comment '追加发行总量(万元)',
  b_tendrst_underwriting decimal(20,4) comment '基本承购总额(万元)',
  b_tendrst_amountact decimal(20,4) comment '实际发行总额(万元)',
  b_tendrst_amnt decimal(20,4) comment '招标总量(万元)',
  b_tendrst_oughttender decimal(20,4) comment '应投家数',
  b_tendrst_investortendered decimal(20,4) comment '投标家数',
  b_tendrst_tenders decimal(20,4) comment '投标笔数',
  b_tendrst_effecttender decimal(20,4) comment '有效笔数',
  b_tendrst_ineffecttender decimal(20,4) comment '无效笔数',
  b_tendrst_effectamnt decimal(20,4) comment '有效投标总量(万元)',
  b_tendrst_hightest decimal(20,4) comment '最高投标价位',
  b_tendrst_lowest decimal(20,4) comment '最低投标价位',
  b_tendrst_winningamnt decimal(20,4) comment '中标总量(万元)',
  b_tendrst_winnerbidder decimal(20,4) comment '中标家数',
  b_tendrst_winningbidder decimal(20,4) comment '中标笔数',
  b_tendrst_privatetrade decimal(20,4) comment '自营中标总量(万元)',
  b_tendrst_hightprice decimal(20,4) comment '最高中标价位',
  b_tendrst_lowprice decimal(20,4) comment '最低中标价位',
  b_tendrst_margamnt decimal(20,4) comment '边际中标价位投标总量(万元)',
  b_tendrst_margwinbidder decimal(20,4) comment '边际中标价位中标总量(万元)',
  b_tendrst_finalprice decimal(20,4) comment '最终发行价格',
  b_tendrst_referyield decimal(20,4) comment '参考收益率(%)',
  b_tendrst_financoupon decimal(20,4) comment '最终票面利率(%)',
  b_tendrst_bidrate decimal(20,4) comment '全场中标利率(%)',
  b_tendrst_bidprice decimal(20,4) comment '全场中标价格(元)',
  b_tendrst_bidspread decimal(20,4) comment '全场中标利差(%)',
  s_ipo_ovrsubratio decimal(20,4) comment '超额认购倍数',
  opdate timestamp,
  opmode string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



