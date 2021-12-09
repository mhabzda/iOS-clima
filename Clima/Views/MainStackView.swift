import UIKit

class MainStackView: UIStackView {
    
    private lazy var searchStackView: SearchStackView = {
        SearchStackView()
    }()
    
    private lazy var conditionImageView: UIImageView = {
        let conditionImageView = UIImageView()
        conditionImageView.image = UIImage(systemName: "cloud")
        conditionImageView.tintColor = UIColor(named: "weatherColor")
        conditionImageView.contentMode = .scaleAspectFit
        return conditionImageView
    }()
    
    private lazy var temperatureStackView: TemperatureStackView = {
        TemperatureStackView()
    }()
    
    private lazy var cityLabel: UILabel = {
        let cityLabel = UILabel()
        cityLabel.font = .systemFont(ofSize: 30)
        cityLabel.text = Localized.Weather.defaultCity
        return cityLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        axis = .vertical
        spacing = 10
        
        addArrangedSubview(searchStackView)
        addArrangedSubview(conditionImageView)
        addArrangedSubview(temperatureStackView)
        addArrangedSubview(cityLabel)
        addArrangedSubview(UIView())
        
        setupLayout()
    }
    
    private func setupLayout() {
        searchStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            conditionImageView.heightAnchor.constraint(equalToConstant: 120),
            conditionImageView.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addLocationButtonAction(closure: @escaping () -> ()) {
        searchStackView.addLocationButtonAction(closure: closure)
    }
    
    func addSearchTextFieldDelegate(delegate: UITextFieldDelegate) {
        searchStackView.addSearchTextFieldDelegate(delegate: delegate)
    }
    
    func setConditionImage(conditionImageName: String) {
        conditionImageView.image = UIImage(systemName: conditionImageName)
    }
    
    func setTemperature(temperature: String) {
        temperatureStackView.setTemperature(temperature: temperature)
    }
    
    func setCity(city: String) {
        cityLabel.text = city
    }
 }
