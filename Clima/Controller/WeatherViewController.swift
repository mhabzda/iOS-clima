import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    var conditionImageView: UIImageView!
    var temperatureLabel: UILabel!
    var cityLabel: UILabel!
    
    var searchStackView: SearchStackView!
    
    private var loadingSpinnerView: UIView!
    
    private var weatherManager = WeatherManager()
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundImage(imageName: "background")
        setupView()
        
        searchStackView.addSearchTextFieldDelegate(delegate: self)
        searchStackView.addLocationButtonAction { [unowned self] in
            self.locationManager.requestLocation()
        }
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
        
        weatherManager.delegate = self
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
            conditionImageView.image = UIImage(systemName: weather.conditionName)
            temperatureLabel.text = weather.temperatureText
            cityLabel.text = weather.cityName
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
