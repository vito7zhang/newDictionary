//
//  MoreViewController.m
//  Dictionary
//
//  Created by vito7zhang on 16/8/4.
//  Copyright © 2016年 vito7zhang. All rights reserved.
//

#import "MoreViewController.h"
#import "MyCollectionViewController.h"
#import "UIViewController+SetNavigationBar.h"

@interface MoreViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *dataSource;
}

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftButton];
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableView];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"beijing"]];
    
    dataSource = @[@"我的收藏",@"我的分享",@"意见反馈",@"精品应用",@"应用打分",@"关于我们"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(UISCREENWIDTH-44, 0, 44, 44)];
        imageView.image = [UIImage imageNamed:@"continue"];
        [cell.contentView addSubview:imageView];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = dataSource[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            MyCollectionViewController *myCollectionVC = [MyCollectionViewController new];
            [self.navigationController pushViewController:myCollectionVC animated:YES];
        }
            break;
            
        default:
            break;
    }
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
