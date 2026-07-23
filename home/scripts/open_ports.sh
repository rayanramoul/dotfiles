# Sunshine (game streaming)
sudo ufw allow 48000/tcp comment 'Sunshine'
sudo ufw allow 48000/udp comment 'Sunshine'
sudo ufw allow 48010/tcp comment 'Sunshine'
sudo ufw allow 48010/udp comment 'Sunshine'
sudo ufw allow 47984,47989,47990,48010/tcp comment 'Sunshine'
sudo ufw allow 47998,47999,48000,48002/udp comment 'Sunshine'

# Wayland screen sharing
sudo ufw allow 1714:1764/tcp
sudo ufw allow 1714:1764/udp

# llama-server (LAN access for Hermes fallback)
sudo ufw allow from 192.168.1.0/24 to any port 18081 proto tcp comment 'llama-server'

sudo ufw reload && sudo ufw status verbose
