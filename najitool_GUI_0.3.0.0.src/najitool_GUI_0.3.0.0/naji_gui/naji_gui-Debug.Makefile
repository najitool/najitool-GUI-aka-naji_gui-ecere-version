.PHONY: all objdir clean distclean

# CONTENT

MODULE := naji_gui
CONFIG := debug
COMPILER := default
TARGET_TYPE = executable

OBJ = obj/$(CONFIG).$(PLATFORM)/

RES = 

CONSOLE = -mwindows

TARGET = obj/$(CONFIG).$(PLATFORM)/naji_gui$(E)

OBJECTS = $(OBJ)najiform.o $(OBJ)najicmds.o $(OBJ)naji_ttt.o $(OBJ)najicalc.o \
	$(OBJ)najihelp.o $(OBJ)naji_mp3.o $(OBJ)$(MODULE).main$(O)

COBJECTS = $(OBJ)najiform.c $(OBJ)najicmds.c $(OBJ)naji_ttt.c $(OBJ)najicalc.c \
	$(OBJ)najihelp.c

SYMBOLS = $(OBJ)najiform.sym $(OBJ)najicmds.sym $(OBJ)naji_ttt.sym $(OBJ)najicalc.sym \
	$(OBJ)najihelp.sym

IMPORTS = $(OBJ)najiform.imp $(OBJ)najicmds.imp $(OBJ)naji_ttt.imp $(OBJ)najicalc.imp \
	$(OBJ)najihelp.imp

SOURCES = najiform.ec najicmds.ec naji_ttt.ec najicalc.ec najihelp.ec naji_mp3.c

RESOURCES = $(RESOURCES1) $(RESOURCES2)
RESOURCES1 = ../../ecereRes/actions/folderNew.png ../../ecereRes/actions/goUp.png \
	../../ecereRes/devices/computer.png ../../ecereRes/devices/driveHardDisk.png \
	../../ecereRes/devices/driveRemovableMedia.png ../../ecereRes/devices/mediaFloppy.png \
	../../ecereRes/devices/mediaOptical.png ../../ecereRes/elements/areaClose.png \
	../../ecereRes/elements/areaMaximize.png ../../ecereRes/elements/areaMinimize.png \
	../../ecereRes/elements/areaRestore.png ../../ecereRes/elements/arrowDown.png ../../ecereRes/elements/arrowLeft.png \
	../../ecereRes/elements/arrowRight.png ../../ecereRes/elements/arrowUp.png ../../ecereRes/elements/checkBox.png \
	../../ecereRes/elements/checkBoxChecked.png ../../ecereRes/elements/checkBoxDisabled.png \
	../../ecereRes/elements/checkBoxDisabledChecked.png ../../ecereRes/elements/optionBoxDisabled.png \
	../../ecereRes/elements/optionBoxDisabledSelected.png ../../ecereRes/elements/optionBoxDown.png \
	../../ecereRes/elements/optionBoxSelected.png ../../ecereRes/elements/optionBoxSelectedDown.png \
	../../ecereRes/elements/optionBoxSelectedUp.png ../../ecereRes/elements/optionBoxUp.png \
	../../ecereRes/elements/orderAscending.png ../../ecereRes/elements/orderCategorized.png \
	../../ecereRes/elements/orderDescending.png ../../ecereRes/mimeTypes/file.png ../../ecereRes/places/driveRemote.png \
	../../ecereRes/places/folder.png ../../ecereRes/places/folderRemote.png \
	../../ecereRes/places/networkServer.png ../../ecereRes/places/networkWorkgroup.png
RESOURCES2 = ../../ecereRes/status/folderOpen.png english_flag.pcx najitool.pcx \
	player_o.pcx player_x.pcx ttt_board.pcx turkish_flag.pcx naji_gui.png resources.rc


# DETECTION
ifeq "$(OS)" "Windows_NT"
   WINDOWS = defined
else
ifeq "$(OSTYPE)" "FreeBSD"
   BSD = defined
else
ifeq "$(shell uname)" "Darwin"
   OSX = defined
else
   LINUX = defined
endif
endif
endif

# PLATFORM
ifndef PLATFORM
ifdef WINDOWS
   PLATFORM := win32
else
ifdef OSX
   PLATFORM := apple
else
   PLATFORM := linux
endif
endif
endif

# TOOLS
empty :=
space := $(empty) $(empty)
fixspace = $(subst $(space),\$(space),$1)
hidspace = $(subst $(space),^,$1)
shwspace = $(subst ^,$(space),$1)
ifdef WINDOWS
   fixps = $(subst \,/,$(1))
   psep = $(subst \\,/,$(subst /,\,$(1)))
   PS := $(strip \)
   SODESTDIR := obj/$(PLATFORM)/bin/
else
   fixps = $(1)
   PS := $(strip /)
   psep = $(1)
   SODESTDIR := obj/$(PLATFORM)/lib/
endif

# EXTENSIONS
.SUFFIXES: .c .ec .sym .imp .o
S := .sym
I := .imp
O := .o
A := .a

# PREFIXES AND POSTFIXES
ifeq "$(PLATFORM)" "win32"
   E := .exe
ifeq "$(TARGET_TYPE)" "staticlib"
   LP := lib
else
   LP :=
endif
   SO := .dll
else
ifeq "$(PLATFORM)" "apple"
   E :=
   LP := lib
   SO := .dylib
else
   E :=
   LP := lib
   SO := .so
endif
endif

# SHELL COMMANDS
ifdef WINDOWS
   echo = $(if $(1),echo $(1))
   cpq = $(if $(1),@cmd /c for %%I in ($(call psep,$(1))) do @copy /y %%I $(call psep,$(2)) > nul 2>&1)
   rmq = $(if $(1),-@del /f /q $(call psep,$(1)) > nul 2>&1)
   rmrq = $(if $(1),-@rmdir /q /s $(call psep,$(1)) > nul 2>&1)
   mkdirq = $(if $(1),-@mkdir $(call psep,$(1)) > nul 2>&1)
   rmdirq = $(if $(1),-@rmdir /q $(call psep,$(1)) > nul 2>&1)
else
ifdef OSX
   echo = $(if $(1),echo "$(1)")
   cpq = $(if $(1),cp $(1) $(2))
   rmq = $(if $(1),-rm -f $(1))
   rmrq = $(if $(1),-rm -f -r $(1))
   mkdirq = $(if $(1),-mkdir -p $(1))
   rmdirq = $(if $(1),-rmdir $(1))
else
   echo = $(if $(1),echo "$(1)")
   cpq = $(if $(1),@cp $(1) $(2))
   rmq = $(if $(1),-@rm -f $(1))
   rmrq = $(if $(1),-@rm -f -r $(1))
   mkdirq = $(if $(1),-@mkdir -p $(1))
   rmdirq = $(if $(1),-@rmdir $(1))
endif
endif

# COMPILER OPTIONS
ifeq "$(TARGET_TYPE)" "sharedlib"
   ECSLIBOPT := -dynamiclib
else
ifeq "$(TARGET_TYPE)" "staticlib"
   ECSLIBOPT := -staticlib
else
   ECSLIBOPT :=
endif
endif
ifdef WINDOWS
   FVISIBILITY :=
   FPIC :=
ifeq "$(TARGET_TYPE)" "executable"
   EXECUTABLE := $(CONSOLE)
else
   EXECUTABLE :=
endif
else
   FVISIBILITY := -fvisibility=hidden
   FPIC := -fPIC
   EXECUTABLE :=
endif
ifdef OSX
ifeq "$(TARGET_TYPE)" "sharedlib"
   INSTALLNAME := -install_name $(LP)$(MODULE)$(SO)
else
   INSTALLNAME :=
endif
else
   INSTALLNAME :=
endif

# LINKER OPTIONS
ifdef OSX
ifeq "$(TARGET_TYPE)" "sharedlib"
   SHAREDLIB := -dynamiclib -single_module -multiply_defined suppress
   LINKOPT :=
else
   SHAREDLIB :=
   LINKOPT :=
endif
ifeq "$(TARGET_TYPE)" "sharedlib"
   STRIPOPT := -x
else
   STRIPOPT := -u -r
endif
else
ifeq "$(TARGET_TYPE)" "sharedlib"
   SHAREDLIB := -shared
else
   SHAREDLIB :=
endif
   LINKOPT :=
   STRIPOPT := -x
endif
# TOOLCHAIN

CPP := cpp
CC := gcc
ECP := ecp
ECC := ecc
ECS := ecs
EAR := ear
LD := gcc
AR := ar
STRIP := strip
UPX := upx

# FLAGS

CFLAGS = -fmessage-length=0 -m32 $(FPIC) -Wall -g \
	 -D_DEBUG

CECFLAGS =

ECFLAGS =

OFLAGS = -m32 \
	 -LC:/Program\ Files\ \(x86\)/ECERE\ SDK/bin

LIBS = -lecere $(SHAREDLIB) $(EXECUTABLE) $(LINKOPT)

UPXFLAGS = -9

# HARD CODED PLATFORM-SPECIFIC OPTIONS
ifdef LINUX
OFLAGS += -Wl,--no-undefined
endif

ifdef OSX
OFLAGS += -framework cocoa -framework OpenGL
endif

# TARGETS

all: objdir $(TARGET)

objdir:
	$(if $(wildcard $(OBJ)),,$(call mkdirq,$(OBJ)))

$(OBJ)$(MODULE).main.ec: $(SYMBOLS) $(COBJECTS)
	$(ECS) $(ECSLIBOPT) $(SYMBOLS) $(IMPORTS) -symbols obj/$(CONFIG).$(PLATFORM) -o $(OBJ)$(MODULE).main.ec

$(OBJ)$(MODULE).main.c: $(OBJ)$(MODULE).main.ec
	$(ECP) $(CECFLAGS) $(ECFLAGS) $(CFLAGS) -c $(OBJ)$(MODULE).main.ec -o $(OBJ)$(MODULE).main.sym -symbols $(OBJ)
	$(ECC) $(CECFLAGS) $(ECFLAGS) $(CFLAGS) $(FVISIBILITY) -c $(OBJ)$(MODULE).main.ec -o $(OBJ)$(MODULE).main.c -symbols $(OBJ)

$(TARGET): $(SOURCES) $(RESOURCES) $(SYMBOLS) $(OBJECTS) | objdir
	$(CC) $(OFLAGS) $(OBJECTS) $(LIBS) -o $(TARGET) $(INSTALLNAME)
	$(EAR) aw $(TARGET) english_flag.pcx najitool.pcx player_o.pcx player_x.pcx ttt_board.pcx turkish_flag.pcx naji_gui.png resources.rc ""
	$(EAR) aw $(TARGET) ../../ecereRes/actions/folderNew.png ../../ecereRes/actions/goUp.png "ecere/actions"
	$(EAR) aw $(TARGET) ../../ecereRes/devices/computer.png ../../ecereRes/devices/driveHardDisk.png ../../ecereRes/devices/driveRemovableMedia.png ../../ecereRes/devices/mediaFloppy.png ../../ecereRes/devices/mediaOptical.png "ecere/devices"
	$(EAR) aw $(TARGET) ../../ecereRes/elements/areaClose.png ../../ecereRes/elements/areaMaximize.png ../../ecereRes/elements/areaMinimize.png ../../ecereRes/elements/areaRestore.png ../../ecereRes/elements/arrowDown.png ../../ecereRes/elements/arrowLeft.png ../../ecereRes/elements/arrowRight.png ../../ecereRes/elements/arrowUp.png ../../ecereRes/elements/checkBox.png ../../ecereRes/elements/checkBoxChecked.png "ecere/elements"
	$(EAR) aw $(TARGET) ../../ecereRes/elements/checkBoxDisabled.png ../../ecereRes/elements/checkBoxDisabledChecked.png ../../ecereRes/elements/optionBoxDisabled.png ../../ecereRes/elements/optionBoxDisabledSelected.png ../../ecereRes/elements/optionBoxDown.png ../../ecereRes/elements/optionBoxSelected.png ../../ecereRes/elements/optionBoxSelectedDown.png ../../ecereRes/elements/optionBoxSelectedUp.png ../../ecereRes/elements/optionBoxUp.png ../../ecereRes/elements/orderAscending.png "ecere/elements"
	$(EAR) aw $(TARGET) ../../ecereRes/elements/orderCategorized.png ../../ecereRes/elements/orderDescending.png "ecere/elements"
	$(EAR) aw $(TARGET) ../../ecereRes/mimeTypes/file.png "ecere/mimeTypes"
	$(EAR) aw $(TARGET) ../../ecereRes/places/driveRemote.png ../../ecereRes/places/folder.png ../../ecereRes/places/folderRemote.png ../../ecereRes/places/networkServer.png ../../ecereRes/places/networkWorkgroup.png "ecere/places"
	$(EAR) aw $(TARGET) ../../ecereRes/status/folderOpen.png "ecere/status"

# SYMBOL RULES

$(OBJ)najiform.sym: najiform.ec
	$(ECP) $(CECFLAGS) $(ECFLAGS) $(CFLAGS) -c najiform.ec -o $(OBJ)najiform.sym

$(OBJ)najicmds.sym: najicmds.ec
	$(ECP) $(CECFLAGS) $(ECFLAGS) $(CFLAGS) -c najicmds.ec -o $(OBJ)najicmds.sym

$(OBJ)naji_ttt.sym: naji_ttt.ec
	$(ECP) $(CECFLAGS) $(ECFLAGS) $(CFLAGS) -c naji_ttt.ec -o $(OBJ)naji_ttt.sym

$(OBJ)najicalc.sym: najicalc.ec
	$(ECP) $(CECFLAGS) $(ECFLAGS) $(CFLAGS) -c najicalc.ec -o $(OBJ)najicalc.sym

$(OBJ)najihelp.sym: najihelp.ec
	$(ECP) $(CECFLAGS) $(ECFLAGS) $(CFLAGS) -c najihelp.ec -o $(OBJ)najihelp.sym

# C OBJECT RULES

$(OBJ)najiform.c: najiform.ec $(OBJ)najiform.sym | $(SYMBOLS)
	$(ECC) $(CECFLAGS) $(ECFLAGS) $(CFLAGS) $(FVISIBILITY) -c najiform.ec -o $(OBJ)najiform.c -symbols $(OBJ)

$(OBJ)najicmds.c: najicmds.ec $(OBJ)najicmds.sym | $(SYMBOLS)
	$(ECC) $(CECFLAGS) $(ECFLAGS) $(CFLAGS) $(FVISIBILITY) -c najicmds.ec -o $(OBJ)najicmds.c -symbols $(OBJ)

$(OBJ)naji_ttt.c: naji_ttt.ec $(OBJ)naji_ttt.sym | $(SYMBOLS)
	$(ECC) $(CECFLAGS) $(ECFLAGS) $(CFLAGS) $(FVISIBILITY) -c naji_ttt.ec -o $(OBJ)naji_ttt.c -symbols $(OBJ)

$(OBJ)najicalc.c: najicalc.ec $(OBJ)najicalc.sym | $(SYMBOLS)
	$(ECC) $(CECFLAGS) $(ECFLAGS) $(CFLAGS) $(FVISIBILITY) -c najicalc.ec -o $(OBJ)najicalc.c -symbols $(OBJ)

$(OBJ)najihelp.c: najihelp.ec $(OBJ)najihelp.sym | $(SYMBOLS)
	$(ECC) $(CECFLAGS) $(ECFLAGS) $(CFLAGS) $(FVISIBILITY) -c najihelp.ec -o $(OBJ)najihelp.c -symbols $(OBJ)

# OBJECT RULES

$(OBJ)najiform.o: $(OBJ)najiform.c
	$(CC) $(CFLAGS) $(FVISIBILITY) -c $(OBJ)najiform.c -o $(OBJ)najiform.o

$(OBJ)najicmds.o: $(OBJ)najicmds.c
	$(CC) $(CFLAGS) $(FVISIBILITY) -c $(OBJ)najicmds.c -o $(OBJ)najicmds.o

$(OBJ)naji_ttt.o: $(OBJ)naji_ttt.c
	$(CC) $(CFLAGS) $(FVISIBILITY) -c $(OBJ)naji_ttt.c -o $(OBJ)naji_ttt.o

$(OBJ)najicalc.o: $(OBJ)najicalc.c
	$(CC) $(CFLAGS) $(FVISIBILITY) -c $(OBJ)najicalc.c -o $(OBJ)najicalc.o

$(OBJ)najihelp.o: $(OBJ)najihelp.c
	$(CC) $(CFLAGS) $(FVISIBILITY) -c $(OBJ)najihelp.c -o $(OBJ)najihelp.o

$(OBJ)naji_mp3.o: naji_mp3.c
	$(CC) $(CFLAGS) -c naji_mp3.c -o $(OBJ)naji_mp3.o

$(OBJ)$(MODULE).main$(O): $(OBJ)$(MODULE).main.c
	$(CC) $(CFLAGS) $(FVISIBILITY) -c $(OBJ)$(MODULE).main.c -o $(OBJ)$(MODULE).main$(O)

clean: objdir
	$(call rmq,$(OBJ)$(MODULE).main.c $(OBJ)$(MODULE).main.ec $(OBJ)$(MODULE).main$(I) $(OBJ)$(MODULE).main$(S) $(TARGET))
	$(call rmq,$(OBJECTS))
	$(call rmq,$(COBJECTS))
	$(call rmq,$(IMPORTS))
	$(call rmq,$(SYMBOLS))

distclean: clean
	$(call rmdirq,$(OBJ))
