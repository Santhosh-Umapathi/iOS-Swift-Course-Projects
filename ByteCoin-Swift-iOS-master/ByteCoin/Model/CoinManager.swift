//
//  CoinManager.swift
//  ByteCoin
//
//

import Foundation


protocol CoinManagerDelegate
{
    func didUpdateData( _ coinManager: CoinManager, coinModel: CoinModel)
    func didFailWithError(error: Error)
}


struct CoinManager
{
    
    let baseURL = ""
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate? // Declaring Protocol and creating delegate
    
    
    func getCoinPrice(for currency: String) // Getting value from ViewController
    {
        let finalURL = "\(baseURL)\(currency)"
        performRequest(with: finalURL) // Passing the finalUrl for getting response
    }
    
    //MARK: - Networking
    func performRequest(with urlString: String) // Use of parameter names
    {
        // -- 1. Create a URL --
        if let url = URL(string: urlString) // URL struct from Apple
        {
        // -- 2. Create a URL Session --
        let session = URLSession(configuration: .default) //URLSession struct from Apple
                
        // -- 3. Give the session a task --
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
                //let dataString = String(data: safeData, encoding: .utf8) // Since encoded data is not printable
                //print(dataString)
                if let coin = self.parseJSON(safeData) // Implement the JSON parsing for data received.Parameter names used.
                {
                // Better to use Delegate for code reusability
                    self.delegate?.didUpdateData(self, coinModel: coin) // Declaring the delegate
                }
            }
            }
            // -- 4. Start a task --
            task.resume() // To start/resume to task since it can be suspended.
        }
    }
    
    //MARK: - JSON Parsing
    func parseJSON(_ coinData: Data) -> CoinModel? // Parsing JSON format to swift readable. Using Parameter names
        {
            let decoder = JSONDecoder() // Initialize JSON decoder class from apple
            do
            {
                let decodedData = try decoder.decode(CoinData.self, from: coinData) // Using CoinData Struct to confirm decodable protocol here
                let lastPrice = decodedData.last // Data retreived from CoinData Struct/API

                let coin = CoinModel(last: lastPrice) // Initializing coin model struct to assign API values
                return coin
            }
            catch
            {
                //print(error)
                delegate?.didFailWithError(error: error)
                return nil
            }
        }
}
