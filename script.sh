#!/bin/bash

# Comprobación de permisos de superusuario
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, ejecuta este script como root o usando sudo."
  exit 1
fi

echo "Actualizando repositorios y paquetes..."
sudo apt update && apt upgrade -y
sudo apt-get update && apt-get upgrade -y
# Instalación de Docker
echo "Instalando Docker..."
# Add Docker's official GPG key:
sudo apt-get update -y
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

#Post-Install Docker
sudo groupadd docker
sudo usermod -aG docker $USER

sudo apt-get update -y

# Instalación de Nginx
echo "Instalando Nginx..."
sudo apt-get update -y
sudo apt-get install nginx -y
sudo nginx -v


# sudo sed -i 's/^user.*/#&/' /etc/nginx/nginx.conf
# sudo chown -R www-data:www-data /var/log/nginx
# sudo chmod -R 755 /var/log/nginx

sudo chmod a+w /var/log/nginx/*.log

# sudo systemctl start nginx
# sudo systemctl enable nginx


echo "Nginx instalado y configurado."

# Configuración de Nginx como proxy inverso
echo "Configurando Nginx como proxy inverso..."

sudo bash -c 'cat <<EOL > /etc/nginx/sites-available/default
server {
    listen 80;

    server_name localhost;

    location /app-1 {
        proxy_pass http://127.0.0.1:8080/;  # Asegúrate de que la URL sea correcta
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }

    location /app-2 {
        proxy_pass http://127.0.0.1:8081/;  # Asegúrate de que la URL sea correcta
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }

}
EOL'

echo "Verificando la configuración de Nginx..."
nginx -t

if [ $? -ne 0 ]; then
  echo "Error en la configuración de Nginx. Por favor, revisa los logs."
  exit 1
fi

echo "Reiniciando Nginx para aplicar los cambios..."
systemctl restart nginx

echo "Instalación y configuración completa."
