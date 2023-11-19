#!/bin/bash
#Ruleta de casino, demuestra que la casa siempre gana, usando tecnica martingala y labroucherInversa
#Autor: JuanGarcia (aka.github. liandd)
##Colours
greenColour="\e[0;32m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m"
blueColour="\e[0;34m"
yellowColour="\e[0;33m"
purpleColour="\e[0;35m"
turquoiseColour="\e[0;36m"
grayColour="\e[0;37m"

#Ctrl + C
trap ctrl_c INT

function ctrl_c(){
  echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
  tput cnorm && exit 1
}

function helpPanel(){
  echo -e "\n\n${yellowColour}[+]${endColour}${grayColour} Uso:${endColour}${purpleColour} $0${endColor}\n"
  echo -e "\t${blueColour}-m)${endColour}${grayColour} Dinero con el que se desea jugar${endColour}"
  echo -e "\t${blueColour}-t)${endColour}${grayColour} Técnica a utilizar ${endColour}${purpleColour}(${endColour}${yellowColour}martingala${endColour}${blueColour}/${endColour}${yellowColour}inverseLabrouchere${endColour}${purpleColour})${endColour}\n"
  exit 1
}

function martingala(){
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero actual: ${endColour}${yellowColour}$money€${endColour}"
  echo -ne "${yellowColour}[+]${endColour}${grayColour} ¿Cuánto dinero tienes pensado apostar? -> ${endColour}" && read initial_bet
  echo -ne "${yellowColour}[+]${endColour}${grayColour} ¿A qué deseas apostar continuamente (par/inpar)? -> ${endColour}" && read par_impar

  backup_bet=$initial_bet
  play_counter=1
  jugadas_malas=""
  c_max=$initial_bet
  tput civis
  while true; do
    money=$(($money-$initial_bet))
    random_number="$(($RANDOM % 37))"

    if [ ! "$money" -lt 0  ]; then
      if [ "$par_impar" == "par" ]; then
        if [ "$(($random_number % 2))" -eq 0 ]; then
          if [ $random_number -eq 0 ]; then
            initial_bet=$((initial_bet*2))
            jugadas_malas+="$random_number "
          else
            reward=$(($initial_bet*2))
            money=$(($money+$reward))
            if [ $money -gt $c_max ]; then
              c_max=""
              c_max+="$money"
            fi
            initial_bet=$backup_bet
            jugadas_malas=""
          fi
        else
          initial_bet=$((initial_bet*2))
          jugadas_malas+="$random_number "
        fi
      else
        if [ "$(($random_number % 2))" -eq 1 ]; then
          reward=$(($initial_bet*2))
          money=$(($money+$reward))
          if [ $money -gt $c_max ]; then
            c_max=""
            c_max+="$money"
          fi
          initial_bet=$backup_bet
          jugadas_malas=""
        else
          initial_bet=$((initial_bet*2))
          jugadas_malas+="$random_number "
        fi
      fi
    else
      echo -e "\n${redColour}[!] Ya no hay dinero para jugar.\n"
      echo -e "${yellowColour}[+]${endColour}${grayColour} Han habido un total de ${endColour}${yellowColour}$(($play_counter-1))${endColour}${grayColour} jugadas${endColour}"
      echo -e "${yellowColour}[+]${endColour}${grayColour} A continuación se van a mostrar las malas jugadas consecutivas que han salido:${endColour}\n"
      echo -e "${blueColour}[ $jugadas_malas]${endColour}"
      echo -e "${yellowColour}[+]${endColour}${grayColour} La cantidad máxima ganada ha sido: ${endColour}${greenColour}$c_max${endColour}\n"
      tput cnorm; exit 0
    fi
    let play_counter+=1
  done
  tput cnorm
}

while getopts "m:t:h" arg; do
  case $arg in:
    m) money=$OPTARG;;
    t) technique=$OPTARG;;
    h) helpPanel;;
  esac
done

if [ $money ] && [ $technique ]; then
  if [ "$technique" == "martingala" ]; then
    martingala
  elif [ "$technique" == "inverseLabroucher" ]; then
    inverseLabroucher
  else
    echo -e "\n${redColour}[+] La tecnica introducida no existe.${endColour}"
    helpPanel
  fi 
else
  helpPanel
fi