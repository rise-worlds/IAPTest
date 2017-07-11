//
//  AppDelegate.h
//  iap test
//
//  Created by 张佗辉 on 2017/7/11.
//  Copyright © 2017年 张佗辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

