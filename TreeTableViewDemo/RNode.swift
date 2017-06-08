//
//  RNode.swift
//  YSTreeTableView
//
//  Created by Ray on 2017/6/5.
//  Copyright © 2017年 ys. All rights reserved.
//

import Foundation

class RNode: NSObject {
    
    var parentIndex: [Int] = []
    var subNodes: [RNode] = []
    var myRow: Int?
    var isExpand:Bool = false
    var value: Any?
    
    private override init() {
        super.init()
    }
    
    convenience init(value: Any, subNodes nodes: [RNode]?) {
        self.init()
        self.value = value
        if let array = nodes {
            self.subNodes = array
        }
    }
}
