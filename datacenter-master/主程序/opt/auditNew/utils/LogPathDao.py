#!/usr/bin/env python
# -*- coding:utf-8 -*-
import datetime
import os
import sys
import traceback

class LogPathDao():

	def __init__(self,tablename):
		self.tablename = tablename

	def getpath(self):
		try:
			# 获取日志路径，和日志的配置文件路径
			logname = self.tablename + ".log"
			parentdir = os.path.abspath(sys.path[0] + os.path.sep + "..")
			rootdir = os.path.abspath(parentdir + os.path.sep + "..")
			logconf = os.path.join(rootdir, 'config/logging.conf')
			now = datetime.datetime.now()
			currentdate = datetime.datetime.strftime(now, "%Y%m%d")
			log_date_path = parentdir + "/log/" + currentdate
			if not os.path.exists(log_date_path):
				os.makedirs(log_date_path)
			logpath = log_date_path + "/" + logname
			return logconf, logpath
		except Exception:
			exe = traceback.format_exc()
			print exe
			sys.exit(1)
