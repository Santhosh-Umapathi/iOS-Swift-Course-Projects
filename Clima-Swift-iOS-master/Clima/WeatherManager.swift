//
//  WeatherManager.swift
//  Clima
//


import Foundation
import CoreLocation

protocol WeatherManagerDelegate // Creating a Delegate protocol to use on perform request.
{
    func didUpdateWeather( _ weatherManager: WeatherManager,  weather: WeatherModel)
    func didFailWithError(error: Error)
}


struct WeatherManager
{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&units=metric&appid="
    var delegate: WeatherManagerDelegate? // Assigning the WeatherManager as delegate for WeatherManagerDelegate Optional
    
    func fetchWeather(cityName: String)
    {
        let urlString = "\(weatherURL)&q=\(cityName)" // Complete weather URL
        //print(urlString)
        performRequest(with: urlString) // Assign parameter names
    }
    
    func fetchWeather(lattitude: CLLocationDegrees, longitude: CLLocationDegrees) // Type alias for lat & lon degrees
    {
        let urlString = "\(weatherURL)&lat=\(lattitude)&lon=\(longitude)" // Complete weather URL
        //print(urlString)
        performRequest(with: urlString) // Assign parameter names
    }
    
    
    // Performing Networking
    //***********************************************
    func performRequest(with urlString: String) // Use of parameter names
    {
        // 1. Create a URL
        if let url = URL(string: urlString) // URL struct from Apple
        {
        // 2. Create a URL Session
            let session = URLSession(configuration: .default) //URLSession struct from Apple
            
        // 3. Give the session a task
        //let task = session.dataTask(with: url, completionHandler: handler(data:urlResponse:error:)) // DataTask from apple // Completion handler can use either the method handler(39) or simply use closure
            
            // Using closure for same way
            let task = session.dataTask(with: url) { (data, response, error) in
                 if error != nil
                    {
                        //print(error!)
                        self.delegate?.didFailWithError(error: error!)
                        return // Just exit this if condition
                    }
                    if let safeData = data
                    {
                    if let weather = self.parseJSON(safeData) // Implement the JSON parsing for data received. Parameter names used.
                    {
//                        let weatherVC = WeatherViewController()
//                        weatherVC.didUpdateWeather(weather: weather)
                        
                        // Better to use Delegate for code reusability
                        self.delegate?.didUpdateWeather(self, weather: weather) // Declaring the delegate
                    }
                    }
            }
        // 4. Start a task
            task.resume() // To start/resume to task since it can be suspended.
        }
    }
    
    // Parsing JSON
    //************************************
    func parseJSON(_ weatherData: Data) -> WeatherModel? // Parsing JSON format to swift readable. Using Parameter names
    {
        let decoder = JSONDecoder() // Initialize JSON decoder class from apple
        do
        {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData) // Using WeatherData Struct to confirm decodable protocol here
            let id = decodedData.weather[0].id // Data retreived from WeatherData Struct/API
            let name = decodedData.name // Data retreived from WeatherData Struct/API
            let temp = decodedData.main.temp // Data retreived from WeatherData Struct/API
            
            let weather = WeatherModel(conditionID: id, cityName: name, temprature: temp) // Initializing weather model struct to assign API values
            
//          print(weather.temperatureFormat)
            return weather
            
//           getConditionName(weatherID: id) // Getting weather condition from API using id from function
        }
        catch
        {
            //print(error)
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    //    func handler(data: Data? , urlResponse: URLResponse?, error: Error?) -> Void // Creating method for completion handler line 31.
    //    {
    //        if error != nil
    //        {
    //            print(error!)
    //            return // Just exit this if condition
    //        }
    //        if let safeData = data
    //        {
    //            let dataString = String(data: safeData, encoding: .utf8) // Since data is encoded, have to convert to string.
    //            print(dataString)
    //        }

}
    

    

        
        
    
    
    


    
