package main

import (
	"bufio"
	"flag"
	"fmt"
	"github.com/gosuri/uiprogress"
	"log"
	"math"
	"net/http"
	"os"
	"strings"
	"sync"
)

func main() {
	outputPath := flag.String("o", "hosts.txt", "output file")
	urlFilePath := flag.String("i", "urls.txt", "file containing urls to download")
	showProgress := flag.Bool("p", false, "show multi-progress bar")
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
	go downloadHostsFiles(urls, linesChannel, *showProgress)

	printedLines := make(map[string]bool, 1024*1024*10)
	for linesChunk := range linesChannel {
		for _, line := range linesChunk {
			if !printedLines[line] {
				printedLines[line] = true
				fmt.Fprintln(outFile, "0.0.0.0", line)
			}
		}
	}
}

func downloadHostsFiles(urls []string, outChannel chan<- []string, showProgress bool) {
	var wg sync.WaitGroup
	wg.Add(len(urls))
	if showProgress {
		uiprogress.Start()
	}

	for _, url := range urls {
		go downloadHostsFile(url, &wg, outChannel, showProgress)
	}

	wg.Wait()
	close(outChannel)
}

func downloadHostsFile(url string, wg *sync.WaitGroup, outChannel chan<- []string, showProgress bool) {
	resp, err := http.Get(url)
	lines := make([]string, 1024)
	defer wg.Done()

	if err != nil {
		log.Println("Failed to download", url, err)
	} else {
		defer resp.Body.Close()
		var bar *uiprogress.Bar
		// counter to keep track of how much we've downloaded
		readBytes := 0
		if showProgress {
			if resp.ContentLength == -1 {
				bar = uiprogress.AddBar(math.MaxInt32).AppendCompleted().PrependElapsed()
			} else {
				bar = uiprogress.AddBar(int(resp.ContentLength)).AppendCompleted().PrependElapsed()
			}
			// make sure that the bar eventually finishes
			defer bar.Set(bar.Total)
		}

		scanner := bufio.NewScanner(resp.Body)
		for scanner.Scan() {
			line := scanner.Text()
			if showProgress {
				// update progress bar
				readBytes += len(line)
				bar.Set(readBytes)
			}
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
