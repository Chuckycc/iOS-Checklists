//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by 袁晨曦 on 2017/3/17.
//  Copyright © 2017年 YYYYCX. All rights reserved.
//

//一个view controller 对应一个view,有可能会有navigation，这是view的container，会切换为不同的view
import Foundation
import UIKit

//protocol是 a name for a group of methods
//并不实现声明的任何方法
protocol ItemDetailViewControllerDelegate:class {
    //当用户点击cancel时,delegate方法的第一个参数指向owner是惯例，一个object可能是两个以上tableview的delegate，to distinguish
    func itemDetailViewControllerDidCancel(_ controller:ItemDetailViewController)
    //当用户点击done时，将会传递ChecklistsItem
    func itemDetailViewController(_ controller:ItemDetailViewController,didFinishAdding item:ChecklistsItem)
    func itemDetailViewController(_ controller:ItemDetailViewController,didFinishEditing item:ChecklistsItem)
}

//view controller可以成为delegates for more than one object
class ItemDetailViewController:UITableViewController,UITextFieldDelegate {
    //当编辑现有的item时，不是nil，当新建一个 item时，是nil，所以？
    var itemToEdit: ChecklistsItem?
   
    //是在view中得到的
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    weak var delegate:ItemDetailViewControllerDelegate? //delegate一般都是weak relationship and optional(?)
    
    @IBAction func cancel() {
        delegate?.itemDetailViewControllerDidCancel(self)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done() {
        if let item = itemToEdit {
            item.text = textField.text!
            delegate?.itemDetailViewController(self, didFinishEditing: item)
        } else {
        let item = ChecklistsItem()
        item.text = textField.text!
        item.checked = false
        delegate?.itemDetailViewController(self, didFinishAdding: item)
        }    }
    
    //当viewcontroller从storyboard加载但是还没有shown on screen
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
            title = "Edit Item" //title是navigation的属性
            textField.text = item.text
            doneBarButton.isEnabled = true
        }
    }
    
    //转到这个页面后，不需要点击textfield就会出现键盘
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    //willselectrowat
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil // return nil是指阻止这个row被选中
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString//原先输入的
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString //有任何改动的
        
        //只有输入了字符donebar才生效
        doneBarButton.isEnabled = (newText.length > 0)
        return true
    }
}
