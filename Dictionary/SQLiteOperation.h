//
//  SQLiteOperation.h
//  Dictionary
//
//  Created by vito7zhang on 16/8/3.
//  Copyright © 2016年 vito7zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WordModel.h"

@interface SQLiteOperation : NSObject
+(NSArray *)findAllPinyin;
+(NSArray *)findAllBushou;

+(BOOL)insertModel:(WordModel *)model;
+(BOOL)deleteModel:(WordModel *)model;
+(NSArray *)findALLCollection;




@end
