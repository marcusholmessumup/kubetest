from alpine

run addgroup -S webserver && adduser -S webserver -G webserver

user webserver

workdir /kubetest

copy kubetest.linux.bin /kubetest/kubetest.linux.bin

expose 8080

entrypoint ["/kubetest/kubetest.linux.bin"]
