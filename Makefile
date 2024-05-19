GRUB_REVISION = 2.12

export GRUB_ROOT := $(shell realpath .)/grub-root
export PATH      := $(GRUB_ROOT)/bin:$(PATH)

.PHONY: all clean

all: payload.elf

clean:
	rm -rf build/ grub-root/ *.elf

grub:
	git clone git://git.savannah.gnu.org/grub.git
	cd $@ && git checkout grub-$(GRUB_REVISION)
	cd $@ && git am ../patches/*.patch
	cd $@ && ./bootstrap

build: grub
	mkdir -p build || touch $<
	cd $@ && ../$</configure --prefix=$(GRUB_ROOT) \
				 --with-platform=coreboot \
				 --disable-efiemu \
				 --disable-werror \
				 || touch $<
	$(MAKE) -C $@/ || touch $<

grub-root: build
	$(MAKE) -C $</ install

payload.elf: grub-root memdisk_src
	grub-mkstandalone --compress=xz \
			  --format=i386-coreboot \
			  --output=$@ \
			  --themes= \
			  /=./memdisk_src/
