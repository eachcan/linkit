$targetDir = "D:\bin"
$fileTypes = @("*.exe")
$paths = @()
$recursive = $false

foreach ($arg in $args) {
    switch ($arg) {
        "-c" { $fileTypes += "*.cmd" }
        "-p" { $fileTypes += "*.ps1" }
        "-a" { $recursive = $true }
        default { $paths += $arg }
    }
}

if ($paths.Count -eq 0) {
    Write-Host "Usage:"
    Write-Host "  linkit [-c] [-p] [-a] path1 [path2 ...]"
    Write-Host "    -c       Include .cmd files"
    Write-Host "    -p       Include .ps1 files"
    Write-Host "    -a       Include subdirectories"
    Write-Host "    path     File or directory to link"
    exit
}

function Create-WrapperScript($originalPath, $targetDir) {
    $fileName = [System.IO.Path]::GetFileNameWithoutExtension($originalPath)
    $extension = [System.IO.Path]::GetExtension($originalPath).ToLower()
    
    # 根据源文件类型决定生成的包装脚本
    switch ($extension) {
        ".exe" {
            # EXE: 生成 PS1 和 CMD wrapper
            $ps1TargetPath = Join-Path -Path $targetDir -ChildPath "$fileName.ps1"
            if (Test-Path -Path $ps1TargetPath) {
                Write-Host "Skipped: $ps1TargetPath already exists."
            } else {
                $ps1Content = @"
# Wrapper script for $originalPath
& '$originalPath' `$args
"@
                Set-Content -Path $ps1TargetPath -Value $ps1Content -Encoding UTF8
                Write-Host "Created PS1 wrapper: $ps1TargetPath -> $originalPath"
            }

            $cmdTargetPath = Join-Path -Path $targetDir -ChildPath "$fileName.cmd"
            if (Test-Path -Path $cmdTargetPath) {
                Write-Host "Skipped: $cmdTargetPath already exists."
            } else {
                $cmdContent = @"
@echo off
"$originalPath" %*
"@
                Set-Content -Path $cmdTargetPath -Value $cmdContent -Encoding UTF8
                Write-Host "Created CMD wrapper: $cmdTargetPath -> $originalPath"
            }
        }
        ".cmd" {
            # CMD: 生成 PS1 和 CMD wrapper
            $ps1TargetPath = Join-Path -Path $targetDir -ChildPath "$fileName.ps1"
            if (Test-Path -Path $ps1TargetPath) {
                Write-Host "Skipped: $ps1TargetPath already exists."
            } else {
                $ps1Content = @"
# Wrapper script for $originalPath
& '$originalPath' `$args
"@
                Set-Content -Path $ps1TargetPath -Value $ps1Content -Encoding UTF8
                Write-Host "Created PS1 wrapper: $ps1TargetPath -> $originalPath"
            }

            $cmdTargetPath = Join-Path -Path $targetDir -ChildPath "$fileName.cmd"
            if (Test-Path -Path $cmdTargetPath) {
                Write-Host "Skipped: $cmdTargetPath already exists."
            } else {
                $cmdContent = @"
@echo off
"$originalPath" %*
"@
                Set-Content -Path $cmdTargetPath -Value $cmdContent -Encoding UTF8
                Write-Host "Created CMD wrapper: $cmdTargetPath -> $originalPath"
            }
        }
        ".ps1" {
            # PS1: 生成 PS1 wrapper 和使用 powershell.exe 的 CMD wrapper
            $ps1TargetPath = Join-Path -Path $targetDir -ChildPath "$fileName.ps1"
            if (Test-Path -Path $ps1TargetPath) {
                Write-Host "Skipped: $ps1TargetPath already exists."
            } else {
                $ps1Content = @"
# Wrapper script for $originalPath
& '$originalPath' `$args
"@
                Set-Content -Path $ps1TargetPath -Value $ps1Content -Encoding UTF8
                Write-Host "Created PS1 wrapper: $ps1TargetPath -> $originalPath"
            }

            $cmdTargetPath = Join-Path -Path $targetDir -ChildPath "$fileName.cmd"
            if (Test-Path -Path $cmdTargetPath) {
                Write-Host "Skipped: $cmdTargetPath already exists."
            } else {
                $cmdContent = @"
@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "$originalPath" %*
"@
                Set-Content -Path $cmdTargetPath -Value $cmdContent -Encoding UTF8
                Write-Host "Created CMD wrapper: $cmdTargetPath -> $originalPath"
            }
        }
    }
}

foreach ($path in $paths) {
    if (-not (Test-Path -Path $path)) {
        Write-Host "Error: $path does not exist."
        continue
    }

    if (Test-Path -Path $path -PathType Leaf) {
        Create-WrapperScript (Resolve-Path $path).Path $targetDir
        continue
    }

    $foundFiles = $false
    foreach ($fileType in $fileTypes) {
        $searchOption = if ($recursive) { "-Recurse" } else { "" }
        $cmd = "Get-ChildItem -Path '$path' -Filter '$fileType' $searchOption"
        $files = Invoke-Expression $cmd
        
        if ($files) {
            $foundFiles = $true
            foreach ($file in $files) {
                Create-WrapperScript $file.FullName $targetDir
            }
        }
    }

    if (-not $foundFiles) {
        Write-Host "No matching files found in $path"
    }
}