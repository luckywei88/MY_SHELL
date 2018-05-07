#!/usr/bin/python
'''by zevolo, 2012.12.20
'''
import rospy
from sensor_msgs.msg import Image
from std_msgs.msg import String
from cv_bridge import CvBridge, CvBridgeError
from PIL import Image as im
import matplotlib.pyplot as plt

import time
import cv2
import gtk.gdk
import gtk
import glib
import numpy as np

class MyRect():
  def __init__(self, x = 0, y = 0, w = 0, h = 0):
    self.x = x
    self.y = y
    self.w = w
    self.h = h
  def __init__(self, x, y):
    self.x = min(int(x.x), int(y.x))
    self.y = min(int(x.y), int(y.y))
    self.w = abs(int(y.x - x.x))
    self.h = abs(int(y.y - x.y))

class MyPair():
  def __init__(self, x = 0, y = 0):
    self.x = x
    self.y = y

class MyPoint(MyPair):
  def __init__(self, x = 0, y = 0):
    MyPair.__init__(self, x, y)

class MySize(MyPair):
  def __init__(self, w = 0, h = 0):
    MyPair.__init__(self, x, y)

class MyCapture():
  (event_enter, event_leave) = (0, 1)
  def __init__(self):
    pass
  def capture(self):
    pass
  def handleEvent(self, event):
    if event == event_enter:
      enterSnap()
    elif event == event_leave:
      leaveSnap()
  def enterSnap(self):
    pass
  def leaveSnap(self):
    pass
  def snap(self, window = None, rect = None, name = None):
    pass

class MyCaptureGtk(MyCapture):
  def __init__(self):
    MyCapture.__init__(self)
    rospy.init_node("send_image",anonymous=True)
    self.window = gtk.Window()
    self.window.set_default_size(1,1)
    self.window.connect("button-press-event", self.button_press_cb)
    self.first = None
    self.second = None
    self.im = None
    self.pub=rospy.Publisher("trajectory",Image,queue_size=1)
    self.rate=rospy.Rate(10)
    self.bridge=CvBridge()
    self.window.show()
    #self.window.set_events(gtk.gdk.BUTTON_PRESS_MASK)
  def getWindow(self):
    return self.window
  def button_press_cb(self, widget, event):
    #print "type is %d" % event.type
    if event.type == gtk.gdk.BUTTON_PRESS:
      if event.button == 1: #left button
        print "(%d, %d), (%d, %d), button is %d" % (event.x_root, event.y_root, event.x, event.y, event.button)
        if not self.first:
          self.first = MyPoint(event.x_root, event.y_root)
        else:
          self.second = MyPoint(event.x_root, event.y_root)
      elif event.button == 3: #right button
        self.uncapture()
      else:
        pass

  def sender(self):
    while not rospy.is_shutdown():
      buf=self.snap(None, MyRect(self.first, self.second))
      if buf is not None:
        self.pub.publish(self.bridge.cv2_to_imgmsg(buf,"bgr8")) 
      else:
	pass
      time.sleep(0.04)
    gtk.mainquit()
  
  def uncapture(self):
    if self.first is not None and self.second is None:
      print "cancel"
      self.first = None
    else:
      gtk.gdk.pointer_ungrab()
      try:
	self.sender()
      except rospy.ROSInterruptException:
	pass
      self.first = None
      #gtk.mainquit()

  def capture(self, time = 0L):
    cursor = gtk.gdk.Cursor(gtk.gdk.display_get_default(), gtk.gdk.CROSSHAIR)
    ret = gtk.gdk.pointer_grab(self.window.window, True,
          gtk.gdk.BUTTON_PRESS_MASK,
          None, cursor, time)
    if ret == gtk.gdk.GRAB_SUCCESS:
      print "left button start, end, right button cancel/exit"
    else:
      print "failed to capture %d, (viewable %d),(frozen %d), (already %d)" \
       % (ret, gtk.gdk.GRAB_NOT_VIEWABLE, gtk.gdk.GRAB_FROZEN, gtk.gdk.GRAB_ALREADY_GRABBED)

  def snap(self, window = None, rect = None, name = None):
    w = window
    if not window:
      d = gtk.gdk.display_get_default()
      w = d.get_default_screen().get_root_window()
    r = rect
    if not r:
      sz = w.get_size()
      r = MyRect(0, 0, sz[0], sz[1])
    n = name
    if not n:
      n = "screenshot.png"
    buf = gtk.gdk.Pixbuf(gtk.gdk.COLORSPACE_RGB,False,8, r.w, r.h)
    buf = buf.get_from_drawable(w,w.get_colormap(), r.x, r.y, 0, 0, r.w, r.h)
    if buf :
      buf.save(n,"png") 
      return cv2.imread("screenshot.png")
    else:
      return None

def timeout(data):
  data.capture()

if __name__ == '__main__':
  cap = MyCaptureGtk()
  w = cap.getWindow()
  glib.timeout_add_seconds(1, timeout, cap)
  gtk.main()
