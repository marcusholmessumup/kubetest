package main

import (
	"fmt"
	"log"
	"net/http"
	"time"
)

const port = "8081"
const address = "0.0.0.0"

func main() {
	startServer()
}

func startServer() error {
	log.Println("starting server on localhost:8080")
	addr := fmt.Sprintf("%s:%s", address, port)
	return http.ListenAndServe(addr, router())
}

func router() http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		result := time.Now().Format(time.RubyDate)
		log.Printf("serving %s to %s\n", result, r.RemoteAddr)
		w.Write([]byte(result))
	})
}
