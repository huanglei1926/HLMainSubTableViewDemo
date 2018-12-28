//
//  HLTestSubTableViewController.m
//  HLMainSubTableViewDemo
//
//  Created by cainiu on 2018/12/26.
//  Copyright © 2018 HL. All rights reserved.
//

#import "HLTestSubTableViewController.h"
#import "HLMainSubTableView.h"
#import "HLTestConfig.h"

@interface HLTestSubTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation HLTestSubTableViewController

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
    [self initDatas];
}

- (void)initSubViews{
    [self.view addSubview:self.subTableView];
}

- (HLMainSubTableView *)subTableView{
    if (!_subTableView) {
        _subTableView = [self createTableView];
    }
    return _subTableView;
}

- (HLMainSubTableView *)createTableView{
    HLMainSubTableView *tableView = [[HLMainSubTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped tableViewType:HLMainSubTableViewTypeSub];
    tableView.backgroundColor = [UIColor darkGrayColor];
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        tableView.frame = CGRectMake(0, kCNSafeAreaTopHeight, kCNScreenW, kCNScreenH-kCNSafeAreaTopHeight);
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
        tableView.frame = CGRectMake(0, kCNSafeAreaTopHeight, kCNScreenW, kCNScreenH-kCNSafeAreaTopHeight);
    }
    tableView.tableHeaderView = TableHeaderFootNoView;
    tableView.tableFooterView = TableHeaderFootNoView;
    tableView.frame = self.view.bounds;
    tableView.rowHeight = 44;
    return tableView;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.subTableView.frame = self.view.bounds;
}

- (void)initDatas{
    [self.dataSource removeAllObjects];
    for (int i = 0; i < 20; i++) {
        [self.dataSource addObject:[NSString stringWithFormat:@"%d",i]];
    }
    [self.subTableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subcell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"subcell"];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{}
@end
