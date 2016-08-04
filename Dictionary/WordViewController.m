//
//  WordViewController.m
//  Dictionary
//
//  Created by vito7zhang on 16/8/4.
//  Copyright © 2016年 vito7zhang. All rights reserved.
//

#import "WordViewController.h"
#import "UIViewController+SetNavigationBar.h"
#import <MBProgressHUD.h>
#import <iflyMSC/iflyMSC.h>
#import "UIViewController+ShowText.h"
#import "SQLiteOperation.h"

@interface WordViewController ()<IFlySpeechSynthesizerDelegate>
{
    WordModel *m;
    IFlySpeechSynthesizer *_iFlySpeechSynthesizer;
}
@property (weak, nonatomic) IBOutlet UILabel *simpLabel;
@property (weak, nonatomic) IBOutlet UILabel *pinyinLabel;
@property (weak, nonatomic) IBOutlet UILabel *fantiLabel;
@property (weak, nonatomic) IBOutlet UILabel *bushouLabel;
@property (weak, nonatomic) IBOutlet UILabel *bishunLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhuyinLabel;
@property (weak, nonatomic) IBOutlet UILabel *jiegouLabel;
@property (weak, nonatomic) IBOutlet UILabel *bihuaLabel;
@property (weak, nonatomic) IBOutlet UILabel *bsBihuaLabel;
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *starBarButtonItem;

@end

@implementation WordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    if (!self.model) {
        [self initData];
    }else{
        m = self.model;
        [self dataBackSetUI];
        self.starBarButtonItem.tintColor = COLORRGB(252, 240, 134);
        self.starBarButtonItem.tag = 1001;
    }
}

-(void)setUI{
    [self setLeftButton];
    [self setHomeButton];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"beijing"]];
    self.title = self.word;
    
}

-(void)initData{
    NSArray *array = [SQLiteOperation findALLCollection];
    for (WordModel *m2 in array) {
        if ([m2.simp isEqualToString:self.word]) {
            m = m2;
            [self dataBackSetUI];
            self.starBarButtonItem.tintColor = COLORRGB(252, 240, 134);
            self.starBarButtonItem.tag = 1001;
            return;
        }
    }
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlString = [NSString stringWithFormat:@"http://www.chazidian.com/service/word/%@",self.word];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *dic = dictionary[@"data"];
        m = [WordModel new];
        m.simp = dic[@"baseinfo"][@"simp"];
        m.pinyin = dic[@"baseinfo"][@"yin"][@"pinyin"];
        m.zhuyin = dic[@"baseinfo"][@"yin"][@"zhuyin"];
        m.tra = dic[@"baseinfo"][@"tra"];
        m.frame = dic[@"baseinfo"][@"frame"];
        m.bushou = dic[@"baseinfo"][@"bushou"];
        m.bsnum = dic[@"baseinfo"][@"bsnum"];
        m.num = dic[@"baseinfo"][@"num"];
        m.seq = dic[@"baseinfo"][@"seq"];
        m.base = dic[@"base"];
        m.english = dic[@"english"];
        m.hanyu = dic[@"hanyu"];
        m.idiom = dic[@"idiom"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dataBackSetUI];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }];
    [task resume];
}


-(void)dataBackSetUI{
    self.simpLabel.text = m.simp;
    self.pinyinLabel.text = [NSString stringWithFormat:@"拼音：%@",m.pinyin];
    self.zhuyinLabel.text = [NSString stringWithFormat:@"注音：%@",m.zhuyin];
    self.fantiLabel.text = [NSString stringWithFormat:@"繁体：%@",m.tra];
    self.jiegouLabel.text = [NSString stringWithFormat:@"结构：%@",m.frame];
    self.bushouLabel.text = [NSString stringWithFormat:@"部首：%@",m.bushou];
    self.bsBihuaLabel.text = [NSString stringWithFormat:@"部首笔画：%@",m.bsnum];
    self.bihuaLabel.text = [NSString stringWithFormat:@"笔画：%@",m.num];
    self.bishunLabel.text = [NSString stringWithFormat:@"笔顺：%@",m.seq];
    self.infoTextView.text = m.base;
}


- (IBAction)segmentControlAction:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:{
            self.infoTextView.text = m.base;
        }
            break;
        case 1:{
            self.infoTextView.text = m.hanyu;
        }
            break;
        case 2:{
            self.infoTextView.text = m.idiom;
        }
            break;
        case 3:{
            self.infoTextView.text = m.english;
        }
            break;
        default:
            break;
    }
}

- (IBAction)pinyinButtonAction:(UIButton *)sender {
    sender.tag = 101;
    [self loudAction:sender];
}
- (IBAction)zhuyinButtonAction:(UIButton *)sender {
    [self loudAction:sender];
}

- (IBAction)copyBarButtonItemAction:(UIBarButtonItem *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.simpLabel.text;
    sender.tintColor = COLORRGB(252, 240, 134);
    [self showTextWithString:@"复制成功"];
}
- (IBAction)starBarButtonItemAction:(UIBarButtonItem *)sender {
    //tag为1001为的时候为收藏状态，1000的时候为未收藏状态
    if (sender.tag == 1000) {
        sender.tag = 1001;
        sender.tintColor = COLORRGB(252, 240, 134);
        [SQLiteOperation insertModel:m];
        [self showTextWithString:@"收藏成功"];
    }else{
        sender.tag = 1000;
        sender.tintColor = COLORRGB(128, 128, 128);
        [SQLiteOperation deleteModel:m];
        [self showTextWithString:@"取消收藏"];
    }
    
}
- (IBAction)shareBarButtonItemAction:(UIBarButtonItem *)sender {
}


#pragma mark 发音

-(void)loudAction:(UIButton *)sender{
    // 创建合成对象，为单例模式
    _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance]; _iFlySpeechSynthesizer.delegate = self;
    //设置语音合成的参数
    //语速,取值范围 0~100
    [_iFlySpeechSynthesizer setParameter:@"20" forKey:[IFlySpeechConstant SPEED]];
    //音量;取值范围 0~100
    [_iFlySpeechSynthesizer setParameter:@"50" forKey: [IFlySpeechConstant VOLUME]];
    //发音人,默认为”xiaoyan”;可以设置的参数列表可参考个 性化发音人列表
    [_iFlySpeechSynthesizer setParameter:@"xiaoyan" forKey: [IFlySpeechConstant VOICE_NAME]];
    //音频采样率,目前支持的采样率有 16000 和 8000
    [_iFlySpeechSynthesizer setParameter:@"8000" forKey: [IFlySpeechConstant SAMPLE_RATE]];
    //asr_audio_path保存录音文件路径，如不再需要，设置value为nil表示取消，默认目录是documents
    [_iFlySpeechSynthesizer setParameter:nil forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
    
    //启动合成会话
    if (sender.tag == 101) {
        [_iFlySpeechSynthesizer startSpeaking:self.pinyinLabel.text];
    }else{
        [_iFlySpeechSynthesizer startSpeaking:self.zhuyinLabel.text];
    }
}

//合成结束，此代理必须要实现
- (void) onCompleted:(IFlySpeechError *) error{}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
