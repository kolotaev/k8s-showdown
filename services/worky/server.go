package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"sync"
	"time"
)

func main() {
	wg := new(sync.WaitGroup)

	// default route handler
	http.HandleFunc("/", func(res http.ResponseWriter, req *http.Request) {
		fmt.Fprint(res, "Hello. You are from: "+req.RemoteAddr)
	})

	wg.Add(1)
	go func() {
		log.Fatal(http.ListenAndServe("0.0.0.0:9005", nil))
		wg.Done()
	}()

	wg.Add(1)
	go func() {
		for {
			sleep := time.Duration(5)
			time.Sleep(sleep * time.Second)
			log.Printf("Waited %d secs.", sleep)
			resp, err := http.Get(os.Getenv("SELF_ADDR"))
			if err != nil {
				log.Println("error", err)
			} else {
				body, err := ioutil.ReadAll(resp.Body)
				if err != nil {
					log.Println("error", err)
				}
				log.Println("Worker got: " + string(body))
			}
		}
		// wg.Done()
	}()

	log.Println("Serving...")
	wg.Wait()
}
