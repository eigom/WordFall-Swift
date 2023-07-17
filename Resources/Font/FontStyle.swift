import UIKit

public enum FontStyle {
    case buttonTitle
    case buttonSmallTitle
    case buttonSubtitle
    case fallingLetter(size: CGFloat)
    case solutionLetter(size: CGFloat)
    case separator
    case wordDefinition
    case wordDefinitionType
    case optionsTitle
    case selectedOption
    case unselectedOption

    public var font: UIFont {
        switch self {
        case .buttonTitle:
            return font(
                name: FontStyle.buttonFontName,
                size: fontSize(18)
            )
        case .buttonSmallTitle:
            return font(
                name: FontStyle.buttonFontName,
                size: fontSize(16)
            )
        case .buttonSubtitle:
            return font(
                name: FontStyle.buttonFontName,
                size: fontSize(13)
            )
        case .fallingLetter(let size):
            return font(
                name: FontStyle.letterFontName,
                size: size
            )
        case .solutionLetter(let size):
            return font(
                name: FontStyle.letterFontName,
                size: size
            )
        case .separator:
            return .systemFont(ofSize: fontSize(10))
        case .wordDefinition:
            return .systemFont(ofSize: fontSize(17))
        case .wordDefinitionType:
            return .systemFont(ofSize: fontSize(16))
        case .optionsTitle:
            return .systemFont(ofSize: fontSize(12))
        case .selectedOption:
            return .boldSystemFont(ofSize: fontSize(14))
        case .unselectedOption:
            return .systemFont(ofSize: fontSize(14))
        }
    }

    private static let defaultFontName = "Avenir-Black"
    private static let letterFontName = "Copperplate"
    private static let buttonFontName = "Copperplate-Bold"

    private func font(
        name: String,
        size: CGFloat
    ) -> UIFont {
        return UIFont(
            name: name,
            size: size
        ) ?? .systemFont(ofSize: size)
    }

    private func fontSize(
        _ size: CGFloat,
        for sizeClass: UIUserInterfaceSizeClass = UIScreen.main.traitCollection.horizontalSizeClass
    ) -> CGFloat {
        switch sizeClass {
        case .unspecified, .compact:
            return size
        case .regular:
            return size + 5
        @unknown default:
            return size
        }
    }
}
