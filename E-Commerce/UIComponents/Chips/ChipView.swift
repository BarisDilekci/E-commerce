import UIKit

final class ChipView: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 14, bottom: 8, right: 14)
        backgroundColor = Theme.Colors.contentBackground
        setTitleColor(Theme.Colors.textPrimary, for: .normal)
        titleLabel?.font = Typography.body
        layer.cornerRadius = Theme.Radii.large
        layer.borderColor = Theme.Colors.separator.cgColor
        layer.borderWidth = 1
    }
}


