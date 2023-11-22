//
//  XHContractMarketSearchVC.m
//  UUKR
//
//  Created by ZXH on 2023/8/7.
//  Copyright © 2023 ZHX. All rights reserved.
//

#import "XHContractMarketSearchVC.h"
#import "XHContractModel.h"

@interface XHContractMarketSearchVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>


@property (strong, nonatomic)NSMutableArray *listArray;
@property (strong, nonatomic)NSMutableArray *localArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation XHContractMarketSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = MyLocalized(@"s_search");
    
    // Do any additional setup after loading the view.
    NSString *filePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/exchangeList.json"];//获取json文件保存的路径
    NSData *data = [NSData dataWithContentsOfFile:filePath];//获取指定路径的data文件
    if (data) {
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil]; //获取到json文件的跟数据（字典）
        NSArray *dataArray = json;
        [self.localArray addObjectsFromArray:dataArray];
        self.listArray = self.localArray.mutableCopy;
        [self.tableView reloadData];
    }
    [self setTextLocalizable];
}

- (void)setTextLocalizable{
    self.searchBar.placeholder = MyLocalized(@"s_search");
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.text = self.listArray[indexPath.row];
        cell.backgroundColor = [UIColor colorNamed:@"white_color"];
        cell.textLabel.textColor = [UIColor colorNamed:@"text_default"];//设置当前单元格的显示字体的颜色
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.clickChoose){
        self.clickChoose(self.listArray[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSString *text = [searchText uppercaseString];
    if (text.length>0) {
        self.listArray = self.localArray.mutableCopy;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", text];
        NSMutableArray *searchArray = [NSMutableArray arrayWithArray:[self.listArray filteredArrayUsingPredicate:predicate]];
        self.listArray = [NSMutableArray arrayWithArray:searchArray];
    }else{
        self.listArray = self.localArray.mutableCopy;
    }
    
    [self.tableView reloadData];
}

- (NSMutableArray *)listArray{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (NSMutableArray *)localArray{
    if (!_localArray) {
        _localArray = [NSMutableArray array];
    }
    return _localArray;
}

@end
