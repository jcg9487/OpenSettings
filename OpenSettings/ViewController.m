//
//  ViewController.m
//  OpenSettings
//
//  Created by MacEdward on 16/7/5.
//  Copyright © 2016年 MacEdward. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation ViewController

#pragma mark - Life Cycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    [self configDataSource];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Config -
- (void)configUI {
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor greenColor]];
    self.title = @"Open Settings";
}

- (id)readLocalFileWithfileName:(NSString *)fileName andFileType:(NSString *)type{
    
    id jObject = nil;
    
    @try {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
        NSData *jdata = [[NSData alloc] initWithContentsOfFile:filePath];
        jObject = [NSJSONSerialization JSONObjectWithData:jdata options:NSJSONReadingMutableContainers error:nil];
        
    } @catch (NSException *exception) {
        
        NSLog(@"Open local json file error: %@", exception.description);
        
    } @finally {
        
        NSLog(@"Open local json file: %@", fileName);
    }
    
    return jObject;
}

- (void)configDataSource {
    
    id jsObject = [self readLocalFileWithfileName:@"Settings" andFileType:@"json"];
    
    NSArray *dataArray = jsObject[@"Settings"];
    
    self.dataSource = [[NSMutableArray alloc] init];
    [self.dataSource addObjectsFromArray:dataArray];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
}


#pragma mark - TableView DataSousrce -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSDictionary *dataDict = self.dataSource[indexPath.row];
    NSString *key = [dataDict allKeys].lastObject;
    cell.textLabel.text = key;
    
    return cell;
}

#pragma mark - TableView Delegate -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    static NSString *kPrefsRoot = @"prefs:root=";
    
    NSDictionary *dataDict = self.dataSource[indexPath.row];
    NSString *key = [dataDict allKeys].lastObject;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kPrefsRoot,dataDict[key]];
    NSURL * url      = [NSURL URLWithString:urlStr];
    
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
        
    }
    
}


@end
