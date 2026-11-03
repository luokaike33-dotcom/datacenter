create table data_mart.o3_tcurrencyrate ( 
  l_date number(8,0),
  vc_currency_source varchar2(100),
  vc_currency_target varchar2(100),
  en_bid_price number(20,12),
  en_ask_price number(20,12),
  en_mid_price number(20,12),
  l_unit_amount number(10,0),
  l_priority_level number(10,0),
  vc_origin varchar2(100),
  en_direct_price number(20,12),
  l_set_no number(10,0),
  c_updated varchar2(100),
  vc_timestamp varchar2(100),
  l_virtual_key number(16,0)
);




