import UIKit

class BackgroundImageView: UIImageView {
    
    override init(image: UIImage?) {
        super.init(image: image)
        
        contentMode = .scaleAspectFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
