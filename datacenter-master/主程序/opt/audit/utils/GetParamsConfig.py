#!/usr/bin/env python
# -*- coding:utf-8 -*-
import cx_Oracle
import sys
import traceback


def oracle_con(user, password, url, url2):
	try:
		con = cx_Oracle.connect(user, password, url)
		return con
	except cx_Oracle.DatabaseError:
		con = cx_Oracle.connect(user, password, url2)
		return con


class GetParamsConfig:

	def __init__(self, user, password, url, url2):
		self.user = user
		self.password = password
		self.url = url
		self.url2 = url2

	def getconfig(self):
		try:
			con = oracle_con(self.user, self.password, self.url, self.url2)
			sql = "select params_name, params_type, isglobal, params_value from ctl_params_config"
			cur = con.cursor()
			cur.execute(sql)
			data = cur.fetchall()
			argv_type = {}
			globaldict = {}
			if data:
				for line in data:
					if line[2] == "N":
						argv_type[line[0]] = line[1]
					else:
						globaldict[line[0]] = line[3]
			else:
				print "ctl_params_config is null!"
			cur.close()
			con.close()
			return argv_type, globaldict
		except Exception:
			exe = traceback.format_exc()
			print exe
			sys.exit(1)
