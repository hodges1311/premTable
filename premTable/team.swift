//
//  team.swift
//  premTable
//
//  Created by Development on 8/6/16.
//  Copyright © 2016 HodgesApps. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class team{
    var rank : String?
    var name : String?
    var points : String?
    
    init(rank : String, name : String, points : String){
        self.rank = rank
        self.name = name
        self.points = points
    }
    
    
    
}