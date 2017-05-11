//
//  TagsDataSource.swift
//  Photorama
//
//  Created by Edouard Barbier on 10/05/17.
//  Copyright © 2017 Edouard Barbier. All rights reserved.
//

import UIKit
import CoreData

class TagsDataSource: NSObject, UITableViewDataSource {
    
    var tags: [NSManagedObject] = []
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell",
                                                 for: indexPath)
        
        let tag = tags[indexPath.row]
        let name = tag.value(forKey: "name") as! String
        
        cell.accessibilityHint = "Double-tap to toggle selected"
        
        cell.textLabel?.text = name
        
        return cell
    }
    
}
