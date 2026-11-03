#!/usr/bin/env python 
# -*- coding:utf-8 -*-
import os
import sys
import traceback
import ConfigParser
import base64

# base64 解密
#def b64_decode(password):
#	return base64.b64decode(password)
	
	

class GetConfig:

	def __init__(self, _):
		self._ = _
	def config(self):
		# 获取配置文件配置信息
		try:
			config = ConfigParser.ConfigParser()
			parentdir = os.path.abspath(sys.path[0] + os.path.sep + "..")
			rootpath = os.path.abspath(parentdir + os.path.sep + "..")
			confpath = rootpath + "/config/config.ini"
                        print confpath
			with open(confpath, 'r') as openfile:
				config.readfp(openfile)
				username = config.get("oraclecon", "username")
				password = config.get("oraclecon", "password")
				#password = b64_decode(password_b64)
				url = config.get("oraclecon", "url")
				hiveconfigdir = config.get("configpath", "hiveconfigdir")
				h_user = config.get("hives2", "username")
				if config.has_option("oraclecon", "url2"):
					url2 = config.get("oraclecon", "url2")
				else:
					url2 = None
				# Modified By LuoGong@20200715:增加读取配置文件参数
				hiveusername = config.get("hives2", "username")
				# hivepassword = config.get("hives2", "password")
				hivepassword = config.get("hives2", "password")
				#hivepassword = b64_decode(hivepassword_b64)
				impala_deamon = config.get("impala_deamon","impala_ip")
				protocoltype = config.get("protocol","protocoltype")
				principal = config.get("protocol","principal")
			return username, password, url, url2, hiveconfigdir, h_user, hiveusername, hivepassword, impala_deamon, protocoltype, principal
		except Exception:
			exe = traceback.format_exc()
			print exe
			sys.exit(1)
