@main
struct Day16: Puzzle {
    mutating func run() {
        var start = Cursor.start

        let part2 = packet(at: &start)
        print("Part 1:", versionSum)
        print("Part 2:", part2)
    }

    var versionSum = 0

    mutating func packet(at cursor: inout Cursor) -> UInt64 {
        let version = getBits(at: &cursor, count: 3)
        let type = getBits(at: &cursor, count: 3)

        versionSum += Int(version)

        if type == 4 {
            return literal(at: &cursor)
        }

        let subPackets = operatorPacket(at: &cursor)

        switch type {
        case 0: return subPackets.reduce(0, +)
        case 1: return subPackets.reduce(1, *)
        case 2: return subPackets.min()!
        case 3: return subPackets.max()!
        case 5: return subPackets[0] > subPackets[1] ? 1 : 0
        case 6: return subPackets[0] < subPackets[1] ? 1 : 0
        case 7: return subPackets[0] == subPackets[1] ? 1 : 0
        default: fatalError("Unknown packet type \(type)")
        }

    }

    func literal(at cursor: inout Cursor) -> UInt64 {
        var result: UInt64 = 0
        while getBit(at: &cursor) {
            result = result << 4 | getBits(at: &cursor, count: 4)
        }
        result = result << 4 | getBits(at: &cursor, count: 4)
        return result
    }

    mutating func operatorPacket(at cursor: inout Cursor) -> [UInt64] {
        let type = getBit(at: &cursor)
        var result: [UInt64] = []
        if type {
            let count = getBits(at: &cursor, count: 11)
            for _ in 0..<count {
                result.append(packet(at: &cursor))
            }
        } else {
            let length = getBits(at: &cursor, count: 15)
            let end = cursor.adding(bits: Int(length))
            while cursor < end {
                result.append(packet(at: &cursor))
            }
        }
        return result
    }


    struct Cursor: Equatable {
        var offset: Int
        var bit: Int

        static let start = Cursor(offset: 0, bit: 0)

        var remainingBits: Int { 4 - bit }

        mutating func skip(_ bits: Int) {
            bit += bits
            offset += bit / 4
            bit = bit % 4
        }

        func adding(bits: Int) -> Cursor {
            var result = self
            result.skip(bits)
            return result
        }

        var bitPos: Int {
            offset * 4 + bit
        }

        static func < (lhs: Cursor, rhs: Cursor) -> Bool {
            lhs.bitPos < rhs.bitPos
        }
    }

    func getBit(at cursor: inout Cursor) -> Bool {
        getBits(at: &cursor, count: 1) == 1
    }

    func getBitRange(_ x: Int, start: Int, count: Int) -> UInt64 {
        let mask = UInt64((1 << count) - 1)
        let shift = 4 - count - start
        precondition(shift >= 0)

        return UInt64(x) >> shift & mask
    }

    func getBits(at cursor: inout Cursor, count: Int) -> UInt64 {
        var remaining = count
        var result: UInt64 = 0

        while remaining > 0 {
            let take = min(cursor.remainingBits, remaining)
            let bits = getBitRange(input[cursor.offset], start: cursor.bit, count: take)

            result = result << take | bits
            remaining -= take

            cursor.bit += take
            if cursor.bit == 4 {
                cursor.bit = 0
                cursor.offset += 1
            }
        }

        return result
    }

    let input = """
E20D79005573F71DA0054E48527EF97D3004653BB1FC006867A8B1371AC49C801039171941340066E6B99A6A58B8110088BA008CE6F7893D4E6F7893DCDCFDB9D6CBC4026FE8026200DC7D84B1C00010A89507E3CCEE37B592014D3C01491B6697A83CB4F59E5E7FFA5CC66D4BC6F05D3004E6BB742B004E7E6B3375A46CF91D8C027911797589E17920F4009BE72DA8D2E4523DCEE86A8018C4AD3C7F2D2D02C5B9FF53366E3004658DB0012A963891D168801D08480485B005C0010A883116308002171AA24C679E0394EB898023331E60AB401294D98CA6CD8C01D9B349E0A99363003E655D40289CBDBB2F55D25E53ECAF14D9ABBB4CC726F038C011B0044401987D0BE0C00021B04E2546499DE824C015B004A7755B570013F2DD8627C65C02186F2996E9CCD04E5718C5CBCC016B004A4F61B27B0D9B8633F9344D57B0C1D3805537ADFA21F231C6EC9F3D3089FF7CD25E5941200C96801F191C77091238EE13A704A7CCC802B3B00567F192296259ABD9C400282915B9F6E98879823046C0010C626C966A19351EE27DE86C8E6968F2BE3D2008EE540FC01196989CD9410055725480D60025737BA1547D700727B9A89B444971830070401F8D70BA3B8803F16A3FC2D00043621C3B8A733C8BD880212BCDEE9D34929164D5CB08032594E5E1D25C0055E5B771E966783240220CD19E802E200F4588450BC401A8FB14E0A1805B36F3243B2833247536B70BDC00A60348880C7730039400B402A91009F650028C00E2020918077610021C00C1002D80512601188803B4000C148025010036727EE5AD6B445CC011E00B825E14F4BBF5F97853D2EFD6256F8FFE9F3B001420C01A88915E259002191EE2F4392004323E44A8B4C0069CEF34D304C001AB94379D149BD904507004A6D466B618402477802E200D47383719C0010F8A507A294CC9C90024A967C9995EE2933BA840
""".compactMap { $0.hexDigitValue }
}
