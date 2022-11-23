import Foundation
let input = loadData(day: 21)

let scanner = Scanner(string: input)
scanner.charactersToBeSkipped = .whitespaces

extension Scanner {
    func ingredient() -> String? {
        scanUpToCharacters(from: .whitespaces)
    }

    func allergens() -> Set<String>? {
        guard string("(contains") else { return nil }
        var result: Set<String> = []
        let end = CharacterSet(charactersIn: ",)")
        repeat {
            guard let allergen = scanUpToCharacters(from: end) else { return nil }
            result.insert(allergen)
        } while string(",")
        guard string(")") else { return nil }
        return result
    }

    func end() -> Set<String>? {
        let allergens = self.allergens()
        guard string("\n") else { return nil }
        return allergens ?? []
    }

    typealias Food = (ingredients: Set<String>, allergens: Set<String>)

    func food() -> Food? {
        var ingredients = Set<String>()
        while true {
            guard let ingredient = self.ingredient() else { return nil }
            ingredients.insert(ingredient)

            if let end = self.end() {
                return (ingredients, end)
            }
        }
    }

    func foods() -> [Food] {
        var result: [Food] = []
        while !isAtEnd, let food = self.food() {
            result.append(food)
        }
        return result
    }
}

let data = scanner.foods()

var possibleIngredientsByAllergen: [String: Set<String>] = [:]
var allIngredients: Set<String> = []
var allergens: [(String, String)] = []

for (ingredients, allergens) in data {
    allIngredients.formUnion(ingredients)
    for allergen in allergens {
        if let possible = possibleIngredientsByAllergen[allergen] {
            possibleIngredientsByAllergen[allergen] = possible.intersection(ingredients)
        } else {
            possibleIngredientsByAllergen[allergen] = ingredients
        }
    }
}

while !possibleIngredientsByAllergen.isEmpty {
    for (allergen, possible) in possibleIngredientsByAllergen where possible.count == 1 {
        let ingredient = possible.first!
        allIngredients.remove(ingredient)
        possibleIngredientsByAllergen.removeValue(forKey: allergen)
        allergens.append((allergen, ingredient))
        for key in possibleIngredientsByAllergen.keys {
            possibleIngredientsByAllergen[key]?.remove(ingredient)
        }
    }
}

let count = data.reduce(0) { $0 + $1.ingredients.intersection(allIngredients).count }

print("part 1:", count)

let canonicalDangerousList = allergens
    .sorted { $0.0 < $1.0 }
    .map { $0.1 }
    .joined(separator: ",")

print("part 2:", canonicalDangerousList)
