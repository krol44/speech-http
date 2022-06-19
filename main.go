package main

import (
	"fmt"
	"log"
	"net/http"
	"net/url"
	"os/exec"
	"strings"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		log.Println("req: ", r.RequestURI)

		vars := strings.Split(r.RequestURI, "/")
		if len(vars) != 3 {
			return
		}

		voice := vars[1]
		text, _ := url.QueryUnescape(vars[2])

		log.Println("text: ", text)

		cmd := exec.Command("/speech.sh", voice, text)

		stdout, err := cmd.Output()
		if err != nil {
			fmt.Println(err.Error())
		}

		fmt.Print(string(stdout))
		fmt.Fprintf(w, "%q", string(stdout))
	})

	err := http.ListenAndServe(":8048", nil)
	if err != nil {
		log.Fatalln(err)
		return
	}
	log.Println("start")
}
