import CryptoKit
import Foundation

func md5(_ string: String) -> String {
    let digest = Insecure.MD5.hash(data: Data(string.utf8))
    digest.withUnsafeBytes { ptr in
        ptr[0] + ptr[1]
    }
    digest.pref
    return digest.reduce("") {
        $0 + String($1, radix: 16)
    }
}

let key = "abcdef"

var iterator = (0...).lazy.map { ($0, md5("\(key)\($0)")) }
.filter { $0.1.hasPrefix("00000" ) }
.makeIterator()

iterator.next()



