//
//  RainbowFart.swift
//  RainbowFart
//
//  Created by Charlotte on 2022/8/23.
//

import WidgetKit
import SwiftUI

private let avatar : UIImage = UIImage(named: "avatar") ?? UIImage()


@main
struct AllWidget : WidgetBundle{
    @Environment(\.widgetFamily) var family : WidgetFamily
    @WidgetBundleBuilder
    var body: some Widget{
        RainbowFartWidgetSmall()
        RainbowFartWidgetLarge()
        SuishenmaAcessCircleWidget()
        XingchengmaAcessCircleWidget()
    }
}


//MARK: - widget

struct SuishenmaAcessCircleWidget : Widget{
    let kind : String = "suishenma"
    var body: some WidgetConfiguration{
        IntentConfiguration(kind: kind, intent:RainbowFartIntent.self, provider: Provider()) { entry in
            SuishenmaView()
        }
        .supportedFamilies([.accessoryCircular])
    }
}
struct XingchengmaAcessCircleWidget : Widget{
    let kind : String = "xingchengma"
    var body: some WidgetConfiguration{
        IntentConfiguration(kind: kind, intent:RainbowFartIntent.self, provider: Provider()) { entry in
            XingchengmaView()
        }
        .supportedFamilies([.accessoryCircular])
    }
}


struct RainbowFartWidgetSmall: Widget {
    @Environment(\.widgetFamily) var family : WidgetFamily
    let kind: String = "RainbowFartSmall"
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: RainbowFartIntent.self, provider: Provider()) { entry in
            RainbowFartEntryView(entry: entry)
        }
        .configurationDisplayName("小号彩虹屁")
        .description("小尺寸显示彩虹屁")
        .supportedFamilies([.systemSmall])
    }
}


struct RainbowFartWidgetLarge: Widget {
    @Environment(\.widgetFamily) var family : WidgetFamily
    let kind: String = "RainbowFartLarge"
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: RainbowFartIntent.self, provider: Provider()) { entry in
            RainbowFartEntryNotSmallView(entry: entry)
        }
        .configurationDisplayName("大号彩虹屁")
        .description("较大尺寸的显示彩虹屁")
        .supportedFamilies([.systemMedium,.systemLarge,.systemExtraLarge])
    }
}




//MARK: - Provider

struct Provider: IntentTimelineProvider {

    func placeholder(in context: Context) -> RainbowFartEntry {
        let rainbowFart = RainbowFart(data: RData(type: "一剪梅",text: "春赏百花冬观雪，醒亦念卿，梦亦念卿"))
        return RainbowFartEntry(date: Date(),fart: rainbowFart, configuration: RainbowFartIntent())
    }
    
    func getSnapshot(for configuration: RainbowFartIntent, in context: Context, completion: @escaping (RainbowFartEntry) -> ()) {
        Task{
            if let data = try? await Api.getContent(){
                let entry = RainbowFartEntry(date: Date(),fart: data, configuration: configuration,image: Api.getImage())
                completion(entry)
            }else{
                let rainbowFart = RainbowFart(data: RData(type: "一剪梅·雨打梨花深闭门",text: "春赏百花冬观雪，醒亦念卿，梦亦念卿"))
                let entry = RainbowFartEntry(date: Date(),fart: rainbowFart, configuration: configuration)
                completion(entry)

            }
        }
    }
    
    func getTimeline(for configuration: RainbowFartIntent, in context: Context, completion: @escaping (Timeline<RainbowFartEntry>) -> ()) {
        let currentDate = Date()
        Task{
            var entrys :[RainbowFartEntry] = [RainbowFartEntry]()
            for _ in 0...5{
                let updateDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate) ?? currentDate
                var entry : RainbowFartEntry
                if let data = try? await Api.getContent(){
                    entry = RainbowFartEntry(date: updateDate,fart: data, configuration: configuration,image: Api.getImage())
                    if data.data?.text?.contains("访问太快") == false{
                        entrys.append(entry)
                    }
                }
            }
            let timeline = Timeline(entries: entrys, policy: .atEnd)
            completion(timeline)
        }
    }

}





//MARK: - Entry
struct RainbowFartEntry: TimelineEntry {
    let date: Date
    var fart : RainbowFart?
    let configuration: RainbowFartIntent
    var image : UIImage = UIImage()

}

//MARK: - API
struct RainbowFart : Codable{
    var data : RData?
}
struct RData : Codable{
    var type : String?
    var text : String?
}

class Api {
    static func getContent() async throws -> RainbowFart{
        let url = "https://api.shadiao.pro/chp?utm_source"
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let (data,_) = try await URLSession.shared.data(for: request)
        let caihongpi = try JSONDecoder().decode(RainbowFart.self, from: data)
        debugPrint(caihongpi)
        return caihongpi
    }
    
    static func getImage() -> UIImage{
//        if let imageData = try? Data(contentsOf: URL(string: "https://cdn.ivy4ever.com/tuchuang/IMG_5253.jpg")!){
//            return UIImage(data: imageData) ?? UIImage()
//        }
        return avatar
    }
}



//MARK: - View

public let backGroundLine : LinearGradient = LinearGradient(gradient: Gradient(colors: [.init(red: Double(144 / 255.0), green: Double(252 / 255.0), blue: Double(231 / 255.0)), .init(red: Double(50 / 204), green: Double(188 / 255.0), blue: Double(231 / 255.0))]), startPoint: .topLeading, endPoint: .bottomTrailing)


struct SuishenmaView : View{
    var body: some View{
        
        Image(uiImage: UIImage.init(named: "jiankangma")!)
            .resizable()
            .frame(width: 50,height: 50)
            .widgetURL(URL(string: "alipays://platformapi/startapp?appId=2019072665939857&page=pages%2Fmy-station-type%2Fmy-station-type"))
    }
    
}
struct XingchengmaView : View{
    var body: some View{
        Image(uiImage: UIImage.init(named: "xingchengma")!)
            .resizable()
            .frame(width: 55,height: 55)
            .widgetURL(URL(string: "alipays://platformapi/startapp?appId=2021002170600786"))
    }
    
}


struct RainbowFartEntryView : View {
    
    @State var entry: RainbowFartEntry

    var body: some View {
        VStack(alignment: .leading){
            Text(entry.fart?.data?.type ?? "类型")
                .font(.system(size: 20))
                .bold()
            Text(entry.fart?.data?.text ?? "内容")
                .font(.system(size: 16))
        }
        .frame(minWidth: 0,maxWidth: .infinity,minHeight: 0,maxHeight: .infinity,alignment: .center)
        .padding()
        .background(backGroundLine)
        .widgetURL(URL(string: "https://www.ivy4ever.com/small")) // small只能用这个
    }
}
struct RainbowFartEntryNotSmallView : View {
    
    @State var entry: RainbowFartEntry
    
    var body: some View {
        HStack {
            
            Image(uiImage: entry.image)
                .resizable()
                .frame(width: 70, height: 70)
                .widgetURL(URL(string: "https://www.ivy4ever.com/imageClick"))
            VStack(alignment: .leading, spacing: 4){
                Link(destination: URL(string: "https://www.ivy4ever.com/buttonClick")!) {
                    Text(entry.configuration.inputTitle ?? "彩虹屁")
                }
                .padding() // 非small 大小的可以用link
                .bold()
                Text(entry.fart?.data?.text ?? "内容")
                    .font(.system(size: 16))
                }
            .widgetURL(URL(string: "https://www.ivy4ever.com/notSmall"))// small只能用这个
        }
        .frame(minWidth: 0,maxWidth: .infinity,minHeight: 0,maxHeight: .infinity,alignment: .center)
        .padding()
        .background(backGroundLine)

    }
}


struct RainbowFartView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            RainbowFartEntryView(entry: RainbowFartEntry(date: Date(), configuration: RainbowFartIntent()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            RainbowFartEntryNotSmallView(entry: RainbowFartEntry(date: Date(), configuration: RainbowFartIntent()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            RainbowFartEntryNotSmallView(entry: RainbowFartEntry(date: Date(), configuration: RainbowFartIntent()))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
            SuishenmaView()
                .previewContext(WidgetPreviewContext(family: .accessoryCircular))

        }
    }
}

import Intents
class IntentsConifg : INIntent{
    
}
