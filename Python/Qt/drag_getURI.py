"""
an example for a drag and drop action.
drag a file into the form and get the URI
"""

from PyQt4.QtGui import *
import sys

class DropLabel(QLabel):
	def __init__(self,parent=None):
		QWidget.__init__(self,parent)
		self.setAcceptDrops(True)
		self.setText( "Drop Files or Urls Here" )
		#self.resize(self.sizeHint())
		self.resize(250, 150)
		
		
	def dragEnterEvent(self,event):
		if event.mimeData().hasUrls():
			event.acceptProposedAction()

	def dropEvent(self,event):
		self.setText('\n'.join([str(url.toString()) for url in event.mimeData().urls()]))
		# self.resize(self.sizeHint())

app = QApplication(sys.argv)

w = DropLabel()
w.show()

app.exec_()