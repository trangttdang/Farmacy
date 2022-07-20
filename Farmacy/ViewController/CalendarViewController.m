//
//  CalendarViewController.m
//  Farmacy
//
//  Created by Trang Dang on 7/17/22.
//

#import "CalendarViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <Parse/Parse.h>


@interface CalendarViewController ()
@property (nonatomic) NSArray *arrayOfSchedules;


@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchSchedules];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)didTapAskPermission:(id)sender {
    //Asking Permission to Use Notifications
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if(!error){
            [[UIApplication sharedApplication] registerForRemoteNotifications];
            NSLog(@"Permision granted");
        } else{
            NSLog(@"Permision not granted");
        }
    }];
    
}

- (IBAction)didTapSetReminder:(id)sender {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removeAllPendingNotificationRequests];
    [self setReminder:center];
    
}

- (void) setReminder: (UNUserNotificationCenter *) center{
    [self.arrayOfSchedules enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:(NSDate *)obj[@"time"]];
        
        // Create the trigger
        UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComponents repeats:NO];
        
        //Create and Register a Notification Request
        NSString *uuidString = [[NSUUID UUID] UUIDString];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:uuidString                                                                        content:[self getContent:dateComponents] trigger:trigger];
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (!error) {
                NSLog(@"Local Notification succeeded");
            }
            else {
                NSLog(@"Local Notification failed");
            }
        }];
    }];
}

- (UNMutableNotificationContent *) getContent: (NSDateComponents *)dateComponents{
    //Specify the Conditions for Delivery
    //Create the Notification's Content
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.categoryIdentifier = @"alarm";
    content.title = [NSString localizedUserNotificationStringForKey:@"Reminder!" arguments:nil];
    
    NSString *bodyHour = [NSString stringWithFormat:@"%ld", [dateComponents hour]];
    NSString *bodyMinute = [NSString stringWithFormat:@"%ld", [dateComponents minute]];
    
    //TODO: fetch crop name and action (fertilize/irrigate) and add to content.body
    content.body = [NSString localizedUserNotificationStringForKey:[@"Wheat needs to be fertilizered at "stringByAppendingFormat: @"%@", [bodyHour stringByAppendingFormat:@"%@", bodyMinute]]                                                                  arguments:nil];
    content.sound = [UNNotificationSound defaultSound];
    content.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] + 1);
    return content;
    
}

- (void) fetchSchedules{
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Schedule"];
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *schedules, NSError *error) {
        if (schedules != nil) {
            self.arrayOfSchedules = schedules;
        } else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

@end
