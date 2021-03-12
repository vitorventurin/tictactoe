//
//  ContentView.swift
//  TicTacToe
//
//  Created by Rotiv on 11/03/2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var gameVieModel = GameViewModel()
    @State private var showingAlert = false
    let columns = [
          GridItem(.adaptive(minimum: 40), alignment: .center)
        ]
    
    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
            ForEach(Array(zip(gameVieModel.data.indices, gameVieModel.data)), id: \.0) { idx, item in
                Button(action: {
                    if item == .empty {
                        gameVieModel.move(idx)
                        if (!gameVieModel.isEnded()) {
                            let bestMove = gameVieModel.bestMove()
                            gameVieModel.move(bestMove)
                        }
                        if (gameVieModel.isEnded()) {
                            showingAlert = true
                        }
                        // print(gameVieModel.description)
                        gameVieModel.refreshData()
                    }
                }, label: {
                    Text(item.rawValue)
                        .font(.system(size: 40))
                })
                .frame(width: 40, height: 40, alignment: .center)
                .background(Color.yellow)
            }
        }
        .frame(width: 145, height: 120, alignment: .center)
        .alert(isPresented: $showingAlert, content: {
            Alert(title: Text(gameVieModel.theWinnerIs()), dismissButton: .default(Text("Play Again!"), action: {
                gameVieModel.playAgain()
                gameVieModel.refreshData()
            }))
        })
    }
}

class GameViewModel: ObservableObject, CustomStringConvertible {
    private var game = Game()
    @Published var data = [Turn]()
    
    init() {
        data = game.board
    }
    
    func refreshData() {
        data = game.board
    }
    
    func move(_ index: Int) {
        _ = game.move(index)
    }
    
    func bestMove() -> Int {
        return game.bestMove()
    }
    
    func isEnded() -> Bool {
        return game.isGameEnded()
    }
    
    func theWinnerIs() -> String {
        return game.isWinFor(.human) ? "You won!" : game.isWinFor(.cpu) ? "CPU won!" : "Draw!"
    }
    
    func playAgain() {
        game = Game()
    }
    
    var description: String {
        return game.board.description
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
