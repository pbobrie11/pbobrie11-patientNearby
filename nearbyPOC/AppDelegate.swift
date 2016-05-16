//
//  AppDelegate.swift
//  nearbyPOC
//
//  Created by Zack on 3/30/16.
//  Copyright © 2016 Zack. All rights reserved.
//

import UIKit

var myAPIKey = "AIzaSyDrpWmPjqzVOHZGpX3PC8gB94JTpSqwVCQ"
var devId = UIDevice.currentDevice().identifierForVendor!.UUIDString
let empty = " "


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    var controlState : Int = 0
    var sendInitial : Bool = false
    
    //create UI Color used in CC App
    let uglyBlue = UIColor(colorLiteralRed: 43/255, green: 107/255, blue: 125/255, alpha: 1)
    
    let sea = UIColor(colorLiteralRed: 55/255, green: 139/255, blue: 127/255, alpha: 1)
    
    //the unattainable font
    let openSans = UIFont(name: "OpenSans-Semibold", size: 18)
    
    /**
    * @property
    * This class lets you check the permission state of Nearby for the app on the current device.  If
    * the user has not opted into Nearby, publications and subscriptions will not function.
    */
    var nearbyPermission: GNSPermission!
    
    /**
    * @property
    * The message manager lets you create publications and subscriptions.  They are valid only as long
    * as the manager exists.
    */
    var messageMgr: GNSMessageManager?
    var publication: GNSPublication?
    var subscription: GNSSubscription?
    var navController: UINavigationController!
    var messageViewController: MessageViewController!
    var receivePaymentViewController: ReceivePaymentViewController!
    
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        messageViewController = MessageViewController()
        navController = UINavigationController(rootViewController: messageViewController)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("checkControlState"), userInfo: nil, repeats: true)
        
        //look of nav controller
        navController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : uglyBlue, NSFontAttributeName : openSans!]
        navController.navigationBar.barTintColor = UIColor.whiteColor()
        
        //setup receive charge view
        receivePaymentViewController = ReceivePaymentViewController()
        
        // Set up the message view navigation buttons.
        nearbyPermission = GNSPermission(changedHandler: {[unowned self] granted in
            self.messageViewController.leftBarButton =
                UIBarButtonItem(title: String(format: "%@ Nearby", granted ? "Deny" : "Allow"),
                    style: UIBarButtonItemStyle.Bordered, target: self, action: "toggleNearbyPermission")
            })
        setupStartStopButton()
        
        // Enable debug logging to help track down problems.
        GNSMessageManager.setDebugLoggingEnabled(true)
        
        // Create the message manager, which lets you publish messages and subscribe to messages
        // published by nearby devices.
        messageMgr = GNSMessageManager(APIKey: myAPIKey,
            paramsBlock: {(params: GNSMessageManagerParams!) -> Void in
                // This is called when microphone permission is enabled or disabled by the user.
                params.microphonePermissionErrorHandler = { hasError in
                    if (hasError) {
                        print("Nearby works better if microphone use is allowed")
                    }
                }
                // This is called when Bluetooth permission is enabled or disabled by the user.
                params.bluetoothPermissionErrorHandler = { hasError in
                    if (hasError) {
                        print("Nearby works better if Bluetooth use is allowed")
                    }
                }
                // This is called when Bluetooth is powered on or off by the user.
                params.bluetoothPowerErrorHandler = { hasError in
                    if (hasError) {
                        print("Nearby works better if Bluetooth is turned on")
                    }
                }
        })
        
        return true
    }
    
    /// Sets up the right bar button to start or stop sharing, depending on current sharing mode.
    func setupStartStopButton() {
        let isListening = (subscription != nil)
        messageViewController.rightBarButton = UIBarButtonItem(title: isListening ? "Stop" : "Start",
            style: UIBarButtonItemStyle.Bordered,
            target: self, action: isListening ? "stopSharing" :  "startSharing")
    }
    
    /// Starts sharing with a randomized name.
    func startSharing() {
        let nameCheck: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("name")
        let nameString: String = nameCheck as! String
        
        var devName = UIDevice.currentDevice().identifierForVendor!.UUIDString
        
        startSharingWithName(nameString, dev: devName)
        setupStartStopButton()
    }
    
    func refreshPub() {
        publication = nil
    }
    
    func resetBools(){
        //set values for Bools for determining messages
        controlState = 0
        print("NEW LOAD")
    }
    
    func checkValidity (message: Message) {
        if message.state == "1" && controlState == 0 {
            refreshPub()
            startPublish(message)
        } else if message.state == "3" || message.state == "4" && controlState == 1 {
            refreshPub()
            startPublish(message)
        }
    }
    
    
    func initialPublish(){
        // get Name, dev ID and rec ID and pass as message to other device
        var nameCheck: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("name")
        let name: String = nameCheck as! String
        
        let state = "1"
        let recID = " "
        let amt = " "
        
        let sendMessage = Message(state: state, name: name, devId: devId, recId: empty, amt: empty)
        // Show the name in the message view title and set up the Stop button.
        messageViewController.title = name
        
        checkValidity(sendMessage)
    }
    
    func checkControlState() {
        
        print("The Control State is:")
        print(controlState)
        if controlState == 2 {
            refreshPub()
            initialPublish()
            controlState = 0
        }
    }
    
    func startPublish(message: Message) {
        
        let message = message.formMessageString()
        
        publication = nil
        
        if let messageMgr = self.messageMgr {
            
            // Publish the name to nearby devices.
            let pubMessage: GNSMessage = GNSMessage(content: message.dataUsingEncoding(NSUTF8StringEncoding,
                allowLossyConversion: true))
            publication = messageMgr.publicationWithMessage(pubMessage)
        }
    }
    
    func stopPublish () {
        publication = nil
    }
    
    /// Stops publishing/subscribing.
    func stopSharing() {
        //uncomment if this doesn't work.
        publication = nil
        subscription = nil
        messageViewController.title = ""
        setupStartStopButton()
    }
    
    func paymentResponse(state: String, name: String, devId: String, recId: String, amt: String) {
        
        let allowCheck: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("payResponseBool")
        var allow: String  = allowCheck as! String
        
        print(allow)
        
        if allow == "true" {
        
        let message = state + "," + name + "," + devId + "," + recId + "," + amt
        
        if let messageMgr = self.messageMgr {
            // Show the name in the message view title and set up the Stop button.
            messageViewController.title = name
            
            // Publish the name to nearby devices.
            let pubMessage: GNSMessage = GNSMessage(content: message.dataUsingEncoding(NSUTF8StringEncoding,
                allowLossyConversion: true))
            publication = messageMgr.publicationWithMessage(pubMessage)
        }
        } else {
            //do nothing send, nothing
            print("sendNewMessage == false")
        }
    }
    
    /// Toggles the permission state of Nearby.
    func toggleNearbyPermission() {
        GNSPermission.setGranted(!GNSPermission.isGranted())
    }
    
    /// Starts publishing the specified name and scanning for nearby devices that are publishing
    /// their names.
    func startSharingWithName(name: String, dev: String) {
        if let messageMgr = self.messageMgr {
            // Show the name in the message view title and set up the Stop button.
            messageViewController.title = name
            
            // Publish the name to nearby devices.
          /*  let pubMessage: GNSMessage = GNSMessage(content: dev.dataUsingEncoding(NSUTF8StringEncoding,
                allowLossyConversion: true))
            publication = messageMgr.publicationWithMessage(pubMessage)
 */
            
            // Subscribe to messages from nearby devices and display them in the message view.
            subscription = messageMgr.subscriptionWithMessageFoundHandler({[unowned self] (message: GNSMessage!) -> Void in
                self.messageViewController.addMessage(String(data: message.content, encoding:NSUTF8StringEncoding)!)
                }, messageLostHandler: {[unowned self](message: GNSMessage!) -> Void in
                    self.messageViewController.removeMessage(String(data: message.content, encoding: NSUTF8StringEncoding))
 
                })
        }
    }
}

