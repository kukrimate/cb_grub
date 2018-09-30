# GRUB2 for coreboot
This project provides a Makefile based system for building GRUB2 images for 
coreboot.  
WARNING: You must enable PS/2 keyboard initialization in coreboot's Kconfig if you want your keyboard to actually work in GRUB2.
# Tutorial
1. Clone the repo using `git clone https://github.com/kukrimate/cb_grub`
2. Customize the memdisk sources to your liking
3. Run `make -j <you core count>`
4. Profit :)
