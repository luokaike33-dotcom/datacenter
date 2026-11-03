#!/usr/bin/env python 
# -*- coding:utf-8 -*-
import sys
import traceback
from decimal import Decimal


'''
与稽核基准值对比完成稽核
'''


class IspChkauditresult:

	def __init__(self, s_retvals, t_retvals, err_val, err_type):
		self.s_retvals = s_retvals
		self.t_retvals = t_retvals
		self.err_val = err_val
		self.err_type = err_type

	def exe(self, logger):
		try:
			if len(self.s_retvals) != len(self.t_retvals):
				logger.error("Source numbers <> Target numbers!")
				raise Exception
			else:
				vals = []
				dk_audit_list = []
				for idx in range(len(self.s_retvals)):
					#vals.append((Decimal(self.s_retvals[idx]), Decimal(self.t_retvals[idx])))
					#print type(self.s_retvals[idx]),type(self.t_retvals[idx])
					if type(self.s_retvals[idx]) == type(Decimal('1')):#modify the HH audit 
						vals.append((float(self.s_retvals[idx]),float(self.t_retvals[idx])))
					else:
						vals.append((self.s_retvals[idx],float(self.t_retvals[idx])))
				for val in vals:
					s_retval = val[0]
					t_retval = val[1]
					# 计算稽核指标与基准指标之间的偏差
					vn_biasval = s_retval - t_retval
                                   
					# 偏差类型（0 - 绝对值，1 - 百分比）
					if str(self.err_type) == '0':
						if abs(vn_biasval) > self.err_val:#Decimal
							dk_audit = "N"
						else:
							dk_audit = "Y"
					else:
						if abs(vn_biasval) / s_retval >self.err_val:#Decimal
							dk_audit = "N"
						else:
							dk_audit = "Y"
					logger.info("Source val:{s_retval}; Target val:{t_retval}".format(s_retval=s_retval,
																					  t_retval=t_retval))
					dk_audit_list.append(dk_audit)
				if "N" in dk_audit_list:
					dk_audit_pass = "N"
					logger.error("This audit-rule is not passed!")
				else:
					dk_audit_pass = "Y"
					logger.info("This audit-rule is passed")
			return dk_audit_pass
		except Exception:
			exe = traceback.format_exc()
			logger.error(exe)
			sys.exit(1)
