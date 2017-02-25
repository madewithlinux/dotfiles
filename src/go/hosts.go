package main

import (
	"bufio"
	"flag"
	"fmt"
	"net/http"
	"os"
	"strings"
	"sync/atomic"
)

func main() {
	linesChannel := make(chan string, 1024*10)
	urlFilePath := flag.String("urls", "urls.txt", "file containing urls to download")
	urls := readLines(*urlFilePath)
	fmt.Fprintln(os.Stderr, urls, "\n")
	var downloadsRemaining int64 = int64(len(urls))

	for _, url := range urls {
		go downloadHostsFile(url, linesChannel, &downloadsRemaining)
	}

	lines := collectLines(linesChannel)
	for line, _ := range lines {
		fmt.Println("0.0.0.0", line)
	}
}

func downloadHostsFile(url string, outChannel chan<- string, downloadsRemaining *int64) {
	resp, err := http.Get(url)

	if err != nil {
		fmt.Println("Failed to download", url, err)
	} else {

		defer resp.Body.Close()
		scanner := bufio.NewScanner(resp.Body)
		for scanner.Scan() {
			line := scanner.Text()
			// skip comments
			if strings.HasPrefix(line, "#") {
				continue
			}
			// skip other garbage
			if !(strings.HasPrefix(line, "0.0.0.0") ||
				strings.HasPrefix(line, "127.0.01") ||
				strings.HasPrefix(line, "::1")) {
				continue
			}
			// trim any kind of prefix
			for _, prefix := range []string{"127.0.0.1", "0.0.0.0", "::1"} {
				line = strings.TrimPrefix(line, prefix)
			}
			// finally, trim whitespace
			line = strings.TrimSpace(line)
			// send line to line-globber
			outChannel <- line
		}

	}
	// decrement the remaining counter, and check if we shall close the counter
	atomic.AddInt64(downloadsRemaining, -1)
	if atomic.LoadInt64(downloadsRemaining) == 0 {
		close(outChannel)
	}
}

func collectLines(inChannel <-chan string) (output map[string]bool) {
	output = make(map[string]bool, 1024*1024*100)
	for line := range inChannel {
		output[line] = true
	}
	return
}

func readLines(filePath string) (output []string) {
	file, err := os.Open(filePath)
	if err != nil {
		panic(err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		if strings.HasPrefix(scanner.Text(), "#") {
			continue
		}
		if len(scanner.Text()) == 0 {
			continue
		}
		output = append(output, strings.TrimSpace(scanner.Text()))
	}
	return
}
