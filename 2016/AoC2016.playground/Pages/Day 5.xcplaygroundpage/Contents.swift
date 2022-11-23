import CryptoKit
import Foundation

func char(_ string: String) -> (String, String)? {
    let md5 = Insecure.MD5.hash(data: Data(string.utf8))
    return md5.withUnsafeBytes { ptr in
        guard ptr[0] == 0 && ptr[1] == 0 && ptr[2] & 0xf0 == 0 else { return nil }
        return (
            String(ptr[2] & 0x0f, radix: 16, uppercase: true),
            String((ptr[3] >> 4) & 0x0f, radix: 16, uppercase: true)
        )
    }
}

var result1 = ""
var result2 = "________"
for i in 0... {
    if let (first, second) = char("abbhdwsy\(i)") {
        if result1.count < 8 {
            result1 += first
        }

        if let i = Int(first), 0..<8 ~= i {
            let index = result2.index(result2.startIndex, offsetBy: i)
            if result2[index] == "_" {
                result2.replaceSubrange(index...index, with: second)
            }
        }

        if result1.count == 8 && !result2.contains("_") {
            break
        }
    }
}

result1
result2
