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
FMDatabase *collectionDB = nil;
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


+(BOOL)createDataBase{
    NSString *dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject]stringByAppendingString:@"/collection.sqlite"];
    collectionDB = [FMDatabase databaseWithPath:dbPath];
    [collectionDB open];
    BOOL isSuccess = [collectionDB executeUpdate:@"create table if not exists CollectionTable(simp text,pinyin text,zhuyin text,tra text,frame text,bushou text,bsnum text,num text,seq text,base text,hanyu text,idiom text,english text)"];
    return isSuccess;
}

+(BOOL)insertModel:(WordModel *)model{
    BOOL isSuccess = [self createDataBase];
    if (isSuccess) {
        BOOL inser = [collectionDB executeUpdate:@"insert or replace into CollectionTable(simp,pinyin,zhuyin,tra,frame,bushou,bsnum,num,seq,base,hanyu,idiom,english)values(?,?,?,?,?,?,?,?,?,?,?,?,?)",model.simp,model.pinyin,model.zhuyin,model.tra,model.frame,model.bushou,model.bsnum,model.num,model.seq,model.base,model.hanyu,model.idiom,model.english];
        return inser;
    }
    return NO;
}

+(BOOL)deleteModel:(WordModel *)model{
    BOOL isSuccess = [self createDataBase];
    if (isSuccess) {
        BOOL delete = [collectionDB executeUpdate:@"delete from CollectionTable where simp = ?",model.simp];
        return delete;
    }
    return NO;
}

+(NSArray *)findALLCollection{
    NSMutableArray *mArray = [NSMutableArray array];
    BOOL isSuccess = [self createDataBase];
    if (isSuccess) {
        FMResultSet *set = [collectionDB executeQuery:@"select * from CollectionTable"];
        while ([set next]) {
            WordModel *m = [WordModel new];
            m.simp = [set stringForColumn:@"simp"];
            m.zhuyin = [set stringForColumn:@"zhuyin"];
            m.pinyin = [set stringForColumn:@"pinyin"];
            m.bushou = [set stringForColumn:@"bushou"];
            m.tra = [set stringForColumn:@"tra"];
            m.frame = [set stringForColumn:@"frame"];
            m.bsnum = [set stringForColumn:@"bsnum"];
            m.num = [set stringForColumn:@"num"];
            m.seq = [set stringForColumn:@"seq"];
            m.base = [set stringForColumn:@"base"];
            m.hanyu = [set stringForColumn:@"hanyu"];
            m.idiom = [set stringForColumn:@"idiom"];
            m.english = [set stringForColumn:@"english"];
            [mArray addObject:m];
        }
        return mArray;
    }
    return nil;
}


@end
