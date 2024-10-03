# winsetup
my custom windows 10 setup script

run:

```
powershell -c "irm short.cmplx.dev/winstall.ps1 | iex"
```

# dism
```
dism /Get-WimInfo /WimFile:D:\Sources\install.wim
dism /Apply-Image /ImageFile:D:\Sources\install.wim /index:1 /ApplyDir:G:\
```

# diskpart
```
# efi partition
create partition efi size=500
format quick fs=fat32
assign letter=y

# create vhd file
create vdisk file=K:\windows.vhdx maximum=40000 type=expandable
attach vdisk
convert gpt
create partition primary
assign letter=u
```
