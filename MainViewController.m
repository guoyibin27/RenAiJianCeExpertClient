//
//  MainViewController.m
//  RenAiJianCeExpertClient
//
//  Created by Sylar on 9/7/15.
//  Copyright (c) 2015 Gyb. All rights reserved.
//

#import "MainViewController.h"
#import "Constants.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "UserService.h"
#import "LeanChatLib.h"
#import "UserModel.h"
#import "ChattingRoomViewController.h"
#import "FSCalendar.h"
#import "ReservationModel.h"
#import "NSDate+FSExtension.h"
#import "DateTools.h"
#import "ReservationTableViewCell.h"
#import <AVOSCloudIM/AVIMTextMessage.h>

@interface MainViewController()<FSCalendarDataSource, FSCalendarDelegate,UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) UITableView *tableView;
@property (retain, nonatomic) FSCalendar *calendarView;
@property (retain, nonatomic) NSMutableArray *dataArray;
@property (retain, nonatomic) NSDateFormatter *dateFormatter;
@property (retain, nonatomic) NSMutableDictionary *cachedDataSource;
@property (retain, nonatomic) NSDateFormatter *formatter;
@property (retain, nonatomic) UIView *alertView;
@property (retain, nonatomic) UILabel *alertTitle;
@property (retain, nonatomic) NSString *conversationId;

@end

@implementation MainViewController

-(void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = Hex2UIColor(0xe6e6e6);
    self.calendarView = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) / 2)];
    self.calendarView.backgroundColor = [UIColor whiteColor];
    self.calendarView.dataSource = self;
    self.calendarView.delegate = self;
    self.calendarView.scrollDirection = FSCalendarScrollDirectionVertical;
    [self.view addSubview:self.calendarView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.calendarView.frame) + 10, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(self.calendarView.frame) - 10)];
    if([self.tableView respondsToSelector:@selector(setSeparatorInset:)]){
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if([self.tableView respondsToSelector:@selector(setLayoutMargins:)]){
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    _alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 23, CGRectGetWidth(self.view.frame), 41)];
    _alertView.backgroundColor = Hex2UIColor(0xFFCDBB);
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ExclamationIcon"]];
    imageView.frame = CGRectMake(10, 10, 20, 20);
    
    _alertTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, CGRectGetWidth(self.view.frame) - 40, 21)];
    _alertTitle.textColor = [UIColor blackColor];
    _alertTitle.font = [UIFont systemFontOfSize:15.0];
    
    [_alertView addSubview:imageView];
    [_alertView addSubview:_alertTitle];
    _alertView.hidden = YES;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forwardToChattingRoom)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [_alertView addGestureRecognizer:tapGestureRecognizer];
    
    [self.view addSubview:self.alertView];
    [self.view addSubview:self.tableView];
}

- (void)forwardToChattingRoom{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.alertView.frame;
        frame.origin.y -= 41;
        [_alertView setFrame:frame];
    } completion:^(BOOL finished) {
        _alertView.hidden = YES;
    }];
    
    AVIMConversation *conv = [[CDChatManager manager] lookupConvById:_conversationId];
    if(conv) {
        ChattingRoomViewController *chattingRoomVC = [[ChattingRoomViewController alloc] initWithConv:conv];
        [[self navigationController] pushViewController:chattingRoomVC animated:YES];
    }else{
        [[CDChatManager manager] fecthConvWithConvid:_conversationId callback:^(AVIMConversation *conversation, NSError *error) {
            if(!error){
                ChattingRoomViewController *chattingRoomVC = [[ChattingRoomViewController alloc] initWithConv:conversation];
                [[self navigationController] pushViewController:chattingRoomVC animated:YES];
            }
        }];

    }
    NSLog(@"%@",conv);
}


- (void)refreshTableViewData:(NSDate *) date {
    [self.dataArray removeAllObjects];
    NSArray *data = [self.cachedDataSource objectForKey:[_dateFormatter stringFromDate:date]];
    [self.dataArray addObjectsFromArray:data];
    [self.tableView reloadData];
}

- (void) configureTableView{
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate =self;
    _tableView.dataSource = self;
}

- (void)viewDidLayoutSubviews{
    if([self.tableView respondsToSelector:@selector(setSeparatorInset:)]){
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if([self.tableView respondsToSelector:@selector(setLayoutMargins:)]){
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self configureTableView];
    [self setTitle:@"仁爱检测"];
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    _formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    self.cachedDataSource = [[NSMutableDictionary alloc] init];
    self.dataArray = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"刷新" style:UIBarButtonItemStyleDone target:self action:@selector(refreshData)];
    [[self navigationItem] setRightBarButtonItem:rightButton];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStyleDone target:self action:@selector(logoff)];
    [[self navigationItem] setLeftBarButtonItem:leftButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didMessageReceived:) name:kCDNotificationMessageReceived object:nil];
}

-(void)didMessageReceived:(NSNotification *)note{
    if([note.object isKindOfClass:[AVIMTypedMessage class]] && self.alertView.hidden){
        _conversationId = ((AVIMConversation *)note.object).conversationId;
        self.alertTitle.text = @"你收到一条新消息,点击查看信息";
        self.alertView.hidden = NO;
        CGRect frame = self.alertView.frame;
        [UIView beginAnimations:nil context:nil];
        //设定动画持续时间
        [UIView setAnimationDuration:0.3];
        //动画的内容
        frame.origin.y += 41;
        [_alertView setFrame:frame];
        //动画结束
        [UIView commitAnimations];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCDNotificationMessageReceived object:nil];
}

-(void)refreshData
{
    [self loadDataWithStartPoint:[self firstDayOfMonth:self.calendarView.currentPage] endPoint:[self lastDayOfMonth:self.calendarView.currentPage]];
}

- (NSString *) firstDayOfMonth:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *beginDate= nil;
    double interval = 0;
    [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:date];
    return [_dateFormatter stringFromDate:[beginDate dateByAddingTimeInterval:1]];
}

- (NSString *) lastDayOfMonth:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *beginDate= nil;
    double interval = 0;
    [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:date];
    return [_dateFormatter stringFromDate:[beginDate dateByAddingTimeInterval:interval-1]];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UserModel *_currentLogonUser = [AppDelegate getCurrentLogonUser];
    if(!_currentLogonUser){
        [self forwardToLogin];
    }else{
        [CDChatManager manager].useDevPushCerticate = YES;
        NSString *clientId = [NSString stringWithFormat:@"servicer_%@",_currentLogonUser.userId];
        [[CDChatManager manager] openWithClientId:clientId callback: ^(BOOL succeeded, NSError *error) {
            if (error) {
                if(self.view.window){
                    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户账号异常，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        [view show];
                }else{
                    [AppDelegate removeUserFromNSUserDefaults];
                }
            }else{
                [self setTitle:[NSString stringWithFormat:@"仁爱检测-%@",_currentLogonUser.name]];
                [self loadDataWithStartPoint:[self firstDayOfMonth:[NSDate date]] endPoint:[self lastDayOfMonth:[NSDate date]]];
            }
        }];
    }
}

-(void)loadDataWithStartPoint:(NSString *)start endPoint:(NSString *)endPoint
{
    NSNumber *userId = [AppDelegate getCurrentLogonUser].userId;
    if(userId != nil){
        [self showProgress:nil];
        [UserService fetchReservationAgenda:userId startPoint:start endPoint:endPoint callback:^(NSMutableArray *reservations, NSError *error) {
            [self dismissProgress];
            if(error){
                [self.dataArray removeAllObjects];
                [self.tableView reloadData];
            }else{
                [self.cachedDataSource removeAllObjects];
                for(int i= 0;i< reservations.count;i++){
                    ReservationModel *arm = [reservations objectAtIndex:i];
                    NSString *start = [_dateFormatter stringFromDate:[_formatter dateFromString:arm.start]];
                    NSMutableArray *models = [self.cachedDataSource objectForKey:start];
                    if(!models){
                        models = [[NSMutableArray alloc] init];
                        [self.cachedDataSource setObject:models forKey:start];
                    }
                    [models addObject:arm];
                }
                [self refreshTableViewData:self.calendarView.selectedDate];
                [self.calendarView reloadData];
            }
        }];
    }
}

- (void)forwardToLogin
{
    LoginViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginView];
    navigationController.navigationBar.barTintColor = Hex2UIColor(0x174C80);
    navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)logoff
{
    [self showProgress:nil];
    [UserService userLogout:^(BOOL succeeded, NSError *error) {
        [self dismissProgress];
        if(error){
            [self showMessage:@"注销失败"];
        }else{
            [self forwardToLogin];
            [AppDelegate removeUserFromNSUserDefaults];
        }
    }];
}

- (void)entryChattingRoom:(ReservationModel *)model atIndex:(NSIndexPath *)indexPath
{
    UserModel *user = [AppDelegate getCurrentLogonUser];
    NSString *owner = [NSString stringWithFormat:@"servicer_%@",user.userId];
    [[CDChatManager manager] fetchConvWithOwner:owner callback:^(AVIMConversation *conversation, NSError *error) {
        if(error){
            NSString *roomName = [NSString stringWithFormat:@"专家 %@ - Room",user.name];
            [[CDChatManager manager] createConvWithOwner:owner name:roomName callback:^(AVIMConversation *conversation, NSError *error) {
                if(error){
                    [self showMessage:@"无法进入咨询室，请稍后重试"];
                }else{
                    [self pushToChattingRoomVC:conversation reservation:model];
                }
            }];
        }else{
            [[CDChatManager manager] joinConversation:conversation callback:^(BOOL succeeded, NSError *error) {
                if(!error){
                    [self pushToChattingRoomVC:conversation reservation:model];
                }else{
                    [self showMessage:@"无法进入咨询室，请稍后重试"];
                }
            }];
        }
    }];
}

-(void) pushToChattingRoomVC:(AVIMConversation *)conv reservation:(ReservationModel *)model
{
    ChattingRoomViewController *chattingRoomVC = [[ChattingRoomViewController alloc] initWithConv:conv];
    [[self navigationController] pushViewController:chattingRoomVC animated:YES];
    NSString *userId = [NSString stringWithFormat:@"user_%@",model.reserveBy];
    [AppDelegate cacheChattingUser:userId username:model.reserveBy];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setLayoutMargins:)]){
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"reservationCell";
    ReservationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell =[[ReservationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    ReservationModel *m = self.dataArray[indexPath.row];
    cell.reservationName.text = m.reservationDesc;
    cell.reserveBy.text = [NSString stringWithFormat:@"预定人 : %@",m.reserveBy];
    cell.reserveDate.text = [NSString stringWithFormat:@"咨询时间  : %@ %@ ~ %@",[([m.start componentsSeparatedByString:@" "][0]) substringFromIndex:5],m.startLabel,m.endLabel];
    if([m.reservationMethod isEqualToString:@"A"]){
        cell.reserveType.text = @"服务方式 : 手机App － 图文聊天系统";
        cell.entryRoom.image = [UIImage imageNamed:@"EntryChatRoom"];
    }else if([m.reservationMethod isEqualToString:@"P"]){
        cell.reserveType.text = [NSString stringWithFormat:@"服务方式 : 手机咨询 － 预留号码(%@)",m.reservationInfo];
        cell.entryRoom.image = [UIImage imageNamed:@"PhoneCall"];
    }else{
       cell.reserveType.text = [NSString stringWithFormat:@"服务方式 : "]; 
    }
    if([m.status isEqualToString:@"O"]){
        cell.reservationStatus.text = @"等待预约";
        cell.entryRoom.hidden = YES;
    }else if([m.status isEqualToString:@"R"]){
        cell.reservationStatus.text = @"已被预约";
        cell.entryRoom.hidden = NO;
    }else if([m.status isEqualToString:@"P"]){
        cell.reservationStatus.text = @"等待客户支付费用";
        cell.entryRoom.hidden = YES;
    }else if([m.status isEqualToString:@"C"]){
        cell.reservationStatus.text = @"已结束咨询";
        cell.entryRoom.hidden = YES;
    }
    cell.reservationStatus.text = [NSString stringWithFormat:@"预约状态 : %@",cell.reservationStatus.text];
    cell.amount.text = [NSString stringWithFormat:@"%@",m.amount];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReservationModel *m = self.dataArray[indexPath.row];
    if([m.status isEqualToString:@"R"]){
        return 185;
    }
    return 159;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ReservationModel *model = self.dataArray[indexPath.row];
    model.isShowBadge = NO;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    NSDate *startDate = [self.formatter dateFromString:model.start];
    NSDate *endDate = [self.formatter dateFromString:model.end];
    NSDate *now = [NSDate date];
    
    if([model.reservationMethod isEqualToString:@"P"]){
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",model.reservationInfo];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
        return;
    }
    
    if([model.status isEqualToString:@"O"]){
        [self showMessage:@"此时间段还未被用户预约"];
        return;
    }

    if([model.status isEqualToString:@"C"]){
        [self showMessage:@"咨询已经结束"];
        return;
    }

    if([model.status isEqualToString:@"P"]){
        [self showMessage:@"此时间段正在等待用户确认"];
        return;
    }
    
    //进入聊天室
    if([model.status isEqualToString:@"R"] && [now isEarlierThan:endDate] && [now isLaterThan:startDate]){
        [self entryChattingRoom:model atIndex:indexPath];
    }else{
        [self showMessage:@"还没到预约时间或预约时间已过"];
    }
}

#pragma FSCalendar

- (BOOL)calendar:(FSCalendar *)calendar hasEventForDate:(NSDate *)date{
    for(int i=0;i<self.cachedDataSource.allKeys.count;i++){
        if([date isEqualToDate:[_dateFormatter dateFromString:[self.cachedDataSource.allKeys objectAtIndex:i]]]){
            return YES;
        }
    }
    return NO;
}


- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date{
    [self refreshTableViewData:date];
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    [self loadDataWithStartPoint:[self firstDayOfMonth:calendar.currentPage] endPoint:[self lastDayOfMonth:calendar.currentPage]];
}
@end

