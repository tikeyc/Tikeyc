//
//  TEchartsMapViewModel.m
//  Tikeyc
//
//  Created by ways on 2016/11/3.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TEchartsMapViewModel.h"

//#import "RMMapper.h"

@implementation TEchartsMapViewModel


/**
 中国基础地图
 
 @return option
 */
+ (PYOption *)basicChinaMapOption {
    return [PYOption initPYOptionWithBlock:^(PYOption *option) {
        option.titleEqual([PYTitle initPYTitleWithBlock:^(PYTitle *title) {
            title.textEqual(@"地图")
            .subtextEqual(@"纯属扯淡")
            .xEqual(PYPositionCenter);
        }])
        .tooltipEqual([PYTooltip initPYTooltipWithBlock:^(PYTooltip *tooltip) {
            tooltip.triggerEqual(PYTooltipTriggerItem)
            .formatterEqual(@"{b}");
        }])
        .legendEqual([PYLegend initPYLegendWithBlock:^(PYLegend *legend) {
            legend.dataEqual(@[@"中国"]);
            legend.showEqual(NO);
        }])
        //        .toolboxEqual([PYToolbox initPYToolboxWithBlock:^(PYToolbox *toolbox) {
        //            toolbox.showEqual(NO)
        //            .featureEqual([PYToolboxFeature initPYToolboxFeatureWithBlock:^(PYToolboxFeature *feature) {
        //                feature.markEqual([PYToolboxFeatureMark initPYToolboxFeatureMarkWithBlock:^(PYToolboxFeatureMark *mark) {
        //                    mark.showEqual(YES);
        //                }])
        //                .dataViewEqual([PYToolboxFeatureDataView initPYToolboxFeatureDataViewWithBlock:^(PYToolboxFeatureDataView *dataView) {
        //                    dataView.showEqual(YES).readOnlyEqual(NO);
        //                }])
        //                .restoreEqual([PYToolboxFeatureRestore initPYToolboxFeatureRestoreWithBlock:^(PYToolboxFeatureRestore *restore) {
        //                    restore.showEqual(YES);
        //                }]);
        //            }]);
        //        }])
        
        .addSeries([PYMapSeries initPYMapSeriesWithBlock:^(PYMapSeries *series) {
            series.nameEqual(@"中国")
            .typeEqual(PYSeriesTypeMap);
            series.mapTypeEqual(@"china");
            series.selectedModeEqual(@"single")//single multiple
            .mapLocationEqual(@{@"x":PYPositionLeft, @"y":PYPositionCenter,@"width":@"60%"})
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                    itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
                        label.showEqual(YES);
                    }]);
                    itemStyleProp.colorEqual(PYRGBA(192, 212, 233, 1));
                    itemStyleProp.borderColorEqual(PYRGBA(55, 55, 55, 1));
                }])
                .emphasisEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                    itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
                        label.showEqual(YES);
                    }]);
                    itemStyleProp.colorEqual(PYRGBA(125, 211, 249, 1));
                    itemStyleProp.borderColorEqual(PYRGBA(255, 255, 255, 1));
                    itemStyleProp.borderWidthEqual(@3);
                }]);
            }]);
            NSString *dataJsonStr = @"{\"tooltip\":{\"trigger\":\"item\"},\"toolbox\":{\"show\":true,\"orient\":\"vertical\",\"x\":\"right\",\"y\":\"center\",\"feature\":{\"mark\":{\"show\":true},\"dataView\":{\"show\":true,\"readOnly\":false}}},\"series\":[{\"tooltip\":{\"trigger\":\"item\",\"formatter\":\"{b}\"},\"name\":\"选择器\",\"type\":\"map\",\"mapType\":\"china\",\"mapLocation\":{\"x\":\"left\",\"y\":\"top\",\"width\":\"30%\"},\"roam\":true,\"selectedMode\":\"single\",\"itemStyle\":{\"emphasis\":{\"label\":{\"show\":true}}},\"data\":[{\"name\":\"北京\",\"selected\":false},{\"name\":\"天津\",\"selected\":false},{\"name\":\"上海\",\"selected\":false},{\"name\":\"重庆\",\"selected\":false},{\"name\":\"河北\",\"selected\":false},{\"name\":\"河南\",\"selected\":false},{\"name\":\"云南\",\"selected\":false},{\"name\":\"辽宁\",\"selected\":false},{\"name\":\"黑龙江\",\"selected\":false},{\"name\":\"湖南\",\"selected\":false},{\"name\":\"安徽\",\"selected\":false},{\"name\":\"山东\",\"selected\":false},{\"name\":\"新疆\",\"selected\":false},{\"name\":\"江苏\",\"selected\":false},{\"name\":\"浙江\",\"selected\":false},{\"name\":\"江西\",\"selected\":false},{\"name\":\"湖北\",\"selected\":false},{\"name\":\"广西\",\"selected\":false},{\"name\":\"甘肃\",\"selected\":false},{\"name\":\"山西\",\"selected\":false},{\"name\":\"内蒙古\",\"selected\":false},{\"name\":\"陕西\",\"selected\":false},{\"name\":\"吉林\",\"selected\":false},{\"name\":\"福建\",\"selected\":false},{\"name\":\"贵州\",\"selected\":false},{\"name\":\"广东\",\"selected\":false},{\"name\":\"青海\",\"selected\":false},{\"name\":\"西藏\",\"selected\":false},{\"name\":\"四川\",\"selected\":false},{\"name\":\"宁夏\",\"selected\":false},{\"name\":\"海南\",\"selected\":false},{\"name\":\"台湾\",\"selected\":false},{\"name\":\"香港\",\"selected\":false},{\"name\":\"澳门\",\"selected\":false}]}],\"animation\":false}";;
            NSData *jsonData = [dataJsonStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
            NSArray *datas = [jsonDic[@"series"] firstObject][@"data"];
            series.addDataArr(datas);
            
            series.markPointEqual([PYMarkPoint initPYMarkPointWithBlock:^(PYMarkPoint *point) {
                point.itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                    itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                        itemStyleProp.colorEqual(@"skyblue");
                        itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
                            label.showEqual(YES);
                        }]);
                    }]);
                }]);
                point.addDataArr(@[@{@"name":@"天津",@"value":@350},
                                   @{@"name":@"上海",@"value":@103}]);
            }]);
            series.geoCoordEqual(@{@"上海":@[@121.4648,@31.2891],@"天津":@[@117.4219,@39.4189]});
            
        }]);
    }];
}

/**
 中国基础地图(城市)
 
 @return option
 */
+ (PYOption *)basicChinaMapCityOptionWithPrivinceName:(NSString *)selectedProvince selectedCityName:(NSString *)selectedCityName {
    return [PYOption initPYOptionWithBlock:^(PYOption *option) {
        option.titleEqual([PYTitle initPYTitleWithBlock:^(PYTitle *title) {
            title.textEqual(@"地图")
            .subtextEqual(@"纯属扯淡")
            .xEqual(PYPositionLeft);
        }])
        .tooltipEqual([PYTooltip initPYTooltipWithBlock:^(PYTooltip *tooltip) {
            tooltip.triggerEqual(PYTooltipTriggerItem)
            .formatterEqual(@"{b}");
        }])
        //        .legendEqual([PYLegend initPYLegendWithBlock:^(PYLegend *legend) {
        //            legend.dataEqual(@[@"series1"]);
        //        }])
        //        .toolboxEqual([PYToolbox initPYToolboxWithBlock:^(PYToolbox *toolbox) {
        //            toolbox.showEqual(NO)
        //            .featureEqual([PYToolboxFeature initPYToolboxFeatureWithBlock:^(PYToolboxFeature *feature) {
        //                feature.markEqual([PYToolboxFeatureMark initPYToolboxFeatureMarkWithBlock:^(PYToolboxFeatureMark *mark) {
        //                    mark.showEqual(YES);
        //                }])
        //                .dataViewEqual([PYToolboxFeatureDataView initPYToolboxFeatureDataViewWithBlock:^(PYToolboxFeatureDataView *dataView) {
        //                    dataView.showEqual(YES).readOnlyEqual(NO);
        //                }])
        //                .restoreEqual([PYToolboxFeatureRestore initPYToolboxFeatureRestoreWithBlock:^(PYToolboxFeatureRestore *restore) {
        //                    restore.showEqual(YES);
        //                }]);
        //            }]);
        //        }])
        
        .addSeries([TEchartsMapViewModel basicChinaPrivinceMapSeriesWithPrivinceName:selectedProvince selectedCityName:selectedCityName]);
    }];
}

/**
 中国基础地图某一个省份 的Series
 
 @return Series
 */
+ (PYSeries *)basicChinaPrivinceMapSeriesWithPrivinceName:(NSString *)selectedProvince{
    PYSeries *series = [PYMapSeries initPYMapSeriesWithBlock:^(PYMapSeries *series) {
        series.nameEqual(@"省份")
        .typeEqual(PYSeriesTypeMap);
        series.mapTypeEqual(selectedProvince);
        series.selectedModeEqual(@"single")//single multiple
        .mapLocationEqual(@{@"x":@"55%", @"y":PYPositionCenter,@"width":@"40%"})
        .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
            itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
                    label.showEqual(YES);
                    
                }]);
                itemStyleProp.colorEqual(PYRGBA(192, 139, 240, 1));
                itemStyleProp.borderColorEqual(PYRGBA(186, 236, 183, 1));
                itemStyleProp.borderWidthEqual(@2);
            }])
            .emphasisEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
                    label.showEqual(YES);
                }]);
                itemStyleProp.colorEqual(@"#32cd32");
                itemStyleProp.borderColorEqual(@"#fff");
                itemStyleProp.borderWidthEqual(@3);
            }]);
        }]);
        
        series.tooltipEqual([PYTooltip initPYTooltipWithBlock:^(PYTooltip *tooltip) {
            tooltip.triggerEqual(PYTooltipTriggerItem)
            .formatterEqual(@"{b}<br/>数值:{c}");
        }]);
        NSString *dataJsonStr = [NSString stringWithFormat:@"{\"name\":\"随机数据\",\"type\":\"map\",\"mapType\":\"%@\",\"itemStyle\":{\"normal\":{\"label\":{\"show\":true}},\"emphasis\":{\"label\":{\"show\":true}}},\"mapLocation\":{\"x\":\"35%%\",\"width\":\"50%%\"},\"roam\":true,\"data\":[{\"name\":\"重庆市\",\"value\":790},{\"name\":\"北京市\",\"value\":189},{\"name\":\"天津市\",\"value\":912},{\"name\":\"上海市\",\"value\":949},{\"name\":\"香港\",\"value\":400},{\"name\":\"澳门\",\"value\":748},{\"name\":\"巴音郭楞蒙古自治州\",\"value\":630},{\"name\":\"和田地区\",\"value\":142},{\"name\":\"哈密地区\",\"value\":803},{\"name\":\"阿克苏地区\",\"value\":528},{\"name\":\"阿勒泰地区\",\"value\":588},{\"name\":\"喀什地区\",\"value\":139},{\"name\":\"塔城地区\",\"value\":94},{\"name\":\"昌吉回族自治州\",\"value\":542},{\"name\":\"克孜勒苏柯尔克孜自治州\",\"value\":394},{\"name\":\"吐鲁番地区\",\"value\":782},{\"name\":\"伊犁哈萨克自治州\",\"value\":799},{\"name\":\"博尔塔拉蒙古自治州\",\"value\":290},{\"name\":\"乌鲁木齐市\",\"value\":901},{\"name\":\"克拉玛依市\",\"value\":443},{\"name\":\"阿拉尔市\",\"value\":454},{\"name\":\"图木舒克市\",\"value\":888},{\"name\":\"五家渠市\",\"value\":119},{\"name\":\"石河子市\",\"value\":239},{\"name\":\"那曲地区\",\"value\":840},{\"name\":\"阿里地区\",\"value\":563},{\"name\":\"日喀则地区\",\"value\":402},{\"name\":\"林芝地区\",\"value\":308},{\"name\":\"昌都地区\",\"value\":702},{\"name\":\"山南地区\",\"value\":842},{\"name\":\"拉萨市\",\"value\":256},{\"name\":\"呼伦贝尔市\",\"value\":53},{\"name\":\"阿拉善盟\",\"value\":556},{\"name\":\"锡林郭勒盟\",\"value\":462},{\"name\":\"鄂尔多斯市\",\"value\":603},{\"name\":\"赤峰市\",\"value\":909},{\"name\":\"巴彦淖尔市\",\"value\":211},{\"name\":\"通辽市\",\"value\":127},{\"name\":\"乌兰察布市\",\"value\":823},{\"name\":\"兴安盟\",\"value\":513},{\"name\":\"包头市\",\"value\":387},{\"name\":\"呼和浩特市\",\"value\":887},{\"name\":\"乌海市\",\"value\":644},{\"name\":\"海西蒙古族藏族自治州\",\"value\":642},{\"name\":\"玉树藏族自治州\",\"value\":339},{\"name\":\"果洛藏族自治州\",\"value\":519},{\"name\":\"海南藏族自治州\",\"value\":332},{\"name\":\"海北藏族自治州\",\"value\":982},{\"name\":\"黄南藏族自治州\",\"value\":721},{\"name\":\"海东地区\",\"value\":618},{\"name\":\"西宁市\",\"value\":920},{\"name\":\"甘孜藏族自治州\",\"value\":728},{\"name\":\"阿坝藏族羌族自治州\",\"value\":292},{\"name\":\"凉山彝族自治州\",\"value\":996},{\"name\":\"绵阳市\",\"value\":999},{\"name\":\"达州市\",\"value\":886},{\"name\":\"广元市\",\"value\":552},{\"name\":\"雅安市\",\"value\":429},{\"name\":\"宜宾市\",\"value\":449},{\"name\":\"乐山市\",\"value\":154},{\"name\":\"南充市\",\"value\":209},{\"name\":\"巴中市\",\"value\":630},{\"name\":\"泸州市\",\"value\":708},{\"name\":\"成都市\",\"value\":53},{\"name\":\"资阳市\",\"value\":662},{\"name\":\"攀枝花市\",\"value\":491},{\"name\":\"眉山市\",\"value\":971},{\"name\":\"广安市\",\"value\":760},{\"name\":\"德阳市\",\"value\":68},{\"name\":\"内江市\",\"value\":618},{\"name\":\"遂宁市\",\"value\":250},{\"name\":\"自贡市\",\"value\":273},{\"name\":\"黑河市\",\"value\":205},{\"name\":\"大兴安岭地区\",\"value\":104},{\"name\":\"哈尔滨市\",\"value\":346},{\"name\":\"齐齐哈尔市\",\"value\":202},{\"name\":\"牡丹江市\",\"value\":378},{\"name\":\"绥化市\",\"value\":616},{\"name\":\"伊春市\",\"value\":960},{\"name\":\"佳木斯市\",\"value\":29},{\"name\":\"鸡西市\",\"value\":548},{\"name\":\"双鸭山市\",\"value\":753},{\"name\":\"大庆市\",\"value\":815},{\"name\":\"鹤岗市\",\"value\":136},{\"name\":\"七台河市\",\"value\":895},{\"name\":\"酒泉市\",\"value\":717},{\"name\":\"张掖市\",\"value\":521},{\"name\":\"甘南藏族自治州\",\"value\":254},{\"name\":\"武威市\",\"value\":131},{\"name\":\"陇南市\",\"value\":925},{\"name\":\"庆阳市\",\"value\":369},{\"name\":\"白银市\",\"value\":62},{\"name\":\"定西市\",\"value\":606},{\"name\":\"天水市\",\"value\":740},{\"name\":\"兰州市\",\"value\":761},{\"name\":\"平凉市\",\"value\":517},{\"name\":\"临夏回族自治州\",\"value\":480},{\"name\":\"金昌市\",\"value\":568},{\"name\":\"嘉峪关市\",\"value\":613},{\"name\":\"普洱市\",\"value\":947},{\"name\":\"红河哈尼族彝族自治州\",\"value\":135},{\"name\":\"文山壮族苗族自治州\",\"value\":533},{\"name\":\"曲靖市\",\"value\":878},{\"name\":\"楚雄彝族自治州\",\"value\":742},{\"name\":\"大理白族自治州\",\"value\":628},{\"name\":\"临沧市\",\"value\":471},{\"name\":\"迪庆藏族自治州\",\"value\":34},{\"name\":\"昭通市\",\"value\":977},{\"name\":\"昆明市\",\"value\":616},{\"name\":\"丽江市\",\"value\":630},{\"name\":\"西双版纳傣族自治州\",\"value\":352},{\"name\":\"保山市\",\"value\":647},{\"name\":\"玉溪市\",\"value\":449},{\"name\":\"怒江傈僳族自治州\",\"value\":771},{\"name\":\"德宏傣族景颇族自治州\",\"value\":59},{\"name\":\"百色市\",\"value\":718},{\"name\":\"河池市\",\"value\":968},{\"name\":\"桂林市\",\"value\":314},{\"name\":\"南宁市\",\"value\":421},{\"name\":\"柳州市\",\"value\":3},{\"name\":\"崇左市\",\"value\":232},{\"name\":\"来宾市\",\"value\":540},{\"name\":\"玉林市\",\"value\":820},{\"name\":\"梧州市\",\"value\":551},{\"name\":\"贺州市\",\"value\":669},{\"name\":\"钦州市\",\"value\":473},{\"name\":\"贵港市\",\"value\":321},{\"name\":\"防城港市\",\"value\":862},{\"name\":\"北海市\",\"value\":361},{\"name\":\"怀化市\",\"value\":289},{\"name\":\"永州市\",\"value\":278},{\"name\":\"邵阳市\",\"value\":148},{\"name\":\"郴州市\",\"value\":819},{\"name\":\"常德市\",\"value\":616},{\"name\":\"湘西土家族苗族自治州\",\"value\":661},{\"name\":\"衡阳市\",\"value\":705},{\"name\":\"岳阳市\",\"value\":202},{\"name\":\"益阳市\",\"value\":369},{\"name\":\"长沙市\",\"value\":580},{\"name\":\"株洲市\",\"value\":514},{\"name\":\"张家界市\",\"value\":761},{\"name\":\"娄底市\",\"value\":349},{\"name\":\"湘潭市\",\"value\":17},{\"name\":\"榆林市\",\"value\":776},{\"name\":\"延安市\",\"value\":556},{\"name\":\"汉中市\",\"value\":984},{\"name\":\"安康市\",\"value\":458},{\"name\":\"商洛市\",\"value\":149},{\"name\":\"宝鸡市\",\"value\":691},{\"name\":\"渭南市\",\"value\":204},{\"name\":\"咸阳市\",\"value\":193},{\"name\":\"西安市\",\"value\":196},{\"name\":\"铜川市\",\"value\":444},{\"name\":\"清远市\",\"value\":642},{\"name\":\"韶关市\",\"value\":895},{\"name\":\"湛江市\",\"value\":703},{\"name\":\"梅州市\",\"value\":467},{\"name\":\"河源市\",\"value\":88},{\"name\":\"肇庆市\",\"value\":205},{\"name\":\"惠州市\",\"value\":596},{\"name\":\"茂名市\",\"value\":193},{\"name\":\"江门市\",\"value\":7},{\"name\":\"阳江市\",\"value\":519},{\"name\":\"云浮市\",\"value\":847},{\"name\":\"广州市\",\"value\":725},{\"name\":\"汕尾市\",\"value\":103},{\"name\":\"揭阳市\",\"value\":513},{\"name\":\"珠海市\",\"value\":192},{\"name\":\"佛山市\",\"value\":684},{\"name\":\"潮州市\",\"value\":857},{\"name\":\"汕头市\",\"value\":714},{\"name\":\"深圳市\",\"value\":551},{\"name\":\"东莞市\",\"value\":689},{\"name\":\"中山市\",\"value\":581},{\"name\":\"延边朝鲜族自治州\",\"value\":874},{\"name\":\"吉林市\",\"value\":34},{\"name\":\"白城市\",\"value\":43},{\"name\":\"松原市\",\"value\":320},{\"name\":\"长春市\",\"value\":278},{\"name\":\"白山市\",\"value\":317},{\"name\":\"通化市\",\"value\":64},{\"name\":\"四平市\",\"value\":779},{\"name\":\"辽源市\",\"value\":503},{\"name\":\"承德市\",\"value\":743},{\"name\":\"张家口市\",\"value\":481},{\"name\":\"保定市\",\"value\":571},{\"name\":\"唐山市\",\"value\":893},{\"name\":\"沧州市\",\"value\":685},{\"name\":\"石家庄市\",\"value\":814},{\"name\":\"邢台市\",\"value\":346},{\"name\":\"邯郸市\",\"value\":611},{\"name\":\"秦皇岛市\",\"value\":30},{\"name\":\"衡水市\",\"value\":594},{\"name\":\"廊坊市\",\"value\":417},{\"name\":\"恩施土家族苗族自治州\",\"value\":637},{\"name\":\"十堰市\",\"value\":485},{\"name\":\"宜昌市\",\"value\":151},{\"name\":\"襄樊市\",\"value\":635},{\"name\":\"黄冈市\",\"value\":615},{\"name\":\"荆州市\",\"value\":938},{\"name\":\"荆门市\",\"value\":607},{\"name\":\"咸宁市\",\"value\":578},{\"name\":\"随州市\",\"value\":37},{\"name\":\"孝感市\",\"value\":249},{\"name\":\"武汉市\",\"value\":100},{\"name\":\"黄石市\",\"value\":113},{\"name\":\"神农架林区\",\"value\":194},{\"name\":\"天门市\",\"value\":874},{\"name\":\"仙桃市\",\"value\":541},{\"name\":\"潜江市\",\"value\":528},{\"name\":\"鄂州市\",\"value\":730},{\"name\":\"遵义市\",\"value\":877},{\"name\":\"黔东南苗族侗族自治州\",\"value\":304},{\"name\":\"毕节地区\",\"value\":577},{\"name\":\"黔南布依族苗族自治州\",\"value\":121},{\"name\":\"铜仁地区\",\"value\":165},{\"name\":\"黔西南布依族苗族自治州\",\"value\":379},{\"name\":\"六盘水市\",\"value\":12},{\"name\":\"安顺市\",\"value\":457},{\"name\":\"贵阳市\",\"value\":268},{\"name\":\"烟台市\",\"value\":503},{\"name\":\"临沂市\",\"value\":280},{\"name\":\"潍坊市\",\"value\":233},{\"name\":\"青岛市\",\"value\":139},{\"name\":\"菏泽市\",\"value\":383},{\"name\":\"济宁市\",\"value\":318},{\"name\":\"德州市\",\"value\":162},{\"name\":\"滨州市\",\"value\":841},{\"name\":\"聊城市\",\"value\":228},{\"name\":\"东营市\",\"value\":167},{\"name\":\"济南市\",\"value\":682},{\"name\":\"泰安市\",\"value\":897},{\"name\":\"威海市\",\"value\":307},{\"name\":\"日照市\",\"value\":160},{\"name\":\"淄博市\",\"value\":629},{\"name\":\"枣庄市\",\"value\":177},{\"name\":\"莱芜市\",\"value\":224},{\"name\":\"赣州市\",\"value\":666},{\"name\":\"吉安市\",\"value\":494},{\"name\":\"上饶市\",\"value\":819},{\"name\":\"九江市\",\"value\":848},{\"name\":\"抚州市\",\"value\":232},{\"name\":\"宜春市\",\"value\":781},{\"name\":\"南昌市\",\"value\":959},{\"name\":\"景德镇市\",\"value\":533},{\"name\":\"萍乡市\",\"value\":170},{\"name\":\"鹰潭市\",\"value\":164},{\"name\":\"新余市\",\"value\":926},{\"name\":\"南阳市\",\"value\":49},{\"name\":\"信阳市\",\"value\":747},{\"name\":\"洛阳市\",\"value\":548},{\"name\":\"驻马店市\",\"value\":356},{\"name\":\"周口市\",\"value\":250},{\"name\":\"商丘市\",\"value\":230},{\"name\":\"三门峡市\",\"value\":957},{\"name\":\"新乡市\",\"value\":545},{\"name\":\"平顶山市\",\"value\":488},{\"name\":\"郑州市\",\"value\":474},{\"name\":\"安阳市\",\"value\":132},{\"name\":\"开封市\",\"value\":131},{\"name\":\"焦作市\",\"value\":922},{\"name\":\"许昌市\",\"value\":965},{\"name\":\"濮阳市\",\"value\":769},{\"name\":\"漯河市\",\"value\":92},{\"name\":\"鹤壁市\",\"value\":130},{\"name\":\"大连市\",\"value\":808},{\"name\":\"朝阳市\",\"value\":230},{\"name\":\"丹东市\",\"value\":473},{\"name\":\"铁岭市\",\"value\":94},{\"name\":\"沈阳市\",\"value\":19},{\"name\":\"抚顺市\",\"value\":738},{\"name\":\"葫芦岛市\",\"value\":425},{\"name\":\"阜新市\",\"value\":187},{\"name\":\"锦州市\",\"value\":947},{\"name\":\"鞍山市\",\"value\":602},{\"name\":\"本溪市\",\"value\":965},{\"name\":\"营口市\",\"value\":970},{\"name\":\"辽阳市\",\"value\":932},{\"name\":\"盘锦市\",\"value\":891},{\"name\":\"忻州市\",\"value\":406},{\"name\":\"吕梁市\",\"value\":143},{\"name\":\"临汾市\",\"value\":394},{\"name\":\"晋中市\",\"value\":464},{\"name\":\"运城市\",\"value\":826},{\"name\":\"大同市\",\"value\":864},{\"name\":\"长治市\",\"value\":291},{\"name\":\"朔州市\",\"value\":911},{\"name\":\"晋城市\",\"value\":410},{\"name\":\"太原市\",\"value\":134},{\"name\":\"阳泉市\",\"value\":987},{\"name\":\"六安市\",\"value\":143},{\"name\":\"安庆市\",\"value\":226},{\"name\":\"滁州市\",\"value\":228},{\"name\":\"宣城市\",\"value\":960},{\"name\":\"阜阳市\",\"value\":708},{\"name\":\"宿州市\",\"value\":996},{\"name\":\"黄山市\",\"value\":346},{\"name\":\"巢湖市\",\"value\":844},{\"name\":\"亳州市\",\"value\":339},{\"name\":\"池州市\",\"value\":656},{\"name\":\"合肥市\",\"value\":740},{\"name\":\"蚌埠市\",\"value\":588},{\"name\":\"芜湖市\",\"value\":82},{\"name\":\"淮北市\",\"value\":853},{\"name\":\"淮南市\",\"value\":802},{\"name\":\"马鞍山市\",\"value\":76},{\"name\":\"铜陵市\",\"value\":733},{\"name\":\"南平市\",\"value\":883},{\"name\":\"三明市\",\"value\":238},{\"name\":\"龙岩市\",\"value\":794},{\"name\":\"宁德市\",\"value\":515},{\"name\":\"福州市\",\"value\":808},{\"name\":\"漳州市\",\"value\":175},{\"name\":\"泉州市\",\"value\":491},{\"name\":\"莆田市\",\"value\":795},{\"name\":\"厦门市\",\"value\":458},{\"name\":\"丽水市\",\"value\":893},{\"name\":\"杭州市\",\"value\":832},{\"name\":\"温州市\",\"value\":662},{\"name\":\"宁波市\",\"value\":184},{\"name\":\"舟山市\",\"value\":709},{\"name\":\"台州市\",\"value\":589},{\"name\":\"金华市\",\"value\":24},{\"name\":\"衢州市\",\"value\":731},{\"name\":\"绍兴市\",\"value\":285},{\"name\":\"嘉兴市\",\"value\":677},{\"name\":\"湖州市\",\"value\":180},{\"name\":\"盐城市\",\"value\":244},{\"name\":\"徐州市\",\"value\":274},{\"name\":\"南通市\",\"value\":872},{\"name\":\"淮安市\",\"value\":385},{\"name\":\"苏州市\",\"value\":811},{\"name\":\"宿迁市\",\"value\":160},{\"name\":\"连云港市\",\"value\":726},{\"name\":\"扬州市\",\"value\":771},{\"name\":\"南京市\",\"value\":162},{\"name\":\"泰州市\",\"value\":551},{\"name\":\"无锡市\",\"value\":1},{\"name\":\"常州市\",\"value\":225},{\"name\":\"镇江市\",\"value\":98},{\"name\":\"吴忠市\",\"value\":929},{\"name\":\"中卫市\",\"value\":210},{\"name\":\"固原市\",\"value\":97},{\"name\":\"银川市\",\"value\":619},{\"name\":\"石嘴山市\",\"value\":477},{\"name\":\"儋州市\",\"value\":792},{\"name\":\"文昌市\",\"value\":73},{\"name\":\"乐东黎族自治县\",\"value\":463},{\"name\":\"三亚市\",\"value\":448},{\"name\":\"琼中黎族苗族自治县\",\"value\":707},{\"name\":\"东方市\",\"value\":322},{\"name\":\"海口市\",\"value\":446},{\"name\":\"万宁市\",\"value\":294},{\"name\":\"澄迈县\",\"value\":428},{\"name\":\"白沙黎族自治县\",\"value\":297},{\"name\":\"琼海市\",\"value\":406},{\"name\":\"昌江黎族自治县\",\"value\":149},{\"name\":\"临高县\",\"value\":419},{\"name\":\"陵水黎族自治县\",\"value\":872},{\"name\":\"屯昌县\",\"value\":935},{\"name\":\"定安县\",\"value\":731},{\"name\":\"保亭黎族苗族自治县\",\"value\":452},{\"name\":\"五指山市\",\"value\":948}]}", selectedProvince];
        NSData *jsonData = [dataJsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
        NSArray *datas = jsonDic[@"data"];
        series.addDataArr(datas);
    }];

    return series;
}


/**
 中国基础地图某一个城市 的Series
 
 @return Series
 */
+ (PYSeries *)basicChinaPrivinceMapSeriesWithPrivinceName:(NSString *)selectedProvince selectedCityName:(NSString *)selectedCityName{
    PYSeries *series = [PYMapSeries initPYMapSeriesWithBlock:^(PYMapSeries *series) {
//        series.nameEqual(@"一级对应的二级地图")
        series.typeEqual(PYSeriesTypeMap);
        NSString *mapType = [[selectedProvince stringByAppendingString:@"|"] stringByAppendingString:selectedCityName];
        series.mapTypeEqual(mapType);
        series.selectedModeEqual(@"single")//single multiple
//        .mapLocationEqual(@{@"x":@"55%", @"y":PYPositionCenter,@"width":@"40%"})
        .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
            itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
                    label.showEqual(YES);
                }]);
            }])
            .emphasisEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
                    label.showEqual(YES);
                }]);
            }]);
        }]);

    }];
    
    return series;
}



/**
 世界基础地图
 
 @return option
 */
+ (PYOption *)basicWorldMapOption{
    return [PYOption initPYOptionWithBlock:^(PYOption *option) {
        option.titleEqual([PYTitle initPYTitleWithBlock:^(PYTitle *title) {
            title.textEqual(@"世界地图")
            .subtextEqual(@"纯属扯淡")
            .xEqual(PYPositionCenter);
        }])
        .tooltipEqual([PYTooltip initPYTooltipWithBlock:^(PYTooltip *tooltip) {
            tooltip.triggerEqual(PYTooltipTriggerItem)
            .formatterEqual(@"{b}");
        }])
        //        .legendEqual([PYLegend initPYLegendWithBlock:^(PYLegend *legend) {
        //            legend.dataEqual(@[@"series1"]);
        //        }])
        //        .toolboxEqual([PYToolbox initPYToolboxWithBlock:^(PYToolbox *toolbox) {
        //            toolbox.showEqual(NO)
        //            .featureEqual([PYToolboxFeature initPYToolboxFeatureWithBlock:^(PYToolboxFeature *feature) {
        //                feature.markEqual([PYToolboxFeatureMark initPYToolboxFeatureMarkWithBlock:^(PYToolboxFeatureMark *mark) {
        //                    mark.showEqual(YES);
        //                }])
        //                .dataViewEqual([PYToolboxFeatureDataView initPYToolboxFeatureDataViewWithBlock:^(PYToolboxFeatureDataView *dataView) {
        //                    dataView.showEqual(YES).readOnlyEqual(NO);
        //                }])
        //                .restoreEqual([PYToolboxFeatureRestore initPYToolboxFeatureRestoreWithBlock:^(PYToolboxFeatureRestore *restore) {
        //                    restore.showEqual(YES);
        //                }]);
        //            }]);
        //        }])
//        .dataRangeEqual([PYDataRange initPYDataRangeWithBlock:^(PYDataRange *dataRange) {
//            dataRange.minEqual(@0).maxEqual(@1000)
//            .textEqual([NSMutableArray arrayWithArray:@[@"热",@"冷"]])
//            .splitListEqual([NSMutableArray arrayWithObject:@0])
//            .colorEqual([NSMutableArray arrayWithArray:@[@"orangered",@"yellow",@"lightskyblue"]]);
//        }])
        .addSeries([PYMapSeries initPYMapSeriesWithBlock:^(PYMapSeries *series) {
            series.nameEqual(@"世界")
            .typeEqual(PYSeriesTypeMap);
            series.mapTypeEqual(@"world"); //world // 自定义扩展图表类型:continent
            series.selectedModeEqual(@"single")//single multiple
//            .mapLocationEqual(@{@"x":PYPositionLeft, @"y":PYPositionCenter,@"width":@"60%"})
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                    itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
                        label.showEqual(NO);
                    }]);
                    itemStyleProp.colorEqual(PYRGBA(186, 236, 183, 1));
                    itemStyleProp.borderColorEqual(PYRGBA(55, 55, 55, 1));
                }])
                .emphasisEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                    itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
                        label.showEqual(YES);
                    }]);
                }]);
            }]);
            series.addDataArr(@[@{@"name": @"亚洲", @"value": @8967.69},
                                @{@"name": @"大洋洲", @"value": @592.09},
                                @{@"name": @"欧洲", @"value": @183.62},
                                @{@"name": @"北美洲", @"value": @41.63},
                                @{@"name": @"南美洲", @"value": @10.41},
                                @{@"name": @"非洲", @"value": @22.5837}]);
            
        }]);
    }];

}

/**
 地图标线(模拟迁徙)

 @return option
 */
+ (PYOption *)showMapMarkLine {
    NSString *json = @"{\"backgroundColor\":\"#1b1b1b\",\"color\":[\"gold\",\"aqua\",\"lime\"],\"title\":{\"text\":\"模拟迁徙\",\"subtext\":\"数据纯属虚构\",\"x\":\"center\",\"textStyle\":{\"color\":\"#fff\"}},\"tooltip\":{\"trigger\":\"item\",\"formatter\":\"{b}\"},\"legend\":{\"orient\":\"vertical\",\"x\":\"left\",\"data\":[\"北京 Top10\",\"上海 Top10\",\"广州 Top10\"],\"selectedMode\":\"single\",\"selected\":{\"上海 Top10\":false,\"广州 Top10\":false},\"textStyle\":{\"color\":\"#fff\"}},\"toolbox\":{\"show\":true,\"orient\":\"vertical\",\"x\":\"right\",\"y\":\"center\",\"feature\":{\"mark\":{\"show\":true},\"dataView\":{\"show\":true,\"readOnly\":false},\"restore\":{\"show\":true},\"saveAsImage\":{\"show\":true}}},\"dataRange\":{\"min\":0,\"max\":100,\"calculable\":true,\"color\":[\"#ff3333\",\"orange\",\"yellow\",\"lime\",\"aqua\"],\"textStyle\":{\"color\":\"#fff\"}},\"series\":[{\"name\":\"全国\",\"type\":\"map\",\"roam\":true,\"hoverable\":false,\"mapType\":\"china\",\"itemStyle\":{\"normal\":{\"borderColor\":\"rgba(100,149,237,1)\",\"borderWidth\":0.5,\"areaStyle\":{\"color\":\"#1b1b1b\"}}},\"data\":[],\"markLine\":{\"smooth\":true,\"symbol\":[\"none\",\"circle\"],\"symbolSize\":1,\"itemStyle\":{\"normal\":{\"color\":\"#fff\",\"borderWidth\":1,\"borderColor\":\"rgba(30,144,255,0.5)\"}},\"data\":[[{\"name\":\"北京\"},{\"name\":\"包头\"}],[{\"name\":\"北京\"},{\"name\":\"北海\"}],[{\"name\":\"北京\"},{\"name\":\"广州\"}],[{\"name\":\"北京\"},{\"name\":\"郑州\"}],[{\"name\":\"北京\"},{\"name\":\"长春\"}],[{\"name\":\"北京\"},{\"name\":\"长治\"}],[{\"name\":\"北京\"},{\"name\":\"重庆\"}],[{\"name\":\"北京\"},{\"name\":\"长沙\"}],[{\"name\":\"北京\"},{\"name\":\"成都\"}],[{\"name\":\"北京\"},{\"name\":\"常州\"}],[{\"name\":\"北京\"},{\"name\":\"丹东\"}],[{\"name\":\"北京\"},{\"name\":\"大连\"}],[{\"name\":\"北京\"},{\"name\":\"东营\"}],[{\"name\":\"北京\"},{\"name\":\"延安\"}],[{\"name\":\"北京\"},{\"name\":\"福州\"}],[{\"name\":\"北京\"},{\"name\":\"海口\"}],[{\"name\":\"北京\"},{\"name\":\"呼和浩特\"}],[{\"name\":\"北京\"},{\"name\":\"合肥\"}],[{\"name\":\"北京\"},{\"name\":\"杭州\"}],[{\"name\":\"北京\"},{\"name\":\"哈尔滨\"}],[{\"name\":\"北京\"},{\"name\":\"舟山\"}],[{\"name\":\"北京\"},{\"name\":\"银川\"}],[{\"name\":\"北京\"},{\"name\":\"衢州\"}],[{\"name\":\"北京\"},{\"name\":\"南昌\"}],[{\"name\":\"北京\"},{\"name\":\"昆明\"}],[{\"name\":\"北京\"},{\"name\":\"贵阳\"}],[{\"name\":\"北京\"},{\"name\":\"兰州\"}],[{\"name\":\"北京\"},{\"name\":\"拉萨\"}],[{\"name\":\"北京\"},{\"name\":\"连云港\"}],[{\"name\":\"北京\"},{\"name\":\"临沂\"}],[{\"name\":\"北京\"},{\"name\":\"柳州\"}],[{\"name\":\"北京\"},{\"name\":\"宁波\"}],[{\"name\":\"北京\"},{\"name\":\"南京\"}],[{\"name\":\"北京\"},{\"name\":\"南宁\"}],[{\"name\":\"北京\"},{\"name\":\"南通\"}],[{\"name\":\"北京\"},{\"name\":\"上海\"}],[{\"name\":\"北京\"},{\"name\":\"沈阳\"}],[{\"name\":\"北京\"},{\"name\":\"西安\"}],[{\"name\":\"北京\"},{\"name\":\"汕头\"}],[{\"name\":\"北京\"},{\"name\":\"深圳\"}],[{\"name\":\"北京\"},{\"name\":\"青岛\"}],[{\"name\":\"北京\"},{\"name\":\"济南\"}],[{\"name\":\"北京\"},{\"name\":\"太原\"}],[{\"name\":\"北京\"},{\"name\":\"乌鲁木齐\"}],[{\"name\":\"北京\"},{\"name\":\"潍坊\"}],[{\"name\":\"北京\"},{\"name\":\"威海\"}],[{\"name\":\"北京\"},{\"name\":\"温州\"}],[{\"name\":\"北京\"},{\"name\":\"武汉\"}],[{\"name\":\"北京\"},{\"name\":\"无锡\"}],[{\"name\":\"北京\"},{\"name\":\"厦门\"}],[{\"name\":\"北京\"},{\"name\":\"西宁\"}],[{\"name\":\"北京\"},{\"name\":\"徐州\"}],[{\"name\":\"北京\"},{\"name\":\"烟台\"}],[{\"name\":\"北京\"},{\"name\":\"盐城\"}],[{\"name\":\"北京\"},{\"name\":\"珠海\"}],[{\"name\":\"上海\"},{\"name\":\"包头\"}],[{\"name\":\"上海\"},{\"name\":\"北海\"}],[{\"name\":\"上海\"},{\"name\":\"广州\"}],[{\"name\":\"上海\"},{\"name\":\"郑州\"}],[{\"name\":\"上海\"},{\"name\":\"长春\"}],[{\"name\":\"上海\"},{\"name\":\"重庆\"}],[{\"name\":\"上海\"},{\"name\":\"长沙\"}],[{\"name\":\"上海\"},{\"name\":\"成都\"}],[{\"name\":\"上海\"},{\"name\":\"丹东\"}],[{\"name\":\"上海\"},{\"name\":\"大连\"}],[{\"name\":\"上海\"},{\"name\":\"福州\"}],[{\"name\":\"上海\"},{\"name\":\"海口\"}],[{\"name\":\"上海\"},{\"name\":\"呼和浩特\"}],[{\"name\":\"上海\"},{\"name\":\"合肥\"}],[{\"name\":\"上海\"},{\"name\":\"哈尔滨\"}],[{\"name\":\"上海\"},{\"name\":\"舟山\"}],[{\"name\":\"上海\"},{\"name\":\"银川\"}],[{\"name\":\"上海\"},{\"name\":\"南昌\"}],[{\"name\":\"上海\"},{\"name\":\"昆明\"}],[{\"name\":\"上海\"},{\"name\":\"贵阳\"}],[{\"name\":\"上海\"},{\"name\":\"兰州\"}],[{\"name\":\"上海\"},{\"name\":\"拉萨\"}],[{\"name\":\"上海\"},{\"name\":\"连云港\"}],[{\"name\":\"上海\"},{\"name\":\"临沂\"}],[{\"name\":\"上海\"},{\"name\":\"柳州\"}],[{\"name\":\"上海\"},{\"name\":\"宁波\"}],[{\"name\":\"上海\"},{\"name\":\"南宁\"}],[{\"name\":\"上海\"},{\"name\":\"北京\"}],[{\"name\":\"上海\"},{\"name\":\"沈阳\"}],[{\"name\":\"上海\"},{\"name\":\"秦皇岛\"}],[{\"name\":\"上海\"},{\"name\":\"西安\"}],[{\"name\":\"上海\"},{\"name\":\"石家庄\"}],[{\"name\":\"上海\"},{\"name\":\"汕头\"}],[{\"name\":\"上海\"},{\"name\":\"深圳\"}],[{\"name\":\"上海\"},{\"name\":\"青岛\"}],[{\"name\":\"上海\"},{\"name\":\"济南\"}],[{\"name\":\"上海\"},{\"name\":\"天津\"}],[{\"name\":\"上海\"},{\"name\":\"太原\"}],[{\"name\":\"上海\"},{\"name\":\"乌鲁木齐\"}],[{\"name\":\"上海\"},{\"name\":\"潍坊\"}],[{\"name\":\"上海\"},{\"name\":\"威海\"}],[{\"name\":\"上海\"},{\"name\":\"温州\"}],[{\"name\":\"上海\"},{\"name\":\"武汉\"}],[{\"name\":\"上海\"},{\"name\":\"厦门\"}],[{\"name\":\"上海\"},{\"name\":\"西宁\"}],[{\"name\":\"上海\"},{\"name\":\"徐州\"}],[{\"name\":\"上海\"},{\"name\":\"烟台\"}],[{\"name\":\"上海\"},{\"name\":\"珠海\"}],[{\"name\":\"广州\"},{\"name\":\"北海\"}],[{\"name\":\"广州\"},{\"name\":\"郑州\"}],[{\"name\":\"广州\"},{\"name\":\"长春\"}],[{\"name\":\"广州\"},{\"name\":\"重庆\"}],[{\"name\":\"广州\"},{\"name\":\"长沙\"}],[{\"name\":\"广州\"},{\"name\":\"成都\"}],[{\"name\":\"广州\"},{\"name\":\"常州\"}],[{\"name\":\"广州\"},{\"name\":\"大连\"}],[{\"name\":\"广州\"},{\"name\":\"福州\"}],[{\"name\":\"广州\"},{\"name\":\"海口\"}],[{\"name\":\"广州\"},{\"name\":\"呼和浩特\"}],[{\"name\":\"广州\"},{\"name\":\"合肥\"}],[{\"name\":\"广州\"},{\"name\":\"杭州\"}],[{\"name\":\"广州\"},{\"name\":\"哈尔滨\"}],[{\"name\":\"广州\"},{\"name\":\"舟山\"}],[{\"name\":\"广州\"},{\"name\":\"银川\"}],[{\"name\":\"广州\"},{\"name\":\"南昌\"}],[{\"name\":\"广州\"},{\"name\":\"昆明\"}],[{\"name\":\"广州\"},{\"name\":\"贵阳\"}],[{\"name\":\"广州\"},{\"name\":\"兰州\"}],[{\"name\":\"广州\"},{\"name\":\"拉萨\"}],[{\"name\":\"广州\"},{\"name\":\"连云港\"}],[{\"name\":\"广州\"},{\"name\":\"临沂\"}],[{\"name\":\"广州\"},{\"name\":\"柳州\"}],[{\"name\":\"广州\"},{\"name\":\"宁波\"}],[{\"name\":\"广州\"},{\"name\":\"南京\"}],[{\"name\":\"广州\"},{\"name\":\"南宁\"}],[{\"name\":\"广州\"},{\"name\":\"南通\"}],[{\"name\":\"广州\"},{\"name\":\"北京\"}],[{\"name\":\"广州\"},{\"name\":\"上海\"}],[{\"name\":\"广州\"},{\"name\":\"沈阳\"}],[{\"name\":\"广州\"},{\"name\":\"西安\"}],[{\"name\":\"广州\"},{\"name\":\"石家庄\"}],[{\"name\":\"广州\"},{\"name\":\"汕头\"}],[{\"name\":\"广州\"},{\"name\":\"青岛\"}],[{\"name\":\"广州\"},{\"name\":\"济南\"}],[{\"name\":\"广州\"},{\"name\":\"天津\"}],[{\"name\":\"广州\"},{\"name\":\"太原\"}],[{\"name\":\"广州\"},{\"name\":\"乌鲁木齐\"}],[{\"name\":\"广州\"},{\"name\":\"温州\"}],[{\"name\":\"广州\"},{\"name\":\"武汉\"}],[{\"name\":\"广州\"},{\"name\":\"无锡\"}],[{\"name\":\"广州\"},{\"name\":\"厦门\"}],[{\"name\":\"广州\"},{\"name\":\"西宁\"}],[{\"name\":\"广州\"},{\"name\":\"徐州\"}],[{\"name\":\"广州\"},{\"name\":\"烟台\"}],[{\"name\":\"广州\"},{\"name\":\"盐城\"}]]},\"geoCoord\":{\"上海\":[121.4648,31.2891],\"东莞\":[113.8953,22.901],\"东营\":[118.7073,37.5513],\"中山\":[113.4229,22.478],\"临汾\":[111.4783,36.1615],\"临沂\":[118.3118,35.2936],\"丹东\":[124.541,40.4242],\"丽水\":[119.5642,28.1854],\"乌鲁木齐\":[87.9236,43.5883],\"佛山\":[112.8955,23.1097],\"保定\":[115.0488,39.0948],\"兰州\":[103.5901,36.3043],\"包头\":[110.3467,41.4899],\"北京\":[116.4551,40.2539],\"北海\":[109.314,21.6211],\"南京\":[118.8062,31.9208],\"南宁\":[108.479,23.1152],\"南昌\":[116.0046,28.6633],\"南通\":[121.1023,32.1625],\"厦门\":[118.1689,24.6478],\"台州\":[121.1353,28.6688],\"合肥\":[117.29,32.0581],\"呼和浩特\":[111.4124,40.4901],\"咸阳\":[108.4131,34.8706],\"哈尔滨\":[127.9688,45.368],\"唐山\":[118.4766,39.6826],\"嘉兴\":[120.9155,30.6354],\"大同\":[113.7854,39.8035],\"大连\":[122.2229,39.4409],\"天津\":[117.4219,39.4189],\"太原\":[112.3352,37.9413],\"威海\":[121.9482,37.1393],\"宁波\":[121.5967,29.6466],\"宝鸡\":[107.1826,34.3433],\"宿迁\":[118.5535,33.7775],\"常州\":[119.4543,31.5582],\"广州\":[113.5107,23.2196],\"廊坊\":[116.521,39.0509],\"延安\":[109.1052,36.4252],\"张家口\":[115.1477,40.8527],\"徐州\":[117.5208,34.3268],\"德州\":[116.6858,37.2107],\"惠州\":[114.6204,23.1647],\"成都\":[103.9526,30.7617],\"扬州\":[119.4653,32.8162],\"承德\":[117.5757,41.4075],\"拉萨\":[91.1865,30.1465],\"无锡\":[120.3442,31.5527],\"日照\":[119.2786,35.5023],\"昆明\":[102.9199,25.4663],\"杭州\":[119.5313,29.8773],\"枣庄\":[117.323,34.8926],\"柳州\":[109.3799,24.9774],\"株洲\":[113.5327,27.0319],\"武汉\":[114.3896,30.6628],\"汕头\":[117.1692,23.3405],\"江门\":[112.6318,22.1484],\"沈阳\":[123.1238,42.1216],\"沧州\":[116.8286,38.2104],\"河源\":[114.917,23.9722],\"泉州\":[118.3228,25.1147],\"泰安\":[117.0264,36.0516],\"泰州\":[120.0586,32.5525],\"济南\":[117.1582,36.8701],\"济宁\":[116.8286,35.3375],\"海口\":[110.3893,19.8516],\"淄博\":[118.0371,36.6064],\"淮安\":[118.927,33.4039],\"深圳\":[114.5435,22.5439],\"清远\":[112.9175,24.3292],\"温州\":[120.498,27.8119],\"渭南\":[109.7864,35.0299],\"湖州\":[119.8608,30.7782],\"湘潭\":[112.5439,27.7075],\"滨州\":[117.8174,37.4963],\"潍坊\":[119.0918,36.524],\"烟台\":[120.7397,37.5128],\"玉溪\":[101.9312,23.8898],\"珠海\":[113.7305,22.1155],\"盐城\":[120.2234,33.5577],\"盘锦\":[121.9482,41.0449],\"石家庄\":[114.4995,38.1006],\"福州\":[119.4543,25.9222],\"秦皇岛\":[119.2126,40.0232],\"绍兴\":[120.564,29.7565],\"聊城\":[115.9167,36.4032],\"肇庆\":[112.1265,23.5822],\"舟山\":[122.2559,30.2234],\"苏州\":[120.6519,31.3989],\"莱芜\":[117.6526,36.2714],\"菏泽\":[115.6201,35.2057],\"营口\":[122.4316,40.4297],\"葫芦岛\":[120.1575,40.578],\"衡水\":[115.8838,37.7161],\"衢州\":[118.6853,28.8666],\"西宁\":[101.4038,36.8207],\"西安\":[109.1162,34.2004],\"贵阳\":[106.6992,26.7682],\"连云港\":[119.1248,34.552],\"邢台\":[114.8071,37.2821],\"邯郸\":[114.4775,36.535],\"郑州\":[113.4668,34.6234],\"鄂尔多斯\":[108.9734,39.2487],\"重庆\":[107.7539,30.1904],\"金华\":[120.0037,29.1028],\"铜川\":[109.0393,35.1947],\"银川\":[106.3586,38.1775],\"镇江\":[119.4763,31.9702],\"长春\":[125.8154,44.2584],\"长沙\":[113.0823,28.2568],\"长治\":[112.8625,36.4746],\"阳泉\":[113.4778,38.0951],\"青岛\":[120.4651,36.3373],\"韶关\":[113.7964,24.7028]}},{\"name\":\"北京 Top10\",\"type\":\"map\",\"mapType\":\"china\",\"data\":[],\"markLine\":{\"smooth\":true,\"effect\":{\"show\":true,\"scaleSize\":1,\"period\":30,\"color\":\"#fff\",\"shadowBlur\":10},\"itemStyle\":{\"normal\":{\"borderWidth\":1,\"lineStyle\":{\"type\":\"solid\",\"shadowBlur\":10}}},\"data\":[[{\"name\":\"北京\"},{\"name\":\"上海\",\"value\":95}],[{\"name\":\"北京\"},{\"name\":\"广州\",\"value\":90}],[{\"name\":\"北京\"},{\"name\":\"大连\",\"value\":80}],[{\"name\":\"北京\"},{\"name\":\"南宁\",\"value\":70}],[{\"name\":\"北京\"},{\"name\":\"南昌\",\"value\":60}],[{\"name\":\"北京\"},{\"name\":\"拉萨\",\"value\":50}],[{\"name\":\"北京\"},{\"name\":\"长春\",\"value\":40}],[{\"name\":\"北京\"},{\"name\":\"包头\",\"value\":30}],[{\"name\":\"北京\"},{\"name\":\"重庆\",\"value\":20}],[{\"name\":\"北京\"},{\"name\":\"常州\",\"value\":10}]]},\"markPoint\":{\"symbol\":\"emptyCircle\",\"symbolSize\":\"(function (v){return 10 + v/10})\",\"effect\":{\"show\":true,\"shadowBlur\":0},\"itemStyle\":{\"normal\":{\"label\":{\"show\":false}},\"emphasis\":{\"label\":{\"position\":\"top\"}}},\"data\":[{\"name\":\"上海\",\"value\":95},{\"name\":\"广州\",\"value\":90},{\"name\":\"大连\",\"value\":80},{\"name\":\"南宁\",\"value\":70},{\"name\":\"南昌\",\"value\":60},{\"name\":\"拉萨\",\"value\":50},{\"name\":\"长春\",\"value\":40},{\"name\":\"包头\",\"value\":30},{\"name\":\"重庆\",\"value\":20},{\"name\":\"常州\",\"value\":10}]}},{\"name\":\"上海 Top10\",\"type\":\"map\",\"mapType\":\"china\",\"data\":[],\"markLine\":{\"smooth\":true,\"effect\":{\"show\":true,\"scaleSize\":1,\"period\":30,\"color\":\"#fff\",\"shadowBlur\":10},\"itemStyle\":{\"normal\":{\"borderWidth\":1,\"lineStyle\":{\"type\":\"solid\",\"shadowBlur\":10}}},\"data\":[[{\"name\":\"上海\"},{\"name\":\"包头\",\"value\":95}],[{\"name\":\"上海\"},{\"name\":\"昆明\",\"value\":90}],[{\"name\":\"上海\"},{\"name\":\"广州\",\"value\":80}],[{\"name\":\"上海\"},{\"name\":\"郑州\",\"value\":70}],[{\"name\":\"上海\"},{\"name\":\"长春\",\"value\":60}],[{\"name\":\"上海\"},{\"name\":\"重庆\",\"value\":50}],[{\"name\":\"上海\"},{\"name\":\"长沙\",\"value\":40}],[{\"name\":\"上海\"},{\"name\":\"北京\",\"value\":30}],[{\"name\":\"上海\"},{\"name\":\"丹东\",\"value\":20}],[{\"name\":\"上海\"},{\"name\":\"大连\",\"value\":10}]]},\"markPoint\":{\"symbol\":\"emptyCircle\",\"symbolSize\":\"(function (v){return 10 + v/10})\",\"effect\":{\"show\":true,\"shadowBlur\":0},\"itemStyle\":{\"normal\":{\"label\":{\"show\":false}},\"emphasis\":{\"label\":{\"position\":\"top\"}}},\"data\":[{\"name\":\"包头\",\"value\":95},{\"name\":\"昆明\",\"value\":90},{\"name\":\"广州\",\"value\":80},{\"name\":\"郑州\",\"value\":70},{\"name\":\"长春\",\"value\":60},{\"name\":\"重庆\",\"value\":50},{\"name\":\"长沙\",\"value\":40},{\"name\":\"北京\",\"value\":30},{\"name\":\"丹东\",\"value\":20},{\"name\":\"大连\",\"value\":10}]}},{\"name\":\"广州 Top10\",\"type\":\"map\",\"mapType\":\"china\",\"data\":[],\"markLine\":{\"smooth\":true,\"effect\":{\"show\":true,\"scaleSize\":1,\"period\":30,\"color\":\"#fff\",\"shadowBlur\":10},\"itemStyle\":{\"normal\":{\"borderWidth\":1,\"lineStyle\":{\"type\":\"solid\",\"shadowBlur\":10}}},\"data\":[[{\"name\":\"广州\"},{\"name\":\"福州\",\"value\":95}],[{\"name\":\"广州\"},{\"name\":\"太原\",\"value\":90}],[{\"name\":\"广州\"},{\"name\":\"长春\",\"value\":80}],[{\"name\":\"广州\"},{\"name\":\"重庆\",\"value\":70}],[{\"name\":\"广州\"},{\"name\":\"西安\",\"value\":60}],[{\"name\":\"广州\"},{\"name\":\"成都\",\"value\":50}],[{\"name\":\"广州\"},{\"name\":\"常州\",\"value\":40}],[{\"name\":\"广州\"},{\"name\":\"北京\",\"value\":30}],[{\"name\":\"广州\"},{\"name\":\"北海\",\"value\":20}],[{\"name\":\"广州\"},{\"name\":\"海口\",\"value\":10}]]},\"markPoint\":{\"symbol\":\"emptyCircle\",\"symbolSize\":\"(function (v){return 10 + v/10})\",\"effect\":{\"show\":true,\"shadowBlur\":0},\"itemStyle\":{\"normal\":{\"label\":{\"show\":false}},\"emphasis\":{\"label\":{\"position\":\"top\"}}},\"data\":[{\"name\":\"福州\",\"value\":95},{\"name\":\"太原\",\"value\":90},{\"name\":\"长春\",\"value\":80},{\"name\":\"重庆\",\"value\":70},{\"name\":\"西安\",\"value\":60},{\"name\":\"成都\",\"value\":50},{\"name\":\"常州\",\"value\":40},{\"name\":\"北京\",\"value\":30},{\"name\":\"北海\",\"value\":20},{\"name\":\"海口\",\"value\":10}]}}]}";
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    //详情见文件 mapMarkLine.geojson
    NSLog(@"%@",jsonDic);//[NSString stringWithFormat:@"%@",jsonDic]
    
    
    return [PYOption initPYOptionWithBlock:^(PYOption *option) {
        option.titleEqual([PYTitle initPYTitleWithBlock:^(PYTitle *title) {
            title.xEqual(PYPositionCenter).textEqual(@"模拟迁徙")
            .textStyleEqual([PYTextStyle initPYTextStyleWithBlock:^(PYTextStyle *textStyle) {
                textStyle.colorEqual(@"#fff");
            }]);
        }]);
        option.legendEqual([PYLegend initPYLegendWithBlock:^(PYLegend *legend) {
            legend.xEqual(PYPositionLeft).orientEqual(PYOrientVertical).selectedModeEqual(@"single")
            .textStyleEqual([PYTextStyle initPYTextStyleWithBlock:^(PYTextStyle *textStyle) {
                textStyle.colorEqual(@"#fff");
            }])
            .dataEqual(@[@"北京 Top10",@"上海 Top10",@"广州 Top10"])
            .selectedEqual(@{@"上海 Top10":@(false),@"广州 Top10":@(false)})
            .selectedModeEqual(@"single");
        }])
        .backgroundColorEqual([PYColor colorWithHexString:@"#1b1b1b"]);
//        option.colorEqual(@[@"gold",@"aqua",@"lime"]);
        option.tooltipEqual([PYTooltip initPYTooltipWithBlock:^(PYTooltip *tooltip) {
            tooltip.triggerEqual(PYTooltipTriggerItem)
            .formatterEqual(@"{b}");
        }]);
        option.dataRangeEqual([PYDataRange initPYDataRangeWithBlock:^(PYDataRange *dataRange) {
            dataRange.minEqual(@0).maxEqual(@100).calculableEqual(@(true));
            dataRange.textStyleEqual([PYTextStyle initPYTextStyleWithBlock:^(PYTextStyle *textStyle) {
                textStyle.colorEqual(@"#fff");
            }]);
            dataRange.colorEqual([NSMutableArray arrayWithArray:@[@"#ff3333",@"orange",@"yellow",@"lime",@"aqua"]]);
        }]);/**/
        //series1
        option.addSeries([PYMapSeries initPYMapSeriesWithBlock:^(PYMapSeries *series) {
            series.nameEqual(@"全国")
            .typeEqual(PYSeriesTypeMap);
            series.mapTypeEqual(@"china").hoverableEqual(@(false));//.roamEqual(@(true));
            series.itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                    itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
                        label.showEqual(NO);
                    }]);
                    itemStyleProp.borderColorEqual(PYRGBA(100, 149, 237, 1));
                    itemStyleProp.borderWidthEqual(@0.5);
                    itemStyleProp.areaStyleEqual([PYAreaStyle initPYAreaStyleWithBlock:^(PYAreaStyle *areaStyle) {
                        areaStyle.colorEqual(@"#1b1b1b");
                    }]);
                }]);
            }]);
            series.markLineEqual([PYMarkLine initPYMarkLineWithBlock:^(PYMarkLine *markLine) {
                markLine.symbolSizeEqual(@1).smoothEqual(@(true));
                markLine.itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                    itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                        itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
                            label.showEqual(NO);
                        }]);
                        itemStyleProp.colorEqual(@"#fff");
                        itemStyleProp.borderColorEqual(PYRGBA(30, 144, 255, 0.5));
                        itemStyleProp.borderWidthEqual(@1);
                    }]);
                }]);
                markLine.symbolEqual(@[@"none",@"circle"]);
                NSArray *datas = jsonDic[@"series"][0][@"markLine"][@"data"];
                markLine.dataEqual([NSMutableArray arrayWithArray:datas]);
            }]);
            NSDictionary *geoCoordDic = jsonDic[@"series"][0][@"geoCoord"];
            series.geoCoordEqual(geoCoordDic);
//            series.dataEqual(@[]);
        }]);
        //series2
        
        option.addSeries([PYMapSeries initPYMapSeriesWithBlock:^(PYMapSeries *series) {
            series.nameEqual(@"北京 Top10")
            .typeEqual(PYSeriesTypeMap);
            series.mapTypeEqual(@"china");
//            series.itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
//                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
//                    itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
//                        label.showEqual(NO);
//                    }]);
//                    itemStyleProp.borderColorEqual(PYRGBA(100, 149, 237, 1));
//                    itemStyleProp.borderWidthEqual(@0.5);
//                    itemStyleProp.areaStyleEqual([PYAreaStyle initPYAreaStyleWithBlock:^(PYAreaStyle *areaStyle) {
//                        areaStyle.colorEqual(@"#1b1b1b");
//                    }]);
//                }]);
//            }]);
            series.markLineEqual([PYMarkLine initPYMarkLineWithBlock:^(PYMarkLine *markLine) {
                markLine.smoothEqual(@(true));
                markLine.itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                    itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                        itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
                            label.showEqual(NO);
                        }]);
                        itemStyleProp.borderWidthEqual(@1);
                        itemStyleProp.lineStyleEqual([PYLineStyle initPYLineStyleWithBlock:^(PYLineStyle *lineStyle) {
                            lineStyle.typeEqual(PYLineStyleTypeSolid).shadowBlurEqual(@10);
                        }]);
                    }]);
                }]);
                markLine.effectEqual([PYMarkLineEffect initPYMarkLineEffectWithBlock:^(PYMarkLineEffect *effect) {
                    effect.loopEqual(YES);//是否循环动画
                    effect.showEqual(YES).shadowBlurEqual(@10).periodEqual(@30).scaleSizeEqual(@1)
                    .colorEqual([PYColor colorWithHexString:@"#fff"]);
                }]);
                NSArray *datas = jsonDic[@"series"][1][@"markLine"][@"data"];
                markLine.dataEqual([NSMutableArray arrayWithArray:datas]);
            }]);
            series.markPointEqual([PYMarkPoint initPYMarkPointWithBlock:^(PYMarkPoint *point) {
                point.itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                    itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                        itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
                            label.showEqual(NO);
                        }]);
                    }]);
                    itemStyle.emphasisEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                        itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
                            label.showEqual(YES)
                            .positionEqual(PYPositionTop);
                        }]);
                    }]);
                }]);
                point.symbolSizeEqual(@"(function (v){return 10 + v/10})");
                point.symbolEqual(@"emptyCircle");
                point.effectEqual([PYMarkPointEffect initPYMarkPointEffectWithBlock:^(PYMarkPointEffect *effect) {
                    effect.loopEqual(YES);//是否循环动画
                    effect.showEqual(YES).shadowBlurEqual(@0);
                }]);
                NSArray *datas = jsonDic[@"series"][1][@"markPoint"][@"data"];
                point.dataEqual([NSMutableArray arrayWithArray:datas]);
            }]);
//            series.dataEqual(@[]);
        }]);
        
        //series3
        option.addSeries([PYMapSeries initPYMapSeriesWithBlock:^(PYMapSeries *series) {
            series.nameEqual(@"上海 Top10")
            .typeEqual(PYSeriesTypeMap);
            series.mapTypeEqual(@"china");
//            series.itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
//                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
//                    itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
//                        label.showEqual(NO);
//                    }]);
//                    itemStyleProp.borderColorEqual(PYRGBA(100, 149, 237, 1));
//                    itemStyleProp.borderWidthEqual(@0.5);
//                    itemStyleProp.areaStyleEqual([PYAreaStyle initPYAreaStyleWithBlock:^(PYAreaStyle *areaStyle) {
//                        areaStyle.colorEqual(@"#1b1b1b");
//                    }]);
//                }]);
//            }]);
            series.markLineEqual([PYMarkLine initPYMarkLineWithBlock:^(PYMarkLine *markLine) {
                markLine.smoothEqual(@(true));
                markLine.itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                    itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                        itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
                            label.showEqual(NO);
                        }]);
                        itemStyleProp.borderWidthEqual(@1);
                        itemStyleProp.lineStyleEqual([PYLineStyle initPYLineStyleWithBlock:^(PYLineStyle *lineStyle) {
                            lineStyle.typeEqual(PYLineStyleTypeSolid).shadowBlurEqual(@10);
                        }]);
                    }]);

                }]);
                markLine.effectEqual([PYMarkLineEffect initPYMarkLineEffectWithBlock:^(PYMarkLineEffect *effect) {
                    effect.loopEqual(YES);//是否循环动画
                    effect.showEqual(YES).shadowBlurEqual(@10).periodEqual(@30).scaleSizeEqual(@1)
                    .colorEqual([PYColor colorWithHexString:@"#fff"]);
                }]);
                NSArray *datas = jsonDic[@"series"][2][@"markLine"][@"data"];
                markLine.dataEqual([NSMutableArray arrayWithArray:datas]);
            }]);
            series.markPointEqual([PYMarkPoint initPYMarkPointWithBlock:^(PYMarkPoint *point) {
                point.itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                    itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                        itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
                            label.showEqual(NO);
                        }]);
                    }]);
                    itemStyle.emphasisEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                        itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
                            label.showEqual(YES)
                            .positionEqual(PYPositionTop);
                        }]);
                    }]);
                }]);
                point.symbolSizeEqual(@"(function (v){return 10 + v/10})");
                point.symbolEqual(@"emptyCircle");
                point.effectEqual([PYMarkPointEffect initPYMarkPointEffectWithBlock:^(PYMarkPointEffect *effect) {
                    effect.loopEqual(YES);//是否循环动画
                    effect.showEqual(YES).shadowBlurEqual(@0);
                }]);
                NSArray *datas = jsonDic[@"series"][2][@"markPoint"][@"data"];
                point.dataEqual([NSMutableArray arrayWithArray:datas]);
            }]);
//            series.dataEqual(@[]);
        }]);

        //series4
        option.addSeries([PYMapSeries initPYMapSeriesWithBlock:^(PYMapSeries *series) {
            series.nameEqual(@"广州 Top10")
            .typeEqual(PYSeriesTypeMap);
            series.mapTypeEqual(@"china");
            //            series.itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
            //                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
            //                    itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
            //                        label.showEqual(NO);
            //                    }]);
            //                    itemStyleProp.borderColorEqual(PYRGBA(100, 149, 237, 1));
            //                    itemStyleProp.borderWidthEqual(@0.5);
            //                    itemStyleProp.areaStyleEqual([PYAreaStyle initPYAreaStyleWithBlock:^(PYAreaStyle *areaStyle) {
            //                        areaStyle.colorEqual(@"#1b1b1b");
            //                    }]);
            //                }]);
            //            }]);
            series.markLineEqual([PYMarkLine initPYMarkLineWithBlock:^(PYMarkLine *markLine) {
                markLine.smoothEqual(@(true));
                markLine.itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                    itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                        itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
                            label.showEqual(NO);
                        }]);
                        itemStyleProp.borderWidthEqual(@1);
                        itemStyleProp.lineStyleEqual([PYLineStyle initPYLineStyleWithBlock:^(PYLineStyle *lineStyle) {
                            lineStyle.typeEqual(PYLineStyleTypeSolid).shadowBlurEqual(@10);
                        }]);
                    }]);
                }]);
                markLine.effectEqual([PYMarkLineEffect initPYMarkLineEffectWithBlock:^(PYMarkLineEffect *effect) {
                    effect.loopEqual(YES);//是否循环动画
                    effect.showEqual(YES).shadowBlurEqual(@10).periodEqual(@30).scaleSizeEqual(@1)
                    .colorEqual([PYColor colorWithHexString:@"#fff"]);
                }]);
                NSArray *datas = jsonDic[@"series"][3][@"markLine"][@"data"];
                markLine.dataEqual([NSMutableArray arrayWithArray:datas]);
            }]);
            series.markPointEqual([PYMarkPoint initPYMarkPointWithBlock:^(PYMarkPoint *point) {
                point.itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                    itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                        itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
                            label.showEqual(NO);
                        }]);
                    }]);
                    itemStyle.emphasisEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp) {
                        itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
                            label.showEqual(YES)
                            .positionEqual(PYPositionTop);
                        }]);
                    }]);
                }]);
                point.symbolSizeEqual(@"(function (v){return 10 + v/10})");
                point.symbolEqual(@"emptyCircle");
                point.effectEqual([PYMarkPointEffect initPYMarkPointEffectWithBlock:^(PYMarkPointEffect *effect) {
                    effect.loopEqual(YES);//是否循环动画
                    effect.showEqual(YES).shadowBlurEqual(@0);
                }]);
                NSArray *datas = jsonDic[@"series"][3][@"markPoint"][@"data"];
                point.dataEqual([NSMutableArray arrayWithArray:datas]);
            }]);
//            series.dataEqual(@[]);
        }]);

    }];
    
//    PYOption *option = [RMMapper objectWithClass:[PYOption class] fromDictionary:jsonDic];
//    return option;
}


@end





