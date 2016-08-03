//
//  UIViewController+SetNavigationBar.m
//  Dictionary
//
//  Created by vito7zhang on 16/8/3.
//  Copyright © 2016年 vito7zhang. All rights reserved.
//

#import "UIViewController+SetNavigationBar.h"

@implementation UIViewController (SetNavigationBar)
-(void)setLeftButton{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}

-(void)setHomeButton{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"home"] style:UIBarButtonItemStylePlain target:self action:@selector(homeAction:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

-(void)backAction:(UIBarButtonItem *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)homeAction:(UIBarButtonItem *)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
