//  ExtraFunctions.swift
//  Fit City
//  Created by Santhosh Umapathi on 2/1/20.
//  Copyright © 2020 App City. All rights reserved.

import UIKit
import AVFoundation
import RevealingSplashView

struct AddOns
{
    
    let splashViewNotificationName = Notification.Name("heartAttack")

    let splashView = RevealingSplashView(iconImage: UIImage(named: "Splash Icon2")!, iconInitialSize: CGSize(width: 125, height: 125), backgroundColor: UIColor.white)

    mutating func splashScreen(view: UIView)
    {
        //Setting Up Splash View
        splashView.animationType = .woobleAndZoomOut
        
        view.addSubview(splashView)
        
        
        splashView.startAnimation()
        
        playSound(soundName: "Cosmic", delay: 0)
        
       // NotificationCenter.default.addObserver(self, selector: #selector(handleSplashNotification), name: splashViewNotificationName, object: nil)
    }
    
//    @objc func handleSplashNotification()
//    {
//        splashView.heartAttack = true
//    }
    
    
    
    
    //MARK: - Calculate Age from date string
    func calcAge(birthday: String) -> Int
    {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MM/dd/yyyy"
        let birthdayDate = dateFormater.date(from: birthday)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
        let age = calcAge.year
        return age!
    }
    
    //MARK: - Error Sound Settings
    var player: AVAudioPlayer?
    mutating func playSound(soundName: String, delay: Double)
    {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else { return }
        do
        {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }

            let seconds = delay//Time To Delay
            let when = DispatchTime.now() + seconds
            DispatchQueue.main.asyncAfter(deadline: when) { player.play() }
        }
        catch let error { print("\(error.localizedDescription), Cannot play sound") }
    }
    
    
    
    
    
    
    
    
    
    //MARK: - User Login Status Check
    let userDefaults = UserDefaults.standard

    func isUserLoggedIn(value: Bool)
    {
        //Set login status of the user to true or false.
        userDefaults.set(value, forKey: "isUserLoggedIn")
        userDefaults.synchronize()
    }
    
    func setUserEmail(userEmail: String)
    {
        userDefaults.set(userEmail, forKey: "userEmail")
        userDefaults.synchronize()
    }
    
    func checkLoginStatus() -> Bool
    {
       return userDefaults.bool(forKey: "isUserLoggedIn")
    }
    
}

//MARK: - TextField Shake Animation
extension UIView
{
    func shake(for duration: TimeInterval = 0.5, withTranslation translation: CGFloat = 10)
    {
        let propertyAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.3)
        {   self.transform = CGAffineTransform(translationX: translation, y: 0) }

        propertyAnimator.addAnimations({
            self.transform = CGAffineTransform(translationX: 0, y: 0)
        }, delayFactor: 0.2)
        propertyAnimator.startAnimation()
    }
}

//MARK: - Search Bar Settings
extension UISearchBar
{
    func setClearButtonColorTo(color: UIColor)
    {
        // Clear Button
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        let crossIconView = textFieldInsideSearchBar?.value(forKey: "clearButton") as? UIButton
        crossIconView?.setImage(crossIconView?.currentImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        crossIconView?.tintColor = color
    }

    func setPlaceholderTextColorTo(color: UIColor)
    {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = color
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = color
    }

    func setMagnifyingGlassColorTo(color: UIColor)
    {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView
        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
        glassIconView?.tintColor = color
    }
}

//MARK: - HexCode to UIColor
extension UIColor
{
    convenience init(hexString: String)
    {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

//MARK: - Remove Duplicates from Array
extension Array where Element:Equatable
{
    func removeDuplicates() -> [Element]
    {
        var result = [Element]()
        for value in self
        {
            if result.contains(value) == false
            {
                result.append(value)
            }
        }
        return result
    }
}

//MARK: - Loading User Image with Cache

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView
{
    
    
    func loadImageWithCacheUsingURLString(URLString: String)
    {
        self.image = nil
        
        // Check Cache for Image first
        if let cachedIamge = imageCache.object(forKey: URLString as AnyObject) as? UIImage
        {
            self.image = cachedIamge
            return
        }
        
        // Fire the Download Images
        let urlFB = URL(string: URLString)
        //Downloading User Image
        URLSession.shared.dataTask(with: urlFB!)
        { (data, response, error) in
            if error != nil { print(error!.localizedDescription) }
            DispatchQueue.main.async //Loading User Image & Caching
            {
                    if let downloadedImage = UIImage(data: data!)
                    {
                        imageCache.setObject(downloadedImage, forKey: URLString as AnyObject)
                        self.image = downloadedImage
                    }
            }
        }.resume()
    }
    
    
    
    
}

//MARK: - Keyboard Dismiss
extension UIViewController: UITextFieldDelegate
{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    
    
    func autoLogin()
    {
        if UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        {
            DispatchQueue.main.async
            {
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let controller = storyboard.instantiateViewController(withIdentifier: "WelcomeScreenVC")
                let navController = UINavigationController(rootViewController: controller)
                
                self.present(navController, animated: true, completion: nil)
            }
         
            
        }
      }
    
    
    
    
    
}

//MARK: - Adding Arrays with For Loop

struct TupleIterator: Sequence, IteratorProtocol
{
    private var firstIterator: IndexingIterator<[String]>
    private var secondIterator: IndexingIterator<[String]>
    private var thirdIterator: IndexingIterator<[String]>
    private var fourthIterator: IndexingIterator<[String]>

    
    
    init(firstArray: [String], secondArray: [String], thirdArray: [String], fourthArray: [String])
    {
        self.firstIterator = firstArray.makeIterator()
        self.secondIterator = secondArray.makeIterator()
        self.thirdIterator = thirdArray.makeIterator()
        self.fourthIterator = fourthArray.makeIterator()

    }
    
    mutating func next() -> (String, String, String, String)?
    {
        guard let el1 = firstIterator.next(), let el2 = secondIterator.next(), let el3 = thirdIterator.next(), let el4 = fourthIterator.next() else { return nil }
        return (el1, el2, el3, el4)
    }
    
    
}


extension UIView
{
    //View Anchor Settings
    //For adding padding to to view, use padding.init method on the call
    
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero)
    {
        translatesAutoresizingMaskIntoConstraints = false
        
        
        if let top = top
        {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading
        {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom
        {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
      
        
        if let trailing = trailing
        {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        
        
        if size.width != 0
        {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0
        {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
}
