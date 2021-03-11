//
//  ContentView.swift
//  TicTacToe
//
//  Created by Rotiv on 11/03/2021.
//

import SwiftUI

class Player: ObservableObject {
    @Published var turn = false
    @Published var score = 0
}

struct ContentView: View {
    var body: some View {
        GridStack(rows: 3, columns: 3) { row, col in
//            let action = {
//                print("tapped: (\(col),\(row))")
//            }
            Mark()
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

struct PlayerTurnView: View {
    @EnvironmentObject var player: Player

    var body: some View {
        Text("\(player.score)")
    }
}

struct Mark: View {
    @StateObject private var player = Player()
    
    let square = Image(systemName: "square")
    let xmark = Image(systemName: "xmark")
    let circle = Image(systemName: "circle")
    
    var body: some View {
        ZStack {
            Button(action: {
                player.score += 1
                player.turn.toggle()
            }) {
                ZStack {
                    if player.turn {
                        xmark.font(.system(size: 60))
                    } else {
                        square.font(.system(size: 60))
                    }
                    PlayerTurnView()
                }
            }
        }
        .environmentObject(player)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
