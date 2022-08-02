//
//  ConversationViewController.m
//  Farmacy
//
//  Created by Trang Dang on 8/1/22.
//

#import "ConversationViewController.h"
#import "ConversationCell.h"
#import "Conversation.h"
#import "ChatViewController.h"
@interface ConversationViewController () <UITableViewDelegate, UITableViewDataSource, ConversationCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *conversationsTableView;
@property (strong, nonatomic) NSArray *arrayOfConversations;
@property (strong, nonatomic) PFUser *currentUser;
@end

@implementation ConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentUser = [PFUser currentUser];
    self.conversationsTableView.delegate = self;
    self.conversationsTableView.dataSource = self;
    [self reloadData];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConversationCell" forIndexPath:indexPath];
    Conversation *conversation = self.arrayOfConversations[indexPath.row];
    if ([self.currentUser.username isEqualToString:conversation.userOne.username]){
        cell.usernameLabel.text = conversation.userTwo.username;
    } else{
        cell.usernameLabel.text = conversation.userOne.username;
    }
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfConversations.count;
}

- (void)reloadData{
    // construct query
    PFQuery *queryWithUserOne = [PFQuery queryWithClassName:@"Conversation"];
    PFQuery *queryWithUserTwo = [PFQuery queryWithClassName:@"Conversation"];
    [queryWithUserOne whereKey:@"userOne" equalTo:self.currentUser];
    [queryWithUserTwo whereKey:@"userTwo" equalTo:self.currentUser];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[queryWithUserOne ,queryWithUserTwo]];
    
    [query includeKey:@"userOne"];
    [query includeKey:@"userTwo"];
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray * conversations, NSError * error) {
        if (conversations != nil) {
            self.arrayOfConversations = conversations;
        } else{
            NSLog(@"%@", error.localizedDescription);
        }
        [self.conversationsTableView reloadData];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
    Conversation *conversation = self.arrayOfConversations[indexPath.row];
    viewController.conversation = conversation;
    [self.navigationController pushViewController: viewController animated:YES];
}

@end
