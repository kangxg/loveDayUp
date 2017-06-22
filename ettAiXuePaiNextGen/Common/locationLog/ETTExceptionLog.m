//
//  ETTExceptionLog.m
//  ettAiXuePaiNextGen
//
//  Created by kangxg on 2017/3/21.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

#import "ETTExceptionLog.h"
#import "AvoidCrash.h"
#define ETTLOGNAME       @"aixuepai"
#define ETTLOGDIRECTORY  @"AiXuePaiLogs"

@implementation ETTExceptionLog
-(id)init
{
    if (self = [super init])
    {
        [self initLog];
     
    }
    return self;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)reciveExceptionMsg:(NSNotification *)notify
{
    if (notify)
    {
        NSException * exception  = notify.object;
        if (exception)
        {
            [self writeFile:exception];
        }
    }
}
-(void)initLog
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reciveExceptionMsg:) name:AvoidCrashNotification object:nil];
    if ([self createDirectory])
    {
        [self createFile];
    }
    
}
/**
 Description  创建文件夹
 @return 创建成功：YES  创建失败：False
 */
-(BOOL)createDirectory
{
    NSString *documentsPath =[self getDocumentsPath];
   
    NSString *iOSDirectory = [documentsPath stringByAppendingPathComponent:ETTLOGDIRECTORY];
    if ([self folderExists:iOSDirectory])
    {
        [self clearCache:iOSDirectory];
        return YES;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isSuccess = [fileManager createDirectoryAtPath:iOSDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    return  isSuccess;
}
-(void)clearCache:(NSString *)path
{
    if (path)
    {
        NSArray * arr = [self allFilesAtPath:path];
        if (arr && arr.count>30)
        {
            NSString * fileName = arr.firstObject;
            [self deleteFile:fileName];
        }
    }
}
- (NSArray*) allFilesAtPath:(NSString*) dirString {
    
    NSMutableArray* array = [[NSMutableArray alloc]init];
    
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    
    NSArray* tempArray = [fileMgr contentsOfDirectoryAtPath:dirString error:nil];
    
    for (NSString* fileName in tempArray) {
        
        BOOL flag = YES;
        
        NSString* fullPath = [dirString stringByAppendingPathComponent:fileName];
        
        if ([fileMgr fileExistsAtPath:fullPath isDirectory:&flag])
        {
            if (!flag)
            {
                [array addObject:fullPath];
            }
        }
        
    }
    
    return array;
    
}

/**
 Description  判断文件夹是否存在
 
 @param path 文件路径
 @return 存在：YES  不存在：False
 */
-(BOOL)folderExists:(NSString *)path
{
    BOOL isDir;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if (isDir)
    {
        NSLog(@"这是个****文件夹****");
        return YES;
    }
    return false;
}
/**
 Description  判断文件是否存在
 
 @param path 文件路径
 @return 存在：YES  不存在：False
 */
-(BOOL)fileExist:(NSString *)path
{

    NSFileManager *fileManager = [NSFileManager defaultManager];
    return   [fileManager fileExistsAtPath:path];
}

-(BOOL)createFile
{
    NSString *documentsPath =[self getDocumentsPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *iOSDirectory = [documentsPath stringByAppendingPathComponent:ETTLOGDIRECTORY];
    
    NSString *iOSPath = [iOSDirectory stringByAppendingPathComponent:[self  getLogName]];
    if ([self fileExist:iOSPath])
    {
        return iOSPath;
    }
    BOOL isSuccess = [fileManager createFileAtPath:iOSPath contents:nil attributes:nil];
    return isSuccess;
}
-(NSString *)getLogName
{
    return [NSString stringWithFormat:@"%@.log",[self getDateString]] ;
}
-(NSString *)getDateString
{
    NSDate * today = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];//格式化
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString * s1 = [df stringFromDate:today];
    NSLog(@" s1s1s1s%@",s1);
    return s1;
}

-(NSString *)getFullDateString
{
    NSDate * today = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];//格式化
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * s1 = [df stringFromDate:today];
    
    return s1;
}

-(void)writeFile:(NSException *)exception
{
    if (exception == nil)
    {
        return;
    }
    NSString *documentsPath =[self getDocumentsPath];
    NSString *iOSDirectory = [documentsPath stringByAppendingPathComponent:ETTLOGDIRECTORY];
    if (![self folderExists:iOSDirectory])
    {
        if (![self createDirectory])
        {
            return;
        }
    }
    
    NSString *iOSPath = [iOSDirectory stringByAppendingPathComponent:[self getLogName]];
    if (![self fileExist:iOSPath])
    {
        if ([self createFile])
        {
            [self enterWriteFile:exception filePath:iOSPath];
        }
        
    }
    else
    {
        [self enterWriteFile:exception filePath:iOSPath];

    }
}

-(void)enterWriteFile:(NSException *)exception filePath:(NSString *)filePath
{
    if (exception == nil || filePath == nil)
    {
        return;
    }
    
    NSArray *callStack = [NSThread callStackSymbols];
    NSString *mainCallStackSymbolMsg = [AvoidCrash getMainCallStackSymbolMessageWithCallStackSymbols:callStack];
    if (mainCallStackSymbolMsg == nil)
    {
        mainCallStackSymbolMsg = @"崩溃方法定位失败,请您查看函数调用栈来排查错误原因";
    }
    NSString *errorPlace = [NSString stringWithFormat:@"Error Place:%@",mainCallStackSymbolMsg];
    //[exception callStackSymbols];
    NSArray * returnAddresses  = [exception callStackReturnAddresses];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    //            NSString * userInfo = [exception userInfo];
    NSString * title = [NSString stringWithFormat:@"-------------  %@  -------------\n",[self getFullDateString]];
   
    
    NSString *content = [NSString stringWithFormat:@"%@name:%@\nreason:n%@\ncallStackSymbols:%@\nuserInfo:%@\ncallStackReturnAddresses:%@\n\n",title,name,reason,errorPlace,[exception userInfo],[returnAddresses componentsJoinedByString:@"\n"]];
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    //将节点跳到文件的末尾
    [fileHandle seekToEndOfFile];
    
    NSData* stringData  = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    [fileHandle writeData:stringData]; //追加写入数据
    
    [fileHandle closeFile];


}
-(void)writeFile
{
    NSString *documentsPath =[self getDocumentsPath];
    NSString *iOSDirectory = [documentsPath stringByAppendingPathComponent:ETTLOGDIRECTORY];
    NSString *filePath = [iOSDirectory stringByAppendingPathComponent:[self getLogName]];
    NSString *content = [NSString stringWithFormat:@"-------------%@ 异常错误报告------------\n",[self getDateString]];
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    //将节点跳到文件的末尾
    [fileHandle seekToEndOfFile];
    
    NSData* stringData  = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    [fileHandle writeData:stringData]; //追加写入数据
    
    [fileHandle closeFile];

}
-(NSString *)getDocumentsPath
{
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    return documentDirectory;

}

/**
 Description  判断文件是否存在

 @param filePath 文件路径
 @return 存在：YES  不存在：False
 */
- (BOOL)isSxistAtPath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:filePath];
    return isExist;
}
/**
 Description  计算文件大小
 
 @param filePath 文件路径
 @return 存在：YES  不存在：False
 */

- (unsigned long long)fileSizeAtPath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:filePath];
    if (isExist)
    {
        unsigned long long fileSize = [[fileManager attributesOfItemAtPath:filePath error:nil] fileSize];
        return fileSize;
    } else {
        NSLog(@"file is not exist");
        return 0;
    }
}

/**
 Description  计算整个文件夹中所有文件大小
 
 @param filePath 文件路径
 @return 存在：YES  不存在：False
 */
- (unsigned long long)folderSizeAtPath:(NSString*)folderPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:folderPath];
    if (isExist)
    {
        NSEnumerator *childFileEnumerator = [[fileManager subpathsAtPath:folderPath] objectEnumerator];
        unsigned long long folderSize = 0;
        NSString *fileName = @"";
        while ((fileName = [childFileEnumerator nextObject]) != nil)
        {
            NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtPath:fileAbsolutePath];
        }
        return folderSize / (1024.0 * 1024.0);
    }
    else
    {
        NSLog(@"file is not exist");
        return 0;
    }
}

/**
 Description  计算整个文件夹中所有文件大小
 
 */
- (void)moveFileName:(NSString *)fileName toName:(NSString *)toName
{
    if (fileName == nil || toName == nil)
    {
        return;
    }
    NSString *documentsPath =[self getDocumentsPath];
    NSString *iOSDirectory = [documentsPath stringByAppendingPathComponent:ETTLOGDIRECTORY];
    NSString *filePath = [iOSDirectory stringByAppendingPathComponent:fileName];
    NSString *moveToPath = [iOSDirectory stringByAppendingPathComponent:toName];
    NSFileManager *fileManager = [NSFileManager defaultManager];

    BOOL isSuccess = [fileManager moveItemAtPath:filePath toPath:moveToPath error:nil];
    if (isSuccess) {
        NSLog(@"rename success");
    }else{
        NSLog(@"rename fail");
    }
}
/**
 Description  删除文件
 
 */

-(void)deleteFile:(NSString *)filePath
{
    if (filePath)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isSuccess = [fileManager removeItemAtPath:filePath error:nil];
        if (isSuccess)
        {
            NSLog(@"delete success");
        }else{
            NSLog(@"delete fail");
        }

    }
}


/**
 Description  重命名
 */
- (void)renameFileName:(NSString *)fileName toName:(NSString *)toName
{
    if (fileName == nil || toName == nil)
    {
        return;
    }
    //通过移动该文件对文件重命名
    NSString *documentsPath =[self getDocumentsPath];
    NSString *iOSDirectory = [documentsPath stringByAppendingPathComponent:ETTLOGDIRECTORY];
    NSString *filePath = [iOSDirectory stringByAppendingPathComponent:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
   
    NSString *moveToPath = [iOSDirectory stringByAppendingPathComponent:toName];
    BOOL isSuccess = [fileManager moveItemAtPath:filePath toPath:moveToPath error:nil];
    if (isSuccess)
    {
        NSLog(@"rename success");
    }else{
        NSLog(@"rename fail");
    }
}

-(BOOL)createLogFile:(NSString *)fileName
{
    if (fileName)
    {
        if ([self createDirectory])
        {
            NSString *documentsPath =[self getDocumentsPath];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *iOSDirectory = [documentsPath stringByAppendingPathComponent:ETTLOGDIRECTORY];
            
            NSString *iOSPath = [iOSDirectory stringByAppendingPathComponent:fileName];
            if ([self fileExist:iOSPath])
            {
                return YES;
            }
            BOOL isSuccess = [fileManager createFileAtPath:iOSPath contents:nil attributes:nil];
            return  isSuccess;
        }
    }
    return false;
}
-(void)deleteLogFile:(NSString *)fileName
{
    NSString *documentsPath =[self getDocumentsPath];
    NSString *iOSDirectory = [documentsPath stringByAppendingPathComponent:ETTLOGDIRECTORY];
    if (![self folderExists:iOSDirectory])
    {
        return;
    }
    NSString *filePath = [iOSDirectory stringByAppendingPathComponent:fileName];
    if ([self fileExist:filePath])
    {
         [self deleteFile:filePath];
    }

}
@end
