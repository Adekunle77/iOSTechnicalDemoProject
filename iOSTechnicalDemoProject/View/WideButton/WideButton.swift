//
//  WideButton.swift
//  iOSTechnicalDemoProject
//
//  Created by Ade Adegoke on 27/03/2024.
//

import SwiftUI

typealias BorderSytle = (color: Color, width: Double)

struct WideButton: View {
    var backgroundColor: Color
    var textColor: Color
    var title: String
    var borderSytle: BorderSytle
    var action: () -> ()
    
    init(backgroundColor: Color,  textColor: Color = Color.black, title: String, borderSytle: BorderSytle = BorderSytle(color: .clear, width: 0.0) , action: @escaping () -> ()) {
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.title = title
        self.borderSytle = borderSytle
        self.action = action
        
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .regular, design: .default))
                .foregroundColor(textColor)
                .frame(width: 343, height: 48.0)
                .border(borderSytle.color, width: borderSytle.width)
                .background(backgroundColor)
            
        }
    }
}

//struct WideButton_Previews: PreviewProvider {
//    static var previews: some View {
//        ForEach(["iPhone 13 Pro","iPhone 6s"], id: \.self) { deviceName in
//            WideButton(backgroundColor: .clear, title: "Wide Button", borderSytle: BorderSytle(Color.black, width: 2.0)) {
//                print("Did tap Wide Button")
//            }
//            .previewDevice(PreviewDevice(rawValue: deviceName))
//            .previewDisplayName(deviceName)
//        }
//    }
//}
