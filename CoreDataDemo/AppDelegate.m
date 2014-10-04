//
//  AppDelegate.m
//  CoreDataDemo
//
//  Created by jianleer on 14-10-4.
//  Copyright (c) 2014年 jianleer. All rights reserved.
//

#import "AppDelegate.h"
#import "Jianleer.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSLog(@"homePath : %@",NSHomeDirectory());
    [self insertData];
    [self deleteData];
    [self updataDataWithName:@"百里屠苏" withAge:@5000];
    [self searchData];
    
    
    
    return YES;
}


-(void)insertData{
    
    //没运行一次插入一次
    
    NSManagedObjectContext *context      = self.managedObjectContext;
    NSManagedObject        *jianleer     = [NSEntityDescription insertNewObjectForEntityForName:@"Jianleer" inManagedObjectContext:context];
    
    [jianleer setValue:@"jianlee" forKey:@"name"];
    [jianleer setValue:@18 forKey:@"age"];
    
    
    
    
    Jianleer *jl    =   [NSEntityDescription insertNewObjectForEntityForName:@"Jianleer" inManagedObjectContext:context];
    jl.name         =   @"百里屠苏";
    jl.age          =   @100;
    
    
    Jianleer *wk    =   [NSEntityDescription insertNewObjectForEntityForName:@"Jianleer" inManagedObjectContext:context];
    wk.name         =   @"孙悟空";
    wk.age          =   @500;
    
    
    [self saveContext];

}

-(void)deleteData
{
    NSEntityDescription     *entity     = [NSEntityDescription entityForName:@"Jianleer" inManagedObjectContext:self.self.managedObjectContext];
    
    NSFetchRequest          *rq         = [[[NSFetchRequest alloc] init] autorelease];
    
    [rq setIncludesPropertyValues:YES];
    [rq setEntity:entity];
    
    NSError                 *error      = nil;
    NSArray                 *datas      = [self.managedObjectContext executeFetchRequest:rq error:&error];
    
    if (!error && datas && [datas count]) {
        for (NSManagedObject *obj in datas) {
            if ([[obj valueForKey:@"name"] isEqualToString:@"孙悟空"]) {
                [self.managedObjectContext deleteObject:obj];

            }
            
        }
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"error : %@",error);
        }else
        {
            NSLog(@"删除成功");
        }
    }
    
}


-(void)searchData
{
    NSManagedObjectContext  *context    = self.managedObjectContext;
    //要搜索那个类型的实体对象 就索检那个 Entity
    NSEntityDescription     *end        = [NSEntityDescription entityForName:@"Jianleer" inManagedObjectContext:context];
    NSFetchRequest          *request    =[[NSFetchRequest new]autorelease];
    [request setEntity:end];
    
    NSError                 *error      = nil;
    NSArray                 *dataArray  = [context executeFetchRequest:request error:&error];
    if (dataArray) {
        for (NSManagedObject *obj in dataArray) {
           // NSLog(@"结果 : %@",obj);
            NSString*name = [obj valueForKey:@"name"];
            NSString*age  = [obj valueForKey:@"age"];
            NSLog(@"name : %@  age : %@",name,age );
            
            
        }
    }
    
    
}


-(void)updataDataWithName:(NSString*)name withAge:(NSNumber*)age{
    //@"name like[cd] %@",name  查询name是传进来name的那条记录 找到之后执行后面的修改
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like[cd] %@",name];
    //IOS 之 谓词(NSPredicate)
    //在语⾔言上,谓语,谓词是用来判断的,比如 “我是程序猿” 中的是,就是表判断的谓语, “是” 就是⼀一个谓词,在objective-c中,应该说在Cocoa中的NSPredicate表示的就是⼀一种 判断。⼀一种条件的构建。我们可以先通过NSPredicate中的predicateWithFormat⽅方法来 ⽣生成⼀一个NSPredicate对象表示⼀一个条件,然后在别的对象中通过evaluateWithObject ⽅方法来进⾏行判断,返回⼀一个布尔值。
    //request
    NSFetchRequest *request     = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Jianleer" inManagedObjectContext:self.managedObjectContext]];
    
    [request setPredicate:predicate];
    NSError *error              = nil;
    NSArray *result             = [self.managedObjectContext executeFetchRequest:request error:&error];//此处获取的是一个数组,需要取出你要更新的那个obj
    for (Jianleer *obj in result) {
        obj.name                = name;
        obj.age                 = age;
    }
    
    
    //保存
    if ([self.managedObjectContext save:&error]) {
        NSLog(@"更新成功");
    }else
    {
        NSLog(@"error : %@",[error localizedDescription]);
    }
    
    
    
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.jianleer.demo.CoreDataDemo" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL     = [[NSBundle mainBundle] URLForResource:@"CoreDataDemo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL         = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreDataDemo.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
