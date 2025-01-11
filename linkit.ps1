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
    $targetPath = Join-Path -Path $targetDir -ChildPath "$fileName.ps1"
    
    if (Test-Path -Path $targetPath) {
        Write-Host "Skipped: $targetPath already exists."
        return
    }
    
    $scriptContent = @"
# Wrapper script for $originalPath
& '$originalPath' `$args
"@
    
    Set-Content -Path $targetPath -Value $scriptContent -Encoding UTF8
    Write-Host "Created wrapper script: $targetPath -> $originalPath"
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