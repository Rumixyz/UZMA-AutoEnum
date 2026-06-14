#!/bin/bash

# UZMA-AutoEnum v1.0 - 8 Demand HTB Tool

# Demand 1: Auto Nmap + Color Output


TARGET=$1

RED='\033[0;31m'

GREEN='\033[0;32m'

YELLOW='\033[1;33m'

BLUE='\033[0;34m'

NC='\033[0m'


banner() {

echo -e "${BLUE}"

echo "¦¦+ ¦¦+¦¦¦¦¦¦¦+¦¦¦+ ¦¦¦+ ¦¦¦¦¦+ "

echo "¦¦¦ ¦¦¦+--¦¦¦++¦¦¦¦+ ¦¦¦¦¦¦¦+--¦¦+"

echo "¦¦¦ ¦¦¦ ¦¦¦++ ¦¦+¦¦¦¦+¦¦¦¦¦¦¦¦¦¦¦"

echo "¦¦¦ ¦¦¦ ¦¦¦++ ¦¦¦+¦¦++¦¦¦¦¦+--¦¦¦"

echo "+¦¦¦¦¦¦++¦¦¦¦¦¦¦+¦¦¦ +-+ ¦¦¦¦¦¦ ¦¦¦"

echo " +-----+ +------++-+ +-++-+ +-+"

echo -e "${NC}${YELLOW} AutoEnum v1.0 | Built by UZMA ??${NC}"

}


if [ -z "$TARGET" ]; then

banner

echo -e "${RED}[!] Usage: ./uzma-autoenum.sh <IP>${NC}"

exit 1

fi


banner

echo -e "${YELLOW}[+] Target: $TARGET ${NC}"

echo -e "${YELLOW}[+] Demand 1: Starting Auto Nmap...${NC}"


echo -e "${BLUE}[*] Phase 1: Fast TCP scan for all ports...${NC}"

nmap -p- --min-rate 1000 -T4 $TARGET -oG fast.gnmap > /dev/null 2>&1

ports=$(cat fast.gnmap | grep -oP '\d+/open' | cut -d'/' -f1 | tr '\n' ',' | sed s/,$//)


if [ -z "$ports" ]; then

echo -e "${RED}[!] No open ports found${NC}"

exit 1

fi


echo -e "${GREEN}[+] Open ports found: $ports${NC}"

echo -e "${BLUE}[*] Phase 2: Service + Script scan...${NC}"

nmap -sC -sV -p $ports $TARGET -oN nmap_scan.txt


echo -e "${GREEN}[+] Demand 1 COMPLETE ?${NC}"

echo -e "${GREEN}[+] Results saved: nmap_scan.txt${NC}"

echo -e "${YELLOW}[+] Next: Demand 2 Web Enum coming soon...${NC}"




