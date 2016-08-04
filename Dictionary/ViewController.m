//
//  ViewController.m
//  Dictionary
//
//  Created by vito7zhang on 16/8/1.
//  Copyright © 2016年 vito7zhang. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+ShowText.h"
#import "SearchViewController.h"

@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *selectedSegmentControl;
@property (weak, nonatomic) IBOutlet UITextField *rectntlySearchTextField;
@property (weak, nonatomic) IBOutlet UIImageView *recentlySearchImageView;
@property (weak, nonatomic) IBOutlet UILabel *changeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pinYinBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *buShouBackgroundView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self addSubViewToRecentlySearch];
    
    [self addSubViewToKeyBackgroungView];
    
    
    
    
}


-(void)insertUserDefaults:(NSString *)text{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *mArray = [NSMutableArray arrayWithArray:[userDefaults valueForKey:@"recentlySearch"]];
    if (!mArray) {
        [userDefaults setObject:[NSArray array] forKey:@"recentlySearch"];
    }
    [mArray insertObject:text atIndex:0];
    if (mArray.count == 8) {
        [mArray removeLastObject];
    }
    [userDefaults setObject:mArray forKey:@"recentlySearch"];
    [userDefaults synchronize];
}

#pragma mark 设置界面
-(void)setUI{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"beijing"]];
    self.navigationController.navigationBar.barTintColor = COLORRGB(134, 34, 41);
    self.title = @"汉语字典";
    NSDictionary *textDic = @{NSFontAttributeName:[UIFont systemFontOfSize:24],NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes = textDic;
}

-(void)addSubViewToRecentlySearch{
    for (UIView *view in self.recentlySearchImageView.subviews) {
        [view removeFromSuperview];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *mArray = [NSMutableArray arrayWithArray:[userDefaults valueForKey:@"recentlySearch"]];
    
    float buttonWidth = self.recentlySearchImageView.frame.size.height;
    float padding = (self.recentlySearchImageView.frame.size.width - 7 * buttonWidth) / 6;
    for (int i = 0; i < mArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(i * (buttonWidth + padding), 0, buttonWidth, buttonWidth);
        [button setTitle:mArray[i] forState:UIControlStateNormal];
        [button setTitleColor:COLORRGB(134, 35, 41) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(recentlySearchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.recentlySearchImageView addSubview:button];
    }
}

-(void)addSubViewToKeyBackgroungView{
    NSArray *array = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    
    float buttonWidth = 35;
    
    float lrPadding = (self.pinYinBackgroundView.frame.size.width-8*35)/7;
    float tbPadding = (self.pinYinBackgroundView.frame.size.height-4*35)/5;
    
    //当index等于26代表按钮添加完毕
    int index = 0;
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 8; j++) {
            if (index == 26) {
                break;
            }
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            [button setTitle:array[index] forState:UIControlStateNormal];
            button.frame = CGRectMake(j*(buttonWidth+lrPadding), (i+1)*tbPadding+i*buttonWidth, buttonWidth, buttonWidth);
            [button setTitleColor:COLORRGB(134, 35, 41) forState:UIControlStateNormal];
            button.tag = index+1;
            [button addTarget:self action:@selector(pinyinButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = [UIFont systemFontOfSize:22];
            [self.pinYinBackgroundView addSubview:button];
            index++;
        }
    }
    
    
    buttonWidth = 40;
    lrPadding = (self.buShouBackgroundView.frame.size.width-6*40)/7;
    tbPadding = (self.buShouBackgroundView.frame.size.height-4*40)/5;
    
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 6; j++) {
            if (i*6+j==17) {
                break;
            }
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            [button setTitle:[NSString stringWithFormat:@"%d",i*6+j+1] forState:UIControlStateNormal];
            [button setTitleColor:COLORRGB(134, 35, 41) forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:22];
            button.frame = CGRectMake((j+1)*lrPadding+j*buttonWidth, (i+1)*tbPadding+i*buttonWidth, buttonWidth, buttonWidth);
            button.tag = i*6+j+1;
            [button addTarget:self action:@selector(bushouButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.buShouBackgroundView addSubview:button];
        }
    }
    self.buShouBackgroundView.hidden = YES;
}


#pragma mark 按钮方法绑定
- (IBAction)selectSegmentControlAction:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:{
            self.changeLabel.text = @"根据拼音字母来检索：";
            self.pinYinBackgroundView.hidden = NO;
            self.buShouBackgroundView.hidden = YES;
        }
            break;
        case 1:{
            self.changeLabel.text = @"根据部首笔画来检索：";
            self.pinYinBackgroundView.hidden = YES;
            self.buShouBackgroundView.hidden = NO;
        }
        default:
            break;
    }
}

//最近搜索按钮绑定方法
-(void)recentlySearchButtonAction:(UIButton *)sender{
    
}
//字母检索绑定方法
-(void)pinyinButtonAction:(UIButton *)sender{
    SearchViewController *searchVC = [SearchViewController new];
    searchVC.isPinyin = YES;
    searchVC.section = (int)sender.tag;
    [self.navigationController pushViewController:searchVC animated:YES];
}
//部首检索绑定方法
-(void)bushouButtonAction:(UIButton *)sender{
    SearchViewController *searchVC = [SearchViewController new];
    searchVC.isPinyin = NO;
    searchVC.section = (int)sender.tag;
    [self.navigationController pushViewController:searchVC animated:YES];
}



#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (textField.text.length == 1) {
        int a = [textField.text characterAtIndex:0];
        if(a > 0x4e00 && a < 0x9fff) {
            [self insertUserDefaults:textField.text];
            [self addSubViewToRecentlySearch];
            textField.text = @"";
            return  YES;
        }
    }
    [self showTextWithString:@"请输入单个汉字"];
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
