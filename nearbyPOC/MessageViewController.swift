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

var recIdString : String = " "
var messageClass : Message!

let myDevId = UIDevice.currentDevice().identifierForVendor!.UUIDString

//create UI Color used in CC App
let uglyBlue = UIColor(colorLiteralRed: 43/255, green: 107/255, blue: 125/255, alpha: 1)

let sea = UIColor(colorLiteralRed: 55/255, green: 139/255, blue: 127/255, alpha: 1)

let lightBlueGrey = UIColor(colorLiteralRed: 213/255, green: 232/255, blue: 236/255, alpha: 1)

let openSans = UIFont(name: "OpenSans-Semibold", size: 16)

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
            navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: openSans!], forState: .Normal)
            navigationItem.leftBarButtonItem?.tintColor = uglyBlue
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
            navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: openSans!], forState: .Normal)
            navigationItem.rightBarButtonItem?.tintColor = uglyBlue
        }
    }
    
    var namesArr = [String]()
    var recArr = [String]()
    
    var messArray = [Message]()
    
    let myDevId = UIDevice.currentDevice().identifierForVendor!.UUIDString
    
    //variable to handle name of device / provider
    
    var provDict = ["Leo's": "https://www.google.com", "James'": "https://www.yahoo.com", "Jeff's": "www.bing.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
        checkForId()
        
   // var checkTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: Selector("determinePubStatus"), userInfo: nil, repeats: true)
        let logo = UIImage(named: "logo")
        let logoImage = UIImageView(image: logo)
        self.navigationItem.titleView = logoImage
        
        var delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.resetBools()
                }


    
    //creating "alert" with input for Device Name / ID
    
    var titleMessage = "No Device ID found"
    var displayMessage = "Please Enter Your Device Name or ID"
    
    let payMessageTitle = "Please Accept or Decline Charge"
    let payMessageBody = " would like to charge you $"
    
    
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

    
    func checkDevId(state: String, name: String, devId: String){
        if recArr.contains(devId) {
            print("repeat device")
            print(recArr)
        } else {
            namesArr.append(name.copy() as! String)
            recArr.append(devId)
        }
            tableView.reloadData()
    }
    
    func checkRecId(recId: String, provider: String, amt: String, devId: String, state: String) {
       // let alertController = UIAlertController(title: "Payment", message: provider + " would like to receive payment", preferredStyle: .Alert)
        
        let myDevId = UIDevice.currentDevice().identifierForVendor!.UUIDString
        
        if recId == myDevId {
            
            recIdString = recId
        //    present View for accepting / cancelling charge request
            
            
            let mainstoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let recVC : UIViewController = mainstoryboard.instantiateViewControllerWithIdentifier("receiveCharge")
            let navController : UINavigationController
            let navRoot = UINavigationController(rootViewController: recVC)
            presentNewView(navRoot)
            
            //set defaults for message values
            NSUserDefaults.standardUserDefaults().setObject(devId, forKey: "chargingDevId")
            NSUserDefaults.standardUserDefaults().setObject(provider, forKey: "provider")
            NSUserDefaults.standardUserDefaults().setObject(amt, forKey: "amt")
 
            
            //show alert with values
           // paymentDecisionAlert(provider, amt: amt, recId: devId, devId: myDevId)
            
        } else if state == "1"{
            let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
            delegate?.initialPublish()
        }
    }
    
    func presentNewView(vc: UIViewController){
        presentViewController(vc, animated: true, completion: nil)
    }
    
    
    func addMessage(message: String) {
        
        var messageToFill = Message(state: " ", name: " ", devId: " ", recId: " ", amt: " ")
        
        let fullMessage = messageToFill.stringToObject(message)
        
        let state = fullMessage.state
        let name = fullMessage.name
        let devId = fullMessage.devId
        let recId = fullMessage.recId
        let amt = fullMessage.amt
        
        determinePubStatus(fullMessage.state)

        
        //function to handle whether the device Id has been sent before, if so then overwrite the indexpath for those arrays
        
        //Add Message
        
        namesArr.append(name.copy() as! String)
        recArr.append(devId)
        
        tableView.reloadData()
        
        messArray.append(fullMessage)
        
        checkRecId(recId!, provider: name, amt: amt!, devId: devId, state: state)
        
    }
    
    func removeMessage(message: String!) {
        var messArr = message.componentsSeparatedByString(",")
        var nameToRemove = messArr[1]
        
        if let index = namesArr.indexOf(nameToRemove)
        {
            namesArr.removeAtIndex(index)
            recArr.removeAtIndex(index)
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
        
        let bounds = UIScreen.mainScreen().bounds
        let width = bounds.size.width
        let arrowPos = width - 15
        
        var customColorView : UIView
        
        print(arrowPos)
        
        var frame = CGRect(x: 285,y: 4,width: 40,height: 40)
        var imageView = UIImageView(frame: frame)
        imageView.image = UIImage(named: "cellArrow")
        
        cell.textLabel?.textColor = uglyBlue
        
        if messArray.isEmpty {
            cell.willRemoveSubview(imageView)
        } else {
            cell.addSubview(imageView)
        }

    
        return cell
    }
    
    
    
    func startPublication(){
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.initialPublish()
        
    }
    
    func stopPublication(){
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.stopPublish()
    }
    
    func determinePubStatus(state: String){
        let count = namesArr.count
        
        if state == "1" {
            startPublication()
        } else if count == 0{
            stopPublication()
        }
        
    }
    
    func paymentDecisionAlert(provider: String, amt: String, recId: String, devId: String) {
        let bodyMessage = provider + payMessageBody + amt
        
        let alertController = UIAlertController(title: payMessageTitle, message: bodyMessage, preferredStyle: .Alert)
    
        let accept = UIAlertAction(title: "Accept", style: .Default, handler: { (action) -> Void in
            self.confirmPayment()
        })
        let decline = UIAlertAction(title: "Decline", style: .Cancel, handler: { (action) -> Void in
            self.declinePayment()
        })
        alertController.addAction(accept)
        alertController.addAction(decline)
        
        presentViewController(alertController, animated: true, completion: nil)
    }

    @IBAction func unwindToHere(segue: UIStoryboardSegue){
        
    }
    
    func confirmPayment(){
        let state = "3"
        
        let nameCheck: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("name")
        var nameString: String = nameCheck as! String
        
        let devId = UIDevice.currentDevice().identifierForVendor!.UUIDString
        
        let recId = recIdString
        let amt = " "
        
        let message = Message(state: state, name: nameString, devId: devId, recId: recIdString, amt: amt)
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.startPublish(message)
        
    }
    
    func declinePayment(){
        let state = "4"
        
        let nameCheck: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("name")
        var nameString: String = nameCheck as! String
        
        let devId = UIDevice.currentDevice().identifierForVendor!.UUIDString
        
        let recId = recIdString
        let amt = " "
        
        let message = Message(state: state, name: nameString, devId: devId, recId: recIdString, amt: amt)
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.startPublish(message)
        
    }

    
    
    
    // MARK: - UItableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let indexPath = indexPath.row
        let labelText = namesArr[indexPath]
        let url: String? = provDict[labelText]
        
        print(messArray[indexPath].state)
        print(messArray[indexPath].name)
        print(messArray[indexPath].devId)
        print(messArray[indexPath].recId)
        print(messArray[indexPath].amt)

    }

    
}


    



