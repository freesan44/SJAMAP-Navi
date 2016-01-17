//
//  ViewController.m
//  UI补充02 高德地图开发
//
//  Created by 曾思健 on 16/1/17.
//  Copyright © 2016年 曾思健. All rights reserved.
//

#import "ViewController.h"
#import <AMapNaviKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
@interface ViewController ()<MAMapViewDelegate,AMapSearchDelegate,AMapNaviManagerDelegate,AMapNaviViewControllerDelegate>
@property (nonatomic,strong)MAMapView* mapView;
@property (nonatomic,strong)AMapSearchAPI* searchAPI;
@property (nonatomic,strong)AMapNaviManager* naviManager;
@property (nonatomic,strong)AMapGeoPoint* endPoint;
@property (nonatomic,strong)AMapNaviViewController* naviViewController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MAMapServices sharedServices].apiKey = @"6141d1d4537fefbbdbfafd141199ea48";
    [AMapSearchServices sharedServices].apiKey=@"6141d1d4537fefbbdbfafd141199ea48";
    [AMapNaviServices sharedServices].apiKey=@"6141d1d4537fefbbdbfafd141199ea48";
//    self.mapView.bounds=self.view.bounds;
    [self.view addSubview:self.mapView];
//    self.mapView.bounds=self.view.bounds;
//    self.mapVi
    [self.mapView setShowsUserLocation:YES];
    //代理
//    self.mapView.userLocation 
    self.mapView.delegate=self;
    self.searchAPI.delegate=self;
    self.naviManager.delegate=self;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.mapView.delegate=nil;
}

-(void)naviManagerOnCalculateRouteSuccess:(AMapNaviManager *)naviManager
{
    [self.naviManager presentNaviViewController:self.naviViewController animated:YES];
    [self.naviManager startEmulatorNavi];
}

//导航
- (IBAction)daohan:(id)sender
{
    
}

//规划
- (IBAction)guihua:(id)sender
{
    NSLog(@"%f--%f",self.endPoint.longitude,self.endPoint.latitude);
    AMapNaviPoint* endPoint=[AMapNaviPoint locationWithLatitude:self.endPoint.latitude longitude:self.endPoint.longitude];
    AMapNaviDrivingStrategy strategy=AMapNaviDrivingStrategyDefault;
    NSLog(@"%d",[self.naviManager calculateDriveRouteWithEndPoints:@[endPoint] wayPoints:nil drivingStrategy:strategy]);
}

//poi搜索
- (IBAction)poiSearch:(id)sender
{
//    AMapSearchObject* search=[[AMapSearchObject alloc]init];
    AMapPOIKeywordsSearchRequest * request=[[AMapPOIKeywordsSearchRequest alloc]init];
    request.keywords=@"洗浴|保健|按摩";
    request.city=@"广州";
    [self.searchAPI AMapPOIKeywordsSearch:request];
}
-(void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSLog(@"名称：%@ 地址：%@",obj.name,obj.address);
    }];
    AMapPOI* obj=response.pois.lastObject;
    AMapGeoPoint*point=obj.location;
    self.endPoint=point;
    NSLog(@"%f--%f",point.latitude,point.longitude);
    
}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    CLLocation*location=userLocation.location;
    CLLocationCoordinate2D zuobiao=location.coordinate;

}
-(MAMapView *)mapView
{
    if (_mapView==nil)
    {
        _mapView=[[MAMapView alloc]initWithFrame:CGRectMake(0, 0, 330, 700)];
        _mapView.userTrackingMode=MAUserTrackingModeFollow;
    }
    return _mapView;
}
-(AMapSearchAPI *)searchAPI
{
    if (_searchAPI==nil)
    {
        _searchAPI=[[AMapSearchAPI alloc]init];
    }
    return _searchAPI;
}
-(AMapNaviManager *)naviManager
{
    if (_naviManager==nil)
    {
        _naviManager=[[AMapNaviManager alloc]init];
        
    }
    return _naviManager;
}
-(AMapGeoPoint *)endPoint
{
    if (_endPoint==nil)
    {
        _endPoint=[[AMapGeoPoint alloc]init];
        
    }
    return _endPoint;
}
-(AMapNaviViewController *)naviViewController
{
    if (_naviViewController==nil)
    {
        _naviViewController=[[AMapNaviViewController alloc]initWithDelegate:self];
    }
    return _naviViewController;
}
@end
