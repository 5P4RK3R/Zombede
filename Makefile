# Define variables
PORT = 8081
OUTPUT_DIR = output
BROWSER = "Arc"
IP = ${EC2_PUBLIC_IP}
URL = http://$(IP):8080
id ?= id
msg ?= msg
ip ?= $(IP)
pem ?= main.pem
remote ?= /home/ubuntu
local ?= *
platform ?= ubuntu


# Define targets
.PHONY: all install clean run
# Set default targets
default: all

# Default target to set up the environment and run the server
all: run server

# Install dependencies
install:
	npm i

uninstall:
	rm -rf $(modules)

# Clean the project
clean:
	find . -type f -name "*.DS_Store" -delete
	find . -type f -name "*.log" -delete
	find . -type f -name "*.png" -delete
	find . -type f -name "log.html" -delete
	find . -type f -name "report.html" -delete
	find . -type f -name "output.xml" -delete
	find . -type d -name 'target' -exec rm -rf {} +
	chmod +x cleanup.sh
	./cleanup.sh

push:
	git pull
	git commit -m $(msg)
	git push
	git pull

check:
	cargo check

build:
	cargo build
	npm run build

compile:
	rustc	$(file).rs && ./$(file)

doc:
	cargo doc && mdbook build && mdbook serve   
	chmod +x doc.sh
	./doc.sh

# Run the server
run:
	mkdir -p $(OUTPUT_DIR)
	cargo run
	
server:
	mkdir -p $(OUTPUT_DIR)
	npm start 

serve:
	run
	server

# watch:
# 	cargo watch -c "cargo run" -w main.rs --ignore target/ --ignore .git/ -p 100
	
automate:
	ansible-playbook -i ansible/inventory/main.ini ansible/main.yml

dbuild:
	docker build -t taskMaster .

up:
	docker-compose up --build -d

down:
	docker-compose down

load:
	docker load -i taskMaster.tar

start:
	docker build -t taskMaster .
	docker run -p 8081:8081 -p 9001:9001 -d taskMaster
	docker buildx build --platform linux/amd64 -t taskMaster .
	
save:
	docker save -o taskMaster.tar taskMaster:latest 

clist:
	docker ps -a

imglist:
	docker images

clog:
	docker logs	$(id)

rm:
	docker rm	$(id)

stop:
	docker stop	$(id)

rmi:
	docker rmi	$(id)

rmc:
	docker stop	$(id)
	docker rm	$(id)

ec2_stop:
	aws ec2 stop-instances --instance-ids	${id}

ec2_start:
	aws ec2 start-instances --instance-ids	${id}

# Upload files to remote server
upload:
	rsync -avz --exclude="*.pem" --exclude="venv" -e "ssh -i  $(pem)" $(local) $(platform)@$(ip):$(remote)

# upload:
# 	rsync -avz --exclude="*.pem" --exclude="venv" -e "ssh -i  $(pem)" $(local) $(platform)@$(ip):$(remote)

# If you want to provide help or instructions
help:
	@echo "Usage: make [target] [VARIABLE=value]"
	@echo "Targets:"
	@echo "  all        - Install dependencies, run the server, and upload files"
	@echo "  install    - Set up the virtual environment and install dependencies"
	@echo "  clean      - Clean up the project"
	@echo "  run        - Run the server"
	@echo "  kill       - Kill any running twistd server"
	@echo "  server     - Run the server without virtual environment activation"
	@echo "  automate   - Run Ansible playbook"
	@echo "  build      - Build the Docker image"
	@echo "  start      - Start the Docker container"
	@echo "  clist      - List Docker containers"
	@echo "  imglist    - List Docker images"
	@echo "  clog       - View Docker container logs"
	@echo "  rm         - Remove Docker container"
	@echo "  stop       - Stop Docker container"
	@echo "  rmi        - Remove Docker image"
	@echo "  upload     - Upload files to remote server"
	@echo "  help       - Display this help message"
	@echo "Usage: make startapp APP_NAME=<app_name>"
	@echo "Example: make startapp APP_NAME=blog"