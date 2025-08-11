import Foundation

enum PriceFormatter {
    static let shared: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        nf.locale = Locale(identifier: "tr_TR")
        nf.currencyCode = "TRY"
        return nf
    }()

    static func string(from value: Double) -> String {
        let number = NSNumber(value: value)
        return shared.string(from: number) ?? String(format: "₺%.2f", value)
    }
}


