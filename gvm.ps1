param ($cmd, $version)

$supportedCmd = @("install", "use", "remove")

$gvmRoot = $env:GVM_ROOT ?? "$env:USERPROFILE\.gvm"
$gvmSymlink = $env:GVM_SYMLINK ?? "$env:USERPROFILE\go"

Function install {
  param($version)
  $url = "https://go.dev/dl/go$version.windows-amd64.zip"
  Write-Host $gvmRoot
  
  Invoke-WebRequest -Uri $url -OutFile "$gvmRoot\dl\$version.zip"
}

Function use {
  "Use"
}

Function remove {
  "Remove"
}

if($supportedCmd -contains $cmd) {
  & $cmd $version
} else {
  Write-Error "Unsupported Command: $cmd";
  Write-Error "Supported Commands are: $supportedCmd";
}