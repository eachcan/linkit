[简体中文](README.md) | [English](README.en.md) | [日本語](README.jp.md) | **[Français](README.fr.md)**

# Linkit

Linkit est un utilitaire de script PowerShell qui crée des scripts wrapper dans le répertoire `D:\bin` pour les fichiers exécutables. Il vous aide à ajouter rapidement des exécutables couramment utilisés à votre chemin système, les rendant facilement accessibles depuis la ligne de commande.

## Fonctionnalités

- Crée des scripts wrapper pour les fichiers `.exe`, `.cmd` et `.ps1`
- Gère les fichiers individuels ou des répertoires entiers
- Prend en charge l'analyse récursive des sous-répertoires
- Ignore automatiquement les scripts wrapper existants
- Génère différents scripts wrapper selon le type de fichier source :
  - Fichiers `.exe` : génère des wrappers `.ps1` et `.cmd`
  - Fichiers `.cmd` : génère des wrappers `.ps1` et `.cmd`
  - Fichiers `.ps1` : génère un wrapper `.ps1` et un wrapper `.cmd` spécial (utilisant PowerShell)

## Utilisation

```powershell
linkit [-c] [-p] [-a] path1 [path2 ...]
```

### Paramètres

- `-c`: Inclure les fichiers `.cmd`
- `-p`: Inclure les fichiers `.ps1`
- `-a`: Inclure les sous-répertoires
- `path`: Chemin du fichier ou du répertoire à lier

### Exemples

1. Lier un exécutable unique :
```powershell
linkit C:\Tools\mytool.exe
```

2. Lier tous les exécutables et scripts PowerShell dans un répertoire :
```powershell
linkit -p C:\Tools
```

3. Lier récursivement tous les exécutables, CMD et scripts PowerShell dans un répertoire :
```powershell
linkit -c -p -a C:\Tools
```

## Fonctionnement

1. Le script crée des scripts wrapper dans le répertoire `D:\bin`
2. Les scripts wrapper utilisent le nom du fichier original (sans extension) + l'extension `.ps1`
3. Tous les arguments sont transmis au programme original

## Notes Importantes

- Assurez-vous que le répertoire `D:\bin` est ajouté à la variable d'environnement PATH de votre système
- Les scripts wrapper existants seront ignorés
- L'exécution du script nécessite des autorisations d'exécution PowerShell appropriées
