DECLARE 
 cols varchar2(4000) := '';
 sqls varchar2(4000) := '';
begin
	for c in (select distinct c_element_name from fa45bbzx.t_template_element where c_authoriz_template = 'gm_ar_report') loop
		cols := 'select distinct c_element_name, max(case when c_element_name = ''' || c.c_element_name || ''' then c_value end as "' || c.c_element_name || '"';
	end loop;
	
	sqls := 'select * from (
               select
                 to_char(txra.d_report_date,''yyyyMMdd'') as d_report_date,
                 txra.c_port_code ,
                 trim(tte.c_chapter_name) as c_chapter_name,
                 tte.c_element_name ,
                 tte.c_element_type ,
                 txra.n_order,
                 txra.c_value
               from fa45bbzx.t_xbrl_report_adjust txra 
               left join fa45bbzx.t_template_element tte
               on txra.c_report_template  = tte.c_template_code 
               and txra.c_element_code  = tte.c_element_code
               and tte.c_authoriz_template = ''gm_ar_report''
               where 1=1
               and txra.c_port_code = ''008145''
               and to_char(txra.d_report_date,''yyyyMMdd'') = ''20221231''
             ) unpivot (c_value for c_element_name in (' || cols || ')) group by d_report_date, c_port_code, c_chapter_name, c_element_type, n_order';

    execute immediate sqls;
end
