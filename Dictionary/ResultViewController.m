//
//  ResultViewController.m
//  Dictionary
//
//  Created by vito7zhang on 16/8/3.
//  Copyright © 2016年 vito7zhang. All rights reserved.
//

#import "ResultViewController.h"
#import "UIViewController+SetNavigationBar.h"
#import "ResultTableViewCell.h"
#import "ResultModel.h"
#import <MBProgressHUD.h>

@interface ResultViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataSource;
    UITableView *myTableView;
}
@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self setUI];
    [self initData];
    
}

-(void)setUI{
    [self setLeftButton];
    [self setHomeButton];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"beijing"]];
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, UISCREENWIDTH, UISCREENHEIGHT-64) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    
    [myTableView registerNib:[UINib nibWithNibName:@"ResultTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([ResultTableViewCell class])];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.rowHeight = 80;
    
    self.title = self.word;
}

-(void)initData{
    dataSource = [NSMutableArray array];
    NSString *urlString;
    if (self.isPinyin) {
        urlString = [NSString stringWithFormat:@"http://www.chazidian.com/service/pinyin/%@/0/10",self.word];
    }else{
        urlString = [NSString stringWithFormat:@"http://www.chazidian.com/service/bushou/%d/0/10",self.bushou_id];
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *array = dictionary[@"data"][@"words"];
        for (NSDictionary *d in array) {
            ResultModel *m = [ResultModel new];
            m.simp = d[@"simp"] ? d[@"simp"] : @"";
            m.pinyin = d[@"yin"][@"pinyin"] ? d[@"yin"][@"pinyin"] : @"";
            m.bushou = d[@"bushou"] ? d[@"bushou"] : @"";
            m.bihua = d[@"num"] ? d[@"num"] : @"";
            [dataSource addObject:m];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [myTableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }];
    [dataTask resume];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResultTableViewCell class])];
    cell.backgroundColor = [UIColor clearColor];
    ResultModel *m = dataSource[indexPath.row];
    cell.wordLabel.text = m.simp;
    cell.zhuyinLabel.text = [NSString stringWithFormat:@"[%@]",m.pinyin];
    cell.bushouLabel.text = [NSString stringWithFormat:@"部首：%@",m.bushou];
    cell.bihuaLabel.text = [NSString stringWithFormat:@"笔画：%@",m.bihua];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
