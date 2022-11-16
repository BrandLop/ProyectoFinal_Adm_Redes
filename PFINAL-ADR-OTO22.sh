#!/bin/bash

clear
usuario=$(whoami)
if [ "$usuario" = "root" ]; then
	echo "Bienvenido
	
	1 -> Gestion de Usuarios
	2 -> Gestion de Grupos
	3 -> Mostrar Procesos
	4 -> Ver Tareas Pendientes
	5 -> Realizar Respalndos
	6 -> Realizar Monitoreo
       	7 -> Salir"
	read -p "Ingrese la opcion de la operacion: " op
	echo ""

	case $op in
		1)
			clear
			echo "--- MENU GESTION DE USUARIOS ---
			
			1) Crear usuario
			2) Modificar usuario
			3) Eliminar usuario
			4) Regresar"
			read -p "Ingrese una opcion: " op2
			case $op2 in
				1)
					read -p "Nombre de usuario: " nom
					useradd $nom
					echo "Usuario $nom creado"
					;;
				2)	echo "¿Que desea modificar?
						1) Nombre de usuario
						2) Grupo al que pertenece
						3) Carpeta HOME
						4) Contraseña
						5) Vencimiento de contraseña
						6) Forzar cambio de contraseña
						7) Bloquear usuario
						8) Reactivar usuario
						9) Caducidad de la cuenta de usuario"
					read -p ": " op
					case $op in
						1)
							read -p "Nombre de usuario: " nom
							read -p "Nuevo nombre de usuario: " nom2
							usermod -l $nom2 $nom
							;;
						2)
							read -p "Nombre de usuario: " nom
							read -p "Nombre de grupo: " grupo
							usermod -G $grupo
							;; 
						3)
							read -p "Nombre de usuario: " nom
							read -p "Nombre de carpeta home: " carpeta
							usermod -d /home/$carpeta $nom
							;;
						4)
							read -p "Nombre de usuario: " nom
							passwd $nom
							;;
						5)
							read -p "Nombre de usuario: " nom
							read -p "Dias: " dias
							chage -m $dias -M $dias $nom
							;;
						6)
							read -p "Nombre de usuario: " nom
							chage -d 0 $nom
							;;
						7)
							read -p "Nombre de usuario: " nom
							usermod -L $nom
							;;
						8)
							read -p "Nombre de usuario: " nom
							usermod -U $nom
							;;
						9)
							read -p "Nombre de usuario: " nom
							read -p "Dia: " dia
							read -p "Mes: " mes
							read -p "Anio: " anio
							echo "hola $anio$mes$dia $nom"
							chage -E $anio$mes$dia $nom
							;;
						*)echo "Opcion no reconocida"
					esac
					;;
				3)	read -p "Nombre de usuario: " nom
					userdel -r $nom
					echo "Usuario $nom eliminado"
					;;
				*) echo "Introdujo una operacion incorrecta"
			esac	
	esac
else
	echo "No has ingresado como Usuario root"
	exit
fi
