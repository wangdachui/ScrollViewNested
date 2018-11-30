//
//  TopScrollView.swift
//  scrollViewNested
//
//  Created by 王涛 on 2018/11/30.
//  Copyright © 2018年 王涛. All rights reserved.
//

import UIKit

class TopScrollView: UITableView {
    
    var syncScrollContext: SyncScrollContext?
    
    override var contentOffset: CGPoint {
        didSet {
            if contentOffset.y != oldValue.y {
                //上层滑动
                guard let syncScrollContext = syncScrollContext else { return }
                if syncScrollContext.outerOffset.y < syncScrollContext.maxOffsetY {
                    //下层的offset < 下层可滑动最大值，说明下层还需要滑动，上层不动offset为0
                    contentOffset.y = 0
                }
                //不管怎么样，滑动即同步offset到上下文
                syncScrollContext.innerOffset = contentOffset
            }
        }
    }
}

extension TopScrollView: UIGestureRecognizerDelegate {
    //手势冲突的时候同时响应
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
