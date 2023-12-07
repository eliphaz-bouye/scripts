echo "██████╗ ██████╗ ███████╗██████╗ ███████╗ ██████╗ ███████╗    ██╗   ██╗ █████╗  ██████╗ ██████╗  █████╗ ███╗   ██╗████████╗
██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔════╝██╔═══██╗██╔════╝    ██║   ██║██╔══██╗██╔════╝ ██╔══██╗██╔══██╗████╗  ██║╚══██╔══╝
██████╔╝██████╔╝█████╗  ██████╔╝█████╗  ██║   ██║███████╗    ██║   ██║███████║██║  ███╗██████╔╝███████║██╔██╗ ██║   ██║
██╔═══╝ ██╔══██╗██╔══╝  ██╔══██╗██╔══╝  ██║▄▄ ██║╚════██║    ╚██╗ ██╔╝██╔══██║██║   ██║██╔══██╗██╔══██║██║╚██╗██║   ██║
██║     ██║  ██║███████╗██║  ██║███████╗╚██████╔╝███████║     ╚████╔╝ ██║  ██║╚██████╔╝██║  ██║██║  ██║██║ ╚████║   ██║
╚═╝     ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝ ╚══▀▀═╝ ╚══════╝      ╚═══╝  ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝
                                                                                                                	"
GREEN='\033[0;32m'
NC='\033[0m'
WHITE='\033[0;37m'

failed_or_ok(){
    if [ $? -ne 0 ]; then
        echo "\nFAILED"
    else
        echo -e "\n${GREEN}OK${NC}"
    fi
}

# Spinner
spinner=( Ooooo oOooo ooOoo oooOo ooooO )

copy(){
    spin &
    pid=$!

    for i in `seq 1 10`
    do
        sleep 1
    done

    kill $pid
    #echo ""
}

spin(){
    while [ 1 ]
    do
        for i in "${spinner[@]}"
        do
            echo -ne "\r$i"
            sleep 0.2
        done
    done
}

loader(){
    PID=$!
    i=1
    sp="/-\|"
    while [ -d /proc/$PID ]
    do
        printf "\b${sp:i++%${#sp}:1}"
    done
}

echo "Get virtual box repository on Fedora"
ovb='oracle_vbox_2016.asc'
if [ -e $ovb ]; then
    echo "Already exist."
    echo -e "${GREEN}SKIP${NC}"
else
    get_vb=$(wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc)
    failed_or_ok
fi

echo "Import oracle_vbox in local fedora repo"
if [ -e $ovb ]; then
    echo "Already exist."
    echo -e "${GREEN}SKIP${NC}"
else
    sudo rpm --import oracle_vbox_2016.asc
    failed_or_ok
fi

echo "Installing VirtualBox"
if yum list installed "VirtualBox" > /dev/null 2>&1; then
    echo -e "${GREEN}SKIP${CN}"
else
    sudo dnf install VirtualBox -y -q &
    loader
    failed_or_ok
    echo "Add user to vboxusers groups"
    sudo groupadd vboxusers
    sudo usermod -aG vboxusers "$USER"
fi

echo -e "${WHITE}Add dependancies DNF plugins core${NC}"
sudo dnf install -y dnf-plugins-core &
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo &
loader
failed_or_ok

# Install Vagrant
echo "Install Vagrant"
sudo dnf -y install vagrant -y -q &
loader
failed_or_ok
echo "ALL FINE PLEASE REBOOT TO APPLY CHANGES"
