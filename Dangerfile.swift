import Danger
import Foundation

let danger = Danger()

// MARK: - Branch Detection

let branchName = danger.github.pullRequest.head.ref
let isReleaseBranch = branchName.hasPrefix("release/") || branchName.hasPrefix("hotfix/")

message("🔍 Analyzing PR from branch: \(branchName)")

// MARK: - Package Version Check

checkPackageVersions(failOnError: isReleaseBranch)

// MARK: - Implementation

func checkPackageVersions(failOnError: Bool) {
    let packageSwiftPath = "Package.swift"
    
    guard FileManager.default.fileExists(atPath: packageSwiftPath) else {
        message("ℹ️ No Package.swift found, skipping dependency check")
        return
    }
    
    guard let content = try? String(contentsOfFile: packageSwiftPath, encoding: .utf8) else {
        warn("⚠️ Could not read Package.swift")
        return
    }
    
    let lines = content.components(separatedBy: "\n")
    var foundIssues = false
    
    for (index, line) in lines.enumerated() {
        let lineNumber = index + 1 // 1-indexed
        
        if line.contains("branch:") {
            postInlineComment(
                message: "❌ Non-release dependency: `branch:` not allowed. Use `.upToNextMajor(from:)` or `.exact()` with a numeric version.",
                file: packageSwiftPath, line: lineNumber, failOnError: failOnError
            )
            foundIssues = true
        }
        
        if line.contains("revision:") {
            postInlineComment(
                message: "❌ Non-release dependency: `revision:` not allowed. Use `.upToNextMajor(from:)` or `.exact()` with a numeric version.",
                file: packageSwiftPath, line: lineNumber, failOnError: failOnError
            )
            foundIssues = true
        }
        
        if line.contains("-SNAPSHOT") {
            postInlineComment(
                message: "❌ Non-release dependency: `-SNAPSHOT` version not allowed. Use a stable release version.",
                file: packageSwiftPath, line: lineNumber, failOnError: failOnError
            )
            foundIssues = true
        }
    }
    
    if !foundIssues {
        message("✅ Package.swift dependencies look good!")
    }
}

func postInlineComment(message: String, file: String, line: Int, failOnError: Bool) {
    if failOnError {
        fail(message: message, file: file, line: line)
    } else {
        warn(message: message, file: file, line: line)
    }
}
