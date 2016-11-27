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
        return viewModel.showLists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellViewModel = viewModel.showLists[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.cellIdentifier, for: indexPath)
        let signal = cellViewModel.bingCell(cell as! LevelCell)
        return cell
    }

}

//tableView 的界面处理
//                let currentIndex = try tableView.indexPath(for: cell).unwrap()
//                let currentModel = self.levelModel
//                let lists = try currentModel.getLevelList().unwrap()

//                    self.showLists!.insert(contentsOf: lists, at: currentIndex.row + 1)
//                    var indexs : [IndexPath] = []
//                    for idx in 1...lists.count {
//                        indexs = indexs + [IndexPath(row: currentIndex.row + idx, section: currentIndex.section)]
//                    }
//                    observer.send(value: (0,indexs))
