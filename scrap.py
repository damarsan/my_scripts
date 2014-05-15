import urllib2
import re
import sys
import dns.resolver
import socket
from urlparse import urlparse

ins_domains = open( sys.argv[1], "r" )
out = open("result_" + sys.argv[1], "w" )
error = open("result_errors", "w")
host =""
for line in ins_domains:
	
	try:
		# GET HOSTNAME 
        	res = socket.gethostbyname(line.strip("\n"))
        	res2 = socket.gethostbyaddr(res)
	except Exception as a:
		res=[]
		continue


	try:
		#GET TITLE PAGE
		content = urllib2.urlopen('http://'+line).read()
		content2 = urllib2.urlopen('http://'+line)
		code = content2.getcode()
		host = urlparse(content2.geturl()).netloc
		allTitles =  re.compile('<title>(.*?)</title>')
		title = re.findall(allTitles,content)
		content2.close()
	except Exception as x:
		print host,x
		continue
	try:
		out.write("%s,%s,%s,%s\n" % (host,res2[0],title[0],code))
	except Exception as y:
		out.write("%s,%s\n" % (host,y))

ins_domains.close()
