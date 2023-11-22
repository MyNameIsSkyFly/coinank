
#import "CTHeadCellView.h"

@implementation CTHeadCellView

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.titleBtn = [[SPButton alloc] initWithFrame:(CGRect){0,0,frame.size.width,frame.size.height}];
        self.titleBtn.imageTitleSpace = 2;
        self.titleBtn.imagePosition = 1;
        [self.titleBtn setTitleColor:[UIColor colorNamed:@"title_color"] forState:UIControlStateNormal];
        [self.titleBtn setImage:[UIImage imageNamed:@"triangle_down_default"] forState:UIControlStateNormal];
        
        self.titleBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.self.titleBtn];
    }
    //加载了过后才可以修改属性
//    self.layer.borderWidth = .5;
//    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.backgroundColor = [UIColor colorNamed:@"white_color"];
    return self;
}
@end
