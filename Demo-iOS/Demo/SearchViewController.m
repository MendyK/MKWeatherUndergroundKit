//
//  SearchViewController.m
//  Demo
//
//  Created by Mendy Krinsky on 2/18/15.
//  Copyright (c) 2015 Mendy Krinsky. All rights reserved.
//

#import "SearchViewController.h"
#import "ViewController.h"

@interface SearchViewController ()
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;

@end

@implementation SearchViewController

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ViewController *vc = segue.destinationViewController;
    vc.locationToSearch = self.locationTextField.text;
}
@end
