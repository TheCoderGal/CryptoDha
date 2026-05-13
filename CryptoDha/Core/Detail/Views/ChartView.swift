//
//  CharTView.swift
//  CryptoDha
//
//  Created by Rosh on 03/05/26.
//

import SwiftUI

struct ChartView: View {
    
    let data: [Double]
    let max: Double
    let min: Double
    let lineColor: Color
    
    @State private var percentage = 0.0
    
    init(coin: Coin) {
        self.data = coin.sparklineIn7D?.price ?? []
        self.max = data.max() ?? 0
        self.min = data.min() ?? 0
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange > 0 ? Color.theme.green : Color.theme.red
    }
    
    var body: some View {
        //x-axis: the no of data points
        //y-axis: The data of variation
        
        /* Y-axis:
         max, min, the steps
         data.max(), data.min(), data/noOfDays
         
         ex; 100 data points: Screenwidth/300 * (index+1)
         300 - width
         300/100 = 3 points on x.
         1*3
         2*3
         3*3
         
         min = 52341
         max = 57328
         
         yAxis = 5000
         
         ypos = (data[index] - min)/5000
         */
        VStack {
            lineChart
                .frame(height: 250)
                .background(yAxisGrid)
                .overlay(alignment: .leading) {
                    yAxisLabels
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now()+3.0, execute: {
                        withAnimation(.linear(duration: 3.0)) {
                            percentage = 1
                        }
                    })
                }
        }
    }
}

#Preview {
    ChartView(coin: Preview.dev.coin)
}


extension ChartView {
    
    var yAxisGrid: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
            Spacer()
        }
        .foregroundStyle(Color.theme.secondaryText)
    }
    var yAxisLabels: some View {
        VStack {
            Text(max.formattedWithAbbreviations())
            Spacer()
            Text(((max+min)/2).formattedWithAbbreviations())
            Spacer()
            Text(min.formattedWithAbbreviations())
        }
        .font(.caption)
    }
    
    var lineChart: some View {
        
        GeometryReader { geometry in
            Path { path in
                
                for index in data.indices {
                    
                    //X-Axis creation
                    let xPosition = (geometry.size.width/CGFloat(data.count))  * CGFloat(index+1)
                    let yAxis = max - min
                    let yPosition = (1 - CGFloat((data[index]-min)/yAxis)) * geometry.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                    
                }
            }
            .trim(from: 0, to: percentage)
            .stroke(lineColor, style: .init(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: lineColor, radius: 10, x: 0, y: 10)
            .shadow(color: lineColor.opacity(0.5), radius: 10, x: 0, y: 20)
            .shadow(color: lineColor.opacity(0.2), radius: 10, x: 0, y: 30)
            .shadow(color: lineColor.opacity(0.1), radius: 10, x: 0, y: 40)

        }
    }
}
