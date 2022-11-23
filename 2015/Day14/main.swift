
/*
 Sugar: capacity 3, durability 0, flavor 0, texture -3, calories 2
 Sprinkles: capacity -3, durability 3, flavor 0, texture 0, calories 9
 Candy: capacity -1, durability 0, flavor 4, texture 0, calories 1
 Chocolate: capacity 0, durability 0, flavor -2, texture 2, calories 8
 */

var score = 0
var scoreFor500 = 0

for a in 0...100 {
    for b in 0...(100-a) {
        for c in 0...(100-a-b) {
            for d in 0...(100-a-b-c) where a + b + c + d == 100 {
                let capacity = 3 * a - 3 * b - c
                let durability = 3 * b
                let flavor = 4 * c - 2 * d
                let texture = -3 * a + 2 * d
                let calories = 2 * a + 9 * b + c + 8 * d

                let currentScore = max(0,capacity) * max(0,durability) * max(0,flavor) * max(0,texture)
                if currentScore > score {
                    score = currentScore
                }


                if calories == 500, currentScore > scoreFor500 {
                    scoreFor500 = currentScore
                }
            }
        }
    }
}

print(score, scoreFor500)
