//
//  UIViewController+ShowText.m
//  Dictionary
//
//  Created by vito7zhang on 16/8/1.
//  Copyright © 2016年 vito7zhang. All rights reserved.
//

#import "UIViewController+ShowText.h"

@implementation UIViewController (ShowText)
-(void)showTextWithString:(NSString *)text{
    float labelWidth = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24]}].width;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(UISCREENWIDTH/2-labelWidth/2-10, UISCREENHEIGHT/2-20, labelWidth+20, 40)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    label.backgroundColor = [UIColor grayColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:24];
    [self.view addSubview:label];
    
    [UIView animateWithDuration:1.5 animations:^{
        label.alpha = 0;
    } completion:^(BOOL finished) {
        [label removeFromSuperview];
    }];
}
@end
