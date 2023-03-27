# my personal packages to install

function ipkg {
    param (
        $package
    )
    winget install $package --accept-source-agreements --accept-package-agreements --silent
}

function ipkg-user {
    param (
        $package
    )
    runas /trustlevel:0x20000 ("cmd /C winget install " + $package + " --accept-source-agreements --accept-package-agreements --silent")
}

ipkg Hibbiki.Chromium
ipkg 7Zip.7Zip
ipkg Notepad++.Notepad++

# you are like always a special fucking snowflake
winget install Microsoft.VisualStudioCode --accept-source-agreements --accept-package-agreements --override '/SILENT /mergetasks="!runcode,addcontextmenufiles,addcontextmenufolders"'
#ipkg Microsoft.VisualStudioCode

ipkg VideoLAN.VLC
ipkg-user Spotify.Spotify
ipkg Discord.Discord
ipkg Valve.Steam
ipkg Python.Python.3.10
ipkg OpenJS.NodeJS
ipkg Git.Git
ipkg EclipseAdoptium.Temurin.8.JDK
ipkg EclipseAdoptium.Temurin.17.JDK
ipkg GorillaDevs.GDLauncher
ipkg Microsoft.PowerToys
ipkg TechPowerUp.NVCleanstall
ipkg Nvidia.Broadcast
ipkg Oracle.VirtualBox

###########################################################################
### restore mandatory packages that are not included in windows 10 ltsc ###
###########################################################################

# xbox game bar for capture
ipkg 9NZKPSTSNW4P

# windows photos app
ipkg 9WZDNCRFJBH4

# calculator
ipkg 9WZDNCRFHVN5

# and you are also a special snowflake.
winget install Microsoft.VisualStudio.2022.Community

pause
