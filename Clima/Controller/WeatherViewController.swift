import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    var searchTextField: UITextField!
    var locationButton: UIButton!
    var searchButton: UIButton!
    
    var conditionImageView: UIImageView!
    var temperatureLabel: UILabel!
    var cityLabel: UILabel!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func loadView() {
        view = UIView()
        
        setBackgroundImage(imageName: "background")
        setupView()
        
        searchButton.addTarget(self, action: #selector(searchPressed), for: .touchUpInside)
        locationButton.addTarget(self, action: #selector(locationPressed), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
    }
    
    @objc private func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    @objc private func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    private func displayAlert(_ errorMessage: String) {
        DispatchQueue.main.async { [self] in
            let alert = UIAlertController(title: "ErrorTitle".localize(), message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OkTitle".localize(), style: .default))
            present(alert, animated: true, completion: nil)
        }
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return textField.text != ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = textField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weather: WeatherModel) {
        DispatchQueue.main.async { [self] in
            conditionImageView.image = UIImage(systemName: weather.conditionName)
            temperatureLabel.text = weather.temperatureText
            cityLabel.text = weather.cityName
        }
    }
    
    func didFail(_ errorMessage: String) {
        displayAlert(errorMessage)
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
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        displayAlert(error.localizedDescription)
    }
}
