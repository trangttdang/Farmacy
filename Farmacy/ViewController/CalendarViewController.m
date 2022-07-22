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
@property (weak , nonatomic) FSCalendar *calendar;
@property (strong, nonatomic) NSMutableArray *arrayOfSchedulesOfSelectedDay;
@property (weak, nonatomic) IBOutlet UITableView *scheduleTableView;
@property (nonatomic) NSArray *arrayOfMyCrops;
@property (nonatomic) NSMutableArray *arrayOfFertilizeSchedules;
@property (nonatomic) NSMutableArray *arrayOfIrrigateSchedules;
@property (nonatomic,strong) NSCalendar *gregorian;


@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchSchedules];
    //Integrate FSCalendar
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(20, 100, 320, 300)];
    self.calendar = calendar;
    calendar.dataSource = self;
    calendar.delegate = self;
    [self.view addSubview:calendar];
    
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
    [self.arrayOfSchedules enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:(NSDate *)obj[@"time"]];
        
        // Create the trigger
        UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComponents repeats:NO];
        
        //Create and Register a Notification Request
        NSString *uuidString = [[NSUUID UUID] UUIDString];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:uuidString                                                                        content:[self getNotificationContent:dateComponents] trigger:trigger];
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (!error) {
                NSLog(@"Local Notification succeeded with %@", (NSDate *)obj[@"time"]);
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

// ---------- Calendar ----------

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
    [self loadSchedulesOfSelectedDate:date];
    [self.scheduleTableView reloadData];
}

- (void) loadSchedulesOfSelectedDate: (NSDate *)selectedDate{
    self.arrayOfSchedulesOfSelectedDay = [[NSMutableArray alloc] init];
    [self.arrayOfSchedules enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDate *date = (NSDate *)obj[@"time"];
        BOOL sameDay = [self.gregorian isDate:date inSameDayAsDate:selectedDate];
        if (sameDay){
            [self.arrayOfSchedulesOfSelectedDay addObject:obj];
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
    cell.timeLabel.text = [formatter stringFromDate:schedule[@"time"]];
    [formatter setDateFormat:@"EE"];
    cell.weekDayLabel.text = [formatter stringFromDate:schedule[@"time"]];
    NSInteger day = [self.gregorian component:NSCalendarUnitDay fromDate:schedule[@"time"]];
    cell.dayLabel.text = [NSString stringWithFormat:@"%ld", day];
    
    //Set action
    Schedule *iSchedule =myCrop[@"irrigateSchedule"];
    Schedule *fSchedule =myCrop[@"fertilizeSchedule"];
    if([schedule.objectId isEqual: fSchedule.objectId]){
        cell.actionLabel.text = @"Fertilize";
    } else if ([schedule.objectId isEqual: iSchedule.objectId]){
        cell.actionLabel.text = @"Irrigate";
    } else{
        NSLog(@"Error fetch crop action");
    }
    
    //Set crop name
    Crop *crop = myCrop[@"crop"];
    [crop fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.description);
        } else {
            NSLog(@"%@", @"Fetch crop sucessfully");
            cell.cropLabel.text = [NSString stringWithFormat: @"%@", crop[@"name"]];
        }
    }];
    

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfSchedulesOfSelectedDay.count;
}


@end
