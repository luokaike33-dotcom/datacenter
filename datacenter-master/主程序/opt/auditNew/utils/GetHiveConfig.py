#!/usr/bin/env python 
# -*- coding:utf-8 -*-
import xml.etree.ElementTree as ElementTree
import re
import traceback
import  sys


class GetHiveConfig:

	def __init__(self,hiveconfigdir):
		self.hiveSiteConfigFile = hiveconfigdir + "/hive-site.xml"

	def hivedatanode(self):
		try:
			tree = ElementTree.parse(self.hiveSiteConfigFile)
			root = tree.getroot()
			for child in root:
				if "hive.metastore.uris" in child.find("name").text:
					uris = child.find("value").text
					datanode = re.findall(r"//(.*?):",uris)[0]
					return datanode
		except Exception:
			exe = traceback.format_exc()  # 返回异常
			print exe
			sys.exit(1)

