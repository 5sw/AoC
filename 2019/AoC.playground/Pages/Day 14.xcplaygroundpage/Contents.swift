import Foundation

let input = """
9 ORE => 2 A
8 ORE => 3 B
7 ORE => 5 C
3 A, 4 B => 1 AB
5 B, 7 C => 1 BC
4 C, 1 A => 1 CA
2 AB, 3 BC, 4 CA => 1 FUEL
"""


struct Chemical {
    let name: String
    let amount: Int
}

struct Reaction {
    let product: Chemical
    let educts: [Chemical]
}

var reactions: [String: Reaction] = [:]

let scanner = Scanner(string: input)

func parseChemical() -> Chemical? {
    guard let amount = scanner.scanInt(),
        let name = scanner.scanCharacters(from: .letters) else {
            return nil
    }
    return Chemical(name: name, amount: amount)
}

func parseReaction() -> Reaction? {
    var educts: [Chemical] = []
    repeat {
        guard let chemical = parseChemical() else {
            return nil
        }
        educts.append(chemical)
    } while scanner.scanString(",") != nil
    guard scanner.scanString("=>") != nil else {
        return nil
    }
    guard let product = parseChemical() else {
        return nil
    }

    return Reaction(product: product, educts: educts)
}

while !scanner.isAtEnd {
    guard let reaction = parseReaction() else {
        fatalError()
    }

    reactions[reaction.product.name] = reaction
}




