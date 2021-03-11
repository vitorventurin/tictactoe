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
        print(board.description)
        var list = [Int]()
        for i in 0..<board.count {
            if board[i] == " " {
                list.append(i)
            }
        }
        return list
    }
    
    var description: String {
        return board.map { "\($0)" }.joined()
    }
}
