//
//  GTOulineTableviewController.swift
//  GTRead
//
//  Created by YangJie on 2021/4/21.
//

import UIKit
import PDFKit

protocol GTOulineTableviewControllerDelegate: class{
    func oulineTableviewController(_ oulineTableviewController: GTOulineTableviewController,
                                   didSelectOutline outline: PDFOutline)
}

class GTOulineTableviewController: UITableViewController {
    weak var delegate: GTOulineTableviewControllerDelegate?
    private var data = [PDFOutline]()
    var pdfOutlineRoot: PDFOutline? {
        didSet{
            for index in 0...(pdfOutlineRoot?.numberOfChildren)!-1 {
                let pdfOutline = pdfOutlineRoot?.child(at: index)
                pdfOutline?.isOpen = false
                data.append(pdfOutline!)
            }
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(GTOulineTableViewCell.self, forCellReuseIdentifier: "GTOulineTableViewCell")
        tableView.tableFooterView = UIView()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GTOulineTableViewCell", for: indexPath) as! GTOulineTableViewCell
        
        let outline = data[indexPath.row];
        
        cell.textLab.text = outline.label
        cell.pageLab.text = outline.destination?.page?.label
        
        if outline.numberOfChildren > 0 {
            cell.openBtn.setImage(outline.isOpen ? UIImage(named: "arrow_down") : UIImage(named: "arrow_right"), for: .normal)
            cell.openBtn.isEnabled = true
        } else {
            cell.openBtn.setImage(nil, for: .normal)
            cell.openBtn.isEnabled = false
        }
        
        cell.openBtnEvent = {[weak self] (sender)-> Void in
            if outline.numberOfChildren > 0 {
                if sender.isSelected {
                    outline.isOpen = true
                    self?.insertChirchen(parent: outline)
                } else {
                    outline.isOpen = false
                    self?.removeChildren(parent: outline)
                }
                tableView.reloadData()
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        let outline = data[indexPath.row];
        let depth = findDepth(outline: outline)
        return depth;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let outline = data[indexPath.row]
        delegate?.oulineTableviewController(self, didSelectOutline: outline)
        self.navigationController?.popViewController(animated: true)
    }
    
    func findDepth(outline: PDFOutline) -> Int {
        var depth: Int = -1
        var tmp = outline
        while (tmp.parent != nil) {
            depth = depth + 1
            tmp = tmp.parent!
        }
        return depth
    }
    
    func insertChirchen(parent: PDFOutline) {
        var tmpData: [PDFOutline] = []
        let baseIndex = self.data.firstIndex(of: parent)
        for index in 0..<parent.numberOfChildren {
            if let pdfOutline = parent.child(at: index) {
                pdfOutline.isOpen = false
                tmpData.append(pdfOutline)
            }
        }
        self.data.insert(contentsOf: tmpData, at:baseIndex! + 1)
    }
    
    func removeChildren(parent: PDFOutline) {
        if parent.numberOfChildren <= 0 {
            return
        }
        
        for index in 0..<parent.numberOfChildren {
            if let node = parent.child(at: index) {
                if node.numberOfChildren > 0 {
                    removeChildren(parent: node)
                    // remove self
                    if let i = data.firstIndex(of: node) {
                        data.remove(at: i)
                    }
                } else {
                    if self.data.contains(node) {
                        if let i = data.firstIndex(of: node) {
                            data.remove(at: i)
                        }
                    }
                }
            }
        }
    }
}
