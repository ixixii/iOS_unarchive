//
//  ViewController.m
//  tempOCZIP2
//
//  Created by beyond on 2018/1/28.
//  Copyright © 2018年 beyond. All rights reserved.
//

#import "ViewController.h"

#import "Objective-Zip.h"

@interface ViewController ()

@end

@implementation ViewController

static int BUFFER_SIZE = 1024;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self startUnZip];
    
}


- (void)startUnZip
{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"abc.zip" ofType:nil];
    
    NSString *unzipPath = [self tempUnzipPathInDoc];
    
    NSLog(@"sg__%@",unzipPath);
    [self decompressFileFromPath:filePath toPath:unzipPath];
}



- (void)decompressFileFromPath:(NSString *)from toPath:(NSString *)to{
    @try {
        OZZipFile *unzipFile = [[OZZipFile alloc] initWithFileName:from mode:OZZipFileModeUnzip];
        
        　　//解压是否完成
        BOOL unzipFinished = NO;
        
        while (!unzipFinished) {
            
            　　　　//获取当前遍历到的文件信息
            OZFileInZipInfo *info = [unzipFile getCurrentFileInZipInfo];
            OZZipReadStream *stream = [unzipFile readCurrentFileInZip];
            NSMutableData *buffer = [[NSMutableData alloc] initWithLength:BUFFER_SIZE];
            
            // unzip files to the write path
            NSString *writePath = [to stringByAppendingPathComponent:info.name];
            if ([info.name hasSuffix:@"/"]) {
                
                　　　　//创建目录
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                
                [fileManager createDirectoryAtPath:writePath withIntermediateDirectories:YES attributes:nil error:nil];
                //                    [MFFileToolkit createDrectoryIfNeeded:writePath];
            }else{
                
                　　　　//创建文件
                NSFileManager *fileManager = [NSFileManager defaultManager];
                [fileManager createFileAtPath:writePath contents:nil attributes:nil];
                
                //                    [MFFileToolkit createFilePath:writePath];
                
                //create fileHanderler to manage writing data to specified path, before writing data, move
                //the cusor to the end of the file first.
                NSFileHandle *fileHandler = [NSFileHandle fileHandleForWritingAtPath:writePath];
                [buffer setLength:0];
                
                do {
                    [buffer setLength:BUFFER_SIZE];
                    int bytesRead = [stream readDataWithBuffer:buffer];
                    
                    
                    　　　　　　//每次读取BUFFER_SIZE大小的数据，如果读出的数据大小>0，就继续循环读取数据，
                    
                    　　　　　　//直到读到的数据大小<= 0时，退出循环，当前遍历的文件已解压完毕
                    if (bytesRead > 0) {
                        [buffer setLength:bytesRead];
                        [fileHandler seekToEndOfFile];
                        [fileHandler writeData:buffer];
                    }else{
                        break;
                    }
                } while (YES);
                
                [fileHandler closeFile];
            }
            
            [stream finishedReading];
            buffer = nil;
            
            // Check if we should continue reading
            unzipFinished = ![unzipFile goToNextFileInZip];
        }
    }
    @catch (OZZipException *exception) {
        @throw exception;
    }
}


- (NSString *)tempUnzipPathInDoc
{
    NSString *path = [NSString stringWithFormat:@"%@/\%@",
                      NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0],
                      [NSUUID UUID].UUIDString];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtURL:url
                             withIntermediateDirectories:YES
                                              attributes:nil
                                                   error:&error];
    if (error) {
        return nil;
    }
    return url.path;
}

@end
