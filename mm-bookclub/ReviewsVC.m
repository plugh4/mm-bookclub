//
//  ReviewsVC.m
//  mm-bookclub
//
//  Created by Christopher Serra on 3/31/16.
//  Copyright © 2016 plugh. All rights reserved.
//

#import "ReviewsVC.h"
#import "AppDelegate.h"
#import "Book.h"
#import "Review.h"


@interface ReviewsVC () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSManagedObjectContext *moc;
@property NSArray *myReviews;
@end


@implementation ReviewsVC

- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"[%@ %@]", self.class, NSStringFromSelector(_cmd));
    
    [self reloadData];
    
    // navbar
    self.navigationItem.title = @"got here";
    self.navigationItem.title = self.bookCore.title;
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    NSLog(@"[%@ %@]", self.class, NSStringFromSelector(_cmd));
//    [self reloadData];
//}
//
//
#pragma mark - Core Data
- (void)reloadData {
    // snapshot of Core Data set
    self.myReviews = self.bookCore.reviews.allObjects;
    [self.tableView reloadData];
}


#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.myReviews.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"[%@ %@] %i", self.class, NSStringFromSelector(_cmd), indexPath.row);
    
    Review *rCore = self.myReviews[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reviewCell" forIndexPath:indexPath];
    cell.textLabel.text = rCore.text;
    return cell;
}


@end
