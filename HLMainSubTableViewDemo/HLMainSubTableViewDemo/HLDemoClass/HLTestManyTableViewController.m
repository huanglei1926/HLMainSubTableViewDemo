//
//  HLTestManyTableViewController.m
//  HLMainSubTableViewDemo
//
//  Created by cainiu on 2018/12/26.
//  Copyright © 2018 HL. All rights reserved.
//

#import "HLTestManyTableViewController.h"
#import "HLTestSubTableViewController.h"
#import "HLMainSubTableView.h"
#import "HLTestConfig.h"

@interface HLTestManyTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) HLMainSubTableView *mainTableView;

@property (nonatomic, strong) UIScrollView *subTableContainerView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, weak) HLTestSubTableViewController *vc1;
@property (nonatomic, weak) HLTestSubTableViewController *vc2;

@end

@implementation HLTestManyTableViewController

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (HLMainSubTableView *)mainTableView{
    if(!_mainTableView){
        HLMainSubTableView *tableView = [[HLMainSubTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped tableViewType:HLMainSubTableViewTypeMain];
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
        tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01)];
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01)];
        _mainTableView = tableView;
        return _mainTableView;
    }
    return _mainTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self initSubViews];
    [self initDatas];
    [self.mainTableView reloadData];
    [self initTotalHeight];
}

- (void)initTotalHeight{
    CGFloat currentOffsetY = self.mainTableView.contentOffset.y;
    CGFloat scrollY  = [self.mainTableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]].origin.y;
    CGFloat headerMaxOffsetY = scrollY + currentOffsetY - 30;
    self.mainTableView.headerMaxOffsetY = headerMaxOffsetY;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.vc1.subTableView reloadData];
    [self.vc2.subTableView reloadData];
}

- (void)backAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)initSubViews{
    [self.view addSubview:self.mainTableView];
    self.subTableContainerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kCNScreenW, kCNScreenH - kCNSafeAreaTopHeight - 30)];
    self.subTableContainerView.pagingEnabled = YES;
    self.subTableContainerView.contentSize = CGSizeMake(kCNScreenW * 2, kCNScreenH - kCNSafeAreaTopHeight - 30);
    
    HLTestSubTableViewController *vc1 = [HLTestSubTableViewController new];
    self.vc1 = vc1;
    UIView *subView1 = vc1.view;
    subView1.frame = CGRectMake(0, 0, kCNScreenW, kCNScreenH - kCNSafeAreaTopHeight - 30);
    [self.subTableContainerView addSubview:subView1];
    
    HLTestSubTableViewController *vc2 = [HLTestSubTableViewController new];
    self.vc2 = vc2;
    UIView *subView2 = vc2.view;
    subView2.frame = CGRectMake(kCNScreenW, 0, kCNScreenW, kCNScreenH - kCNSafeAreaTopHeight - 30);
    [self.subTableContainerView addSubview:subView2];
    
    [self addChildViewController:vc1];
    [self addChildViewController:vc2];
}

- (void)initDatas{
    [self.dataSource removeAllObjects];
    for (int i = 0; i < 10; i++) {
        [self.dataSource addObject:[NSString stringWithFormat:@"%d",i]];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.dataSource.count;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.textLabel.text = self.dataSource[indexPath.row];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableViewCell"];
            [cell.contentView addSubview:self.subTableContainerView];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 44;
    }else{
        return kCNScreenH - kCNSafeAreaTopHeight - 30;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 30;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCNScreenW, 30)];
    headerView.backgroundColor = [UIColor darkGrayColor];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{}

@end
