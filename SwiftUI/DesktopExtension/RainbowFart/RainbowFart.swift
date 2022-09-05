//
//  RainbowFart.swift
//  RainbowFart
//
//  Created by 360-jr on 2022/8/23.
//

import WidgetKit
import SwiftUI

@main
struct AllWidget : WidgetBundle{
    @Environment(\.widgetFamily) var family : WidgetFamily
    @WidgetBundleBuilder
    var body: some Widget{
        RainbowFartWidgetSmall()
        RainbowFartWidgetLarge()
    }
}


//MARK: - widget
struct RainbowFartWidgetSmall: Widget {
    @Environment(\.widgetFamily) var family : WidgetFamily
    let kind: String = "RainbowFartSmall"
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: RainbowFartIntent.self, provider: Provider()) { entry in
            RainbowFartEntryView(entry: entry)
        }
        .configurationDisplayName("RainbowFartSmall Widget")
        .description("This is an small widget.")
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
        .configurationDisplayName("RainbowFartLarge Widget")
        .description("This is an large widget.")
        .supportedFamilies([.systemMedium,.systemLarge,.systemExtraLarge])
    }
}




//MARK: - Provider

struct Provider: IntentTimelineProvider {

    func placeholder(in context: Context) -> RainbowFartEntry {
        let rainbowFart = RainbowFart(data: RData(type: "彩虹屁",text: "窗前明月光，疑似地上霜"))
        return RainbowFartEntry(date: Date(),fart: rainbowFart, configuration: RainbowFartIntent())
    }
    
    func getSnapshot(for configuration: RainbowFartIntent, in context: Context, completion: @escaping (RainbowFartEntry) -> ()) {
        let rainbowFart = RainbowFart(data: RData(type: "彩虹屁",text: "窗前明月光，疑似地上霜"))
        let entry = RainbowFartEntry(date: Date(),fart: rainbowFart, configuration: configuration)
        completion(entry)

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
                }else{
                    let rainbowFart = RainbowFart(data: RData(type: "彩虹屁",text: "窗前明月光，疑似地上霜"))
                    entry = RainbowFartEntry(date: updateDate,fart: rainbowFart, configuration: configuration)
                }
                entrys.append(entry)
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
        return caihongpi
    }
    
    static func getImage() -> UIImage{
        if let imageData = try? Data(contentsOf: URL(string: "http://cdn.ivy4ever.com/tuchuang/IMG_5253.GIF")!){
            return UIImage(data: imageData) ?? UIImage()
        }
        return UIImage()
    }
}



//MARK: - View

public let backGroundLine : LinearGradient = LinearGradient(gradient: Gradient(colors: [.init(red: Double(144 / 255.0), green: Double(252 / 255.0), blue: Double(231 / 255.0)), .init(red: Double(50 / 204), green: Double(188 / 255.0), blue: Double(231 / 255.0))]), startPoint: .topLeading, endPoint: .bottomTrailing)


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
                    Text(entry.configuration.inputTitle ?? "输入的标题")
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

        }
    }
}

import Intents
class IntentsConifg : INIntent{
    
}
