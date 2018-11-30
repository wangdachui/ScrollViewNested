//
//  ViewController.swift
//  scrollViewNested
//
//  Created by 王涛 on 2018/11/30.
//  Copyright © 2018年 王涛. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ScrollView嵌套"
        edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        
        let subView = BottomScrollView(frame: view.bounds)
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 200))
        headerView.backgroundColor = UIColor.green
        subView.headerView = headerView
        view.addSubview(subView)
    }


}

