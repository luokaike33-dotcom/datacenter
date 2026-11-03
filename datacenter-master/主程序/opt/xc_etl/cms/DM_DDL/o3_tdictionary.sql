create table data_mart.o3_tdictionary ( 
  l_dictionary_no number(10),
  c_lemma_item varchar2(100),
  vc_item_name varchar2(100),
  c_allow_edit varchar2(100),
  l_code_length number(10),
  c_lemma_type varchar2(100),
  l_opposite_no number(10),
  vc_opposite_item varchar2(100),
  l_virtual_key number(10),
  vc_timestamp varchar2(100),
  l_code_min_length number(10),
  bath_dt varchar2(100),
  data_ins_time timestamp,
  task_rs_id varchar2(100)
);
comment on column data_mart.o3_tdictionary.c_allow_edit is '1:允许2：禁止';




