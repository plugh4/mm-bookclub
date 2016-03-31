//
//  Review+CoreDataProperties.h
//  mm-bookclub
//
//  Created by Christopher Serra on 3/31/16.
//  Copyright © 2016 plugh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Review.h"
@class Book;

NS_ASSUME_NONNULL_BEGIN

@interface Review (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) Book *book;

@end

NS_ASSUME_NONNULL_END
