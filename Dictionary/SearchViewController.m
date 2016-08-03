//
//  SearchViewController.m
//  Dictionary
//
//  Created by vito7zhang on 16/8/3.
//  Copyright © 2016年 vito7zhang. All rights reserved.
//

#import "SearchViewController.h"
#import "UIViewController+SetNavigationBar.h"
#import "PinyinModel.h"
#import "BushouModel.h"
#import "SQLiteOperation.h"
#import "IndexView.h"

@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataSource;
    NSArray *array1;
}
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setUI];

    
}

-(void)initData{
    dataSource = [NSMutableArray array];
    
    array1 = @[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z"];
    if (self.isPinyin) {
        NSArray *array = [SQLiteOperation findAllPinyin];
        for (int i = 0; i < 26; i++) {
            NSMutableArray *zimuArray = [NSMutableArray array];
            int index = 0;
            for (PinyinModel *m in array) {
                index++;
                if (index <= 26) {
                    continue;
                }
                if ([m.pinyin hasPrefix:array1[i]]) {
                    [zimuArray addObject:m];
                }
            }
            [dataSource addObject:zimuArray];
        }
    }else{
        NSArray *array = [SQLiteOperation findAllBushou];
        for (int i = 0; i < 17; i++) {
            NSMutableArray *bushouArray = [NSMutableArray array];
            for (BushouModel *m in array) {
                if (m.bihua == i+1) {
                    [bushouArray addObject:m];
                }
            }
            [dataSource addObject:bushouArray];
        }
    }
}

-(void)setUI{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"beijing"]];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.sectionIndexColor = [UIColor redColor];
    tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [self.view addSubview:tableView];
    
    [self setLeftButton];
    [self setHomeButton];
    
    if (self.isPinyin) {
        if (self.section == 9 || self.section == 22) {
            self.section++;
        }
        if (self.section == 21) {
            self.section--;
        }
    }
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.section-1] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
//    IndexView *indexView = [IndexView viewWithArray:array1];
//    [self.view addSubview:indexView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = dataSource[section];
    return array.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataSource.count;
}

-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (self.isPinyin) {
        return array1;
    }else{
        return @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17"];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.isPinyin) {
        return [array1[section] uppercaseString];
    }else{
        return [NSString stringWithFormat:@"%ld",section+1];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"];
        cell.backgroundColor = [UIColor clearColor];
    }
    if (self.isPinyin) {
        cell.textLabel.text = [(PinyinModel *)dataSource[indexPath.section][indexPath.row] pinyin];
    }else{
        cell.textLabel.text = [(BushouModel *)dataSource[indexPath.section][indexPath.row] bushou];
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end