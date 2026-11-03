#!/usr/bin/env python
# -*- coding:utf-8 -*-
import sys
import traceback
import argparse
from decimal import Decimal

class ArgvParser:

	def __init__(self, _):
		self._ = _

	def parse(self, argv_type):
		try:
			typedict = {"string": str, "int": int, "decimal": Decimal}
			parser = argparse.ArgumentParser(description='manual to this script')
			parser.add_argument('--pi_startdate', type=int, required=True, default=None)  # 设定参数：startdate
			parser.add_argument('--pi_enddate', type=int, required=True, default=None)  # 设定参数：enddate
			parser.add_argument('--pi_batchno', type=int, required=True, default=None)  # 设定参数：batchno
			params = ["pi_startdate", "pi_enddate", "pi_batchno"]
			for param, parmtype in argv_type.items():
				if param not in params:
					arg = "--" + param
					arg_type = parmtype.lower()
					parser.add_argument(arg, type=typedict[arg_type], default=None)
			args = parser.parse_args()
			# 记录传参名和传参值的字典
			argsdict = args.__dict__
			return argsdict
		except Exception:
			exe = traceback.format_exc()
			print exe
			sys.exit(1)
