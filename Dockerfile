#from alpine
from gcr.io/distroless/base-debian10

workdir /kubetest

copy kubetest.linux.bin /kubetest/kubetest.linux.bin

expose 8080

user nonroot:nonroot

entrypoint ["/kubetest/kubetest.linux.bin"]
