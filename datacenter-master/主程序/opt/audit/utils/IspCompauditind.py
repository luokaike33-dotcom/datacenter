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
			re_run_sql_1 = '''delete from ctl_audit_result t
 								where t.sk_measure = {sk_measure} 
  								 and t.startdate = {in_startdate}
  								 and t.enddate = {in_enddate}
								 and t.srcsys = '{in_srcsys}' '''
								 
			re_run_sql_2 = '''delete from ctl_audit_result t
 								where t.data_set = '{in_data_set}' 
 								 and t.srcsys = '{in_srcsys}' 
  								 and t.startdate = {in_startdate}
  								 and t.enddate = {in_enddate} '''
			# 获取游标
			cur_sql_1 = '''select      p.sk_measure,
									   p.srcsys,
									   p.data_set,
								       p.measure_name,
								       p.src_sql,
								       p.trg_sql,
								       p.err_val,
								       p.err_type,
								       p.treatment_type,
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
								  from ctl_audit_param p
								  left join ctl_db_info sdb
								    on p.src_db = sdb.db_name
								   left join ctl_db_info tdb
								   on p.trg_db = tdb.db_name
								 where p.sk_measure = {sk_measure} 
								   and p.dk_active = 1 '''
								   
			cur_sql_2 = '''select      p.sk_measure,
									   --p.srcsys,
									   '{in_srcsys}' as srcsys,
									   p.data_set,
									   p.measure_name,
									   p.src_sql,
									   p.trg_sql,
									   p.err_val,
									   p.err_type,
									   p.treatment_type,
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
									from ctl_audit_param p
									left join ctl_db_info sdb
									 on p.src_db = sdb.db_name
									left join ctl_db_info tdb
									 on p.trg_db = tdb.db_name
									where p.data_set = '{in_data_set}' 
									 --and p.srcsys = '{in_srcsys}' 
									 and p.dk_active = 1 '''
									 
			if self.has_sk_measure:
				re_run_sql = re_run_sql_1.format(
					sk_measure=self.argsdict["pi_sk_measure"],
					in_startdate=self.argsdict["pi_startdate"],
					in_enddate=self.argsdict["pi_enddate"],
					in_srcsys=self.argsdict["pi_srcsys"])
				cur_sql = cur_sql_1.format(sk_measure=self.argsdict["pi_sk_measure"], in_srcsys=self.argsdict["pi_srcsys"])
			else:
				re_run_sql = re_run_sql_2.format(
					in_srcsys=self.argsdict["pi_srcsys"],
					in_data_set=self.argsdict["pi_data_set"],
					in_startdate=self.argsdict["pi_startdate"],
					in_enddate=self.argsdict["pi_enddate"])
				cur_sql = cur_sql_2.format(in_data_set=self.argsdict["pi_data_set"], in_srcsys=self.argsdict["pi_srcsys"])
			logger.info("execute sql:%s" % re_run_sql)
			self.sm.execute(re_run_sql)
			self.con.commit()
			logger.info("execute sql:%s" % cur_sql)
			self.sm.execute(cur_sql)
			mycursor = self.sm.fetchall()
			cur_data = [line for line in mycursor]
			self.audit_list = []
			#多线程------------------
			self.threadmax = threading.BoundedSemaphore(1) # 最大线程数为8
			# self.lock = threading.Lock()  # 将锁内的代码串行化
			L=[]
			i=0
			for line in cur_data:
				i=i+1
				# 增加信号量，可用信号量减一
				self.threadmax.acquire()
				t=threading.Thread(target=self.thread_audit,args=(line,logger,i))
				t.start()
				L.append(t)
			for l in L:
				l.join()
			#END---------------
			self.sm.close()
			self.con.close()
			if "N" in self.audit_list:
				logger.error("Exit with the error rule!")
				# sys.exit(1)
				os._exit(1)
			else:
				sys.exit(0)
		except Exception:
			exe = traceback.format_exc()
			logger.error(exe)
			# sys.exit(1)
			os._exit(1)

	def thread_audit(self,line,logger,i):
		# self.lock.acquire()# 上锁
		# print 'lock.acquire',i
		# 将游标值里的全局变量替换
		QueryFGL = QueryFromGlobalVal.QueryFromGlobalVal(self.globaldict)
		i = lamb(QueryFGL.query, line)
		sk_measure = i[0]
		srcsys = i[1]
		data_set = i[2]
		measure_name = i[3]
		src_sql = i[4]
		trg_sql = i[5]
		err_val = i[6]
		err_type = i[7]
		treatment_type = i[8]
		rule = i[9]
		SDB_USER = i[10]
		SDB_PASSWD = i[11]
		SDB_HOST = i[12]
		SDB_PORT = i[13]
		SDB_INSTANT = i[14]
		TDB_USER = i[15]
		TDB_PASSWD = i[16]
		TDB_HOST = i[17]
		TDB_PORT = i[18]
		TDB_INSTANT = i[19]
		exec_type = i[20]
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
		print sk_measure
		if src_type == "R":
			src_url = get_ourl(SDB_HOST, SDB_PORT, SDB_INSTANT)
			S_IbpECO = IbpExecsqlCompOrc.IbpExecsqlCompOrc(src_sql, SDB_USER, SDB_PASSWD, src_url)
			s_retvals = S_IbpECO.exe(logger)
		elif exec_type == 1:
			# Modified By LuoGong@20200715:添加入参
			# S_IbpEC = IbpExecsqlComp.IbpExecsqlComp(src_sql, self.h_node, self.protocoltype, self.hiveusername, self.hivepassword)
			# Modified By 20211108: hive连接地址使用ctl_db_info里面配置的ip地址，为了兼容稽核不同集群之间的稽核。
			S_IbpEC = IbpExecsqlComp.IbpExecsqlComp(src_sql, SDB_HOST, self.protocoltype, self.hiveusername, SDB_PASSWD)
			s_retvals = S_IbpEC.exe(logger)
		else:
			# Modified By LuoGong@20200720:支持impala
			# S_IbpEC = IbpExecsqlComp.IbpExecsqlCompImpala(src_sql, self.protocoltype, self.impala_deamon, self.hiveusername, self.hivepassword)
			# Modified By 20211108: hive连接地址使用ctl_db_info里面配置的ip地址，为了兼容稽核不同集群之间的稽核。
			S_IbpEC = IbpExecsqlComp.IbpExecsqlCompImpala(src_sql, self.protocoltype, SDB_HOST, self.hiveusername, SDB_PASSWD)
			s_retvals = S_IbpEC.exe(logger)
		# 解析目标稽核指标
		logger.info("Exec trg_sql:{}".format(trg_sql))
		if trg_type == "R":  #oracle
			trg_url = get_ourl(TDB_HOST, TDB_PORT, TDB_INSTANT)
			T_IbpECO = IbpExecsqlCompOrc.IbpExecsqlCompOrc(trg_sql, TDB_USER, TDB_PASSWD, trg_url)
			t_retvals = T_IbpECO.exe(logger)
		elif trg_type == 'S':  
			# Modified By Diaozhecheng@20240412:支持下游为starrocks
			T_IbpEC = IbpExecsqlComp.IbpExecsqlCompStarrocks(trg_sql, TDB_HOST, TDB_PORT, self.protocoltype, TDB_USER, TDB_PASSWD)
			t_retvals = T_IbpEC.exe(logger)
		elif exec_type == 1:
			# Modified By LuoGong@20200715:添加入参
			# T_IbpEC = IbpExecsqlComp.IbpExecsqlComp(trg_sql, self.h_node, self.protocoltype, self.hiveusername, self.hivepassword)
			# Modified By 20211108: hive连接地址使用ctl_db_info里面配置的ip地址，为了兼容稽核不同集群之间的稽核。
			T_IbpEC = IbpExecsqlComp.IbpExecsqlComp(trg_sql, TDB_HOST, self.protocoltype, self.hiveusername, TDB_PASSWD)
			t_retvals = T_IbpEC.exe(logger)
		else:  #impala
			# Modified By LuoGong@20200720:支持impala
			# T_IbpEC = IbpExecsqlComp.IbpExecsqlCompImpala(trg_sql, self.protocoltype, self.impala_deamon, self.hiveusername, self.hivepassword)
			# Modified By 20211108: hive连接地址使用ctl_db_info里面配置的ip地址，为了兼容稽核不同集群之间的稽核。
			T_IbpEC = IbpExecsqlComp.IbpExecsqlCompImpala(trg_sql, self.protocoltype, TDB_HOST, self.hiveusername, TDB_PASSWD)
			t_retvals = T_IbpEC.exe(logger)
		# 如果源和目标稽核都执行成功则写入结果
		IspChk = IspChkauditresult.IspChkauditresult(s_retvals, t_retvals, err_val, err_type)
		dk_audit_pass = IspChk.exe(logger)
		self.audit_list.append(dk_audit_pass)
		r_sql = '''insert into ctl_audit_result
									  (startdate,
									   enddate,
									   srcsys,
									   batchno,
									   measure_name,
									   sk_measure,
									   src_result,
									   trg_result,
									   src_sql,
									   trg_sql,
									   inserttime,
									   updatetime,
									   err_val,
									   err_type,
									   dk_audit_pass,
									   data_set)
									VALUES
									  ({startdate},
									   {enddate},
									   '{srcsys}',
									   {batchno},
									   '{measure_name}',
									   {sk_measure},
									   '{src_result}',
									   '{trg_result}',
									   '{src_sql}',
									   '{trg_sql}',
									   sysdate,
									   sysdate,
									   {err_val},
									   {err_type},
									   '{dk_audit_pass}',
									   '{data_set}')
									'''
		src_sql = src_sql.replace("'", "''")
		trg_sql = trg_sql.replace("'", "''")
		src_result = ",".join([str(val) for val in s_retvals])
		trg_result = ",".join([str(val) for val in t_retvals])
		r_sql = r_sql.format(startdate=self.argsdict["pi_startdate"], enddate=self.argsdict["pi_enddate"],
							 srcsys=srcsys, batchno=self.argsdict["pi_batchno"], measure_name=measure_name,
							 sk_measure=sk_measure, src_result=src_result, trg_result=trg_result, src_sql=src_sql,
							 trg_sql=trg_sql, err_val=err_val, err_type=err_type, dk_audit_pass=dk_audit_pass,
							 data_set=data_set)
		logger.info("Record into result:%s" % r_sql)
		try:
			self.sm.execute(r_sql)
			self.con.commit() 
		except Exception:
			exe = traceback.format_exc()
			logger.error(exe)
			os._exit(1)  # Modified By LuoGong@20200720:捕获 ORA
		#if treatment_type.lower() == "error" and self.audit_list[0] == "N":
		#	logger.error("Exit with the error rule!")
		#	sys.exit(1)
		#else:
		#	sys.exit(0)
		# print 'lock.release', i
		# self.lock.release() # 解锁
		self.threadmax.release() # 释放信号量
