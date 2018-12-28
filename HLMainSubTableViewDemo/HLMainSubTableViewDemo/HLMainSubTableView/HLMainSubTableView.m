//
//  HLMainSubTableView.m
//  HLMainSubTableViewDemo
//
//  Created by cainiu on 2018/12/26.
//  Copyright © 2018 HL. All rights reserved.
//

#import "HLMainSubTableView.h"
#import <objc/runtime.h>


@interface HLMainSubTableView()

@property (nonatomic, assign) BOOL canScroll;

@end

@implementation HLMainSubTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style tableViewType:(HLMainSubTableViewType)tableViewType{
    if (self = [super initWithFrame:frame style:style]) {
        self.tableViewType = tableViewType;
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (self.tableViewType == HLMainSubTableViewTypeMain) {
        return YES;
    }
    return NO;
}


- (void)setTableViewType:(HLMainSubTableViewType)tableViewType{
    if (_tableViewType != HLMainSubTableViewTypeNone) {
        return;
    }
    _tableViewType = tableViewType;
    if (_tableViewType == HLMainSubTableViewTypeMain) {
        self.canScroll = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mainTableViewCanScroll) name:@"HLMainTableViewCanScrollNoti" object:nil];
    }else if (_tableViewType == HLMainSubTableViewTypeSub){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subTableViewCanScrollNoti) name:@"HLSubTableViewCanScrollNoti" object:nil];
    }
}

- (void)mainTableViewCanScroll{
    if (self.tableViewType == HLMainSubTableViewTypeMain) {
        self.canScroll = YES;
        self.showsVerticalScrollIndicator = YES;
    }
}

- (void)subTableViewCanScrollNoti{
    if (self.tableViewType == HLMainSubTableViewTypeSub) {
        self.canScroll = YES;
        self.showsVerticalScrollIndicator = YES;
    }
}

- (void)setDelegate:(id<UITableViewDelegate>)delegate{
    [super setDelegate:delegate];
    if (delegate) {
        if ([delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
            if (self.tableViewType == HLMainSubTableViewTypeMain) {
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                    Method method1 = class_getInstanceMethod([delegate class], @selector(scrollViewDidScroll:));
                    Method method2 = class_getInstanceMethod([self class], @selector(hl_mainScrollViewDidScroll:));
                    method_exchangeImplementations(method1, method2);
                });
            }else if (self.tableViewType == HLMainSubTableViewTypeSub){
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                    Method method1 = class_getInstanceMethod([delegate class], @selector(scrollViewDidScroll:));
                    Method method2 = class_getInstanceMethod([self class], @selector(hl_subScrollViewDidScroll:));
                    method_exchangeImplementations(method1, method2);
                });
            }else{
                NSLog(@"未指定TableView类型或指定类型为HLMainSubTableViewTypeNone");
            }
        }else{
            NSString *des = [NSString stringWithFormat:@"%@未实现scrollViewDidScroll:方法!",NSStringFromClass([delegate class])];
            NSCAssert(self.tableViewType == HLMainSubTableViewTypeNone,des);
        }
    }
}


- (void)hl_mainScrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[HLMainSubTableView class]]) {
        HLMainSubTableView *tableView = (HLMainSubTableView *)scrollView;
        [tableView updateScrollView:scrollView];
        [tableView hl_mainScrollViewDidScroll:scrollView];
    }
}

- (void)hl_subScrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[HLMainSubTableView class]]) {
        HLMainSubTableView *tableView = (HLMainSubTableView *)scrollView;
        [tableView updateScrollView:scrollView];
        [tableView hl_subScrollViewDidScroll:scrollView];
    }
}


- (void)updateScrollView:(UIScrollView *)scrollView{
    if (![scrollView isKindOfClass:[self class]]) {
        return;
    }
    if (self.tableViewType == HLMainSubTableViewTypeMain) {
        if (!self.canScroll) {
            self.contentOffset = CGPointMake(0, self.headerMaxOffsetY);
            self.showsVerticalScrollIndicator = NO;
            return;
        }
        if (scrollView.contentOffset.y >= self.headerMaxOffsetY) {
            self.contentOffset = CGPointMake(0, self.headerMaxOffsetY);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HLSubTableViewCanScrollNoti" object:nil];
            self.canScroll = NO;
        }
    }else if (self.tableViewType == HLMainSubTableViewTypeSub){
        if (!self.canScroll) {
            self.contentOffset = CGPointZero;
            self.showsVerticalScrollIndicator = NO;
        }
        if (scrollView.contentOffset.y <= 0) {
            self.canScroll = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HLMainTableViewCanScrollNoti" object:nil];
        }
    }
}

- (void)dealloc{
    if (self.tableViewType != HLMainSubTableViewTypeNone) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

@end
