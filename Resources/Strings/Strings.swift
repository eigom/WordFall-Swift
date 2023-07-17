// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Strings {
  internal enum Alert {
    /// Word Fall
    internal static let defaultTitle = Strings.tr("Localizable", "alert.defaultTitle", fallback: "Word Fall")
    internal enum Action {
      /// Cancel
      internal static let cancel = Strings.tr("Localizable", "alert.action.cancel", fallback: "Cancel")
      /// OK
      internal static let dismiss = Strings.tr("Localizable", "alert.action.dismiss", fallback: "OK")
    }
  }
  internal enum GamePlay {
    internal enum Intro {
      /// WordFall
      internal static let word = Strings.tr("Localizable", "gamePlay.intro.word", fallback: "WordFall")
      internal enum Definition {
        /// a word game where you form words and names from falling letters
        internal static let text = Strings.tr("Localizable", "gamePlay.intro.definition.text", fallback: "a word game where you form words and names from falling letters")
        /// noun
        internal static let type = Strings.tr("Localizable", "gamePlay.intro.definition.type", fallback: "noun")
      }
    }
    internal enum NextButton {
      /// NEXT
      internal static let title = Strings.tr("Localizable", "gamePlay.nextButton.title", fallback: "NEXT")
    }
    internal enum PurchaseAlert {
      /// %@
      internal static func title(_ p1: Any) -> String {
        return Strings.tr("Localizable", "gamePlay.purchaseAlert.title", String(describing: p1), fallback: "%@")
      }
      internal enum PurchaseAction {
        /// Get for %@
        internal static func title(_ p1: Any) -> String {
          return Strings.tr("Localizable", "gamePlay.purchaseAlert.purchaseAction.title", String(describing: p1), fallback: "Get for %@")
        }
      }
    }
    internal enum SettingsButton {
      /// ⦿
      internal static let title = Strings.tr("Localizable", "gamePlay.settingsButton.title", fallback: "⦿")
    }
    internal enum SolveButton {
      /// REVEAL
      internal static let title = Strings.tr("Localizable", "gamePlay.solveButton.title", fallback: "REVEAL")
      internal enum Purchase {
        /// get for %@
        internal static func subtitle(_ p1: Any) -> String {
          return Strings.tr("Localizable", "gamePlay.solveButton.purchase.subtitle", String(describing: p1), fallback: "get for %@")
        }
      }
      internal enum RevealsLeft {
        /// %@ left
        internal static func subtitle(_ p1: Any) -> String {
          return Strings.tr("Localizable", "gamePlay.solveButton.revealsLeft.subtitle", String(describing: p1), fallback: "%@ left")
        }
      }
    }
  }
  internal enum Settings {
    internal enum RestorePurchasesButton {
      /// restoring...
      internal static let restoringTitle = Strings.tr("Localizable", "settings.restorePurchasesButton.restoringTitle", fallback: "restoring...")
      /// Restore purchase
      internal static let title = Strings.tr("Localizable", "settings.restorePurchasesButton.title", fallback: "Restore purchase")
    }
    internal enum Sound {
      /// Off
      internal static let off = Strings.tr("Localizable", "settings.sound.off", fallback: "Off")
      /// On
      internal static let on = Strings.tr("Localizable", "settings.sound.on", fallback: "On")
      /// SOUND
      internal static let title = Strings.tr("Localizable", "settings.sound.title", fallback: "SOUND")
    }
    internal enum WordLength {
      /// All
      internal static let all = Strings.tr("Localizable", "settings.wordLength.all", fallback: "All")
      /// WORD LENGTH
      internal static let title = Strings.tr("Localizable", "settings.wordLength.title", fallback: "WORD LENGTH")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Strings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
