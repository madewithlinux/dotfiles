package main

import (
	"bytes"
	"github.com/atotto/clipboard"
	"os"
	"path"
	"path/filepath"
	"strconv"
	"strings"
)

// header just so that sublime text auto detects the syntax
const header = "#!/usr/bin/env bash\n"

// start with space so commands don't save in bash history
const move = " mv "

// this is just something easy to search for
const fileNamePrefix = "///"

func main() {
	var files []string

	// source from either clipboard or arguments
	// TODO: source from stdin maybe?
	if len(os.Args) > 1 {
		files = os.Args[1:]
	} else {
		text, err := clipboard.ReadAll()
		die(err)
		files = strings.Split(text, "\n")
	}

	// find max length
	maxLen := 0
	for _, v := range files {
		if len(v) > maxLen {
			maxLen = len(v)
		}
	}

	// prepare output
	buf := &bytes.Buffer{}
	buf.WriteString(header)
	for _, v := range files {
		absPath, err := filepath.Abs(v)
		die(err)
		absPath = strconv.Quote(absPath)

		localPath := strconv.Quote(path.Base(v))

		buf.WriteString(move)

		buf.WriteString(absPath)
		buf.WriteString(strings.Repeat(" ", maxLen-len(v)+1))
		buf.WriteString(fileNamePrefix)
		buf.WriteString(localPath)
		buf.WriteString("\n")
	}

	err := clipboard.WriteAll(buf.String())
	die(err)

}

func die(err error) {
	if err != nil {
		panic(err)
	}
}
