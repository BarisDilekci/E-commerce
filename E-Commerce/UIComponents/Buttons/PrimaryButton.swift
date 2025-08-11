import UIKit

final class PrimaryButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = Theme.Colors.tint
        setTitleColor(.white, for: .normal)
        titleLabel?.font = Typography.titleM
        layer.cornerRadius = Theme.Radii.large
        heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}


