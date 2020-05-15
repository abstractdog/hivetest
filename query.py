import os
import time
import logging
import sys
import subprocess
import ConfigParser
from subprocess import check_output, CalledProcessError

query_file = sys.argv[1]
settings_file = sys.argv[2]

config = ConfigParser.ConfigParser()
config.readfp(open('config.properties'))
config=dict(config.items(config.sections()[0]))
beeline_cmd=config["beeline_cmd"].replace("#database#", config["database"])

cmd = "{0} -i {1} -f {2}".format(beeline_cmd, settings_file, query_file)

process = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

sys.stdout.write ("running query from file: {}\n".format(query_file))
# Poll process for new output until finished
with open('output', 'w+') as writer:
	writer.write("### cmd ###\n" + cmd + "\n")

	while True:
			nextline = process.stdout.readline()
			if nextline == '' and process.poll() is not None:
				break

			writer.write(nextline)
			sys.stdout.write(nextline)
			writer.flush()

