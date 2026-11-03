drop table if exists ty_ods.fc_tq_bd_creditrtissue;
create table if not exists ty_ods.fc_tq_bd_creditrtissue
(
  id bigint,
  publishdate string,
  compcode string,
  compname string,
  comtype string,
  ratecompcode string,
  ratecomname string,
  ratetype string,
  creditrate string,
  mapcbcode string,
  exptrating string,
  memo string,
  isvalid bigint,
  tmstamp string,
  entrydate timestamp,
  entrytime string,
  creditrtissueid bigint,
  declaredate string,
  actrating string,
  pdfid bigint,
  istempnotice bigint,
  compleveltype string,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



