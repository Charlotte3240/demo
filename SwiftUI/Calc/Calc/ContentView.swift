//
//  ContentView.swift
//  Calc
//
//  Created by Charlotte on 2023/6/13.
//

import SwiftUI

struct ContentView: View {
    let scale : CGFloat = UIScreen.main.bounds.size.width / 414
    var body: some View {
        VStack (spacing:12*scale){
            Spacer()
            Text("0")
                .font(.system(size: 76*scale))
                .minimumScaleFactor(0.5)
                .padding(.trailing,24)
                .frame(minWidth: 0,
                       maxWidth: .infinity,
                       alignment:.trailing
//                       maxHeight: .infinity, alignment: .bottomTrailing
                )
                .lineLimit(1)
            CalculatorPad(scale: scale)
                .padding(.bottom)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
//        ContentView().previewDevice("iPhone SE (3rd generation)")
//        ContentView().previewDevice("iPad Air (5th generation)")
    }
}

struct CalculatorButton: View {
    let fontSize : CGFloat
    let title : String
    let size : CGSize
    let foregroundColorName : String
    let backgroundColorName : String
    let action : () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack{
                if title != "0"{
                    Circle()
                        .fill(Color(backgroundColorName))
                        .frame(width: size.width,height: size.height)
                        .overlay {
                            Text(title)
                                .font(.system(size: fontSize))
                                .foregroundColor(Color(foregroundColorName))
                        }
                }else{
                    RoundedRectangle(cornerRadius: size.height/2,style: .continuous)
                        .fill(Color(backgroundColorName))
                        .frame(width: size.width,height: size.height)
                        .overlay {
                            Text(title)
                                .font(.system(size: fontSize))
                                .foregroundColor(Color(foregroundColorName))
                        }
                }

            }

//            Text(title)
//                .foregroundColor(Color(foregroundColorName))
//                .font(.system(size: fontSize))
//                .frame(width: size.width,height: size.height)
//                .background(Color(backgroundColorName))
//                .cornerRadius(size.height/2.0)
        }
    }
}

struct CalculatorButtonRow: View {
    let row : [CalculatorButtonItem]
    var body: some View {
        HStack {
            ForEach(row ,id: \.self) { item in
                CalculatorButton(fontSize:item.scale * 38,title: item.title, size: item.size, foregroundColorName: item.foregroundColorname, backgroundColorName: item.backgroundColorName) {
                    print("\(item.title) click")
                }
            }
        }
    }
}

struct CalculatorPad: View {
    let scale : CGFloat
    let pad : [[CalculatorButtonItem]] = [
        [.command(.clear),.command(.flip),.command(.percent),.op(.divide)],
        [.digit(7),.digit(8),.digit(9),.op(.multipy)],
        [.digit(4),.digit(5),.digit(6),.op(.minus)],
        [.digit(1),.digit(2),.digit(3),.op(.plus)],
        [.digit(0),.dot,.op(.equal)]
    ]
    var body: some View {
        VStack(spacing: 8 * scale) {
            ForEach(pad , id: \.self){row in
                CalculatorButtonRow(row: row)
            }
        }
    }
}
