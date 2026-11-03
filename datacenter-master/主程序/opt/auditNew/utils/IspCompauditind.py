#!/usr/bin/env python 
# -*- coding:utf-8 -*-
import sys
import traceback
import cx_Oracle
import IbpExecsqlComp
import IbpExecsqlCompOrc
import QueryFromArgs
import QueryFromGlobalVal
import IspChkauditresult
import threading
import os
import datetime 

'''
根据稽核结果集、稽核指标名称、源系统简称、源系统指标序号完成指标计算
'''


def oracle_con(user, password, url, url2):
	try:
		con = cx_Oracle.connect(user, password, url)
		return con
	except cx_Oracle.DatabaseError:
		con = cx_Oracle.connect(user, password, url2)
		return con

def get_ourl(db_host, db_port, db_instant):
	return str(db_host) + ":" + str(db_port) + "/" +str(db_instant)

def lamb(func, data):
	l = []
	for x in data:
		if type(x) == str:
			l.append(func(x))
		else:
			l.append(x)
	return l

class IspCompauditind:

	def __init__(self, argsdict, argv_type, globaldict, user, password, url, url2, h_node, h_user, protocoltype, impala_deamon, hiveusername, hivepassword):
		self.argsdict = argsdict
		self.argv_type = argv_type
		self.globaldict = globaldict
		self.user = user
		self.password = password
		self.url = url
		self.url2 = url2
		self.h_node = h_node
		self.h_user = h_user
		# Modified By LuoGong@20200715:增加入参
		self.protocoltype = protocoltype
		self.impala_deamon = impala_deamon
		self.hiveusername = hiveusername
		self.hivepassword = hivepassword
                now = datetime.datetime.now()
		currentdate = datetime.datetime.strftime(now, "%Y%m%d")
                self.audit_dt= currentdate

	def exe(self, logger):
		try:
			self.con = oracle_con(self.user, self.password, self.url, self.url2)
			self.sm = self.con.cursor()
			if "pi_sk_measure" in self.argsdict:
				if self.argsdict["pi_sk_measure"] is not None:
					self.has_sk_measure = True
				else:
					self.has_sk_measure = False
			else:
				self.has_sk_measure = False
			# 如果计算结果记录已存在且需强制重算(或非基准指标),则删除原结果,重新计算(根据传参模式决定该重算的记录)
			# Modified By LuoGong@20200715:按源删除
			re_run_sql_1 = '''delete from ctl_audit_result_new t
 								where t.sk_measure = {sk_measure} 
                                 and t.audit_dt = '{audit_dt}' '''
								 
			re_run_sql_2 = '''delete from ctl_audit_result_new t
 								where t.data_set = '{in_data_set}' 
  								 and t.audit_dt = '{audit_dt}' '''
			# 获取游标
			cur_sql_1 = '''select      p.sk_measure,
									   p.data_set,
								       p.measure_name,
								       p.src_sql,
								       p.trg_sql,
								       p.rule,
								       sdb.db_user as sdb_user,
                                       utl_raw.cast_to_varchar2(utl_encode.base64_decode(utl_raw.cast_to_raw(sdb.db_passwd))) as sdb_passwd,
								       sdb.db_host as sdb_host,
								       sdb.db_port as sdb_port,
								       sdb.db_instant as sdb_instant,
								       tdb.db_user as tdb_user,
									  utl_raw.cast_to_varchar2(utl_encode.base64_decode(utl_raw.cast_to_raw(tdb.db_passwd))) as tdb_passwd,
								       tdb.db_host as tdb_host,
								       tdb.db_port as tdb_port,
								       tdb.db_instant as tdb_instant,
									   p.exec_type as exec_type
								  from ctl_audit_param_new p
								  left join ctl_db_info sdb
								    on p.src_db = sdb.db_name
								   left join ctl_db_info tdb
								   on p.trg_db = tdb.db_name
								 where p.sk_measure = {sk_measure} 
								   and p.dk_active = 1 '''
								   
			cur_sql_2 = '''select      p.sk_measure,				
									   p.data_set,
									   p.measure_name,
									   p.src_sql,
									   p.trg_sql,
									   p.rule,
									   sdb.db_user as sdb_user,
                                       utl_raw.cast_to_varchar2(utl_encode.base64_decode(utl_raw.cast_to_raw(sdb.db_passwd))) as sdb_passwd,
									   sdb.db_host as sdb_host,
									   sdb.db_port as sdb_port,
									   sdb.db_instant as sdb_instant,
									   tdb.db_user as tdb_user,
									   utl_raw.cast_to_varchar2(utl_encode.base64_decode(utl_raw.cast_to_raw(tdb.db_passwd))) as tdb_passwd,
									   tdb.db_host as tdb_host,
									   tdb.db_port as tdb_port,
									   tdb.db_instant as tdb_instant,
									   p.exec_type as exec_type
									from ctl_audit_param_new p
									left join ctl_db_info sdb
									 on p.src_db = sdb.db_name
									left join ctl_db_info tdb
									 on p.trg_db = tdb.db_name
									where p.data_set = '{in_data_set}' 								
									 and p.dk_active = 1 '''
									 
			if self.has_sk_measure:
				re_run_sql = re_run_sql_1.format(
					sk_measure=self.argsdict["pi_sk_measure"],                    
					audit_dt=self.audit_dt )
				cur_sql = cur_sql_1.format(sk_measure=self.argsdict["pi_sk_measure"])
			else:
				re_run_sql = re_run_sql_2.format( in_data_set=self.argsdict["pi_data_set"],  audit_dt=self.audit_dt)
				cur_sql = cur_sql_2.format(in_data_set=self.argsdict["pi_data_set"])
			logger.info("execute sql:%s" % re_run_sql)
			self.sm.execute(re_run_sql)
			self.con.commit()
			logger.info("execute sql:%s" % cur_sql)
			self.sm.execute(cur_sql)
			mycursor = self.sm.fetchall()
                        logger.info("execute sql return :%s" %mycursor )
			cur_data = [line for line in mycursor]
			self.audit_list = []
			
			for line in cur_data:
                                logger.info("execute sql:%s" % str(line))
			        self.thread_audit(line,logger)
                     	        
			#self.sm.close()
			#self.con.close()
                        #self.threadmax.release()
			if "N" in self.audit_list:
				logger.error("Exit with the error rule!")
				# sys.exit(1)
				os._exit(1)
			else:
				sys.exit(0)
                        #self.threadmax.release()
		except Exception:
			exe = traceback.format_exc()
			logger.error(exe)
			# sys.exit(1)
			os._exit(1)

	def thread_audit(self,line,logger):
		# self.lock.acquire()# 上锁
		# print 'lock.acquire',i
		# 将游标值里的全局变量替换
		QueryFGL = QueryFromGlobalVal.QueryFromGlobalVal(self.globaldict)
		i = lamb(QueryFGL.query, line)
                                      
		sk_measure = i[0]
		data_set = i[1]
		measure_name = i[2]
		src_sql = i[3]
		trg_sql = i[4]
		rule = i[5]
		SDB_USER = i[6]
		SDB_PASSWD = i[7]
		SDB_HOST = i[8]
		SDB_PORT = i[9]
		SDB_INSTANT = i[10]
		TDB_USER = i[11]
		TDB_PASSWD = i[12]
		TDB_HOST = i[13]
		TDB_PORT = i[14]
		TDB_INSTANT = i[15]
		exec_type = i[16]
		# 将源sql和目标sql的参数替换
		QueryFromA = QueryFromArgs.QueryFromArgs(self.argsdict, self.argv_type)
		try:
			src_sql = QueryFromA.query(src_sql)
			trg_sql = QueryFromA.query(trg_sql)
		except Exception as e:
			exit()
		# 解析源和目标的数据库类型，R:RDBMS  H:HIVE
		src_type = rule[0]
		trg_type = rule[1]
		# 解析源稽核指标
		logger.info("Exec src_sql:{}".format(src_sql))
		#print sk_measure
		if src_type == "R":
			src_url = get_ourl(SDB_HOST, SDB_PORT, SDB_INSTANT)
			S_IbpECO = IbpExecsqlCompOrc.IbpExecsqlCompOrc(src_sql, SDB_USER, SDB_PASSWD, src_url)
			s_retvals = S_IbpECO.exe(logger)
		elif exec_type == 1:
			# Modified By LuoGong@20200715:添加入参
			#S_IbpEC = IbpExecsqlComp.IbpExecsqlComp(src_sql, self.h_node, self.protocoltype, self.hiveusername, self.hivepassword)
			# Modified By 20211108: hive连接地址使用ctl_db_info里面配置的ip地址，为了兼容稽核不同集群之间的稽核。
			S_IbpEC = IbpExecsqlComp.IbpExecsqlComp(src_sql, SDB_HOST, self.protocoltype, SDB_USER, SDB_PASSWD)
			s_retvals = S_IbpEC.exe(logger)
		else:
			# Modified By LuoGong@20200720:支持impala
			#S_IbpEC = IbpExecsqlComp.IbpExecsqlCompImpala(src_sql, self.protocoltype, self.impala_deamon, self.hiveusername, self.hivepassword)
			# Modified By 20211108: hive连接地址使用ctl_db_info里面配置的ip地址，为了兼容稽核不同集群之间的稽核。
			S_IbpEC = IbpExecsqlComp.IbpExecsqlCompImpala(src_sql, self.protocoltype, SDB_HOST, self.hiveusername, SDB_PASSWD)
			s_retvals = S_IbpEC.exe(logger)
		# 解析目标稽核指标
		logger.info("Exec trg_sql:{}".format(trg_sql))
		if trg_type == "R":
			trg_url = get_ourl(TDB_HOST, TDB_PORT, TDB_INSTANT)
			T_IbpECO = IbpExecsqlCompOrc.IbpExecsqlCompOrc(trg_sql, TDB_USER, TDB_PASSWD, trg_url)
			t_retvals = T_IbpECO.exe(logger)
		elif exec_type == 1:
			# Modified By LuoGong@20200715:添加入参
			#T_IbpEC = IbpExecsqlComp.IbpExecsqlComp(trg_sql, self.h_node, self.protocoltype, self.hiveusername, self.hivepassword)
			# Modified By 20211108: hive连接地址使用ctl_db_info里面配置的ip地址，为了兼容稽核不同集群之间的稽核。
			T_IbpEC = IbpExecsqlComp.IbpExecsqlComp(trg_sql, TDB_HOST, self.protocoltype, TDB_USER, TDB_PASSWD)
			t_retvals = T_IbpEC.exe(logger)
		else:
			# Modified By LuoGong@20200720:支持impala
			#T_IbpEC = IbpExecsqlComp.IbpExecsqlCompImpala(trg_sql, self.protocoltype, self.impala_deamon, self.hiveusername, self.hivepassword)
			# Modified By 20211108: hive连接地址使用ctl_db_info里面配置的ip地址，为了兼容稽核不同集群之间的稽核。
			T_IbpEC = IbpExecsqlComp.IbpExecsqlCompImpala(trg_sql, self.protocoltype, TDB_HOST, self.hiveusername, TDB_PASSWD)
			t_retvals = T_IbpEC.exe(logger)
		# 如果源和目标稽核都执行成功则写入结果
		#IspChk = IspChkauditresult.IspChkauditresult(s_retvals, t_retvals, err_val, err_type)
		#dk_audit_pass = IspChk.exe(logger)
		#self.audit_list.append(dk_audit_pass)
            
		#src_result = ",".join([str(val) for val in s_retvals])
		#trg_result = ",".join([str(val) for val in t_retvals])
                src_sql = src_sql.replace("'", "''")
                trg_sql = trg_sql.replace("'", "''") 
                ta1=[sk_measure,measure_name, data_set, self.audit_dt,'src',src_sql,trg_sql]
                self.insertre(ta1,s_retvals,logger)    
        
                ta2=[sk_measure,measure_name, data_set, self.audit_dt,'tar',src_sql,trg_sql]
                self.insertre(ta2,t_retvals,logger) 


        def insertre(self, ta,dataew,logger):
            self.con = oracle_con(self.user, self.password, self.url, self.url2)
            self.sm = self.con.cursor()
            for data in dataew:
	        r_sql = '''insert into ctl_audit_result_new
	                               (SK_MEASURE,
                                        MEASURE_NAME,
                                        DATA_SET,		
                                        AUDIT_DT,
                                        SOURCE_ID,
                                        SRC_SQL,
                                        TRG_SQL,
                                        P1,
                                        P2,
                                        P3,
                                        P4,
                                        P5,
                                        P6,
                                        P7,
                                        P8,
                                        P9,
                                        P10,
                                        P11,
                                        P12,
                                        P13,
                                        P14,
                                        P15,
                                        P16,
                                        P17,
                                        P18,
                                        P19,
                                        P20)
				VALUES
                                      ({SK_MEASURE},
                                      '{MEASURE_NAME}',
                                      '{DATA_SET}',
                                      '{AUDIT_DT}',
                                      '{SOURCE_ID}',
                                      '{SRC_SQL}',
                                      '{TRG_SQL}',
                                      '{P1}',
                                      '{P2}',
                                      '{P3}',
                                      '{P4}',
                                      '{P5}',
                                      '{P6}',
                                      '{P7}',
                                      '{P8}',
                                      '{P9}',
                                      '{P10}',
                                      '{P11}',
                                      '{P12}',
                                      '{P13}',
                                      '{P14}',
                                      '{P15}',
                                      '{P16}',
                                      '{P17}',
                                      '{P18}',
                                      '{P19}',
                                      '{P20}')
	      								'''
	        r_sql = r_sql.format(SK_MEASURE=ta[0],
                             MEASURE_NAME=ta[1], 
                             DATA_SET=ta[2],
			     AUDIT_DT=ta[3],
                             SOURCE_ID=ta[4],
                             SRC_SQL=ta[5],
                             TRG_SQL=ta[6],
                             P1=data[0],
                             P2=data[1],
                             P3=data[2],
                             P4=data[3],
                             P5=data[4],
                             P6=data[5],
                             P7=data[6],
                             P8=data[7],
                             P9=data[8],
                             P10=data[9],
                             P11=data[10],
                             P12=data[11],
                             P13=data[12],
                             P14=data[13],
                             P15=data[14],
                             P16=data[15],
                             P17=data[16],
                             P18=data[17],
                             P19=data[18],
                             P20=data[19])
		logger.info("Record into result:%s" % r_sql)
		try:
			self.sm.execute(r_sql)
			self.con.commit() 
		except Exception:
                        self.sm.close()
			exe = traceback.format_exc()
			logger.error(exe)
			os._exit(1)
            self.con.close()

