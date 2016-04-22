//
//  ViewController.swift
//  nearbyPOC
//
//  Created by Zack on 3/30/16.
//  Copyright © 2016 Zack. All rights reserved.
//

import UIKit
import Foundation

let cellIdentifier = "messageCell"


class MessageViewController: UITableViewController {
    /**
    * @property
    * The left button to use in the nav bar.
    */
    var leftBarButton: UIBarButtonItem! {
        get {
            return navigationItem.leftBarButtonItem
        }
        set(leftBarButton) {
            navigationItem.leftBarButtonItem = leftBarButton
        }
    }
    
    /**
    * @property
    * The right button to use in the nav bar.
    */
    var rightBarButton: UIBarButtonItem! {
        get {
            return navigationItem.rightBarButtonItem
        }
        set(rightBarButton) {
            navigationItem.rightBarButtonItem = rightBarButton
        }
    }
    
    var namesArr = [String]()
    var devArr = [String]()
    var stateArr = [String]()
    
    let myDevId = UIDevice.currentDevice().identifierForVendor!.UUIDString
    
    //variable to handle name of device / provider
    
    var provDict = ["Leo's": "https://www.google.com", "James'": "https://www.yahoo.com", "Jeff's": "www.bing.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
        checkForId()
        
    var checkTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: Selector("determinePubStatus"), userInfo: nil, repeats: true)
        print(namesArr)

                }


    
    //creating "alert" with input for Device Name / ID
    
    var titleMessage = "No Device ID found"
    var displayMessage = "Please Enter Your Device Name or ID"
    
    
    
    func checkForId(){
        var idCheck: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("name")
        
        if idCheck == nil {
            showAlert()
        } else {
            var idString: String = (idCheck as? String)!
        }
        
    
    }
    
    func showAlert() {
        var idTextField : UITextField?
        let alertController = UIAlertController(title: titleMessage, message: displayMessage, preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler {(textField) in
            idTextField = textField
            textField.placeholder = "     Name"
            textField.keyboardType = .EmailAddress
            }
        let sub = UIAlertAction(title: "Submit", style: .Cancel, handler: { (action) -> Void in
            var id: NSString = (idTextField?.text)!
            NSUserDefaults.standardUserDefaults().setObject(id, forKey: "name")
        })
        alertController.addAction(sub)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showLinkAlert() {
        let alertController = UIAlertController(title: "Error", message: "Please Select Another Provider", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "Ok", style: .Cancel, handler: { (action) -> Void in
        })
        alertController.addAction(ok)
        presentViewController(alertController, animated: true, completion: nil)
    }
    

    
    func checkDevId(state: String, name: String, devId: String){
        if devArr.contains(devId) {
            print("repeat device")
            print(devArr)
        } else {
            namesArr.append(name.copy() as! String)
            devArr.append(devId)
            stateArr.append(state)
        }
            tableView.reloadData()
    }
    
    func checkRecId(recId: String, provider: String, amt: String, devId: String) {
       // let alertController = UIAlertController(title: "Payment", message: provider + " would like to receive payment", preferredStyle: .Alert)
        
        let myDevId = UIDevice.currentDevice().identifierForVendor!.UUIDString
        
        if recId == myDevId {
        //    present View for accepting / cancelling charge request
            let mainstoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let recVC : UIViewController = mainstoryboard.instantiateViewControllerWithIdentifier("receiveCharge")
            let navController : UINavigationController
            let navRoot = UINavigationController(rootViewController: recVC)
            presentViewController(navRoot, animated: true, completion: nil)
            
            //set defaults for message values
            NSUserDefaults.standardUserDefaults().setObject(devId, forKey: "chargingDevId")
            NSUserDefaults.standardUserDefaults().setObject(provider, forKey: "provider")
            NSUserDefaults.standardUserDefaults().setObject(amt, forKey: "amt")
        } else{
            //nothing?
        }
    }
    
    
    func addMessage(message: String!) {
        let messageArray = message.componentsSeparatedByString(",")
        
        print(namesArr)
        
        //pull all components of message from messageArray
        var state = messageArray[0]
        var name = messageArray[1]
        var devId = messageArray[2]
        var recId = messageArray[3]
        var amt = messageArray[4]
        
        
        //function to handle whether the device Id has been sent before, if so then overwrite the indexpath for those arrays
        
        checkDevId(state, name: name, devId: devId)
        
        checkRecId(recId, provider: name, amt: amt, devId: devId)
        
    }
    
    func removeMessage(message: String!) {
        var messArr = message.componentsSeparatedByString(",")
        var nameToRemove = messArr[1]
        
        if let index = namesArr.indexOf(nameToRemove)
        {
            stateArr.removeAtIndex(index)
            namesArr.removeAtIndex(index)
            devArr.removeAtIndex(index)
        }
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namesArr.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = namesArr[indexPath.row]
        return cell
    }
    
    func checkURL(url: String?){
        if url != nil {
            openURL(url!)
        } else {
            showLinkAlert()
        }
    }
    
    func openURL(url: String){
        if let openURL = NSURL(string: url) {
        UIApplication.sharedApplication().openURL(openURL)
        print(url)
        }
    }
    
    func startPublication(){
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.startPublish()
        
    }
    
    func stopPublication(){
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.stopPublish()
    }
    
    func determinePubStatus(){
        let count = namesArr.count
        
        if count > 0 {
            startPublication()
        } else {
            stopPublication()
        }
        print("Ran")
    }
    
    // MARK: - UItableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let indexPath = indexPath.row
        let labelText = namesArr[indexPath]
        let url: String? = provDict[labelText]
        checkURL(url)
    }

    
}


    



