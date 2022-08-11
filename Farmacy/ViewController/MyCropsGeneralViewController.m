//
//  MyCropsGeneralViewController.m
//  Farmacy
//
//  Created by Trang Dang on 8/11/22.
//

#import "MyCropsGeneralViewController.h"
#import "ConversationViewController.h"

@interface MyCropsGeneralViewController ()
@property (weak, nonatomic) IBOutlet UIView *plantingView;
@property (weak, nonatomic) IBOutlet UIView *harvestedView;
@end

@implementation MyCropsGeneralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.plantingView.alpha = 1;
    self.harvestedView.alpha = 0;
}
- (IBAction)didSwitchViews:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex== 0){
        self.plantingView.alpha = 1;
        self.harvestedView.alpha = 0;
    } else{
        self.plantingView.alpha = 0;
        self.harvestedView.alpha = 1;
    }
}
- (IBAction)didTapChat:(id)sender {
    ConversationViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ConversationViewController"];
    [self.navigationController pushViewController: viewController animated:YES];
}

@end
