import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    private var mainStackView: MainStackView!
    private var loadingSpinnerView: UIView!
    
    private var weatherManager = WeatherManager()
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundImage(imageName: "background")
        setupMainStackView()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
        
        weatherManager.delegate = self
    }
    
    private func setBackgroundImage(imageName: String) {
        let backgroundImageView = BackgroundImageView(image: UIImage(named: imageName))
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(backgroundImageView, at: 0)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupMainStackView() {
        mainStackView = MainStackView()
        mainStackView.alignment = .trailing
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
        
        mainStackView.addSearchTextFieldDelegate(delegate: self)
        mainStackView.addLocationButtonAction { [unowned self] in
            self.locationManager.requestLocation()
        }
    }
    
    private func displayAlert(_ errorMessage: String) {
        DispatchQueue.main.async { [self] in
            let alert = UIAlertController(title: Localized.Weather.errorTitle, message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Localized.Weather.okTitle, style: .default))
            present(alert, animated: true, completion: nil)
        }
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return textField.text != ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = textField.text {
            weatherManager.fetchWeather(cityName: city)
            showLoadingSpinner()
        }
        
        textField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weather: WeatherModel) {
        DispatchQueue.main.async { [self] in
            mainStackView.setConditionImage(conditionImageName: weather.conditionName)
            mainStackView.setTemperature(temperature: weather.temperatureText)
            mainStackView.setCity(city: weather.cityName)
            hideLoadingSpinner()
        }
    }
    
    func didFail(_ errorMessage: String) {
        displayAlert(errorMessage)
        hideLoadingSpinner()
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: latitude, longitude: longitude)
            showLoadingSpinner()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        displayAlert(error.localizedDescription)
    }
}

//MARK: - SpinnerController

extension WeatherViewController {
    
    private func showLoadingSpinner() {
        loadingSpinnerView = UIView(frame: view.bounds)
        loadingSpinnerView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        let loadingIndicator = UIActivityIndicatorView.init(style: .large)
        loadingIndicator.startAnimating()
        loadingIndicator.center = loadingSpinnerView.center
        loadingSpinnerView.addSubview(loadingIndicator)
        
        view.addSubview(loadingSpinnerView)
    }
    
    private func hideLoadingSpinner() {
        DispatchQueue.main.async { [self] in
            loadingSpinnerView?.removeFromSuperview()
            loadingSpinnerView = nil
        }
    }
}
