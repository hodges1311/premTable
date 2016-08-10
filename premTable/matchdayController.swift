//
//  matchdayController.swift
//  premTable
//
//  Created by Hodges, Ethan on 8/10/16.
//  Copyright © 2016 HodgesApps. All rights reserved.
//

import UIKit


class matchController: UITableViewController
{

    @IBOutlet var matchdayTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMatchdays()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 38
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCellWithIdentifier("matchdayCell", forIndexPath: indexPath) 
        cell.textLabel!.text = "Matchday " + String(indexPath.row + 1)
        
      return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let matchView = self.storyboard!.instantiateViewControllerWithIdentifier("matches") as! MatchViewController
        matchView.matchdaySet = true
        matchView.currentMatchday = String(indexPath.row + 1)
        navigationController?.pushViewController(matchView, animated: true)
    }

    func loadMatchdays(){
        reloadTable()
    }

    func reloadTable() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.matchdayTable.reloadData()
        })
    }


}

