//
//  Message.swift
//  nearbyPOC
//
//  Created by Zack on 4/26/16.
//  Copyright © 2016 Zack. All rights reserved.
//

import Foundation
import UIKit

class Message {
    
    //properties
    
    var state : String!
    var name : String!
    var devId : String!
    var recId: String?
    var amt: String?
    
    //initialize
    
    init(state: String, name: String, devId: String, recId: String, amt: String) {
        self.state = state
        self.name = name
        self.devId = devId
        self.recId = recId
        self.amt = amt
    }
    
    func formMessageString() -> String{
        
        if recId == nil {
            recId = " "
        }
        if amt == nil {
            amt = " "
        }
        
        var firstMessage = state + "," + name + ","
        var secondMessage = devId + "," + recId! + "," + amt!
        var fullMessage = firstMessage + secondMessage
        return fullMessage
    }
    
    func stringToObject(message: String) -> AnyObject {
        let messageArray = message.componentsSeparatedByString(",")
        
        var state = messageArray[0]
        var name = messageArray[1]
        var devId = messageArray[2]
        var recId = messageArray[3]
        var amt = messageArray[4]
        
        var message = Message(state: state, name: name, devId: devId, recId: recId, amt: amt)
        return message
        
    }

    
    
}
