//
//  SQLiteOperation.m
//  Dictionary
//
//  Created by vito7zhang on 16/8/3.
//  Copyright © 2016年 vito7zhang. All rights reserved.
//

#import "SQLiteOperation.h"
#import <FMDB.h>
#import "PinyinModel.h"
#import "BushouModel.h"

FMDatabase *db = nil;
@implementation SQLiteOperation

+(NSArray *)findAllPinyin{
    NSMutableArray *array = [NSMutableArray array];
    db = [FMDatabase databaseWithPath:[[NSBundle mainBundle] pathForResource:@"aaaaa2" ofType:@"sqlite"]];
    [db open];
    FMResultSet *set = [db executeQuery:@"select * from ol_pinyins"];
    while (set.next) {
        PinyinModel *pinyin = [PinyinModel new];
        pinyin.pinyin_id = [set intForColumn:@"id"];
        pinyin.pinyin = [set stringForColumn:@"pinyin"];
        [array addObject:pinyin];
    }
    return array;
}

+(NSArray *)findAllBushou{
    NSMutableArray *array = [NSMutableArray array];
    db = [FMDatabase databaseWithPath:[[NSBundle mainBundle] pathForResource:@"aaaaa2" ofType:@"sqlite"]];
    [db open];
    FMResultSet *set = [db executeQuery:@"select * from ol_bushou"];
    while (set.next) {
        BushouModel *bushou = [BushouModel new];
        bushou.bushou_id = [set intForColumn:@"id"];
        bushou.bihua = [set intForColumn:@"bihua"];
        bushou.bushou = [set stringForColumn:@"title"];
        [array addObject:bushou];
    }
    return array;
}








@end
