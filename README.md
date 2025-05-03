
# 🛠️ Dotfiles de Qu4s4r

![Dotfiles Banner](https://via.placeholder.com/1200x400.png?text=Dotfiles+de+Tu+Nombre)

Configuraciones personales para entornos Unix/Linux. Incluye `.bashrc`, `.zshrc`, `.vimrc`, configuraciones de `tmux`, `git`, y más. Perfecto para configurar rápidamente un entorno de desarrollo limpio y productivo.

---

## 📸 Capturas de Pantalla

| Vista Principal | Configuración |
|------------------|----------------|
| ![Pantalla 1](https://github.com/user-attachments/assets/1cb43aa5-3dde-493a-8abc-974d0555b716) |

---

## 📦 Contenido

- 🐚 Shell: `.bashrc`, `.zshrc`
- 📝 Editor: `.vimrc`, configuraciones de VSCode
- 🔧 Terminal: `kitty`
- 📁 Scripts de instalación y respaldo

---

## 🧰 Requisitos

- Unix-like OS (Linux, macOS)
- Git
- [stow](https://www.gnu.org/software/stow/) _(recomendado para gestionar los dotfiles)_

---

## 🚀 Instalación

```bash
# 1. Clona el repositorio
git clone https://github.com/tuusuario/dotfiles.git ~/.dotfiles

# 2. Entra al directorio
cd ~/.dotfiles

# 3. Usa stow para aplicar configuraciones
stow bash
stow vim
stow zsh
stow tmux
```

O bien, puedes copiar los archivos manualmente si no usas `stow`.

```bash
cp .bashrc ~/
cp .vimrc ~/
```

---

## ⚙️ Personalización

Puedes editar los archivos dentro de `modules/` o `configs/` según tu estructura. Las configuraciones están separadas por tecnología para facilitar la modularidad.

---

## 🔁 Respaldo

```bash
# Script para hacer backup de tu configuración actual
./backup.sh
```

Este script guarda los archivos modificados en `~/dotfiles_backup/`.

---

## 📸 Vista Previa

| Terminal + Vim | Tmux |
|----------------|------|
| ![Terminal](https://via.placeholder.com/400x200.png?text=Terminal+%2B+Vim) | ![Tmux](https://via.placeholder.com/400x200.png?text=Tmux) |

---

## 🤝 Contribuciones

Siéntete libre de abrir un Issue o Pull Request si quieres compartir mejoras o agregar nuevas configuraciones.

```bash
git checkout -b mejora-configuracion
git commit -m "Agrega mejoras a zshrc"
git push origin mejora-configuracion
```

---

## 📜 Licencia

MIT License. Puedes usar, copiar, modificar y compartir libremente.

> ⚠️ **Nota:** Estos dotfiles están pensados para uso personal. Úsalos bajo tu propio riesgo.  
> Es recomendable revisar cada archivo antes de aplicar en tu sistema.

```
MIT License

Copyright (c) 2025 [Tu Nombre]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated configuration files (the "Dotfiles"), to deal
in the Dotfiles without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Dotfiles, and to permit persons to whom the Dotfiles are
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Dotfiles.

THE DOTFILES ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE DOTFILES OR THE USE OR OTHER DEALINGS IN
THE DOTFILES.
```

---

## 📬 Contacto

- 🐙 GitHub: [@tuusuario](https://github.com/tuusuario)
- 🌐 Web: [tuweb.dev](https://tuweb.dev)
- ✉️ Email: tuemail@ejemplo.com

> _Hecho con 💻 y ☕ por [Tu Nombre]_
