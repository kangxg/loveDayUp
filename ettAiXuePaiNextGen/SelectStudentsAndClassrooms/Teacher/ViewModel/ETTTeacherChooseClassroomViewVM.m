//
//  ETTTeacherChooseClassroomViewVM.m
//  ettAiXuePaiNextGen
//
//
//                          _oo8oo_
//                         o8888888o
//                         88" . "88
//                         (| -_- |)
//                         0\  =  /0
//                       ___/'==='\___
//                     .' \\|     |// '.
//                    / \\|||  :  |||// \
//                   / _||||| -:- |||||_ \
//                  |   | \\\  -  /// |   |
//                  | \_|  ''\---/''  |_/ |
//                  \  .-\__  '-'  __/-.  /
//                ___'. .'  /--.--\  '. .'___
//             ."" '<  '.___\_<|>_/___.'  >' "".
//            | | :  `- \`.:`\ _ /`:.`/ -`  : | |
//            \  \ `-.   \_ __\ /__ _/   .-` /  /
//        =====`-.____`.___ \_____/ ___.`____.-`=====
//                          `=---=`
//       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//                 佛祖镇楼   BUG辟易  永不修改
//       佛曰:
//                 写字楼里写字间，写字间里程序员；
//                 程序人员写程序，又拿程序换酒钱。
//                 酒醒只在网上坐，酒醉还来网下眠；
//                 酒醉酒醒日复日，网上网下年复年。
//                 但愿老死电脑间，不愿鞠躬老板前；
//                 奔驰宝马贵者趣，公交自行程序员。
//                 别人笑我忒疯癫，我笑自己命太贱；
//                 不见满街漂亮妹，哪个归得程序员？
//
//  Created by zhaiyingwei on 2016/10/26.
//  Copyright © 2016年 Etiantian. All rights reserved.
//

#import "ETTTeacherChooseClassroomViewVM.h"

@implementation ETTTeacherChooseClassroomViewVM

-(ETTTeacherChooseClassroomModel *)getClassIdsStrWithModel:(NSMutableArray *)modelArray
{
    NSString *classIdsStr = @"";
    ETTTeacherChooseClassroomModel *basisModel;
    for (id obj in modelArray) {
        ETTTeacherChooseClassroomButton *btn = (ETTTeacherChooseClassroomButton *)obj;
        if (![btn getType]) {
            if ([classIdsStr isEqualToString:@""]) {
                classIdsStr = [NSString stringWithFormat:@"%@",btn.classroomModel.classId];
            }else{
                classIdsStr = [NSString stringWithFormat:@"%@,%@",classIdsStr,btn.classroomModel.classId];
            }
            basisModel = btn.classroomModel;
        }
    }
    
    [basisModel setClassIdsStr:classIdsStr];
    return basisModel;
}

-(void)openClassRoom:(NSMutableArray *)modelArray returnBack:(ReturnBackHandler)returnBack
{
    ETTTeacherChooseClassroomModel *model = [self getClassIdsStrWithModel:modelArray];
    NSString *urlBody = @"axpad/classroom/openClassroom.do";
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SERVER_HOST,urlBody];

    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           model.jid,@"jid",
                           model.schoolId,@"schoolId",
                           model.gradeId,@"gradeId",model.subjectId,@"subjectId",
                           model.classIdsStr,@"classIdsStr", nil];
    [[ETTNetworkManager sharedInstance]GET:urlString Parameters:param responseCallBack:^(NSDictionary *responseDictionary, NSError *error) {
        if (error) {
            returnBack(nil,error);
            NSLog(@"axpad/classroom/openClassroom.do was wrong!");
        }else{
            NSLog(@"%@",responseDictionary);
            switch ([[responseDictionary valueForKey:@"result"]intValue]) {
                case 1:
                {
                    NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithDictionary:[responseDictionary valueForKey:@"data"]];
                    for (id obj in param) {
                        [dataDic setObject:[param valueForKey:obj] forKey:obj];
                    }
                    NSArray *identityArray = [ETTUSERDefaultManager getIdentityArray];
                    [AXPUserInformation sharedInformation].paperRootUrl = [[identityArray firstObject] objectForKey:@"paperRootUrl"];
                    
                    ETTOpenClassroomDoBackModel *backModel = [self dealWithOpenClassroomDoModel:dataDic];
                    returnBack(backModel,nil);
                }
                    break;
                default:
                    NSLog(@"axpad/classroom/openClassroom.do was %@",[NSString stringWithFormat:@"%@",[responseDictionary valueForKey:@"msg"]]);
                    break;
                    
            }
        }
    }];
}


-(ETTOpenClassroomDoBackModel *)dealWithOpenClassroomDoModel:(NSDictionary *)modelDic
{
    ETTOpenClassroomDoBackModel *openClassroomBM = [[ETTOpenClassroomDoBackModel alloc]initWithDictionary:modelDic];
    return openClassroomBM;
}

-(void)changerCellTypeWithArray:(NSMutableArray *)mutableArray inSection:(NSInteger)tSelction
{
    for (id obj in mutableArray) {
        ETTTeacherChooseClassroomButton *btn = (ETTTeacherChooseClassroomButton *)obj;
        if (btn && (btn.indexPath.section != tSelction)&&(ETTTeacherChooseClassroomButtonTypeSelected == [btn getType])) {
            [btn setType:ETTTeacherChooseClassroomButtonTypeUnSelected];
        }
    }
}

-(NSInteger)getSelectedCellNumber:(NSMutableArray *)mutableArray
{
    NSInteger num = 0;
    for (id obj in mutableArray) {
        ETTTeacherChooseClassroomButton *btn = (ETTTeacherChooseClassroomButton *)obj;
        if (ETTTeacherChooseClassroomButtonTypeSelected == [btn getType]) {
            num = num+1;
        }
    }
    return num;
}

@end
