import UIKit

class SearchStackView: UIStackView {
    
    private lazy var searchTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.placeholder = Localized.Weather.searchPlaceholder
        searchTextField.font = .systemFont(ofSize: 25)
        searchTextField.borderStyle = .roundedRect
        searchTextField.autocapitalizationType = .words
        searchTextField.returnKeyType = .go
        searchTextField.textAlignment = .right
        searchTextField.backgroundColor = .systemFill
        
        return searchTextField
    }()
    
    private lazy var locationButton: UIButton = {
        createButton(backgroundImageName: "location.circle.fill")
    }()
    private lazy var searchButton: UIButton =  {
        let button = createButton(backgroundImageName: "magnifyingglass")
        button.addTarget(self, action: #selector(searchPressed), for: .touchUpInside)
        return button
    }()
    
    @objc private func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        axis = .horizontal
        spacing = 10
        
        addArrangedSubview(locationButton)
        addArrangedSubview(searchTextField)
        addArrangedSubview(searchButton)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addLocationButtonAction(closure: @escaping () -> ()) {
        @objc class ClosureSleeve: NSObject {
            let closure: () -> ()
            init(_ closure: @escaping () -> ()) { self.closure = closure }
            @objc func invoke() { closure() }
        }
        let sleeve = ClosureSleeve(closure)
        locationButton.addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: .touchUpInside)
        objc_setAssociatedObject(self, "\(UUID())", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
    
    func addSearchTextFieldDelegate(delegate: UITextFieldDelegate) {
        searchTextField.delegate = delegate
    }
}

private extension SearchStackView {
    
    func createButton(backgroundImageName: String) -> UIButton {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: backgroundImageName), for: .normal)
        button.tintColor = .label
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 40),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        return button
    }
}
