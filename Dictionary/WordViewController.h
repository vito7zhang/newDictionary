//
//  WordViewController.h
//  Dictionary
//
//  Created by vito7zhang on 16/8/4.
//  Copyright © 2016年 vito7zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordModel.h"

@interface WordViewController : UIViewController
@property (nonatomic,strong)NSString *word;
@property (nonatomic,strong)WordModel *model;
@end
