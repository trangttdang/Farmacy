//
//  CalendarViewController.m
//  Farmacy
//
//  Created by Trang Dang on 7/17/22.
//

#import "CalendarViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <Parse/Parse.h>
#import <FSCalendar/FSCalendar.h>
#import "Schedule.h"
#import "ScheduleCell.h"
#import "MyCrop.h"

@interface CalendarViewController ()<FSCalendarDelegate,FSCalendarDataSource, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) NSArray *arrayOfSchedules;
@property (weak , nonatomic) FSCalendar *calendar;
@property (strong, nonatomic) NSMutableArray *arrayOfSchedulesOfSelectedDay;
@property (weak, nonatomic) IBOutlet UITableView *scheduleTableView;


@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchSchedules];
    //Integrate FSCalendar
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    self.calendar = calendar;
    calendar.dataSource = self;
    calendar.delegate = self;
    [self.view addSubview:calendar];
    
    self.scheduleTableView.delegate = self;
    self.scheduleTableView.dataSource = self;
    
}

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
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:uuidString                                                                        content:[self getNotificationContent:dateComponents] trigger:trigger];
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

- (UNMutableNotificationContent *) getNotificationContent: (NSDateComponents *)dateComponents{
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
    [query orderByAscending:@"time"];
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *schedules, NSError *error) {
        if (schedules != nil) {
            self.arrayOfSchedules = schedules;
            for (Schedule *schedule in schedules){
                NSLog(@"%@",schedule);
            }
        } else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}


- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    self.arrayOfSchedulesOfSelectedDay = [self loadSchedule:date];
    [self.scheduleTableView reloadData];
}

- (NSMutableArray *) loadSchedule: (NSDate *)date{
    //TODO: Optimize search/filter
    NSLog(@"%@", date);
    NSDateComponents *selectedComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSMutableArray *arrayOfScheduleOfSpecificDate = [[NSMutableArray alloc] init];
    
    [self.arrayOfSchedules enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDateComponents *specificDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:(NSDate *)obj[@"time"]];
        if ([selectedComponents isEqual: specificDateComponents]){
            [arrayOfScheduleOfSpecificDate addObject:obj];
        }
    }];
    return arrayOfScheduleOfSpecificDate;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScheduleCell" forIndexPath:indexPath];
    Schedule *schedule = self.arrayOfSchedulesOfSelectedDay[indexPath.row];
    //TODO: get weekday, time, and day format from date and change the labels
    cell.timeLabel.text = [NSString stringWithFormat: @"%@", schedule[@"time"]];

    //TODO: Get my crop that has this schedule
    

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfSchedulesOfSelectedDay.count;
}





@end
