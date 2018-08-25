//
//  ViewController.m
//  tmpZipperIos
//
//  Created by beyond on 2018/1/28.
//  Copyright © 2018年 beyond. All rights reserved.
//

#import "ViewController.h"
#import "SSZipArchive.h"
@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    //    [self startZip];
    
    [self startUnZip];
    
    
    
}
#pragma mark - 压缩
- (void)startZip
{
    NSString *sampleDataPath = [[NSBundle mainBundle].bundleURL
                                URLByAppendingPathComponent:@"Sample Data"
                                isDirectory:YES].path;
    
    NSLog(@"sg__sampleDataPath:%@",sampleDataPath);
    NSString *zipPath = [self tempZipPath];
    NSLog(@"sg___zipPath:%@",zipPath);
    
    NSString *password = @"";
    BOOL success = [SSZipArchive createZipFileAtPath:zipPath
                             withContentsOfDirectory:sampleDataPath
                                 keepParentDirectory:NO
                                    compressionLevel:-1
                                            password:password.length > 0 ? password : nil
                                                 AES:YES
                                     progressHandler:nil];
    if (success) {
        NSLog(@"Success zip");
        
        
//        [self startUnZip];
    } else {
        NSLog(@"No success zip");
    }
}


- (NSString *)tempZipPath {
    NSString *path = [NSString stringWithFormat:@"%@/\%@.zip",
                      NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0],
                      [NSUUID UUID].UUIDString];
    return path;
}

#pragma mark - 解压
- (void)startUnZip
{
    NSString *unzipPath = [self tempUnzipPathInDoc];
    
    
    
    
    NSString *zipPath = [[NSBundle mainBundle] pathForResource:@"abc.zip" ofType:nil];
    NSLog(@"sg__zip:%@",zipPath);
    
    NSLog(@"sg__unzip:%@",unzipPath);
    BOOL success = [SSZipArchive unzipFileAtPath:zipPath
                                   toDestination:unzipPath
                              preserveAttributes:YES
                                       overwrite:YES
                                  nestedZipLevel:0
                                        password:nil
                                           error:nil
                                        delegate:nil
                                 progressHandler:nil
                               completionHandler:nil];
    if (success) {
        NSLog(@"Success unzip");
    } else {
        NSLog(@"No success unzip");
        return;
    }
    
    
}

- (NSString *)tempUnzipPath {
    NSString *path = [NSString stringWithFormat:@"%@/\%@",
                      NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0],
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
