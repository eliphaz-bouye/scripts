GREEN='\033[0;32m'
NC='\033[0m'

# Get CFSSL & CFSSLJSON
mkdir -p run # Create run directory to save binary to will run
echo
echo "Downloading CFSSL"
wget_cfssl=$(wget -q --show-progress --https-only --timestamping https://github.com/cloudflare/cfssl/releases/download/v1.6.4/cfssl_1.6.4_linux_amd64 -O run/cfssl)

if [ $? -ne 0 ]; then
    echo "Download failed"
    exit 1;
else
    echo -e "${GREEN}OK${NC}"
fi

echo "Downloading CFSSL"
wget_cfssljson=$(wget -q --show-progress --https-only --timestamping https://github.com/cloudflare/cfssl/releases/download/v1.6.4/cfssljson_1.6.4_linux_amd64 -O run/cfssljson)
if [ $? -ne 0 ]; then
    echo "Download failed"
    exit 1;
else
    echo -e "${GREEN}OK${NC}"
fi
