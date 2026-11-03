#!/usr/bin/env python 
# -*- coding:utf-8 -*-
import traceback
import sys

class QueryFromGlobalVal():

	def __init__(self, globaldict):
		self.globaldict = globaldict

	def query(self, prequery):
		try:
			querystr = prequery
			for key, value in self.globaldict.items():
				key_f = "$${" + key + "}"
				querystr = querystr.replace(key_f, str(value))
			return querystr
		except Exception:
			exe = traceback.format_exc()
			print exe
			sys.exit(1)
