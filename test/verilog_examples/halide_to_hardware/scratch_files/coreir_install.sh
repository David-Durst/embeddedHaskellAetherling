# Uncomment one of the following lines to choose your OS
export OS_NAME="linux"
# export OS_NAME="osx"

# Fetch the latest release from GitHub
curl -s -L https://github.com/rdaly525/coreir/releases/latest | grep "href.*coreir-${OS_NAME}.tar.gz" | cut -d \" -f 2 | xargs -I {} wget https://github.com"{}"

# Unpack and install
mkdir coreir_release;
tar -xf coreir-${OS_NAME}.tar.gz -C coreir_release --strip-components 1;
cd coreir_release && make install && cd ..

