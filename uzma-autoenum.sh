#!/bin/bash

# UZMA-AutoEnum v1.1 - 8 Demand HTB Tool

# Demand 1: Auto Nmap | Demand 2: Web Enum


TARGET=$1

RED='\033[0;31m'

GREEN='\033[0;32m'

YELLOW='\033[1;33m'

BLUE='\033[0;34m'

PURPLE='\033[0;35m'

NC='\033[0m'


banner() {

echo -e "${BLUE}"

echo "¦¦+ ¦¦+¦¦¦¦¦¦¦+¦¦¦+ ¦¦¦+ ¦¦¦¦¦+ "

echo "¦¦¦ ¦¦¦+--¦¦¦++¦¦¦¦+ ¦¦¦¦¦¦¦+--¦¦+"

echo "¦¦¦ ¦¦¦ ¦¦¦++ ¦¦+¦¦¦¦+¦¦¦¦¦¦¦¦¦¦¦"

echo "¦¦¦ ¦¦¦ ¦¦¦++ ¦¦¦+¦¦++¦¦¦¦¦+--¦¦¦"

echo "+¦¦¦¦¦¦++¦¦¦¦¦¦¦+¦¦¦ +-+ ¦¦¦¦¦¦ ¦¦¦"

echo " +-----+ +------++-+ +-++-+ +-+"

echo -e "${NC}${YELLOW} AutoEnum v1.1 | Built by UZMA ??${NC}"

}


if [ -z "$TARGET" ]; then

banner

echo -e "${RED}[!] Usage: ./uzma-autoenum.sh <IP>${NC}"

exit 1

fi


banner

echo -e "${YELLOW}[+] Target: $TARGET ${NC}"

mkdir -p uzma_results


# DEMAND 1: AUTO NMAP

echo -e "${BLUE}[*] Demand 1: Starting Auto Nmap...${NC}"

nmap -p- --min-rate 1000 -T4 $TARGET -oG uzma_results/fast.gnmap > /dev/null 2>&1

ports=$(cat uzma_results/fast.gnmap | grep -oP '\d+/open' | cut -d'/' -f1 | tr '\n' ',' | sed s/,$//)


if [ -z "$ports" ]; then

echo -e "${RED}[!] No open ports found${NC}"

exit 1

fi


echo -e "${GREEN}[+] Open ports: $ports${NC}"

nmap -sC -sV -p $ports $TARGET -oN uzma_results/nmap_scan.txt

echo -e "${GREEN}[+] Demand 1 COMPLETE ?${NC}"


# DEMAND 2: WEB ENUM

if echo $ports | grep -qE '80|443|8080|8000'; then

echo -e "${PURPLE}[*] Demand 2: Web ports detected! Starting Web Enum...${NC}"


for port in 80 443 8080 8000; do

if echo $ports | grep -q $port; then

if [ "$port" == "443" ]; then

url="https://$TARGET"

else

url="http://$TARGET:$port"

fi


echo -e "${YELLOW}[+] Enumerating $url ${NC}"


echo -e "${BLUE}[*] Running WhatWeb...${NC}"

whatweb $url | tee uzma_results/whatweb_$port.txt


echo -e "${BLUE}[*] Running Gobuster...${NC}"

gobuster dir -u $url -w /usr/share/wordlists/dirb/common.txt -q -o uzma_results/gobuster_$port.txt


echo -e "${BLUE}[*] Running Nikto...${NC}"

nikto -h $url -output uzma_results/nikto_$port.txt > /dev/null 2>&1

fi

done

echo -e "${GREEN}[+] Demand 2 COMPLETE ?${NC}"

else

echo -e "${YELLOW}[!] No web ports found. Skipping Demand 2${NC}"

fi


echo -e "${GREEN}[+] All results saved in: uzma_results/${NC}"

echo -e "${YELLOW}[+] Next: Demand 3 Subdomain Finder...${NC}"





