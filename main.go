package main

import (
	"fmt"
	"net/http"
	"os"
)

func main() {
	mux := http.NewServeMux()
	mux.HandleFunc("/", handler)
	mux.HandleFunc("/health", healthHandler)

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	fmt.Printf("listening on :%s\n", port)
	http.ListenAndServe(":"+port, mux)
}

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello from PikoCI demo!")
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	fmt.Fprintf(w, "ok")
}
