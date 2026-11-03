#!/usr/bin/env python 
# -*- coding:utf-8 -*-
import sys
import os
os.environ['NLS_LANG'] = 'SIMPLIFIED CHINESE_CHINA.UTF8'
sys.path.append(os.path.abspath(sys.path[0]) + os.path.sep + "../utils")
import logging.config
import LogPathDao
import GetParamsConfig
import ArgvParser
import GetConfig
import GetHiveConfig
import IspCompauditind


class Audit:

	def __init__(self, logger):
		self.logger = logger

	def run(self):
		  # 获取配置文件配置信息
		  GetC = GetConfig.GetConfig(1)
		  username, password, url, url2, hiveconfigdir, h_user, hiveusername, hivepassword, impala_deamon, protocoltype, \
        	  principal = GetC.config()
		  # 返回参数字典
		  GetParamsC = GetParamsConfig.GetParamsConfig(username, password, url, url2)
		  argv_type, globaldict = GetParamsC.getconfig()
		  # 构建传递参数
		  ArgP = ArgvParser.ArgvParser(1)
		  argsdict = ArgP.parse(argv_type)
		  # 将startdate,enddate,batchno计入参数与类型字典
		  argv_type["pi_startdate"] = "int"
		  argv_type["pi_enddate"] = "int"
		  argv_type["pi_batchno"] = "int"
		  # 获取hive数据节点
		  ReadHC = GetHiveConfig.GetHiveConfig(hiveconfigdir)
		  h_node = ReadHC.hivedatanode()
		  # 执行指标计算, 指标稽核
		  IspCom = IspCompauditind.IspCompauditind(argsdict, argv_type, globaldict, username,password, url, url2, h_node, h_user,
												   protocoltype, impala_deamon, hiveusername, hivepassword)
		  IspCom.exe(self.logger)

if __name__ == '__main__':
	# 获取logging模块的logger
	LogDao = LogPathDao.LogPathDao("Audit")
	logconf, logpath = LogDao.getpath()
	logging.config.fileConfig(logconf, defaults={'logdir': logpath})
	logger = logging.getLogger('hivelog')
	Aud = Audit(logger)
	Aud.run()
