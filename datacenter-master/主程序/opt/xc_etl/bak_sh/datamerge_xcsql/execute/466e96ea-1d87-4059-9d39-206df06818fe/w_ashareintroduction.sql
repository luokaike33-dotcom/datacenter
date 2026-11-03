-- 新建表：
declare cnt number; begin select count(1) into cnt from user_tables a where a.table_name = upper('w_ashareintroduction');if cnt=0 then execute immediate'create table w_ashareintroduction(
object_id varchar2(100 char), 
s_info_windcode varchar2(40 char), 
s_info_province varchar2(20 char), 
s_info_city varchar2(20 char), 
s_info_chairman varchar2(38 char), 
s_info_president varchar2(38 char), 
s_info_bdsecretary varchar2(500 char), 
s_info_regcapital number(20,4), 
s_info_founddate varchar2(8 char), 
s_info_chineseintroduction varchar2(1000 char), 
s_info_comptype varchar2(20 char), 
s_info_website varchar2(80 char), 
s_info_email varchar2(80 char), 
s_info_office varchar2(200 char), 
ann_dt varchar2(8 char), 
s_info_country varchar2(20 char), 
s_info_businessscope varchar2(1000 char), 
s_info_company_type varchar2(10 char), 
s_info_totalemployees int, 
s_info_main_business varchar2(1000 char), 
is_vie varchar2(1 char), 
is_profit varchar2(1 char), 
comp_name varchar2(200 char) 
)';
end if; end;
/
