@main
struct Day14 {
    mutating func run() {
        let part1 = calculate(start, depth: 10)
        print("Part 1:", part1.values.max()! - part1.values.min()!)

        let part2 = calculate(start, depth: 40)
        print("Part 2:", part2.values.max()! - part2.values.min()!)
    }

    mutating func calculate(_ string: String, depth: Int) -> [Character: Int] {
        var result: [Character: Int] = [:]
        for (a, b) in zip(string, string.dropFirst()) {
            result.merge(calculate(a, b, depth: depth), uniquingKeysWith: +)
        }
        result[string.last!, default: 0] += 1
        return result
    }

    struct CacheKey: Hashable {
        var string: String
        var depth: Int
    }
    var cache: [CacheKey: [Character: Int]] = [:]

    mutating func calculate(_ first: Character, _ second: Character, depth: Int) -> [Character: Int] {
        guard depth > 0 else {
            return [first: 1]
        }

        let pair = "\(first)\(second)"
        let cacheKey = CacheKey(string: pair, depth: depth)

        if let result = cache[cacheKey] {
            return result
        }

        let mid = mapping[pair]!

        var result = calculate(first, mid, depth: depth - 1)
        result.merge(calculate(mid, second, depth: depth - 1), uniquingKeysWith: +)

        cache[cacheKey] = result

        return result
    }

    let start = "KBKPHKHHNBCVCHPSPNHF"
    let mapping: [String: Character] = [
        "OP": "H",
        "CF": "C",
        "BB": "V",
        "KH": "O",
        "CV": "S",
        "FV": "O",
        "FS": "K",
        "KO": "C",
        "PP": "S",
        "SH": "K",
        "FH": "O",
        "NF": "H",
        "PN": "P",
        "BO": "H",
        "OK": "K",
        "PO": "P",
        "SF": "K",
        "BF": "P",
        "HH": "S",
        "KP": "H",
        "HB": "N",
        "NP": "V",
        "KK": "P",
        "PF": "P",
        "BK": "V",
        "OF": "H",
        "FO": "S",
        "VC": "P",
        "FK": "B",
        "NK": "S",
        "CB": "B",
        "PV": "C",
        "CO": "N",
        "BN": "C",
        "HV": "H",
        "OC": "N",
        "NB": "O",
        "CS": "S",
        "HK": "C",
        "VS": "F",
        "BH": "C",
        "PC": "S",
        "KC": "O",
        "VO": "P",
        "FB": "K",
        "BV": "V",
        "VN": "N",
        "ON": "F",
        "VH": "H",
        "CN": "O",
        "HO": "O",
        "SV": "O",
        "SS": "H",
        "KF": "N",
        "SP": "C",
        "NS": "V",
        "SO": "F",
        "BC": "P",
        "HC": "C",
        "FP": "H",
        "OH": "S",
        "OB": "S",
        "HF": "V",
        "SC": "B",
        "SN": "N",
        "VK": "C",
        "NC": "V",
        "VV": "S",
        "SK": "K",
        "PK": "K",
        "PS": "N",
        "KB": "S",
        "KS": "C",
        "NN": "C",
        "OO": "C",
        "BS": "B",
        "NV": "H",
        "FF": "P",
        "FC": "N",
        "OS": "H",
        "KN": "N",
        "VP": "B",
        "PH": "N",
        "NH": "S",
        "OV": "O",
        "FN": "V",
        "CP": "B",
        "NO": "V",
        "CK": "C",
        "VF": "B",
        "HS": "B",
        "KV": "K",
        "VB": "H",
        "SB": "S",
        "BP": "S",
        "CC": "F",
        "HP": "B",
        "PB": "P",
        "HN": "P",
        "CH": "O",
    ]
}
