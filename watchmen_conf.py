import jinja
import csv
import sys
reload(sys)
sys.setdefaultencoding('utf-8')
env= jinja.Environment()
env.loader= jinja.FileSystemLoader("./")
template= env.get_template( "watchmen_conf" )

#rdr= csv.reader( open(sys.argv[1], "r" ) )
rdr= csv.reader( open(sys.argv[1], "r"), delimiter='#' )
csv_data = [ row for row in rdr ]

output =  template.render( data=csv_data )

with open ('watchmen_conf.js', 'w') as f:
	f.write(output)
