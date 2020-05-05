//
//  ProgressView.swift
//  PDFViewer
//
//  Created by Raju on 4/5/20.
//  Copyright © 2020 Raju. All rights reserved.
//

import SwiftUI

public struct ProgressView: View {
    var value: Binding<Float>
    var visible: Binding<Bool>

    public init(value: Binding<Float>, visible: Binding<Bool>){
        self.value = value
        self.visible = visible
    }
    
    public var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.primary.opacity(0.001))
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.gray)
                Circle()
                    .trim(from: 0, to: CGFloat(value.wrappedValue))
                    .stroke(Color.primary, lineWidth:5)
                    .frame(width:50)
                    .rotationEffect(Angle(degrees:-90))
                Text(getPercentage(value.wrappedValue))
            }.frame(width: 160, height: 120)
        }
        .opacity(visible.wrappedValue ? 1 : 0)
    }
    
    func getPercentage(_ value:Float) -> String {
        let intValue = Int(ceil(value * 100))
        return "\(intValue) %"
    }
}
