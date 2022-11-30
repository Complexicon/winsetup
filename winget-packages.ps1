# my personal packages to install

function ipkg {
    param (
        $package
    )
    winget install $package --accept-source-agreements --accept-package-agreements
}

ipkg Hibbiki.Chromium
ipkg 7Zip.7Zip
ipkg Notepad++.Notepad++
ipkg Microsoft.VisualStudioCode
ipkg VideoLAN.VLC
ipkg Spotify.Spotify
ipkg Discord.Discord
ipkg Valve.Steam
ipkg Python.Python.3.10
ipkg OpenJS.NodeJS
ipkg Git.Git
ipkg EclipseAdoptium.Temurin.8.JDK
ipkg EclipseAdoptium.Temurin.17.JDK
ipkg Microsoft.PowerToys
ipkg TechPowerUp.NVCleanstall
ipkg Nvidia.RTXVoice
ipkg Oracle.VirtualBox
ipkg 9NZKPSTSNW4P
ipkg Microsoft.VisualStudio.2022.Community
