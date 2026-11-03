drop table if exists ty_ods.esg_xq_news;
create table if not exists ty_ods.esg_xq_news
(
  company_id string,
  companyname string,
  ticker string,
  `exchange` string,
  news_id string,
  date timestamp,
  titlecn string,
  content_text string,
  risklabelcn string,
  url string,
  publish_time timestamp,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
partitioned by(busi_month bigint)
row format delimited fields terminated by '\t'
stored as orc;



