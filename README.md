# Cat
Cat是一个开发辅助工具，用来调试网路通信，Cat可以把一个网络请求转化成读取本地文件，或者制定的字符串，或者转化成另外一个URL.可以用来管理生产环境和开发环境的接口地址。






#### Alamofire

如果使用Alamofire,需要额外Cat+Alamofire.swift ，请求时，使用Cat.alamofire()代替Alamofire



#### USE

1.把 Cat.swift 拖到项目中
2.调用 Cat.start() 方法，建议在程序一开始调用，把所有需要替换的URL统一放在程序一开始。


```swift
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Cat.start() 
        
        return true
    }
```

3.基础功能，简单替换URL为本地文件、字符串、或其他URL

```swift
     Cat.replace("http://.....", withString:"I'm string replaced by Cat.")
     Cat.replace("http://.....", withFileName: "demo", ofType: "json") //the file in the project
     Cat.replace("http://.....", withURL: "http://.....")
```
