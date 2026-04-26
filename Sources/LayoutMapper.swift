import Foundation

class LayoutMapper {
    static let engToRus: [Character: Character] = [
        "q": "й", "w": "ц", "e": "у", "r": "к", "t": "е", "y": "н", "u": "г", "i": "ш", "o": "щ", "p": "з", "[": "х", "]": "ъ",
        "a": "ф", "s": "ы", "d": "в", "f": "а", "g": "п", "h": "р", "j": "о", "k": "л", "l": "д", ";": "ж", "'": "э",
        "z": "я", "x": "ч", "c": "с", "v": "м", "b": "и", "n": "т", "m": "ь", ",": "б", ".": "ю", "/": ".",
        "Q": "Й", "W": "Ц", "E": "У", "R": "К", "T": "Е", "Y": "Н", "U": "Г", "I": "Ш", "O": "Щ", "P": "З", "{": "Х", "}": "Ъ",
        "A": "Ф", "S": "Ы", "D": "В", "F": "А", "G": "П", "H": "Р", "J": "О", "K": "Л", "L": "Д", ":": "Ж", "\"": "Э",
        "Z": "Я", "X": "Ч", "C": "С", "V": "М", "B": "И", "N": "Т", "M": "Ь", "<": "Б", ">": "Ю", "?": ","
    ]
    
    static let rusToEng: [Character: Character] = Dictionary(uniqueKeysWithValues: engToRus.map { ($1, $0) })
    
    static func convert(_ text: String) -> String {
        guard !text.isEmpty else { return text }
        
        // Определяем направление конвертации по первому валидному символу
        var isEng = false
        var isRus = false
        
        for char in text {
            if engToRus.keys.contains(char) { isEng = true }
            if rusToEng.keys.contains(char) { isRus = true }
        }
        
        // Если смешанный текст, по умолчанию конвертируем из того, чего больше, или просто переводим все что сможем
        // Для простоты, если есть русские буквы — переводим в инглиш, иначе в русский
        let targetDict = isRus ? rusToEng : engToRus
        
        var result = ""
        for char in text {
            if let converted = targetDict[char] {
                result.append(converted)
            } else {
                result.append(char) // символы типа пробелов и цифр остаются как есть
            }
        }
        return result
    }
}
