#!/bin/bash
#

function copia(){
  
  # Wallpaper
  
  mkdir ~/Wallpaper
  cp $ruta/dotfiles/Walpaper/tron_legacy1.jpg ~/Wallpaper/
  
  #polybar
  mkdir ~/.config/polybar
  cp -rv $ruta/dotfiles/polybar/* ~/.config/polybar/
  chmod +x ~/.config/polybar/launch.sh
  chmod +x ~/.config/polybar/scripts/playerctl.sh
  chmod +x ~/.config/polybar/scripts/playerctl_label.sh

  # Picom
  mkdir ~/.config/picom
  cp -rv $ruta/dotfiles/picom/* ~/.config/picom


# kitty
  mkdir ~/.config/kitty
  cp -rv $ruta/dotfiles/kitty/* ~/.config/kitty/
  
  # zsh
  sudo usermod --shell /usr/bin/zsh $usermod
  sudo usermod --shell /usr/bin/zsh root
  cp -rv $ruta/dotfiles/.zshrc ~/
  sudo ln -sf ~/.zshrc /root/.zshrc


  #Powerlevel10k
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
  sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/powerlevel10k
  cp -rv $ruta/dotfiles/.p10k.zsh ~/
  sudo cp -rv $ruta/dotfiles/.p10k-root.zsh /root/.p10k.zsh
  
  #Rofi
  mkdir ~/.config/rofi
  cp -rv $ruta/dotfiles/rofi/* ~/.config/rofi/  
  chmod +x ~/.config/rofi/powermenu/powermenu  

  #Plugin sudo 
  cd /usr/share 
  sudo mkdir zsh-sudo 
  sudo chown $USER:$USER zsh-sudo/
  cd zsh-sudo
  wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh

  #Betterlockscreen
  betterlockscreen -u ~/Wallpaper/tron_legacy1.jpg blur

  # SDDM
   # sddm (Aviso! En este caso se deshabilita lightdm ya que xfce4 utiliza este session manager. En caso de que tu sistema utilice uno distinto, deberás hallarlo y desactivarlo.)
    # Puedes encontrarlo empleando la siguiente comanda: sudo loginctl show-session $XDG_SESSION_ID
    service=$(sudo loginctl show-session $XDG_SESSION_ID | awk -F= '/Service/ {print $2}')
    sudo systemctl disable $service
    sudo systemctl enable sddm
    #sudo cp -rv "$1/dotfiles/sddm/wallpaper.jpg" "/usr/share/sddm/themes/Sugar-Candy/Backgrounds/"
    #sudo cp -rv "$1/dotfiles/sddm/theme.conf" "/usr/share/sddm/themes/Sugar-Candy/"
    #sudo cp -rv "$1/dotfiles/sddm/sddm.conf" "/etc/"

  #Descargando fuentes necesarias
  cd /usr/share/fonts/
  sudo megadl --print-names 'https://mega.nz/file/GxFVSLLY#etuNc6QRrEl6wgl_ZatvomojDhkBTFPqlKS7ELk7KAM'
  sudo unzip fonts.zip
  sudo rm -rf fonts.zip

  #Bspwm & Sxhkd
  mkdir ~/.config/bspwm/
  mkdir ~/.config/sxhkd/
  cp -rv $ruta/dotfiles/bspwm/* ~/.config/bspwm/
  cp -rv $ruta/dotfiles/sxhkd/* ~/.config/sxhkd/
  cd ~/.config/bspwm/
  chmod +x bspwmrc
  cd scripts
  chmod +x bspwm_resize
 
}

function necesarios(){
  #Update
  sudo pacman -Syu --noconfirm

  # Instalar SDDM 
  sudo pacman -S sddm --noconfirm

  sudo pacman -S bspwm sxhkd polybar kitty zsh wget rofi xorg-xrandr picom git unzip zsh lsd bat feh dash xorg-xsetroot zsh-autosuggestions zsh-syntax-highlighting polkit-gnome megatools playerctl qemu-full libvirt iptables openbsd-netcat dmidecode virt-manager timeshift pavucontrol  --noconfirm

# Yay
cd ~/
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ..
sudo rm -r yay

yay -S google-chrome spotify betterlockscreen --noconfirm

}

function finalizar(){
  echo "A terminado la instalación"
  notify-send "Instalación finalizada"
  sleep 1
  notify-send "3"
  sleep 1
  notify-send "2"
  sleep 1
  notify-send "1"
  sleep 1
  notify-send "Reboot.."
  sleep 1
  reboot
}

if [ $(whoami) != 'root' ]; then
    ruta=$(pwd)
    necesarios
    #paquetes
    copia "$ruta"
    #betterlockscreen "$ruta"
    finalizar
else
    echo 'Error, el script no debe ser ejecutado como root.'
    exit 0
fi

