zapt-location-sdk-ios-demo
===========

This project implements zapt-location-sdk for iOS and uses zapt-maps-sdk integrated with location in a webview.

## Project Setup
    1. pod install
    2. open the file WebViewDemo.xcworkspace in the XCode
    3. run this project in a real device
    4. simulate an iBeacon with the following parameters: 
        Protocol: iBeacon
        UUID: 0428c59e-25b7-4e9d-b3cd-d126a46e6e9d
        Major: 17001
        Minor: 1

    The app will recognize it and display a bluedot
