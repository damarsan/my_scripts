import urllib2
import re
import sys
import dns.resolver
import socket
import requests
from urlparse import urlparse

ins_domains = open( sys.argv[1], "r" )
out = open("result_" + sys.argv[1], "w" )
error = open("result_errors", "w")
host =""
for line in ins_domains:
	redir = ''	
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
		# STRIP TO REMOVE BLANK SPACES
		r = requests.get('http://' + line.strip(), allow_redirects=False)
		# GET HTTP REDIR STATUS
		code = r.status_code
		# GET URL REDIRECTION
		getredir = content2.geturl()
		getredir = getredir.split('/')

		if len(getredir) == 4:
			redir = getredir[3]
		# GET TITLE PAGE
		host = urlparse(content2.geturl()).netloc
		allTitles =  re.compile('<title>(.*?)</title>')
		title = re.findall(allTitles,content)
		content2.close()
	except Exception as x:
		print host,x
		continue
	try:
		out.write("%s,%s,%s,%s,%s\n" % (host,res2[0],title[0],code,"/"+redir))
	except Exception as y:
		out.write("%s,%s\n" % (host,y))

ins_domains.close()
