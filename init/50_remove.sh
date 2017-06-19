# Fedora-only stuff. Abort if not Fedora.
is_fedora || return 1

sudo dnf -y remove libreoffice* evolution rhythmbox