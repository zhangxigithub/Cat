# Cat
Cat是一个开发辅助工具，用来调试网路通信，Cat可以把一个网络请求转化成读取本地文件，或者制定的字符串，或者转化成另外一个URL.可以用来管理生产环境和开发环境的接口地址。

只是用来调试的工具，请不要用在业务逻辑中.




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
        
        return true
    }
```
#### 使用

1. 基础功能，简单替换URL为本地文件、字符串、或其他URL
```swift
Cat.replace("http://.....", withString:"I'm string replaced by Cat.") //返回值变成I'm string replaced by Cat.
Cat.replace("http://.....", withFileName: "demo", ofType: "json") //返回值变成demo.json中的内容
Cat.replace("http://111.com", withURL: "http://222.com") //请求地址由http://111.com 变成http://222.com
```

2. 替换host
```swift
Cat.replaceHost("zhangxi.me", host: "zxapi.sinaapp.com")
原始请求 http://zhangxi.me/api.json 会变成请求 http://zxapi.sinaapp.com/api.json
```