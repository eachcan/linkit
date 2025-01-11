**[简体中文](README.md)** | [English](README.en.md) | [日本語](README.jp.md) | [Français](README.fr.md)

# Linkit

Linkit 是一个 PowerShell 脚本工具，用于在 `D:\bin` 目录下创建可执行文件的包装脚本。它可以帮助你快速将常用的可执行文件添加到系统路径中，方便在命令行中直接调用。

## 功能特点

- 支持创建 `.exe`、`.cmd` 和 `.ps1` 文件的包装脚本
- 可以处理单个文件或整个目录
- 支持递归扫描子目录
- 自动跳过已存在的包装脚本
- 根据源文件类型生成不同的包装脚本：
  - `.exe` 文件：生成 `.ps1` 和 `.cmd` 包装脚本
  - `.cmd` 文件：生成 `.ps1` 和 `.cmd` 包装脚本
  - `.ps1` 文件：生成 `.ps1` 包装脚本和特殊的 `.cmd` 包装脚本（使用 PowerShell 执行）

## 使用方法

```powershell
linkit [-c] [-p] [-a] path1 [path2 ...]
```

### 参数说明

- `-c`: 包含 `.cmd` 文件
- `-p`: 包含 `.ps1` 文件
- `-a`: 包含子目录
- `path`: 要链接的文件或目录路径

### 示例

1. 链接单个可执行文件：
```powershell
linkit C:\Tools\mytool.exe
```

2. 链接目录中的所有可执行文件和 PowerShell 脚本：
```powershell
linkit -p C:\Tools
```

3. 递归链接目录中的所有可执行文件、CMD 和 PowerShell 脚本：
```powershell
linkit -c -p -a C:\Tools
```

## 工作原理

1. 脚本会在 `D:\bin` 目录下创建包装脚本
2. 包装脚本使用原始程序的文件名（不含扩展名）+ `.ps1` 扩展名
3. 包装脚本会将所有参数传递给原始程序

## 注意事项

- 确保 `D:\bin` 目录已添加到系统的 PATH 环境变量中
- 如果目标文件已存在包装脚本，将会自动跳过
- 运行脚本需要适当的 PowerShell 执行权限
