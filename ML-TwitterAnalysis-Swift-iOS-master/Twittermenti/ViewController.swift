//  ViewController.swift
//  TwitterAnalysis

import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON

class ViewController: UIViewController
{
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
        
                                                            //Get your api keys and paste it here or create a new plist file
    let swifter = Swifter(consumerKey: valueForAPIKey(keyname:"API_Key"), consumerSecret: valueForAPIKey(keyname:"API_Secret_Key"))
    let sentimentClassifier = TweetSentimentClassifier()
    let tweetCount = 100

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    @IBAction func predictPressed(_ sender: Any)
    {
        
        fetchTweets()
        
    }
    
    func fetchTweets()
    {
        if let searchText = textField.text
        {
            //Networking with twitter API
            swifter.searchTweet(using: searchText, lang: "en", count: tweetCount, tweetMode: .extended, success: { (results, metadata) in
                // print(results)
                //JSON Parsing
                var tweetsArray = [TweetSentimentClassifierInput]()
                
                for i in 0..<self.tweetCount
                {
                    if let tweet = results[i]["full_text"].string
                    {
                        let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
                        tweetsArray.append(tweetForClassification)
                    }
                }
                self.makePredictions(with: tweetsArray)
                })

            { (error) in
                print("\(error) There was an error with twitter api request")
            }
            
            //Sample results for prediction
            //let prediction = try! sentimentClassifier.prediction(text: "@Apple is a terrible company")
            //print(prediction.label)
        }
    }
    
    func makePredictions(with tweetsArray: [TweetSentimentClassifierInput])
    {
        do
            {
                let predictions = try self.sentimentClassifier.predictions(inputs: tweetsArray)
                var sentimentScore = 0
                
                for pred in predictions
                {
                    //print(pred.label)
                    let sentiment = pred.label
                    
                    if sentiment == "Pos"
                    {
                        sentimentScore += 1
                    }
                    else if sentiment == "Neg"
                    {
                        sentimentScore -= 1
                    }
                }
                updateUI(with: sentimentScore)
                
            }
            catch { print("\(error) There was an error with making a prediction") }
    }
    
    func updateUI(with sentimentScore: Int)
    {
        //print(sentimentScore)
        
        if sentimentScore > 20
        {
            self.sentimentLabel.text = "😍 Great Results"
        }
        else if sentimentScore > 10
        {
            self.sentimentLabel.text = "😀 Good Results"
        }
        else if sentimentScore > 0
        {
            self.sentimentLabel.text = "😊 Nice Results"
        }
        else if sentimentScore == 0
        {
            self.sentimentLabel.text = "😶 Ok Results"
        }
        else if sentimentScore > -10
        {
            self.sentimentLabel.text = "😐 Poor Results"
        }
        else if sentimentScore > -20
        {
            self.sentimentLabel.text = "😡 Bad Results"
        }
        else
        {
            self.sentimentLabel.text = "🤬 Results"
        }
    }
}

