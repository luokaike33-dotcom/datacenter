#!/usr/bin/env python 
# -*- coding:utf-8 -*-
import sys
import traceback
from impala.dbapi import connect
import MySQLdb
import Udf
import os


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
			#	# logger.debug(sql)
			#	hcur.execute(sql)
			sqls = self.h_sql.split(";")
			for sql in sqls:
				if sql.strip() != "":
					# logger.debug(sql)
					hcur.execute(sql)
			rs = hcur.fetchall()
			vn_retvals = [nvlx(val, 0) for val in rs[0]]
			logger.info("The hive's results :%s" % vn_retvals)
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
                             # hconn = connect(host=self.impala_deamon[0:self.impala_deamon.rfind(':'):], port=25003, database="DEFAULT", auth_mechanism="PLAIN", user="etl_az", password=password) # LDAP
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
			vn_retvals = [nvlx(val, 0) for val in rs[0]]
			logger.info("The hive's results :%s" % vn_retvals)
			return vn_retvals

		except Exception:
			exe = traceback.format_exc()
			logger.error(exe)
			os._exit(1)
      
# Modified By DiaoZheCheng@20240410:增加连接Starrocks数据库
class IbpExecsqlCompStarrocks:

    def __init__(self, h_sql, xcsrurl, port, protocoltype, xcsrusername, xcsrpassword):
        self.h_sql = h_sql
        self.protocoltype = protocoltype
        self.xcsrurl = xcsrurl
        self.port = port
        self.xcsrusername = xcsrusername
        self.xcsrpassword = xcsrpassword

    def exe(self, logger):
        try:
            if self.protocoltype == '1':
                hconn = MySQLdb.connect(host=self.xcsrurl, port=self.port, db="data_mart")
            elif self.protocoltype == '2':
                hconn = MySQLdb.connect(host=self.xcsrurl,user=self.xcsrusername,passwd=self.xcsrpassword,db='data_mart',port=self.port)
            hcur = hconn.cursor()
            sqls = self.h_sql.split(";")
            for sql in sqls:
                if sql.strip() != "":
                    # logger.debug(sql)
                    hcur.execute(sql)
            rs = hcur.fetchall()
            vn_retvals = [nvlx(val, 0) for val in rs[0]]
            logger.info("The StarRocks's results :%s" % vn_retvals)
            return vn_retvals

        except Exception:
            exe = traceback.format_exc()
            logger.error(exe)
            os._exit(1)