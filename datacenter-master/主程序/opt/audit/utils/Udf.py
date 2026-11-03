#!/usr/bin/env python 
# -*- coding:utf-8 -*-
import sys
import os
import traceback


class Udf:

	def __init__(self, logger):
		self.logger = logger

	def main(self):
		try:
			parentpath = os.path.abspath(sys.path[0] + os.path.sep + "..")
			udfpath = os.path.abspath(parentpath + os.path.sep + "../udf") + "/udf.sql"
			with open(udfpath) as openfile:
				lines = openfile.readlines()
			new_lines = [line for line in lines if line.strip() != "" and line[0:2] != "--"]
			new_string = " ".join(new_lines)
			sql_list = [sql for sql in new_string.split(";") if sql.strip() != ""]
			return sql_list
		except Exception:
			exe = traceback.format_exc()
			self.logger.error(exe)
			sys.exit(1)
