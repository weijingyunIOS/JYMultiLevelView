//
//  MultiLevelViewController.swift
//  MultiLevel
//
//  Created by weijingyun on 16/11/26.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

import UIKit
import ReactiveSwift

class MultiLevelViewController: UITableViewController {
    
    let viewModel = MultiLevelViewModel()
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = viewModel;
        tableView.dataSource = viewModel;
        // Do any additional setup after loading the view, typically from a nib.
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        let fetchSignal = viewModel.fetchMultiLevelList(jsonName: "testJson")
        fetchSignal.observe(Signal.Observer { event in
            switch event {
            case let .failed(error):
              print(error.localizedDescription)
            case .completed:
              self.tableView.reloadData()
                print("reloadData")
            case .interrupted:
               print("interrupted")
            default:
            break
        }})
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
        // #file,#line,#column和#function
    deinit {
        print((#file as NSString).lastPathComponent, #function)
    }
}




