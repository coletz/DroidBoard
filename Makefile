TARGET = iphone:11.2:12.4
ARCHS = arm64

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DroidBoard

DroidBoard_FILES = Tweak.xm
DroidBoard_CFLAGS = -fobjc-arc
DroidBoard_LIBRARIES = applist
DroidBoard_PRIVATE_FRAMEWORKS = GraphicsServices

include $(THEOS_MAKE_PATH)/tweak.mk
