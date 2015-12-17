//
//  ZXURLProtocol.swift
//  ChinasoClient
//
//  Created by zhangxi on 12/14/15.
//  Copyright © 2015 Chinaso. All rights reserved.
//

import Foundation



class Cat : NSURLProtocol,NSURLConnectionDelegate, NSURLConnectionDataDelegate,NSURLSessionDelegate,NSURLSessionDataDelegate
{
    static var enableCat = false
    
    static var conditions = [CatCondition]()
    
    
    var connection: NSURLConnection!
    

    class func start()
    {
        enableCat = true
        NSURLProtocol.registerClass(Cat)
    }
    class func stop()
    {
        enableCat = false
        NSURLProtocol.unregisterClass(Cat)
    }
    class func clean()
    {
        conditions.removeAll()
    }
    
    
    
    
    class func replace(condition:(request:NSURLRequest) -> Bool , withRequest result:(request:NSURLRequest) -> NSURLRequest)
    {
        let theCondition = CatCondition()
        theCondition.condition = condition
        theCondition.type = .Request
        theCondition.result = result
        
        conditions.append(theCondition)
    }
    
    class func replace(condition:(request:NSURLRequest) -> Bool , withString result:(request:NSURLRequest) -> String)
    {
        let theCondition = CatCondition()
        theCondition.condition = condition
        theCondition.type = .String
        theCondition.result = result
        
        conditions.append(theCondition)
    }
    
    class func replace(condition:(request:NSURLRequest) -> Bool , withFilePath result:(request:NSURLRequest) -> String)
    {
        let theCondition = CatCondition()
        theCondition.condition = condition
        theCondition.type = .File
        theCondition.result = result
        
        conditions.append(theCondition)
    }
    
    class func replaceHost(origin:String,host:String)
    {
        let theCondition = CatCondition()
        theCondition.type = .Request
        conditions.append(theCondition)
        
        
        
        theCondition.condition = {(request) -> Bool in
            
            if let URLComponents = NSURLComponents(string: request.URL?.absoluteString ?? "")
            {
                if URLComponents.host == origin
                {
                    return true
                }
            }
            return false
        }
        
        theCondition.result = {(request) -> NSURLRequest in
            
            if let URLComponents = NSURLComponents(string: request.URL?.absoluteString ?? "")
            {
                if URLComponents.host == origin
                {
                    let newRequest = request.mutableCopy() as! NSMutableURLRequest
                    URLComponents.host = host
                    newRequest.URL = URLComponents.URL
                    return newRequest
                }
            }
            return NSURLRequest()
        }
    }
    
    
    private class func findCondition(request : NSURLRequest) -> CatCondition?
    {
        for condition in conditions
        {
            if condition.condition(request:request) == true
            {
                return condition
            }
        }
        return nil
    }
    
    
    override class func canInitWithRequest(request: NSURLRequest) -> Bool {

        if Cat.enableCat == false
        {
            return false
        }
        
        if (NSURLProtocol.propertyForKey("CATProtocol", inRequest: request) != nil)
        {
            return false
        }
        
        if let _ = Cat.findCondition(request)
        {
            return true
        }
        

        
        return false
    }
    
    override class func canonicalRequestForRequest(request: NSURLRequest) -> NSURLRequest {
        
        
        if let condition = Cat.findCondition(request)
        {
            switch condition.type!
            {
            case .Request:
                
                let newRequest        = condition.result(request:request) as! NSURLRequest
                let newMutableRequest = newRequest.mutableCopy() as! NSMutableURLRequest
                NSURLProtocol.setProperty(NSNumber(bool: true), forKey: "CATProtocol", inRequest: newMutableRequest)
                return newMutableRequest
                
            case .String:
                break
            case .File:
                break
            default:
                break
            }
        }
        

        return request
    }
    
    
    override func startLoading() {
        
        if let condition = Cat.findCondition(request)
        {
            switch condition.type!
            {
            case .Request:
                break
            case .String:
                let string   = condition.result(request:request) as! String
                let data     = string.dataUsingEncoding(NSUTF8StringEncoding)
                let response = NSURLResponse(URL: self.request.URL!, MIMEType: "", expectedContentLength: (data?.length)!, textEncodingName: "")
                
                self.client?.URLProtocol(self, didReceiveResponse: response, cacheStoragePolicy: NSURLCacheStoragePolicy.NotAllowed)
                self.client?.URLProtocol(self, didLoadData: data!)
                self.client?.URLProtocolDidFinishLoading(self)
                
                return
            case .File:
                let path     = condition.result(request:request) as! String
                let data     = NSData(contentsOfFile: path)
                let response = NSURLResponse(URL: self.request.URL!, MIMEType: "", expectedContentLength: (data?.length)!, textEncodingName: "")
                
                self.client?.URLProtocol(self, didReceiveResponse: response, cacheStoragePolicy: NSURLCacheStoragePolicy.NotAllowed)
                self.client?.URLProtocol(self, didLoadData: data!)
                self.client?.URLProtocolDidFinishLoading(self)
                
                return
            default:
                break
            }
        }

        self.connection = NSURLConnection(request: Cat.canonicalRequestForRequest(self.request), delegate: self,startImmediately:true)
        
    }
    
    override func stopLoading() {
        
        if let condition = Cat.findCondition(request)
        {
            switch condition.type!
            {
            case .Request:
                self.connection.cancel()
            default:
                break
            }
        }
    }
    
    
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        self.client?.URLProtocol(self, didFailWithError: error)
    }
    func connectionShouldUseCredentialStorage(connection: NSURLConnection) -> Bool {
        return true
    }
    func connection(connection: NSURLConnection, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge) {
        self.client?.URLProtocol(self, didReceiveAuthenticationChallenge: challenge)
    }
    func connection(connection: NSURLConnection, didCancelAuthenticationChallenge challenge: NSURLAuthenticationChallenge) {
        self.client?.URLProtocol(self, didCancelAuthenticationChallenge: challenge)
    }
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        self.client?.URLProtocol(self, didReceiveResponse: response, cacheStoragePolicy:NSURLCacheStoragePolicy.NotAllowed)
    }
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        self.client?.URLProtocol(self, didLoadData: data)
    }
    func connection(connection: NSURLConnection, willCacheResponse cachedResponse: NSCachedURLResponse) -> NSCachedURLResponse? {
        return cachedResponse
    }
    func connectionDidFinishLoading(connection: NSURLConnection) {
        self.client?.URLProtocolDidFinishLoading(self)
    }

}

enum CatConditionType
{
    case String
    case File
    case Request
}

class CatCondition : NSObject
{
    var condition:((request:NSURLRequest) -> Bool)!
    var result:((request:NSURLRequest) -> Any)!
    var type:CatConditionType!
}