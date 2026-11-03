#!/usr/bin/env python 
# -*- coding:utf-8 -*-
import sys
import traceback
from impala.dbapi import connect
import Udf
import os
import decimal

'''
在hive上执行SQL语句计算稽核指标
'''


def nvlx(x,y):
	if x is None:
		return y
	else:
		return x


class IbpExecsqlComp:

	def __init__(self, h_sql, h_node, protocoltype, hiveusername, hivepassword):
		self.h_sql = h_sql
		self.h_node = h_node
		# Modified By LuoGong@20200715:增加配置文件参数
		self.protocoltype = protocoltype
		self.hiveusername = hiveusername
		self.hivepassword = hivepassword

	def exe(self, logger):
		try:
			# Modified By LuoGong@20200715:支持LDAP和Kerberos协议
			# Modified By LuoGong@20200715:支持Impala,两层会导致变量引用失败;connect定义时连接，无法format: user="hive", password="1qaz2wsx", 
			if self.protocoltype == '1':
				hconn = connect(host=self.h_node, port=25005, database="DEFAULT", auth_mechanism="PLAIN") # Normal
			elif self.protocoltype == '2':
				#hconn = connect(host=self.h_node, port=10000, database="DEFAULT", auth_mechanism="PLAIN", user="hive", password="1qaz2wsx") # LDAP
				# Modified 20211108 使用配置表里面的密码
				hconn = connect(host=self.h_node, port=25005, database="DEFAULT", auth_mechanism="PLAIN", user=self.hiveusername, password=self.hivepassword) # LDAP
			elif self.protocoltype == '3':
				hconn = connect(host=self.h_node, port=25005, database="DEFAULT", auth_mechanism="GSSAPI", user=self.hiveusername, password=self.hivepassword,Kerberos_service_name='hive') # Kerberos
			hcur = hconn.cursor()
			# Modified By LuoGong@20200715:使用MR/Hive on spark时才可加载udf.sql
			#Ud = Udf.Udf(logger)
			#sql_list = Ud.main()
			#for sql in sql_list:
				# logger.debug(sql)
			#	hcur.execute(sql)
			sqls = self.h_sql.split(";")
			for sql in sqls:
				if sql.strip() != "":
					# logger.debug(sql)
					hcur.execute(sql)
			rs = hcur.fetchall()
            
                        vn_retvals=[]
                        for vals in rs:
                           re_tmp=[]
                           for val in vals:
                              if isinstance(val,decimal.Decimal):
                                  re_tmp.append(repr(float(nvlx(val, 0))))
                              elif isinstance(val,str):
                                  re_tmp.append(nvlx(val, 0))
                              else:
                                  re_tmp.append(repr(nvlx(val, 0)))
                           p = len(re_tmp)
                           if p <20:
                              re_tmp.extend(['null']*(20-p))
                           if p>20:
                              re_tmp=re_tmp[0:20]
			   vn_retvals.append(re_tmp)
                
			logger.info("The hive's results :%s" % vn_retvals)
                        print vn_retvals
            
			return vn_retvals

		except Exception:
			exe = traceback.format_exc()
			logger.error(exe)
			os._exit(1)


class IbpExecsqlCompImpala:

	def __init__(self, h_sql, protocoltype, impala_deamon, hiveusername, hivepassword):
		self.h_sql = h_sql
		# Modified By LuoGong@20200715:增加配置文件参数
		self.protocoltype = protocoltype
		self.impala_deamon = impala_deamon
		self.hiveusername = hiveusername
		self.hivepassword = hivepassword

	def exe(self, logger):
		try:
			# Modified By LuoGong@20200715:支持LDAP和Kerberos协议
			# Modified By LuoGong@20200715:支持Impala,两层会导致变量引用失败;connect定义时连接，无法format:
			import subprocess
			popen = subprocess.Popen('sh /etl/config/ldap_password_cmd', shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)  #执行hive
			password = popen.stdout.readline()
			if self.protocoltype == '1':
			# hconn = connect(host=self.impala_deamon[0:self.impala_deamon.rfind(':'):], port=25003, database="DEFAULT", auth_mechanism="PLAIN") # Normal 
			# Modified By 20211108: hive连接地址使用ctl_db_info里面配置的ip地址，为了兼容稽核不同集群之间的稽核。
							 hconn = connect(host=self.impala_deamon, port=25003, database="DEFAULT", auth_mechanism="PLAIN") # Normal 

			elif self.protocoltype == '2':
				# hconn = connect(host=self.impala_deamon[0:self.impala_deamon.rfind(':'):], port=25003, database="DEFAULT", auth_mechanism="PLAIN", user=self.hiveusername, password=self.hivepassword) # LDAP
				# Modified By 20211108: hive连接地址使用ctl_db_info里面配置的ip地址，为了兼容稽核不同集群之间的稽核。
				hconn = connect(host=self.impala_deamon, port=25003, database="DEFAULT", auth_mechanism="PLAIN", user=self.hiveusername, password=self.hivepassword) # LDAP
			elif self.protocoltype == '3':
				# hconn = connect(host=self.impala_deamon[0:self.impala_deamon.rfind(':'):], port=25003, database="DEFAULT", auth_mechanism="GSSAPI", user=self.hiveusername, password=self.hivepassword, Kerberos_service_name='impala') # Kerberos
				# Modified By 20211108: hive连接地址使用ctl_db_info里面配置的ip地址，为了兼容稽核不同集群之间的稽核。
							 hconn = connect(host=self.impala_deamon, port=25003, database="DEFAULT", auth_mechanism="GSSAPI", user=self.hiveusername, password=self.hivepassword, Kerberos_service_name='impala') # Kerberos

			hcur = hconn.cursor()
			sqls = self.h_sql.split(";")
			for sql in sqls:
				if sql.strip() !="":
					# logger.debug(sql)
					hcur.execute(sql)
			rs = hcur.fetchall()
            		vn_retvals=[]
            		for vals in rs:
                	   re_tmp=[]
                	   for val in vals:
                    		# re_tmp.append(str(nvlx(val, 0)))
                              if isinstance(val,decimal.Decimal):
                                  re_tmp.append(repr(float(nvlx(val, 0))))
                              elif isinstance(val,str):
                                  re_tmp.append(nvlx(val, 0))
                              else:
                                  re_tmp.append(repr(nvlx(val, 0)))
                           p = len(re_tmp)
                	   if p <20:
                              re_tmp.extend(['null']*(20-p))
                	   if p>20:
                   	      re_tmp=re_tmp[0:20]
			   vn_retvals.append(re_tmp)
                
                        logger.info("The hive's rs results :%s" % rs)
			logger.info("The hive's results :%s" % vn_retvals)
			return vn_retvals

		except Exception:
			exe = traceback.format_exc()
			logger.error(exe)
			os._exit(1)
