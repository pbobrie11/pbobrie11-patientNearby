//
//  navController.swift
//  nearbyPOC
//
//  Created by Zack on 5/11/16.
//  Copyright © 2016 Zack. All rights reserved.
//

import UIKit

class navController: UINavigationController {

    override func viewDidLoad() {
        
        let uglyBlue = UIColor(colorLiteralRed: 43/255, green: 107/255, blue: 125/255, alpha: 1)
        
        let openSans = UIFont(name: "OpenSans-Semibold", size: 18)
        
        super.viewDidLoad()

        self.navigationBar.barTintColor = UIColor.whiteColor()
        
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : uglyBlue, NSFontAttributeName : openSans!]
        
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: openSans!], forState: .Normal)
        navigationItem.leftBarButtonItem?.tintColor = uglyBlue
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
