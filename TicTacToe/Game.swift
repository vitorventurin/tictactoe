//
//  Game.swift
//  TicTacToe
//
//  Created by Rotiv on 11/03/2021.
//

import Foundation

enum Turn: String {
    case empty = " "
    case cpu = "o"
    case human = "x"
}

class Game: CustomStringConvertible, Comparable {
    var turn: Turn
    var board: [Turn]
    var dimension = 3
    var size: Int
    
    init() {
        turn = .human
        size = dimension * dimension
        board = []
        board.reserveCapacity(size)
        for _ in 0..<size {
            board.append(.empty)
        }
    }
    
    init(_ string: String, _ turn: Turn) {
        size = dimension * dimension
        board = []
        board.reserveCapacity(size)
        self.turn = turn
        board = self.convertStringToTurns(string)
    }
    
    func convertStringToTurns(_ string: String) -> [Turn] {
        let turns: [Turn] = string.map {
            switch $0 {
            case " ": return .empty
            case "x": return .human
            case "o": return .cpu
            default: return .empty
            }
        }
        return turns
    }
    
    func move(_ index: Int) -> Game {
        board[index] = turn
        turn = turn == .human ? .cpu : .human
        return self
    }
    
    func unmove(_ index: Int) -> Game {
        board[index] = .empty
        turn = turn == .human ? .cpu : .human
        return self
    }
    
    func possibleMoves() -> [Int] {
        var list = [Int]()
        for i in 0..<board.count {
            if board[i] == .empty {
                list.append(i)
            }
        }
        return list
    }
    
    func isWinFor(_ turn: Turn) -> Bool {
        var isWin = false
        for i in stride(from: 0, through: size-1, by: dimension) {
            isWin = isWin || lineMatch(turn: turn, start: i, end: i + dimension, step: 1) // horizontal line
        }
        for i in 0..<dimension {
            isWin = isWin || lineMatch(turn: turn, start: i, end: size, step: dimension) // vertical line
        }
        isWin = isWin || lineMatch(turn: turn, start: 0, end: size, step: dimension+1) // diagonal from top left to bottom right
        isWin = isWin || lineMatch(turn: turn, start: dimension-1, end: size-1, step: dimension-1) // diagonal from top right to bottom left
        return isWin
    }
    
    func lineMatch(turn: Turn, start: Int, end: Int, step: Int) -> Bool {
        for i in stride(from: start, through: end-1, by: step) {
            if board[i] != turn {
                return false
            }
        }
        return true
    }
    
    func blanks() -> Int {
        return board.filter { $0 == .empty }.count
    }
    
    func minmax() -> Int {
        if isWinFor(.human) {
            return blanks()
        }
        if isWinFor(.cpu) {
            return -blanks()
        }
        if blanks() == 0 {
            return 0
        }
        var list = [Int]()
        for idx in possibleMoves() {
            list.append(move(idx).minmax())
            _ = unmove(idx)
        }
        return turn == .human ? list.max()! : list.min()!
    }
    
    func bestMove() -> Int {
        let list: [Int] = possibleMoves()
        return turn == .human ? list.max(by: >)! : list.min(by: <)!
    }
    
    func isGameEnded() -> Bool {
        return isWinFor(.human) || isWinFor(.cpu) || blanks() == 0 // human won or cpu won or game has drawn
    }
    
    //- MARK: Comparable
    static func < (lhs: Game, rhs: Game) -> Bool {
        return lhs.minmax() < rhs.minmax()
    }

    static func == (lhs: Game, rhs: Game) -> Bool {
        return lhs.minmax() == rhs.minmax()
    }
    
    //- MARK: CustomStringConvertible
    var description: String {
        return board.map { "\($0.rawValue)" }.joined()
    }
}
