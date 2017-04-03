//
//  ViewController.swift
//  Checklists
//
//  Created by 袁晨曦 on 2017/3/16.
//  Copyright © 2017年 YYYYCX. All rights reserved.
//

import UIKit

//这个checklists view controller决定做additemview controller的protocol做的事
class ChecklistsViewController: UITableViewController,ItemDetailViewControllerDelegate {
    
    //var items:[ChecklistsItem]
    var checklist: Checklist!
    
//    required init?(coder aDecoder: NSCoder) {
//        items = [ChecklistsItem]()
//
//        super.init(coder: aDecoder)
//        //loadChecklistsItems()
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //title本来就在UIKit里面
        title = checklist.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }

    //每次有新的cell要找新的row时，就会调用此方法
    //在tableview中，indexPath可以理解为一个包含了两个信息的参数，row（第几行）和section（第几分区）
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistsItem", for: indexPath)
        let item = checklist.items[indexPath.row]

        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
    
    //当选中了某个row时
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        //saveChecklistsItems()
    }
    
    //删除某一行
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //在data model中删除这个item 
        checklist.items.remove(at: indexPath.row)
        //在table view里删除对应的row
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        //saveChecklistsItems()//添加在任何数据改动的地方
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //每一个view controller可能不止一个segue，所以要有identifier
        if segue.identifier == "AddItem" {
            // new view controller can be found in destination
            let navigationController = segue.destination as! UINavigationController
            // to find ItemDetailViewController,u should find the topviewcontroller
            let controller = navigationController.topViewController as! ItemDetailViewController
            //self means chekclistsviewcontroller, who is the delegate for the ItemDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            //函数的参数sender是reference
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    
    func configureCheckmark(for cell:UITableViewCell,with item:ChecklistsItem) {
        //现在√也是一个有tag 的label
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
        }
    }
    
    //将item里的文本放到label里
    func configureText(for cell:UITableViewCell,with item:ChecklistsItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    //在现有的row中新添加了一个row
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        //close the add item screen
        dismiss(animated: true, completion: nil)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistsItem) {
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        
        let indexPath = IndexPath(row:newRowIndex,section:0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        dismiss(animated: true, completion: nil) //close the add item screen
        //saveChecklistsItems()
    }
    
    //...
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistsItem) {
        if let index = checklist.items.index(of : item){
            let indexPath = IndexPath(row :index, section:0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        dismiss(animated: true, completion: nil)
        //saveChecklistsItems()
    }
    
    //在app关闭后文件的保存 sandbox
    //documents directory是存放应用数据的地方
//    func documentsDirectory() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return paths[0]
//    }
//    
//    func dataFilePath() -> URL {
//        return documentsDirectory().appendingPathComponent("Checklists.plist")
//    }
//    
//    //获取了items数组的内容并把它转换成二进制数据，写入了一个文件
//    func saveChecklistsItems() {
//        let data = NSMutableData()
//        let archiver = NSKeyedArchiver(forWritingWith: data)
//        archiver.encode(checklist.items, forKey: "ChecklistsItems")
//        archiver.finishEncoding()
//        data.write(to: dataFilePath(), atomically: true)
//    }
//    
//    func loadChecklistsItems() {
//        let path = dataFilePath()
//        if let data = try? Data(contentsOf: path) {
//            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
//            checklist.items = unarchiver.decodeObject(forKey: "ChecklistsItems") as! [ChecklistsItem]
//            unarchiver.finishDecoding()
//        }
//    }
}





















