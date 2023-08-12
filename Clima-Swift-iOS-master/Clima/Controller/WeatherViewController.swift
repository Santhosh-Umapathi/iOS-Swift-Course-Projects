

import UIKit
import CoreLocation

                                                
class WeatherViewController: UIViewController
{

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager() // Declaring WeatherManager Struct to assign cityname
    let locationManager = CLLocationManager() // Declaring CLLocationManager to assign location coordinates
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        searchTextField.delegate = self // Declaring keyboard delegate as self to use those functionalities
        weatherManager.delegate = self  // Declaring current class as delegate for weatherManager struct
        locationManager.delegate = self // Declaring current class as delegate for CLLocationManagerDelegate struct
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    @IBAction func locationPressed(_ sender: UIButton)
    {
        locationManager.requestLocation()
    }
}
//MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate //[Using UITextFieldDelegate for keyboard functionalities] Using Extension
{
        @IBAction func searchPressed(_ sender: UIButton) // Using search button when pressed.
        {
            searchTextField.endEditing(true) // End keyboard editing and hide keyboard
            //print(searchTextField.text!)
        }
                
        func textFieldShouldReturn(_ textField: UITextField) -> Bool // Using Keyboard delegate function to use the go button when pressed.
        {
            searchTextField.endEditing(true) // End keyboard editing and hide keyboard
            //print(searchTextField.text!)
            return true
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) // When keyboard editing is completed
        {
            if let city = searchTextField.text // Using if let since text field had optional string, making it string.
            {
                weatherManager.fetchWeather(cityName: city)
            }
            searchTextField.text = ""
            searchTextField.placeholder = "Search"
        }
        
        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool // If Search text field is empty, keyboard remains for editing
        {
            if textField.text != "" // Using textField instead of searchTextField, there is only 1 text field in app, can use default name.
            {
                return true
            }
            else
            {
                textField.placeholder = "Type Something"
                return false
            }
        }
}

//MARK: -  WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate //Adopting Weather Manager Delegate, Using Extension
{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    {
        //print(weather.temperatureFormat)
        DispatchQueue.main.async // Since completion handler causes error to update UI
        {
            self.temperatureLabel.text = weather.temperatureFormat
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error)
    {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        //print("Got the location")
        if let location = locations.last // To get the last accurate location data
        {
            locationManager.stopUpdatingLocation() // To reupdate the location coordinates
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            weatherManager.fetchWeather(lattitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print(error)
    }
}

