const readline = require('readline');
const fs = require('fs');

function calculate_score(input) {
    if ('a' <= input && input <= 'z') {
        return input.charCodeAt(0) - 'a'.charCodeAt(0) + 1;
    } else if ('A' <= input && input <= 'Z') {
        return input.charCodeAt(0) - 'A'.charCodeAt(0) + 27;
    } else {
        throw `Invalid character '${input}'`
    }
}

async function puzzle() {

    const lines = readline.createInterface({
        input: fs.createReadStream('day3.input'),
    });

    var score = 0;
    for await (const line of lines) {
        const mid = line.length / 2;
        const first = line.substring(0, mid);
        const second  = new Set(line.substring(mid));

        for (const character of first) {
            if (second.has(character)) {
                score += calculate_score(character);
                break;
            }
        }
    }
    console.log(`Part 1: Score ${score}`);
}

puzzle();
