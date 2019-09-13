import UIKit
import CoreLocation

protocol WeatherManagerDelegate {
    func updateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    let apiKey: String = "a201425a6e77568bc89d266f3a24d4d5"
    let urlString: String = "https://api.openweathermap.org/data/2.5/weather?"
    let units: Units = .metric
    
    var delegate: WeatherManagerDelegate?
    
    func getWeather(forcity cityName: String?) {
        if let city = cityName {
            let string = createUrlString(city)
            performRequest(with: string)
        }
    }
    
    func getWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let string = createUrlString(latitude: latitude, longitude: longitude)
        performRequest(with: string)
    }
   
    
    private func createUrlString(_ cityName: String) -> String {
        let keyPrefix: String = "appid"
        let unitsPrefix: String = "units"
        
        let fullURLString: String = "\(urlString)q=\(cityName)&\(unitsPrefix)=\(units)&\(keyPrefix)=\(apiKey)"
        return fullURLString
    }
    
    private func createUrlString(latitude lat: CLLocationDegrees, longitude lon: CLLocationDegrees) -> String {
        let keyPrefix: String = "appid"
        let unitsPrefix: String = "units"
        
        let fullURLString: String = "\(urlString)lat=\(lat)&lon=\(lon)&\(unitsPrefix)=\(units)&\(keyPrefix)=\(apiKey)"
        return fullURLString
    }
    
    private func performRequest(with string: String) {
        if let url = URL(string: string) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, responce, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    DispatchQueue.main.async {
                        if let weather = self.parseJSON(safeData) {
                            self.delegate?.updateWeather(self, weather: weather)
                        }
                    }
                    
                }
            }
            task.resume()
        }
    }
    
    private func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionID: id, cityName: name, temperature: temp)
            return weather
            
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
