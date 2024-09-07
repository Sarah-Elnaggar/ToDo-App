//
//  SecondViewController.m
//  ToDo App
//
//  Created by Sarah on 17/07/2024.
//

#import "SecondViewController.h"



@interface SecondViewController ()

@property (weak, nonatomic) IBOutlet UITableView *table2;
@property (weak, nonatomic) IBOutlet UIImageView *image2;

@property NSArray<NSData *> *encodedItems;
@property NSMutableArray<Items*>* enteredItems2;
@property NSMutableArray<Items*>* filteredItems;
@property Items* item;
@property BOOL isFiltered;

@end


@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _table2.delegate = self;
    _table2.dataSource = self;
    
    _isFiltered = NO;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.title = @"In Progress Notes";

    //  [self.tabBarController.navigationItem.rightBarButtonItems [0] setHidden:YES];
    //  [self.tabBarController.navigationItem.rightBarButtonItems [1] setHidden:NO];
    
    self.tabBarController.navigationItem.rightBarButtonItem = [UIBarButtonItem.alloc initWithImage:[UIImage systemImageNamed:@"line.3.horizontal.decrease.circle.fill"] style: UIBarButtonItemStylePlain target:self action:@selector(filter)];
    self.tabBarController.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithDisplayP3Red:0.428 green:0.612 blue:0.185 alpha:1];
    
    self.encodedItems =  [[NSUserDefaults standardUserDefaults] arrayForKey:@"savedItems"];
    
    self.enteredItems2 = [NSMutableArray array];
    
    for (NSData *encodedItem in self.encodedItems) {
        NSError *error = nil;
        _item = [NSKeyedUnarchiver unarchivedObjectOfClass:[Items class] fromData:encodedItem error:&error];
        if (!error && _item.type.intValue == 1) {
            [self.enteredItems2 addObject:_item];
        }
    }

    if (self.enteredItems2.count ==0) {
        _table2.hidden = YES;
        _image2.hidden = NO;
    } else {
        _table2.hidden = NO;
        _image2.hidden = YES;
    }
  
    [self.table2 reloadData];
}

- (void) filter {
    _isFiltered = !_isFiltered;
    [self.table2 reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_isFiltered)
        return 3;
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (_isFiltered) {
        switch (section) {
            case 0:
                return @"Low";
                break;
            case 1:
                return @"Medium";
                break;
            default:
                return @"High";
                break;
        }
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isFiltered) {
        NSPredicate *predicate;
        switch (section) {
            case 0:
                predicate = [NSPredicate predicateWithFormat:@"priority == %d", 0];
                break;
            case 1:
                predicate = [NSPredicate predicateWithFormat:@"priority == %d", 1];
                break;
            case 2:
                predicate = [NSPredicate predicateWithFormat:@"priority == %d", 2];
                break;
            default:
                return 0;
        }
        return [[self.enteredItems2 filteredArrayUsingPredicate:predicate] count];
    } else {
        return self.enteredItems2.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
    
    Items *item;
    if (self.isFiltered) {
            NSPredicate *predicate;
            switch (indexPath.section) {
                case 0:
                    predicate = [NSPredicate predicateWithFormat:@"priority == %d", 0];
                    break;
                case 1:
                    predicate = [NSPredicate predicateWithFormat:@"priority == %d", 1];
                    break;
                case 2:
                    predicate = [NSPredicate predicateWithFormat:@"priority == %d", 2];
                    break;
                default:
                    return cell;
            }
        item = [[self.enteredItems2 filteredArrayUsingPredicate:predicate] objectAtIndex:indexPath.row];
        } else {
            item = self.enteredItems2[indexPath.row];
        }
        
    cell.textLabel.text = item.title;
    switch (item.priority.intValue) {
            case 0:
                cell.imageView.image = [UIImage imageNamed:@"Low"];
                break;
            case 1:
                cell.imageView.image = [UIImage imageNamed:@"Medium"];
                break;
            case 2:
                cell.imageView.image = [UIImage imageNamed:@"High"];
                break;
            default:
                break;
        }
        
        return cell;
    }

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSError *error = nil;
        Items * item = self.enteredItems2[indexPath.row];
    
        NSMutableArray<NSData*> *itemsArray = [NSMutableArray array];
        for (int i = 0; i < self.encodedItems.count; i++) {
            Items * decodedItem = [NSKeyedUnarchiver unarchivedObjectOfClass:[Items class] fromData:self.encodedItems[i] error:&error];
            if (decodedItem.ID != item.ID) {
                [itemsArray addObject:self.encodedItems[i]];
            }
        }
        [[NSUserDefaults standardUserDefaults] setObject:itemsArray forKey:@"savedItems"];
        
        [self.enteredItems2 removeObjectAtIndex:indexPath.row];
        
        [self.table2 deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        if (self.enteredItems2.count ==0) {
            _table2.hidden = YES;
            _image2.hidden = NO;
        } else {
            _table2.hidden = NO;
            _image2.hidden = YES;
        }
        
        [self.table2 reloadData];
    }
    
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   Items *selectedItem = self.isFiltered ? self.filteredItems[indexPath.row] : self.enteredItems2[indexPath.row];
    
    DetailsViewController *details = [self.storyboard instantiateViewControllerWithIdentifier:@"details"];
    details.item = selectedItem;
    details.editMode = YES;
    details.isInProgress= YES;
    [self.tabBarController.navigationController pushViewController:details animated:YES];
    
    [self.table2 reloadData];

    
}


@end
