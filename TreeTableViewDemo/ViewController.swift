//
//  ViewController.swift
//  TreeTableViewDemo
//
//  Created by Ray on 2017/6/8.
//  Copyright © 2017年 Ray. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var treeTableView: RTableTree!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        let _111 = RNode(value: ["name" :"SuSheng"], subNodes: nil)
        let _112 = RNode(value: ["name" :"SuSu"], subNodes: nil)
        
        let _11 = RNode(value: ["name" :"Tim"], subNodes: [_111, _112])
        let _12 = RNode(value: ["name" :"HaHa"], subNodes: nil)
        
        let _1 = RNode(value: ["group" :"Oga"], subNodes: [_11, _12])
        
        let _21 = RNode(value: ["name" :"Henry"], subNodes: nil)
        let _22 = RNode(value: ["name" :"TaTa"], subNodes: nil)
        
        let _2 = RNode(value: ["group" :"Edo"], subNodes: [_21, _22])
        
        self.treeTableView.rootNods = [_1, _2]
        self.treeTableView.levelIndentationWidth = 30
        self.treeTableView.treeDataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: RTableTreeDataSource {
    func tableTree(_ tableView: UITableView, index: [Int], value: Any?) -> UITableViewCell {
        
        if index.count == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "firstCell")!
            if let getValue = value as? Dictionary<String, Any> {
                cell.textLabel?.text = getValue["group"] as? String
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "secondCell")!
            if let getValue = value as? Dictionary<String, Any> {
                cell.textLabel?.text = getValue["name"] as? String
            }
            return cell
        }
    }
    
    func tableTree(_ tableView: UITableView, didSelectRowAt indexPath: [Int], value: Any?) {
        //
    }
}

