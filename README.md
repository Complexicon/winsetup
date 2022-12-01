# winsetup
my custom windows 10 setup script

run:

```
powershell -c "Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://short.cmplx.tk/winstall.ps1'))"
```

# dism
```
dism /Get-WimInfo /WimFile:D:\Sources\install.wim
dism /Apply-Image /ImageFile:D:\Sources\install.wim /index:1 /ApplyDir:G:\
```
