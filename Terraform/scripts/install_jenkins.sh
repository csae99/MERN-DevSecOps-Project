#!/bin/bash
set -e

# Update and install dependencies
sudo apt-get update -y
sudo apt-get install -y openjdk-11-jdk curl gnupg unzip docker.io

# Install Jenkins
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y jenkins

# Enable and start services
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ubuntu
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Install Trivy
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh
sudo mv trivy /usr/local/bin/

# Install Sonar Scanner (Optional for demo)
sudo mkdir -p /opt/sonar
cd /opt/sonar
wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip
unzip sonar-scanner-cli-*.zip
sudo ln -s /opt/sonar/sonar-scanner-*/bin/sonar-scanner /usr/local/bin/sonar-scanner

echo "Jenkins setup completed."
