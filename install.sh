cd /data
sudo yum update -y
sudo yum install -y tar gzip
wget https://github.com/PowerShell/PowerShell/releases/download/v7.4.1/powershell-7.4.1-linux-arm64.tar.gz
mkdir ~/powershell
tar -xvf powershell-*-linux-arm64.tar.gz -C ~/powershell
sudo ln -s ~/powershell/pwsh /usr/bin/pwsh
sudo ln -s /home/ec2-user/powershell/pwsh /usr/bin/pwsh
sudo yum install -y libicu
cd /data/voting
sudo chmod +x /data/voting/start.sh
sudo chown ec2-user:ec2-user /data/voting/start.sh
sudo chmod 775 /data

sudo chmod +x /data/voting/start.sh

sudo cp /data/voting/mystartup.ini /etc/systemd/system/mystartup.service

sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable mystartup.service
sudo systemctl start mystartup.service
