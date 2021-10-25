# build the program (both linux for Docker containers and Mac for localhost)
build:
	env GOOS=linux go build -o kubetest.linux.bin ./src
	go build -o kubetest.darwin.bin ./src

# straight deploy this onto a container
deploy_docker: kill_docker
	docker build -t kubetest .
	docker run -d --publish 8081:8080 --name kubetest_runner kubetest

# check what the server produces - this should work regardless of deployment type
check:
	curl localhost:8080

# drop all the docker stuff ready to go again
kill_docker:
	-docker container stop kubetest_runner
	-docker container rm kubetest_runner
	docker image rm kubetest

# start minikube, set the docker environment to minikube, and build the image in that environment
kube_up: kill_kube
	-minikube start
	eval $(minikube docker-env);docker build -t kubetest .

# run the container inside minikube directly (no yaml) as a pod
start_pod: kube_up
	kubectl run kubetest-run --image=kubetest --image-pull-policy=Never

# create a deployment
create_deployment: kube_up
	kubectl create -f kubetest_deployment.yml

# create a service from the deployment
create_service: create_deployment
	kubectl create -f kubetest_service.yml

# do the port-forward thing to create the service and access it from localhost
#   make check should work after this
kubetest_pf: create_service
	sleep 3s
	kubectl port-forward svc/kubetest-service 8080:8080 &

# drop anything we created in minikube - this should get us back to a clean slate ready to start again
kill_kube:
	-kubectl delete pod kubetest-run
	-kubectl delete deployment kubetest-deploy
	-kubectl delete job kubetest-job
	-kubectl delete service kubetest-service