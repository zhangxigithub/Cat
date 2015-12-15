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

        
        let api = "http://zhangxi.sinaapp.com/api/"  //return  {"name":"http:\/\/zhangxi.me","male":true}

        Cat.start()
        Cat.replace(api, withString: "{\"key\":\"I'm new json.\"}")
       
        //Cat.replace(api, withFileName: "demo", ofType: "json")
        //Cat.replace(api, withURL: "http://nfe.mgt.chinaso365.com/1/card/usercarddetail?devType=1")
        //Cat.stop()
        
        
        
        
        Cat.alamofire().request(.GET, api).responseJSON { (response:Response<AnyObject, NSError>) -> Void in
         
            print(response.debugDescription)
        }
        

        

        let request = NSURLRequest(URL:NSURL(string: api)!)
        if let data = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
        {
            let string = NSString(data: data, encoding: NSUTF8StringEncoding)
            print(string)
        }

        
        
        
    
        return true
    }



}

