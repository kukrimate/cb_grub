export GRUB_ROOT := $(shell realpath .)/grub-root
export PATH      := $(GRUB_ROOT)/bin:$(PATH)

.PHONY: all
all: grub2_cb.elf

grub/configure:
	cd $< && ./autogen.sh

build: grub grub/configure
	mkdir -p build || touch $<
	cd $@ && ../$</configure --prefix=$(GRUB_ROOT) \
							 --with-platform=coreboot \
							 --disable-efiemu \
							 || touch $<
	$(MAKE) -C $@/ || touch $<

grub-root: build
	$(MAKE) -C $</ install

grub2_cb.elf: grub-root memdisk_src
	grub-mkstandalone --compress=xz \
					  --format=i386-coreboot \
					  --output=$@ \
					  /=./memdisk_src/

.PHONY: clean
clean:
	rm -rf build/ grub-root/ *.elf
