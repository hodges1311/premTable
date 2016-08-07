//
//  File.swift
//  premTable
//
//  Created by Development on 8/7/16.
//  Copyright © 2016 HodgesApps. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class match{
    var home : String
    var away : String
    var homeGoals : String?
    var awayGoals : String?
    var status : String
    var time : String
    
    init(home : String, away : String, homeGoals : String?, awayGoals : String?, status: String, time : String){
        self.home = home
        self.away = away
        self.homeGoals = homeGoals
        self.awayGoals = awayGoals
        self.status = status
        self.time = time
    }
    
    
}