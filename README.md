# covergo-test
## Implement
This Makefile has been tested and works well on MacOS with the following requirements:
- Install [KIND](https://kind.sigs.k8s.io/docs/user/quick-start#installing-with-a-package-manager)
- Install [Docker](https://docs.docker.com/desktop/install/mac-install/)
- Install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/)
- Install [go](https://go.dev/dl/)
- Install [terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli#install-terraform)

Create cluster
```
make up              
cd terraform/ && \
    terraform init && \
    terraform apply

Initializing the backend...

Initializing provider plugins...
- Finding tehcyx/kind versions matching "~> 0.0.19"...
- Installing tehcyx/kind v0.0.19...
- Installed tehcyx/kind v0.0.19 (self-signed, key ID 15BD4444F5DB9E44)

Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/cli/plugins/signing.html

...
```
Deploy application
```
make deploy 
Docker Build
docker build ./app1 --platform linux/arm64 --tag covergo/app1:1.0.1
[+] Building 3.4s (8/8) FINISHED                                               
```
Clear all
```
make down                                            
Destroy all
kubectl delete -f https://docs.projectcalico.org/manifests/calico.yaml
poddisruptionbudget.policy "calico-kube-controllers" deleted
serviceaccount "calico-kube-controllers" deleted

```

## Design a multi-stage deployment pipeline
- Propose a solution for the app1 multi-stage release pipeline.
- Draw a principal diagram and add the required description.

Refer [here](https://github.com/thongle92/covergo-test/blob/main/docs/Scenario4.md)