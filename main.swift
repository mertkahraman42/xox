//  XOX Game
//  Created by Mert Kahraman on 25/06/16.
//  Copyright © 2016 Mert Kahraman. All rights reserved.

import Foundation

/* Let's define a struct to represent the XOX table as a matrix of 9.
We can think of an XOX table as the following:

(0,0) | (1,0) | (2,0)

(0,1) | (1,1) | (2,1)

(0,2) | (1,2) | (2,2)

*/

// We can define the coordinate area of a given X or an O using a Point type, which would explain its position on the above table coordinate area
struct Point {
    var state: Int // This property will store the state of a given location. A location could be empty, claimed by X or claimed Y. These will be denoted as strings: 1 for X claimed, 10 for Y claimed and 0 for empty
}

// Below are some examples of what sort of inputs the game would expect
//let exampleX = Point(x: 0, y: 0, state:1) This is an X played onto the lower left side of our XOX table.
//let exampleY = Point(x: 0, y: 0, state:10) This is an X played onto the lower left side of our XOX table.
//let exampleEmpty = Point(x: 0, y: 0, state:0) This is an X played onto the lower left side of our XOX table.

// Below is our function to get input for a string input
func getInput() -> String {
    print("Please enter your input:")
    let theInput = readLine()
    return theInput!
}

// Below, we define a class that will control the status of the game.
class gameStatus {
    
    var playerX: String
    var playerO: String
    
    var turnNumber = 0 // We will increase the turn number by 1 for each turn
    
    var table:[[Point]] // Here we initialize our table, a matrix with a size of 3 and 3. This is our XOX table and is an array of arrays (a matrix). It stores Point type of information. We will use indexes of arrays to locate a position on the matrix.
    
    init() {
        print("Welcome to X O X. This game is being played through inputs of locations where you wish to play using the below matrix for coords in a 3 x 3 table of X O X")
        print("While playing this game please input the location you would like to claim through the following words on your keyboard")
        print("q | w | e")
        print("a | s | d")
        print("z | x | c")
        print("To begin please enter the name of player who would be X")
        self.playerX = getInput()
        print("Please enter the name of player who would be O")
        self.playerO = getInput()
        print("It is \(playerX) against \(playerO).")
        //        turnNumber += 1 // Here we finalize initializing our game by advancing to Turn #1
        
        
        // Below, we initialize our table to be an empty matrix. Note that an empty state of a location is explained as setting the state of a Point with 0 in INT type.
        table = []
        for (var y = 0; y < 3; y += 1) {
            var row = [Point]() // We define a row of Point array
            for (var x = 0; x < 3; x += 1) {
                row.append(Point(state: 0)) // We append state:0 on each column of the current row
            }
            table.append(row) // After three columns, we append the updated row.
            
        }
    }
    
    // Below function will calculate if the turn number is even or odd, which represents in fact it is Player X's turn or Y's turn
    func isPlayerXTurn() -> Bool {
        return turnNumber % 2 == 0;
    }
    
    
    // Below function prints out the latest state of the map.
    func renderTable() {
        for(_, row) in table.enumerate() { // We use enumeration function on our array. It simply iterates on the indexes.
            var rowString = ""
            for (_, point) in row.enumerate() { // The _ notation marks that the x index is not being used.
                if (point.state == 1) {
                    rowString += "[X]"
                } else if (point.state == 10) {
                    rowString += "[O]"
                } else {
                    rowString += "[ ]"
                }
                
            }
            print(rowString)
        }
    }
    
    // Lets define a function and dictionary to translate the inputs from strings to locations on our table.
    
    func getCoord() -> (Int,Int) {
        let input = getInput()
        
        let inputToCoord: [String:(Int,Int)] = [
            "q":(0,0),
            "w":(0,1),
            "e":(0,2),
            "a":(1,0),
            "s":(1,1),
            "d":(1,2),
            "z":(2,0),
            "x":(2,1),
            "c":(2,2)
        ]
        
        if ((inputToCoord[input]) == nil) {
            print("You've entered an incorrect input, please input from the designated matrix letters")
            // calling a method from itself is called recursion
            // it's a dangerous concept as long as you don't know what you do since you can end up in infinite loops
            return getCoord()
        } else {
            return inputToCoord[input]!
        }
    }
    
    
    // This function will execute the code when a winner is calculated using the sum of Points
    func renderGameOver(sum: Int) {
        if sum == 3 {
            print("The game is won by \(playerX) at Turn #\(turnNumber). Congratulations!")
        }
        else if sum == 30 {
            print("The game is won by \(playerO) Turn #\(turnNumber). Congratulations!")
        }
        renderTable()
        print("Let's play again!")
    }
    
    // Here we set the condition for our game
    func isGameOver() -> Bool {
        // The below condition remarks that the game is ended with a draw after 8 possible turns
        if (turnNumber > 8) {
            print("The game is a draw")
            return true
        } else {}
        
        // If not we carry on by checking the XOX game winning conditions.
        // There are 8 potential cases for which a player to win the game. Three horizontal, three vertical and two cross lines of victory.
        // Below conditions will set that a player has won the game
        
        // 1) ///// Here we check the Diagonal sums in our table
        // Firstly we check the direction of left top to bottom right
                var sumDiag1: Int = 0
                for d in 0...2 {
                    sumDiag1 += table[d][d].state
        
                    if sumDiag1 == 3 {
                        renderGameOver(sumDiag1)
                        return true
                        }
                        else if sumDiag1 == 30 {
                            renderGameOver(sumDiag1)
                            return true
                            }
                    
                }
        
        // 2) ///// Then we check the direction of the other diagonal
                var sumDiag2: Int = 0
                for c in 0...2 {
                        sumDiag2 += table[2-c][0+c].state
                    if sumDiag2 == 3 {
                        renderGameOver(sumDiag2)
                        return true
                        }
                            else if sumDiag2 == 30 {
                            renderGameOver(sumDiag2)
                            return true
                            }
                
                }
        
        
        //// 3) ///// Here we check the Vertical sums in our table
        for x in 0...2 {
            var sumVertical: Int = 0
            for y in 0...2 {
                sumVertical += table[x][y].state
            }
            
            
            if sumVertical == 3 {
                renderGameOver(sumVertical)
                return true
            }
            else if sumVertical == 30 {
                renderGameOver(sumVertical)
                return true
            }
        }
        
        //// 4) ///// Here we check the Horizontal sums in our table

        for y in 0...2 {
            var sumHorizontal: Int = 0
            for x in 0...2 {
                sumHorizontal += table[x][y].state
                
                if sumHorizontal == 3 {
                    renderGameOver(sumHorizontal)
                    return true
                }
                else if sumHorizontal == 30 {
                    renderGameOver(sumHorizontal)
                    return true
                }
            }
        } // Here we conclude our for loop that started on 3)
        
        // If none of the conditions above satisfy, then return false
        return false
    }
    
    
    func processUserTurn() {
        let coord:(Int,Int) = getCoord()
        let x = coord.0
        let y = coord.1
        
        var point:Point = table[x][y]
        
        if (point.state == 0) {
            // point.state = isPlayerXTurn() ? 1 : 10
            if (isPlayerXTurn()) {
                point.state = 1
            } else {
                point.state = 10
            }
            table[x][y] = point
        } else {
            print("The point you have chosen is already played. Please select another point!")
            renderTable()
            processUserTurn()
        }
    }
    
    // Below function will announce who's turn and prints it
    func loop() {
        renderTable()
        if (isPlayerXTurn()) {
            print("Turn #\(turnNumber). It's \(playerX)'s turn.")
        } else {
            print("Turn #\(turnNumber). It's \(playerO)'s turn.")
        }
        
        processUserTurn()
        
        self.turnNumber += 1
        
    }
    
} // End of our gameStatus Class

while(true) {
    // We begin the game
    let game = gameStatus()
    while (!game.isGameOver()) {
        // Each turn we will want the player who's turn is it to select a coord and claim it. Hence first we print the Turn and game status,    and set who's turn is it.
        game.loop()
    }
}







