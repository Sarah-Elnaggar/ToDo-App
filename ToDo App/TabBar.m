//
//  TabBar.m
//  ToDo App
//
//  Created by Sarah on 17/07/2024.
//

#import "TabBar.h"
#import "ViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "DetailsViewController.h"
#import "Items.h"

@interface TabBar ()

@end

@implementation TabBar

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)add:(id)sender {
    DetailsViewController *details = [self.storyboard instantiateViewControllerWithIdentifier:@"details"];
    [self.navigationController pushViewController:details animated:YES];
}

- (IBAction)filter:(id)sender {
    
}

@end
