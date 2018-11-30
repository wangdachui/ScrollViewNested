//
//  BottomScrollView.swift
//  scrollViewNested
//
//  Created by 王涛 on 2018/11/30.
//  Copyright © 2018年 王涛. All rights reserved.
//

import UIKit

class BottomScrollView: UIScrollView {

    var topScrollView: TopScrollView
    
    //由于上下滑动的时候top和bottom都需要相互通知自己滑动的offset，故设计一个上下文，两个ScrollView滑动的时候都同步数据到上下文中，需要的时候从上下文获取
    var syncScrollContext: SyncScrollContext
    
    var headerView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let headerView = headerView {
                addSubview(headerView)
            }
            p_layoutSubviews()
        }
    }
    
    override var contentOffset: CGPoint {
        didSet {
            if contentOffset.y != oldValue.y {
                //下层scrollView滑动
                if syncScrollContext.innerOffset.y > 0 {
                    // 上层的scrollView滑动，则下层的scrollView保持最大滑动距离
                    contentOffset.y = syncScrollContext.maxOffsetY
                } else {
                    //否则，上层不动，下层滑动
                }
                //同步offset到上下文
                syncScrollContext.outerOffset = contentOffset
            }
        }
    }
    
    override init(frame: CGRect) {
        topScrollView = TopScrollView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        //创建上下文，并让两个scrollView都持有
        syncScrollContext = SyncScrollContext()
        topScrollView.syncScrollContext = syncScrollContext
        
        super.init(frame: frame)
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        }
    
        topScrollView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        addSubview(topScrollView)
        topScrollView.dataSource = self
    }
    
    @available(*,unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func p_layoutSubviews() {
        var offsetY: CGFloat = 0
        if let headerView = headerView {
            headerView.frame = CGRect(x: 0, y: offsetY, width: bounds.width, height: headerView.frame.height)
            offsetY += headerView.frame.height
            syncScrollContext.maxOffsetY = headerView.frame.height
        }
        topScrollView.frame = CGRect(x: 0, y: offsetY, width: bounds.width, height: bounds.height)
        //下层scrollView的contentSize的高 = headerView.height + topScrollView.height。这样，当下层scrollView滑了y（y = headerView的高度）的时候，下层scrollView滑到底了，这时候c下层scrollView无法滑动，也就不存在手势冲突，上层scrollView自动开始响应，流畅的滑动起来了
        contentSize = CGSize(width: bounds.width, height: topScrollView.frame.maxY)
    }
}

extension BottomScrollView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.contentView.backgroundColor = UIColor.white
        cell.textLabel?.text = "\(indexPath.row)"
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    
}
