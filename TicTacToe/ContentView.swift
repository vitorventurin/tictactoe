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
    
    var body: some View {
        HStack {
            ForEach(Array(zip(gameVieModel.data.indices, gameVieModel.data)), id: \.0) { idx, item in
                Button(action: {
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
                }, label: {
                    Text(String(item))
                        .font(.system(size: 40))
                })
                .frame(width: 40, height: 40, alignment: .center)
                .background(Color.yellow)
                .alert(isPresented: $showingAlert, content: {
                    Alert(title: Text(gameVieModel.theWinnerIs()))
                })
            }
        }
    }
}

class GameViewModel: ObservableObject, CustomStringConvertible {
    private var game = Game()
    @Published var data = [Character]()
    
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
        return game.isWinFor("x") ? "You won!" : "CPU won!"
    }
    
    var description: String {
        return game.board.description
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
