//
//  ViewController.m
//  ToDo App
//
//  Created by Sarah on 17/07/2024.
//

#import "ViewController.h"

@interface ViewController ()


@property (weak, nonatomic) IBOutlet UITableView *table1;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UISearchBar *searcher;

@property NSArray<NSData*>* encodedItems;
@property NSMutableArray<Items*>* enteredItems1;
@property NSMutableArray<Items*>* filteredItems;
@property Items* item;
@property BOOL isFiltered;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _searcher.delegate = self;
    _isFiltered = NO;
    
    _table1.delegate = self;
    _table1.dataSource = self;
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.title = @"ToDo Notes";

  //  [self.tabBarController.navigationItem.rightBarButtonItems [0] setHidden:NO];
  //  [self.tabBarController.navigationItem.rightBarButtonItems [1] setHidden:YES];
    self.tabBarController.navigationItem.rightBarButtonItem = [UIBarButtonItem.alloc initWithImage:[UIImage systemImageNamed:@"plus"] style: UIBarButtonItemStylePlain target:self action:@selector(addItem)];
    self.tabBarController.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithDisplayP3Red:0.428 green:0.612 blue:0.185 alpha:1];
    
    self.encodedItems =  [[NSUserDefaults standardUserDefaults] arrayForKey:@"savedItems"];
    
    self.enteredItems1 = [NSMutableArray array];
    
    for (NSData *encodedItem in self.encodedItems) {
        NSError *error = nil;
        _item = [NSKeyedUnarchiver unarchivedObjectOfClass:[Items class] fromData:encodedItem error:&error];
        if (!error && _item.type.intValue == 0) {
            [self.enteredItems1 addObject:_item];
        }
    }
   
    if (self.enteredItems1.count ==0) {
        _table1.hidden = YES;
        _image1.hidden = NO;
    } else {
        _table1.hidden = NO;
        _image1.hidden = YES;
    }
  
    [self.table1 reloadData];
}


- (void) addItem {
    DetailsViewController *details = [self.storyboard instantiateViewControllerWithIdentifier:@"details"];
    details.isCreated = YES;
    [self.navigationController pushViewController:details animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length ==0) {
        _isFiltered = NO;
    } else {
        _isFiltered = YES;
        _filteredItems = [NSMutableArray new];
        for (Items* it in _enteredItems1) {
            NSRange titleRange = [it.title rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (titleRange.location != NSNotFound) {
                [self.filteredItems addObject:it];
            }
        }
    }
    [self.table1 reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_isFiltered)
        return _filteredItems.count;
    return _enteredItems1.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
    
    if (_isFiltered) {
        cell.textLabel.text = [[NSString alloc] initWithFormat: @"%@", [self.filteredItems[indexPath.row] valueForKey:@"title"]];
    } else {
        cell.textLabel.text = [[NSString alloc] initWithFormat: @"%@", [self.enteredItems1[indexPath.row] valueForKey:@"title"]];
    }
    NSString *priority = [[NSString alloc] initWithFormat: @"%@", [self.enteredItems1[indexPath.row] valueForKey:@"priority"]];
        switch ([priority integerValue]) {
            case 0:
                cell.imageView.image = [UIImage imageNamed:@"Low"];
                break;
            case 1:
                cell.imageView.image = [UIImage imageNamed:@"Medium"];
                break;
            default:
                cell.imageView.image = [UIImage imageNamed:@"High"];
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
        Items * item = self.enteredItems1[indexPath.row];
    
        NSMutableArray<NSData*> *itemsArray = [NSMutableArray array];
        for (int i = 0; i < self.encodedItems.count; i++) {
            Items * decodedItem = [NSKeyedUnarchiver unarchivedObjectOfClass:[Items class] fromData:self.encodedItems[i] error:&error];
            if (decodedItem.ID != item.ID) {
                [itemsArray addObject:self.encodedItems[i]];
            }
        }
        [[NSUserDefaults standardUserDefaults] setObject:itemsArray forKey:@"savedItems"];
        
        [self.enteredItems1 removeObjectAtIndex:indexPath.row];
        
        [self.table1 deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        if (self.enteredItems1.count ==0) {
            _table1.hidden = YES;
            _image1.hidden = NO;
        } else {
            _table1.hidden = NO;
            _image1.hidden = YES;
        }
        
        [self.table1 reloadData];
    }
    
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   Items *selectedItem = self.isFiltered ? self.filteredItems[indexPath.row] : self.enteredItems1[indexPath.row];
    
    DetailsViewController *details = [self.storyboard instantiateViewControllerWithIdentifier:@"details"];
    details.item = selectedItem;
    details.editMode = YES;
    [self.tabBarController.navigationController pushViewController:details animated:YES];
    
    [self.table1 reloadData];
    
}


@end
