//
//  TLanguageTableViewController.m
//  Tikeyc
//
//  Created by ways on 2017/2/5.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import "TLanguageTableViewController.h"


static NSString *key_AppleLanguages = @"appLanguage";

#define AppLanguage @"appLanguage"
#define CustomLocalizedString(key, comment) \
[[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]] ofType:@"lproj"]] localizedStringForKey:(key) value:@"" table:@"Localizable"]


@interface TLanguageTableViewController ()

@property (nonatomic,strong)NSArray *languageNames;


@end

@implementation TLanguageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *appLanguage = [TUserDefaults objectForKey:key_AppleLanguages];
    NSLog(@"appLanguage:%@",appLanguage);
    

    self.title = CustomLocalizedString(@"languageVC_title", "未设置");
    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    NSLog ( @"%@" , currentLanguage);
    /*
     zh-Hans-CN,
     en-CN
     */
    _languageNames = @[@"en",@"zh-Hans",@"zh-Hant"];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

/**/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"languageCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSString *language = _languageNames[indexPath.row];
    
    NSString *currentLanguage = [TUserDefaults objectForKey:key_AppleLanguages];
    if ([currentLanguage isEqualToString:language]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = language;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/**/
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *selectedLanguage = _languageNames[indexPath.row];
    NSLog(@"%@",selectedLanguage);
    
    [TUserDefaults setObject:selectedLanguage forKey:@"appLanguage"];
    
    [TUserDefaults synchronize];
    
    [tableView reloadData];
    
    self.title = CustomLocalizedString(@"languageVC_title", "未设置");
    
    [TNotificationCenter postNotificationName:@"通知其他界面刷新UI，暂未设置" object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
