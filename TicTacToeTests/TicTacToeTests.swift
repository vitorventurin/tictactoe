//
//  TicTacToeTests.swift
//  TicTacToeTests
//
//  Created by Rotiv on 11/03/2021.
//

import XCTest
@testable import TicTacToe

class TicTacToeTests: XCTestCase {
    func testNewPosition() throws {
        let position = Position()
        XCTAssertEqual(position.turn, "x")
        XCTAssertEqual("         ", position.description)
    }
    
    func testMove() throws {
        let position = Position().move(1)
        XCTAssertEqual(position.turn, "o")
        XCTAssertEqual(" x       ", position.description)
    }
    
    func testUnmove() {
        let position = Position().move(1).unmove(1)
        XCTAssertEqual(position.turn, "x")
        XCTAssertEqual("         ", position.description)
    }
    
    func testPossibleMoves() {
        let position = Position()
        var list = [Int]()
        list.reserveCapacity(position.size)
        for i in 0..<position.size {
            list.append(i)
        }
        if let indexOf1 = list.firstIndex(of: 1) {
            list.remove(at: indexOf1)
        }
        if let indexOf2 = list.firstIndex(of: 2) {
            list.remove(at: indexOf2)
        }
        XCTAssertEqual(list, Position().move(1).move(2).possibleMoves())
    }
    
    func testIsWinFor() throws {
        XCTAssertFalse(Position().isWinFor("x"))
        XCTAssertTrue(Position("xxx      ", "x").isWinFor("x"))
        XCTAssertTrue(Position("x  x  x  ", "x").isWinFor("x"))
        XCTAssertTrue(Position("o   o   o", "x").isWinFor("o"))
        XCTAssertTrue(Position("  o o o  ", "x").isWinFor("o"))
    }
    
    func testMinMax() {
        XCTAssertEqual(6, Position("xxx      ", "x").minmax())
        XCTAssertEqual(-6, Position("ooo      ", "o").minmax())
        XCTAssertEqual(0, Position("xoxxoxoxo", "x").minmax())
        XCTAssertEqual(6, Position("xx       ", "x").minmax())
        XCTAssertEqual(-6, Position("oo       ", "o").minmax())
    }
}

class Position: CustomStringConvertible {
    var turn: Character
    var board: [Character]
    var dimension = 3
    var size: Int
    
    init() {
        turn = "x"
        size = dimension * dimension
        board = []
        board.reserveCapacity(size)
        for _ in 0..<size {
            board.append(" ")
        }
    }
    
    init(_ string: String, _ char: Character) {
        size = dimension * dimension
        board = Array(string)
        board.reserveCapacity(size)
        turn = char
    }
    
    func move(_ index: Int) -> Position {
        board[index] = turn
        turn = turn == "x" ? "o" : "x"
        return self
    }
    
    func unmove(_ index: Int) -> Position {
        board[index] = " "
        turn = turn == "x" ? "o" : "x"
        return self
    }
    
    func possibleMoves() -> [Int] {
        var list = [Int]()
        for i in 0..<board.count {
            if board[i] == " " {
                list.append(i)
            }
        }
        return list
    }
    
    func isWinFor(_ turn: Character) -> Bool {
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
    
    func lineMatch(turn: Character, start: Int, end: Int, step: Int) -> Bool {
        for i in stride(from: start, through: end-1, by: step) {
            if board[i] != turn {
                return false
            }
        }
        return true
    }
    
    func blanks() -> Int {
        return board.filter { $0 == " " }.count
    }
    
    func minmax() -> Int {
        if isWinFor("x") {
            return blanks()
        }
        if isWinFor("o") {
            return -blanks()
        }
        if blanks() == 0 {
            return 0
        }
        var list = [Int]()
        for idx in possibleMoves() {
            list.append(move(idx).minmax())
            unmove(idx)
        }
        return turn == "x" ? list.max()! : list.min()!
    }
    
    var description: String {
        return board.map { "\($0)" }.joined()
    }
}
