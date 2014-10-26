//
//  ViewController.m
//  Blong
//
//  Created by Lisa Accardi on 10/20/14.
//  Copyright (c) 2014 BLOC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UICollisionBehaviorDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *bluePaddleView;
@property (weak, nonatomic) IBOutlet UIView *redPaddleView;
@property (weak, nonatomic) IBOutlet UIView *ballView;
@property (weak, nonatomic) IBOutlet UIImageView *soccerBallImageView;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIPushBehavior *pusher;
@property (strong, nonatomic) UICollisionBehavior *collision;
@property (strong, nonatomic) UIDynamicItemBehavior *ballDynamicProperties;
@property (strong, nonatomic) UIDynamicItemBehavior *paddleDynamicProperties;
@property (strong, nonatomic) UIDynamicItemBehavior *wallDynamicProperties;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;
@property (strong, nonatomic) UIPanGestureRecognizer *bluePanGesture;

@property (strong, nonatomic) UIBezierPath *blueGoal;
@property (strong, nonatomic) UIBezierPath *redGoal;


@property (weak, nonatomic) IBOutlet UILabel *redScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *blueScoreLabel;

@property (weak, nonatomic) id <UICollisionBehaviorDelegate> delegate;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.ballView addSubview:self.soccerBallImageView];
    self.pusher = [[UIPushBehavior alloc] initWithItems:@[self.ballView]
                                                   mode:UIPushBehaviorModeInstantaneous];

//    int a = (rand() % (high - low) + low);
//    int b = (rand() % (high - low) + low);
    
    self.pusher.pushDirection = CGVectorMake(.2, -.2);
    self.pusher.active = YES;
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    

    
    [self.animator addBehavior:self.pusher];
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePaddle:)];
    self.panGesture.delegate = self;
    self.bluePanGesture.delegate = self;
    self.bluePanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveBluePaddle:)];
    [self.bluePaddleView addGestureRecognizer:self.bluePanGesture];
    [self.redPaddleView addGestureRecognizer:self.panGesture];
    UIColor *fillColor = [UIColor whiteColor];
    [fillColor setFill];
    UIColor *strokeColor = [UIColor whiteColor];
    [strokeColor setStroke];
    self.redGoal = [[UIBezierPath alloc] init];
    [self.redGoal moveToPoint:CGPointMake(227,34.25)];
    
    [self.redGoal closePath];
    self.redGoal.lineWidth = 2;
    [self.redGoal fill];
    [self.redGoal stroke];
    
    UITouch *touch = [[UITouch alloc] init];
   
    CGPoint currentPoint = [touch locationInView:self.view];
    NSLog(@"%f, %f", currentPoint.x, currentPoint.y);
    
    
//    self.collision = [[UICollisionBehavior alloc] initWithItems:@[self.ballView, self.redPaddleView, self.bluePaddleView, self.topView, self.bottomView]];
//    self.collision.collisionDelegate = self;
//    self.collision.collisionMode = UICollisionBehaviorModeItems;
//    self.collision.translatesReferenceBoundsIntoBoundary = YES;
//    
//    
//    [self.animator addBehavior:self.collision];
//    // Remove rotation
//    self.ballDynamicProperties = [[UIDynamicItemBehavior alloc] initWithItems:@[self.ballView]];
//    self.ballDynamicProperties.allowsRotation = NO;
//    [self.animator addBehavior:self.ballDynamicProperties];
//    
//    self.paddleDynamicProperties = [[UIDynamicItemBehavior alloc] initWithItems:@[self.redPaddleView, self.bluePaddleView]];
//    self.paddleDynamicProperties.allowsRotation = NO;
//    self.paddleDynamicProperties.density = 1000.0f;
//    [self.animator addBehavior:self.paddleDynamicProperties];
//    
//    // Better collisions, no friction
//    self.ballDynamicProperties.elasticity = 1.0;
//    self.ballDynamicProperties.friction = 0.0;
//    self.ballDynamicProperties.resistance = 0.0;
//
}


- (void)viewWillLayoutSubviews {
    self.collision = [[UICollisionBehavior alloc] initWithItems:@[self.ballView, self.redPaddleView, self.bluePaddleView, self.topView, self.bottomView]];
    self.collision.collisionDelegate = self;
    self.collision.collisionMode = UICollisionBehaviorModeItems;
    self.collision.translatesReferenceBoundsIntoBoundary = YES;
    
    
    [self.animator addBehavior:self.collision];
    // Remove rotation
    self.ballDynamicProperties = [[UIDynamicItemBehavior alloc] initWithItems:@[self.ballView]];
    self.ballDynamicProperties.allowsRotation = NO;
    [self.animator addBehavior:self.ballDynamicProperties];
    
    self.paddleDynamicProperties = [[UIDynamicItemBehavior alloc] initWithItems:@[self.redPaddleView, self.bluePaddleView]];
    self.paddleDynamicProperties.allowsRotation = NO;
    self.paddleDynamicProperties.density = 1000.0f;
    [self.animator addBehavior:self.paddleDynamicProperties];
    
    // Better collisions, no friction
    self.ballDynamicProperties.elasticity = 1.0;
    self.ballDynamicProperties.friction = 0.0;
    self.ballDynamicProperties.resistance = 0.0;
    
    // Add collisions
    self.wallDynamicProperties = [[UIDynamicItemBehavior alloc] initWithItems:@[self.topView, self.bottomView]];
    self.wallDynamicProperties.density = 100000.0f;
    self.wallDynamicProperties.allowsRotation = NO;
    [self.animator addBehavior:self.wallDynamicProperties];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)movePaddle:(UIPanGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self.view];
    
    if ((point.x < [UIScreen mainScreen].bounds.size.width - 610) && (point.y > 0)){
    
    self.redPaddleView.center = [recognizer locationInView:self.view];
    [self.animator updateItemUsingCurrentState:self.redPaddleView];
        
    }
}

- (void)moveBluePaddle:(UIPanGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self.view];
    
    //Only allow movement up to within 100 pixels of the right bound of the screen
    if (point.x > [UIScreen mainScreen].bounds.size.width - 50) {

    self.bluePaddleView.center = [recognizer locationInView:self.view];
    [self.animator updateItemUsingCurrentState:self.bluePaddleView];
        
    }
}



- (void)blueScore {
    if (self.ballView ) {
        
    }
}
@end
