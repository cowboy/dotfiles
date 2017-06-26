# Fedora-only stuff. Abort if not Fedora.
is_fedora || return 1

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm -P install/
wget https://downloads.slack-edge.com/linux_releases/slack-2.6.3-0.1.fc21.x86_64.rpm -P install/
wget https://www.dropbox.com/download?dl=packages/fedora/nautilus-dropbox-2015.10.28-1.fedora.x86_64.rpm -P install/
wget http://kdl.cc.ksosoft.com/wps-community/download/a21/wps-office-10.1.0.5672-1.a21.x86_64.rpm -P install/

e_header "Installing Fedora packages: ${packages[*]}"
for f in install/*.rpm
do
  sudo dnf install -y $f
done

packages=(
  php-cli
  phpunit
  composer
  python-pip
  code
  vlc
  vim
)

if (( ${#packages[@]} > 0 )); then
  e_header "Installing Fedora packages: ${packages[*]}"
  for package in "${packages[@]}"; do
    sudo dnf install -y $package
  done
  sudo dnf clean packages
fi

sudo dnf -y update