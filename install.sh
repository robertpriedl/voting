sudo yum update -y
sudo yum install -y tar gzip
wget https://github.com/PowerShell/PowerShell/releases/download/v7.4.1/powershell-7.4.1-linux-arm64.tar.gz
mkdir ~/powershell
tar -xvf powershell-*-linux-arm64.tar.gz -C ~/powershell
sudo ln -s ~/powershell/pwsh /usr/bin/pwsh
sudo yum install -y libicu
