//
//  ChatViewController.m
//  Farmacy
//
//  Created by Trang Dang on 7/16/22.
//

#import "ChatViewController.h"
#import <Parse/Parse.h>
#import "ChatCell.h"
#import "ParseLiveQuery/ParseLiveQuery-Swift.h"
#import "Conversation.h"
#import "Message.h"

@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *chatMessageField;
@property (nonatomic) NSArray *arrayOfMessages;
@property (weak, nonatomic) IBOutlet UITableView *chatBoxTableView;

@property (nonatomic, strong) PFLiveQueryClient *liveQueryClient;
@property (nonatomic, strong) PFQuery *messageQuery;
@property (nonatomic, strong) PFLiveQuerySubscription *subscription;


@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchMessages];
    self.chatBoxTableView.delegate = self;
    self.chatBoxTableView.dataSource = self;
    
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    self.liveQueryClient = [[PFLiveQueryClient alloc] initWithServer:@"wss://farmacy.b4a.io" applicationId:[dict objectForKey: @"parse_app_id"] clientKey:[dict objectForKey:@"parse_client_key"]];
    
    self.messageQuery = [PFQuery queryWithClassName:@"Message"];
    [self.messageQuery whereKey:@"conversation" equalTo:self.conversation];
    [self.messageQuery includeKey:@"conversation"];
    
    self.subscription = [self.liveQueryClient subscribeToQuery:self.messageQuery];
    __weak typeof(self) weakSelf = self;
    [self.subscription addCreateHandler:^(PFQuery<PFObject *> *query, PFObject * object) {
        [weakSelf fetchMessages];
        return;
    }];

}

- (IBAction)didTapSend:(id)sender {
    Message *message = [Message new];
    message.text = self.chatMessageField.text;
    message.sender = [PFUser currentUser];
    message.conversation = self.conversation;
    [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (succeeded) {
            NSLog(@"The message was saved!");
            self.chatMessageField.text = @"";
            [self fetchMessages];
        } else {
            NSLog(@"Problem saving message: %@", error.localizedDescription);
        }
    }];
    

}

- (void) fetchMessages{
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    [query whereKey:@"conversation" equalTo:self.conversation];
    [query includeKey:@"sender"];
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
    Message *message = self.arrayOfMessages[indexPath.row];
    NSString *text = message.text;
    PFUser *sender = message.sender;
    cell.messageLabel.text = text;
    cell.usernameLabel.text = sender.username;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfMessages.count;
}



@end
