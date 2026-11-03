drop table if exists ty_ods.fc_tq_bd_creditrate;
create table if not exists ty_ods.fc_tq_bd_creditrate
(
  id bigint,
  publishdate string,
  begindate string,
  enddate string,
  secode string,
  creditdate string,
  ratemode string,
  ratetype string,
  creditrate string,
  mapcbcode string,
  ratecompcode string,
  ratecomname string,
  radjustdir string,
  exptrating string,
  chgrsn string,
  memo string,
  isvalid bigint,
  tmstamp string,
  entrydate timestamp,
  entrytime string,
  bondcgchgid bigint,
  pdfid bigint,
  istempnotice bigint,
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



