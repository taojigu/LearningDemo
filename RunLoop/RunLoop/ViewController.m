//
//  ViewController.m
//  RunLoop
//
//  Created by 顾吉涛Air on 2018/7/28.
//  Copyright © 2018年 顾吉涛. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, assign) NSInteger clickCount;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startRunLoopClicked:(id)sender {
    self.clickCount ++;
    NSInteger thisCount = self.clickCount;
    
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        NSLog(@"NewThread is Running");
        [self performSelector:@selector(printLog:) withObject:@(thisCount) afterDelay:3];
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:10]];//如果去掉这一行，thread就会立刻结束，3秒钟后，printLog不会被执行
    }];
    [thread start];
    
}

- (void)printLog:(NSObject *)objc {
    NSLog(@"PrintLog: %@",objc);
}

- (IBAction)stopRunLoopClicked:(id)sender {
    
}


@end
