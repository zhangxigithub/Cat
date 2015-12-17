# Cat
Cat是一个开发辅助工具，用来调试网路通信，Cat可以把一个网络请求转化成读取本地文件，或者制定的字符串，或者转化成另外一个URL.可以用来管理生产环境和开发环境的接口地址。

只是用来调试的工具，请不要用在业务逻辑中.

思路:在程序一开始的时候统一设置request替换规则，不影响原来的项目代码，方便管理和控制。切换成线下地址或者用本地json文件调试时不影响项目的业务逻辑。


#### Alamofire

如果使用Alamofire,需要额外引入Cat+Alamofire.swift文件 ，请求时使用Cat.Alamofire()代替Alamofire
```swift
Cat.Alamofire().request(.GET, api1).responseString(encoding: NSUTF8StringEncoding) { (response:Response<String, NSError>) -> Void in
            print(response.result.value)
}
```


#### 集成

1. 把 Cat.swift 拖到项目中
2. 调用 Cat.start() 方法，建议在程序一开始调用，把所有需要替换的URL统一放在程序一开始。

```swift
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
        Cat.start() 
        Cat.replace.......
        
        return true
    }
```
#### 使用
提供三种基本功能，把返回结果替换成本地文件、字符串、或其他URL


1.替换成字符串

```swift
Cat.replace({ (request) -> Bool in
    //当返回true时，表示改request需要替换
    return true/false

    }, withString: { (request) -> String in
        //返回替换之后的字符串
        return "I'm string replaced by Cat[condition]."
})
```

2.替换成本地文件的内容

```swift
Cat.replace({ (request) -> Bool in
    //当返回true时，表示改request需要替换
    return true/false

    }, withFile: { (request) -> String in
        //返回本地文件的路径
        return NSBundle.mainBundle().pathForResource("demo", ofType: "json")!
})
```

3.替换成其他请求,可以自由修改URL或者参数

```swift
Cat.replace({ (request) -> Bool in
    //当返回true时，表示改request需要替换
    return true/false

    }, withRequest: { (request) -> String in
        //返回新的NSURLRequest
        return NSURLRequest(URL: NSURL(string: self.api2)!)
})
```


还有一些特殊替换
1.替换host
```swift
Cat.replaceHost("zhangxi.me", host: "zxapi.sinaapp.com")
原始请求 http://zhangxi.me/api.json 会变成请求 http://zxapi.sinaapp.com/api.json
```
