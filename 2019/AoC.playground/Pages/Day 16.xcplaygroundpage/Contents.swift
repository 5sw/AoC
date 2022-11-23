
func pattern(position: Int) -> DropFirstSequence<AnySequence<Int>>
{
    precondition(position >= 0)
    let repeats = position + 1

    let base = [0, 1, 0, -1]
    return repeating(base.flatMap { Array(repeating: $0, count: repeats) }).dropFirst()
}

func repeating<T: Sequence>(_ sequence: T) -> AnySequence<T.Element>
{
    return AnySequence { () -> AnyIterator<T.Element> in
        var it = sequence.makeIterator()
        return AnyIterator { () -> T.Element? in
            if let value = it.next() {
                return value
            }

            it = sequence.makeIterator()
            return it.next()
        }
    }
}

func phase(_ input: [Int]) -> [Int] {
    var result: [Int] = []
    return input.indices.map { i in
        abs(zip(input, pattern(position: i)).reduce(0) { (accum: Int, value: (Int, Int)) -> Int in accum + value.0 * value.1 }) % 10
        }
    }

let input = "59773419794631560412886746550049210714854107066028081032096591759575145680294995770741204955183395640103527371801225795364363411455113236683168088750631442993123053909358252440339859092431844641600092736006758954422097244486920945182483159023820538645717611051770509314159895220529097322723261391627686997403783043710213655074108451646685558064317469095295303320622883691266307865809481566214524686422834824930414730886697237161697731339757655485312568793531202988525963494119232351266908405705634244498096660057021101738706453735025060225814133166491989584616948876879383198021336484629381888934600383957019607807995278899293254143523702000576897358"

var data: [Int] = input.map { $0.wholeNumberValue! }

func readAt(_ index: Int) -> Int {
    data[index ..< index + 8].reduce(0) { 10 * $0 + $1 }
}

readAt(readAt(0))


//for i in 0..<100 {
//    data = phase(data)
//}
//
//print(data[0..<8])


