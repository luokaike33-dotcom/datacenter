create table data_mart.o3_thisrestrictedstock ( 
  l_unit_id number(10,0),
  l_date number(8,0),
  l_restricted_amount number(20,4),
  c_restricted_type varchar2(100),
  l_rsend_date number(8,0),
  en_buy_balance number(18,2),
  en_buy_fee number(18,2),
  l_sale_amount number(20,4),
  en_untransfered_invest number(18,2),
  c_lockrestricted_type varchar2(100),
  c_deal_flag varchar2(100),
  l_adjust_amount number(20,4),
  l_stgplc_frozen_amount number(18,2),
  vc_custom_restricted varchar2(100),
  l_frozen_amount number(20,4),
  c_rsend_flag varchar2(100)
);




