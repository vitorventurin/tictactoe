//
//  TicTacToeTests.swift
//  TicTacToeTests
//
//  Created by Rotiv on 11/03/2021.
//

import XCTest
@testable import TicTacToe

class TicTacToeTests: XCTestCase {
    func testNewGame() throws {
        let game = Game()
        XCTAssertEqual(game.turn, "x")
        XCTAssertEqual("         ", game.description)
    }
    
    func testMove() throws {
        let game = Game().move(1)
        XCTAssertEqual(game.turn, "o")
        XCTAssertEqual(" x       ", game.description)
    }
    
    func testUnmove() {
        let game = Game().move(1).unmove(1)
        XCTAssertEqual(game.turn, "x")
        XCTAssertEqual("         ", game.description)
    }
    
    func testPossibleMoves() {
        let game = Game()
        var list = [Int]()
        list.reserveCapacity(game.size)
        for i in 0..<game.size {
            list.append(i)
        }
        if let indexOf1 = list.firstIndex(of: 1) {
            list.remove(at: indexOf1)
        }
        if let indexOf2 = list.firstIndex(of: 2) {
            list.remove(at: indexOf2)
        }
        XCTAssertEqual(list, Game().move(1).move(2).possibleMoves())
    }
    
    func testIsWinFor() throws {
        XCTAssertFalse(Game().isWinFor("x"))
        XCTAssertTrue(Game("xxx      ", "x").isWinFor("x"))
        XCTAssertTrue(Game("x  x  x  ", "x").isWinFor("x"))
        XCTAssertTrue(Game("o   o   o", "x").isWinFor("o"))
        XCTAssertTrue(Game("  o o o  ", "x").isWinFor("o"))
    }
    
    func testMinMax() {
        XCTAssertEqual(6, Game("xxx      ", "x").minmax())
        XCTAssertEqual(-6, Game("ooo      ", "o").minmax())
        XCTAssertEqual(0, Game("xoxxoxoxo", "x").minmax())
        XCTAssertEqual(6, Game("xx       ", "x").minmax())
        XCTAssertEqual(-6, Game("oo       ", "o").minmax())
    }
    
    func testBestMove() {
        XCTAssertEqual(2, Game("xx       ", "x").bestMove())
        XCTAssertEqual(2, Game("oo       ", "o").bestMove())
    }
    
    func testIsGameEnded() {
        XCTAssertFalse(Game().isGameEnded())
        XCTAssertTrue(Game("xxx      ", "x").isGameEnded())
        XCTAssertTrue(Game("ooo      ", "x").isGameEnded())
        XCTAssertTrue(Game("oxoxoxoxo", "x").isGameEnded())
    }
}


