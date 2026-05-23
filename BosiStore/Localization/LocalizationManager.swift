import Foundation
import SwiftUI
internal import Combine

enum AppLanguage: String, CaseIterable {
    case english = "en"
    case chinese = "zh"
    case arabic = "ar"
    
    var displayName: String {
        switch self {
        case .english: return "English"
        case .chinese: return "中文"
        case .arabic: return "العربية"
        }
    }
    
    var isRTL: Bool {
        self == .arabic
    }
}

final class LocalizationManager: ObservableObject {
    @Published var currentLanguage: AppLanguage
    
    init() {
        let saved = UserDefaults.standard.string(forKey: "app_language_key") ?? "en"
        self.currentLanguage = AppLanguage(rawValue: saved) ?? .english
    }
    
    func setLanguage(_ language: AppLanguage) {
        currentLanguage = language
        UserDefaults.standard.set(language.rawValue, forKey: "app_language_key")
    }
    
    func str(_ key: String) -> String {
        switch currentLanguage {
        case .english: return EnStrings.map[key] ?? key
        case .chinese: return ZhStrings.map[key] ?? key
        case .arabic: return ArStrings.map[key] ?? key
        }
    }
    
    var layoutDirection: LayoutDirection {
        currentLanguage.isRTL ? .rightToLeft : .leftToRight
    }
}
