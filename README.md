# Cat
Cat

#### USE


```swift
1.Drag Cat.swift into your project
2.call Cat.start() 
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Cat.start() 
        
        return true
    }
3.

     Cat.replace("http://.....", withString:"I'm string replaced by Cat.")
     Cat.replace("http://.....", withFileName: "demo", ofType: "json") //the file in the project
     Cat.replace("http://.....", withURL: "http://.....")



```
