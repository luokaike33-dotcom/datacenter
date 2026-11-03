------------------------------------------------------------------------
  -- 模块名称：组合成交明细数据大宽表开发、落地
------------------------------------------------------------------------
----set hive.vectorized.execution.enabled=false;
----set hive.strict.checks.type.safety=false;
----set hive.exec.dynamic.partition.mode=nonstrict;
----set hive.execution.engine=spark;
----set hive.exec.max.dynamic.partitions.pernode=10000;
----set hive.exec.max.dynamic.partitions=10000;
----set hive.exec.max.created.files=10000;
----set hive.merge.sparkfiles=true;
----set hive.optimize.sort.dynamic.partition=true;
----set hive.merge.orcfile.stripe.level=false;
----set spark.memory.fraction=0.8;
----set hive.exec.dynamic.partition=true;
----set hive.crud.dynamic.partition=true;
----set spark.driver.memory=2G; --内存默认2G，复杂任务不够时可单独设置增加
----set hive.auto.convert.join=true;

alter table ${dwd_db}.mid_l2_prd_tnv_dtl drop if exists partition (p_dt>=${beg_date} , p_dt<=${end_date}) ;

insert into ${dwd_db}.mid_l2_prd_tnv_dtl partition(p_dt)
(occu_dt,prd_code,src_fund_src,prd_name,prd_full_name,crrc,prd_clas,prd_clas_name,ttl_navl,ast_unit_code,src_ast_unit_no,ast_unit_name,src_ast_unit_onum,pfl_code,src_pfl_no,pfl_name,odr_onum,src_odr_onum,src_odr_chg_onum,src_odr_secu_onum,odr_rela_prsn,odr_rela_agt_prsn,odr_oper_lvl,odr_vol,trd_typ,entr_onum,src_entr_onum,entr_bath,rep_no,prc_clas,entr_vol,entr_prc,tnv_onum,src_tnv_onum,tnv_no,tnv_time,busi_typ,busi_clas,entr_dir_o3,entr_dir_name_o3,busi_clas_o3,busi_clas_name_o3,sh_code,seat_code,inv_typ,src_inv_typ,src_inv_typ_name,clr_sped,tnv_vol,tnv_prc,net_prc,full_prc,tnv_val,tnv_val_locy,occu_val,covr_pl,is_forc_covr,tot_fee,stmp,tfee,sfee,hand_fee,cms,clea_chag,deli_fee,trd_chag,clea_serv_chag,pr_fee,oth_fee,full_tfee,sett_mode,deli_dt,sett_fail_flag,oper_no,oper_name,tnv_stat,tnv_stat_name,inbk_stat,inbk_stat_name,memo,fir_deli_dt,end_deli_dt,fir_deli_mode,end_deli_mode,fir_net_prc,end_net_prc,fir_hd_intr,end_hd_intr,fir_yld,end_yld,exer_yld,valu_yld,repo_rat,repo_days,buyb_val,inta_days,trad_id,trad_name,trd_cntp_id,cntp_sht,cntp_name,cntp_seat_code,cntp_delr_id,cntp_delr_name,trd_cntp_ins_rela_typ,secu_id,secu_code,blooaberg_code,cusip_code,isin_code,ric_code,sedol_code,secu_sht,typ_code,typ_codei,typ_codeii,secu_class_o3,secu_class_name_o3,secu_type_o3,secu_type_name_o3,oth_class_o3,exch_code,exch_name,curr_code,trd_curr_code,is_prc_bond,mkt_tnv_val,mkt_tnv_vol,open_prc,mkt_tnv_avg_prc,mkt_low_prc,mkt_high_prc,mkt_cls_prc,mkt_last_prc,day_chg_rat,cnbd_valu,cstd_ins_id,cstd_ins_name,ext_rat,inr_rat,com_id,com_name,issr_inr_rat,issr_ext_rat,guar_id,guar_rat,ocom_id,excf_dt,excf_time,busi_prss_clas_o3,busi_prss_clas_name_o3,excf_tnv_stat,excf_tnv_stat_name,dpsi_srte_dt,dpsi_end_dt,expe_yld,dpsi_rat,bnk_hbnk_id,bnk_hbnk_name,dpsi_site,dpsi_ahed_coll_lim,dpsi_accr_intr,dpsi_aggr_intr_incm,in_secu_id,in_secu_code,in_secu_name,in_exch_code,in_exch_name,in_com_id,in_com_name,in_tnv_vol,in_tnv_prc,in_tnv_val,in_occu_val,in_fee,huge_redp_mode,rf_val,makp_val,rf_intr,marg,feer,tnv_val_nav,prc_high,tnv_val_full,occu_val_full,tnv_prc_full,end_valu_yld,cptl_dir,secu_dir,tnv_flag,busi_date,sys_rs_id,task_rs_id,dm_created_time,p_dt)
SELECT
occu_dt,prd_code,null as src_fund_src,prd_name,prd_full_name,crrc,prd_clas,prd_clas_name,ttl_navl,ast_unit_code,src_ast_unit_no,ast_unit_name,src_ast_unit_onum,pfl_code,src_pfl_no,pfl_name,odr_onum,src_odr_onum,src_odr_chg_onum,src_odr_secu_onum,odr_rela_prsn,odr_rela_agt_prsn,odr_oper_lvl,odr_vol,trd_typ,entr_onum,src_entr_onum,entr_bath,rep_no,prc_clas,entr_vol,entr_prc,tnv_onum,src_tnv_onum,tnv_no,tnv_time,busi_typ,busi_clas,entr_dir_o3,entr_dir_name_o3,busi_clas_o3,busi_clas_name_o3,sh_code,seat_code,inv_typ,src_inv_typ,null as src_inv_typ_name,clr_sped,tnv_vol,tnv_prc,net_prc,full_prc,tnv_val,tnv_val_locy,occu_val,covr_pl,is_forc_covr,tot_fee,stmp,tfee,sfee,hand_fee,cms,clea_chag,deli_fee,trd_chag,clea_serv_chag,pr_fee,oth_fee,full_tfee,sett_mode,deli_dt,sett_fail_flag,oper_no,oper_name,
case
   when busi_clas in ('02010106','02010107','05000100','05000101','05000103','05000104','05000105','05010100','05010101','05010103','05010104','05010105','05010106','05010107','05030100','05030101','05040100','05040102','05040103','05040200','05040202','05040203','05030100','05030101','06000100','06000108','06000106','06000107','06000103','06000105','07000100','07000101','08000100','08000101','08000200','08000201','08000203','08000204','09000309','09000300','09000310','09000311','09000312','09000302','09000313','09000314','09000315','09000304','09000316','09000317','09000306','09000318','10000101','11000101','11000301','14000201','15000201','15000203','21000105','21000102','21000103','21000106','21000107','23000106','23000108','25000100','25000101')
   then 0
   when busi_clas in ('05000102','05010102','05030102','05040101','05040201','05030102','06000102','06000104','08000102','08000202','09000301','09000303','09000305','09000307','09000308','10000100','11000100','11000300','12000100','12000300','13000100','13000200','14000100','14000101','14000102','14000103','14000200','15000100','15000101','15000200','15000202','16000300','16000301','16000302','16000303','16000304','18000100','18000101','18000300','18000301','19000100','19000301','20000100','20000101','21000100','21000101','21000104','21000108','21000109','23000100','23000101','23000102','23000103','23000104','23000105','23000107','26000100','26000101')
   then 1
   when busi_clas in ('01000100','01000101','01000102','01000103','01000200','01000201','02000100','02000101','02000200','02000201','02000202','02010100','02010101','02010102','02010103','02010104','02010105','03000200','03000201','03000202','04000100','04000101','07000102','22000100','22000101','22000102','22000103','22000104','22000105','22000106','22000107','24000200','24000201')
   then tnv_stat
   when busi_clas in ('06000101') and secu_id like '%BOND%'
   then 1
   when busi_clas in ('06000101') and secu_id like '%STK%'
   then 0
end as tnv_stat,
m1.para_cname as tnv_stat_name,
null as inbk_stat,null as inbk_stat_name,memo,fir_deli_dt,end_deli_dt,fir_deli_mode,end_deli_mode,fir_net_prc,end_net_prc,fir_hd_intr,end_hd_intr,fir_yld,end_yld,exer_yld,valu_yld,repo_rat,repo_days,buyb_val,inta_days,trad_id,trad_name,trd_cntp_id,cntp_sht,cntp_name,cntp_seat_code,cntp_delr_id,cntp_delr_name,trd_cntp_ins_rela_typ,secu_id,secu_code,blooaberg_code,cusip_code,isin_code,ric_code,sedol_code,secu_sht,typ_code,typ_codei,typ_codeii,secu_class_o3,secu_class_name_o3,secu_type_o3,secu_type_name_o3,oth_class_o3,exch_code,exch_name,curr_code,trd_curr_code,is_prc_bond,mkt_tnv_val,mkt_tnv_vol,open_prc,mkt_tnv_avg_prc,mkt_low_prc,mkt_high_prc,mkt_cls_prc,mkt_last_prc,day_chg_rat,cnbd_valu,cstd_ins_id,cstd_ins_name,ext_rat,inr_rat,com_id,com_name,issr_inr_rat,issr_ext_rat,guar_id,guar_rat,ocom_id,excf_dt,excf_time,busi_prss_clas_o3,busi_prss_clas_name_o3,null as excf_tnv_stat,null as excf_tnv_stat_name,dpsi_srte_dt,dpsi_end_dt,expe_yld,dpsi_rat,bnk_hbnk_id,bnk_hbnk_name,dpsi_site,dpsi_ahed_coll_lim,dpsi_accr_intr,dpsi_aggr_intr_incm,in_secu_id,in_secu_code,in_secu_name,in_exch_code,in_exch_name,in_com_id,in_com_name,in_tnv_vol,in_tnv_prc,in_tnv_val,in_occu_val,in_fee,huge_redp_mode,rf_val,makp_val,rf_intr,marg,feer,tnv_val_nav,prc_high,tnv_val_full,occu_val_full,tnv_prc_full,end_valu_yld,
case
   when busi_clas in ('01000101','01000103','01000201','02010107','07000100','07000101','08000100','08000101','08000102','08000200','08000201','08000202','08000203','08000204','09000315','09000304','09000305','09000316','09000317','09000306','09000307','11000100','11000101','11000300','11000301','13000100','13000200','14000100','14000101','14000102','14000103','14000200','14000201','15000100','15000101','15000200','15000201','15000202','15000203','16000301','16000302','16000303','16000304','19000100','22000107','23000101','23000103','23000105','23000106','26000100')
   then -1
   when busi_clas in ('02000202','02010103','03000202','04000100','04000101','05000105','05010107','06000107','06000105','10000100','10000101','18000100','18000101','18000300','18000301','20000100','20000101','21000100','21000101','21000104','21000105','21000102','21000103','21000106','21000107','21000108','21000109','23000107','23000108','25000100','25000101')
   then 0
   when busi_clas in ('01000100','01000102','01000200','02010106','05000100','05000101','05000102','05000103','05000104','05010100','05010101','05010102','05010103','05010104','05010105','05010106','05030100','05030101','05030102','05040100','05040101','05040102','05040103','05040200','05040201','05040202','05040203','05030100','05030101','05030102','06000100','06000101','06000102','06000108','06000106','06000103','06000104','07000102','09000309','09000300','09000310','09000301','09000311','09000312','09000302','09000313','09000303','09000314','09000318','09000308','12000100','12000300','16000300','19000301','22000100','22000101','22000102','22000103','22000104','22000105','22000106','23000100','23000102','23000104','26000101')
   then 1
   when busi_clas in ('02000100','02000200','02010100','03000200','24000200') and pos_id = 'L'
   then 1
   when busi_clas in ('02000100','02000200','02010100','03000200','24000200') and pos_id = 'S'
   then -1
   when busi_clas in ('02000101','02000201','02010101','02010102','02010105','03000201','24000201') and pos_id = 'S'
   then 1
   when busi_clas in ('02000101','02000201','02010101','02010102','02010105','03000201','24000201') and pos_id = 'L'
   then -1
   when busi_clas in ('02010104') and entr_dir in ('104','105')
   then 1
   when busi_clas in ('02010104') and entr_dir in ('103','106')
   then -1
end as cptl_dir,
case
   when busi_clas in ('01000101','01000103','01000201','06000103','07000101','08000100','08000101','08000102','08000200','08000201','08000202','08000203','08000204','09000315','09000304','09000305','09000316','09000317','09000306','09000307','14000100','14000101','14000102','14000200','14000201','15000101','15000202','15000203','16000301','16000302','16000304','18000101','18000301','20000100','21000100','21000104','21000102','21000106','21000108','22000101','22000102','22000103','22000105','23000101','23000103','26000100')
   then -1
   when busi_clas in ('02000202','02010103','02010106','02010107','03000202','04000100','04000101','05000105','05010107','06000107','06000105','11000100','11000101','11000300','11000301','13000100','13000200','14000103','15000100','15000200','15000201','16000303','19000100','19000301','22000106','22000107','23000105','23000106','25000100','25000101')
   then 0
   when busi_clas in ('01000100','01000102','01000200','05000100','05000101','05000102','05000103','05000104','05010100','05010101','05010102','05010103','05010104','05010105','05010106','05030100','05030101','05030102','05040100','05040101','05040102','05040103','05040200','05040201','05040202','05040203','05030100','05030101','05030102','06000100','06000101','06000102','06000108','06000106','06000104','07000100','07000102','09000309','09000300','09000310','09000301','09000311','09000312','09000302','09000313','09000303','09000314','09000318','09000308','10000100','10000101','12000100','12000300','16000300','18000100','18000300','20000101','21000101','21000103','21000107','21000109','22000100','22000104','23000100','23000102','23000104','23000107','23000108','26000101','21000105')
   then 1
   when busi_clas in ('02000100','02000200','02010100','03000200','24000200') and pos_id = 'L'
   then 1
   when busi_clas in ('02000100','02000200','02010100','03000200','24000200') and pos_id = 'S'
   then -1
   when busi_clas in ('02000101','02000201','02010101','02010102','02010105','03000201','24000201') and pos_id = 'S'
   then 1
   when busi_clas in ('02000101','02000201','02010101','02010102','02010105','03000201','24000201') and pos_id = 'L'
   then -1
   when busi_clas in ('02010104') and entr_dir in ('104','105')
   then 1
   when busi_clas in ('02010104') and entr_dir in ('103','106')
   then -1
end as secu_dir,
case
   when busi_clas in ('02000202','02010103','02010106','02010107','03000202','04000100','04000101','05000101','05000103','05000104','05000105','05010101','05010107','05030101','05040102','05040202','05030101','06000100','06000108','06000106','06000107','06000103','06000105','07000100','07000101','08000101','08000201','08000203','10000101','11000101','23000106','23000108','25000100','25000101')
   then 0
   when busi_clas in ('01000100','01000101','01000102','01000103','01000200','01000201','02000100','02000101','02000200','02000201','02010100','02010101','02010102','02010104','02010105','03000200','03000201','05000102','05010102','05030102','05040101','05040201','05030102','06000102','06000104','07000102','08000102','08000202','09000301','09000303','09000305','09000307','09000308','10000100','11000100','11000300','12000100','12000300','13000100','13000200','14000100','14000101','14000102','14000103','14000200','15000100','15000101','15000200','15000202','16000300','16000301','16000302','16000303','16000304','18000100','18000101','18000300','18000301','19000100','19000301','20000100','20000101','21000100','21000101','21000104','21000108','21000109','22000100','22000101','22000102','22000103','22000104','22000105','22000106','22000107','23000100','23000101','23000102','23000103','23000104','23000105','23000107','24000200','24000201','26000100','26000101')
   then 1
   when busi_clas in ('05000100','05010100','05030100','05040100','05040200','05030100','08000100','08000200','09000300','09000302','09000304','09000306','09000318','21000106','21000107')
   then 2
   when busi_clas in ('05010103','05010104','05010105','05010106','05040103','05040203','08000204','09000310','09000311','09000313','09000314','09000316','09000317','11000301','14000201','15000201','15000203','21000105')
   then 3
   when busi_clas in ('09000309','09000312','09000315','21000102','21000103')
   then 4
   when busi_clas in ('06000101') and secu_id like '%BOND%'
   then 1
   when busi_clas in ('06000101') and secu_id like '%STK%'
   then 0
end as tnv_flag,
busi_date,sys_rs_id,task_rs_id,dm_created_time,p_dt
from (
select 		 t0.POS_ID,T0.ENTR_DIR,
			 t0.occu_dt as occu_dt, --发生日期
             t0.prd_code as prd_code, --产品代码
             t1.trd_sys_id as src_fund_id, --源基金编号
             t2.prd_name as prd_name, --产品名称
             t2.prd_full_name as prd_full_name, --产品全称
             t2.crrc as crrc, --产品本币币种
             t3.dim_value as prd_clas, --产品类型
             m10.para_cname as prd_clas_name, --产品类型名称
             t0.ast_unit_code as ast_unit_code, --资产单元代码
             substr(t0.ast_unit_code, instr(t0.ast_unit_code, '_') + 1) as src_ast_unit_no, --源资产单元编号
             t4.ast_unit_name as ast_unit_name, --资产单元名称
             t4.src_sys_code as src_ast_unit_onum, --源资产单元序号
             t0.pfl_code as pfl_code, --投组代码
             substr(t0.pfl_code, locate('_',t0.pfl_code,locate('_',t0.pfl_code,2)+1 ) + 1) as src_pfl_no, --源组合编号
             t5.pfl_name as pfl_name, --投资组合名称
             t0.odr_onum as odr_onum, --指令序号
             substr(t0.odr_onum,
                    locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 ) + 1,
                    locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 )+1) -
                    locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 ) - 1) as src_odr_onum, --源指令序号
             substr(t0.odr_onum,
                    locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 )+1) + 1,
                    locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 )+1)+1) -
                    locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 )+1) - 1) as src_odr_chg_onum, --源指令修改次序
             substr(t0.odr_onum, locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 )+1)+1) + 1) as src_odr_secu_onum, --源指令证券序号
             null as odr_rela_prsn, --指令下达人
             null as odr_rela_agt_prsn, --指令代下达人
             null as odr_oper_lvl, --指令操作级别
             null as odr_vol, --指令数量
             null as trd_typ, --交易类别
             t0.entr_onum as entr_onum, --委托序号/执行确认序号
             substr(t0.entr_onum, locate('_',t0.entr_onum,locate('_',t0.entr_onum,2)+1 ) + 1) as src_entr_onum, --源委托序号/执行确认序号
             null as entr_bath, --委托批号
             t0.rep_no as rep_no, --申报编号
             null as prc_clas, --价格类型
             null as entr_vol, --委托数量
             null as entr_prc, --委托价格
             t0.tnv_onum as tnv_onum, --成交序号
             replace(substr(t0.tnv_onum, locate('_',t0.tnv_onum,locate('_',t0.tnv_onum,2)+1 ) + 1),
                     'L',
                     '') as src_tnv_onum, --源委托序号/确认序号
             t0.tnv_no as tnv_no, --成交编号
             case
               when t0.tnv_time is not null then
                CONCAT(substr(lpad(t0.tnv_time, 6, '0'), 1, 2) , ':' ,
                substr(lpad(t0.tnv_time, 6, '0'), -4, 2) , ':' ,
                substr(lpad(t0.tnv_time, 6, '0'), -2, 2))
             end as tnv_time, --成交时间
             t0.busi_typ as busi_typ, --业务类别
             t0.busi_clas as busi_clas, --业务类型
             '' as   busi_clas_dtl_o3,
             '' as  busi_clas_dtl_name_o3,
             t0.entr_dir_o3 as entr_dir_o3, --委托方向_o32
             t0.entr_dir_name_o3 as entr_dir_name_o3, --委托方向名称_o32
             t0.busi_clas_o3 as busi_clas_o3, --业务分类_o32
             m6.para_cname as busi_clas_name_o3, --业务分类名称_o32,根据数据字典818转换
             t0.sh_code as sh_code, --股东代码
             t0.seat_code as seat_code, --席位号
             t0.inv_typ as inv_typ, --投资类型
             m3.para_hcode as src_inv_typ, --源投资类型,根据数据字典125转换，并对1的枚举调整为2，2的枚举调整为1
             m3.para_name as src_inv_name, --源投资类型名称
             t0.clr_sped as clr_sped, --清算速度
             t0.tnv_vol as tnv_vol, --成交数量
             t0.tnv_prc as tnv_prc, --成交价格
             null as net_prc, --净价价格
             null as full_prc, --全价价格
             (case
               when t0.exch_code not in ('SZSC', 'SHSC') THEN
                t0.tnv_val
               else
                cast(t0.tnv_vol as double) * cast(t0.tnv_prc as double)
             end) as tnv_val, --成交金额
             t0.tnv_val as tnv_val_locy, --本币成交金额,当为港币时通过通过汇率信息表中的中间价转换为人名币
             (case
               when t0.exch_code not in ('SZSC', 'SHSC') THEN
                t0.occu_val
               else
                nvl(cast(t0.tnv_vol as double) * cast(t0.tnv_prc as double), 0) +
                (nvl(t0.stmp, 0) + nvl(t0.tfee, 0) + nvl(t0.sfee, 0) +
                 nvl(t0.hand_fee, 0) + nvl(t0.cms, 0) + nvl(t0.clea_chag, 0) +
                 nvl(t0.oth_fee, 0))
             end) as occu_val, --发生金额
             null as covr_pl, --平仓盈亏
             null as is_forc_covr, --是否强平
             (nvl(t0.cms, 0) + nvl(t0.sfee, 0) + nvl(t0.hand_fee, 0)) as tot_fee, --总费用=佣金+经手费+证管费
             t0.stmp as stmp, --印花税
             t0.tfee as tfee, --过户费
             t0.sfee as sfee, --证管费
             t0.hand_fee as hand_fee, --经手费
             t0.cms as cms, --佣金
             t0.clea_chag as clea_chag, --结算费
             0 as deli_fee, --交割费
             0 as trd_chag, --交易手续费
             0 as clea_serv_chag, --结算服务费
             0 as pr_fee, --申赎费用
             nvl(t0.oth_fee, 0) as oth_fee, --其他费用
             nvl(t0.full_tfee, 0) as full_tfee, --全额过户费
             null as sett_mode, --结算方式
             t0.deli_dt as deli_dt, --交割日期
             null as sett_fail_flag, --交收失败标识
             t0.oper_no as oper_no, --操作员
             t6.oper_name as oper_name, --操作员名称
             null as memo, --备注
             t0.fir_deli_dt as fir_deli_dt, --首期交割日期
             t0.end_deli_dt as end_deli_dt, --到期交割日期
             t0.fir_deli_mode as fir_deli_mode, --首期交割方式
             t0.end_deli_mode as end_deli_mode, --到期交割方式
             null as fir_net_prc, --首期净价价格
             null as end_net_prc, --到期净价价格
             null as fir_hd_intr, --首期百元利息
             null as end_hd_intr, --到期百元利息
             null as fir_yld, --首期收益率
             null as end_yld, --到期收益率
             null as exer_yld, --行权收益率
             null as valu_yld, --公允收益率
             t0.rat as repo_rat, --回购利率
             t0.cont_days as repo_days, --回购天数/合约天数
             t0.buyb_val as buyb_val, --购回金额
             t0.inta_days as inta_days, --计息天数
             t0.trad_id as trad_id, --券商编号
             t21.trad_name as trad_name, --券商名称
             t0.trd_cntp_id as trd_cntp_id, --交易对手编码
             t7.cntp_sht as cntp_sht, --对手方简称
             t7.cntp_name as cntp_name, --对手全称
             null as cntp_seat_code, --对方席位号
             null as cntp_delr_id, --对手方交易员
             null as cntp_delr_name, --对手方交易员名称
             null as trd_cntp_ins_rela_typ, --交易对手机构主从类型
             t0.secu_id as secu_id, --证券编码
             t0.secu_code as secu_code, --证券代码
             null as blooaberg_code, --bloomberg
             null as cusip_code, --cusip
             t8.isin_code as isin_code, --isin
             null as ric_code, --ric
             null as sedol_code, --sedol
             t8.secu_sht as secu_sht, --中文简称
             t8.typ_code as typ_code, --证券类别代码（大类）
             t8.typ_codei as typ_codei, --证券类别代码（中类）
             t8.typ_codeii as typ_codeii, --证券类别代码（细分）
             t9.src_secu_class as secu_class_o3, --资产类别_o3
             m1.para_cname as secu_class_name_o3, --资产类别名称_o3
             t9.src_secu_type as secu_type_o3, --证券类别_o3
             m2.para_cname as secu_type_name_o3, --证券类别名称_o3
             t9.src_oth_class as oth_class_o3, --杂项分类_o3
             t0.exch_code as exch_code, --交易市场代码
             t8.exch_name as exch_name, --交易市场名称
             nvl(t8.curr_code, 'CNY') as curr_code, --货币代码
             nvl(t8.trd_curr_code, 'CNY') as trd_curr_code, --交易货币币种
             t10.is_prc_bond as is_prc_bond, --是否净价债
             t11.tnv_val as mkt_tnv_val, --市场成交额（元）
             t11.tnv_vol as mkt_tnv_vol, --市场成交数量
             (Case
               when t11.tnv_vol > 0 and t0.CONT_MULT<>0 and t0.busi_typ='220001' then --期货交易
                t11.tnv_val / t11.tnv_vol /t0.CONT_MULT
               when t0.busi_typ='220001' then --期货交易
                t11.avg_price
               when t11.tnv_vol > 0 then
                t11.tnv_val / t11.tnv_vol
               else
                nvl(t11.avg_price,0)
             end) as mkt_tnv_avg_prc, --市场成交均价
             t11.open_prc, --今开盘
             t11.low_prc as mkt_low_prc, --市场最低价
             t11.high_prc as mkt_high_prc, --市场最高价
             t11.cls_prc as mkt_cls_prc, --市场收盘价
             t11.cls_prc as mkt_last_prc, --市场最新价
             t11.day_chg_rat as day_chg_rat, --日涨跌幅
             null as cnbd_valu, --中债估值
             t10.cstd_ins_id as cstd_ins_id, --托管机构
             m8.para_cname as cstd_ins_name, --托管机构名称
             t12.rat_name as ext_rat, --外部评级
             t13.rat_name as inr_rat, --内部评级
             t8.com_id as com_id, --发行机构编号
             t8.com_name as com_name, --发行机构名称
             t14.rat_name as issr_inr_rat, --发行人内部评级
             t15.rat_name as issr_ext_rat, --发行人外部评级
             t10.guar_id as guar_id, --担保人id
             t16.rat_name as guar_rat, --担保人评级
             t10.ocom_id as ocom_id, --最初发行人/原始权益人id
             t10.ocom_name as ocom_name, --最初发行人/原始权益人名称
             null as excf_dt, --确认日期
             null as excf_time, --确认时间
             null as busi_prss_clas_o3, --业务过程分类_o32
             null as busi_prss_clas_name_o3, --业务过程分类名称_o32
             t0.tnv_stat as tnv_stat, --成交状态
             m5.para_cname as tnv_stat_name, --成交状态名称
             null as dpsi_srte_dt, --存款起息日期
             null as dpsi_end_dt, --存款到期日期
             null as expe_yld, --理财产品预期收益率
             null as dpsi_rat, --存款利率
             null as bnk_hbnk_id, --银行总行编码
             null as bnk_hbnk_name, --银行总行名称
             null as dpsi_site, --存款地方
             null as dpsi_ahed_coll_lim, --存款提前支取限制
             null as dpsi_accr_intr, --存款应计利息
             null as dpsi_aggr_intr_incm, --存款累计利息收入
             null as in_secu_id, --转入证券编码
             null as in_secu_code, --转入证券代码
             null as in_secu_name, --转入证券名称
             null as in_exch_code, --转入交易市场代码
             null as in_exch_name, --转入交易市场名称
             null as in_com_id, --转入发行机构编号
             null as in_com_name, --转入发行机构名称
             null as in_tnv_vol, --转入成交数量
             null as in_tnv_prc, --转入成交价格
             null as in_tnv_val, --转入成交金额
             null as in_occu_val, --转入发生金额
             null as in_fee, --转入费用
             null as huge_redp_mode, --巨额赎回方式
             0 as rf_val, --退款金额
             0 as makp_val, --补款金额
             0 as rf_intr, --退款利息
             0 as marg, --保证金
             0 as feer, --费率
             t17.ttl_navl, --净资产
             (Case
               when t17.ttl_navl = 0 then
                0
               else
                (case
                  when t0.exch_code not in ('SZSC', 'SHSC') THEN
                   t0.tnv_val
                  else
                   t0.tnv_vol * t0.tnv_prc
                end) / t17.ttl_navl
             end) as tnv_val_nav, --成交金额占净值(%)
             null as prc_high, --价格偏离
             ((case
               when t10.is_prc_bond = 1 and t0.clr_sped = 1 and
                    t0.guar_sett_flag = 0 then
                nvl(t0.tnv_val, 0) +
                nvl(t0.tnv_vol * t22.hund_intr_bfr_tax_tmw, 0)
               when t10.is_prc_bond = 1 then
                nvl(t0.tnv_val, 0) +
                nvl(t0.tnv_vol * t22.hund_intr_bfr_tax_bs, 0)
               else
                nvl((case
                      when t0.exch_code not in ('SZSC', 'SHSC') THEN
                       t0.tnv_val
                      else
                       t0.tnv_vol * t0.tnv_prc
                    end),
                    0)
             end)) * (case
               when t0.busi_clas = '01000100' or
                    (t0.busi_clas in ('02000100', '02000101') and
                    t0.pos_id = 'S') then
                -1
               else
                1
             end) - ((nvl(t0.stmp, 0) + nvl(t0.tfee, 0) + nvl(t0.sfee, 0) +
             nvl(t0.hand_fee, 0) + nvl(t0.clea_chag, 0) +
             nvl(t0.oth_fee, 0) + nvl(t0.full_tfee, 0))) as occu_val_full, --发生金额（全价） 成交金额-除佣金外所有费用,买入和逆回购做-1处理
             (case
               when t10.is_prc_bond = 1 and t0.clr_sped = 1 and
                    t0.guar_sett_flag = 0 then
                nvl(t0.tnv_val, 0) +
                nvl(t0.tnv_vol * t22.hund_intr_bfr_tax_tmw, 0)
               when t10.is_prc_bond = 1 then
                nvl(t0.tnv_val, 0) +
                nvl(t0.tnv_vol * t22.hund_intr_bfr_tax_bs, 0)
               else
                nvl((case
                      when t0.exch_code not in ('SZSC', 'SHSC') THEN
                       t0.tnv_val
                      else
                       t0.tnv_vol * t0.tnv_prc
                    end),
                    0)
             end) * (case
               when t0.busi_clas = '01000100' or
                    (t0.busi_clas in ('02000100', '02000101') and
                    t0.pos_id = 'S') then
                -1
               else
                1
             end) as tnv_val_full, --成交金额（全价）
             (case
               when t10.is_prc_bond = 1 and t0.clr_sped = 1 and
                    t0.guar_sett_flag = 0 then
                nvl(t0.tnv_prc, 0) + nvl(t22.hund_intr_bfr_tax_tmw, 0)
               when t10.is_prc_bond = 1 then
                nvl(t0.tnv_prc, 0) + nvl(t22.hund_intr_bfr_tax_bs, 0)
               else
                nvl(t0.tnv_prc, 0)
             end) as tnv_prc_full, --成交价格（全价）
             null as end_valu_yld, --到期收益率-公允收益率
             ${end_date} AS BUSI_DATE, --业务日期
             NULL AS UPD_TIME, --源数据更新时间
             'O3' AS SYS_RS_ID, --系统来源标识
             'mid_l2_prd_tnv_dtl_1' AS TASK_RS_ID, --任务来源标识
             'evt_exch_tnv_his' AS DM_SRC_INFO, --来源信息
             CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
             'OUTLINE' AS DM_CREATED_BY, --数据中台创建者
             CURRENT_TIMESTAMP AS DM_UPDATED_TIME, --数据中台更新时间
             'OUTLINE' AS DM_UPDATED_BY,
             CONT_MULT, --合约乘数
	     t0.occu_dt as  p_dt
        from ${dwd_db}.evt_exch_tnv_his t0
        left join ${dwd_db}.pty_prd_code_rela_o32 t1
          on t0.prd_code = t1.prd_code
         and t1.sys_rs_id = 'O3'
        left join ${dwd_db}.pty_prd_base_info_o32 t2
          on t0.prd_code = t2.prd_code
        left join ${dwd_db}.pty_prd_fetu_exd_dt_o32 t3
          on t0.prd_code = t3.prd_code
         and t3.dim_code = '1'
        left join ${dwd_db}.pro_acc_asset_unit_info t4
          on t0.ast_unit_code = t4.ast_unit_code
        left join ${dwd_db}.pro_acc_pfl t5
          on t0.pfl_code = t5.pfl_code
        left join ${dwd_db}.pty_oper_info t6
          on t0.oper_no = t6.oper_no
        left join ${dwd_db}.pty_cutp_info t7
          on t0.trd_cntp_id = t7.cutp_id
        left join ${dwd_db}.var_secu_info_o32 t8
          on t0.secu_id = t8.secu_id
        left join ${dwd_db}.var_secu_code_conf t9
          on t0.occu_Dt = t9.occu_dt
         and (case
               when t0.busi_clas in ('02000100', '02000101') then
                substr(t0.secu_id, locate('_',t0.secu_id,locate('_',t0.secu_id,locate('_',t0.secu_id,2)+1 )+1) + 1)
               else
                t0.secu_id
             end) = t9.secu_id
        left join ${dwd_db}.var_bond_info_o32 t10
          on t0.secu_id = t10.secu_id
        left join ${dwd_db}.var_secu_dquot_o32 t11
          on (case
               when t0.busi_clas in ('02000100', '02000101') then
                substr(t0.secu_id, locate('_',t0.secu_id,locate('_',t0.secu_id,locate('_',t0.secu_id,2)+1 )+1) + 1)
               else
                t0.secu_id
             end) = t11.secu_id
         and t0.occu_Dt = t11.trd_dt
        left join ${dwd_db}.var_bond_rat_o32 t12
          on t0.secu_id = t12.secu_id
         and t0.occu_dt = t12.rat_dt
         and t12.rat_sign = '1'
        left join ${dwd_db}.var_bond_rat_o32 t13
          on t0.secu_id = t13.secu_id
         and t0.occu_dt = t13.rat_dt
         and t13.rat_sign = '2'
        left join ${dwd_db}.pty_rat_o32 t14
          on t8.com_id = t14.com_id
         and t14.rat_obj_code = '3'
        left join ${dwd_db}.pty_rat_o32 t15
          on t8.com_id = t15.com_id
         and t15.rat_obj_code = '2'
        left join ${dwd_db}.pty_rat_o32 t16
          on t10.guar_id = t16.com_id
         and t16.rat_obj_code = '4'
        left join ${dwd_db}.ast_prd_ast_his t17
          on t0.prd_code = t17.prd_code
         and t0.occu_Dt = t17.occu_Dt
        left join ${dwd_db}.var_excr_info_o32 t20
          on t20.exer_rs = 2
         and t8.trd_curr_code = t20.basi_curr
         and t0.occu_Dt = t20.excr_dt
         and t20.excr_dt BETWEEN ${beg_date} AND ${end_date}
        left join ${dwd_db}.pro_acc_trad_info t21
          on t0.trad_id = t21.trad_id
        left join ${dwd_db}.var_bond_accr_intr_o32 t22
          on t0.occu_Dt = t22.trd_dt
         and t0.secu_id = t22.secu_id
         and t22.trd_dt BETWEEN ${beg_date} AND ${end_date}
        left join ${dwd_db}.pub_para_info m1
          on t9.src_secu_class = m1.para_hcode
         and m1.para_class_hcode = '817'
        left join ${dwd_db}.pub_para_info m2
          on t9.src_secu_type = m2.para_hcode
         and m2.para_class_hcode = '822'
        left join ${dwd_db}.pub_para_mapping m3
          on t0.inv_typ = m3.orisys_para_code
         and m3.para_class_hcode = '125'
        left join ${dwd_db}.pub_para_info m5
          on t0.tnv_stat = m5.para_hcode
         and m5.para_class_hcode = '825'
        left join ${dwd_db}.pub_para_info m6
          on t0.busi_clas_o3 = m6.para_hcode
         and m6.para_class_hcode = '818'
        left join ${dwd_db}.pub_para_info m8
          on t10.cstd_ins_id = m8.para_hcode
         and m8.para_class_hcode = '813'
        left join ${dwd_db}.pub_para_info m10
          on t3.dim_value = m10.para_hcode
         and m10.para_class_hcode = '823'
       WHERE t0.occu_dt BETWEEN ${beg_date} AND ${end_date}

       union all

	  select t0.POS_ID,T0.ENTR_DIR,
			 t0.occu_dt as occu_dt, --发生日期
             t0.prd_code as prd_code, --产品代码
             t1.trd_sys_id as src_fund_id, --源基金编号
             t2.prd_name as prd_name, --产品名称
             t2.prd_full_name as prd_full_name, --产品全称
             t2.crrc as crrc, --产品本币币种
             t3.dim_value as prd_clas, --产品类型
             m10.para_cname as prd_clas_name, --产品类型名称
             t0.ast_unit_code as ast_unit_code, --资产单元代码
             substr(t0.ast_unit_code, instr(t0.ast_unit_code, '_') + 1) as src_ast_unit_no, --源资产单元编号
             t4.ast_unit_name as ast_unit_name, --资产单元名称
             t4.src_sys_code as src_ast_unit_onum, --源资产单元序号
             t0.pfl_code as pfl_code, --投组代码
             substr(t0.pfl_code, locate('_',t0.pfl_code,locate('_',t0.pfl_code,2)+1 ) + 1) as src_pfl_no, --源组合编号
             t5.pfl_name as pfl_name, --投资组合名称
             t0.odr_onum as odr_onum, --指令序号
             substr(t0.odr_onum,
                    locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 ) + 1,
                    locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 )+1) -
                    locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 ) - 1) as src_odr_onum, --源指令序号
             substr(t0.odr_onum,
                    locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 )+1) + 1,
                    locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 )+1)+1)-
                    locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 )+1) - 1) as src_odr_chg_onum, --源指令修改次序
             substr(t0.odr_onum, locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 )+1)+1)
 + 1) as src_odr_secu_onum, --源指令证券序号
             null as odr_rela_prsn, --指令下达人
             null as odr_rela_agt_prsn, --指令代下达人
             null as odr_oper_lvl, --指令操作级别
             null as odr_vol, --指令数量
             null as trd_typ, --交易类别
             t0.excf_onum as entr_onum, --委托序号/执行确认序号
             substr(t0.excf_onum, locate('_',t0.excf_onum,locate('_',t0.excf_onum,2)+1 ) + 1) as src_entr_onum, --源委托序号/执行确认序号
             null as entr_bath, --委托批号
             null as rep_no, --申报编号
             null as prc_clas, --价格类型
             null as entr_vol, --委托数量
             null as entr_prc, --委托价格
             t0.tnv_onum as tnv_onum, --成交序号
             replace(substr(t0.tnv_onum, locate('_',t0.tnv_onum,locate('_',t0.tnv_onum,2)+1 ) + 1),
                     'l',
                     '') as src_tnv_onum, --源委托序号/确认序号
             t0.tnv_no as tnv_no, --成交编号
             case
               when t0.tnv_time is not null then
                CONCAT(substr(lpad(t0.tnv_time, 6, '0'), 1, 2) , ':' ,
                substr(lpad(t0.tnv_time, 6, '0'), -4, 2) , ':' ,
                substr(lpad(t0.tnv_time, 6, '0'), -2, 2))
             end as tnv_time, --成交时间
             t0.busi_typ as busi_typ, --业务类别
             t0.busi_clas as busi_clas, --业务类型
             null as busi_clas_dtl_o3, --业务类型明细_O3
             null as busi_clas_dtl_name_o3, --业务类型明细名称_O3
             t0.entr_dir_o3 as entr_dir_o3, --委托方向_o32
             t0.entr_dir_name_o3 as entr_dir_name_o3, --委托方向名称_o32
             t0.busi_clas_o3 as busi_clas_o3, --业务分类_o32
             m6.para_cname as busi_clas_name_o3, --业务分类名称_o32
             t0.sh_code as sh_code, --股东代码
             t0.seat_code as seat_code, --席位号
             t0.inv_typ as inv_typ, --投资类型
             m3.para_hcode as src_inv_typ, --源投资类型
             m3.para_name as src_inv_name, --源投资类型名称
             t0.clr_sped as clr_sped, --清算速度
             t0.par_gamt / 100 as tnv_vol, --成交数量
             t0.tnv_prc as tnv_prc, --成交价格
             t0.net_prc as net_prc, --净价价格
             t0.full_prc as full_prc, --全价价格
             t0.tnv_val as tnv_val, --成交金额
             t0.tnv_val as tnv_val_locy, --本币成交金额
             t0.occu_val as occu_val, --发生金额
             null as covr_pl, --平仓盈亏
             null as is_forc_covr, --是否强平
             nvl(t0.trd_chag, 0) + nvl(t0.clea_serv_chag, 0) + nvl(t0.oth_fee, 0) as tot_fee, --总费用
             0 as stmp, --印花税
             0 as tfee, --过户费
             0 as sfee, --证管费
             0 as hand_fee, --经手费
             0 as cms, --佣金
             0 as clea_chag, --结算费
             0 as deli_fee, --交割费
             t0.trd_chag as trd_chag, --交易手续费
             t0.clea_serv_chag as clea_serv_chag, --结算服务费
             0 as pr_fee, --申赎费用
             t0.oth_fee as oth_fee, --其他费用
             0 as full_tfee, --全额过户费
             (case
               when t0.busi_typ = '010002' then
                '3'
             end) as sett_mode, --结算方式，债券补充
             (case
               when t0.busi_typ = '010002' then
                t0.deli_dt
             end) as deli_dt, --交割日期，只有债券买入卖出有交割日
             t0.sett_fail_flag as sett_fail_flag, --交收失败标识
             t0.oper_no as oper_no, --操作员
             t6.oper_name as oper_name, --操作员名称
             t0.memo as memo, --备注
             t0.fir_deli_dt as fir_deli_dt, --首期交割日期
             t0.end_deli_dt as end_deli_dt, --到期交割日期
             t0.fir_deli_mode as fir_deli_mode, --首期交割方式
             t0.end_deli_mode as end_deli_mode, --到期交割方式
             t0.fir_net_prc as fir_net_prc, --首期净价价格
             t0.end_net_prc as end_net_prc, --到期净价价格
             t0.fir_hd_intr as fir_hd_intr, --首期百元利息
             t0.end_hd_intr as end_hd_intr, --到期百元利息
             null as fir_yld, --首期收益率
             t0.end_yld as end_yld, --到期收益率
             null as exer_yld, --行权收益率
             null as valu_yld, --公允收益率
             t0.rat as repo_rat, --回购利率
             t0.cont_days as repo_days, --回购天数/合约天数
             t0.buyb_val as buyb_val, --购回金额
             t0.inta_days as inta_days, --计息天数
             null as trad_id, --券商编号
             null as trad_name, --券商名称
             t0.trd_cntp_id as trd_cntp_id, --交易对手编码
             nvl(t7.cntp_sht,t18.BNK_HBNK_NAME) as cntp_sht, --对手方简称
             nvl(t7.cntp_name,t18.BNK_HBNK_NAME) as cntp_name, --对手全称
             null as cntp_seat_code, --对方席位号
             t0.cntp_delr_id as cntp_delr_id, --对手方交易员
             t0.cntp_delr_name, --对手方交易员名称
             t7.ins_rela_typ as trd_cntp_ins_rela_typ, --交易对手机构主从类型
             t0.secu_id as secu_id, --证券编码
             t0.secu_code as secu_code, --证券代码
             null as blooaberg_code, --bloomberg
             null as cusip_code, --cusip
             t8.isin_code as isin_code, --isin
             null as ric_code, --ric
             null as sedol_code, --sedol
             t8.secu_sht as secu_sht, --中文简称
             t8.typ_code as typ_code, --证券类别代码（大类）
             t8.typ_codei as typ_codei, --证券类别代码（中类）
             t8.typ_codeii as typ_codeii, --证券类别代码（细分）
             t9.src_secu_class as secu_class_o3, --资产类别_o3
             m1.para_cname as secu_class_name_o3, --资产类别名称_o3
             t9.src_secu_type as secu_type_o3, --证券类别_o3
             m2.para_cname as secu_type_name_o3, --证券类别名称_o3
             null as oth_class_o3, --杂项分类_o3
             t0.exch_code as exch_code, --交易市场代码
             t8.exch_name as exch_name, --交易市场名称
             nvl(t8.curr_code, 'CNY') as curr_code, --货币代码
             nvl(t8.trd_curr_code, 'CNY') as trd_curr_code, --交易货币币种
             t10.is_prc_bond as is_prc_bond, --是否净价债
             t11.tnv_val as mkt_tnv_val, --市场成交额（元）
             t11.tnv_vol as mkt_tnv_vol, --市场成交数量
             case
               when t11.tnv_vol = 0 then
                0
               else
                t11.tnv_val / t11.tnv_vol
             end as mkt_tnv_avg_prc, --市场成交均价
             t11.open_prc, --今开盘
             t11.low_prc as mkt_low_prc, --市场最低价
             t11.high_prc as mkt_high_prc, --市场最高价
             t11.cls_prc as mkt_cls_prc, --市场收盘加
             t11.cls_prc as mkt_last_prc, --市场最新价
             t11.day_chg_rat as day_chg_rat, --日涨跌幅
             null as cnbd_valu, --中债估值
             nvl(t10.cstd_ins_id, t23.cstd_ins_id) as cstd_ins_id, --托管机构
             nvl(m8.para_cname, m9.para_cname) as cstd_ins_name, --托管机构名称
             t12.rat_name as ext_rat, --外部评级
             t13.rat_name as inr_rat, --内部评级
             t8.com_id as com_id, --发行机构编号
             t8.com_name as com_name, --发行机构名称
             t14.rat_name as issr_inr_rat, --发行人内部评级
             t15.rat_name as issr_ext_rat, --发行人外部评级
             t10.guar_id as guar_id, --担保人id
             t16.rat_name as guar_rat, --担保人评级
             t10.ocom_id as ocom_id, --最初发行人/原始权益人id
             t10.ocom_name as ocom_name, --最初发行人/原始权益人名称
             null as excf_dt, --确认日期
             null as excf_time, --确认时间
             null as busi_prss_clas_o3, --业务过程分类_o32
             null as busi_prss_clas_name_o3, --业务过程分类名称_o32
             t0.stat as tnv_stat, --银行间状态
             m5.para_cname as tnv_stat_name, --银行间状态名称
             null as dpsi_srte_dt, --存款起息日期
             null as dpsi_end_dt, --存款到期日期
             null as expe_yld, --理财产品预期收益率
             null as dpsi_rat, --存款利率
             null as bnk_hbnk_id, --银行总行编码
             null as bnk_hbnk_name, --银行总行名称
             null as dpsi_site, --存款地方
             null as dpsi_ahed_coll_lim, --存款提前支取限制
             null as dpsi_accr_intr, --存款应计利息
             null as dpsi_aggr_intr_incm, --存款累计利息收入
             null as in_secu_id, --转入证券编码
             null as in_secu_code, --转入证券代码
             null as in_secu_name, --转入证券名称
             null as in_exch_code, --转入交易市场代码
             null as in_exch_name, --转入交易市场名称
             null as in_com_id, --转入发行机构编号
             null as in_com_name, --转入发行机构名称
             null as in_tnv_vol, --转入成交数量
             null as in_tnv_prc, --转入成交价格
             null as in_tnv_val, --转入成交金额
             null as in_occu_val, --转入发生金额
             null as in_fee, --转入费用
             null as huge_redp_mode, --巨额赎回方式
             0 as rf_val, --退款金额
             0 as makp_val, --补款金额
             0 as rf_intr, --退款利息
             0 as marg, --保证金
             0 as feer, --费率
             t17.ttl_navl, --净资产
             (Case
               when t17.ttl_navl = 0 then
                0
               else
                t0.tnv_val / t17.ttl_navl
             end) as tnv_val_nav, --成交金额占净值(%)                                                                                                                                                                                                                                                        as               ,--成交金额占净值
             nvl(case
                   when t10.is_prc_bond = '1' then
                     ( case when t11.prev_cls_prc = 0
                           then 0
                           else
                           (t0.net_prc - t11.prev_cls_prc) / t11.prev_cls_prc end )
                   else
                     ( case when t11.prev_cls_prc = 0
                            then 0 else
                           (t0.full_prc - t11.prev_cls_prc) / t11.prev_cls_prc end )
                 end,
                 0) as prc_high, --价格偏离
             (case
               when t10.is_prc_bond = 1 and t0.clr_sped = 1 then
                nvl(t0.tnv_val, 0) +
                nvl(t0.par_gamt * t22.hund_intr_bfr_tax_tmw / 100, 0)
               when t10.is_prc_bond = 1 and t0.clr_sped = 0 then
                nvl(t0.tnv_val, 0) +
                nvl(t0.par_gamt * t22.hund_intr_bfr_tax_bs / 100, 0)
               else
                nvl(t0.tnv_val, 0)
             end) * (case
               when t0.busi_clas = '01000200' or
                    (t0.busi_clas in ('02000100', '02000101') and
                    t0.pos_id = 'S') then
                -1
               else
                1
             end) -
             (nvl(t0.trd_chag, 0) + nvl(t0.clea_serv_chag, 0) + nvl(t0.oth_fee, 0)) as occu_val_full, --发生金额（全价） 成交金额全价-除佣金外所有费用
             (case
               when t10.is_prc_bond = 1 and t0.clr_sped = 1 then
                nvl(t0.tnv_val, 0) +
                nvl(t0.par_gamt * t22.hund_intr_bfr_tax_tmw / 100, 0)
               when t10.is_prc_bond = 1 and t0.clr_sped = 0 then
                nvl(t0.tnv_val, 0) +
                nvl(t0.par_gamt * t22.hund_intr_bfr_tax_bs / 100, 0)
               else
                nvl(t0.tnv_val, 0)
             end) * (case
               when t0.busi_clas = '01000100' or
                    (t0.busi_clas in ('02000100', '02000101') and
                    t0.pos_id = 'S') then
                -1
               else
                1
             end) as tnv_val_full, --成交金额（全价）
             (case
               when t10.is_prc_bond = 1 and t0.clr_sped = 1 then
                nvl(t0.tnv_prc, 0) + nvl(t22.hund_intr_bfr_tax_tmw, 0)
               when t10.is_prc_bond = 1 and t0.clr_sped = 0 then
                nvl(t0.tnv_prc, 0) + nvl(t22.hund_intr_bfr_tax_bs, 0)
               else
                nvl(t0.tnv_prc, 0)
             end) as tnv_prc_full, --成交价格（全价）
             null as end_valu_yld, --到期收益率-公允收益率
             ${end_date} AS BUSI_DATE, --业务日期
             NULL AS UPD_TIME, --源数据更新时间
             'O3' AS SYS_RS_ID, --系统来源标识
             'mid_l2_prd_tnv_dtl_2' AS TASK_RS_ID, --任务来源标识
             'evt_inbk_tnv_his' AS DM_SRC_INFO, --来源信息
             CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
             'OUTLINE' AS DM_CREATED_BY, --数据中台创建者
             CURRENT_TIMESTAMP AS DM_UPDATED_TIME, --数据中台更新时间
             'OUTLINE' AS DM_UPDATED_BY,
	     null as cont_mult,
	     t0.occu_dt as  p_dt
        from ${dwd_db}.evt_inbk_tnv_his t0
        left join ${dwd_db}.pty_prd_code_rela_o32 t1
          on t0.prd_code = t1.prd_code
         and t1.sys_rs_id = 'O3'
        left join ${dwd_db}.pty_prd_base_info_o32 t2
          on t0.prd_code = t2.prd_code
        left join ${dwd_db}.pty_prd_fetu_exd_dt_o32 t3
          on t0.prd_code = t3.prd_code
         and t3.dim_code = '1'
        left join ${dwd_db}.pro_acc_asset_unit_info t4
          on t0.ast_unit_code = t4.ast_unit_code
        left join ${dwd_db}.pro_acc_pfl t5
          on t0.pfl_code = t5.pfl_code
        left join ${dwd_db}.pty_oper_info t6
          on t0.oper_no = t6.oper_no
        left join ${dwd_db}.pty_cutp_info t7
          on t0.trd_cntp_id = t7.cutp_id
        left join ${dwd_db}.var_secu_info_o32 t8
          on t0.secu_id = t8.secu_id
        left join ${dwd_db}.var_secu_code_conf t9
          on t0.secu_id = t9.secu_id
         and t0.occu_dt = t9.occu_dt
        left join ${dwd_db}.var_bond_info_o32 t10
          on t0.secu_id = t10.secu_id
        left join ${dwd_db}.var_secu_dquot_o32 t11
          on t0.secu_id = t11.secu_id
         and t0.occu_dt = t11.trd_dt
        left join ${dwd_db}.var_bond_rat_o32 t12
          on t0.secu_id = t12.secu_id
         and t0.occu_dt = t12.rat_dt
         and t12.rat_sign = '1'
        left join ${dwd_db}.var_bond_rat_o32 t13
          on t0.secu_id = t13.secu_id
         and t0.occu_dt = t13.rat_dt
         and t13.rat_sign = '2'
        left join ${dwd_db}.pty_rat_o32 t14
          on t8.com_id = t14.com_id
         and t14.rat_obj_code = '3'
        left join ${dwd_db}.pty_rat_o32 t15
          on t8.com_id = t15.com_id
         and t15.rat_obj_code = '2'
        left join ${dwd_db}.pty_rat_o32 t16
          on t10.guar_id = t16.com_id
         and t16.rat_obj_code = '4'
        left join ${dwd_db}.ast_prd_ast_his t17
          on t0.prd_code = t17.prd_code
         and t0.occu_Dt = t17.occu_Dt
        left join ${dwd_db}.var_bond_accr_intr_o32 t22
          on t0.occu_Dt = t22.trd_dt
         and t0.secu_id = t22.secu_id
         and t22.trd_dt BETWEEN ${beg_date} AND ${end_date}
        left join (select e1.secu_id, max(e2.cstd_ins_id) cstd_ins_id
                     from ${dwd_db}.evt_inbk_tnv_mort e1
                     join ${dwd_db}.var_bond_info_o32 e2
                       on e1.pldg_secu_id = e2.secu_id
                    group by e1.secu_id) t23
          on t0.secu_id = t23.secu_id
        left join ${dwd_db}.pub_para_info m1
          on t9.src_secu_class = m1.para_hcode
         and m1.para_class_hcode = '817'
        left join ${dwd_db}.pub_para_info m2
          on t9.src_secu_type = m2.para_hcode
         and m2.para_class_hcode = '822'
        left join ${dwd_db}.pub_para_mapping m3
          on t0.inv_typ = m3.orisys_para_code
         and m3.para_class_hcode = '125'
        left join ${dwd_db}.pub_para_info m5
          on t0.stat = m5.para_hcode
         and m5.para_class_hcode = '814'
        left join ${dwd_db}.pub_para_info m6
          on t0.busi_clas_o3 = m6.para_hcode
         and m6.para_class_hcode = '818'
        left join ${dwd_db}.pub_para_info m8
          on t10.cstd_ins_id = m8.para_hcode
         and m8.para_class_hcode = '813'
        left join ${dwd_db}.pub_para_info m9
          on t23.cstd_ins_id = m9.para_hcode
         and m9.para_class_hcode = '813'
        left join ${dwd_db}.pub_para_info m10
          on t3.dim_value = m10.para_hcode
         and m10.para_class_hcode = '823'
        left join ${dwd_db}.pro_dpsi_info t18
          on t0.secu_id = t18.secu_id
       WHERE t0.occu_dt BETWEEN ${beg_date} AND ${end_date}

union all

      select t0.POS_ID,T0.ENTR_DIR,
			 t0.occu_dt as occu_dt, --发生日期
             t0.prd_code as prd_code, --产品代码
             t1.trd_sys_id as src_fund_id, --源基金编号
             t2.prd_name as prd_name, --产品名称
             t2.prd_full_name as prd_full_name, --产品全称
             t2.crrc as crrc, --产品本币币种
             t3.dim_value as prd_clas, --产品类型
             m10.para_cname as prd_clas_name, --产品类型名称
             t0.ast_unit_code as ast_unit_code, --资产单元代码
             substr(t0.ast_unit_code, instr(t0.ast_unit_code, '_') + 1) as src_ast_unit_no, --源资产单元编号
             t4.ast_unit_name as ast_unit_name, --资产单元名称
             t4.src_sys_code as src_ast_unit_onum, --源资产单元序号
             t0.pfl_code as pfl_code, --投组代码
             substr(t0.pfl_code, locate('_',t0.pfl_code,locate('_',t0.pfl_code,2)+1 ) + 1) as src_pfl_no, --源组合编号
             t5.pfl_name as pfl_name, --投资组合名称
             t0.odr_onum as odr_onum, --指令序号
             substr(t0.odr_onum,
                    locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 ) + 1,
                    locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 )+1) -
                    locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 ) - 1) as src_odr_onum, --源指令序号
             substr(t0.odr_onum,
                    locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 )+1)+ 1,
                    locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 )+1)+1) -
                    locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 )+1) - 1) as src_odr_chg_onum, --源指令修改次序
             substr(t0.odr_onum, locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 )+1)+1) + 1) as src_odr_secu_onum, --源指令证券序号
             null as odr_rela_prsn, --指令下达人
             null as odr_rela_agt_prsn, --指令代下达人
             null as odr_oper_lvl, --指令操作级别
             null as odr_vol, --指令数量
             null as trd_typ, --交易类别
             t0.excf_onum as entr_onum, --委托序号/执行确认序号
             substr(t0.excf_onum, locate('_',t0.excf_onum,locate('_',t0.excf_onum,2)+1 )+ 1) as src_entr_onum, --源委托序号/执行确认序号
             null as entr_bath, --委托批号
             null as rep_no, --申报编号
             null as prc_clas, --价格类型
             null as entr_vol, --委托数量
             null as entr_prc, --委托价格
             tt0.tnv_onum as tnv_onum, --成交序号
             replace(replace(substr(t0.excf_onum,
                                    locate('_',t0.excf_onum,locate('_',t0.excf_onum,2)+1 ) + 1),
                             'L',
                             ''),
                     'C',
                     '') as src_tnv_onum, --源委托序号/确认序号
             null as tnv_no, --成交编号
             null as tnv_time, --成交时间
             t0.busi_typ as busi_typ, --业务类别
             t0.busi_clas as busi_clas, --业务类型
             t0.busi_clas_dtl_o3, --业务类型明细_O3
             m11.para_cname as busi_clas_dtl_name_o3, --业务类型明细名称_O3
             t0.entr_dir_o3 as entr_dir_o3, --委托方向_o32
             t0.entr_dir_name_o3 as entr_dir_name_o3, --委托方向名称_o32
             t0.busi_clas_o3 as busi_clas_o3, --业务分类_o32
             m6.para_cname as busi_clas_name_o3, --业务分类名称_o32,根据数据字典818转换
             t0.sh_code as sh_code, --股东代码
             t0.seat_code as seat_code, --席位号
             t0.inv_typ as inv_typ, --投资类型
             m3.para_hcode as src_inv_typ, --源投资类型,根据数据字典125转换，并对1的枚举调整为2，2的枚举调整为1
             m3.para_name as src_inv_name, --源投资类型名称
             null as clr_sped, --清算速度
             t0.entr_vol as tnv_vol, --成交数量
             t0.entr_prc as tnv_prc, --成交价格
             null as net_prc, --净价价格
             null as full_prc, --全价价格
             t0.entr_val as tnv_val, --成交金额
             t0.entr_val as tnv_val_locy, --本币成交金额,当为港币时通过通过汇率信息表中的中间价转换为人名币
             t0.occu_val as occu_val, --发生金额
             null as covr_pl, --平仓盈亏
             null as is_forc_covr, --是否强平
             0 as tot_fee, --总费用
             0 as stmp, --印花税
             0 as tfee, --过户费
             0 as sfee, --证管费
             0 as hand_fee, --经手费
             0 as cms, --佣金
             0 as clea_chag, --结算费
             0 as deli_fee, --交割费
             0 as trd_chag, --交易手续费
             0 as clea_serv_chag, --结算服务费
             0 as pr_fee, --申赎费用
             0 as oth_fee, --其他费用
             0 as full_tfee, --全额过户费
             t0.sett_mode as sett_mode, --结算方式
             null as deli_dt, --交割日期
             null as sett_fail_flag, --交收失败标识
             t0.oper_no as oper_no, --操作员
             t6.oper_name as oper_name, --操作员名称
             null as memo, --备注
             null as fir_deli_dt, --首期交割日期
             null as end_deli_dt, --到期交割日期
             null as fir_deli_mode, --首期交割方式
             null as end_deli_mode, --到期交割方式
             null as fir_net_prc, --首期净价价格
             null as end_net_prc, --到期净价价格
             null as fir_hd_intr, --首期百元利息
             null as end_hd_intr, --到期百元利息
             null as fir_yld, --首期收益率
             null as end_yld, --到期收益率
             null as exer_yld, --行权收益率
             null as valu_yld, --公允收益率
             null as repo_rat, --回购利率
             null as repo_days, --回购天数
             null as buyb_val, --购回金额
             null as inta_days, --计息天数
             null as trad_id, --券商编号
             null as trad_name, --券商名称
             t0.trd_cntp_id as trd_cntp_id, --交易对手编码
             t7.cntp_sht as cntp_sht, --对手方简称
             t7.cntp_name as cntp_name, --对手全称
             null as cntp_seat_code, --对方席位号
             null as cntp_delr_id, --对手方交易员
             null as cntp_delr_name, --对手方交易员名称
             null as trd_cntp_ins_rela_typ, --交易对手机构主从类型
             t0.secu_id as secu_id, --证券编码
             t0.secu_code as secu_code, --证券代码
             null as blooaberg_code, --bloomberg
             null as cusip_code, --cusip
             t8.isin_code as isin_code, --isin
             null as ric_code, --ric
             null as sedol_code, --sedol
             t8.secu_sht as secu_sht, --中文简称
             t8.typ_code as typ_code, --证券类别代码（大类）
             t8.typ_codei as typ_codei, --证券类别代码（中类）
             t8.typ_codeii as typ_codeii, --证券类别代码（细分）
             t9.src_secu_class as secu_class_o3, --资产类别_o3
             m1.para_cname as secu_class_name_o3, --资产类别名称_o3
             t9.src_secu_type as secu_type_o3, --证券类别_o3
             m2.para_cname as secu_type_name_o3, --证券类别名称_o3
             null as oth_class_o3, --杂项分类_o3
             t0.exch_code as exch_code, --交易市场代码
             t8.exch_name as exch_name, --交易市场名称
             nvl(t8.curr_code, 'CNY') as curr_code, --货币代码
             nvl(t8.trd_curr_code, 'CNY') as trd_curr_code, --交易货币币种
             t10.is_prc_bond as is_prc_bond, --是否净价债
             t11.tnv_val as mkt_tnv_val, --市场成交额（元）
             t11.tnv_vol as mkt_tnv_vol, --市场成交数量
             (Case
               when t11.tnv_vol > 0 then
                t11.tnv_val / t11.tnv_vol
               else
                0
             end) as mkt_tnv_avg_prc, --市场成交均价
             t11.open_prc, --今开盘
             t11.low_prc as mkt_low_prc, --市场最低价
             t11.high_prc as mkt_high_prc, --市场最高价
             t11.cls_prc as mkt_cls_prc, --市场收盘加
             t11.cls_prc as mkt_last_prc, --市场最新价
             t11.day_chg_rat as day_chg_rat, --日涨跌幅
             null as cnbd_valu, --中债估值
             null as cstd_ins_id, --托管机构
             null as cstd_ins_name, --托管机构名称
             null as ext_rat, --外部评级
             null as inr_rat, --内部评级
             t8.com_id as com_id, --发行机构编号
             t8.com_name as com_name, --发行机构名称
             null as issr_inr_rat, --发行人内部评级
             null as issr_ext_rat, --发行人外部评级
             t10.guar_id as guar_id, --担保人id
             null as guar_rat, --担保人评级
             t10.ocom_id as ocom_id, --最初发行人/原始权益人id
             t10.ocom_name as ocom_name, --最初发行人/原始权益人名称
             null as excf_dt, --确认日期
             case
               when t0.excf_time is not null then
                CONCAT(substr(lpad(t0.excf_time, 6, '0'), 1, 2) , ':' ,
                lpad(lpad(substr(t0.excf_time, -4, 2), 2, '0'), 2, '0') , ':' ,
                lpad(substr(t0.excf_time, -2, 2), 2, '0'))
             end as excf_time, --确认时间
             t0.busi_prss_clas_o3 as busi_prss_clas_o3, --业务过程分类_o32
             m4.para_cname as busi_prss_clas_name_o3, --业务过程分类名称_o32
             t0.tnv_stat as tnv_stat ,--执行成交状态
             m5.para_cname as tnv_stat_name ,--执行成交状态
             null as dpsi_srte_dt, --存款起息日期
             null as dpsi_end_dt, --存款到期日期
             null as expe_yld, --理财产品预期收益率
             null as dpsi_rat, --存款利率
             null as bnk_hbnk_id, --银行总行编码
             null as bnk_hbnk_name, --银行总行名称
             null as dpsi_site, --存款地方
             null as dpsi_ahed_coll_lim, --存款提前支取限制
             null as dpsi_accr_intr, --存款应计利息
             null as dpsi_aggr_intr_incm, --存款累计利息收入
             null as in_secu_id, --转入证券编码
             null as in_secu_code, --转入证券代码
             null as in_secu_name, --转入证券名称
             null as in_exch_code, --转入交易市场代码
             null as in_exch_name, --转入交易市场名称
             null as in_com_id, --转入发行机构编号
             null as in_com_name, --转入发行机构名称
             null as in_tnv_vol, --转入成交数量
             null as in_tnv_prc, --转入成交价格
             null as in_tnv_val, --转入成交金额
             null as in_occu_val, --转入发生金额
             null as in_fee, --转入费用
             null as huge_redp_mode, --巨额赎回方式
             0 as rf_val, --退款金额
             0 as makp_val, --补款金额
             0 as rf_intr, --退款利息
             t0.marg as marg, --保证金
             t0.feer as feer, --费率
             t17.ttl_navl, --净资产
             (Case
               when t17.ttl_navl = 0 then
                0
               else
                t0.entr_val / t17.ttl_navl
             end) as tnv_val_nav, --成交金额占净值(%)
             null as prc_high, --价格偏离
             null as occu_val_full, --发生金额（全价）
             null as tnv_val_full, --成交金额（全价）
             null as tnv_prc_full, --成交价格（全价）
             null as end_valu_yld, --到期收益率-公允收益率
             ${end_date} AS BUSI_DATE, --业务日期
             NULL AS UPD_TIME, --源数据更新时间
             'O3' AS SYS_RS_ID, --系统来源标识
             'mid_l2_prd_tnv_dtl_3' AS TASK_RS_ID, --任务来源标识
             'evt_ofle_excf_his' AS DM_SRC_INFO, --来源信息
             CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
             'OUTLINE' AS DM_CREATED_BY, --数据中台创建者
             CURRENT_TIMESTAMP AS DM_UPDATED_TIME, --数据中台更新时间
             'OUTLINE' AS DM_UPDATED_BY,
	     null as cont_mult ,
	     t0.occu_dt  as  p_dt
        from ${dwd_db}.evt_ofle_excf_his t0
        left join ${dwd_db}.evt_ofle_clea_jour_his tt0
          on t0.occu_dt = tt0.occu_dt
         and t0.excf_onum = tt0.excf_onum
         and t0.busi_clas = tt0.busi_clas
        left join ${dwd_db}.pty_prd_code_rela_o32 t1
          on t0.prd_code = t1.prd_code
         and t1.sys_rs_id = 'O3'
        left join ${dwd_db}.pty_prd_base_info_o32 t2
          on t0.prd_code = t2.prd_code
        left join ${dwd_db}.pty_prd_fetu_exd_dt_o32 t3
          on t0.prd_code = t3.prd_code
         and t3.dim_code = '1'
        left join ${dwd_db}.pro_acc_asset_unit_info t4
          on t0.ast_unit_code = t4.ast_unit_code
        left join ${dwd_db}.pro_acc_pfl t5
          on t0.pfl_code = t5.pfl_code
        left join ${dwd_db}.pty_oper_info t6
          on t0.oper_no = t6.oper_no
        left join ${dwd_db}.pty_cutp_info t7
          on t0.trd_cntp_id = t7.cutp_id
        left join ${dwd_db}.var_secu_info_o32 t8
          on t0.secu_id = t8.secu_id
        left join ${dwd_db}.var_secu_code_conf t9
          on t0.secu_id = t9.secu_id
         and t0.occu_Dt = t9.occu_Dt
        left join ${dwd_db}.var_bond_info_o32 t10
          on t0.secu_id = t10.secu_id
        left join ${dwd_db}.var_secu_dquot_o32 t11
          on t0.secu_id = t11.secu_id
         and t0.occu_Dt = t11.trd_dt
        left join ${dwd_db}.ast_prd_ast_his t17
          on t0.prd_code = t17.prd_code
         and t0.occu_Dt = t17.occu_Dt
        left join ${dwd_db}.pub_para_info m11
          on t0.busi_clas_dtl_o3 = m11.para_hcode
         and m11.para_class_hcode = '824'
        left join ${dwd_db}.pub_para_info m1
          on t9.src_secu_class = m1.para_hcode
         and m1.para_class_hcode = '817'
        left join ${dwd_db}.pub_para_info m2
          on t9.src_secu_type = m2.para_hcode
         and m2.para_class_hcode = '822'
        left join ${dwd_db}.pub_para_mapping m3
          on t0.inv_typ = m3.orisys_para_code
         and m3.para_class_hcode = '125'
        left join ${dwd_db}.pub_para_info m4
          on t0.busi_prss_clas_o3 = m4.para_hcode
         and m4.para_class_hcode = '820'
        left join ${dwd_db}.pub_para_info m5
          on t0.tnv_stat = m5.para_hcode
         and m5.para_class_hcode = '821'
        left join ${dwd_db}.pub_para_info m6
          on t0.busi_clas_o3 = m6.para_hcode
         and m6.para_class_hcode = '818'
        left join ${dwd_db}.pub_para_info m10
          on t3.dim_value = m10.para_hcode
         and m10.para_class_hcode = '823'
       WHERE t0.occu_dt  BETWEEN ${beg_date} AND ${end_date}

      union all

	  select t0.POS_ID,T0.ENTR_DIR,
			 t0.occu_dt as occu_dt, --发生日期
             t0.prd_code as prd_code, --产品代码
             t1.trd_sys_id as src_fund_id, --源基金编号
             t2.prd_name as prd_name, --产品名称
             t2.prd_full_name as prd_full_name, --产品全称
             t2.crrc as crrc, --产品本币币种
             t3.dim_value as prd_clas, --产品类型
             m10.para_cname as prd_clas_name, --产品类型名称
             t0.ast_unit_code as ast_unit_code, --资产单元代码
             substr(t0.ast_unit_code, instr(t0.ast_unit_code, '_') + 1) as src_ast_unit_no, --源资产单元编号
             t4.ast_unit_name as ast_unit_name, --资产单元名称
             t4.src_sys_code as src_ast_unit_onum, --源资产单元序号
             t0.pfl_code as pfl_code, --投组代码
             substr(t0.pfl_code, locate('_',t0.pfl_code,locate('_',t0.pfl_code,2)+1 ) + 1) as src_pfl_no, --源组合编号
             t5.pfl_name as pfl_name, --投资组合名称
             t0.odr_onum as odr_onum, --指令序号
             substr(t0.odr_onum,
                    locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 ) + 1,
                    locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 )+1)-
                    locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 ) - 1) as src_odr_onum, --源指令序号
             substr(t0.odr_onum,
                    locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 )+1)+ 1,
                    locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 )+1)+1)-
                    locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 )+1)- 1) as src_odr_chg_onum, --源指令修改次序
             substr(t0.odr_onum, locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 )+1)+1) + 1) as src_odr_secu_onum, --源指令证券序号
             null as odr_rela_prsn, --指令下达人
             null as odr_rela_agt_prsn, --指令代下达人
             null as odr_oper_lvl, --指令操作级别
             null as odr_vol, --指令数量
             null as trd_typ, --交易类别
             t0.excf_onum as entr_onum, --委托序号/执行确认序号
             substr(t0.excf_onum, locate('_',t0.excf_onum,locate('_',t0.excf_onum,2)+1 )+ 1) as src_entr_onum, --源委托序号/执行确认序号
             null as entr_bath, --委托批号
             null as rep_no, --申报编号
             null as prc_clas, --价格类型
             null as entr_vol, --委托数量
             null as entr_prc, --委托价格
             t0.tnv_onum as tnv_onum, --成交序号
             replace(replace(substr(t0.tnv_onum,
                                    locate('_',t0.tnv_onum,locate('_',t0.tnv_onum,2)+1 )+ 1),
                             'L',
                             ''),
                     'C',
                     '') as src_tnv_onum, --源委托序号/确认序号
             null as tnv_no, --成交编号
             null as tnv_time, --成交时间
             t0.busi_typ as busi_typ, --业务类别
             t0.busi_clas as busi_clas, --业务类型
             t0.busi_clas_dtl_o3, --业务类型明细_O3
             m11.para_cname as busi_clas_dtl_name_o3, --业务类型明细名称_O3
             t0.entr_dir_o3 as entr_dir_o3, --委托方向_o32
             t0.entr_dir_name_o3 as entr_dir_name_o3, --委托方向名称_o32
             t0.busi_clas_o3 as busi_clas_o3, --业务分类_o32
             m6.para_cname as busi_clas_name_o3, --业务分类名称_o32,根据数据字典818转换
             t0.sh_code as sh_code, --股东代码
             t0.seat_code as seat_code, --席位号
             t0.inv_typ as inv_typ, --投资类型
             m3.para_hcode as src_inv_typ, --源投资类型,根据数据字典125转换，并对1的枚举调整为2，2的枚举调整为1
             m3.para_name as src_inv_name, --源投资类型名称
             null as clr_sped, --清算速度
             t0.tnv_vol as tnv_vol, --成交数量
             t0.tnv_prc as tnv_prc, --成交价格
             null as net_prc, --净价价格
             null as full_prc, --全价价格
             t0.tnv_val as tnv_val, --成交金额
             t0.tnv_val as tnv_val_locy, --本币成交金额,当为港币时通过通过汇率信息表中的中间价转换为人名币
             t0.occu_val as occu_val, --发生金额
             null as covr_pl, --平仓盈亏
             null as is_forc_covr, --是否强平
             0 as tot_fee, --总费用
             0 as stmp, --印花税
             0 as tfee, --过户费
             0 as sfee, --证管费
             0 as hand_fee, --经手费
             0 as cms, --佣金
             0 as clea_chag, --结算费
             0 as deli_fee, --交割费
             0 as trd_chag, --交易手续费
             0 as clea_serv_chag, --结算服务费
             0 as pr_fee, --申赎费用
             0 as oth_fee, --其他费用
             0 as full_tfee, --全额过户费
             t0.sett_mode as sett_mode, --结算方式
             t0.deli_dt as deli_dt, --交割日期
             null as sett_fail_flag, --交收失败标识
             t0.oper_no as oper_no, --操作员
             t6.oper_name as oper_name, --操作员名称
             null, --t0.memo
             null as fir_deli_dt, --首期交割日期
             null as end_deli_dt, --到期交割日期
             null as fir_deli_mode, --首期交割方式
             null as end_deli_mode, --到期交割方式
             null, --t0.fir_net_prc                                                                         as fir_net_prc                ,--首期净价价格
             null, --t0.end_net_prc                                                                         as end_net_prc                ,--到期净价价格
             null, --t0.fir_hd_intr                                                                         as fir_hd_intr                ,--首期百元利息
             null, --t0.end_hd_intr                                                                         as end_hd_intr                ,--到期百元利息
             null as fir_yld, --首期收益率
             null as end_yld, --到期收益率
             null as exer_yld, --行权收益率
             null as valu_yld, --公允收益率
             null as repo_rat, --回购利率
             null as repo_days, --回购天数
             null as buyb_val, --购回金额
             null as inta_days, --计息天数
             null as trad_id, --券商编号
             null as trad_name, --券商名称
             t0.trd_cntp_id as trd_cntp_id, --交易对手编码
             t7.cntp_sht as cntp_sht, --对手方简称
             t7.cntp_name as cntp_name, --对手全称
             null as cntp_seat_code, --对方席位号
             null as cntp_delr_id, --对手方交易员
             null as cntp_delr_name, --对手方交易员名称
             null as trd_cntp_ins_rela_typ, --交易对手机构主从类型
             t0.secu_id as secu_id, --证券编码
             t0.secu_code as secu_code, --证券代码
             null as blooaberg_code, --bloomberg
             null as cusip_code, --cusip
             t8.isin_code as isin_code, --isin
             null as ric_code, --ric
             null as sedol_code, --sedol
             t8.secu_sht as secu_sht, --中文简称
             t8.typ_code as typ_code, --证券类别代码（大类）
             t8.typ_codei as typ_codei, --证券类别代码（中类）
             t8.typ_codeii as typ_codeii, --证券类别代码（细分）
             t9.src_secu_class as secu_class_o3, --资产类别_o3
             m1.para_cname as secu_class_name_o3, --资产类别名称_o3
             t9.src_secu_type as secu_type_o3, --证券类别_o3
             m2.para_cname as secu_type_name_o3, --证券类别名称_o3
             null as oth_class_o3, --杂项分类_o3
             t0.exch_code as exch_code, --交易市场代码
             t8.exch_name as exch_name, --交易市场名称
             nvl(t8.curr_code, 'CNY') as curr_code, --货币代码
             nvl(t8.trd_curr_code, 'CNY') as trd_curr_code, --交易货币币种
             t10.is_prc_bond as is_prc_bond, --是否净价债
             t11.tnv_val as mkt_tnv_val, --市场成交额（元）
             t11.tnv_vol as mkt_tnv_vol, --市场成交数量
             (Case
               when t11.tnv_vol > 0 then
                t11.tnv_val / t11.tnv_vol
               else
                0
             end) as mkt_tnv_avg_prc, --市场成交均价
             t11.open_prc, --今开盘
             t11.low_prc as mkt_low_prc, --市场最低价
             t11.high_prc as mkt_high_prc, --市场最高价
             t11.cls_prc as mkt_cls_prc, --市场收盘加
             t11.cls_prc as mkt_last_prc, --市场最新价
             t11.day_chg_rat as day_chg_rat, --日涨跌幅
             null as cnbd_valu, --中债估值
             null as cstd_ins_id, --托管机构
             null as cstd_ins_name, --托管机构名称
             null as ext_rat, --外部评级
             null as inr_rat, --内部评级
             t8.com_id as com_id, --发行机构编号
             t8.com_name as com_name, --发行机构名称
             null as issr_inr_rat, --发行人内部评级
             null as issr_ext_rat, --发行人外部评级
             t10.guar_id as guar_id, --担保人id
             null as guar_rat, --担保人评级
             t10.ocom_id as ocom_id, --最初发行人/原始权益人id
             t10.ocom_name as ocom_name, --最初发行人/原始权益人名称
             null as excf_dt, --确认日期
             case
               when t0.excf_time is not null then
                CONCAT(substr(lpad(t0.excf_time, 6, '0'), 1, 2) , ':' ,
                lpad(lpad(substr(t0.excf_time, -4, 2), 2, '0'), 2, '0') , ':' ,
                lpad(substr(t0.excf_time, -2, 2), 2, '0'))
             end as excf_time, --确认时间
             t0.busi_prss_clas_o3 as busi_prss_clas_o3, --业务过程分类_o32
             m4.para_cname as busi_prss_clas_name_o3, --业务过程分类名称_o32
             t0.tnv_stat as tnv_stat ,--执行成交状态
             m5.para_cname as tnv_stat_name ,--执行成交状态
             null as dpsi_srte_dt, --存款起息日期
             null as dpsi_end_dt, --存款到期日期
             null as expe_yld, --理财产品预期收益率
             null as dpsi_rat, --存款利率
             null as bnk_hbnk_id, --银行总行编码
             null as bnk_hbnk_name, --银行总行名称
             null as dpsi_site, --存款地方
             null as dpsi_ahed_coll_lim, --存款提前支取限制
             null as dpsi_accr_intr, --存款应计利息
             null as dpsi_aggr_intr_incm, --存款累计利息收入
             null as in_secu_id, --转入证券编码
             null as in_secu_code, --转入证券代码
             null as in_secu_name, --转入证券名称
             null as in_exch_code, --转入交易市场代码
             null as in_exch_name, --转入交易市场名称
             null as in_com_id, --转入发行机构编号
             null as in_com_name, --转入发行机构名称
             null as in_tnv_vol, --转入成交数量
             null as in_tnv_prc, --转入成交价格
             null as in_tnv_val, --转入成交金额
             null as in_occu_val, --转入发生金额
             null as in_fee, --转入费用
             null as huge_redp_mode, --巨额赎回方式
             t0.rf_val as rf_val, --退款金额
             t0.makp_val as makp_val, --补款金额
             0 as rf_intr, --退款利息
             t0.marg as marg, --保证金
             t0.feer as feer, --费率
             t17.ttl_navl, --净资产
             (Case
               when t17.ttl_navl = 0 then
                0
               else
                t0.tnv_val / t17.ttl_navl
             end) as tnv_val_nav, --成交金额占净值(%)
             null as prc_high, --价格偏离
             null as occu_val_full, --发生金额（全价）
             null as tnv_val_full, --成交金额（全价）
             null as tnv_prc_full, --成交价格（全价）
             null as end_valu_yld, --到期收益率-公允收益率
             ${end_date} AS BUSI_DATE, --业务日期
             NULL AS UPD_TIME, --源数据更新时间
             'O3' AS SYS_RS_ID, --系统来源标识
             'mid_l2_prd_tnv_dtl_4' AS TASK_RS_ID, --任务来源标识
             'evt_ofle_tnv_his' AS DM_SRC_INFO, --来源信息
             CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
             'OUTLINE' AS DM_CREATED_BY, --数据中台创建者
             CURRENT_TIMESTAMP AS DM_UPDATED_TIME, --数据中台更新时间
             'OUTLINE' AS DM_UPDATED_BY,
	     null,
	     t0.occu_dt as  p_dt
        from ${dwd_db}.evt_ofle_tnv_his t0
        left join ${dwd_db}.pty_prd_code_rela_o32 t1
          on t0.prd_code = t1.prd_code
         and t1.sys_rs_id = 'O3'
        left join ${dwd_db}.pty_prd_base_info_o32 t2
          on t0.prd_code = t2.prd_code
        left join ${dwd_db}.pty_prd_fetu_exd_dt_o32 t3
          on t0.prd_code = t3.prd_code
         and t3.dim_code = '1'
        left join ${dwd_db}.pro_acc_asset_unit_info t4
          on t0.ast_unit_code = t4.ast_unit_code
        left join ${dwd_db}.pro_acc_pfl t5
          on t0.pfl_code = t5.pfl_code
        left join ${dwd_db}.pty_oper_info t6
          on t0.oper_no = t6.oper_no
        left join ${dwd_db}.pty_cutp_info t7
          on t0.trd_cntp_id = t7.cutp_id
        left join ${dwd_db}.var_secu_info_o32 t8
          on t0.secu_id = t8.secu_id
        left join ${dwd_db}.var_secu_code_conf t9
          on t0.secu_id = t9.secu_id
         and t0.occu_Dt = t9.occu_Dt
        left join ${dwd_db}.var_bond_info_o32 t10
          on t0.secu_id = t10.secu_id
        left join ${dwd_db}.var_secu_dquot_o32 t11
          on t0.secu_id = t11.secu_id
         and t0.occu_Dt = t11.trd_dt
        left join ${dwd_db}.ast_prd_ast_his t17
          on t0.prd_code = t17.prd_code
         and t0.occu_Dt = t17.occu_Dt
        left join ${dwd_db}.pub_para_info m11
          on t0.busi_clas_dtl_o3 = m11.para_hcode
         and m11.para_class_hcode = '824'
        left join ${dwd_db}.pub_para_info m1
          on t9.src_secu_class = m1.para_hcode
         and m1.para_class_hcode = '817'
        left join ${dwd_db}.pub_para_info m2
          on t9.src_secu_type = m2.para_hcode
         and m2.para_class_hcode = '822'
        left join ${dwd_db}.pub_para_mapping m3
          on t0.inv_typ = m3.orisys_para_code
         and m3.para_class_hcode = '125'
        left join ${dwd_db}.pub_para_info m4
          on t0.busi_prss_clas_o3 = m4.para_hcode
         and m4.para_class_hcode = '820'
        left join ${dwd_db}.pub_para_info m5
          on t0.tnv_stat = m5.para_hcode
         and m5.para_class_hcode = '821'
        left join ${dwd_db}.pub_para_info m6
          on t0.busi_clas_o3 = m6.para_hcode
         and m6.para_class_hcode = '818'
        left join ${dwd_db}.pub_para_info m10
          on t3.dim_value = m10.para_hcode
         and m10.para_class_hcode = '823'
       WHERE t0.occu_dt BETWEEN ${beg_date} AND ${end_date}

      union all

	  select t0.POS_ID,T0.ENTR_DIR,
			 t0.occu_dt as occu_dt, --发生日期
             t0.prd_code as prd_code, --产品代码
             t1.trd_sys_id as src_fund_id, --源基金编号
             t2.prd_name as prd_name, --产品名称
             t2.prd_full_name as prd_full_name, --产品全称
             t2.crrc as crrc, --产品本币币种
             t3.dim_value as prd_clas, --产品类型
             m10.para_cname as prd_clas_name, --产品类型名称
             t0.ast_unit_code as ast_unit_code, --资产单元代码
             substr(t0.ast_unit_code, instr(t0.ast_unit_code, '_') + 1) as src_ast_unit_no, --源资产单元编号
             t4.ast_unit_name as ast_unit_name, --资产单元名称
             t4.src_sys_code as src_ast_unit_onum, --源资产单元序号
             t0.pfl_code as pfl_code, --投组代码
             substr(t0.pfl_code,locate('_',t0.pfl_code,locate('_',t0.pfl_code,2)+1 ) + 1) as src_pfl_no, --源组合编号
             t5.pfl_name as pfl_name, --投资组合名称
             t0.odr_onum as odr_onum, --指令序号
             substr(t0.odr_onum,
                    locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 )+ 1,
                    locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 )+1) -
                    locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 )- 1) as src_odr_onum, --源指令序号
             substr(t0.odr_onum,
                    locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 )+1)+ 1,
                    locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 )+1)+1)-
                    locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 )+1)- 1) as src_odr_chg_onum, --源指令修改次序
             substr(t0.odr_onum, locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 )+1)+1) + 1) as src_odr_secu_onum, --源指令证券序号
             null as odr_rela_prsn, --指令下达人
             null as odr_rela_agt_prsn, --指令代下达人
             null as odr_oper_lvl, --指令操作级别
             null as odr_vol, --指令数量
             null as trd_typ, --交易类别
             t0.excf_onum as entr_onum, --委托序号/执行确认序号
             substr(t0.excf_onum,locate('_',t0.excf_onum,locate('_',t0.excf_onum,2)+1 )+ 1) as src_entr_onum, --源委托序号/执行确认序号
             null as entr_bath, --委托批号
             null as rep_no, --申报编号
             null as prc_clas, --价格类型
             null as entr_vol, --委托数量
             null as entr_prc, --委托价格
             tt0.tnv_onum as tnv_onum, --成交序号
             replace(replace(substr(t0.excf_onum,
                                    locate('_',t0.excf_onum,locate('_',t0.excf_onum,2)+1 ) + 1),
                             'L',
                             ''),
                     'C',
                     '') as src_tnv_onum, --源委托序号/确认序号
             null as tnv_no, --成交编号
             null as tnv_time, --成交时间
             t0.busi_typ as busi_typ, --业务类别
             t0.busi_clas as busi_clas, --业务类型
             t0.busi_clas_dtl_o3, --业务类型明细_O3
             m11.para_cname as busi_clas_dtl_name_o3, --业务类型明细名称_O3
             t0.entr_dir_o3 as entr_dir_o3, --委托方向_o32
             t0.entr_dir_name_o3 as entr_dir_name_o3, --委托方向名称_o32
             t0.busi_clas_o3 as busi_clas_o3, --业务分类_o32
             m6.para_cname as busi_clas_name_o3, --业务分类名称_o32,根据数据字典818转换
             null as sh_code, --股东代码
             null as seat_code, --席位号
             t0.inv_typ as inv_typ, --投资类型
             m3.para_hcode as src_inv_typ, --源投资类型,根据数据字典125转换，并对1的枚举调整为2，2的枚举调整为1
             m3.para_name as src_inv_name, --源投资类型名称
             null as clr_sped, --清算速度
             t0.entr_vol as tnv_vol, --成交数量
             t0.entr_prc as tnv_prc, --成交价格
             null as net_prc, --净价价格
             null as full_prc, --全价价格
             t0.entr_val as tnv_val, --成交金额
             t0.entr_val as tnv_val_locy, --本币成交金额,当为港币时通过通过汇率信息表中的中间价转换为人名币
             t0.occu_val as occu_val, --发生金额
             null as covr_pl, --平仓盈亏
             null as is_forc_covr, --是否强平
             0 as tot_fee, --总费用
             0 as stmp, --印花税
             0 as tfee, --过户费
             0 as sfee, --证管费
             0 as hand_fee, --经手费
             0 as cms, --佣金
             0 as clea_chag, --结算费
             0 as deli_fee, --交割费
             0 as trd_chag, --交易手续费
             0 as clea_serv_chag, --结算服务费
             0 as pr_fee, --申赎费用
             0 as oth_fee, --其他费用
             0 as full_tfee, --全额过户费
             null as sett_mode, --结算方式
             null as deli_dt, --交割日期
             null as sett_fail_flag, --交收失败标识
             t0.oper_no as oper_no, --操作员
             t6.oper_name as oper_name, --操作员名称
             null as memo, --备注
             null as fir_deli_dt, --首期交割日期
             null as end_deli_dt, --到期交割日期
             null as fir_deli_mode, --首期交割方式
             null as end_deli_mode, --到期交割方式
             null as fir_net_prc, --首期净价价格
             null as end_net_prc, --到期净价价格
             null as fir_hd_intr, --首期百元利息
             null as end_hd_intr, --到期百元利息
             null as fir_yld, --首期收益率
             null as end_yld, --到期收益率
             null as exer_yld, --行权收益率
             null as valu_yld, --公允收益率
             null as repo_rat, --回购利率
             null as repo_days, --回购天数
             null as buyb_val, --购回金额
             null as inta_days, --计息天数
             null as trad_id, --券商编号
             null as trad_name, --券商名称
             t0.trd_cntp_id as trd_cntp_id, --交易对手编码
             t7.cntp_sht as cntp_sht, --对手方简称
             t7.cntp_name as cntp_name, --对手全称
             null as cntp_seat_code, --对方席位号
             null as cntp_delr_id, --对手方交易员
             null as cntp_delr_name, --对手方交易员名称
             null as trd_cntp_ins_rela_typ, --交易对手机构主从类型
             t0.secu_id as secu_id, --证券编码
             t0.secu_code as secu_code, --证券代码
             null as blooaberg_code, --bloomberg
             null as cusip_code, --cusip
             t8.isin_code as isin_code, --isin
             null as ric_code, --ric
             null as sedol_code, --sedol
             t8.secu_sht as secu_sht, --中文简称
             t8.typ_code as typ_code, --证券类别代码（大类）
             t8.typ_codei as typ_codei, --证券类别代码（中类）
             t8.typ_codeii as typ_codeii, --证券类别代码（细分）
             t9.src_secu_class as secu_class_o3, --资产类别_o3
             m1.para_cname as secu_class_name_o3, --资产类别名称_o3
             t9.src_secu_type as secu_type_o3, --证券类别_o3
             m2.para_cname as secu_type_name_o3, --证券类别名称_o3
             null as oth_class_o3, --杂项分类_o3
             t0.exch_code as exch_code, --交易市场代码
             t8.exch_name as exch_name, --交易市场名称
             nvl(t8.curr_code, 'CNY') as curr_code, --货币代码
             nvl(t8.trd_curr_code, 'CNY') as trd_curr_code, --交易货币币种
             t10.is_prc_bond as is_prc_bond, --是否净价债
             t11.tnv_val as mkt_tnv_val, --市场成交额（元）
             t11.tnv_vol as mkt_tnv_vol, --市场成交数量
             (Case
               when t11.tnv_vol > 0 then
                t11.tnv_val / t11.tnv_vol
               else
                0
             end) as mkt_tnv_avg_prc, --市场成交均价
             t11.open_prc, --今开盘
             t11.low_prc as mkt_low_prc, --市场最低价
             t11.high_prc as mkt_high_prc, --市场最高价
             t11.cls_prc as mkt_cls_prc, --市场收盘加
             t11.cls_prc as mkt_last_prc, --市场最新价
             t11.day_chg_rat as day_chg_rat, --日涨跌幅
             null as cnbd_valu, --中债估值
             null as cstd_ins_id, --托管机构
             null as cstd_ins_name, --托管机构名称
             null as ext_rat, --外部评级
             null as inr_rat, --内部评级
             t8.com_id as com_id, --发行机构编号
             t8.com_name as com_name, --发行机构名称
             null as issr_inr_rat, --发行人内部评级
             null as issr_ext_rat, --发行人外部评级
             t10.guar_id as guar_id, --担保人id
             null as guar_rat, --担保人评级
             t10.ocom_id as ocom_id, --最初发行人/原始权益人id
             t10.ocom_name as ocom_name, --最初发行人/原始权益人名称
             null as excf_dt, --确认日期
             case
               when t0.excf_time is not null then
                CONCAT(substr(lpad(t0.excf_time, 6, '0'), 1, 2) , ':' ,
                lpad(lpad(substr(t0.excf_time, -4, 2), 2, '0'), 2, '0') , ':' ,
                lpad(substr(t0.excf_time, -2, 2), 2, '0'))
             end as excf_time, --确认时间
             t0.busi_prss_clas_o3 as busi_prss_clas_o3, --业务过程分类_o32
             m4.para_cname as busi_prss_clas_name_o3, --业务过程分类名称_o32
             t0.tnv_stat as tnv_stat ,--执行成交状态
             m5.para_cname as tnv_stat_name ,--执行成交状态
             t18.srte_dt as dpsi_srte_dt, --存款起息日期
             t18.end_dt as dpsi_end_dt, --存款到期日期
             t0.expe_yld as expe_yld, --理财产品预期收益率
             t18.dpsi_rat as dpsi_rat, --存款利率
             t18.bnk_hbnk_id as bnk_hbnk_id, --银行总行编码
             t18.bnk_hbnk_name as bnk_hbnk_name, --银行总行名称
             t18.dpsi_site as dpsi_site, --存款地方
             t18.ahed_coll_lim as dpsi_ahed_coll_lim, --存款提前支取限制
             t18.accr_intr as dpsi_accr_intr, --存款应计利息
             t18.aggr_intr_incm as dpsi_aggr_intr_incm, --存款累计利息收入
             null as in_secu_id, --转入证券编码
             null as in_secu_code, --转入证券代码
             null as in_secu_name, --转入证券名称
             null as in_exch_code, --转入交易市场代码
             null as in_exch_name, --转入交易市场名称
             null as in_com_id, --转入发行机构编号
             null as in_com_name, --转入发行机构名称
             null as in_tnv_vol, --转入成交数量
             null as in_tnv_prc, --转入成交价格
             null as in_tnv_val, --转入成交金额
             null as in_occu_val, --转入发生金额
             null as in_fee, --转入费用
             t0.huge_redp_mode as huge_redp_mode, --巨额赎回方式
             0 as rf_val, --退款金额
             0 as makp_val, --补款金额
             0 as rf_intr, --退款利息
             0 as marg, --保证金
             0 as feer, --费率
             t17.ttl_navl, --净资产
             (Case
               when t17.ttl_navl = 0 then
                0
               else
                t0.entr_val / t17.ttl_navl
             end) as tnv_val_nav, --成交金额占净值(%)
             null as prc_high, --价格偏离
             null as occu_val_full, --发生金额（全价）
             null as tnv_val_full, --成交金额（全价）
             null as tnv_prc_full, --成交价格（全价）
             null as end_valu_yld, --到期收益率-公允收益率
             ${end_date} AS BUSI_DATE, --业务日期
             NULL AS UPD_TIME, --源数据更新时间
             'O3' AS SYS_RS_ID, --系统来源标识
             'mid_l2_prd_tnv_dtl_5' AS TASK_RS_ID, --任务来源标识
             'evt_otc_excf_his' AS DM_SRC_INFO, --来源信息
             CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
             'OUTLINE' AS DM_CREATED_BY, --数据中台创建者
             CURRENT_TIMESTAMP AS DM_UPDATED_TIME, --数据中台更新时间
             'OUTLINE' AS DM_UPDATED_BY,
	     null,
	    t0.occu_dt as  p_dt
        from ${dwd_db}.evt_otc_excf_his t0
        left join ${dwd_db}.evt_otc_clea_jour_his tt0
          on t0.occu_dt = tt0.occu_dt
         and t0.excf_onum = tt0.excf_onum
         and t0.busi_clas = tt0.busi_clas
        left join ${dwd_db}.pty_prd_code_rela_o32 t1
          on t0.prd_code = t1.prd_code
         and t1.sys_rs_id = 'O3'
        left join ${dwd_db}.pty_prd_base_info_o32 t2
          on t0.prd_code = t2.prd_code
        left join ${dwd_db}.pty_prd_fetu_exd_dt_o32 t3
          on t0.prd_code = t3.prd_code
         and t3.dim_code = '1'
        left join ${dwd_db}.pro_acc_asset_unit_info t4
          on t0.ast_unit_code = t4.ast_unit_code
        left join ${dwd_db}.pro_acc_pfl t5
          on t0.pfl_code = t5.pfl_code
        left join ${dwd_db}.pty_oper_info t6
          on t0.oper_no = t6.oper_no
        left join ${dwd_db}.pty_cutp_info t7
          on t0.trd_cntp_id = t7.cutp_id
        left join ${dwd_db}.var_secu_info_o32 t8
          on t0.secu_id = t8.secu_id
        left join ${dwd_db}.var_secu_code_conf t9
          on t0.secu_id = t9.secu_id
         and t0.occu_Dt = t9.occu_Dt
        left join ${dwd_db}.var_bond_info_o32 t10
          on t0.secu_id = t10.secu_id
        left join ${dwd_db}.var_secu_dquot_o32 t11
          on t0.secu_id = t11.secu_id
         and t0.occu_dt = t11.trd_dt
        left join ${dwd_db}.ast_prd_ast_his t17
          on t0.prd_code = t17.prd_code
         and t0.occu_Dt = t17.occu_Dt
        left join ${dwd_db}.pro_dpsi_info t18
          on t0.secu_id = t18.secu_id
        left join ${dwd_db}.pub_para_info m11
          on t0.busi_clas_dtl_o3 = m11.para_hcode
         and m11.para_class_hcode = '824'
        left join ${dwd_db}.pub_para_info m1
          on t9.src_secu_class = m1.para_hcode
         and m1.para_class_hcode = '817'
        left join ${dwd_db}.pub_para_info m2
          on t9.src_secu_type = m2.para_hcode
         and m2.para_class_hcode = '822'
        left join ${dwd_db}.pub_para_mapping m3
          on t0.inv_typ = m3.orisys_para_code
         and m3.para_class_hcode = '125'
        left join ${dwd_db}.pub_para_info m4
          on t0.busi_prss_clas_o3 = m4.para_hcode
         and m4.para_class_hcode = '820'
        left join ${dwd_db}.pub_para_info m5
          on t0.tnv_stat = m5.para_hcode
         and m5.para_class_hcode = '821'
        left join ${dwd_db}.pub_para_info m6
          on t0.busi_clas_o3 = m6.para_hcode
         and m6.para_class_hcode = '818'
        left join ${dwd_db}.pub_para_info m10
          on t3.dim_value = m10.para_hcode
         and m10.para_class_hcode = '823'
       WHERE t0.occu_dt BETWEEN ${beg_date} AND ${end_date}

	 union all

      select t0.POS_ID,T0.ENTR_DIR,
			 t0.occu_dt as occu_dt, --发生日期
             t0.prd_code as prd_code, --产品代码
             t1.trd_sys_id as src_fund_id, --源基金编号
             t2.prd_name as prd_name, --产品名称
             t2.prd_full_name as prd_full_name, --产品全称
             t2.crrc as crrc, --产品本币币种
             t3.dim_value as prd_clas, --产品类型
             m10.para_cname as prd_clas_name, --产品类型名称
             t0.ast_unit_code as ast_unit_code, --资产单元代码
             substr(t0.ast_unit_code, instr(t0.ast_unit_code, '_') + 1) as src_ast_unit_no, --源资产单元编号
             t4.ast_unit_name as ast_unit_name, --资产单元名称
             t4.src_sys_code as src_ast_unit_onum, --源资产单元序号
             t0.pfl_code as pfl_code, --投组代码
             substr(t0.pfl_code, locate('_',t0.pfl_code,locate('_',t0.pfl_code,2)+1 ) + 1) as src_pfl_no, --源组合编号
             t5.pfl_name as pfl_name, --投资组合名称
             t0.odr_onum as odr_onum, --指令序号
             substr(t0.odr_onum,
                    locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 ) + 1,
                    locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 )+1) -
                    locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 ) - 1) as src_odr_onum, --源指令序号
             substr(t0.odr_onum,
                    locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 )+1)+ 1,
                   locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 )+1)+1)-
                    locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 )+1)- 1) as src_odr_chg_onum, --源指令修改次序
             substr(t0.odr_onum, locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,locate('_',t0.odr_onum,2)+1 )+1)+1) + 1) as src_odr_secu_onum, --源指令证券序号
             null as odr_rela_prsn, --指令下达人
             null as odr_rela_agt_prsn, --指令代下达人
             null as odr_oper_lvl, --指令操作级别
             null as odr_vol, --指令数量
             null as trd_typ, --交易类别
             t0.excf_onum as entr_onum, --委托序号/执行确认序号
             substr(t0.excf_onum, locate('_',t0.excf_onum,locate('_',t0.excf_onum,2)+1 ) + 1) as src_entr_onum, --源委托序号/执行确认序号
             null as entr_bath, --委托批号
             null as rep_no, --申报编号
             null as prc_clas, --价格类型
             null as entr_vol, --委托数量
             null as entr_prc, --委托价格
             t0.tnv_onum as tnv_onum, --成交序号
             replace(replace(substr(t0.tnv_onum,
                                    locate('_',t0.tnv_onum,locate('_',t0.tnv_onum,2)+1 ) + 1),
                             'L',
                             ''),
                     'C',
                     '') as src_tnv_onum, --源委托序号/确认序号
             null as tnv_no, --成交编号
             null as tnv_time, --成交时间
             t0.busi_typ as busi_typ, --业务类别
             t0.busi_clas as busi_clas, --业务类型
             t0.busi_clas_dtl_o3, --业务类型明细_O3
             m11.para_cname as busi_clas_dtl_name_o3, --业务类型明细名称_O3
             t0.entr_dir_o3 as entr_dir_o3, --委托方向_o32
             t0.entr_dir_name_o3 as entr_dir_name_o3, --委托方向名称_o32
             t0.busi_clas_o3 as busi_clas_o3, --业务分类_o32
             m6.para_cname as busi_clas_name_o3, --业务分类名称_o32,根据数据字典818转换
             null as sh_code, --股东代码
             null as seat_code, --席位号
             t0.inv_typ as inv_typ, --投资类型
             m3.para_hcode as src_inv_typ, --源投资类型,根据数据字典125转换，并对1的枚举调整为2，2的枚举调整为1
             m3.para_name as src_inv_name, --源投资类型名称
             null as clr_sped, --清算速度
             t0.tnv_vol as tnv_vol, --成交数量
             t0.tnv_prc as tnv_prc, --成交价格
             null as net_prc, --净价价格
             null as full_prc, --全价价格
             t0.tnv_val as tnv_val, --成交金额
             t0.tnv_val as tnv_val_locy, --本币成交金额,当为港币时通过通过汇率信息表中的中间价转换为人名币
             t0.occu_val as occu_val, --发生金额
             null as covr_pl, --平仓盈亏
             null as is_forc_covr, --是否强平
             nvl(t0.pr_fee, 0) as tot_fee, --总费用
             0 as stmp, --印花税
             0 as tfee, --过户费
             0 as sfee, --证管费
             0 as hand_fee, --经手费
             0 as cms, --佣金
             0 as clea_chag, --结算费
             0 as deli_fee, --交割费
             0 as trd_chag, --交易手续费
             0 as clea_serv_chag, --结算服务费
             t0.pr_fee as pr_fee, --申赎费用
             0 as oth_fee, --其他费用
             0 as full_tfee, --全额过户费
             null as sett_mode, --结算方式
             t0.deli_dt as deli_dt, --交割日期
             null as sett_fail_flag, --交收失败标识
             t0.oper_no as oper_no, --操作员
             t6.oper_name as oper_name, --操作员名称
             null as memo, --备注
             null as fir_deli_dt, --首期交割日期
             null as end_deli_dt, --到期交割日期
             null as fir_deli_mode, --首期交割方式
             null as end_deli_mode, --到期交割方式
             null as fir_net_prc, --首期净价价格
             null as end_net_prc, --到期净价价格
             null as fir_hd_intr, --首期百元利息
             null as end_hd_intr, --到期百元利息
             null as fir_yld, --首期收益率
             null as end_yld, --到期收益率
             null as exer_yld, --行权收益率
             null as valu_yld, --公允收益率
             null as repo_rat, --回购利率
             null as repo_days, --回购天数
             null as buyb_val, --购回金额
             null as inta_days, --计息天数
             null as trad_id, --券商编号
             null as trad_name, --券商名称
             t0.trd_cntp_id as trd_cntp_id, --交易对手编码
             t7.cntp_sht as cntp_sht, --对手方简称
             t7.cntp_name as cntp_name, --对手全称
             null as cntp_seat_code, --对方席位号
             null as cntp_delr_id, --对手方交易员
             null as cntp_delr_name, --对手方交易员名称
             null as trd_cntp_ins_rela_typ, --交易对手机构主从类型
             t0.secu_id as secu_id, --证券编码
             t0.secu_code as secu_code, --证券代码
             null as blooaberg_code, --bloomberg
             null as cusip_code, --cusip
             t8.isin_code as isin_code, --isin
             null as ric_code, --ric
             null as sedol_code, --sedol
             t8.secu_sht as secu_sht, --中文简称
             t8.typ_code as typ_code, --证券类别代码（大类）
             t8.typ_codei as typ_codei, --证券类别代码（中类）
             t8.typ_codeii as typ_codeii, --证券类别代码（细分）
             t9.src_secu_class as secu_class_o3, --资产类别_o3
             m1.para_cname as secu_class_name_o3, --资产类别名称_o3
             t9.src_secu_type as secu_type_o3, --证券类别_o3
             m2.para_cname as secu_type_name_o3, --证券类别名称_o3
             null as oth_class_o3, --杂项分类_o3
             t0.exch_code as exch_code, --交易市场代码
             t8.exch_name as exch_name, --交易市场名称
             nvl(t8.curr_code, 'CNY') as curr_code, --货币代码
             nvl(t8.trd_curr_code, 'CNY') as trd_curr_code, --交易货币币种
             t10.is_prc_bond as is_prc_bond, --是否净价债
             t11.tnv_val as mkt_tnv_val, --市场成交额（元）
             t11.tnv_vol as mkt_tnv_vol, --市场成交数量
             (Case
               when t11.tnv_vol > 0 then
                t11.tnv_val / t11.tnv_vol
               else
                0
             end) as mkt_tnv_avg_prc, --市场成交均价
             t11.open_prc, --今开盘
             t11.low_prc as mkt_low_prc, --市场最低价
             t11.high_prc as mkt_high_prc, --市场最高价
             t11.cls_prc as mkt_cls_prc, --市场收盘加
             t11.cls_prc as mkt_last_prc, --市场最新价
             t11.day_chg_rat as day_chg_rat, --日涨跌幅
             null as cnbd_valu, --中债估值
             null as cstd_ins_id, --托管机构
             null as cstd_ins_name, --托管机构名称
             null as ext_rat, --外部评级
             null as inr_rat, --内部评级
             t8.com_id as com_id, --发行机构编号
             t8.com_name as com_name, --发行机构名称
             null as issr_inr_rat, --发行人内部评级
             null as issr_ext_rat, --发行人外部评级
             t10.guar_id as guar_id, --担保人id
             null as guar_rat, --担保人评级
             t10.ocom_id as ocom_id, --最初发行人/原始权益人id
             t10.ocom_name as ocom_name, --最初发行人/原始权益人名称
             null as excf_dt, --确认日期
             case
               when t0.excf_time is not null then
                CONCAT(substr(lpad(t0.excf_time, 6, '0'), 1, 2) , ':' ,
                lpad(lpad(substr(t0.excf_time, -4, 2), 2, '0'), 2, '0') , ':' ,
                lpad(substr(t0.excf_time, -2, 2), 2, '0'))
             end as excf_time, --确认时间
             t0.busi_prss_clas_o3 as busi_prss_clas_o3, --业务过程分类_o32
             m4.para_cname as busi_prss_clas_name_o3, --业务过程分类名称_o32
             t0.tnv_stat as tnv_stat ,--执行成交状态
             m5.para_cname as tnv_stat_name ,--执行成交状态
             t18.srte_dt as dpsi_srte_dt, --存款起息日期
             t18.end_dt as dpsi_end_dt, --存款到期日期
             t0.expe_yld as expe_yld, --理财产品预期收益率
             t18.dpsi_rat as dpsi_rat, --存款利率
             t18.bnk_hbnk_id as bnk_hbnk_id, --银行总行编码
             t18.bnk_hbnk_name as bnk_hbnk_name, --银行总行名称
             t18.dpsi_site as dpsi_site, --存款地方
             t18.ahed_coll_lim as dpsi_ahed_coll_lim, --存款提前支取限制
             t18.accr_intr as dpsi_accr_intr, --存款应计利息
             t18.aggr_intr_incm as dpsi_aggr_intr_incm, --存款累计利息收入
             t0.in_secu_id as in_secu_id, --转入证券编码
             t19.trd_code as in_secu_code, --转入证券代码
             t19.secu_sht as in_secu_name, --转入证券名称
             t19.exch_code as in_exch_code, --转入交易市场代码
             t19.exch_name as in_exch_name, --转入交易市场名称
             t19.com_id as in_com_id, --转入发行机构编号
             t19.com_name as in_com_name, --转入发行机构名称
             t0.in_tnv_vol as in_tnv_vol, --转入成交数量
             t0.in_tnv_prc as in_tnv_prc, --转入成交价格
             t0.in_tnv_val as in_tnv_val, --转入成交金额
             t0.in_occu_val as in_occu_val, --转入发生金额
             t0.in_fee as in_fee, --转入费用
             t0.huge_redp_mode as huge_redp_mode, --巨额赎回方式
             t0.rf_val as rf_val, --退款金额
             0 as makp_val, --补款金额
             t0.rf_intr as rf_intr, --退款利息
             0 as marg, --保证金
             0 as feer, --费率
             t17.ttl_navl, --净资产
             (Case
               when t17.ttl_navl = 0 then
                0
               else
                t0.tnv_val / t17.ttl_navl
             end) as tnv_val_nav, --成交金额占净值(%)
             null as prc_high, --价格偏离
             null as occu_val_full, --发生金额（全价）
             null as tnv_val_full, --成交金额（全价）
             null as tnv_prc_full, --成交价格（全价）
             null as end_valu_yld, --到期收益率-公允收益率
             ${end_date} AS BUSI_DATE, --业务日期
             NULL AS UPD_TIME, --源数据更新时间
             'O3' AS SYS_RS_ID, --系统来源标识
             'mid_l2_prd_tnv_dtl_6' AS TASK_RS_ID, --任务来源标识
             'evt_otc_tnv_his' AS DM_SRC_INFO, --来源信息
             CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
             'OUTLINE' AS DM_CREATED_BY, --数据中台创建者
             CURRENT_TIMESTAMP AS DM_UPDATED_TIME, --数据中台更新时间
             'OUTLINE' AS DM_UPDATED_BY,
	     null,
	     t0.occu_dt as  p_dt
        from ${dwd_db}.evt_otc_tnv_his t0
        left join ${dwd_db}.pty_prd_code_rela_o32 t1
          on t0.prd_code = t1.prd_code
         and t1.sys_rs_id = 'O3'
        left join ${dwd_db}.pty_prd_base_info_o32 t2
          on t0.prd_code = t2.prd_code
        left join ${dwd_db}.pty_prd_fetu_exd_dt_o32 t3
          on t0.prd_code = t3.prd_code
         and t3.dim_code = '1'
        left join ${dwd_db}.pro_acc_asset_unit_info t4
          on t0.ast_unit_code = t4.ast_unit_code
        left join ${dwd_db}.pro_acc_pfl t5
          on t0.pfl_code = t5.pfl_code
        left join ${dwd_db}.pty_oper_info t6
          on t0.oper_no = t6.oper_no
        left join ${dwd_db}.pty_cutp_info t7
          on t0.trd_cntp_id = t7.cutp_id
        left join ${dwd_db}.var_secu_info_o32 t8
          on t0.secu_id = t8.secu_id
        left join ${dwd_db}.var_secu_code_conf t9
          on t0.secu_id = t9.secu_id
         and t0.occu_Dt = t9.occu_Dt
        left join ${dwd_db}.var_bond_info_o32 t10
          on t0.secu_id = t10.secu_id
        left join ${dwd_db}.var_secu_dquot_o32 t11
          on t0.secu_id = t11.secu_id
         and t0.occu_Dt = t11.trd_dt
        left join ${dwd_db}.ast_prd_ast_his t17
          on t0.prd_code = t17.prd_code
         and t0.occu_Dt = t17.occu_Dt
        left join ${dwd_db}.pro_dpsi_info t18
          on t0.secu_id = t18.secu_id
        left join ${dwd_db}.var_secu_info_o32 t19
          on t0.in_secu_id = t19.secu_id
        left join ${dwd_db}.pub_para_info m11
          on t0.busi_clas_dtl_o3 = m11.para_hcode
         and m11.para_class_hcode = '824'
        left join ${dwd_db}.pub_para_info m1
          on t9.src_secu_class = m1.para_hcode
         and m1.para_class_hcode = '817'
        left join ${dwd_db}.pub_para_info m2
          on t9.src_secu_type = m2.para_hcode
         and m2.para_class_hcode = '822'
        left join ${dwd_db}.pub_para_mapping m3
          on t0.inv_typ = m3.orisys_para_code
         and m3.para_class_hcode = '125'
        left join ${dwd_db}.pub_para_info m4
          on t0.busi_prss_clas_o3 = m4.para_hcode
         and m4.para_class_hcode = '820'
        left join ${dwd_db}.pub_para_info m5
          on t0.tnv_stat = m5.para_hcode
         and m5.para_class_hcode = '821'
        left join ${dwd_db}.pub_para_info m6
          on t0.busi_clas_o3 = m6.para_hcode
         and m6.para_class_hcode = '818'
        left join ${dwd_db}.pub_para_info m10
          on t3.dim_value = m10.para_hcode
         and m10.para_class_hcode = '823'
       WHERE t0.occu_dt BETWEEN ${beg_date} AND ${end_date}

	UNION ALL

      select t0.POS_ID,null as ENTR_DIR,
			 t0.occu_dt as occu_dt, --发生日期
             t0.prd_code as prd_code, --产品代码
             t1.trd_sys_id as src_fund_id, --源基金编号
             t2.prd_name as prd_name, --产品名称
             t2.prd_full_name as prd_full_name, --产品全称
             t2.crrc as crrc, --产品本币币种
             t3.dim_value as prd_clas, --产品类型
             m10.para_cname as prd_clas_name, --产品类型名称
             t0.ast_unit_code as ast_unit_code, --资产单元代码
             substr(t0.ast_unit_code, instr(t0.ast_unit_code, '_') + 1) as src_ast_unit_no, --源资产单元编号
             t4.ast_unit_name as ast_unit_name, --资产单元名称
             t4.src_sys_code as src_ast_unit_onum, --源资产单元序号
             t0.pfl_code as pfl_code, --投组代码
             substr(t0.pfl_code,locate('_',t0.pfl_code,locate('_',t0.pfl_code,2)+1 ) + 1) as src_pfl_no, --源组合编号
             t5.pfl_name as pfl_name, --投资组合名称
             null as odr_onum, --指令序号
             null as src_odr_onum, --源指令序号
             null as src_odr_chg_onum, --源指令修改次序
             null as src_odr_secu_onum, --源指令证券序号
             null as odr_rela_prsn, --指令下达人
             null as odr_rela_agt_prsn, --指令代下达人
             null as odr_oper_lvl, --指令操作级别
             null as odr_vol, --指令数量
             null as trd_typ, --交易类别
             null as entr_onum, --委托序号/执行确认序号
             null as src_entr_onum, --源委托序号/执行确认序号
             null as entr_bath, --委托批号
             null as rep_no, --申报编号
             null as prc_clas, --价格类型
             null as entr_vol, --委托数量
             null as entr_prc, --委托价格
             t0.tnv_onum as tnv_onum, --成交序号
             replace(replace(substr(t0.tnv_onum,
                                   locate('_',t0.tnv_onum,locate('_',t0.tnv_onum,2)+1 ) + 1),
                             'L',
                             ''),
                     'C',
                     '') as src_tnv_onum, --源委托序号/确认序号
             null as tnv_no, --成交编号
             null as tnv_time, --成交时间
             t0.busi_typ as busi_typ, --业务类别
             t0.busi_clas as busi_clas, --业务类型
             null as busi_clas_dtl_o3, --业务类型明细_O3
             null as busi_clas_dtl_name_o3, --业务类型明细名称_O3
             null as entr_dir_o3, --委托方向_o32
             null as entr_dir_name_o3, --委托方向名称_o32
             null as busi_clas_o3, --业务分类_o32
             null as busi_clas_name_o3, --业务分类名称_o32,根据数据字典818转换
             null as sh_code, --股东代码
             null as seat_code, --席位号
             t0.inv_typ as inv_typ, --投资类型
             m3.para_hcode as src_inv_typ, --源投资类型,根据数据字典125转换，并对1的枚举调整为2，2的枚举调整为1
             m3.para_name as src_inv_name, --源投资类型名称
             null as clr_sped, --清算速度
             t0.tnv_vol as tnv_vol, --成交数量
             t0.tnv_prc as tnv_prc, --成交价格
             null as net_prc, --净价价格
             null as full_prc, --全价价格
             t0.tnv_val as tnv_val, --成交金额
             t0.tnv_val as tnv_val_locy, --本币成交金额,当为港币时通过通过汇率信息表中的中间价转换为人名币
             t0.occu_val as occu_val, --发生金额
             null as covr_pl, --平仓盈亏
             null as is_forc_covr, --是否强平
             0 as tot_fee, --总费用
             0 as stmp, --印花税
             0 as tfee, --过户费
             0 as sfee, --证管费
             0 as hand_fee, --经手费
             0 as cms, --佣金
             0 as clea_chag, --结算费
             0 as deli_fee, --交割费
             0 as trd_chag, --交易手续费
             0 as clea_serv_chag, --结算服务费
             0 as pr_fee, --申赎费用
             0 as oth_fee, --其他费用
             0 as full_tfee, --全额过户费
             null as sett_mode, --结算方式
             t0.deli_dt as deli_dt, --交割日期
             null as sett_fail_flag, --交收失败标识
             null as oper_no, --操作员
             null as oper_name, --操作员名称
             null as memo, --备注
             null as fir_deli_dt, --首期交割日期
             null as end_deli_dt, --到期交割日期
             null as fir_deli_mode, --首期交割方式
             null as end_deli_mode, --到期交割方式
             null as fir_net_prc, --首期净价价格
             null as end_net_prc, --到期净价价格
             null as fir_hd_intr, --首期百元利息
             null as end_hd_intr, --到期百元利息
             null as fir_yld, --首期收益率
             null as end_yld, --到期收益率
             null as exer_yld, --行权收益率
             null as valu_yld, --公允收益率
             null as repo_rat, --回购利率
             null as repo_days, --回购天数
             null as buyb_val, --购回金额
             null as inta_days, --计息天数
             null as trad_id, --券商编号
             null as trad_name, --券商名称
             null as trd_cntp_id, --交易对手编码
             null as cntp_sht, --对手方简称
             null as cntp_name, --对手全称
             null as cntp_seat_code, --对方席位号
             null as cntp_delr_id, --对手方交易员
             null as cntp_delr_name, --对手方交易员名称
             null as trd_cntp_ins_rela_typ, --交易对手机构主从类型
             t0.secu_id as secu_id, --证券编码
             t0.secu_code as secu_code, --证券代码
             null as blooaberg_code, --bloomberg
             null as cusip_code, --cusip
             t8.isin_code as isin_code, --isin
             null as ric_code, --ric
             null as sedol_code, --sedol
             t8.secu_sht as secu_sht, --中文简称
             t8.typ_code as typ_code, --证券类别代码（大类）
             t8.typ_codei as typ_codei, --证券类别代码（中类）
             t8.typ_codeii as typ_codeii, --证券类别代码（细分）
             t9.src_secu_class as secu_class_o3, --资产类别_o3
             m1.para_cname as secu_class_name_o3, --资产类别名称_o3
             t9.src_secu_type as secu_type_o3, --证券类别_o3
             m2.para_cname as secu_type_name_o3, --证券类别名称_o3
             null as oth_class_o3, --杂项分类_o3
             t0.exch_code as exch_code, --交易市场代码
             t8.exch_name as exch_name, --交易市场名称
             nvl(t8.curr_code, 'CNY') as curr_code, --货币代码
             nvl(t8.trd_curr_code, 'CNY') as trd_curr_code, --交易货币币种
             t10.is_prc_bond as is_prc_bond, --是否净价债
             t11.tnv_val as mkt_tnv_val, --市场成交额（元）
             t11.tnv_vol as mkt_tnv_vol, --市场成交数量
             (Case
               when t11.tnv_vol > 0 then
                t11.tnv_val / t11.tnv_vol
               else
                0
             end) as mkt_tnv_avg_prc, --市场成交均价
             t11.open_prc, --今开盘
             t11.low_prc as mkt_low_prc, --市场最低价
             t11.high_prc as mkt_high_prc, --市场最高价
             t11.cls_prc as mkt_cls_prc, --市场收盘加
             t11.cls_prc as mkt_last_prc, --市场最新价
             t11.day_chg_rat as day_chg_rat, --日涨跌幅
             null as cnbd_valu, --中债估值
             null as cstd_ins_id, --托管机构
             null as cstd_ins_name, --托管机构名称
             null as ext_rat, --外部评级
             null as inr_rat, --内部评级
             t8.com_id as com_id, --发行机构编号
             t8.com_name as com_name, --发行机构名称
             null as issr_inr_rat, --发行人内部评级
             null as issr_ext_rat, --发行人外部评级
             t10.guar_id as guar_id, --担保人id
             null as guar_rat, --担保人评级
             t10.ocom_id as ocom_id, --最初发行人/原始权益人id
             t10.ocom_name as ocom_name, --最初发行人/原始权益人名称
             null as excf_dt, --确认日期
             null as excf_time, --确认时间
             null as busi_prss_clas_o3, --业务过程分类_o32
             null as busi_prss_clas_name_o3, --业务过程分类名称_o32
             null as tnv_stat, --成交状态
             null as tnv_stat_name, --成交状态名称
             t18.srte_dt as dpsi_srte_dt, --存款起息日期
             t18.end_dt as dpsi_end_dt, --存款到期日期
             null as expe_yld, --理财产品预期收益率
             t18.dpsi_rat as dpsi_rat, --存款利率
             t18.bnk_hbnk_id as bnk_hbnk_id, --银行总行编码
             t18.bnk_hbnk_name as bnk_hbnk_name, --银行总行名称
             t18.dpsi_site as dpsi_site, --存款地方
             t18.ahed_coll_lim as dpsi_ahed_coll_lim, --存款提前支取限制
             t18.accr_intr as dpsi_accr_intr, --存款应计利息
             t18.aggr_intr_incm as dpsi_aggr_intr_incm, --存款累计利息收入
             null as in_secu_id, --转入证券编码
             null as in_secu_code, --转入证券代码
             null as in_secu_name, --转入证券名称
             null as in_exch_code, --转入交易市场代码
             null as in_exch_name, --转入交易市场名称
             null as in_com_id, --转入发行机构编号
             null as in_com_name, --转入发行机构名称
             null as in_tnv_vol, --转入成交数量
             null as in_tnv_prc, --转入成交价格
             null as in_tnv_val, --转入成交金额
             null as in_occu_val, --转入发生金额
             null as in_fee, --转入费用
             null as huge_redp_mode, --巨额赎回方式
             0 as rf_val, --退款金额
             0 as makp_val, --补款金额
             0 as rf_intr, --退款利息
             0 as marg, --保证金
             0 as feer, --费率
             t17.ttl_navl, --净资产
             (Case
               when t17.ttl_navl = 0 then
                0
               else
                t0.tnv_val / t17.ttl_navl
             end) as tnv_val_nav, --成交金额占净值(%)
             null as prc_high, --价格偏离
             null as occu_val_full, --发生金额（全价）
             null as tnv_val_full, --成交金额（全价）
             null as tnv_prc_full, --成交价格（全价）
             null as end_valu_yld, --到期收益率-公允收益率
             ${end_date} AS BUSI_DATE, --业务日期
             NULL AS UPD_TIME, --源数据更新时间
             'O3' AS SYS_RS_ID, --系统来源标识
             'mid_l2_prd_tnv_dtl_7' AS TASK_RS_ID, --任务来源标识
             'evt_sett_tnv_his' AS DM_SRC_INFO, --来源信息
             CURRENT_TIMESTAMP AS DM_CREATED_TIME, --数据中台创建时间
             'OUTLINE' AS DM_CREATED_BY, --数据中台创建者
             CURRENT_TIMESTAMP AS DM_UPDATED_TIME, --数据中台更新时间
             'OUTLINE' AS DM_UPDATED_BY,
	     null,
	     t0.occu_dt as  p_dt
        from ${dwd_db}.evt_sett_tnv_his t0
        left join ${dwd_db}.pty_prd_code_rela_o32 t1
          on t0.prd_code = t1.prd_code
         and t1.sys_rs_id = 'O3'
        left join ${dwd_db}.pty_prd_base_info_o32 t2
          on t0.prd_code = t2.prd_code
        left join ${dwd_db}.pty_prd_fetu_exd_dt_o32 t3
          on t0.prd_code = t3.prd_code
         and t3.dim_code = '1'
        left join ${dwd_db}.pro_acc_asset_unit_info t4
          on t0.ast_unit_code = t4.ast_unit_code
        left join ${dwd_db}.pro_acc_pfl t5
          on t0.pfl_code = t5.pfl_code
        left join ${dwd_db}.var_secu_info_o32 t8
          on t0.secu_id = t8.secu_id
        left join ${dwd_db}.var_secu_code_conf t9
          on t0.secu_id = t9.secu_id
         and t0.occu_Dt = t9.occu_dt
        left join ${dwd_db}.var_bond_info_o32 t10
          on t0.secu_id = t10.secu_id
        left join ${dwd_db}.var_secu_dquot_o32 t11
          on t0.secu_id = t11.secu_id
         and t0.occu_Dt = t11.trd_dt
        left join ${dwd_db}.ast_prd_ast_his t17
          on t0.prd_code = t17.prd_code
         and t0.occu_Dt = t17.occu_Dt
        left join ${dwd_db}.pro_dpsi_info t18
          on t0.secu_id = t18.secu_id
        left join ${dwd_db}.pub_para_info m1
          on t9.src_secu_class = m1.para_hcode
         and m1.para_class_hcode = '817'
        left join ${dwd_db}.pub_para_info m2
          on t9.src_secu_type = m2.para_hcode
         and m2.para_class_hcode = '822'
        left join ${dwd_db}.pub_para_mapping m3
          on t0.inv_typ = m3.orisys_para_code
         and m3.para_class_hcode = '125'
        left join ${dwd_db}.pub_para_info m10
          on t3.dim_value = m10.para_hcode
         and m10.para_class_hcode = '823'
       WHERE t0.occu_dt BETWEEN ${beg_date} AND ${end_date}
) T1
left join ${dwd_db}.pub_para_info m1
  on t1.tnv_stat = m1.para_hcode
 and m1.para_class_hcode = '825'
       ;







create temporary table ${dwd_db}.mid_tmp as
select * from ${dwd_db}.mid_l2_prd_tnv_dtl t0 where   t0.occu_dt BETWEEN ${beg_date} AND ${end_date} ;





alter table ${dwd_db}.mid_l2_prd_tnv_dtl drop if exists partition (p_dt>=${beg_date} , p_dt<=${end_date}) ;
insert into ${dwd_db}.mid_l2_prd_tnv_dtl partition(p_dt)
(occu_dt,prd_code,src_fund_src,prd_name,prd_full_name,crrc,prd_clas,prd_clas_name,ttl_navl,ast_unit_code,src_ast_unit_no,ast_unit_name,src_ast_unit_onum,pfl_code,src_pfl_no,pfl_name,odr_onum,src_odr_onum,src_odr_chg_onum,src_odr_secu_onum,odr_rela_prsn,odr_rela_agt_prsn,odr_oper_lvl,odr_vol,trd_typ,entr_onum,src_entr_onum,entr_bath,rep_no,prc_clas,entr_vol,entr_prc,tnv_onum,src_tnv_onum,tnv_no,tnv_time,busi_typ,busi_clas,entr_dir_o3,entr_dir_name_o3,busi_clas_o3,busi_clas_name_o3,sh_code,seat_code,inv_typ,src_inv_typ,src_inv_typ_name,clr_sped,tnv_vol,tnv_prc,net_prc,full_prc,tnv_val,tnv_val_locy,occu_val,covr_pl,is_forc_covr,tot_fee,stmp,tfee,sfee,hand_fee,cms,clea_chag,deli_fee,trd_chag,clea_serv_chag,pr_fee,oth_fee,full_tfee,sett_mode,deli_dt,sett_fail_flag,oper_no,oper_name,tnv_stat,tnv_stat_name,inbk_stat,inbk_stat_name,memo,fir_deli_dt,end_deli_dt,fir_deli_mode,end_deli_mode,fir_net_prc,end_net_prc,fir_hd_intr,end_hd_intr,fir_yld,end_yld,exer_yld,valu_yld,repo_rat,repo_days,buyb_val,inta_days,trad_id,trad_name,trd_cntp_id,cntp_sht,cntp_name,cntp_seat_code,cntp_delr_id,cntp_delr_name,trd_cntp_ins_rela_typ,secu_id,secu_code,blooaberg_code,cusip_code,isin_code,ric_code,sedol_code,secu_sht,typ_code,typ_codei,typ_codeii,secu_class_o3,secu_class_name_o3,secu_type_o3,secu_type_name_o3,oth_class_o3,exch_code,exch_name,curr_code,trd_curr_code,is_prc_bond,mkt_tnv_val,mkt_tnv_vol,open_prc,mkt_tnv_avg_prc,mkt_low_prc,mkt_high_prc,mkt_cls_prc,mkt_last_prc,day_chg_rat,cnbd_valu,cstd_ins_id,cstd_ins_name,ext_rat,inr_rat,com_id,com_name,issr_inr_rat,issr_ext_rat,guar_id,guar_rat,ocom_id,excf_dt,excf_time,busi_prss_clas_o3,busi_prss_clas_name_o3,excf_tnv_stat,excf_tnv_stat_name,dpsi_srte_dt,dpsi_end_dt,expe_yld,dpsi_rat,bnk_hbnk_id,bnk_hbnk_name,dpsi_site,dpsi_ahed_coll_lim,dpsi_accr_intr,dpsi_aggr_intr_incm,in_secu_id,in_secu_code,in_secu_name,in_exch_code,in_exch_name,in_com_id,in_com_name,in_tnv_vol,in_tnv_prc,in_tnv_val,in_occu_val,in_fee,huge_redp_mode,rf_val,makp_val,rf_intr,marg,feer,tnv_val_nav,prc_high,tnv_val_full,occu_val_full,tnv_prc_full,end_valu_yld,cptl_dir,secu_dir,tnv_flag,busi_date,sys_rs_id,task_rs_id,dm_created_time,p_dt)
select T0.occu_dt, --发生日期
       T0.prd_code, --产品代码
       T0.src_fund_id, --源基金编号
       T0.prd_name, --产品名称
       T0.prd_full_name, --产品全称
       T0.crrc, --产品本币币种
       T0.prd_clas, --产品类型
       T0.prd_clas_name, --产品类型名称
       T0.ast_unit_code, --资产单元代码
       T0.src_ast_unit_no, --源资产单元编号
       T0.ast_unit_name, --资产单元名称
       T0.src_ast_unit_onum, --源资产单元序号
       T0.pfl_code, --投组代码
       T0.src_pfl_no, --源组合编号
       T0.pfl_name, --投资组合名称
       T0.odr_onum, --指令序号
       T0.src_odr_onum, --源指令序号
       T0.src_odr_chg_onum, --源指令修改次序
       T0.src_odr_secu_onum, --源指令证券序号
       T0.odr_rela_prsn, --指令下达人
       T0.odr_rela_agt_prsn, --指令代下达人
       T0.odr_oper_lvl, --指令操作级别
       T0.odr_vol, --指令数量
       T0.trd_typ, --交易类别
       T0.entr_onum, --委托序号/执行确认序号
       T0.src_entr_onum, --源委托序号/执行确认序号
       T0.entr_bath, --委托批号
       T0.rep_no, --申报编号
       T0.prc_clas, --价格类型
       T0.entr_vol, --委托数量
       T0.entr_prc, --委托价格
       T0.tnv_onum, --成交序号
       T0.src_tnv_onum, --源委托序号/确认序号
       T0.tnv_no, --成交编号
       T0.tnv_time, --成交时间
       T0.busi_typ, --业务类别
       T0.busi_clas, --业务类型
       T0.busi_clas_dtl_o3, --业务类型明细_O3
       T0.busi_clas_dtl_name_o3, --业务类型明细名称_O3
       T0.entr_dir_o3, --委托方向_o32
       T0.entr_dir_name_o3, --委托方向名称_o32
       T0.busi_clas_o3, --业务分类_o32
       T0.busi_clas_name_o3, --业务分类名称_o32
       T0.sh_code, --股东代码
       T0.seat_code, --席位号
       T0.inv_typ, --投资类型
       T0.src_inv_typ, --源投资类型
       T0.src_inv_name, --源投资类型名称
       T0.clr_sped, --清算速度
       T0.tnv_vol, --成交数量
       T0.tnv_prc, --成交价格
       T0.net_prc, --净价价格
       T0.full_prc, --全价价格
       T0.tnv_val, --成交金额
       T0.tnv_val_locy, --本币成交金额
       T0.occu_val, --发生金额
       T0.covr_pl, --平仓盈亏
       T0.is_forc_covr, --是否强平
       T0.tot_fee, --总费用
       T0.stmp, --印花税
       T0.tfee, --过户费
       T0.sfee, --证管费
       T0.hand_fee, --经手费
       T0.cms, --佣金
       T0.clea_chag, --结算费
       T0.deli_fee, --交割费
       T0.trd_chag, --交易手续费
       T0.clea_serv_chag, --结算服务费
       T0.pr_fee, --申赎费用
       T0.oth_fee, --其他费用
       T0.full_tfee, --全额过户费
       T0.sett_mode, --结算方式
       T0.deli_dt, --交割日期
       T0.sett_fail_flag, --交收失败标识
       T0.oper_no, --操作员
       T0.oper_name, --操作员名称
       T0.memo, --备注
       T0.fir_deli_dt, --首期交割日期
       T0.end_deli_dt, --到期交割日期
       T0.fir_deli_mode, --首期交割方式
       T0.end_deli_mode, --到期交割方式
       T0.fir_net_prc, --首期净价价格
       T0.end_net_prc, --到期净价价格
       T0.fir_hd_intr, --首期百元利息
       T0.end_hd_intr, --到期百元利息
       T0.fir_yld, --首期收益率
       T0.end_yld, --到期收益率
       T0.exer_yld, --行权收益率
       T0.valu_yld, --公允收益率
       T0.repo_rat, --回购利率
       T0.repo_days, --回购天数
       T0.buyb_val, --购回金额
       T0.inta_days, --计息天数
       T0.trad_id, --券商编号
       T0.trad_name, --券商名称
       T0.trd_cntp_id, --交易对手编码
       T0.cntp_sht, --对手方简称
       T0.cntp_name, --对手全称
       T0.cntp_seat_code, --对方席位号
       T0.cntp_delr_id, --对手方交易员
       T0.cntp_delr_name, --对手方交易员名称
       T0.trd_cntp_ins_rela_typ, --交易对手机构主从类型
       T0.secu_id, --证券编码
       T0.secu_code, --证券代码
       T0.blooaberg_code, --bloomberg
       T0.cusip_code, --cusip
       T0.isin_code, --isin
       T0.ric_code, --ric
       T0.sedol_code, --sedol
       nvl(t1.secu_sht, t0.secu_sht) as secu_sht, --中文简称
       T0.typ_code, --证券类别代码（大类）
       T0.typ_codei, --证券类别代码（中类）
       T0.typ_codeii, --证券类别代码（细分）
       T0.secu_class_o3, --资产类别_o3
       T0.secu_class_name_o3, --资产类别名称_o3
       T0.secu_type_o3, --证券类别_o3
       T0.secu_type_name_o3, --证券类别名称_o3
       T0.oth_class_o3, --杂项分类_o3
       T0.exch_code, --交易市场代码
       T0.exch_name, --交易市场名称
       T0.curr_code, --货币代码
       T0.trd_curr_code, --交易货币币种
       T0.is_prc_bond, --是否净价债
       T0.mkt_tnv_val, --市场成交额（元）
       T0.mkt_tnv_vol, --市场成交数量
       T0.mkt_tnv_avg_prc, --市场成交均价
       T0.open_prc, --今开盘
       T0.mkt_low_prc, --市场最低价
       T0.mkt_high_prc, --市场最高价
       T0.mkt_cls_prc, --市场收盘加
       T0.mkt_last_prc, --市场最新价
       T0.day_chg_rat, --日涨跌幅
       T0.cnbd_valu, --中债估值
       T0.cstd_ins_id, --托管机构
       T0.cstd_ins_name, --托管机构名称
       T0.ext_rat, --外部评级
       T0.inr_rat, --内部评级
       T0.com_id, --发行机构编号
       T0.com_name, --发行机构名称
       T0.issr_inr_rat, --发行人内部评级
       T0.issr_ext_rat, --发行人外部评级
       T0.guar_id, --担保人id
       T0.guar_rat, --担保人评级
       T0.ocom_id, --最初发行人/原始权益人id
       T0.ocom_name, --最初发行人/原始权益人名称
       T0.excf_dt, --确认日期
       T0.excf_time, --确认时间
       T0.busi_prss_clas_o3, --业务过程分类_o32
       T0.busi_prss_clas_name_o3, --业务过程分类名称_o32
       T0.tnv_stat, --成交状态
       T0.tnv_stat_name, --成交状态名称
       T0.dpsi_srte_dt, --存款起息日期
       T0.dpsi_end_dt, --存款到期日期
       T0.expe_yld, --理财产品预期收益率
       T0.dpsi_rat, --存款利率
       T0.bnk_hbnk_id, --银行总行编码
       T0.bnk_hbnk_name, --银行总行名称
       T0.dpsi_site, --存款地方
       T0.dpsi_ahed_coll_lim, --存款提前支取限制
       T0.dpsi_accr_intr, --存款应计利息
       T0.dpsi_aggr_intr_incm, --存款累计利息收入
       T0.in_secu_id, --转入证券编码
       T0.in_secu_code, --转入证券代码
       T0.in_secu_name, --转入证券名称
       T0.in_exch_code, --转入交易市场代码
       T0.in_exch_name, --转入交易市场名称
       T0.in_com_id, --转入发行机构编号
       T0.in_com_name, --转入发行机构名称
       T0.in_tnv_vol, --转入成交数量
       T0.in_tnv_prc, --转入成交价格
       T0.in_tnv_val, --转入成交金额
       T0.in_occu_val, --转入发生金额
       T0.in_fee, --转入费用
       T0.huge_redp_mode, --巨额赎回方式
       T0.rf_val, --退款金额
       T0.makp_val, --补款金额
       T0.rf_intr, --退款利息
       T0.marg, --保证金
       T0.feer, --费率
       T0.ttl_navl, --净资产
       T0.tnv_val_nav, --成交金额占净值
       T0.prc_high, --价格偏离
       T0.occu_val_full, --发生金额（全价）
       T0.tnv_val_full, --成交金额（全价）
       T0.tnv_prc_full, --成交价格（全价）
       T0.end_valu_yld, --到期收益率-公允收益率
       T0.busi_date, --业务日期
       T0.upd_time, --源数据修改时间
       T0.sys_rs_id, --系统来源标识
       T0.task_rs_id, --任务来源标识
       T0.dm_src_info, --来源信息
       T0.dm_created_time, --数据中台创建时间
       T0.dm_created_by, --数据中台创建者
       current_date, --数据中台更新时间
       T0.dm_updated_by, --数据中台更新者
       T0.cont_mult, --合约乘数
       T0.occu_dt as p_dt
  from (select * from ${dwd_db}.mid_tmp t0 where t0.typ_code = 'STK') T0
  left join (select T1.*
               from ${dwd_db}.var_stk_abbr_chg t1
               join (select *
                      from ${dwd_db}.mid_tmp t0
                     where t0.typ_code = 'STK') T0
              where t0.occu_dt between t1.bgn_dt and t1.end_dt
                and t1.bgn_dt between ${end_date} and ${beg_date}
                and t0.secu_sht <> t1.secu_sht
                and t1.info_sour <> '初始'
			) T1
    on T0.secu_id = t1.secu_id

union all

select T0.occu_dt, --发生日期
       T0.prd_code, --产品代码
       T0.src_fund_id, --源基金编号
       T0.prd_name, --产品名称
       T0.prd_full_name, --产品全称
       T0.crrc, --产品本币币种
       T0.prd_clas, --产品类型
       T0.prd_clas_name, --产品类型名称
       T0.ast_unit_code, --资产单元代码
       T0.src_ast_unit_no, --源资产单元编号
       T0.ast_unit_name, --资产单元名称
       T0.src_ast_unit_onum, --源资产单元序号
       T0.pfl_code, --投组代码
       T0.src_pfl_no, --源组合编号
       T0.pfl_name, --投资组合名称
       T0.odr_onum, --指令序号
       T0.src_odr_onum, --源指令序号
       T0.src_odr_chg_onum, --源指令修改次序
       T0.src_odr_secu_onum, --源指令证券序号
       T0.odr_rela_prsn, --指令下达人
       T0.odr_rela_agt_prsn, --指令代下达人
       T0.odr_oper_lvl, --指令操作级别
       T0.odr_vol, --指令数量
       T0.trd_typ, --交易类别
       T0.entr_onum, --委托序号/执行确认序号
       T0.src_entr_onum, --源委托序号/执行确认序号
       T0.entr_bath, --委托批号
       T0.rep_no, --申报编号
       T0.prc_clas, --价格类型
       T0.entr_vol, --委托数量
       T0.entr_prc, --委托价格
       T0.tnv_onum, --成交序号
       T0.src_tnv_onum, --源委托序号/确认序号
       T0.tnv_no, --成交编号
       T0.tnv_time, --成交时间
       T0.busi_typ, --业务类别
       T0.busi_clas, --业务类型
       T0.busi_clas_dtl_o3, --业务类型明细_O3
       T0.busi_clas_dtl_name_o3, --业务类型明细名称_O3
       T0.entr_dir_o3, --委托方向_o32
       T0.entr_dir_name_o3, --委托方向名称_o32
       T0.busi_clas_o3, --业务分类_o32
       T0.busi_clas_name_o3, --业务分类名称_o32
       T0.sh_code, --股东代码
       T0.seat_code, --席位号
       T0.inv_typ, --投资类型
       T0.src_inv_typ, --源投资类型
       T0.src_inv_name, --源投资类型名称
       T0.clr_sped, --清算速度
       T0.tnv_vol, --成交数量
       T0.tnv_prc, --成交价格
       T0.net_prc, --净价价格
       T0.full_prc, --全价价格
       T0.tnv_val, --成交金额
       T0.tnv_val_locy, --本币成交金额
       T0.occu_val, --发生金额
       T0.covr_pl, --平仓盈亏
       T0.is_forc_covr, --是否强平
       T0.tot_fee, --总费用
       T0.stmp, --印花税
       T0.tfee, --过户费
       T0.sfee, --证管费
       T0.hand_fee, --经手费
       T0.cms, --佣金
       T0.clea_chag, --结算费
       T0.deli_fee, --交割费
       T0.trd_chag, --交易手续费
       T0.clea_serv_chag, --结算服务费
       T0.pr_fee, --申赎费用
       T0.oth_fee, --其他费用
       T0.full_tfee, --全额过户费
       T0.sett_mode, --结算方式
       T0.deli_dt, --交割日期
       T0.sett_fail_flag, --交收失败标识
       T0.oper_no, --操作员
       T0.oper_name, --操作员名称
       T0.memo, --备注
       T0.fir_deli_dt, --首期交割日期
       T0.end_deli_dt, --到期交割日期
       T0.fir_deli_mode, --首期交割方式
       T0.end_deli_mode, --到期交割方式
       T0.fir_net_prc, --首期净价价格
       T0.end_net_prc, --到期净价价格
       T0.fir_hd_intr, --首期百元利息
       T0.end_hd_intr, --到期百元利息
       T0.fir_yld, --首期收益率
       T0.end_yld, --到期收益率
       T0.exer_yld, --行权收益率
       T0.valu_yld, --公允收益率
       T0.repo_rat, --回购利率
       T0.repo_days, --回购天数
       T0.buyb_val, --购回金额
       T0.inta_days, --计息天数
       T0.trad_id, --券商编号
       T0.trad_name, --券商名称
       T0.trd_cntp_id, --交易对手编码
       T0.cntp_sht, --对手方简称
       T0.cntp_name, --对手全称
       T0.cntp_seat_code, --对方席位号
       T0.cntp_delr_id, --对手方交易员
       T0.cntp_delr_name, --对手方交易员名称
       T0.trd_cntp_ins_rela_typ, --交易对手机构主从类型
       T0.secu_id, --证券编码
       T0.secu_code, --证券代码
       T0.blooaberg_code, --bloomberg
       T0.cusip_code, --cusip
       T0.isin_code, --isin
       T0.ric_code, --ric
       T0.sedol_code, --sedol
       t0.secu_sht               as secu_sht, --中文简称
       T0.typ_code, --证券类别代码（大类）
       T0.typ_codei, --证券类别代码（中类）
       T0.typ_codeii, --证券类别代码（细分）
       T0.secu_class_o3, --资产类别_o3
       T0.secu_class_name_o3, --资产类别名称_o3
       T0.secu_type_o3, --证券类别_o3
       T0.secu_type_name_o3, --证券类别名称_o3
       T0.oth_class_o3, --杂项分类_o3
       T0.exch_code, --交易市场代码
       T0.exch_name, --交易市场名称
       T0.curr_code, --货币代码
       T0.trd_curr_code, --交易货币币种
       T0.is_prc_bond, --是否净价债
       T0.mkt_tnv_val, --市场成交额（元）
       T0.mkt_tnv_vol, --市场成交数量
       T0.mkt_tnv_avg_prc, --市场成交均价
       T0.open_prc, --今开盘
       T0.mkt_low_prc, --市场最低价
       T0.mkt_high_prc, --市场最高价
       T0.mkt_cls_prc, --市场收盘加
       T0.mkt_last_prc, --市场最新价
       T0.day_chg_rat, --日涨跌幅
       T0.cnbd_valu, --中债估值
       T0.cstd_ins_id, --托管机构
       T0.cstd_ins_name, --托管机构名称
       T0.ext_rat, --外部评级
       T0.inr_rat, --内部评级
       T0.com_id, --发行机构编号
       T0.com_name, --发行机构名称
       T0.issr_inr_rat, --发行人内部评级
       T0.issr_ext_rat, --发行人外部评级
       T0.guar_id, --担保人id
       T0.guar_rat, --担保人评级
       T0.ocom_id, --最初发行人/原始权益人id
       T0.ocom_name, --最初发行人/原始权益人名称
       T0.excf_dt, --确认日期
       T0.excf_time, --确认时间
       T0.busi_prss_clas_o3, --业务过程分类_o32
       T0.busi_prss_clas_name_o3, --业务过程分类名称_o32
       T0.tnv_stat, --成交状态
       T0.tnv_stat_name, --成交状态名称
       T0.dpsi_srte_dt, --存款起息日期
       T0.dpsi_end_dt, --存款到期日期
       T0.expe_yld, --理财产品预期收益率
       T0.dpsi_rat, --存款利率
       T0.bnk_hbnk_id, --银行总行编码
       T0.bnk_hbnk_name, --银行总行名称
       T0.dpsi_site, --存款地方
       T0.dpsi_ahed_coll_lim, --存款提前支取限制
       T0.dpsi_accr_intr, --存款应计利息
       T0.dpsi_aggr_intr_incm, --存款累计利息收入
       T0.in_secu_id, --转入证券编码
       T0.in_secu_code, --转入证券代码
       T0.in_secu_name, --转入证券名称
       T0.in_exch_code, --转入交易市场代码
       T0.in_exch_name, --转入交易市场名称
       T0.in_com_id, --转入发行机构编号
       T0.in_com_name, --转入发行机构名称
       T0.in_tnv_vol, --转入成交数量
       T0.in_tnv_prc, --转入成交价格
       T0.in_tnv_val, --转入成交金额
       T0.in_occu_val, --转入发生金额
       T0.in_fee, --转入费用
       T0.huge_redp_mode, --巨额赎回方式
       T0.rf_val, --退款金额
       T0.makp_val, --补款金额
       T0.rf_intr, --退款利息
       T0.marg, --保证金
       T0.feer, --费率
       T0.ttl_navl, --净资产
       T0.tnv_val_nav, --成交金额占净值
       T0.prc_high, --价格偏离
       T0.occu_val_full, --发生金额（全价）
       T0.tnv_val_full, --成交金额（全价）
       T0.tnv_prc_full, --成交价格（全价）
       T0.end_valu_yld, --到期收益率-公允收益率
       T0.busi_date, --业务日期
       T0.upd_time, --源数据修改时间
       T0.sys_rs_id, --系统来源标识
       T0.task_rs_id, --任务来源标识
       T0.dm_src_info, --来源信息
       T0.dm_created_time, --数据中台创建时间
       T0.dm_created_by, --数据中台创建者
       current_date, --数据中台更新时间
       T0.dm_updated_by, --数据中台更新者
       T0.cont_mult, --合约乘数
       T0.occu_dt                as p_dt
  from ${dwd_db}.mid_tmp t0
 where t0.typ_code <> 'STK'
;

