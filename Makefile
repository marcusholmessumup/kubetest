build:
	env GOOS=linux go build -o kubetest.linux.bin ./src
	go build -o kubetest.darwin.bin ./src

deploy:
	docker build -t kubetest .
	docker run -d --publish 8081:8080 --name kubetest_runner kubetest

kill_all:
	-docker container stop kubetest_runner
	-docker container rm kubetest_runner
	docker image rm kubetest

start_pod:
	-minikube start
	eval $(minikube docker-inv);docker build -t kubetest .
	kubectl run kubetest-run --image=kubetest --image-pull-policy=Never

kill_pod:
	kubectl delete pod kubetest-run