build:
	env GOOS=linux go build -o kubetest.linux.bin ./src
	go build -o kubetest.darwin.bin ./src

deploy:
	docker build -t kubetest .
	docker run -d --publish 8081:8080 --name kubetest_runner kubetest

check:
	curl localhost:8081
	
kill_all:
	-docker container stop kubetest_runner
	-docker container rm kubetest_runner
	docker image rm kubetest

kube_up:
	-minikube start
	eval $(minikube docker-env);docker build -t kubetest .

start_pod: kube_up
	kubectl run kubetest-run --image=kubetest --image-pull-policy=Never

create_deployment: kube_up
	kubectl create -f kubetest_deployment.yml

create_job:
	kubectl create -f kubetest_job.yml

kill_kube:
	-kubectl delete pod kubetest-run
	-kubectl delete deployment kubetest-deploy
	-kubectl delete job kubetest-job