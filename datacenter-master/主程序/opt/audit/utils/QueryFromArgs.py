#!/usr/bin/env python 
# -*- coding:utf-8 -*-
import traceback
import sys

class QueryFromArgs():

	def __init__(self, argsdict, argv_type):
		self.argsdict = argsdict
		self.argv_type = argv_type

	def query(self, prequery):
		try:
			querystr = prequery
			for key, value in self.argsdict.items():
				key_f = "${" + key + "}"
				if self.argv_type[key].strip().lower() == "str":
					value_f = "'" + str(value) + "'"
				else:
					value_f = str(value)
				querystr = querystr.replace(key_f, value_f)
			return querystr
		except Exception:
			exe = traceback.format_exc()
			print exe
			sys.exit(1)
