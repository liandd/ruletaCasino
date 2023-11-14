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