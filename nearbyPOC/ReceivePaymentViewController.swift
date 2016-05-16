//
//  ReceivePaymentViewController.swift
//  nearbyPOC
//
//  Created by Zack on 4/22/16.
//  Copyright © 2016 Zack. All rights reserved.
//

import UIKit
import ABPadLockScreen

class ReceivePaymentViewController: UIViewController, ABPadLockScreenSetupViewControllerDelegate, ABPadLockScreenViewControllerDelegate {
    
    private(set) var thePin: String = "2580"

    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var acceptButton: UIButton!
    
    @IBOutlet weak var declineButton: UIButton!
    
    @IBOutlet weak var actionLabel: UILabel!
    
    @IBAction func cancelButton(sender: AnyObject) {
        self.performSegueWithIdentifier("unwind", sender: self)
        var delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.controlState = 0
    }
    
    
    var recIdString : String = " "
    var providerString : String = " "
    var amtString : String = " "
    
    var needPin : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: openSans!], forState: .Normal)
        navigationItem.leftBarButtonItem?.tintColor = uglyBlue
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.controlState = 1
        
        messageLabel.sizeToFit()
        messageLabel.textColor = uglyBlue
        
        let recId : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("chargingDevId")
        recIdString = recId as! String
        
        let provider : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("provider")
        providerString = provider as! String
        
        let amt : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("amt")
        print(amt)
        amtString = amt as! String
        var attributedString = NSMutableAttributedString(string: amtString)
        
        actionLabel.textColor = uglyBlue
        
        // Do any additional setup after loading the view.
        messageLabel.text = providerString + " would like to charge you $" + amtString
        
        //button formatting
        acceptButton.backgroundColor = sea
        acceptButton.layer.cornerRadius = 5
        acceptButton.layer.borderWidth = 1
        acceptButton.addTarget(self, action: "pinConfirm", forControlEvents: .TouchUpInside)
    //    acceptButton.addTarget(self, action: "backToTableView", forControlEvents: .TouchUpInside)
        
        declineButton.backgroundColor = sea
        declineButton.layer.cornerRadius = 5
        declineButton.layer.borderWidth = 1
        declineButton.addTarget(self, action: "declinePayment", forControlEvents: .TouchUpInside)
        declineButton.addTarget(self, action: "backToTableView", forControlEvents: .TouchUpInside)
        
        ABPadLockScreenView.appearance().backgroundColor = UIColor.whiteColor()
        
        ABPadLockScreenView.appearance().labelColor = uglyBlue
        
        let buttonLineColor = sea
        ABPadButton.appearance().backgroundColor = UIColor.clearColor()
        ABPadButton.appearance().borderColor = buttonLineColor
        ABPadButton.appearance().selectedColor = buttonLineColor
        ABPinSelectionView.appearance().selectedColor = buttonLineColor
        ABPadButton.appearance().textColor = uglyBlue
        
        let logo = UIImage(named: "logo")
        let logoImage = UIImageView(image: logo)
        self.navigationItem.titleView = logoImage
        
        checkAmt()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backToTableView(){
        self.performSegueWithIdentifier("unwind", sender: self)
    }
    
    func checkAmt() {
        var amt : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("amt")
        var amtString: String = " "
        
        if amt == nil {
            
        } else {
            amtString = (amt as? String)!
        }

        var amount = Double(amtString)
        
        
        if amount >= 500 {
            needPin = true
        }
    }
    
    func confirmPayment(){
        
        let state = "3"
        
        let nameCheck: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("name")
        var nameString: String = nameCheck as! String
        
        let devId = UIDevice.currentDevice().identifierForVendor!.UUIDString
        
        let recId = recIdString
        let amt = " "
        
        let message = Message(state: state, name: nameString, devId: devId, recId: recId, amt: amt)
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.checkValidity(message)
        
        backToTableView()
    }
    
    func pinConfirm(){
        if needPin == true {
            let lockScreen = ABPadLockScreenViewController(delegate: self, complexPin: false)
            lockScreen.setAllowedAttempts(3)
            lockScreen.modalPresentationStyle = UIModalPresentationStyle.FullScreen
            lockScreen.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            
            presentViewController(lockScreen, animated: true, completion: nil)
        } else {
            confirmPayment()
        }
    
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
        delegate.checkValidity(message)

    }
    
    func unlockWasCancelledForSetupViewController(padLockScreenViewController: ABPadLockScreenAbstractViewController!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    //MARK: Lock Screen Delegate
    func padLockScreenViewController(padLockScreenViewController: ABPadLockScreenViewController!, validatePin pin: String!) -> Bool {
        print("Validating Pin \(pin)")
        return thePin == pin
    }
    
    func unlockWasSuccessfulForPadLockScreenViewController(padLockScreenViewController: ABPadLockScreenViewController!) {
        print("Unlock Successful!")
        confirmPayment()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func unlockWasUnsuccessful(falsePin: String!, afterAttemptNumber attemptNumber: Int, padLockScreenViewController: ABPadLockScreenViewController!) {
        print("Failed Attempt \(attemptNumber) with incorrect pin \(falsePin)")
    }
    
    func unlockWasCancelledForPadLockScreenViewController(padLockScreenViewController: ABPadLockScreenViewController!) {
        print("Unlock Cancelled")
        dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
