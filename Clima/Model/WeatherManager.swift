import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weather: WeatherModel)
    func didFail(_ errorMessage: String)
}

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=\(apiToken)&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: Double, longitude: Double) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    private func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate?.didFail(error!.localizedDescription)
                }
                
                if let safeData = data {
                    parseJSON(weatherData: safeData)
                }
            }
            
            task.resume()
        }
    }
    
    private func parseJSON(weatherData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let weather = WeatherModel(
                conditonId: decodedData.weather[0].id,
                cityName: decodedData.name,
                temperature: decodedData.main.temp
            )
            
            delegate?.didUpdateWeather(weather)
        } catch {
            delegate?.didFail(error.localizedDescription)
        }
    }
}
