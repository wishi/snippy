import sys
import paramiko # for ssh
import os  
from PyQt4 import QtGui, QtCore
from mainwindow import Ui_MainWindow

class gui_does(QtGui.QMainWindow):
   def __init__(self):
      QtGui.QMainWindow.__init__(self)
      self.ui = Ui_MainWindow()
      self.ui.setupUi(self)

	   self.setWindowTitle('To-SSH Droplet')
	   # to accept drops
      self.setAcceptDrops(True) 
	   self.ui.lineEdit.setText("/home/wishi/")
	   self.statusBar().showMessage('Ready')
	        	
   def dragEnterEvent(self, event):
	   if event.mimeData().hasUrls():
	      event.acceptProposedAction()
    
    """ the initial drop action is scp """
   def dropEvent(self, event):
	   filelist = ('\r\n'.join([str(url.toString()) for url in event.mimeData().urls()]))
	   self.ui.textEdit.setText(filelist)
	   splitted_filelist = filelist.split("\r\n")
	   destination_path = self.ui.lineEdit.text()
	
	   #privatekeyfile = os.path.expanduser('~/.ssh/id_rsa')
	   #mykey = paramiko.RSAKey.from_private_key_file(privatekeyfile)
	   username = 'wishi'
	   password = 'bmljZSB0cnkgaWRpb3Q='
	   host = 'crazylazy.info'
	   port = 22
	   error = False
	
	try:
	   self.statusBar().showMessage("Uploading")
	   ssh = paramiko.SSHClient()
	   ssh.load_system_host_keys()
	   ssh.connect(host, username = username, password = password)
	   sftp = ssh.open_sftp()
			    
	   for file in splitted_filelist:
		   file = file[7:]
		   patharray = file.split("/")
		   destination_path = destination_path + patharray[len(patharray)-1]
		   sftp.put(file, str(destination_path))
	    
	   sftp.close()
	   ssh.close()
	    
	except:
	   error = True
	
	if (error):    
	   self.statusBar().showMessage("Error")
	else:
	   self.statusBar().showMessage("Ready")
    
if __name__=="__main__":
   app = QtGui.QApplication(sys.argv)
   window = gui_does()
   window.show()
   sys.exit(app.exec_())
    




