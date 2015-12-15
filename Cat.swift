//
//  ZXURLProtocol.swift
//  ChinasoClient
//
//  Created by zhangxi on 12/14/15.
//  Copyright © 2015 Chinaso. All rights reserved.
//

import Foundation
import Alamofire


extension Manager {
    
    public static let cat: Manager = {
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.protocolClasses =  [Cat.self]
        configuration.HTTPAdditionalHeaders = Manager.defaultHTTPHeaders
        
        return Manager(configuration: configuration)
    }()
}


class Cat : NSURLProtocol,NSURLConnectionDelegate, NSURLConnectionDataDelegate,NSURLSessionDelegate,NSURLSessionDataDelegate
{
    static var enableCat = false
    static var urls      = [CatItem]()
        
    var connection: NSURLConnection!
    
    class func alamofire() -> Alamofire.Manager
    {
        if enableCat == true
        {
            return Alamofire.Manager.cat
        }else
        {
            return Alamofire.Manager.sharedInstance
        }
    }
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
    
    class func replace(origin:String,withString value:String)
    {
        replace(origin, type: CatItemType.String, value: value)
    }
    
    class func replace(origin:String,withFileName value:String,ofType type:String)
    {
        if let path = NSBundle.mainBundle().pathForResource(value, ofType: type)
        {
            replace(origin, type: CatItemType.File, value: path)
        }
    }
    
    class func replace(origin:String,withURL value:String)
    {
        replace(origin, type: CatItemType.URL, value: value)
    }
    
    private class func replace(origin:String,type:CatItemType,value:String)
    {
        let item = CatItem()
        item.origin = origin
        item.type = type
        item.value = value

        urls.append(item)
        

    }
    
    
    class func item(request : NSURLRequest) -> CatItem?
    {
        for item in Cat.urls
        {
            if item.origin == (request.URL?.absoluteString ?? "")
            {
                return item
            }
        }
        return nil
    }
    
    override class func canInitWithRequest(request: NSURLRequest) -> Bool {

        if item(request) != nil
        {
            if (NSURLProtocol.propertyForKey("CATProtocol", inRequest: request) != nil)
            {
                return false
            }
            return true
        }else
        {
            if (NSURLProtocol.propertyForKey("CATProtocol", inRequest: request) != nil)
            {
                return false
            }
        }
        return false
    }
    
    override class func canonicalRequestForRequest(request: NSURLRequest) -> NSURLRequest {
        if let item = item(request)
        {
            switch item.type!
            {
            case .String:
                return request
            case .File:
                return request
            case .URL:
                let newRequest = request.mutableCopy() as! NSMutableURLRequest
                newRequest.URL = NSURL(string: item.value)

                NSURLProtocol.setProperty(NSNumber(bool: true), forKey: "CATProtocol", inRequest: newRequest )
                return newRequest
            }
        }
        
        return request
    }
    
    
    override func startLoading() {
        
        if let item = Cat.item(request)
        {
            switch item.type!
            {
            case .String:

                let data     = item.value.dataUsingEncoding(NSUTF8StringEncoding)
                let response = NSURLResponse(URL: self.request.URL!, MIMEType: "", expectedContentLength: (data?.length)!, textEncodingName: "")
                
                self.client?.URLProtocol(self, didReceiveResponse: response, cacheStoragePolicy: NSURLCacheStoragePolicy.Allowed)
                self.client?.URLProtocol(self, didLoadData: data!)
                self.client?.URLProtocolDidFinishLoading(self)

                return
            case .File:
            
                let data     = NSData(contentsOfFile: item.value)
                let response = NSURLResponse(URL: self.request.URL!, MIMEType: "", expectedContentLength: (data?.length)!, textEncodingName: "")
                
                self.client?.URLProtocol(self, didReceiveResponse: response, cacheStoragePolicy: NSURLCacheStoragePolicy.Allowed)
                self.client?.URLProtocol(self, didLoadData: data!)
                self.client?.URLProtocolDidFinishLoading(self)
                
                return
            case .URL:
                
                break
                //self.connection = NSURLConnection(request: Cat.canonicalRequestForRequest(self.request), delegate: self,startImmediately:true)
                //self.client?.urlp
            }
        }

        self.connection = NSURLConnection(request: Cat.canonicalRequestForRequest(self.request), delegate: self,startImmediately:true)

    }
    
    override func stopLoading() {
        if let item = Cat.item(request)
        {
            switch item.type!
            {
            case .String:
                break
            case .File:
                break
            case .URL:
                self.connection.cancel()
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
        self.client?.URLProtocol(self, didReceiveResponse: response, cacheStoragePolicy:NSURLCacheStoragePolicy.Allowed)
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

enum CatItemType
{
    case String
    case File
    case URL
}
class CatItem : NSObject
{
    var origin:String!
    var type:CatItemType!
    var value:String!
    
}