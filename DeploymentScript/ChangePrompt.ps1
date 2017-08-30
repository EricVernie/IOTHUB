 function global:prompt {  # Multiple Write-Host commands with color
    Write-Host("[") -nonewline
    Write-Host((Get-Date).ToShortTimeString()) -nonewline -foregroundcolor Red
    Write-Host("] ") -nonewline
    Write-Host($(Split-Path $pwd -Leaf)) -nonewline -foregroundcolor Green
    return " $ "
}