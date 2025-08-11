import UIKit

final class PriceView: UIView {
    private let currentLabel = UILabel()
    private let originalLabel = UILabel()
    private let badgeLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        currentLabel.font = Typography.titleL
        currentLabel.textColor = Theme.Colors.textPrimary

        originalLabel.font = Typography.body
        originalLabel.textColor = Theme.Colors.textSecondary

        badgeLabel.font = Typography.caption
        badgeLabel.textColor = Theme.Colors.danger
        badgeLabel.backgroundColor = Theme.Colors.danger.withAlphaComponent(0.08)
        badgeLabel.textAlignment = .center
        badgeLabel.layer.cornerRadius = Theme.Radii.small
        badgeLabel.layer.masksToBounds = true

        let vstack = UIStackView(arrangedSubviews: [currentLabel, originalLabel, badgeLabel])
        vstack.axis = .vertical
        vstack.alignment = .leading
        vstack.spacing = 6
        vstack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(vstack)
        NSLayoutConstraint.activate([
            vstack.topAnchor.constraint(equalTo: topAnchor),
            vstack.leadingAnchor.constraint(equalTo: leadingAnchor),
            vstack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            vstack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func configure(price: Double, discount: Double) {
        currentLabel.text = PriceFormatter.string(from: price * (1 - discount/100))
        originalLabel.isHidden = discount <= 0
        badgeLabel.isHidden = discount <= 0

        if discount > 0 {
            let original = PriceFormatter.string(from: price)
            let attributed = NSMutableAttributedString(string: original)
            attributed.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributed.length))
            originalLabel.attributedText = attributed
            badgeLabel.text = "%\(Int(discount)) indirim"
        }
    }
}


