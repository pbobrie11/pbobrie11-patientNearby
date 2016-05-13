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
    
    @IBAction func cancelButton(sender: AnyObject) {
        self.performSegueWithIdentifier("unwind", sender: self)
        var delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.controlState = 0
    }
    
    
    var recIdString : String = " "
    var providerString : String = " "
    var amtString : String = " "
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.controlState = 1
        
        messageLabel.sizeToFit()
        
        let recId : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("chargingDevId")
        recIdString = recId as! String
        
        let provider : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("provider")
        providerString = provider as! String
        
        let amt : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("amt")
        print(amt)
        amtString = amt as! String
        var attributedString = NSMutableAttributedString(string: amtString)
        
        
        
        // Do any additional setup after loading the view.
        messageLabel.text = providerString + " would like to charge you $" + amtString
        
        //button formatting
        acceptButton.backgroundColor = UIColor(red: 32.0/255.0, green: 157.0/255.0, blue: 139.0/255.0, alpha: 1.0)
        acceptButton.layer.cornerRadius = 5
        acceptButton.layer.borderWidth = 1
        acceptButton.addTarget(self, action: "confirmPayment", forControlEvents: .TouchUpInside)
        acceptButton.addTarget(self, action: "backToTableView", forControlEvents: .TouchUpInside)
        
        declineButton.backgroundColor = UIColor(red: 32.0/255.0, green: 157.0/255.0, blue: 139.0/255.0, alpha: 1.0)
        declineButton.layer.cornerRadius = 5
        declineButton.layer.borderWidth = 1
        declineButton.addTarget(self, action: "declinePayment", forControlEvents: .TouchUpInside)
        declineButton.addTarget(self, action: "backToTableView", forControlEvents: .TouchUpInside)
        
        ABPadLockScreenView.appearance().backgroundColor = UIColor(hue:0.61, saturation:0.55, brightness:0.64, alpha:1)
        
        ABPadLockScreenView.appearance().labelColor = UIColor.whiteColor()
        
        let buttonLineColor = UIColor(red: 229/255, green: 180/255, blue: 46/255, alpha: 1)
        ABPadButton.appearance().backgroundColor = UIColor.clearColor()
        ABPadButton.appearance().borderColor = buttonLineColor
        ABPadButton.appearance().selectedColor = buttonLineColor
        ABPinSelectionView.appearance().selectedColor = buttonLineColor
        
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
            let lockScreen = ABPadLockScreenViewController(delegate: self, complexPin: false)
            lockScreen.setAllowedAttempts(3)
            lockScreen.modalPresentationStyle = UIModalPresentationStyle.FullScreen
            lockScreen.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            
            presentViewController(lockScreen, animated: true, completion: nil)
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
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func unlockWasUnsuccessful(falsePin: String!, afterAttemptNumber attemptNumber: Int, padLockScreenViewController: ABPadLockScreenViewController!) {
        print("Failed Attempt \(attemptNumber) with incorrect pin \(falsePin)")
    }
    
    func unlockWasCancelledForPadLockScreenViewController(padLockScreenViewController: ABPadLockScreenViewController!) {
        print("Unlock Cancled")
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
