# Script to create a password for the Jupyter notebook configuration
# under the MIT licence by Romilly Cocking https://github.com/romilly/nano 


import sys

from notebook.auth import passwd
import os

jupyter_config = os.path.expanduser('~/.jupyter/jupyter_notebook_config.py')

if len(sys.argv) != 2:
    print('usage: python3 set_jupyter_password <password>')
    sys.exit(-1)
pwhash = passwd(sys.argv[1])

jupyter_comment_start = "# Start of lines added by jupyter-password.py"
jupyter_comment_end = "# End of lines added by jupyter-password.py"
jupyter_passwd_line = "c.NotebookApp.password = '%s'" % (pwhash)

with open(jupyter_config, 'a') as file:
    file.write('\n')
    file.write(jupyter_comment_start + '\n')
    file.write(jupyter_passwd_line + '\n')
    file.write(jupyter_comment_end + '\n')
