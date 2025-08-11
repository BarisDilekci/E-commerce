import UIKit

final class PromoBannerView: UIView {
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = UIColor.systemPurple.withAlphaComponent(0.12)
        layer.cornerRadius = Theme.Radii.large

        titleLabel.font = Typography.titleM
        titleLabel.textColor = Theme.Colors.textPrimary
        titleLabel.text = "CYBER LINIO"

        subtitleLabel.font = Typography.caption
        subtitleLabel.textColor = Theme.Colors.textSecondary
        subtitleLabel.text = "40% off in technology\nFree shipping"
        subtitleLabel.numberOfLines = 0

        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Vector")

        let vstack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        vstack.axis = .vertical
        vstack.spacing = 6
        vstack.translatesAutoresizingMaskIntoConstraints = false

        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(vstack)
        addSubview(imageView)

        NSLayoutConstraint.activate([
            vstack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            vstack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            vstack.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -16),

            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 140),
            imageView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}


