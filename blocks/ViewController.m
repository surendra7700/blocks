//
//  ViewController.m
//  blocks
//
//  Created by surendra kumar k on 13/03/16.
//  Copyright © 2016 frendsOrg. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
- (IBAction)get:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *make = @"kumar";
    NSString *(^getFullName)(NSString *) = ^
    
    (NSString *model)
    
    {
        return [make stringByAppendingFormat:@" %@", model];
    };
    
    
    
    NSLog(@"%@", getFullName(@"surendra"));

    // Honda Accord
    // Do any additional setup after loading the view, typically from a nib.
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)get:(id)sender {
    
    

    
}
@end
