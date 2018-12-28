# HLMainSubTableViewDemo
父TableView嵌套子TableView平滑滚动
## 可指定TableView类型,TableView中实现了对滑动的监听,只需设置子TableView距离父TableView顶部的距离即可

### 示例
<img src="https://github.com/huanglei1926/HLMainSubTableViewDemo/blob/master/images/mainsubtableview.gif" width="375" height="812" alt="示例"/>

## 使用
### Import
```Objective-C
#import "HLMainSubTableView.h"
```
### 创建父TableView
```Objective-C
- (void)viewDidLoad {
    [super viewDidLoad];
    HLMainSubTableView *mainTableView = [[HLMainSubTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped tableViewType:HLMainSubTableViewTypeMain];
    mainTableView.headerMaxOffsetY = 200;
}

//必须实现此代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{}
```
### 创建子TableView
```Objective-C
- (void)viewDidLoad {
    [super viewDidLoad];
    HLMainSubTableView *subTableView = [[HLMainSubTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped tableViewType:HLMainSubTableViewTypeSub];
}

//必须实现此代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{}
```
