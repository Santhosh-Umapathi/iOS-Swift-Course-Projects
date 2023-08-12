//
//  WeatherDataModel.swift
//  Clima
//


import Foundation

struct WeatherModel
{
    let conditionID : Int
    let cityName : String
    let temprature : Double
    
    var conditionName : String // Computed Property instead of function getConditionName(40)
    {
        switch conditionID // Using conditionID value to check conditions
        {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
    var temperatureFormat: String // Computized property to get assign 1 decimal value to temperature
    {
        return String(format: "%.1f", temprature)
    }
    
//    func getConditionName(weatherID: Int) -> String // Function to get weather condition from API
//    {
//
//    }
}
