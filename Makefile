DEFINES  ?= 
INCLUDES ?= -I./ -I./utils -I./include/vlc2x -I./include
CXXFLAGS ?= -fvisibility=hidden -Wno-multichar -fexceptions  -fpermissive
CFLAGS   ?= -fvisibility=hidden -Wno-multichar
PREFIX   ?= /usr/local
LIBDIR   ?= $(PREFIX)/lib
INCDIR   ?= $(PREFIX)/include

LIBS = -lpthread -lc -ldl


TOOLCHAIN_PATH=/usr/bin



LD=    /Applications/Xcode.app/Contents/Developer/usr/bin/ld
AR=    $(TOOLCHAIN_PATH)/ar
RANLIB=$(TOOLCHAIN_PATH)/ranlib
CC=    $(TOOLCHAIN_PATH)/clang
CXX=   $(TOOLCHAIN_PATH)/clang++
STRIP= $(TOOLCHAIN_PATH)/strip




EXTRALIBS =-framework CoreFoundation -framework VideoDecodeAcceleration -framework QuartzCore -framework CoreServices  -Wl,-framework,Cocoa  -Wl,-framework,OpenGL -Wl,-framework,Cocoa -Wl,-framework,ApplicationServices -Wl,-framework,Carbon -Wl,-framework,AudioToolbox -Wl,-framework,AudioUnit -Wl,-framework,IOKit -liconv -lbz2







SOURCES  :=    \
	VideoSource.cpp \
	HomeXml.c \
	utils/xdw_list.c \
	utils/xdw_lock.c \
	utils/xdw_socket_ipc.c 
    



OBJECTS  =$(filter %.o,$(SOURCES:.c=.o))
OBJECTS  +=$(filter %.o,$(SOURCES:.cpp=.o))

DEPS+=$(filter %.P,$(OBJECTS:.o=.P))

GEN_DEPS=\
  cp $*.d $*.P \
  && sed -e 's/\#.*//' -e 's/^[^:]*: *//' -e 's/ *\\$$//' \
         -e '/^$$/ d' -e 's/$$/ :/' < $*.d >> $*.P \
  && rm -f $*.d \
  || ( rm -f $*.P $@ && exit 1 )



SILENT_CPP=@echo "CPP     $(rel_top_srcdir)$@";
SILENT_CC =@echo "CC      $(rel_top_srcdir)$@";
SILENT_S  =@echo "S       $(rel_top_srcdir)$@";
SILENT_GCH=@echo "GCH     $(rel_top_srcdir)$@";
SILENT_MM =@echo "MM      $(rel_top_srcdir)$@";
SILENT_AR =@echo "AR      $(rel_top_srcdir)$@";
SILENT_LD =@echo "LD      $(rel_top_srcdir)$@";






airmirrorserver: $(OBJECTS)
	$(SILENT_LD) $(CXX) $(CXXFLAGS) $(LDFLAGS) -o $@  $(OBJECTS) $(LIBS) $(EXTRALIBS)\
		./lib/libavformat.a\
		./lib/libavcodec.a\
		./lib/libavutil.a\
		./lib/libswresample.a\
		./lib/libavdevice.a\
		./lib/libswscale.a\
		./lib/libavfilter.a\
        ./lib/libavdevice.a\
        ./lib/libpostproc.a\
        ./lib/libcrypto.a \
        ./lib/libz.a \
	./lib/libSDL.a \
	./lib/libSDLmain.a \
    ./lib/libgnutls.a \
    ./lib/libnettle.a \
	./lib/libgmp.a \
    ./lib/libdcadec.a \
    ./lib/libhogweed.a \
	./libmediaserver.dylib\
    ./lib/libintl.a\
    ./libvlc.dylib\
		-rdynamic
#		$(STRIP) airmirrorserver





%.o: %.cpp
	@rm -f $@
	$(SILENT_CPP) $(CXX) -MF $*.d -MD -c $(CXXFLAGS) $(DEFINES) $(INCLUDES) $< -o $@ \
        && $(GEN_DEPS)

%.o: %.cc
	@rm -f $@
	$(SILENT_CPP) $(CXX) -MF $*.d -MD -c $(CXXFLAGS) $(DEFINES) $(INCLUDES) $< -o $@ \
        && $(GEN_DEPS)

%.o: %.c
	@rm -f $@
	$(SILENT_CC) $(CC) -MF $*.d -MD -c $(CFLAGS) $(DEFINES) $(INCLUDES) $< -o $@ \
        && $(GEN_DEPS)

%.o: %.C
	@rm -f $@
	$(SILENT_CPP) $(CXX) -MF $*.d -MD -c $(CFLAGS) $(DEFINES) $(INCLUDES) $< -o $@ \
        && $(GEN_DEPS)



clean:
	-rm  $(DEPS)  $(OBJECTS) airmirrorserver
