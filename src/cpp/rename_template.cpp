// rename_template.cpp
// reads copied filenames from stdin, and writes templates to stdout
// this version aligns the outputs, so they are more readable
#include <iostream>  // for cout and cin
#include <string>    // for string
#include <vector>    // for vector

/*
output is set to where the shell script expects it to be
g++     -Wall -Wextra -O3 -std=gnu++14 rename_template.cpp -o ../.rename_template
clang++ -Wall -Wextra -O3 -std=gnu++14 rename_template.cpp -o ../.rename_template
*/

const std::string move_cmd = "mv ";

int main() {
    std::vector<std::string> input_lines;
    std::vector<std::string> basename_lines;
    std::string line;          // for input
    std::string line_buffer;   // temp var for inserting into vectors
    unsigned int longest = 0;  // temp var for keeping track of the longest

    while (getline(std::cin, line)) {
        input_lines.push_back(line);
        if (line.length() > longest) {
            longest = line.length();  // keep track of the longest line
        }
        // add 1 because we don't want the forward slash
        basename_lines.push_back(line.substr(line.find_last_of('/') + 1));
    }

    // this makes sublime-text auto-detect bash syntax
    std::cout << "#!/usr/bin/env bash" << std::endl;
    for (unsigned int i = 0; i < input_lines.size(); i++) {
        // start with space so that commands do not save in bash history
        std::cout << " " << move_cmd << "\"" << input_lines.at(i) << "\"";
        for (unsigned int j = input_lines.at(i).size(); j < longest; j++) {
            std::cout << " ";  // this is faster than resize because we needn't allocate memory
        }
        std::cout << " ///"
                  << "\"" << basename_lines.at(i) << "\"" << std::endl;
    }
    return 0;
}
