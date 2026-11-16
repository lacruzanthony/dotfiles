# Guía de herramientas

Qué hace cada cosa instalada por este repo, cómo se usa y qué atajos/aliases trae configurados.

## Shell

### zsh + Oh My Zsh
Shell por defecto de macOS + framework de plugins. Plugins activos (`home/.zshrc`):

| Plugin | Qué hace |
|---|---|
| `git` | Cientos de aliases de git (`gst`, `gco`, `gp`, `gl`…). Lista: `alias \| grep git` |
| `zsh-autosuggestions` | Sugiere en gris el comando según tu historial. `→` acepta, `Ctrl+→` acepta una palabra |
| `zsh-syntax-highlighting` | Colorea el comando mientras escribes: rojo = no existe, verde = válido |

### Starship
Prompt rápido que muestra carpeta, rama y estado de git, versión de Node/Python/Java del proyecto y duración del último comando si tarda más de 2 s. Config: `home/.config/starship.toml`.

### atuin — historial
Sustituye el historial de zsh por una base de datos SQLite con contexto (carpeta, duración, código de salida).

| Atajo | Qué hace |
|---|---|
| `Ctrl+R` | Busca en todo el historial (difuso) |
| `↑` | Historial **solo de la carpeta actual** |
| `Enter` en un resultado | Lo pega en la línea para editarlo (no lo ejecuta) |

No guarda comandos que parezcan contener tokens/claves. Sync entre máquinas desactivado; para activarlo: `atuin register` / `atuin login`. Config: `home/.config/atuin/config.toml`.

### fzf — buscador difuso
| Atajo | Qué hace |
|---|---|
| `Ctrl+T` | Busca un archivo y pega su ruta |
| `Alt+C` | Busca una carpeta y entra en ella |
| `**<Tab>` | Autocompletado difuso: `cd **<Tab>`, `zed **<Tab>` |

(`Ctrl+R` lo gestiona atuin.)

### zoxide — `cd` con memoria
Aprende las carpetas que visitas.

```sh
z colmena        # salta a la carpeta más usada que contenga "colmena"
z code stock     # varias palabras afinan
zi               # elige entre las candidatas con fzf
```

## Sustitutos modernos

| Herramienta | Sustituye a | Uso típico | Alias configurado |
|---|---|---|---|
| **eza** | `ls` | Colores, iconos, estado git, árbol | `ls`, `ll` (detalle + git), `la` (con ocultos), `lt` (árbol 2 niveles) |
| **bat** | `cat` | Resaltado de sintaxis y números de línea | `cat` → `bat --paging=never` (`\cat` usa el original) |
| **fd** | `find` | `fd test` · `fd -e ts` · respeta `.gitignore` | — |
| **ripgrep** (`rg`) | `grep` | `rg "useStock"` · `rg -t ts todo` · muy rápido | — |
| **jq** | — | Filtra JSON: `curl … \| jq '.items[].name'` | — |

## Git

| Herramienta | Qué hace | Uso |
|---|---|---|
| **gh** | CLI de GitHub: auth, repos, PRs, issues | `gh repo clone x/y` · `gh pr create` · `gh pr checkout 12` |
| **git-delta** | Pager de diffs con resaltado y números de línea; ya configurado en `.gitconfig` | Automático en `git diff`, `git show`, `git log -p`. `n`/`N` salta entre archivos |
| **lazygit** | Interfaz de git en la terminal | `lg`. `space` stage · `c` commit · `P` push · `?` ayuda |

Aliases de `.gitconfig`: `git s` (status corto), `git co`, `git sw`, `git br`, `git cm "msg"`, `git amend`, `git lg` (grafo), `git undo` (deshace el último commit manteniendo cambios).

Ajustes: `pull` con rebase, `push` crea la rama remota sola, `fetch` limpia ramas borradas, `rerere` recuerda resoluciones de conflictos.

## Utilidades

| Herramienta | Qué hace | Uso |
|---|---|---|
| **btop** | Monitor de CPU, RAM, red y procesos | `btop` · `q` sale |
| **tldr** (tlrc) | Ejemplos prácticos de un comando | `tldr tar` |
| **httpie** | Cliente HTTP legible | `http GET api.example.com/items` · `http POST … name=foo` |

Aliases extra: `dots` (va a `~/.dotfiles`), `reload` (recarga zsh), `brewup` (actualiza todo brew), `ports` (qué procesos escuchan en qué puerto).

## Runtimes

| Lenguaje | Gestor | Comandos clave |
|---|---|---|
| Node | **nvm** | `nvm install 22` · `nvm use` (lee `.nvmrc`) · `nvm alias default lts/*` |
| Python | **pyenv** | `pyenv install 3.13` · `pyenv local 3.12` (crea `.python-version`) · `pyenv global` |
| Java/Kotlin | **sdkman** | `sdk list java` · `sdk install java 21-tem` · `sdk use java …` · `sdk env init` (crea `.sdkmanrc`) |

## Apps

| App | Para qué | Config en el repo |
|---|---|---|
| **Rectangle** | Colocar ventanas con atajos (`⌃⌥←/→` mitades, `⌃⌥↩` maximizar…) | `apps/rectangle/RectangleConfig.json` (exportado) |
| **cmux** | Terminal | `home/.config/cmux/cmux.json` |
| **T3 Code** | Cliente de agentes de código | `apps/t3code/` (settings y atajos; se exportan solos en cada commit) |
| **Zed** | Editor | `home/.config/zed/` |
| **Android Studio** *(opcional, `./install.sh 08`)* | IDE Android. El SDK (en `~/Library/Android/sdk`) lo gestiona el propio Studio (SDK Manager); `.zshrc` exporta `ANDROID_HOME` y añade al PATH `adb` y `emulator` | — |
| **Claude Code** / **Codex** | Agentes de IA en terminal | `ai/` — instrucciones comunes en `ai/instructions/AGENTS.md` |
| **JetBrainsMono Nerd Font** | Fuente con iconos para Starship y eza | — |

## SSH

Va a GitHub por `ssh.github.com:443` (el 22 está bloqueado en la red corporativa); la passphrase se guarda en el llavero de macOS. Ver README.
