//
//  SyncScrollContext.swift
//  scrollViewNested
//
//  Created by 王涛 on 2018/11/30.
//  Copyright © 2018年 王涛. All rights reserved.
//

import UIKit

class SyncScrollContext {
    var maxOffsetY: CGFloat = 0 //上层最大的滑动距离
    var outerOffset: CGPoint = CGPoint.zero //上层offset
    var innerOffset: CGPoint = CGPoint.zero //下层offset
}
