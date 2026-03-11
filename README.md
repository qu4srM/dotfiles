# 🛠️ Dotfiles de Qu4s4r

![Dotfiles Banner](https://via.placeholder.com/1200x400.png?text=Dotfiles+de+Tu+Nombre)

<p align="center">
  <img src="https://img.shields.io/badge/STATUS-EN%20DESAROLLO-green">
</p>

Estos son mis dotfiles, espero que les guste, utilicé hyprland como gestor de ventanas. Incluye `.zshrc`, `.p10krc`, y más. Perfecto para configurar rápidamente un entorno de desarrollo limpio y productivo.

> [!NOTE]
> Aún faltan algunas cosas, pero ya se puede usar

> [!IMPORTANT]
> Recomendable para Arch Linux

---

## 📸 Capturas de Pantalla

| Vista Principal |
|------------------|
| ![Home](https://github.com/user-attachments/assets/32d49ac5-fe70-49f2-a654-065b06d6f43c) |

| Terminal | Widgets |
|------------------|------------------|
|![Terminal](https://github.com/user-attachments/assets/66dcd6ff-4875-49b8-a924-5c9f0716cf77) | ![Widgets](https://github.com/user-attachments/assets/8fc29fef-777f-4bbd-897e-faac502b52ab)|

| Wallpaper Selector (rofi) | Run Application (rofi) |
|------------------|------------------|
|![wallselector](https://github.com/user-attachments/assets/920db824-802e-414d-8c86-dc2475e29423) | ![run](https://github.com/user-attachments/assets/add43b93-6a75-4505-8eab-10b85891a16e) |

> [!IMPORTANT]
> Lo demás está en desarrollo, wlogout y swaylock, pero se pueden usar sin ningún problema

---

## 📦 Contenido

- 🐚 Shell: `.p10k.zsh`, `.zshrc`
- 📝 Editor: VSCode
- 🔧 Terminal: `kitty`
- 📁 Scripts de instalación y respaldo

---

## Dependencias

- Bun (Recomendado desde su github)
- Powerlevel10k (desde su github)

### Arch Linux

```bash
sudo pacman -S hyprland grim slurp zsh hyprpicker bc acpi swww mplayer imagemagick wl-clipboard playerctl code rofi-wayland fastfetch kitty noto-fonts qt6-wayland qt6-base xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-wlr pavucontrol brightnessctl pamixer net-tools mpc papirus-icon-theme ttf-fira-code ttf-cascadia-code twolame dart-sass grim slurp python-pipx
```

### AUR

```bash
yay -S cava nerd-fonts aylurs-gtk-shell-git ttf-ms-win11-auto wlogout ttf-google-fonts-git swaylock-effects zsh-syntax-highlighting zsh-autosuggestions
```

---

## 🚀 Instalación

```bash
# 1. Clona el repositorio
git clone https://github.com/Qu4s4rM/dotfiles.git

# 2. Entra al directorio
cd dotfiles

# 3. Asigna permisos de ejecución al script
chmod +x install.sh

# 4. Ejecuta el script
./install.sh

# 5. Elimina el repositorio clonado
cd ..
rm -rf dotfiles
```

### 🖼️ Instalación de Rembg (para wallpapers con efecto de profundidad)

rembg se usa para eliminar fondos de imágenes y generar el efecto de depth overlay en los wallpapers.

📦 Instalación en Arch Linux
```
# 1. Instalar pipx (gestor de entornos para apps de Python)
sudo pacman -S python-pipx

# 2. Instalar rembg con pipx
pipx install rembg

# 3. Asegurar que ~/.local/bin está en tu PATH
pipx ensurepath
```
🛠️ Dependencias adicionales
Algunas versiones de rembg requieren: 
```
~/.local/share/pipx/venvs/rembg/bin/python -m pip install onnxruntime
```




---

## ⚙️ Personalización

Está en desarrollo la forma de personalizarlo al antojo, se pueden modificar los archivos dentro de `home/` o `configs/` según lo que tu quieras.

También es necesario compilar los shaders de qt, para ello se utiliza: 
```
/usr/lib/qt6/bin/qsb 
```

---

## 🔁 Respaldo

Este script guarda los archivos que tenias anteriormente en `~/dotfiles_backup/`.

## 🤝 Contribuciones

Dale like al repositorio.

---

## 📜 Licencia

MIT License. Puedes usar, copiar, modificar y compartir libremente.

> [!CAUTION]
> Estos dotfiles están pensados para uso personal. Úsalos bajo tu propio riesgo.
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

- 🐙 GitHub: [@Qu4s4rM](https://github.com/Qu4s4rM)
- 🌐 Web: [tuweb.dev](https://tuweb.dev)
- ✉️ Email: tuemail@ejemplo.com

> _Hecho con 💻 y ☕ por Qu4s4r_
