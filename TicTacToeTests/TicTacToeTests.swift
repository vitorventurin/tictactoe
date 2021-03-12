//
//  TicTacToeTests.swift
//  TicTacToeTests
//
//  Created by Rotiv on 11/03/2021.
//

import XCTest
@testable import TicTacToe

class TicTacToeTests: XCTestCase {
    var game: Game!
    
    override func setUp() {
        game = Game()
    }
    
    func testConversionFromStringToTurns() {
        XCTAssertEqual(game.convertStringToTurns("xo ox xo "), [.human, .cpu, .empty, .cpu, .human, .empty, .human, .cpu, .empty])
    }
    
    func testConversionFromMalformedStringToTurns() {
        XCTAssertEqual(game.convertStringToTurns("xo1ox xoz"), [.human, .cpu, .empty, .cpu, .human, .empty, .human, .cpu, .empty])
    }
    
    func testNewGame() throws {
        XCTAssertEqual(game.turn, .human)
        XCTAssertEqual("         ", game.description)
    }
    
    func testMove() throws {
        _ = game.move(1)
        XCTAssertEqual(game.turn, .cpu)
        XCTAssertEqual(" x       ", game.description)
    }
    
    func testUnmove() {
        _ = game.move(1).unmove(1)
        XCTAssertEqual(game.turn, .human)
        XCTAssertEqual("         ", game.description)
    }
    
    func testPossibleMoves() {
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
        XCTAssertFalse(Game().isWinFor(.human))
        XCTAssertTrue(Game("xxx      ", .human).isWinFor(.human))
        XCTAssertTrue(Game("x  x  x  ", .human).isWinFor(.human))
        XCTAssertTrue(Game("o   o   o", .human).isWinFor(.cpu))
        XCTAssertTrue(Game("  o o o  ", .human).isWinFor(.cpu))
    }
    
    func testMinMax() {
        XCTAssertEqual(6, Game("xxx      ", .human).minmax())
        XCTAssertEqual(-6, Game("ooo      ", .cpu).minmax())
        XCTAssertEqual(0, Game("xoxxoxoxo", .human).minmax())
        XCTAssertEqual(6, Game("xx       ", .human).minmax())
        XCTAssertEqual(-6, Game("oo       ", .cpu).minmax())
    }
    
    func testBestMove() {
        XCTAssertEqual(2, Game("xx       ", .human).bestMove())
        XCTAssertEqual(2, Game("oo       ", .cpu).bestMove())
    }
    
    func testIsGameEnded() {
        XCTAssertFalse(Game().isGameEnded())
        XCTAssertTrue(Game("xxx      ", .human).isGameEnded())
        XCTAssertTrue(Game("ooo      ", .human).isGameEnded())
        XCTAssertTrue(Game("oxoxoxoxo", .human).isGameEnded())
    }
}


