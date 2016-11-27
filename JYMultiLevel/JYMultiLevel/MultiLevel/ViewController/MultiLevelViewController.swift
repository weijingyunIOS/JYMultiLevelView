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
    
    // MARK: tableView代理
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if viewModel.showLists == nil {
            return 0
        }
        return viewModel.showLists!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "LevelCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let model = viewModel.showLists![indexPath.row]
        viewModel.bing(tableView,cell: cell as! LevelCell, model: model).observeResult { value in
            value.analysis(ifSuccess: { (type, indexs) -> Void in
                print(indexs)
                self.tableView .insertRows(at: indexs, with: UITableViewRowAnimation.none)
                
            }, ifFailure: { (error) -> Void in
            })
        }
        return cell
    }

}

