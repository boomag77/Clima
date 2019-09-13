//Model


import Foundation

struct WeatherModel {
    let conditionID: Int
    let cityName: String
    let temperature: Double
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var conditionName: String {
        switch conditionID {
            case 200...232:
                return "cloud.bolt"
            case 300...321:
                return "cloud.drizzle"
            case 500...531:
                return "cloud.rain"
            case 600...622:
                return "cloud.snow"
            case 701...771:
                return "cloud.fog"
            case 781:
                return "tornado"
            case 800:
                return "sun.max"
            case 801...803:
                return "cloud.sun"
            default:
                return "cloud"
        }
    }
}
