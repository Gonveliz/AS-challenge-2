## IaC Challenge 2 - Guía y Uso

Está guía tiene como objetivo poder utilizar el codigo de script de [Bash](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest) para automatizar la instalacion de dependencias.

<p align="center">
<img src="/assets/bashlogo.png" width="30%">

## Tabla de contenido
- [IaC Challenge 2 - Guía y Uso](#iac-challenge-2---guía-y-uso)
- [Tabla de contenido](#tabla-de-contenido)
- [Pre-requisitos](#pre-requisitos)
- [Estructura del proyecto](#estructura-del-proyecto)
- [Dependencias que instala](#dependencias-que-instala)
- [Guia de Uso](#guia-de-uso)
- [Verificacion](#verificacion)

## Pre-requisitos
* [Ubuntu como sistema operativo](https://ubuntu.com/)
* [Requerimientos Docker](https://docs.docker.com/desktop/setup/install/windows-install/#system-requirements)

## Estructura del proyecto

```
├── assets
├── default
├── LICENCE
├── README.md
└── script.sh

```


## Dependencias que instala

Actualmente se estan utilizando los siguientes recursos/modulos:
- [Docker](https://docs.docker.com/engine/install/)
- [Nginx](https://nginx.org/en/)

## Guia de Uso

Para utilizar el script en un entorno docker, podemos seguir los siguientes pasos:
1. Crear archivo de `script.sh` en nuestro local:
    `nano script.sh`
2. En este archivo local pegaremos el contenido del archivo con el mismo nombre que se encuentra en este repositorio repositorio [script.sh](https://github.com/Gonveliz/AS-challenge-2/blob/main/script.sh)
3. Una vez pegado el contenido en nuestro archivo local debemos conceder permisos al mismo para poder realizar la ejecucion del script:
   `chmod +x script.sh`
4. Ya concedido los permisos de ejecucion sobre el script podemos ejecutarlo de la siguiente manera:
   `sudo bash script.sh`
5. Una vez realizado, debemos esperar a que finalice el script. 
   
![Script Finalizado](/assets/script_finalizado.png)

## Verificacion

Podemos verificar que las instalaciones se hayan completado y el nginx este correctamente configurado de las siguiente manera:

1. Desplegamos dos conteedores simples:

```
sudo docker run -d --name app1 -p 8080:8000 jdkelley/simple-http-server
sudo docker run -d --name app2 -p 8081:80 httpd
```
2. Realizamos dos curl para verificar el funcionamiento de la configuracion de nginx:

```
curl localhost:80/app-1
curl localhost:80/app-2
```
Esto nos deberia responder de la siguiente manera:

![Verificacion](/assets/verificacion.png)