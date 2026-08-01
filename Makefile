HWDB := etc/udev/hwdb.d/90-apple-keyboard-remap.hwdb
KEYD := etc/keyd/mouse-m720.conf

.PHONY: system hwdb keyd

system: hwdb keyd

hwdb:
	sudo install -Dm0644 system/$(HWDB) /$(HWDB)
	sudo systemd-hwdb update
	sudo udevadm trigger --subsystem-match=input --action=change

keyd:
	sudo install -Dm0644 system/$(KEYD) /$(KEYD)
	sudo keyd reload
