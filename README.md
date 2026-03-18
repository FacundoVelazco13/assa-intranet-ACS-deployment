# Repositorio de archivos de despliegue en Docker de la implementación de ACS de ASSA

##

### Dev compose

> Configuración para desarrollo y pruebas finales. (Local, no apto para ASSA).
Toma configuración de _commons_

### ASSA compose

> Configuración para despliegue final en ASSA.

Las configuraciones estan basadas en : [Alfresco/acs-deployment](https://github.com/Alfresco/acs-deployment)

---

### DESPLIEGUE para pruebas

> ./run.sh up dev \
> ./run.sh down dev

TODO list para desplegar

- Todas las configuraciones utilizar volumenes externos. Estos deben existir previo a ejecutar _docker compose up_.
Por eso utilizar el script run.sh, que verifica esta creación previamente. _Ingresar en el contenido del script el compose file y nombre de volumenes_
