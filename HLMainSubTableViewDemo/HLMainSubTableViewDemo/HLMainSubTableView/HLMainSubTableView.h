//
//  HLMainSubTableView.h
//  HLMainSubTableViewDemo
//
//  Created by cainiu on 2018/12/26.
//  Copyright © 2018 HL. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HLMainSubTableViewType) {
    HLMainSubTableViewTypeNone = 0,//普通TableView
    HLMainSubTableViewTypeMain = 1,//主TableView(外层TableView)
    HLMainSubTableViewTypeSub = 2,//子TableView(内层TableView)
};


@interface HLMainSubTableView : UITableView

///注意,需要在TableView的代理里实现scrollViewDidScroll:方法
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style tableViewType:(HLMainSubTableViewType)tableViewType;

/** TableView类型 */
@property (nonatomic, assign) HLMainSubTableViewType tableViewType;

/**
 主TableView最大偏移量(即子TableView滚动到主TableView指定位置时主TableView的contentOffsetY,可通过主TableView初始contentOffsetY+主TableView最大滚动距离得到),只有tableViewType为HLMainSubTableViewTypeMain时需要设置
 */
@property (nonatomic, assign) CGFloat headerMaxOffsetY;

@end

NS_ASSUME_NONNULL_END
