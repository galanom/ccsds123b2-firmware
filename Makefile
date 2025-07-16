.PHONY: default all clean distclean install uninstall

BITC := $(basename $(notdir $(wildcard *.bit.xz)))
ifeq ($(words $(BITC),0)
	$(error No bit file was found.)
endif
ifneq ($(words $(BITC),1)
	$(error Multiple bit files were found.)
endif

BIT := $(subst .xz,,$(BITC))
DTSI := pl.dtsi
DTBO := $(subst .bit,.dtbo,$(BIT))
BIN := $(BIT).bin
JSON = shell.json

INSTALL_DIR=$(DESTDIR)/lib/firmware/xilinx/ccsds123b2/

default all: $(BIN) $(DTBO)

%.bit:
	xz -d $@

%.bit.bin: $(BIT)
	echo -e "all:\n{\n\t[destination_device = pl] $(BIT)\n}" > $(BIT).bif
	bootgen -image $(BIT).bif -arch zynqmp -o $@ -w

%.dtbo
	dtc -I dts -O dtb -o $@ $(DTSI)
