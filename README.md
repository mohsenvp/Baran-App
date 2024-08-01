# HeyWeather
## _Accurate local forecast_

The HeyWeather App, a modern, simple, elegant, and accurate weather application with comprehensive features, is now also available on Apple Watch!
This file contains developer guide in the following topics:

- Localization
- Naming Conventions

## Localization

We use the latest available method for localization:

Your strings are either a `Text("", tableName: "")` or in some (preferably small cases) a `String(localized: "", table: "")`:
```
Text("Awesome Weather!", tableName: "WeatherTab")
String(localized: "Awesome Weather!", table: "WeatherTab")
```
Tehre are a few things that you have to keep in mind, the following cases fail to compile for localization and XCode can not extract the strings correctly if written like this:

```
conditionals should generate seperate views
🔴 Text(isTrue ? "A" : "B", tableName: "") 

none of the key or table name can be variables and should be provided as StringLiterals
🔴 Text(MyStringVariable, tableName: TableName.WeatherTab) 
```

## Naming Conventions

- Group, class and struct names are PascalCased
- function and method names are camelCased
