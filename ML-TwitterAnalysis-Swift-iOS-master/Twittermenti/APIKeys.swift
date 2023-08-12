//
//  APIKeys.swift
//  ML-TwitterAnalysis
//
//  Created by Santhosh Umapathi on 11/14/19.
//  Copyright © 2019 Santhosh Umapathi. All rights reserved.
//

import Foundation

func valueForAPIKey(named keyname:String) -> String {
  // Credit to the original source for this technique at
  // http://blog.lazerwalker.com/blog/2014/05/14/handling-private-api-keys-in-open-source-ios-apps
  let filePath = NSBundle.main().path(forResource: "SecretKeys", ofType: "plist")
  let plist = NSDictionary(contentsOfFile:filePath!)
  let value = plist?.object(forKey: keyname) as! String
  return value
}
