//
//  ReceivePaymentViewController.swift
//  nearbyPOC
//
//  Created by Zack on 4/22/16.
//  Copyright © 2016 Zack. All rights reserved.
//

import UIKit

class ReceivePaymentViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var acceptButton: UIButton!
    
    @IBOutlet weak var declineButton: UIButton!
    
    var recIdString : String = " "
    var providerString : String = " "
    var amtString : String = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(printCheck())
        
        messageLabel.sizeToFit()
        
        let recId : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("chargingDevId")
        recIdString = recId as! String
        
        let provider : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("provider")
        providerString = provider as! String
        
        let amt : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("amt")
        amtString = amt as! String
        
        // Do any additional setup after loading the view.
        messageLabel.text = providerString + " would like to charge you " + amtString
        
        //button formatting
        acceptButton.backgroundColor = UIColor(red: 32.0/255.0, green: 157.0/255.0, blue: 139.0/255.0, alpha: 1.0)
        acceptButton.layer.cornerRadius = 5
        acceptButton.layer.borderWidth = 1
        
        declineButton.backgroundColor = UIColor(red: 32.0/255.0, green: 157.0/255.0, blue: 139.0/255.0, alpha: 1.0)
        declineButton.layer.cornerRadius = 5
        declineButton.layer.borderWidth = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func printCheck () {
        print(recIdString)
        print(providerString)
        print(amtString)
        print("THE STRINGS SHOULD BE PRINTED ABOVE")
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