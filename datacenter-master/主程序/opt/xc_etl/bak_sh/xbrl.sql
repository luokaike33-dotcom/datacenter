select
  TO_CHAR(txra.D_REPORT_DATE,'yyyyMMdd') as D_REPORT_DATE,
  txra.C_PORT_CODE ,
  trim(tte.C_CHAPTER_NAME) as C_CHAPTER_NAME,
  tte.C_ELEMENT_NAME ,
  tte.C_ELEMENT_TYPE ,
  txra.n_order,
  txra.C_VALUE,txra.*,tte.*
from FA45BBZX.T_XBRL_REPORT_ADJUST txra 
left join FA45BBZX.T_TEMPLATE_ELEMENT tte
on txra.C_REPORT_TEMPLATE  = tte.C_TEMPLATE_CODE 
and txra.C_ELEMENT_CODE  = tte.C_ELEMENT_CODE
and tte.C_AUTHORIZ_TEMPLATE = 'gm_ar_report'
where 1=1
and txra.C_PORT_CODE = '008145'
and TO_CHAR(txra.D_REPORT_DATE,'yyyyMMdd') = '20231231'
and trim(tte.C_CHAPTER_NAME) like '7.2%'
and txra.C_REPORT_TEMPLATE not like '%_en'
order by trim(tte.C_CHAPTER_NAME), tte.C_ELEMENT_TYPE, tte.C_ELEMENT_NAME
