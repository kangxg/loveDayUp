//
//  ETTPushedTestPaperDataManager.m
//  ettAiXuePaiNextGen
//
//  Created by LiuChuanan on 17/2/14.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTPushedTestPaperDataManager.h"
#import <FMDB.h>
#import "ETTPushedTestPaperModel.h"

@interface ETTPushedTestPaperDataManager ()

@property (nonatomic, strong) FMDatabase *db;

@end

static NSString *pushedTestPaperTable = @"t_pushedTestPaper";

@implementation ETTPushedTestPaperDataManager


+ (instancetype)sharedManager 
{
    static ETTPushedTestPaperDataManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ETTPushedTestPaperDataManager alloc]init];
    });
    return manager;
}

- (instancetype)init 
{
    if (self = [super init]) 
    {
        [self createTable];
    }
    return self;
}


/**
 创建表格
 */
- (void)createTable 
{   
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSString *filePath         = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingString:@"pushedTestPaper.sqlite"];
    BOOL isFileExist = [fileManager fileExistsAtPath:filePath];
    
    _db = [FMDatabase databaseWithPath:filePath];
    
    if ([_db open]) {
        NSString *createTable = [NSString stringWithFormat:@"create table if not exists t_pushedTestPaper (id integer primary key autoincrement, 'itemId' VARCHAR,'testPaperId' VARCHAR, 'pushedId' VARCHAR ,'testPaperUrlString' VARCHAR)"];
        BOOL isSuccessCreate = [_db executeUpdate:createTable];
        if (!isSuccessCreate) {
            ETTLog(@"推送试卷创建表格失败原因 :%@",_db.lastErrorMessage);
        }
    }
    [_db close];
    
    //判断缓存文件路径中数据库是否存在
    if (!isFileExist) {
        
    }
}


/**
 插入数据

 @param data 数据
 */
- (void)insertData:(id)data
{
    ETTPushedTestPaperModel *model = (ETTPushedTestPaperModel *)data;
    if ([_db open]) {
        BOOL isSuccessInsert = [_db executeUpdate:@"insert into t_pushedTestPaper ('itemId','testPaperId','pushedId','testPaperUrlString') values (?,?,?,?)",model.itemId,model.testPaperId,model.pushedId,model.testPaperUrlString];
        if (!isSuccessInsert) {
            ETTLog(@"推送试卷插入数据失败原因: %@",_db.lastErrorMessage);
        }
    }
    [_db close];
}


/**
 查询所有数据

 @return 所有数据
 */
- (NSMutableArray *)selectAllData
{
    [_db open];
    
    NSMutableArray *array = [NSMutableArray array];
    
    FMResultSet *resultSet = [_db executeQuery:@"select *from t_pushedTestPaper"];
    while (resultSet.next) {
        
        ETTPushedTestPaperModel *model = [[ETTPushedTestPaperModel alloc]init];
        model.itemId = [resultSet stringForColumn:@"itemId"];
        model.testPaperId = [resultSet stringForColumn:@"testPaperId"];
        model.pushedId = [resultSet stringForColumn:@"pushedId"];
        model.testPaperUrlString = [resultSet stringForColumn:@"testPaperUrlString"];
        [array addObject:model];
    }
    [_db close];
    return array;
}


/**
 删除所有数据
 */
- (void)deleteAllData
{
    [_db open];
    BOOL isSuccessDelete = [_db executeUpdate:@"delete from t_pushedTestPaper where id > 0"];
    if (!isSuccessDelete) {
        ETTLog(@"推送试卷删除数据失败原因 :%@",_db.lastErrorMessage);
    }
    [_db close];
}

/**
 删除一条数据

 @param ID 单条数据
 */
- (void)deleteOneDataWithID:(NSInteger)ID
{
    [_db open];
    BOOL isSuccessDelete = [_db executeUpdate:[NSString stringWithFormat:@"delete from t_pushedTestPaper where id = %d",ID]];
    
    if (!isSuccessDelete) {
        ETTLog(@"推送试卷删除单条数据失败原因: %@",_db.lastErrorMessage);
    }
    [_db close];
}

@end
