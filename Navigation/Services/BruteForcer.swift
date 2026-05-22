//
//  BruteForcer.swift
//  Navigation
//
//  Created by Sasha Soldatov on 22.05.2026.
//

final class BruteForcer {
    
    private let allowedCharacters: [String] = {
        let digits = "0123456789"
        let lowercase = "abcdefghijklmnopqrstuvwxyz"
        let uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return (digits + lowercase + uppercase).map { String($0) }
    }()
    
    func bruteForce(passwordToUnlock: String) -> String {

        var password: String = ""

        // Will strangely ends at 0000 instead of ~~~
        while password != passwordToUnlock { // Increase MAXIMUM_PASSWORD_SIZE value for more
            password = generateBruteForce(password, fromArray: allowedCharacters)

        }
        
        return password
    }
    
    func randomPassword(length: Int = 3) -> String {
        var result = ""
        for _ in 0..<length {
            if let ch = allowedCharacters.randomElement() {
                result += ch
            }
        }
        return result
    }
    
    func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
        var str: String = string

        if str.count <= 0 {
            str.append(characterAt(index: 0, array))
        }
        else {
            str.replace(at: str.count - 1,
                        with: characterAt(index: (indexOf(character: str.last!, array) + 1) % array.count, array))

            if indexOf(character: str.last!, array) == 0 {
                str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last!)
            }
        }

        return str
    }
    
    func indexOf(character: Character, _ array: [String]) -> Int {
        return array.firstIndex(of: String(character))!
    }

    func characterAt(index: Int, _ array: [String]) -> Character {
        return index < array.count ? Character(array[index])
                                   : Character("")
    }
    
}

private extension String {
    mutating func replace(at index: Int, with character: Character) {
            var stringArray = Array(self)
            stringArray[index] = character
            self = String(stringArray)
        }
}
