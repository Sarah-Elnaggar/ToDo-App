//
//  DetailsViewController.h
//  ToDo App
//
//  Created by Sarah on 17/07/2024.
//

#import <UIKit/UIKit.h>
#import "Items.h"
#import "ViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController

@property Items* item;
@property NSInteger itemIndex;

@property BOOL editMode;
@property BOOL isCreated;
@property BOOL isInProgress;
@property BOOL isDone;

@end

NS_ASSUME_NONNULL_END
