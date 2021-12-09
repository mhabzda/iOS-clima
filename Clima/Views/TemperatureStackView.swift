import UIKit

class TemperatureStackView: UIStackView {
    
    private lazy var temperatureValueLabel: UILabel = {
        let temperatureLabel = UILabel()
        temperatureLabel.font = .systemFont(ofSize: 80, weight: .black)
        temperatureLabel.text = Localized.Weather.defaultTemperature
        return temperatureLabel
    }()
    
    private lazy var temperatureUnitLabel: UILabel = {
        let temperatureUnitLabel = UILabel()
        temperatureUnitLabel.font = .systemFont(ofSize: 100, weight: .light)
        temperatureUnitLabel.text = Localized.Weather.temperatureUnit
        return temperatureUnitLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        axis = .horizontal
        spacing = 0
        
        addArrangedSubview(temperatureValueLabel)
        addArrangedSubview(temperatureUnitLabel)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTemperature(temperature: String) {
        temperatureValueLabel.text = temperature
    }
}
