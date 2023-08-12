//
//  QuoteTableViewController.swift
//  InspoQuotes
//
//

import UIKit
import StoreKit // For In-App purchases

class QuoteTableViewController: UITableViewController, SKPaymentTransactionObserver
{
    let productID = "" // Product ID from apple developer account.
    
    var quotesToShow = [
        "Our greatest glory is not in never falling, but in rising every time we fall. — Confucius",
        "All our dreams can come true, if we have the courage to pursue them. – Walt Disney",
        "It does not matter how slowly you go as long as you do not stop. – Confucius",
        "Everything you’ve ever wanted is on the other side of fear. — George Addair",
        "Success is not final, failure is not fatal: it is the courage to continue that counts. – Winston Churchill",
        "Hardships often prepare ordinary people for an extraordinary destiny. – C.S. Lewis"
    ]
    
    let premiumQuotes = [
        "Believe in yourself. You are braver than you think, more talented than you know, and capable of more than you imagine. ― Roy T. Bennett",
        "I learned that courage was not the absence of fear, but the triumph over it. The brave man is not he who does not feel afraid, but he who conquers that fear. – Nelson Mandela",
        "There is only one thing that makes a dream impossible to achieve: the fear of failure. ― Paulo Coelho",
        "It’s not whether you get knocked down. It’s whether you get up. – Vince Lombardi",
        "Your true success in life begins only when you make the commitment to become excellent at what you do. — Brian Tracy",
        "Believe in yourself, take on your challenges, dig deep within yourself to conquer fears. Never let anyone bring you down. You got to keep going. – Chantal Sutherland"
    ]

    override func viewDidLoad()
    {
        super.viewDidLoad()
        SKPaymentQueue.default().add(self) //Setting the observer as current class.
        
        if isPurchased()
        {
            showPremiumQuotes()
        }
    }

    // MARK: - TableView data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if isPurchased()
        {
            return quotesToShow.count
        }
        else
        {
            return quotesToShow.count + 1 //Extra cell for app purchases button
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)
        
        
        if indexPath.row < quotesToShow.count //Display basic features.
        {
            cell.textLabel?.text = quotesToShow[indexPath.row]
            cell.textLabel?.numberOfLines = 0 //Setting no.of lines to display full text
            cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.accessoryType = .none
        }
        else //Display purchase in last cell
        {
            cell.textLabel?.text = "Buy more Quotes"
            cell.textLabel?.textColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.textAlignment = .center
        }
        return cell
    }

    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == quotesToShow.count
        {
            buyPremiumQuotes()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Buy Premium / Show Premium features
    func buyPremiumQuotes()
    {
        if SKPaymentQueue.canMakePayments() //Can make payments
        {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productID //Setting up the product id for payment
            SKPaymentQueue.default().add(paymentRequest) //Adding payment request to apple
        }
        else //cant make payments
        {
            print("Failed Transaction")
        }
    }
    
    func showPremiumQuotes()
    {
        quotesToShow.append(contentsOf: premiumQuotes) //Adding premium features to existing feature.
        UserDefaults.standard.set(true, forKey: productID) //Checking if premium purchase already made. Saving in UserDefaults.
        tableView.reloadData()
    }
    
    //MARK: - In-App Purchase methods
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction])
    {
        for transactionStatus in transactions
        {
            if transactionStatus.transactionState == .purchased
            {
                //Made purchase
                print("Purchase Successfull")
                showPremiumQuotes()
                SKPaymentQueue.default().finishTransaction(transactionStatus) //Transaction completed
                
            }
            else if transactionStatus.transactionState == .failed
            {
                //failed purchase
                let errorDesc = transactionStatus.error!.localizedDescription
                
                print("Purchase Failed \(errorDesc)")
                SKPaymentQueue.default().finishTransaction(transactionStatus) //Transaction completed
            }
            else if transactionStatus.transactionState == .restored
            {
                print("Transaction restored")
                showPremiumQuotes()
                navigationItem.setRightBarButton(nil, animated: true)
                
                SKPaymentQueue.default().finishTransaction(transactionStatus)
            }
        }
    }
    
    //To check if preimum already purchased.
    func isPurchased() -> Bool
    {
        let purchaseStatus = UserDefaults.standard.bool(forKey: productID) //Passing bool value from DB to object
        
        if purchaseStatus
        {
            print("Already purchased")
            return true
        }
        else
        {
            print("Never purchased")
            return false
        }
    }
    
//MARK: - Restore Button
    
    @IBAction func restorePressed(_ sender: UIBarButtonItem)
    {
        SKPaymentQueue.default().restoreCompletedTransactions() //Restoring payment info from apple
    }
}
