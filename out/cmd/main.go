package main

import (
	"fmt"
	"io/ioutil"
	"os"

	"github.com/pivotal-cf/email-resource/out"
)

var (
	//VERSION -
	VERSION string
)

func main() {
	sourceRoot := os.Args[1]
	inbytes, err := ioutil.ReadAll(os.Stdin)
	if err != nil {
		fmt.Fprintln(os.Stderr, err.Error())
		os.Exit(1)
	}
	output, err := out.Execute(sourceRoot, VERSION, inbytes)
	if err != nil {
		if output != "" {
			fmt.Fprintln(os.Stderr, output)
		}
		fmt.Fprintln(os.Stderr, err.Error())
		os.Exit(1)
	}
	fmt.Println(output)
}
