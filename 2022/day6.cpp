/* Compile using `clang day6.cpp -o day6 -lstdc++ -std=c++11` */

#include <string>
#include <fstream>
#include <iostream>
#include <set>

int find_marker(std::string input, int size) {
    auto start = input.begin();
    while (start + size != input.end()) {
        auto group = std::set<char>(start, start + size);
        if (group.size() == size) {
            return start - input.begin() + size;
        }
        start++;
    }
    
    return -1;
}

int main() {
    std::string input;
    std::ifstream file("day6.input");
    std::getline(file, input);
    
    std::cout << "Part 1: First marker after " << find_marker(input, 4)  << " characters\n";
    std::cout << "Part 2: First marker after " << find_marker(input, 14)  << " characters\n";
}
