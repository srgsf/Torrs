package main

import (
	"flag"
	"log"
	"os"
	"path/filepath"
	"strconv"
	"torrsru/db/search"
	"torrsru/db/sync"
	"torrsru/web"
	"torrsru/web/global"
)

var version = "unknown"
var port = flag.Int("port", 8094, "port for web")
var db string

func init() {
	pwd := filepath.Dir(os.Args[0])
	pwd, _ = filepath.Abs(pwd)
	global.PWD = pwd
	flag.StringVar(&db, "db", filepath.Join(pwd, "torrents.db"), "data store file")
}

func main() {
	log.Println("torrs version: ", version)
	global.VERSION = version
	flag.Parse()
	log.Println("PWD:", global.PWD)
	sync.Init(db)
	search.UpdateIndex()

	web.Start(strconv.Itoa(*port))
}
