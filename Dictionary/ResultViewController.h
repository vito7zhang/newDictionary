//
//  ResultViewController.h
//  Dictionary
//
//  Created by vito7zhang on 16/8/3.
//  Copyright © 2016年 vito7zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultViewController : UIViewController
@property (nonatomic,strong)NSString *word;
@property (nonatomic,assign)int bushou_id;
@property (nonatomic,assign)BOOL isPinyin;
@end
