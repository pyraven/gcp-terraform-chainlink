curl -sSL https://get.docker.com/ | sh
sudo usermod -aG docker $USER
sudo docker pull ethereum/client-go:latest