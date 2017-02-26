package main

import (
	"bufio"
	"flag"
	"fmt"
	"net/http"
	"os"
	"strings"
	"sync"
	"log"
)

func main() {
	outputPath := flag.String("o", "hosts.txt", "output file")
	urlFilePath := flag.String("i", "urls.txt", "file containing urls to download")
	flag.Parse()

	urls := readLines(*urlFilePath)

	var outFile *os.File
	if *outputPath == "-" {
		outFile = os.Stdout
	} else {
		var err error
		outFile, err = os.OpenFile(*outputPath, os.O_RDWR|os.O_CREATE, 0644)
		if err != nil {
			panic(err)
		}
		defer outFile.Close()
	}

	linesChannel := make(chan []string, 20)
	go downloadHostsFiles(urls, linesChannel)

	printedLines := make(map[string]bool, 1024*1024*100)
	for linesChunk := range linesChannel {
		for _, line := range linesChunk {
			if !printedLines[line] {
				printedLines[line] = true
				fmt.Fprintln(outFile, "0.0.0.0", line)
			}
		}
	}
}

func downloadHostsFiles(urls []string, outChannel chan<- []string) {
	var wg sync.WaitGroup
	wg.Add(len(urls))

	for _, url := range urls {
		go downloadHostsFile(url, &wg, outChannel)
	}

	wg.Wait()
	close(outChannel)
}

func downloadHostsFile(url string, wg *sync.WaitGroup, outChannel chan<- []string) {
	resp, err := http.Get(url)
	lines := make([]string, 1024)
	defer wg.Done()

	if err != nil {
		log.Println("Failed to download", url, err)
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
					strings.HasPrefix(line, "127.0.0.1") ||
					strings.HasPrefix(line, "::1")) {
				continue
			}

			// trim any kind of prefix
			for _, prefix := range []string{"127.0.0.1", "0.0.0.0", "::1"} {
				line = strings.TrimPrefix(line, prefix)
			}
			// finally, trim whitespace
			line = strings.TrimSpace(line)

			lines = append(lines, line)
		}

		// send files on channel in chunks for efficiency
		outChannel <- lines
	}
}

func readLines(filePath string) (output []string) {
	file, err := os.Open(filePath)
	if err != nil {
		panic(err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()

		if strings.HasPrefix(line, "#") {
			continue
		}
		if len(line) == 0 {
			continue
		}
		output = append(output, strings.TrimSpace(line))
	}
	return
}
