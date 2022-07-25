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
#import "MyCropsViewController.h"

@interface CalendarViewController ()<FSCalendarDelegate,FSCalendarDataSource, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) NSArray *arrayOfSchedules;
@property (strong, nonatomic) NSMutableArray *arrayOfSchedulesOfSelectedDay;
@property (weak, nonatomic) IBOutlet UITableView *scheduleTableView;
@property (nonatomic) NSArray *arrayOfMyCrops;
@property (nonatomic,strong) NSCalendar *gregorian;
@property (weak, nonatomic) IBOutlet FSCalendar *calendarView;


@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self fetchSchedules];
    //Integrate FSCalendar
    self.calendarView.dataSource = self;
    self.calendarView.delegate = self;
    [self.view addSubview:self.calendarView];
    
    self.gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];

    self.scheduleTableView.delegate = self;
    self.scheduleTableView.dataSource = self;
    
}
// ---------- Reminder ----------
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
    NSLog(@"%@", [NSDate date]);
    [self.arrayOfSchedules enumerateObjectsUsingBlock:^(Schedule *schedule, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:(NSDate *)schedule.time];
        
        // Create the trigger
        UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComponents repeats:NO];
        
        //Create and Register a Notification Request
        NSString *uuidString = [[NSUUID UUID] UUIDString];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:uuidString                                                                        content:[self getNotificationContent:dateComponents withSchedule:schedule] trigger:trigger];
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (!error) {
                NSLog(@"Local Notification succeeded with %@", (NSDate *)schedule.time);
            }
            else {
                NSLog(@"Local Notification failed");
            }
        }];
    }];
}

- (UNMutableNotificationContent *) getNotificationContent: (NSDateComponents *)dateComponents withSchedule: (Schedule *)schedule {
    //Specify the Conditions for Delivery
    //Create the Notification's Content
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.categoryIdentifier = @"alarm";
    content.title = [NSString localizedUserNotificationStringForKey:@"Reminder!" arguments:nil];
    
    NSString *bodyHour = [NSString stringWithFormat:@"%ld", [dateComponents hour]];
    NSString *bodyMinute = [NSString stringWithFormat:@"%ld", [dateComponents minute]];
    
    MyCrop *myCrop = [MyCrop getMyCropUsingSchedule:schedule];
    Schedule *iSchedule =myCrop.irrigateSchedule;
    Schedule *fSchedule =myCrop.fertilizeSchedule;
    NSString *action = @"";
    if([schedule.objectId isEqual: fSchedule.objectId]){
        action = @" needs to fertilized at ";
    } else if ([schedule.objectId isEqual: iSchedule.objectId]){
        action = @" needs to irrigated at ";
    } else{
        NSLog(@"Error fetch crop action");
    }
    
    NSString *body = [myCrop.crop.name stringByAppendingString:[action stringByAppendingFormat:@"%@", [bodyHour stringByAppendingFormat:@":%@", bodyMinute]]];
    content.body = [NSString localizedUserNotificationStringForKey:body arguments:nil];
    content.sound = [UNNotificationSound defaultSound];
    content.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] + 1);
    return content;
    
}

// ---------- Calendar ----------

- (void) fetchSchedules{
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Schedule"];
    [query orderByAscending:@"time"];
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *schedules, NSError *error) {
        if (schedules != nil) {
            self.arrayOfSchedules = schedules;
        } else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}


- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    [self loadSchedulesOfSelectedDate:date];
    [self.scheduleTableView reloadData];
}

- (void) loadSchedulesOfSelectedDate: (NSDate *)selectedDate{
    self.arrayOfSchedulesOfSelectedDay = [[NSMutableArray alloc] init];
    [self.arrayOfSchedules enumerateObjectsUsingBlock:^(Schedule *schedule, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDate *date = schedule.time;
        BOOL sameDay = [self.gregorian isDate:date inSameDayAsDate:selectedDate];
        if (sameDay){
            [self.arrayOfSchedulesOfSelectedDay addObject:schedule];
        }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScheduleCell" forIndexPath:indexPath];
    Schedule *schedule = self.arrayOfSchedulesOfSelectedDay[indexPath.row];
    MyCrop *myCrop = [MyCrop getMyCropUsingSchedule:schedule];
    
    //Set time, weekday, and day Label
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"h:mm a"];
    cell.timeLabel.text = [formatter stringFromDate:schedule.time];
    [formatter setDateFormat:@"EE"];
    cell.weekDayLabel.text = [formatter stringFromDate:schedule.time];
    NSInteger day = [self.gregorian component:NSCalendarUnitDay fromDate:schedule.time];
    cell.dayLabel.text = [NSString stringWithFormat:@"%ld", day];
    
    //Set action
    if([schedule.objectId isEqual: myCrop.fertilizeSchedule.objectId]){
        cell.actionLabel.text = @"Fertilize";
    } else if ([schedule.objectId isEqual: myCrop.irrigateSchedule.objectId]){
        cell.actionLabel.text = @"Irrigate";
    } else{
        NSLog(@"Error fetch crop action");
    }
    
    //Set crop name
    cell.cropLabel.text = [NSString stringWithFormat: @"%@", myCrop.crop.name];

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfSchedulesOfSelectedDay.count;
}


@end
