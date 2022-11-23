import Foundation

func loadData(day: Int) -> String {
    let session = (try! String(contentsOf: FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".config/aoc2020session"))).trimmingCharacters(in: .whitespacesAndNewlines)

    var request = URLRequest(url: URL(string: "https://adventofcode.com/2020/day/\(day)/input")!)
    request.setValue("session=\(session)", forHTTPHeaderField: "Cookie")

    var result: String? = nil

    let group = DispatchGroup()

    group.enter()
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard error == nil, let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            fatalError("Cannot get input from server")
        }

        result = String(data: data, encoding: .utf8)
        group.leave()
    }

    task.resume()

    group.wait()

    return result!
}
