import Foundation

class ConfigLoader {
    static let shared = ConfigLoader()

    private(set) var openAIKey: String = ""
    private(set) var deepseekKey: String = ""

    init() {
        loadConfigFromFile()
        // Fallback to environment variables
        if openAIKey.isEmpty {
            openAIKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] ?? ""
        }
        if deepseekKey.isEmpty {
            deepseekKey = ProcessInfo.processInfo.environment["DEEPSEEK_API_KEY"] ?? ""
        }
        // Fallback to Info.plist
        if openAIKey.isEmpty {
            openAIKey = Bundle.main.infoDictionary?["OPENAI_API_KEY"] as? String ?? ""
        }
        if deepseekKey.isEmpty {
            deepseekKey = Bundle.main.infoDictionary?["DEEPSEEK_API_KEY"] as? String ?? ""
        }
    }

    private func loadConfigFromFile() {
        guard let configPath = Bundle.main.path(forResource: "Config", ofType: "xcconfig") else {
            print("⚠️  Config.xcconfig not found in Bundle")
            return
        }

        do {
            let configContent = try String(contentsOfFile: configPath, encoding: .utf8)
            parseConfig(configContent)
        } catch {
            print("⚠️  Failed to read Config.xcconfig: \(error)")
        }
    }

    private func parseConfig(_ content: String) {
        let lines = content.components(separatedBy: .newlines)

        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)

            // Skip comments and empty lines
            if trimmed.isEmpty || trimmed.starts(with: "//") {
                continue
            }

            // Parse key = value format
            let parts = trimmed.components(separatedBy: "=")
            guard parts.count == 2 else { continue }

            let key = parts[0].trimmingCharacters(in: .whitespaces)
            let value = parts[1].trimmingCharacters(in: .whitespaces)

            if key == "OPENAI_API_KEY" {
                openAIKey = value
                print("✅ Loaded OPENAI_API_KEY from Config.xcconfig")
            } else if key == "DEEPSEEK_API_KEY" {
                deepseekKey = value
                print("✅ Loaded DEEPSEEK_API_KEY from Config.xcconfig")
            }
        }
    }
}
