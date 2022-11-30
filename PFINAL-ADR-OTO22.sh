#!/bin/bash
main_menu() {
  echo "          Bienvenido

  1 -> Gestion de Usuarios
  2 -> Gestion de Grupos
  3 -> Mostrar Procesos
  4 -> Ver Tareas Pendientes
  5 -> Realizar Respaldos
  6 -> Realizar Monitoreo
  7 -> Salir"
  read -p "Seleccione una opcion: " op
  echo ""
  return $op
}

user_list() {
  echo " --- Usuarios Existentes ---"
  getent passwd {1000..1200} | cut -d: -f1
  echo ""
}

group_list() {
  echo " --- Grupos Existentes ---"
  getent group {1000..1200} | cut -d: -f1
  echo ""
}

user_management_menu() {
  echo "--- MENU GESTION DE USUARIOS ---
  1) Crear usuario
  2) Modificar usuario
  3) Eliminar usuario
  4) Regresar"
  read -p "Seleccione una opcion: " op2
  echo ""
  return $op2
}

user_modify_menu() {
  echo "¿Que desea modificar?
  1) Nombre de usuario
  2) Grupo asignado
  3) Carpeta HOME
  4) Contraseña
  5) Vencimiento de contraseña
  6) Forzar cambio de contraseña
  7) Bloquear usuario
  8) Reactivar usuario
  9) Caducidad de la cuenta de usuario
  10) Regresar"
  read -p ": " op
  echo ""
  return $op
}

group_menu() {
  echo "--- GESTION DE GRUPOS ---
  1) Crear grupo
  2) Modificar nombre de grupo
  3) Asignar usuario a un grupo
  4) Eliminar usuarios de un grupo
  5) Eliminar grupo
  6) Regresar"
  read -p "Seleccione una opcion: " op
  echo ""
  return $op
}

process_menu() {
  echo "--- MENU PROCESOS ---
  1) ps
  2) top"
  read -p "Seleccione una opcion: " op
  return $op
}

tareas_menu() {
  echo "--- MENU TAREAS ---
  1) Vista general
  2) Vista por usuario
  3) Regresar"
  read -p "Seleccione una opcion: " op
  return $op
}

backup() {
  read -p "Nombre de usuario que se le realizara un respaldo: " user
  if id "$user" >/dev/null 2>&1; then
    homedir=$(cat /etc/passwd | grep ${user} | cut -d ":" -f6)
    echo "El directorio home del usuario $user es $homedir "
    echo "Creando archivo de respaldo..."
    date=$(date +%F)
    time=$(date +%T)
    tar --force-local -cf ${user}-${date}-${time}.tar $homedir
    sleep 5
    echo "Respaldo completado satisfactoriamente... "
    sleep 3
  else
    echo "Este nombre de usuario no existe en el sistema"
    sleep 2
  fi
  return 0
}

network_monitoring_menu() {
  echo "--- MENU MONITOREO ---
  1) nmap
  2) por_definir xd
  3) Regresar"
  read -p "Seleccione una opcion: " op
  return $op
}

nmap_menu() {
  echo "--- MENU NMAP ---
  1) Escaneo de puertos
  2) Informacion sobre el SO
  3) Información sobre los servicios instalados
  4) Regresar"
  read -p "Seleccione una opcion: " op
  return $op
}

tshark_menu() {
  echo "--- MENU WIRESHARK ---
  1) Escaneo de interfaces disponibles
  2) Captura del trafico de red por identificador de interfaz
  3) Captura del trafico de red por identificador de interfaz y duracion de captura (En segundos)
  4) Captura del trafico de red por identificador de interfaz y numero de paquetes a capturar
  5) Captura del trafico de red por nombre de la interfaz
  6) Captura del trafico de red por nombre de la interfaz y duracion de captura (En segundos)
  7) Captura del trafico de red por nombre de la interfaz y numero de paquetes a capturar
  8) Regresar"
  read -p "Seleccione una opcion: " op
  return $op
}

clear
usuario=$(whoami)
if [ "$usuario" = "root" ]; then
  do=true
  while [ $do = true ]; do
    clear
    main_menu
    case $op in
    1)
      clear
      user_management_menu
      case $? in
      1)
        read -p "Nombre de usuario: " nom
        echo "El Usuario se ha creado correctamente"
        useradd $nom
        ;;
      2)
        user_modify_menu
        case $? in
        1)
          user_list
          read -p "Nombre de usuario a modificar: " nom
          read -p "Nuevo nombre de usuario: " nom2
          echo "Nombre de usuario modificado correctamente..."
          usermod -l $nom2 $nom
          ;;
        2)
          user_list
          read -p "Nombre de usuario: " nom
          echo "El usuario $nom pertenece a los siguientes grupos: "
          id -nG $nom
          echo ""
          echo "1) Agregar usuario a un grupo existente"
          echo "2) Cambiar grupo primario"
          echo "3) Eliminar usuario de un grupo (Distinto del primario)"
          read -p ": " opc
          echo ""
          case $opc in
          1)
            group_list
            read -p "Nombre del grupo a agregar: " group
            usermod -a -G $group $nom
            ;;
          2)
            read -p "Nombre del nuevo grupo primario: " group
            usermod -g $group $nom
            ;;
          3)
            read -p "Nombre del grupo a eliminar: " group
            gpasswd -d $nom $group
            ;;
          esac
          ;;
        3)
          read -p "Nombre de usuario: " nom
          read -p "Nombre de carpeta home: " carpeta
          echo "Se ha cambiado el nombre de la carpeta Home..."
          usermod -d /home/$carpeta $nom
          ;;
        4)
          read -p "Nombre de usuario: " nom
          passwd $nom
          ;;
        5)
          read -p "Nombre de usuario: " nom
          read -p "Dias: " dias
          echo "Se configuro la fecha de vencimiento..."
          chage -m $dias -M $dias $nom
          ;;
        6)
          read -p "Nombre de usuario: " nom
          echo "Listo..."
          chage -d 0 $nom
          ;;
        7)
          read -p "Nombre de usuario: " nom
          echo "Usuario bloqueado..."
          usermod -L $nom
          ;;
        8)
          read -p "Nombre de usuario: " nom
          echo "Listo..."
          usermod -U $nom
          ;;
        9)
          read -p "Nombre de usuario: " nom
          echo "- Indique fecha de vencimiento -"
          read -p "(DD): " dia
          read -p "(MM): " mes
          read -p "(AAAA): " anio
          echo "hola $anio$mes$dia $nom"
          chage -E $anio$mes$dia $nom
          ;;
        *) echo "Opcion no reconocida" ;;
        esac
        ;;
      3)
        user_list
        read -p "Nombre de usuario: " nom
        echo "Usuario eliminado"
        userdel -r $nom
        ;;
      esac
      ;;
    2)
      clear
      group_menu
      case $? in
      1)
        read -p "Nombre de grupo: " nm_group
        echo "El Grupo se ha creado correctamente"
        groupadd $nm_group
        ;;
      2)
        group_list
        read -p "Nombre de grupo: " group
        read -p "Nuevo nombre: " new_group
        echo "Listo..."
        groupmod -n $new_group $group
        ;;
      3)
        group_list
        read -p "Seleccione un Grupo: " nm_group
        echo ""
        user_list
        read -p "Seleccione un Usuario: " user
        echo "El Usuario se agrego al grupo..."
        usermod -a -G $nm_group $user
        ;;
      4)
        group_list
        read -p "Nombre de grupo: " nm_group
        echo "El grupo contiene a los siguientes usuarios"
        getent group $nm_group
        echo ""
        read -p "¿Desea continuar? (s/n): " op
        case $op in
        s)
          read -p "Nombre de usuario a eliminar del grupo: " user
          gpasswd -d $user $nm_group
          ;;
        esac
        ;;
      5)
        group_list
        read -p "Grupo a eliminar: " nm_group
        echo "Grupo eliminado..."
        groupdel $nm_group
        ;;
      *) "Introdujo una operacion incorrecta" ;;
      esac
      ;;
    3)
      process_menu
      case $? in
      1)
        echo ""
        ps
        read -t 7
        echo ""
        ;;
      2)
        top
        ;;
      esac
      ;;
    4)
      tareas_menu
      case $? in
      1)
        echo ""
        echo "-> Tareas programadas en CRON <-"
        cat /var/spool/cron/*
        sleep 7
        ;;
      2)
        echo ""
        user_list
        read -p "Nombre de usuario: " nom
        echo ""
        echo "-> Tareas programadas en CRON <-"
        crontab -u $nom -l
        sleep 7
        ;;
      *) echo "opcion no valida" ;;
      esac
      ;;
    5)
      backup
      ;;
    6)
      echo ""
      network_monitoring_menu
      case $? in
      1)
        echo ""
        nmap_menu
        case $? in
        1)
          read -p 'Ingrese una direccion IP a escanear: ' ip
          echo "Escaneando $ip..."
          nmap $ip
          sleep 7
          ;;
        2)
          read -p 'Ingrese una direccion IP del equipo a obtener info del SO: ' ip
          echo "Escaneando $ip..."
          nmap -A $ip
          sleep 7
          ;;
        3)
          read -p 'Ingrese una direccion IP del equipo a obtener info de sus servicios: ' ip
          echo "Escaneando $ip..."
          nmap -sV $ip
          sleep 7 
          ;;  
        esac
        ;;
      2)
        echo ""
        tshark_menu
        case $? in
        1)
          tshark -D
          sleep 7
          ;;
        esac
        ;;
      3) ;;
      esac
      ;;
    7)
      do=false
      ;;
    esac
  done
else
  echo "No has ingresado como Usuario root :("
  exit
fi
