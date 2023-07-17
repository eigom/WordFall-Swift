import UIKit

public typealias StringAttributes = [NSAttributedString.Key: Any]

public enum Attributes {
    public enum Button {
        public static let title: StringAttributes = [
            .font: FontStyle.buttonTitle.font,
            .foregroundColor: Assets.Colors.Button.title.color,
            .strokeColor: UIColor.black,
            .strokeWidth: -2.0
        ]

        public static let smallTitle: StringAttributes = [
            .font: FontStyle.buttonSmallTitle.font,
            .foregroundColor: Assets.Colors.Button.smallTitle.color,
            .strokeColor: UIColor.black,
            .strokeWidth: -2.0
        ]

        public static let subtitle: StringAttributes = [
            .font: FontStyle.buttonSubtitle.font,
            .foregroundColor: Assets.Colors.Button.subtitle.color,
            .strokeColor: UIColor.black,
            .strokeWidth: -2.0
        ]
    }

    public enum WordDefinition {
        public static let type: StringAttributes = [
            .font: FontStyle.wordDefinitionType.font,
            .foregroundColor: Assets.Colors.Definition.type.color
        ]

        public static let text: StringAttributes = [
            .font: FontStyle.wordDefinition.font,
            .foregroundColor: Assets.Colors.Definition.text.color
        ]
    }

    public enum FallingLetterNode {
        public static func title(fontSize: CGFloat) -> StringAttributes {
            let shadow = NSShadow()
            shadow.shadowColor = UIColor.black
            shadow.shadowBlurRadius = 1
            shadow.shadowOffset = .init(width: 1.0, height: -1.0)

            return [
                .foregroundColor: Assets.Colors.GamePlay.letter.color,
                .font: FontStyle.fallingLetter(size: fontSize).font,
                .shadow: shadow
            ]
        }
    }

    public enum SolutionLetterNode {
        public static func title(fontSize: CGFloat) -> StringAttributes {
            let shadow = NSShadow()
            shadow.shadowColor = UIColor.black
            shadow.shadowBlurRadius = 1
            shadow.shadowOffset = .init(width: 1.0, height: -1.0)

            return [
                .foregroundColor: Assets.Colors.GamePlay.letter.color,
                .font: FontStyle.solutionLetter(size: fontSize).font,
                .shadow: shadow
            ]
        }
    }
}
