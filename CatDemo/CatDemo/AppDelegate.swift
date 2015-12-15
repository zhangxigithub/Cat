//
//  AppDelegate.swift
//  CatDemo
//
//  Created by zhangxi on 12/15/15.
//  Copyright © 2015 zhangxi.me. All rights reserved.
//

import UIKit
import Alamofire


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        
        let api1 = "http://zhangxi.sinaapp.com/cat/index.php"
        //return  {"name":"http:\/\/zhangxi.me","male":true}
        let api2 = "http://zhangxi.sinaapp.com/cat/index2.php"
        //return  {"name":"http:\/\/zhangxi.me","description":"demo api 2"}

        Cat.start()
        
        
        //Cat.replace(api1, withString: "{\"key\":\"I'm new json.\"}")
        Cat.replace(api1, withFileName: "demo", ofType: "json")
        //Cat.replace(api1, withURL: api2)
        //Cat.stop()
        
        
        Cat.alamofire().request(.GET, api1).responseJSON { (response:Response<AnyObject, NSError>) -> Void in
            print("replaced data with alamofire: \(response.result.value)\n")
        }
        


        let request = NSURLRequest(URL:NSURL(string: api1)!)
        if let data = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
        {
            let string = NSString(data: data, encoding: NSUTF8StringEncoding)
            print("replaced data with NSURLConnection: \(string)\n")
        }

        
        
        
    
        return true
    }



}

