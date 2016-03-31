//
//  Book.h
//  mm-bookclub
//
//  Created by Christopher Serra on 3/30/16.
//  Copyright © 2016 plugh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Person, Review;

NS_ASSUME_NONNULL_BEGIN

@interface Book : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "Book+CoreDataProperties.h"
