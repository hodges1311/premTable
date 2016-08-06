//
//  ViewController.swift
//  premTable
//
//  Created by Development on 8/5/16.
//  Copyright © 2016 HodgesApps. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTable()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadTable() {
        
        Alamofire.request(.GET, "https://api.football-data.org/v1/soccerseasons/426/leagueTable")
            .responseJSON { response in
         //       print(response)
                
        }
    }
}

