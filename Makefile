GRUB_REVISION = 2.02

export GRUB_ROOT := $(shell realpath .)/grub-root
export PATH      := $(GRUB_ROOT)/bin:$(PATH)

.PHONY: all
all: grub2_cb.elf

grub:
	git clone git://git.savannah.gnu.org/grub.git
	cd $@ && git checkout grub-$(GRUB_REVISION)
	./apply_patches.sh
	cd $@ && ./autogen.sh

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

grub2_cb.elf: grub-root memdisk_src
	grub-mkstandalone --compress=xz \
					  --format=i386-coreboot \
					  --output=$@ \
					  --themes= \
					  /=./memdisk_src/

.PHONY: clean
clean:
	rm -rf build/ grub-root/ *.elf
