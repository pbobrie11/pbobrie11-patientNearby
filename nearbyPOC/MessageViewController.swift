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
    
    var messages = [String]()
    
    //variable to handle name of device / provider
    
    var provDict = ["Leo's": "https://www.google.com", "James'": "https://www.yahoo.com", "Jeff's": "www.bing.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
        checkForId()
        
    var checkTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: Selector("determinePubStatus"), userInfo: nil, repeats: true)

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
    

    
    func addMessage(message: String!) {
        messages.append(message.copy() as! String)
        tableView.reloadData()
    }
    
    func removeMessage(message: String!) {
        if let index = messages.indexOf(message)
        {
            messages.removeAtIndex(index)
        }
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = messages[indexPath.row]
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
        let count = messages.count
        
        if count > 0 {
            startPublication()
        } else {
            stopPublication()
        }
        print("It ran")
    }
    
    // MARK: - UItableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let indexPath = indexPath.row
        let labelText = messages[indexPath]
        let url: String? = provDict[labelText]
        checkURL(url)
    }

    
}


    



