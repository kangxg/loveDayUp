//
//  ETTTestPaperDataManager.m
//  ettAiXuePaiNextGen
//
//  Created by LiuChuanan on 17/2/14.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTTestPaperDataManager.h"
#import <FMDB.h>
#import "ETTPushedTestPaperModel.h"

@interface ETTTestPaperDataManager ()

@property (nonatomic, strong) FMDatabase *db;

@end

@implementation ETTTestPaperDataManager

+ (instancetype)sharedManager 
{
    static ETTTestPaperDataManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ETTTestPaperDataManager alloc]init];
    });
    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self createTable];
    }
    return self;
}

- (void)createTable 
{
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingString:@"testPaper.sqlite"];
    _db = [FMDatabase databaseWithPath:filePath];
    
    if ([_db open]) 
    {
        BOOL isCreateSuccses = [_db executeUpdate:@"create table if not exists t_testPaper(id interger primary key autoincrement, 'itemId' VARCHAR, 'testPaperId' VARCHAR, 'pushedId' VARCHAR)"];
        if (!isCreateSuccses) 
        {
            ETTLog(@"%@",_db.lastErrorMessage);
        }
    }
    [_db open];
}

- (void)insertData:(id)data 
{   [_db open];
    ETTPushedTestPaperModel *model = (ETTPushedTestPaperModel *)data;
    BOOL isInsertSuccess = [_db executeUpdate:@"insert into t_testPaper('itemId','testPaperId','pushedId') values(?,?,?)",model.itemId,model.testPaperId,model.pushedId];
    if (!isInsertSuccess) {
        ETTLog(@"%@",_db.lastErrorMessage);
    }
    [_db close];
}

- (NSMutableArray *)selectAllData
{
    [_db open];
    NSMutableArray *array = [NSMutableArray array];
    FMResultSet *resultSet = [_db executeQuery:@"select *from t_testPaper"];
    while (resultSet.next) {
        ETTPushedTestPaperModel *model = [[ETTPushedTestPaperModel alloc]init];
        model.itemId                   = [resultSet stringForColumn:@"itemId"];
        model.testPaperId              = [resultSet stringForColumn:@"testPaperId"];
        model.pushedId                 = [resultSet stringForColumn:@"pushedId"];
        [array addObject:model];
    }
    [_db close];
    return array;
}

- (void)deleteAllData
{
    [_db open];
    BOOL isDeleteSuccess = [_db executeUpdate:@"delect from t_testPaper where id >0"];
    if (!isDeleteSuccess) {
        ETTLog(@"删除试卷数据失败原因 :%@",_db.lastErrorMessage);
    }
    [_db close];
}

- (void)deleteOneDataWithID:(NSInteger)ID
{
    [_db open];
    BOOL isDeleteSuccess = [_db executeUpdate:@"delete from t_testPaper where id =%d",ID];
    if (!isDeleteSuccess) {
        ETTLog(@"删除单条数据失败原因: %@",_db.lastErrorMessage);
    }
}

@end
