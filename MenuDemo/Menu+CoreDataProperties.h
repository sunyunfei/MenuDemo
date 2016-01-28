//
//  Menu+CoreDataProperties.h
//  MenuDemo
//
//  Created by 孙云 on 16/1/28.
//  Copyright © 2016年 haidai. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Menu.h"

NS_ASSUME_NONNULL_BEGIN

@interface Menu (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;

@end

NS_ASSUME_NONNULL_END
