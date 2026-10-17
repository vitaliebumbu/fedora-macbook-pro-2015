#!/usr/bin/python3
"""Disable USB3 link power saving only on the internal Apple card-reader port."""
from pathlib import Path
import re,sys
if len(sys.argv)!=2:raise SystemExit('Supply sysfs device path')
d=Path('/sys'+sys.argv[1]) if sys.argv[1].startswith('/devices/') else Path(sys.argv[1])
d=d.resolve()
if not str(d).startswith('/sys/devices/'):raise SystemExit('Invalid sysfs path')
if (d/'idVendor').read_text().strip()!='05ac' or (d/'idProduct').read_text().strip()!='8406':raise SystemExit('Not the Apple card reader')
m=re.fullmatch(r'(\d+)-(\d+)',d.name)
if not m:raise SystemExit('Expected internal root-hub port')
bus,port=m.groups()
p=Path(f'/sys/bus/usb/devices/usb{bus}/{bus}-0:1.0/usb{bus}-port{port}/usb3_lpm_permit')
p.write_text('0')
print('Apple card reader USB3 link power saving disabled:',p)
