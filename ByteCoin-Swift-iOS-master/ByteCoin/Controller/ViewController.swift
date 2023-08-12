//
//  ViewController.swift
//  ByteCoin
//

import UIKit
                                        //Adding DataSource   , Adding Delegate
class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CoinManagerDelegate
{
    var coinManager = CoinManager() // Declaring CoinManager struct and Initialize
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currenyPicker: UIPickerView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        currenyPicker.dataSource = self // Declaring current class as datasource
        currenyPicker.delegate = self   // Declaring current class as Delegate
        coinManager.delegate = self     // Declaring current class as CoinManagerDelegate
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int // no.of Columns
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int // No.of Rows
    {
        //print(coinManager.currencyArray.count)
        return coinManager.currencyArray.count
    }
    
    // Setting Row title from CoinManager Struct
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return coinManager.currencyArray[row]
    }
    
    // When row selection is made
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let coinName = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: coinName)
        currencyLabel.text = coinName
    }

    func didUpdateData(_ coinManager: CoinManager, coinModel: CoinModel)
    {
        DispatchQueue.main.async // Since completion handler causes error to update UI
        {
            self.bitcoinLabel.text = "\(coinModel.last)"
        }
    }
       
    func didFailWithError(error: Error)
    {
        print(error)
    }
}

