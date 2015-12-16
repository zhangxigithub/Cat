//
//  Cat+Alamofire.swift
//  demddddd
//
//  Created by zhangxi on 12/16/15.
//  Copyright © 2015 zhangxi.me. All rights reserved.
//

import Foundation
import Alamofire

extension Manager {
    
    public static let cat: Manager = {
        
        var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        var classes = configuration.protocolClasses
        classes?.insert(Cat.self, atIndex: 0)
        configuration.protocolClasses =  classes
        configuration.HTTPAdditionalHeaders = Manager.defaultHTTPHeaders
        
        return Manager(configuration: configuration)
    }()
}

extension Cat
{
    class func Alamofire() -> Alamofire.Manager
    {
        if enableCat
        {
            return Alamofire.Manager.cat
        }else
        {
            return Alamofire.Manager.sharedInstance
        }
    }
}