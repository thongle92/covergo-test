TF_DIR := terraform/
CHART_APP_DIR := charts/app1/
CHART_NGINX_DIR := charts/nginx1/
TAG_IMG := 1.0.1

up:
	cd $(TF_DIR) && \
    terraform init && \
    terraform apply
deploy:
	@echo "Docker Build"
	docker build ./app1 --platform linux/arm64 --tag covergo/app1:$(TAG_IMG)
	@echo "Install calico"
	kind load docker-image covergo/app1:$(TAG_IMG) --name new
	@echo "Install calico"
	kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
	@echo "Deploy app1"
	helm install app1 $(CHART_APP_DIR)
	@echo "Deploy nginx1"
	helm install nginx1 $(CHART_NGINX_DIR)
	@echo "Apply NetworkPolicy"
	kubectl apply -f network.yaml

down:
	@echo "Destroy all"
	kubectl delete -f https://docs.projectcalico.org/manifests/calico.yaml
	helm uninstall app1
	helm uninstall nginx1
	kubectl delete -f network.yaml
	cd $(TF_DIR) && \
    terraform destroy

