//
//  ResultViewController.m
//  Dictionary
//
//  Created by vito7zhang on 16/8/3.
//  Copyright © 2016年 vito7zhang. All rights reserved.
//

#import "ResultViewController.h"
#import "UIViewController+SetNavigationBar.h"
#import "ResultTableViewCell.h"
#import "ResultModel.h"
#import <MBProgressHUD.h>
#import <MJRefresh.h>
#import <iflyMSC/iflyMSC.h>

@interface ResultViewController ()<UITableViewDelegate,UITableViewDataSource,IFlySpeechSynthesizerDelegate>
{
    NSMutableArray *dataSource;
    UITableView *myTableView;
    int index;
    IFlySpeechSynthesizer *_iFlySpeechSynthesizer;
}
@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self setUI];
    [self initData];
    
}

-(void)setUI{
    [self setLeftButton];
    [self setHomeButton];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"beijing"]];
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, UISCREENWIDTH, UISCREENHEIGHT-64) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    
    [myTableView registerNib:[UINib nibWithNibName:@"ResultTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([ResultTableViewCell class])];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.rowHeight = 80;
    
    myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreData)];

    self.title = self.word;
}

-(void)initData{
    myTableView.mj_footer.state = MJRefreshStateIdle;
    index = 0;
    dataSource = [NSMutableArray array];
    NSString *urlString;
    if (self.isPinyin) {
        urlString = [NSString stringWithFormat:@"http://www.chazidian.com/service/pinyin/%@/0/10",self.word];
    }else{
        urlString = [NSString stringWithFormat:@"http://www.chazidian.com/service/bushou/%d/0/10",self.bushou_id];
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *array = dictionary[@"data"][@"words"];
        for (NSDictionary *d in array) {
            ResultModel *m = [ResultModel new];
            m.simp = d[@"simp"] ? d[@"simp"] : @"";
            m.pinyin = d[@"yin"][@"pinyin"] ? d[@"yin"][@"pinyin"] : @"";
            m.bushou = d[@"bushou"] ? d[@"bushou"] : @"";
            m.bihua = d[@"num"] ? d[@"num"] : @"";
            [dataSource addObject:m];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [myTableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            index++;
            [myTableView.mj_header endRefreshing];
        });
    }];
    [dataTask resume];
}

-(void)moreData{
    NSString *urlString;
    if (self.isPinyin) {
        urlString = [NSString stringWithFormat:@"http://www.chazidian.com/service/pinyin/%@/%d/10",self.word,index*10];
    }else{
        urlString = [NSString stringWithFormat:@"http://www.chazidian.com/service/bushou/%d/%d/10",self.bushou_id,index*10];
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *array = dictionary[@"data"][@"words"];
        for (NSDictionary *d in array) {
            BOOL hasWord = NO;
            for (ResultModel *m in dataSource) {
                if ([m.simp isEqualToString:d[@"simp"]]) {
                    hasWord = YES;
                    break;
                }
            }
            if (hasWord) {
                continue;
            }
            
            ResultModel *m = [ResultModel new];
            m.simp = d[@"simp"] ? d[@"simp"] : @"";
            m.pinyin = d[@"yin"][@"pinyin"] ? d[@"yin"][@"pinyin"] : @"";
            m.bushou = d[@"bushou"] ? d[@"bushou"] : @"";
            m.bihua = d[@"num"] ? d[@"num"] : @"";
            [dataSource addObject:m];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [myTableView reloadData];
            index++;
            [myTableView.mj_footer endRefreshing];
            if ([dictionary[@"data"][@"page"][@"pagenum"] intValue] == [dictionary[@"data"][@"page"][@"curpage"] intValue]) {
                [myTableView.mj_footer endRefreshingWithNoMoreData];
            }
        });
    }];
    [dataTask resume];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResultTableViewCell class])];
    cell.backgroundColor = [UIColor clearColor];
    ResultModel *m = dataSource[indexPath.row];
    cell.loudButton.tag = indexPath.row;
    [cell.loudButton addTarget:self action:@selector(loudAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.wordLabel.text = m.simp;
    cell.zhuyinLabel.text = [NSString stringWithFormat:@"[%@]",m.pinyin];
    cell.bushouLabel.text = [NSString stringWithFormat:@"部首：%@",m.bushou];
    cell.bihuaLabel.text = [NSString stringWithFormat:@"笔画：%@",m.bihua];
    return cell;
}

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
    [_iFlySpeechSynthesizer startSpeaking:[(ResultModel *)dataSource[sender.tag] simp]];
}

//合成结束，此代理必须要实现
- (void) onCompleted:(IFlySpeechError *) error{}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
