-- 新建表：
declare cnt number; begin select count(1) into cnt from user_tables a where a.table_name = upper('w_bankingficlasscbrc');if cnt=0 then execute immediate'create table w_bankingficlasscbrc(
object_id varchar2(100 char), 
s_info_compcode varchar2(40 char), 
s_info_compname varchar2(100 char), 
s_info_typecode varchar2(50 char), 
entry_dt varchar2(8 char), 
remove_dt varchar2(8 char), 
cur_sign varchar2(10 char) 
)';
end if; end;
/
