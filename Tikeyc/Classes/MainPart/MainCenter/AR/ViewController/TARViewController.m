//
//  TARViewController.m
//  Tikeyc
//
//  Created by ways on 2017/9/26.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import "TARViewController.h"

#import <ARKit/ARKit.h>
#import <CoreML/CoreML.h>
#import <SceneKit/SceneKit.h>//3D引擎

#import "TSelectListValueView.h"

@interface TARViewController ()<ARSCNViewDelegate, ARSessionDelegate>

//AR视图：展示3D界面
@property (nonatomic, strong)ARSCNView *arSCNView;
//AR会话，负责管理相机追踪配置及3D相机坐标
@property (nonatomic, strong)ARSession *arSession;
//会话追踪配置：负责追踪相机的运动
@property (nonatomic, strong)ARConfiguration *arConfiguration;
//飞机3D模型
@property (nonatomic, strong)SCNNode *node;
//当前显示的Node
@property (nonatomic, strong)SCNNode *currentShipNode;

@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UIButton *filterListButton;
@property (strong, nonatomic) IBOutlet UIButton *rotationButton;
- (IBAction)colseButtonAction:(UIButton *)sender;
- (IBAction)filterListButtonAction:(UIButton *)sender;
- (IBAction)rotationButtonAction:(UIButton *)sender;


@property (nonatomic, strong) TSelectListValueView *selectListValueView;

@end

@implementation TARViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self runAR];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



#pragma mark - init


- (TSelectListValueView *)selectListValueView {
    if (!_selectListValueView) {
        _selectListValueView = [[TSelectListValueView alloc] initWithFrame:CGRectMake(0, 0, 200, 0)];
        [self.view addSubview:_selectListValueView];
        NSArray *valueList =@[@"candle/candle.scn",
                              @"chair/chair.scn",
                              @"cup/cup.scn",
                              @"lamp/lamp.scn",
                              @"ship.scn",
                              @"vase/vase.scn"
                              ];
        [_selectListValueView selectListValueViewIsShow:NO withListValue:valueList];
        @weakify(self)
        _selectListValueView.selectedValueBlock = ^(NSString *value) {
            @strongify(self)
            [self showNodeWithModelName:value];
        };
    }
    return _selectListValueView;
}

/**
 创建AR视图

 @return ARSCNView
 */
- (ARSCNView *)arSCNView {
    if (!_arSCNView) {
        _arSCNView = [[ARSCNView alloc]  initWithFrame:self.view.bounds];
        _arSession.delegate = self;
        _arSCNView.session = self.arSession;
        //自动刷新灯光（3D游戏用到，此处可忽略）
        _arSCNView.automaticallyUpdatesLighting = YES;
    }
    return _arSCNView;
}


/**
 拍摄会话

 @return ARSession
 */
- (ARSession *)arSession {
    if (!_arSession) {
        _arSession = [[ARSession alloc] init];
        _arSession.delegate = self;
    }
    return _arSession;
}


/**
 会话追踪配置

 @return ARWorldTrackingConfiguration 、AROrientationTrackingConfiguration 、ARFaceTrackingConfiguration ：ARConfiguration
 */
- (ARConfiguration *)arConfiguration {
    if (!_arConfiguration) {
        //1.创建世界追踪会话配置（使用ARWorldTrackingSessionConfiguration效果更加好），需要A9芯片支持
        ARWorldTrackingConfiguration *arConfiguration = [[ARWorldTrackingConfiguration alloc] init];
        //2.设置追踪方向（追踪平面，后面会用到）
        arConfiguration.planeDetection = ARPlaneDetectionHorizontal;
        //3.自适应灯光（相机从暗到强光快速过渡效果会平缓一些）
        arConfiguration.lightEstimationEnabled = YES;
        //
        _arConfiguration = arConfiguration;
    }
    return _arConfiguration;
}


#pragma mark - ARSCNViewDelegate



//添加节点时候调用（当开启平地捕捉模式之后，如果捕捉到平地，ARKit会自动添加一个平地节点）
- (void)renderer:(id <SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    
    if ([anchor isMemberOfClass:[ARPlaneAnchor class]]) {
        NSLog(@"捕捉到平地");
        
        //添加一个3D平面模型，ARKit只有捕捉能力，锚点只是一个空间位置，要想更加清楚看到这个空间，我们需要给空间添加一个平地的3D模型来渲染他
        
        //1.获取捕捉到的平地锚点
        ARPlaneAnchor *planeAnchor = (ARPlaneAnchor *)anchor;
        //2.创建一个3D物体模型    （系统捕捉到的平地是一个不规则大小的长方形，这里笔者将其变成一个长方形，并且是否对平地做了一个缩放效果）
        //参数分别是长宽高和圆角
        SCNBox *plane = [SCNBox boxWithWidth:planeAnchor.extent.x*0.3 height:0 length:planeAnchor.extent.x*0.3 chamferRadius:0];
        //3.使用Material渲染3D模型（默认模型是白色的，这里笔者改成红色）
        plane.firstMaterial.diffuse.contents = [UIColor redColor];
        
        //4.创建一个基于3D物体模型的节点
        SCNNode *planeNode = [SCNNode nodeWithGeometry:plane];
        //5.设置节点的位置为捕捉到的平地的锚点的中心位置  SceneKit框架中节点的位置position是一个基于3D坐标系的矢量坐标SCNVector3Make
        planeNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z);
        
        //self.planeNode = planeNode;
        [node addChildNode:planeNode];
    }
}

//刷新时调用
- (void)renderer:(id <SCNSceneRenderer>)renderer willUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    NSLog(@"刷新中");
}

//更新节点时调用
- (void)renderer:(id <SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    NSLog(@"节点更新");
    
}

//移除节点时调用
- (void)renderer:(id <SCNSceneRenderer>)renderer didRemoveNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    NSLog(@"节点移除");
}

#pragma mark -ARSessionDelegate

//会话位置更新（监听相机的移动），此代理方法会调用非常频繁，只要相机移动就会调用，如果相机移动过快，会有一定的误差，具体的需要强大的算法去优化，笔者这里就不深入了
- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame
{
//    NSLog(@"相机移动");//调用次数太多了！
    if (self.node) {
        
        //捕捉相机的位置，让节点随着相机移动而移动
        //根据官方文档记录，相机的位置参数在4X4矩阵的第三列
        float x = frame.camera.transform.columns[3].x;
        float y = frame.camera.transform.columns[3].y;
        float z = frame.camera.transform.columns[3].z;
//        self.node.position = SCNVector3Make(x,y,z);
    }
    
}
- (void)session:(ARSession *)session didAddAnchors:(NSArray<ARAnchor*>*)anchors
{
    NSLog(@"添加锚点");
    
}


- (void)session:(ARSession *)session didUpdateAnchors:(NSArray<ARAnchor*>*)anchors
{
    NSLog(@"刷新锚点");
    
}


- (void)session:(ARSession *)session didRemoveAnchors:(NSArray<ARAnchor*>*)anchors
{
    NSLog(@"移除锚点");
    
}



#pragma mark - ARSessionObserver

/**
 This is called when a session fails.
 
 @discussion On failure the session will be paused.
 @param session The session that failed.
 @param error The error being reported (see ARError.h).
 */
- (void)session:(ARSession *)session didFailWithError:(NSError *)error {
    NSLog(@"%@",error.userInfo[NSLocalizedFailureReasonErrorKey]);//所提供的配置在此设备上不受支持
    
    [TAlertView showWithTitle:nil message:error.userInfo[NSLocalizedFailureReasonErrorKey] cancelButtonTitle:@"确定" otherButtonTitles:nil type:UIAlertControllerStyleAlert andParentView:self.view andAction:^(NSInteger buttonIndex) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }];
}

#pragma mark - Actions

- (void)runAR {
    
    Class ARSCNView_Class = NSClassFromString(@"ARSCNView");
    if (!ARSCNView_Class) {
        return;
    }
    
    [self.view addSubview:self.arSCNView];
    [self.view bringSubviewToFront:self.closeButton];
    [self.view bringSubviewToFront:self.filterListButton];
    [self.view bringSubviewToFront:self.rotationButton];
    
    [self.arSession runWithConfiguration:self.arConfiguration];
    
    [self showNodeWithModelName:@"ship.scn"];
}

/**
 添加模型

 @param modelName chair.scn
 */
- (void)showNodeWithModelName:(NSString *)modelName {
    //1.使用场景加载scn文件（scn格式文件是一个基于3D建模的文件，使用3DMax软件可以创建，这里系统有一个默认的3D飞机）--------在右侧我添加了许多3D模型，只需要替换文件名即可
    SCNScene *scene = [SCNScene sceneNamed:[@"Models.scnassets/" stringByAppendingString:modelName]];
    //2.获取飞机节点（一个场景会有多个节点，此处我们只写，飞机节点则默认是场景子节点的第一个）
    //所有的场景有且只有一个根节点，其他所有节点都是根节点的子节点
    SCNNode *shipNode = scene.rootNode.childNodes[0];
    self.node = shipNode;
    //椅子比较大，可以可以调整Z轴的位置让它离摄像头远一点，，然后再往下一点（椅子太高我们坐不上去）就可以看得全局一点
    shipNode.position = SCNVector3Make(0, -1, -1);//x/y/z/坐标相对于世界原点，也就是相机位置
    
    //3.将飞机节点添加到当前屏幕中
    if (_currentShipNode) {
        [_currentShipNode removeFromParentNode];
    }
    [self.arSCNView.scene.rootNode addChildNode:shipNode];
    _currentShipNode = shipNode;
    
}


/**
 物体围绕相机旋转

 @param modelName ship.scn
 */
- (void)showRotationNodelWithModelName:(NSString *)modelName {
    if (modelName) {
        //1.使用场景加载scn文件（scn格式文件是一个基于3D建模的文件，使用3DMax软件可以创建，这里系统有一个默认的3D飞机）--------在右侧我添加了许多3D模型，只需要替换文件名即可
        SCNScene *scene = [SCNScene sceneNamed:[@"Models.scnassets/" stringByAppendingString:modelName]];
        //2.获取飞机节点（一个场景会有多个节点，此处我们只写，飞机节点则默认是场景子节点的第一个）
        //所有的场景有且只有一个根节点，其他所有节点都是根节点的子节点
        SCNNode *shipNode = scene.rootNode.childNodes[0];
        self.node = shipNode;
        //椅子比较大，可以可以调整Z轴的位置让它离摄像头远一点，，然后再往下一点（椅子太高我们坐不上去）就可以看得全局一点
        shipNode.position = SCNVector3Make(0, -1, -1);//x/y/z/坐标相对于世界原点，也就是相机位置
        
        //3.将飞机节点添加到当前屏幕中
        if (_currentShipNode) {
            [_currentShipNode removeFromParentNode];
        }
        //    [self.arSCNView.scene.rootNode addChildNode:shipNode];
        _currentShipNode = shipNode;
    }
    
    //3.绕相机旋转
    //绕相机旋转的关键点在于：在相机的位置创建一个空节点，然后将台灯添加到这个空节点，最后让这个空节点自身旋转，就可以实现台灯围绕相机旋转
    //1.为什么要在相机的位置创建一个空节点呢？因为你不可能让相机也旋转
    //2.为什么不直接让台灯旋转呢？ 这样的话只能实现台灯的自转，而不能实现公转
    SCNNode *node1 = [[SCNNode alloc] init];
    
    //空节点位置与相机节点位置一致
    node1.position = self.arSCNView.scene.rootNode.position;
    
    //将空节点添加到相机的根节点
    [self.arSCNView.scene.rootNode addChildNode:node1];
    
    
    // !!!将台灯节点作为空节点的子节点，如果不这样，那么你将看到的是台灯自己在转，而不是围着你转
    [node1 addChildNode:self.node];
    
    
    //旋转核心动画
    CABasicAnimation *moonRotationAnimation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    
    //旋转周期
    moonRotationAnimation.duration = 30;
    
    //围绕Y轴旋转360度  （不明白ARKit坐标系的可以看笔者之前的文章）
    moonRotationAnimation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI * 2)];
    //无限旋转  重复次数为无穷大
    moonRotationAnimation.repeatCount = FLT_MAX;
    
    //开始旋转  ！！！：切记这里是让空节点旋转，而不是台灯节点。  理由同上
    [node1 addAnimation:moonRotationAnimation forKey:@"moon rotation around earth"];
}

- (IBAction)filterListButtonAction:(UIButton *)sender {
    
    [self.selectListValueView selectListValueViewIsShow:self.selectListValueView.hidden withListValue:nil];
    
}

- (IBAction)rotationButtonAction:(UIButton *)sender {
    
    Class ARSCNView_Class = NSClassFromString(@"ARSCNView");
    if (!ARSCNView_Class) {
        return;
    }
    
    [self showRotationNodelWithModelName:nil];//@"ship.scn"
}

- (IBAction)colseButtonAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end












