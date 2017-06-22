//
//  MainViewController.m
//  HomeKitDemo
//
//  Created by 刘春奇 on 2017/5/24.
//  Copyright © 2017年 com.hc-nsqk.hc. All rights reserved.
//

#import "MainViewController.h"
#import "RoomConfigController.h"


@interface MainViewController ()<HMHomeManagerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation MainViewController{
    //homes dataList
    NSArray *_homesList;
    //rooms datalist
    NSArray *_roomsList;
    //current home
    HMHome *_currentHome;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //init home manager
    self.homeManager = [[HMHomeManager alloc]init];
    self.homeManager.delegate = self;
    
    
    //创建长按手势监听
    UILongPressGestureRecognizer *homeLongPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(homesLongPress:)];
    homeLongPress.minimumPressDuration = 1.0;
    [self.homeCollectionView addGestureRecognizer:homeLongPress];
    
    UILongPressGestureRecognizer *roomLongPress = [[UILongPressGestureRecognizer alloc]
                                                   initWithTarget:self
                                                   action:@selector(roomLongPress:)];
    roomLongPress.minimumPressDuration = 1.0;
    [self.roomCollectionView addGestureRecognizer:roomLongPress];
    
    
}
- (IBAction)addHomeAction:(id)sender {
    TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"TYAlertView" message:@"This is a message, the alert view containt text and textfiled. "];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
        NSLog(@"%@",action.title);
    }]];
    
    // 弱引用alertView 否则 会循环引用
    __typeof (alertView) __weak weakAlertView = alertView;
    [alertView addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
        UITextField *textfield = weakAlertView.textFieldArray.firstObject;
        [self addHome:textfield.text];
    }]];
    
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"请输入添加房子名称";
    }];
    
    // first way to show
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (IBAction)addRoomAction:(id)sender {
    TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"TYAlertView" message:@"This is a message, the alert view containt text and textfiled. "];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
        NSLog(@"%@",action.title);
    }]];
    
    // 弱引用alertView 否则 会循环引用
    __typeof (alertView) __weak weakAlertView = alertView;
    [alertView addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
        UITextField *textfield = weakAlertView.textFieldArray.firstObject;
        [self addRoom:_currentHome roomName:textfield.text];
    }]];

    
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"请输入添加房间名称";
    }];
    
    // first way to show
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)homesLongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    CGPoint pointTouch = [gestureRecognizer locationInView:self.homeCollectionView];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        NSIndexPath *indexPath = [self.homeCollectionView indexPathForItemAtPoint:pointTouch];
        if (indexPath != nil) {
            NSLog(@"点击%ld",(long)indexPath.row);
            TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"提示" message:@"删除home"];
            
            [alertView addAction:[TYAlertAction actionWithTitle:@"重命名" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
                TYAlertView *alertView2 = [TYAlertView alertViewWithTitle:@"提示" message:@"重命名Home"];
                [alertView2 addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                    textField.placeholder = @"输入更改的Home名称";
                }];
                __typeof (alertView) __weak weakAlertView2 = alertView2;
                [alertView2 addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
                    UITextField *textfield = weakAlertView2.textFieldArray.firstObject;
                    HMHome *home = _homesList[indexPath.row];
                    //rename
                    [self updateHomeName:textfield.text home:home];
                }]];
                TYAlertController *alertController2 = [TYAlertController alertControllerWithAlertView:alertView2 preferredStyle:TYAlertControllerStyleAlert];
                [self presentViewController:alertController2 animated:YES completion:nil];
            }]];

            
            [alertView addAction:[TYAlertAction actionWithTitle:@"删除" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
                HMHome *home = _homesList[indexPath.row];
                [self removeHome:home];
            }]];
            [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
                NSLog(@"%@",action.title);
            }]];
            
            TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleActionSheet];
            [self presentViewController:alertController animated:YES completion:nil];

        }
    }
    
}
- (void)roomLongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    CGPoint pointTouch = [gestureRecognizer locationInView:self.roomCollectionView];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        NSIndexPath *indexPath = [self.roomCollectionView indexPathForItemAtPoint:pointTouch];
        if (indexPath != nil) {
            NSLog(@"点击%ld",(long)indexPath.row);
            TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"提示" message:@"删除room"];
            [alertView addAction:[TYAlertAction actionWithTitle:@"重命名" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
                TYAlertView *alertView2 = [TYAlertView alertViewWithTitle:@"提示" message:@"重命名room"];
                [alertView2 addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                    textField.placeholder = @"输入更改的room名称";
                }];
                
                
                
                __typeof (alertView) __weak weakAlertView2 = alertView2;
                [alertView2 addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
                    UITextField *textfield = weakAlertView2.textFieldArray.firstObject;
                    HMRoom *room = _roomsList[indexPath.row];
                    //rename
                    [self updateRoomName:textfield.text room:room];
                }]];
                TYAlertController *alertController2 = [TYAlertController alertControllerWithAlertView:alertView2 preferredStyle:TYAlertControllerStyleAlert];
                [self presentViewController:alertController2 animated:YES completion:nil];
                
            }]];

            
            __weak MainViewController *weakself = self;
            [alertView addAction:[TYAlertAction actionWithTitle:@"删除" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
                HMRoom *room = _roomsList[indexPath.row];
                [weakself removeRoom:_currentHome room:room];
            }]];
            [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
                NSLog(@"%@",action.title);
            }]];
            
            TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleActionSheet];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
    }
}

#pragma mark - HMHomeManagerDelegate
//修改房间回调
- (void)homeManagerDidUpdateHomes:(HMHomeManager *)manager{
    
    [self refreshData];
    NSLog(@"%@",manager.homes);
}

//主要房间修改回调
- (void)homeManagerDidUpdatePrimaryHome:(HMHomeManager *)manager{
    NSLog(@"primary房间修改");
}

#pragma mark - end


#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([collectionView isKindOfClass:[HomesCollectionView class]]) {
        return _homesList.count;
    }else{
        return _roomsList.count;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isKindOfClass:[HomesCollectionView class]]) {
        HomesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomesCollectionViewCell" forIndexPath:indexPath];
        HMHome *home = _homesList[indexPath.row];
        cell.homeName.text = home.name;
        return cell;
    }else{
        HMRoom *room = _roomsList[indexPath.row];
        RoomsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RoomsCollectionViewCell" forIndexPath:indexPath];
        cell.roomName.text = room.name;
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isKindOfClass:[HomesCollectionView class]]) {
        HMHome *home = _homesList[indexPath.row];
        _roomsList = home.rooms;
        self.currentHomeLabel.text = [NSString stringWithFormat:@"%@ 的所有房间",home.name];
        _currentHome = home;
        [self.roomCollectionView reloadData];
    }else{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        RoomConfigController *roomConfigVc = [sb instantiateViewControllerWithIdentifier:@"RoomConfigController"];
        HMRoom *room = _roomsList[indexPath.row];
        roomConfigVc.myRoom = room;
        roomConfigVc.myHome = _currentHome;
        [self.navigationController pushViewController:roomConfigVc animated:YES];
    }
}






#pragma mark - end

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)refreshData{
    _homesList = self.homeManager.homes;
    _roomsList = self.homeManager.homes.firstObject.rooms;
    _currentHome = self.homeManager.primaryHome;
    self.currentHomeLabel.text = _currentHome.name;
    [self.homeCollectionView reloadData];
    [self.roomCollectionView reloadData];
}



- (void)refreshRoom:(HMHome *)home{
    _roomsList = home.rooms;
    [self.roomCollectionView reloadData];

}

- (void)addHome:(NSString *)homeName{
    
    __weak MainViewController *weakSelf = self;
    [self showHUD];
    [self.homeManager addHomeWithName:homeName completionHandler:^(HMHome * _Nullable home, NSError * _Nullable error) {
        if (error) {
            NSLog(@"添加home失败error is%@",error);
            [weakSelf HUDDissmiss];

        }else{
            NSLog(@"添加%@房间成功",home.name);
            [weakSelf refreshData];
            [weakSelf HUDDissmiss];
        }
    }];
}

- (void)removeHome:(HMHome *)home{
    __weak MainViewController *weakSelf = self;
    [self showHUD];
    [self.homeManager removeHome:home completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"删除home失败error is%@",error);
            [weakSelf HUDDissmiss];

        }else{
            NSLog(@"删除%@房间成功",home.name);
            [weakSelf refreshData];
            [weakSelf HUDDissmiss];
        }
    }];
}

- (void)addRoom:(HMHome *)home roomName:(NSString *)name{
    __weak MainViewController *weakSelf = self;
    __weak HMHome *weakHome = home;
    [self showHUD];
    [home addRoomWithName:name completionHandler:^(HMRoom * _Nullable room, NSError * _Nullable error) {
        if (error) {
            NSLog(@"添加room失败 error is %@",error);
            [weakSelf HUDDissmiss];

        }else{
            NSLog(@"添加room%@成功",room.name);
            [weakSelf refreshRoom:weakHome];
            [weakSelf HUDDissmiss];
        }
    }];
}

- (void)removeRoom:(HMHome *)home room:(HMRoom *)room{
    __weak MainViewController *weakSelf = self;
    __weak HMHome *weakHome = home;
    [self showHUD];
    [home removeRoom:room completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"删除room失败 error is %@",error);
            [weakSelf HUDDissmiss];

        }else{
            NSLog(@"删除room%@成功",room.name);
            [weakSelf refreshRoom:weakHome];
            [weakSelf HUDDissmiss];
        }
    }];
}

- (void)updateRoomName:(NSString *)name room:(HMRoom *)room{
    [self showHUD];
    __weak MainViewController *weakSelf = self;
    [room updateName:name completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"room 重命名error is %@",error);
            [weakSelf HUDDissmiss];
        }else{
            NSLog(@"room 重命名成功");
            [weakSelf refreshRoom:_currentHome];
            [weakSelf HUDDissmiss];
        }
    }];

}

- (void)updateHomeName:(NSString *)name home:(HMHome *)home{
    [self showHUD];
    __weak MainViewController *weakSelf = self;
    [home updateName:name completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"home 重命名error is %@",error);
            [weakSelf HUDDissmiss];
        }else{
            NSLog(@"home 重命名成功");
            [weakSelf refreshData];
            [weakSelf HUDDissmiss];
        }
    }];
}

- (void)showHUD{
    [SVProgressHUD show];
}

- (void)HUDDissmiss{
    [SVProgressHUD dismiss];
}

@end
