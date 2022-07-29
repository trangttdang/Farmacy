//
//  ChatViewController.m
//  Farmacy
//
//  Created by Trang Dang on 7/16/22.
//

#import "ChatViewController.h"
#import <Parse/Parse.h>
#import "ChatCell.h"

@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *chatMessageField;
@property (nonatomic) NSArray *arrayOfMessages;
@property (weak, nonatomic) IBOutlet UITableView *chatBoxTableView;




@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchMessages];
    self.chatBoxTableView.delegate = self;
    self.chatBoxTableView.dataSource = self;
}

- (IBAction)didTapSend:(id)sender {
    PFObject *chatMessage = [PFObject objectWithClassName:@"Message"];
    NSString *text = self.chatMessageField.text;
    chatMessage[@"text"] = text;
    chatMessage[@"User"] = [PFUser currentUser];
    [chatMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (succeeded) {
            NSLog(@"The message was saved!");
            self.chatMessageField.text = @"";
            [self fetchMessages];
        } else {
            NSLog(@"Problem saving message: %@", error.localizedDescription);
        }
    }];
    
    if ([text isEqual: @"weather today"]){
        
    }

}

- (void) fetchMessages{
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    [query includeKey:@"User"];
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *messages, NSError *error) {
        if (messages != nil) {
            self.arrayOfMessages = messages;
            [self.chatBoxTableView reloadData];
        } else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell" forIndexPath:indexPath];
    NSString *message = self.arrayOfMessages[indexPath.row][@"text"];
    PFUser *sender = self.arrayOfMessages[indexPath.row][@"User"];
    cell.messageLabel.text = message;
    cell.usernameLabel.text = sender.username;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfMessages.count;
}


@end
