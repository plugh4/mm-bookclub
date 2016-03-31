//
//  Person+CoreDataProperties.h
//  mm-bookclub
//
//  Created by Christopher Serra on 3/31/16.
//  Copyright © 2016 plugh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Person.h"
@class Book;

NS_ASSUME_NONNULL_BEGIN

@interface Person (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *isFriend;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<Book *> *books;

@end

@interface Person (CoreDataGeneratedAccessors)

- (void)addBooksObject:(Book *)value;
- (void)removeBooksObject:(Book *)value;
- (void)addBooks:(NSSet<Book *> *)values;
- (void)removeBooks:(NSSet<Book *> *)values;

@end

NS_ASSUME_NONNULL_END
