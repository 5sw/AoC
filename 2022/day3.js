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

function find_badge(group) {
    const first = group.shift();
    const sets = group.map(item => new Set(item));
    
    for (const character of first) {
        if (sets.find(item => !item.has(character)) === undefined) {
            return character;
        }
    }
    
    throw 'No badge found';
}

async function puzzle() {

    const lines = readline.createInterface({
        input: fs.createReadStream('day3.input'),
    });

    var score = 0;
    var badge_score = 0;
    var group = [];
    
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

        group.push(line);
        if (group.length == 3) {
            badge_score += calculate_score(find_badge(group));
            group = [];
        }
    }
    
    console.log(`Part 1: Score ${score}`);
    console.log(`Part 2: Score ${badge_score}`);
}

puzzle();
