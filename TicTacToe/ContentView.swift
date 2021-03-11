//
//  ContentView.swift
//  TicTacToe
//
//  Created by Rotiv on 11/03/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GridStack(rows: 3, columns: 3) { row, col in
            Text("(\(row),\(col))")
        }
    }
}

struct GridStack<T: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> T
    
    var body: some View {
        VStack {
            ForEach(0..<rows, id: \.self) { row in
                HStack {
                    ForEach(0..<columns, id: \.self) { column in
                        content(row, column)
                    }
                }
            }
        }
    }
    
    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> T) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
