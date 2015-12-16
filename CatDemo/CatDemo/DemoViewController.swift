//
//  DemoViewController.swift
//  CatDemo
//
//  Created by zhangxi on 12/16/15.
//  Copyright © 2015 zhangxi.me. All rights reserved.
//

import UIKit
import Alamofire

class DemoViewController: UIViewController {


    
    @IBAction func request(sender: AnyObject) {
        

        //use alamofire
        Cat.alamofire().request(.GET, api1).responseString(encoding: NSUTF8StringEncoding) { (response:Response<String, NSError>) -> Void in

            self.content.text = response.result.value
        }
        
        //you can use NSURLConnection,NSURLSession and so on
        
        /*
        let request = NSURLRequest(URL: NSURL(string: api1)!)
        if let data = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
        {
            let string = String(data: data, encoding: NSUTF8StringEncoding)
            self.content.text = string
        }
        */

    
    }
    
    
    @IBAction func changState(sender: UISwitch) {
        
        sender.on = true
        
        for s in [s1,s2,s3,s4]
        {
            if s != sender
            {
                s.on = !sender.on
            }
        }
        
        if s1.on
        {//original url
            Cat.stop()
        }
        if s2.on
        {//replace by string
            Cat.clean()
            Cat.start()
            Cat.replace(api1, withString:"I'm string replaced by Cat.")
        }
        if s3.on
        {//replace by content of file
            Cat.clean()
            Cat.start()
            Cat.replace(api1, withFileName: "demo", ofType: "json")

        }
        if s4.on
        {//replace by another url
            Cat.clean()
            Cat.start()
            Cat.replace(api1, withURL: api2)
        }
    }
    
    let api1 = "http://zhangxi.sinaapp.com/cat/index.php"
    let api2 = "http://zhangxi.sinaapp.com/cat/index2.php"
    
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var s1: UISwitch!
    @IBOutlet weak var s2: UISwitch!
    @IBOutlet weak var s3: UISwitch!
    @IBOutlet weak var s4: UISwitch!
    
}