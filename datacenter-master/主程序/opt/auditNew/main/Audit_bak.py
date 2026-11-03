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
                  print 'step 6.1'
		  username, password, url, url2, hiveconfigdir, h_user, hiveusername, hivepassword, impala_deamon, protocoltype, \
        	  principal = GetC.config()
                  print GetC.config()
		  # 返回参数字典
                  print 'step 6.2'
		  GetParamsC = GetParamsConfig.GetParamsConfig(username, password, url, url2)
		  print 'step 6.3'
                  argv_type, globaldict = GetParamsC.getconfig()
		  # 构建传递参数
                  print 'step 6.4'
		  ArgP = ArgvParser.ArgvParser(1)
		  print 'step 6.5'
                  argsdict = ArgP.parse(argv_type)
		  # 将startdate,enddate,batchno计入参数与类型字典
		  #yeyongjian
          #argv_type["pi_startdate"] = "int"
		  #argv_type["pi_enddate"] = "int"
		  #argv_type["pi_batchno"] = "int"
          #yeyongjian
		  # 获取hive数据节点
		  ReadHC = GetHiveConfig.GetHiveConfig(hiveconfigdir)
		  h_node = ReadHC.hivedatanode()
		  # 执行指标计算, 指标稽核
                  print 'step 6.6'
		  IspCom = IspCompauditind.IspCompauditind(argsdict, argv_type, globaldict, username,password, url, url2, h_node, h_user,
												   protocoltype, impala_deamon, hiveusername, hivepassword)
                  print 'step 6.7'
                  print argsdict, argv_type, globaldict, username,password, url, url2, h_node, h_user,protocoltype, impala_deamon, hiveusername, hivepassword
		  IspCom.exe(self.logger)

if __name__ == '__main__':
	# 获取logging模块的logger
	LogDao = LogPathDao.LogPathDao("AuditNew")
	print '------------------step 1------------------'
        logconf, logpath = LogDao.getpath()
        print '------------------step 2------------------'
	logging.config.fileConfig(logconf, defaults={'logdir': logpath})
        print '------------------step 3------------------'
	logger = logging.getLogger('hivelog')
        print '------------------step 4------------------'
	Aud = Audit(logger)
        print '------------------step 5------------------'
	Aud.run()
