#
# Makefile:
#	Library to utilise the 4D Systems SPE Library - Picaso
#	Primarily aimed at the Raspberry Pi, however this may be used
#	on most Linux platforms with a serial connection (USB on
#	on-board) to the 4D Systems Intelligent displays.
#
#	Copyright (c) 2014 4D Systems PTY Ltd, Sydney, Australia
#######################################################################


DESTDIR=/usr
PREFIX=/local

STATIC=goldeloxSerial.a
DYNAMIC=goldeloxSerial.so

#DEBUG	= -g -O0
DEBUG	= -O2
CC	= gcc
INCLUDE	= -I.
CFLAGS	= $(DEBUG) -Wall $(INCLUDE) -Winline -pipe

#LIBS    = -lpthread

SRC	=	goldeloxSerial.c


# May not need to  alter anything below this line
###############################################################################

OBJ	=	$(SRC:.c=.o)

#all:	$(STATIC)
all:	$(DYNAMIC)

$(STATIC):	$(OBJ)
	@echo "[Link (Static)]"
	@ar rcs $(STATIC) $(OBJ)
	@ranlib $(STATIC)
#	@size   $(STATIC)

$(DYNAMIC):     $(OBJ)
	@echo "[Link (Dynamic)]"
	@$(CC) -shared -Wl,-soname,libgoldeloxSerial.so -o libgoldeloxSerial.so -lpthread $(OBJ) -lrt
.c.o:
	@echo [Compile] $<
	@$(CC) -c $(CFLAGS) $< -o $@

.PHONEY:	clean
clean:
	rm -f $(OBJ) *~ core tags *.bak Makefile.bak libgoldeloxSerial.*

.PHONEY:	tags
tags:	$(SRC)
	@echo [ctags]
	@ctags $(SRC)

.PHONEY:	depend
depend:
	makedepend -Y $(SRC)

.PHONEY:	install
install:	$(TARGET)
	@echo "[Install]"
	@install -m 0755 -d            $(DESTDIR)$(PREFIX)/lib
	@install -m 0755 -d            $(DESTDIR)$(PREFIX)/include
	@install -m 0644 goldeloxSerial.h     $(DESTDIR)$(PREFIX)/include
	@install -m 0644 Goldelox_const4D.h     $(DESTDIR)$(PREFIX)/include
	@install -m 0644 Goldelox_Types4D.h     $(DESTDIR)$(PREFIX)/include
	@install -m 0755 libgoldeloxSerial.so $(DESTDIR)$(PREFIX)/lib

	
.PHONEY:	uninstall
uninstall:
	@echo "[Un-Install]"
	@rm -f	$(DESTDIR)$(PREFIX)/include/goldeloxSerial.h
	@rm -f	$(DESTDIR)$(PREFIX)/include/Goldelox_const4D.h
	@rm -f	$(DESTDIR)$(PREFIX)/include/Goldelox_Types4D.h
	@rm -f	$(DESTDIR)$(PREFIX)/lib/libgoldeloxSerial.*

# DO NOT DELETE

goldeloxSerial.o: goldeloxSerial.h
