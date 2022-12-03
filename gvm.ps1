param ($cmd, $p1)

$supportedCmd = @("install", "use", "remove")

$gvmRoot = $env:GVM_HOME ?? "$env:USERPROFILE\.gvm"
$gvmSymlink = $env:GVM_SYMLINK ?? "$env:USERPROFILE\go"

Function install {
  param($version)
  if(!(Test-Path -Path "$gvmRoot\$version")) {
    $url = "https://go.dev/dl/go$version.windows-amd64.zip"
    
    New-Item -ItemType Directory -Force -Path "$gvmRoot\dl"
    New-Item -ItemType Directory -Force -Path "$gvmRoot\$version"
    Invoke-WebRequest -Uri $url -OutFile "$gvmRoot\dl\$version.zip"

    Expand-Archive -LiteralPath "$gvmRoot\dl\$version.zip" -DestinationPath "$gvmRoot\$version"

    Move-Item -Path "$gvmRoot\$version\go\*" -Destination "$gvmRoot\$version\"
    Remove-Item "$gvmRoot\$version\go"
    Remove-Item "$gvmRoot\dl\$version.zip"
  }

  use $version
}

Function use {
  $symlink = $gvmSymlink -split "\\"

  if(Test-Path -Path $gvmSymlink) { Remove-Item $gvmSymlink }
  New-Item -ItemType Junction -Path ($symlink[0..($symlink.Length - 1)] -join "/") -Name $symlink[$symlink.Length] -Target $gvmRoot\$version
  [Environment]::SetEnvironmentVariable('Path', $env:Path + ";" + "$gvmSymlink/bin", 'User')
  $Env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 
}

Function remove {
  "Remove"
}

if($supportedCmd -contains $cmd) {
  & $cmd $p1
} else {
  Write-Error "Unsupported Command: $cmd";
  Write-Error "Supported Commands are: $supportedCmd";
}