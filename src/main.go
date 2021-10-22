package main

import (
	"log"
	"net/http"
	"time"
)

var clock bool

func main() {
	go startClock()
	defer stopClock()
	log.Println(startServer().Error())
}

func startServer() error {
	log.Println("starting server on localhost:8080")
	return http.ListenAndServe("0.0.0.0:8080", router())
}

func router() http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		log.Println("serving hello page to ", r.RemoteAddr)
		w.Write([]byte("test server says hello"))
	})
}

func startClock() {
	clock = true
	for clock {
		log.Println("tick")
		time.Sleep(time.Second * 5)
	}
}

func stopClock() {
	clock = false
	log.Println("tock")
}
