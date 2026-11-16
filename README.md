# dotfiles

Mi configuración de macOS (Apple Silicon). Estructura inspirada en [fmontes/dotfiles](https://github.com/fmontes/dotfiles).

## Instalación

Máquina nueva:

```sh
curl -fsSL https://raw.githubusercontent.com/lacruzanthony/dotfiles/main/bootstrap.sh | bash
```

Con el repo ya clonado en `~/.dotfiles`:

```sh
./install.sh          # todos los pasos
./install.sh 03 07    # solo algunos
```

Todo es idempotente: se puede relanzar sin romper nada. Si un archivo real ocupa el sitio de un symlink, se mueve a `<archivo>.bak`.

| Paso | Qué hace |
|---|---|
| `01-xcode.sh` | Command Line Tools (git, clang…) |
| `02-brew.sh` | Homebrew + `brew bundle` del `Brewfile` |
| `03-symlinks.sh` | `home/` → `~/`, `ai/` → Claude Code y Codex, activa `.githooks/` |
| `04-ohmyzsh.sh` | Oh My Zsh + zsh-autosuggestions + zsh-syntax-highlighting |
| `05-runtimes.sh` | Node LTS (nvm), Python 3 (pyenv), Java (sdkman) |
| `06-macos.sh` | Preferencias de Dock y Finder |
| `07-post-install.sh` | Restaura T3 Code y Rectangle, crea `~/.gitconfig.local`, instala plugins de Claude Code |

## Estructura

```
bootstrap.sh       entrada remota: clona en ~/.dotfiles y lanza install.sh
install.sh         ejecuta scripts/NN-*.sh en orden
Brewfile           CLI y apps
home/              se enlaza archivo a archivo en ~/  (.zshrc, .gitconfig, .config/…)
apps/              config de apps que reescriben sus archivos → se copian, no se enlazan
  t3code/            settings y atajos de T3 Code
  rectangle/         RectangleConfig.json exportado
ai/
  instructions/AGENTS.md   fuente única → ~/.claude/CLAUDE.md y ~/.codex/AGENTS.md
  skills/                  skills propias → ~/.claude/skills y ~/.codex/skills
  claude/                  settings.json + plugins.txt
  codex/                   config.toml
templates/         plantillas de identidad git (no se versiona la real)
.githooks/         pre-commit: exporta la config de apps al repo
```

## Herramientas

**Shell**: zsh + Oh My Zsh + [Starship](https://starship.rs), [atuin](https://atuin.sh) (historial, `Ctrl+R`), fzf (`Ctrl+T`), zoxide (`z`).

**CLI**: eza, bat, fd, ripgrep, jq, gh, git-delta, lazygit, btop, tldr (tlrc), httpie.

**Apps**: Rectangle, cmux, T3 Code, Zed, Claude Code, Codex.

## Git: identidad personal y de trabajo

`.gitconfig` no lleva nombre ni email: incluye `~/.gitconfig.local` (fuera del repo), que define el email personal y usa `~/.gitconfig.work` para todo lo que esté en `~/Documents/code/`. El paso 07 los crea preguntando.

## SSH

`home/.ssh/config` va a GitHub por `ssh.github.com:443` (el puerto 22 está bloqueado en la red corporativa) y guarda la passphrase en el llavero de macOS. Las claves no se versionan: una por máquina.

```sh
ssh-keygen -t ed25519 -C "lacruzanthony@<maquina>" -f ~/.ssh/id_ed25519
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
gh auth refresh -h github.com -s admin:public_key
gh ssh-key add ~/.ssh/id_ed25519.pub --title "<maquina>"
ssh -T git@github.com
```

## Pasos manuales

- `gh auth login`
- Clave SSH de la máquina (ver arriba)
- Rectangle → Settings → Export → `apps/rectangle/RectangleConfig.json`
- Opcional: `atuin register` / `atuin login` para sincronizar el historial
- Config solo de una máquina: `~/.zshrc.local` (no se versiona)
