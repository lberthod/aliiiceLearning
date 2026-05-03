import Foundation

enum NumberMode: String, CaseIterable {
    case basic = "1-10"
    case complete = "1-100"
    case hundreds = "100+"
    case quiz = "Quiz"

    var displayName: String {
        self.rawValue
    }
}

struct NumbersDataGenerator {
    static func generateBasicNumbers() -> [(number: Int, thai: String, romanization: String, english: String, french: String, emoji: String)] {
        [
            (1, "หนึ่ง", "neung", "one", "un", "1"),
            (2, "สอง", "song", "two", "deux", "2"),
            (3, "สาม", "sam", "three", "trois", "3"),
            (4, "สี่", "si", "four", "quatre", "4"),
            (5, "ห้า", "ha", "five", "cinq", "5"),
            (6, "หก", "hok", "six", "six", "6"),
            (7, "เจ็ด", "jet", "seven", "sept", "7"),
            (8, "แปด", "paet", "eight", "huit", "8"),
            (9, "เก้า", "kao", "nine", "neuf", "9"),
            (10, "สิบ", "sip", "ten", "dix", "10"),
        ]
    }

    static func generateCompleteNumbers() -> [(number: Int, thai: String, romanization: String, english: String, french: String, emoji: String)] {
        var numbers: [(number: Int, thai: String, romanization: String, english: String, french: String, emoji: String)] = []

        // 1-10
        numbers.append(contentsOf: generateBasicNumbers())

        // 11-19
        let teens = [
            (11, "สิบเอ็ด", "sip et", "eleven", "onze"),
            (12, "สิบสอง", "sip song", "twelve", "douze"),
            (13, "สิบสาม", "sip sam", "thirteen", "treize"),
            (14, "สิบสี่", "sip si", "fourteen", "quatorze"),
            (15, "สิบห้า", "sip ha", "fifteen", "quinze"),
            (16, "สิบหก", "sip hok", "sixteen", "seize"),
            (17, "สิบเจ็ด", "sip jet", "seventeen", "dix-sept"),
            (18, "สิบแปด", "sip paet", "eighteen", "dix-huit"),
            (19, "สิบเก้า", "sip kao", "nineteen", "dix-neuf"),
        ]

        for (num, thai, roman, en, fr) in teens {
            numbers.append((num, thai, roman, en, fr, "\(num)"))
        }

        // 20-99
        let tensBase = [(2, "ยี่", "yi"), (3, "สาม", "sam"), (4, "สี่", "si"), (5, "ห้า", "ha"),
                        (6, "หก", "hok"), (7, "เจ็ด", "jet"), (8, "แปด", "paet"), (9, "เก้า", "kao")]

        for (tensDigit, thaiTens, romanTens) in tensBase {
            let tenNum = tensDigit * 10
            let tenThai = thaiTens + "สิบ"
            let tenRoman = romanTens + " sip"

            // Add the tens number (20, 30, 40, etc.)
            let (tenEn, tenFr) = getEnglishFrench(for: tenNum)
            numbers.append((tenNum, tenThai, tenRoman, tenEn, tenFr, "\(tenNum)"))

            // Add 21-29, 31-39, etc.
            for unitsDigit in 1...9 {
                let num = tenNum + unitsDigit
                let (en, fr) = getEnglishFrench(for: num)
                let thaiUnits = getThaiUnits(unitsDigit)
                let romanUnits = getRomanUnits(unitsDigit)
                let thai = tenThai + thaiUnits
                let roman = tenRoman + " " + romanUnits
                numbers.append((num, thai, roman, en, fr, "\(num)"))
            }
        }

        // 100
        numbers.append((100, "ร้อย", "roi", "one hundred", "cent", "100"))

        return numbers
    }

    private static func getEnglishFrench(for num: Int) -> (String, String) {
        let englishNumbers = [
            20: "twenty", 21: "twenty-one", 22: "twenty-two", 23: "twenty-three", 24: "twenty-four",
            25: "twenty-five", 26: "twenty-six", 27: "twenty-seven", 28: "twenty-eight", 29: "twenty-nine",
            30: "thirty", 31: "thirty-one", 32: "thirty-two", 33: "thirty-three", 34: "thirty-four",
            35: "thirty-five", 36: "thirty-six", 37: "thirty-seven", 38: "thirty-eight", 39: "thirty-nine",
            40: "forty", 41: "forty-one", 42: "forty-two", 43: "forty-three", 44: "forty-four",
            45: "forty-five", 46: "forty-six", 47: "forty-seven", 48: "forty-eight", 49: "forty-nine",
            50: "fifty", 51: "fifty-one", 52: "fifty-two", 53: "fifty-three", 54: "fifty-four",
            55: "fifty-five", 56: "fifty-six", 57: "fifty-seven", 58: "fifty-eight", 59: "fifty-nine",
            60: "sixty", 61: "sixty-one", 62: "sixty-two", 63: "sixty-three", 64: "sixty-four",
            65: "sixty-five", 66: "sixty-six", 67: "sixty-seven", 68: "sixty-eight", 69: "sixty-nine",
            70: "seventy", 71: "seventy-one", 72: "seventy-two", 73: "seventy-three", 74: "seventy-four",
            75: "seventy-five", 76: "seventy-six", 77: "seventy-seven", 78: "seventy-eight", 79: "seventy-nine",
            80: "eighty", 81: "eighty-one", 82: "eighty-two", 83: "eighty-three", 84: "eighty-four",
            85: "eighty-five", 86: "eighty-six", 87: "eighty-seven", 88: "eighty-eight", 89: "eighty-nine",
            90: "ninety", 91: "ninety-one", 92: "ninety-two", 93: "ninety-three", 94: "ninety-four",
            95: "ninety-five", 96: "ninety-six", 97: "ninety-seven", 98: "ninety-eight", 99: "ninety-nine",
        ]

        let frenchNumbers = [
            20: "vingt", 21: "vingt-et-un", 22: "vingt-deux", 23: "vingt-trois", 24: "vingt-quatre",
            25: "vingt-cinq", 26: "vingt-six", 27: "vingt-sept", 28: "vingt-huit", 29: "vingt-neuf",
            30: "trente", 31: "trente-et-un", 32: "trente-deux", 33: "trente-trois", 34: "trente-quatre",
            35: "trente-cinq", 36: "trente-six", 37: "trente-sept", 38: "trente-huit", 39: "trente-neuf",
            40: "quarante", 41: "quarante-et-un", 42: "quarante-deux", 43: "quarante-trois", 44: "quarante-quatre",
            45: "quarante-cinq", 46: "quarante-six", 47: "quarante-sept", 48: "quarante-huit", 49: "quarante-neuf",
            50: "cinquante", 51: "cinquante-et-un", 52: "cinquante-deux", 53: "cinquante-trois", 54: "cinquante-quatre",
            55: "cinquante-cinq", 56: "cinquante-six", 57: "cinquante-sept", 58: "cinquante-huit", 59: "cinquante-neuf",
            60: "soixante", 61: "soixante-et-un", 62: "soixante-deux", 63: "soixante-trois", 64: "soixante-quatre",
            65: "soixante-cinq", 66: "soixante-six", 67: "soixante-sept", 68: "soixante-huit", 69: "soixante-neuf",
            70: "soixante-dix", 71: "soixante-et-onze", 72: "soixante-douze", 73: "soixante-treize", 74: "soixante-quatorze",
            75: "soixante-quinze", 76: "soixante-seize", 77: "soixante-dix-sept", 78: "soixante-dix-huit", 79: "soixante-dix-neuf",
            80: "quatre-vingts", 81: "quatre-vingt-un", 82: "quatre-vingt-deux", 83: "quatre-vingt-trois", 84: "quatre-vingt-quatre",
            85: "quatre-vingt-cinq", 86: "quatre-vingt-six", 87: "quatre-vingt-sept", 88: "quatre-vingt-huit", 89: "quatre-vingt-neuf",
            90: "quatre-vingt-dix", 91: "quatre-vingt-onze", 92: "quatre-vingt-douze", 93: "quatre-vingt-treize", 94: "quatre-vingt-quatorze",
            95: "quatre-vingt-quinze", 96: "quatre-vingt-seize", 97: "quatre-vingt-dix-sept", 98: "quatre-vingt-dix-huit", 99: "quatre-vingt-dix-neuf",
        ]

        return (englishNumbers[num] ?? "", frenchNumbers[num] ?? "")
    }

    private static func getThaiUnits(_ digit: Int) -> String {
        let units = ["", "เอ็ด", "สอง", "สาม", "สี่", "ห้า", "หก", "เจ็ด", "แปด", "เก้า"]
        return units[digit]
    }

    private static func getRomanUnits(_ digit: Int) -> String {
        let units = ["", "et", "song", "sam", "si", "ha", "hok", "jet", "paet", "kao"]
        return units[digit]
    }

    static func generateHundreds() -> [(number: Int, thai: String, romanization: String, english: String, french: String, emoji: String)] {
        var numbers: [(number: Int, thai: String, romanization: String, english: String, french: String, emoji: String)] = []

        // 100-109
        numbers.append((100, "ร้อย", "roi", "one hundred", "cent", "100"))
        for i in 1...9 {
            let thai = "ร้อย" + getThaiUnits(i)
            let roman = "roi " + getRomanUnits(i)
            let en = "one hundred \(["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"][i-1])"
            let fr = "cent \(["un", "deux", "trois", "quatre", "cinq", "six", "sept", "huit", "neuf"][i-1])"
            numbers.append((100 + i, thai, roman, en, fr, "\(100 + i)"))
        }

        // 110-119
        for i in 0...9 {
            let num = 110 + i
            let thai = "ร้อยสิบ" + (i > 0 ? getThaiUnits(i) : "")
            let roman = "roi sip" + (i > 0 ? " \(getRomanUnits(i))" : "")
            let (en, fr) = getEnglishFrench(for: num)
            numbers.append((num, thai, roman, en, fr, "\(num)"))
        }

        // 120-129
        for i in 0...9 {
            let num = 120 + i
            let thai = "ร้อยยี่สิบ" + (i > 0 ? getThaiUnits(i) : "")
            let roman = "roi yi sip" + (i > 0 ? " \(getRomanUnits(i))" : "")
            let (en, fr) = getEnglishFrench(for: num)
            numbers.append((num, thai, roman, en, fr, "\(num)"))
        }

        // 200-209
        numbers.append((200, "สองร้อย", "song roi", "two hundred", "deux cents", "200"))
        for i in 1...9 {
            let thai = "สองร้อย" + getThaiUnits(i)
            let roman = "song roi " + getRomanUnits(i)
            let en = "two hundred \(["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"][i-1])"
            let fr = "deux cent \(["un", "deux", "trois", "quatre", "cinq", "six", "sept", "huit", "neuf"][i-1])"
            numbers.append((200 + i, thai, roman, en, fr, "\(200 + i)"))
        }

        // Key hundreds: 300-900
        let hundredsData = [
            (3, "สาม", "sam", "three", "trois"),
            (4, "สี่", "si", "four", "quatre"),
            (5, "ห้า", "ha", "five", "cinq"),
            (6, "หก", "hok", "six", "six"),
            (7, "เจ็ด", "jet", "seven", "sept"),
            (8, "แปด", "paet", "eight", "huit"),
            (9, "เก้า", "kao", "nine", "neuf"),
        ]

        for (digit, thai, roman, en, fr) in hundredsData {
            let num = digit * 100
            let thaiNum = thai + "ร้อย"
            let romanNum = roman + " roi"
            numbers.append((num, thaiNum, romanNum, en + " hundred", fr + " cents", "\(num)"))
        }

        // 1000-1021
        numbers.append((1000, "พัน", "phan", "one thousand", "mille", "1000"))
        for i in 1...9 {
            let thai = "พันเอ็ด" + getThaiUnits(i)
            let roman = "phan et " + getRomanUnits(i)
            let en = "one thousand \(["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"][i-1])"
            let fr = "mille \(["un", "deux", "trois", "quatre", "cinq", "six", "sept", "huit", "neuf"][i-1])"
            numbers.append((1000 + i, thai, roman, en, fr, "\(1000 + i)"))
        }

        // 1010-1019
        for i in 0...9 {
            let num = 1010 + i
            let thai = "พันสิบ" + (i > 0 ? getThaiUnits(i) : "")
            let roman = "phan sip" + (i > 0 ? " \(getRomanUnits(i))" : "")
            let (en, fr) = getEnglishFrench(for: num)
            numbers.append((num, thai, roman, "one thousand " + en, "mille " + fr, "\(num)"))
        }

        // 1020-1021
        numbers.append((1020, "พันยี่สิบ", "phan yi sip", "one thousand twenty", "mille vingt", "1020"))
        numbers.append((1021, "พันยี่สิบเอ็ด", "phan yi sip et", "one thousand twenty-one", "mille vingt-et-un", "1021"))

        // 1100, 1200, 2000, 3000, ... 10000
        let keyThousands = [
            (1100, "พันหนึ่งร้อย", "phan neung roi", "one thousand one hundred", "mille cent"),
            (1200, "พันสองร้อย", "phan song roi", "one thousand two hundred", "mille deux cents"),
            (2000, "สองพัน", "song phan", "two thousand", "deux mille"),
            (3000, "สามพัน", "sam phan", "three thousand", "trois mille"),
            (4000, "สี่พัน", "si phan", "four thousand", "quatre mille"),
            (5000, "ห้าพัน", "ha phan", "five thousand", "cinq mille"),
            (6000, "หกพัน", "hok phan", "six thousand", "six mille"),
            (7000, "เจ็ดพัน", "jet phan", "seven thousand", "sept mille"),
            (8000, "แปดพัน", "paet phan", "eight thousand", "huit mille"),
            (9000, "เก้าพัน", "kao phan", "nine thousand", "neuf mille"),
            (10000, "หมื่น", "muean", "ten thousand", "dix mille"),
        ]

        for (num, thai, roman, en, fr) in keyThousands {
            numbers.append((num, thai, roman, en, fr, "\(num)"))
        }

        return numbers
    }

    static func generateQuizNumbers() -> [(number: Int, thai: String, romanization: String, english: String, french: String, emoji: String)] {
        // Mixed numbers from all ranges for quiz
        var quizNumbers: [(number: Int, thai: String, romanization: String, english: String, french: String, emoji: String)] = []

        // Include all basic numbers
        quizNumbers.append(contentsOf: generateBasicNumbers())

        // Add some intermediate numbers
        let intermediate = [
            (11, "สิบเอ็ด", "sip et", "eleven", "onze"),
            (15, "สิบห้า", "sip ha", "fifteen", "quinze"),
            (20, "ยี่สิบ", "yi sip", "twenty", "vingt"),
            (50, "ห้าสิบ", "ha sip", "fifty", "cinquante"),
            (100, "ร้อย", "roi", "one hundred", "cent"),
        ]

        for (num, thai, roman, en, fr) in intermediate {
            quizNumbers.append((num, thai, roman, en, fr, "\(num)"))
        }

        return quizNumbers.shuffled()
    }

    static func getNumbers(for mode: NumberMode) -> [(number: Int, thai: String, romanization: String, english: String, french: String, emoji: String)] {
        switch mode {
        case .basic:
            return generateBasicNumbers()
        case .complete:
            return generateCompleteNumbers()
        case .hundreds:
            return generateHundreds()
        case .quiz:
            return generateQuizNumbers()
        }
    }
}
