package main

import (
	"github.com/julienschmidt/httprouter"
	"html/template"
	"log"
	"net/http"
	"os"
)

func main() {
	router := httprouter.New()

	router.ServeFiles("/statics/*filepath", http.Dir(FileGetCurrentDirectory() + "/statics"))

	router.GET("/", homeHandle)

	if err := http.ListenAndServe("localhost:10019", router); err != nil && err != http.ErrServerClosed {
		log.Fatal(err.Error())
	}
}

func homeHandle(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	template, err := template.ParseFiles("template/wasm_exec.html")
	if err != nil {
		log.Fatal(err.Error())
	}

	template.Execute(w, nil)
}

// FileGetCurrentDirectory 获取当前目录
func FileGetCurrentDirectory() string {
	dir, err := os.Getwd()
	if err != nil {
		return ""
	}

	return dir
}