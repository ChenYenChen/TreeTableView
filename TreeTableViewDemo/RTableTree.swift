//
//  RTableTree.swift
//  YSTreeTableView
//
//  Created by Ray on 2017/6/5.
//  Copyright © 2017年 ys. All rights reserved.
//

import UIKit
protocol RTableTreeDataSource {
    func tableTree(_ tableView: UITableView, index: [Int], value: Any?) -> UITableViewCell
    
    func tableTree(_ tableView: UITableView, didSelectRowAt indexPath: [Int], value: Any?)
}

class RTableTree: UITableView {
    
    var rootNods: [RNode] = [] {
        didSet {
            self.changeData()
            self.reloadData()
        }
    }
    var treeDataSource: RTableTreeDataSource?
    var levelIndentationWidth: CGFloat = 0
    fileprivate var tempNodeArray:[RNode] = []
    
    /// 初始化
    private func initialization() {
        self.delegate = self
        self.dataSource = self
    }
    
    private func changeData() {
        self.tempNodeArray.removeAll()
        for i in 0..<self.rootNods.count {
            if self.rootNods[i].parentIndex.count == 0 {
                self.addExpandNodeToArray(node: self.rootNods[i], index: i)
            }
        }
    }
    fileprivate func addExpandNodeToArray(node:RNode, index: Int) {
        node.myRow = index
        self.tempNodeArray.append(node)
    }
    
    /// 展開 增加節點
    fileprivate func insertChildNode(_ node:RNode) -> [IndexPath] {
        var insertIndexPath: [IndexPath] = []
        
        guard node.subNodes.count > 0, let myRow = node.myRow else {
            return insertIndexPath
        }
        
        guard var insertRow = self.tempNodeArray.index(of: node) else {
            return insertIndexPath
        }
        node.isExpand = true
        insertRow = insertRow + 1
        var parentRow = node.parentIndex
        parentRow.append(myRow)
        
        for i in 0..<node.subNodes.count {
            let childRow = insertRow
            let childIndexPath = IndexPath(row: childRow, section: 0)
            insertIndexPath.append(childIndexPath)
            node.subNodes[i].myRow = i
            node.subNodes[i].parentIndex = parentRow
            self.tempNodeArray.insert(node.subNodes[i], at: childRow)
            insertRow = insertRow + 1
        }
        
        return insertIndexPath
    }
    
    /// 收縮 刪除展開的節點
    fileprivate func deleteIndexPaths(node:RNode) -> [IndexPath] {
        var deleteIndexPath: [IndexPath] = []
        
        guard node.subNodes.count > 0 else {
            return deleteIndexPath
        }
        
        node.isExpand = false
        for childNode in node.subNodes {
            guard let deleteRow = self.tempNodeArray.index(of: childNode) else {
                return deleteIndexPath
            }
            let childIndexPath = IndexPath(row: deleteRow, section: 0)
            deleteIndexPath.append(childIndexPath)
            
            if childNode.isExpand {
                deleteIndexPath = deleteIndexPath + self.deleteIndexPaths(node: childNode)
            }
        }
        
        return deleteIndexPath
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.initialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialization()
    }
}
extension RTableTree: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tempNodeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nodes = self.tempNodeArray[indexPath.row]
        
        guard let row = nodes.myRow else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
            return cell
        }
        
        var RIndex: [Int] = [row]
        if nodes.parentIndex.count != 0 {
            RIndex = nodes.parentIndex + RIndex
        }
        
        guard let newCell = self.treeDataSource?.tableTree(tableView, index: RIndex, value: nodes.value) else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
            return cell
        }
        newCell.indentationLevel = RIndex.count - 1
        newCell.indentationWidth = self.levelIndentationWidth
        
        return newCell
    }
}

extension RTableTree: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nodes = self.tempNodeArray[indexPath.row]
        guard let row = nodes.myRow else {
            return
        }
        
        var RIndex: [Int] = [row]
        if nodes.parentIndex.count != 0 {
            RIndex = nodes.parentIndex + RIndex
        }
        
        guard nodes.subNodes.count > 0 else {
            self.treeDataSource?.tableTree(tableView, didSelectRowAt: RIndex, value: nodes.value)
            return
        }
        
        if nodes.isExpand {
            let array = self.deleteIndexPaths(node: nodes)
            for _ in array {
                self.tempNodeArray.remove(at: array.first!.row)
            }
            self.deleteRows(at: array, with: .top)
        } else {
            self.insertRows(at: self.insertChildNode(nodes), with: .top)
        }
    }
}
