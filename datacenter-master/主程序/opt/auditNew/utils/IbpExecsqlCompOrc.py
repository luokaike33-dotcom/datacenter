#!/usr/bin/env python 
# -*- coding:utf-8 -*-
import sys
import traceback
import cx_Oracle
import os
import decimal

'''
在Oracle上执行SQL语句计算稽核指标
'''


def nvlx(x,y):
	if x is None:
		return y
	else:
		return x

def oraclcon(user, password, url, url2):
	try:
		con = cx_Oracle.connect(user, password, url)
		return con
	except cx_Oracle.DatabaseError:
		con = cx_Oracle.connect(user, password, url2)
		return con


class IbpExecsqlCompOrc:

	def __init__(self, o_sql, user, password, url):
		self.o_sql = o_sql
		self.user = user
		self.password = password
		self.url = url

	def exe(self, logger):
		try:
			con = cx_Oracle.connect(self.user, self.password, self.url)
			sm = con.cursor()
			sm.execute(self.o_sql)
			data = sm.fetchall()
           		vn_retvals=[]
            		for vals in data:
                	    re_tmp=[]
               		    for val in vals:
                    		#re_tmp.append(repr(nvlx(val, 0)))
                                if isinstance(nvlx(val, 'null'),str): re_tmp.append(nvlx(val, 'null'))   
                                elif isinstance(val,decimal.Decimal) : re_tmp.append(repr(float(nvlx(val, 'null'))))
                                else: re_tmp.append(repr(nvlx(val, 0)))
                	    p = len(re_tmp)
                	    if p <20:
                		re_tmp.extend(['null']*(20-p))
                            if p>20:
                   		re_tmp=re_tmp[0:20]
			    vn_retvals.append(re_tmp)
            		print vn_retvals
			sm.close()
			con.close()
			logger.info("The oracle's result :%s" % vn_retvals)
			return vn_retvals
		except cx_Oracle.DatabaseError:
			# except cx_Oracle.DatabaseError:
			exe = traceback.format_exc()
			logger.error(exe)
			# sys.exit(1)
			os._exit(1)
