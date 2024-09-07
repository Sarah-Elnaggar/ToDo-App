//
//  DetailsViewController.m
//  ToDo App
//
//  Created by Sarah on 17/07/2024.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextField *titlelbl;
@property (weak, nonatomic) IBOutlet UITextField *descriptionlbl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritylbl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typelbl;
@property (weak, nonatomic) IBOutlet UIDatePicker *datelbl;

@property NSMutableArray<NSData*> *itemsArray;
@property NSMutableArray<Items*> *enteredItems;

@property NSInteger itemID;
@property NSString* itemTitle;
@property NSString* itemDescription;
@property NSNumber *itemPriority;
@property NSNumber *itemType;
@property NSDate *itemDate;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //_image.image = [UIImage imageNamed:@"Low"];
    [self setSegment];
    
    
    if (self.editMode) {
        self.itemID = self.item.ID;
        self.titlelbl.text = self.item.title;
        self.descriptionlbl.text = self.item.descriptionn;
        self.prioritylbl.selectedSegmentIndex = [self.item.priority integerValue];
        self.typelbl.selectedSegmentIndex = [self.item.type integerValue];
        self.datelbl.date = self.item.date;
    } else {
        self.itemID = [[NSUserDefaults standardUserDefaults] integerForKey:@"nextID"];
        self.titlelbl.text = @"";
        self.descriptionlbl.text = @"";
        [[NSUserDefaults standardUserDefaults] setInteger:self.itemID + 1 forKey:@"nextID"];
    }
}


- (IBAction)segment:(id)sender {
    switch (self.prioritylbl.selectedSegmentIndex) {
        case 2:
            _image.image = [UIImage imageNamed:@"High"];
            break;
        case 1:
            _image.image = [UIImage imageNamed:@"Medium"];
            break;
        default:
            _image.image = [UIImage imageNamed:@"Low"];
            break;
    }
}

- (void) setSegment {
    
     [self.typelbl setEnabled:YES forSegmentAtIndex:0];
     [self.typelbl setEnabled:YES forSegmentAtIndex:1];
     [self.typelbl setEnabled:YES forSegmentAtIndex:2];
    
    if (self.isCreated) {
        [self.typelbl setEnabled:NO forSegmentAtIndex:1];
        [self.typelbl setEnabled:NO forSegmentAtIndex:2];
    } else if (self.isInProgress) {
        [self.typelbl setEnabled:NO forSegmentAtIndex:0];
        [self.typelbl setEnabled:YES forSegmentAtIndex:1];
        [self.typelbl setEnabled:YES forSegmentAtIndex:2];
    } else if (self.isDone) {
        [self.typelbl setEnabled:NO forSegmentAtIndex:0];
        [self.typelbl setEnabled:NO forSegmentAtIndex:1];
        [self.typelbl setEnabled:YES forSegmentAtIndex:2];
    }
}

- (IBAction)done:(id)sender {
    
    _itemTitle = _titlelbl.text;
    _itemDescription = _descriptionlbl.text;
    _itemPriority = @( _prioritylbl.selectedSegmentIndex);
    _itemType = @( _typelbl.selectedSegmentIndex);
    _itemDate = _datelbl.date;
    
    if (self.itemTitle.length ==0) {
        
        UIAlertController* titleAlert = [UIAlertController alertControllerWithTitle:@"Not allowed" message:@"Please Enter a title" preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction* Dismiss = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil];
    
        [titleAlert addAction:Dismiss];
        
        [self presentViewController:titleAlert animated:YES completion:nil];
        
    } else {
        UIAlertController* Alert = [UIAlertController alertControllerWithTitle:@"Confirm saving a note" message:@"Are you sure?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* Ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            self->_item = [[Items alloc] initWithID:self->_itemID Andtitle:self->_itemTitle Anddescription:self->_itemDescription Andpriority:self->_itemPriority Andtype:self->_itemType Anddate:self->_itemDate];
            
           self->_itemsArray = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"savedItems"] mutableCopy];
           

            if (!self->_itemsArray) {
                self->_itemsArray= [NSMutableArray array];
            }
            
            NSError *error = nil;
            NSData *encodedItem = [NSKeyedArchiver archivedDataWithRootObject: self->_item requiringSecureCoding:NO error:&error];
            
            if (error) {
                UIAlertController* error = [UIAlertController alertControllerWithTitle:@"Error" message:@"Failed to save item" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *dismiss = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil];
                   [error addAction:dismiss];
                [self presentViewController:error animated:YES completion:nil];
                return;
            }
            
            
            if (self.editMode) {
                for (int i = 0; i < self.itemsArray.count; i++) {
                    NSError *error = nil;
                    Items * item = [NSKeyedUnarchiver unarchivedObjectOfClass:[Items class] fromData:self.itemsArray[i] error:&error];
                    if (item.ID == self.item.ID) {
                        [self.itemsArray replaceObjectAtIndex:i withObject:encodedItem];
                    }
                }
            } else {
                [self.itemsArray addObject:encodedItem];
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:self.itemsArray forKey:@"savedItems"];

            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        
        
        UIAlertAction* Cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
        
        [Alert addAction:Ok];
        [Alert addAction:Cancel];
        
        [self presentViewController:Alert animated:YES completion:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
