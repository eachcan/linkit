# 定义目标目录（D:\bin）
$targetDir = "D:\bin"

# 定义默认扫描的文件类型
$fileTypes = @("*.exe")

# 解析参数
$paths = @()
$recursive = $false
for ($i = 0; $i -lt $args.Count; $i++) {
    if ($args[$i] -eq "-c") {
        $fileTypes += "*.cmd"
    } elseif ($args[$i] -eq "-p") {
        $fileTypes += "*.ps1"
    } elseif ($args[$i] -eq "-a") {
        $recursive = $true
    } else {
        $paths += $args[$i]
    }
}

# 如果没有提供路径，显示用法信息
if ($paths.Count -eq 0) {
    Write-Host "Usage:"
    Write-Host "  linkit [-c] [-p] [-a] path1 [path2 ...]"
    Write-Host "    -c       Include .cmd files"
    Write-Host "    -p       Include .ps1 files"
    Write-Host "    -a       Include subdirectories"
    Write-Host "    path     File or directory to link"
    exit
}

# 创建包装脚本的函数
function Create-WrapperScript {
    param (
        [string]$originalPath,
        [string]$targetDir
    )
    
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
    
    Set-Content -Path $targetPath -Value $scriptContent
    Write-Host "Created wrapper script: $targetPath -> $originalPath"
}

# 遍历每个路径
foreach ($path in $paths) {
    # 单个文件模式
    if (Test-Path -Path $path -PathType Leaf) {
        Create-WrapperScript -originalPath (Resolve-Path $path) -targetDir $targetDir
    }
    # 目录模式
    elseif (Test-Path -Path $path -PathType Container) {
        # 获取目录中的所有匹配文件
        if ($recursive) {
            $files = Get-ChildItem -Path $path -Include $fileTypes -Recurse
        } else {
            $files = Get-ChildItem -Path $path -Include $fileTypes
        }

        if ($files.Count -eq 0) {
            Write-Host "No matching files found in $path"
        } else {
            foreach ($file in $files) {
                Create-WrapperScript -originalPath $file.FullName -targetDir $targetDir
            }
        }
    }
    else {
        Write-Host "Error: $path does not exist."
    }
}