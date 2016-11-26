//
//  JYMultiLevelViewController.swift
//  JYMultiLevel
//
//  Created by weijingyun on 16/11/26.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

import UIKit
import ReactiveSwift

class JYMultiLevelViewController: UITableViewController {
    
    let viewModel = JYMultiLevelViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.red
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


}

