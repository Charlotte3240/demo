//
//  ContentView.swift
//  Calc
//
//  Created by Charlotte on 2023/6/13.
//

import SwiftUI

struct ContentView: View {
    let scale : CGFloat = UIScreen.main.bounds.size.width / 414
    
//    @State private var brain : CalculatorBrain = .left("0")
    @ObservedObject var model = CalculatorModel()
    
    var body: some View {
        VStack (spacing:12){
            Spacer()
            Button("history\(model.history.count)"){
                debugPrint(model.history)
            }
            Text(model.brain.output)
                .font(.system(size: 76))
                .minimumScaleFactor(0.5)
                .padding(.trailing,24)
                .frame(minWidth: 0,
                       maxWidth: .infinity,
                       alignment:.trailing
                )
                .lineLimit(1)
            CalculatorPad(model:self.model)
                .padding(.bottom)
        }
        .scaleEffect(self.scale)
    }
}




struct CalculatorButton: View {
//    @Binding var brain : CalculatorBrain
    var model : CalculatorModel
    
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
        }
    }
}

struct CalculatorButtonRow: View {
//    @Binding var brain : CalculatorBrain
    var model : CalculatorModel
    let row : [CalculatorButtonItem]
    var body: some View {
        HStack {
            ForEach(row ,id: \.self) { item in
                CalculatorButton(model: model, fontSize:item.scale * 38,title: item.title, size: item.size, foregroundColorName: item.foregroundColorname, backgroundColorName: item.backgroundColorName) {
                    print("\(item.title) click")
//                    self.brain = self.brain.apply(item: item)
                    self.model.apply(item)
                }
            }
        }
    }
}

struct CalculatorPad: View {
//    @Binding var brain : CalculatorBrain
    var model : CalculatorModel
//    let scale : CGFloat
    let pad : [[CalculatorButtonItem]] = [
        [.command(.clear),.command(.flip),.command(.percent),.op(.divide)],
        [.digit(7),.digit(8),.digit(9),.op(.multiply)],
        [.digit(4),.digit(5),.digit(6),.op(.minus)],
        [.digit(1),.digit(2),.digit(3),.op(.plus)],
        [.digit(0),.dot,.op(.equal)]
    ]
    var body: some View {
        VStack(spacing: 8) {
            ForEach(pad , id: \.self){row in
                CalculatorButtonRow(model: model, row: row)
            }
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
