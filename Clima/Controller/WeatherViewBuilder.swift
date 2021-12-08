import UIKit

extension WeatherViewController {
    
    func setBackgroundImage(imageName: String) {
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(imageView, at: 0)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupView() {
        let mainStackView = createStackView(axis: .vertical, spacing: 10)
        mainStackView.alignment = .trailing
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
        
        searchStackView = SearchStackView()
        searchStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addArrangedSubview(searchStackView)
        NSLayoutConstraint.activate([
            searchStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            searchStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
        ])
        
        mainStackView.addArrangedSubview(createConditionImageView())
        NSLayoutConstraint.activate([
            conditionImageView.heightAnchor.constraint(equalToConstant: 120),
            conditionImageView.widthAnchor.constraint(equalToConstant: 120)
        ])
        
        let temperatureStackView = createStackView(axis: .horizontal, spacing: 0)
        temperatureStackView.addArrangedSubview(createTemperatureValueLabel())
        temperatureStackView.addArrangedSubview(createTemperatureUnitLabel())
        mainStackView.addArrangedSubview(temperatureStackView)
        
        mainStackView.addArrangedSubview(createCityLabel())
        mainStackView.addArrangedSubview(UIView())
    }
    
    private func createConditionImageView() -> UIImageView {
        conditionImageView = UIImageView()
        conditionImageView.image = UIImage(systemName: "cloud")
        conditionImageView.tintColor = UIColor(named: "weatherColor")
        conditionImageView.contentMode = .scaleAspectFit
        return conditionImageView
    }
    
    private func createTemperatureValueLabel() -> UILabel {
        temperatureLabel = UILabel()
        temperatureLabel.font = .systemFont(ofSize: 80, weight: .black)
        temperatureLabel.text = Localized.Weather.defaultTemperature
        return temperatureLabel
    }
    
    private func createTemperatureUnitLabel() -> UILabel {
        let temperatureUnitLabel = UILabel()
        temperatureUnitLabel.font = .systemFont(ofSize: 100, weight: .light)
        temperatureUnitLabel.text = Localized.Weather.temperatureUnit
        return temperatureUnitLabel
    }
    
    private func createCityLabel() -> UILabel {
        cityLabel = UILabel()
        cityLabel.font = .systemFont(ofSize: 30)
        cityLabel.text = Localized.Weather.defaultCity
        return cityLabel
    }
    
    private func createStackView(axis: NSLayoutConstraint.Axis, spacing: Int) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.spacing = CGFloat(spacing)
        return stackView
    }
}
