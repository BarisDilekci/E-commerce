import UIKit

final class ImageLoader {
    static let shared = ImageLoader()
    private let cache = NSCache<NSString, UIImage>()

    func load(_ urlString: String, into imageView: UIImageView, placeholder: UIImage? = nil) {
        imageView.image = placeholder
        if let cached = cache.object(forKey: urlString as NSString) {
            imageView.image = cached
            return
        }
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self, let data = data, let image = UIImage(data: data) else { return }
            self.cache.setObject(image, forKey: urlString as NSString)
            DispatchQueue.main.async { imageView.image = image }
        }.resume()
    }
}


