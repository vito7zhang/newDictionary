//
//  IndexView.m
//  Dictionary
//
//  Created by vito7zhang on 16/8/3.
//  Copyright © 2016年 vito7zhang. All rights reserved.
//

#import "IndexView.h"

@implementation IndexView

+(id)viewWithArray:(NSArray *)array{
    IndexView *view = [IndexView new];
    view.frame = CGRectMake(UISCREENWIDTH-30, (UISCREENHEIGHT-(array.count*20+20))/2, 30, array.count*20+20);
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, view.frame.size.height)];
    imageView.image = [UIImage imageNamed:@"Key-frame3"];
    [view addSubview:imageView];
    
    for (int i = 0; i < array.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 10+i*20, 30, 20);
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [view addSubview:button];
    }
    return view;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
