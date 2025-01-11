[简体中文](README.md) | [English](README.en.md) | [日本語](README.jp.md) | [Français](README.fr.md)

# Linkit

Linkit is a PowerShell script utility that creates wrapper scripts in the `D:\bin` directory for executable files. It helps you quickly add commonly used executables to your system path, making them easily accessible from the command line.

## Features

- Creates wrapper scripts for `.exe`, `.cmd`, and `.ps1` files
- Handles single files or entire directories
- Supports recursive scanning of subdirectories
- Automatically skips existing wrapper scripts
- Generates different wrapper scripts based on source file type:
  - `.exe` files: generates both `.ps1` and `.cmd` wrappers
  - `.cmd` files: generates both `.ps1` and `.cmd` wrappers
  - `.ps1` files: generates `.ps1` wrapper and special `.cmd` wrapper (using PowerShell)

## Usage

```powershell
linkit [-c] [-p] [-a] path1 [path2 ...]
```

### Parameters

- `-c`: Include `.cmd` files
- `-p`: Include `.ps1` files
- `-a`: Include subdirectories
- `path`: File or directory path to link

### Examples

1. Link a single executable:
```powershell
linkit C:\Tools\mytool.exe
```

2. Link all executables and PowerShell scripts in a directory:
```powershell
linkit -p C:\Tools
```

3. Recursively link all executables, CMD, and PowerShell scripts in a directory:
```powershell
linkit -c -p -a C:\Tools
```

## How It Works

1. The script creates wrapper scripts in the `D:\bin` directory
2. Wrapper scripts use the original program's filename (without extension) + `.ps1` extension
3. All arguments are passed through to the original program

## Important Notes

- Ensure `D:\bin` directory is added to your system's PATH environment variable
- Wrapper scripts will be skipped if they already exist
- Running the script requires appropriate PowerShell execution permissions
