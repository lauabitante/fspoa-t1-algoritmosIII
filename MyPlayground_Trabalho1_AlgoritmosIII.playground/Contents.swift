//: Playground - noun: a place where people can play
//
// Laura Abitante
// Academic project - 2017
//
//

import UIKit

// Popula a matriz a partir de uma string
func populateMatrix(withString string: String) -> [[Int]] {
    
    var matrix: [[Int]] = [[]]
    var columns: Int = 0
    var rows: Int = 0
    var rowsCounter: Int = 0
    var columnsCounter: Int  = 0
    var hasReadColumns = false
    var hasReadRows = false
    
    for char in string.characters {
        if char != "\n" && char != " " {
            if hasReadColumns == false {
                var oldColumns = String(columns)
                oldColumns.append(char)
                columns = Int(String(oldColumns))!
                continue
            }
            if hasReadRows == false {
                var oldRows = String(rows)
                oldRows.append(char)
                rows = Int(String(oldRows))!
                continue
            }
            
            if columnsCounter == columns {
                columnsCounter = 0
                rowsCounter += 1
                matrix.append([])
            }
            matrix[rowsCounter].append(Int(String(char))!)
            columnsCounter += 1
        } else if char == " " {
            hasReadColumns = true
        } else if char == "\n" {
            hasReadRows = true
        }
    }
    return matrix
}


// Leitura de arquivo de texto.
let filePath = Bundle.main.path(forResource: "example_4", ofType: "txt")
let content: String = try! String(contentsOfFile: filePath!, encoding: .utf8)

var matrix = populateMatrix(withString: content)


// Função que dada uma matriz, conta o número de ilhas.
func numberOfIslands(matrix: inout [[Int]]) -> Int {
    
    var islandCount = 0
    let rowCount = matrix.count
    if rowCount == 0 {
        return 0
    }
    
    let columnCount = matrix[0].count
    
    for row in 0..<rowCount {
        for column in 0..<columnCount {
            if matrix[row][column] == 1 {
                // Chamada função recursiva.
                marking(matrix: &matrix, row: row, column: column)
                islandCount += 1
            }
        }
    }
    return islandCount
}


// Função recursiva para zerar posições da matriz (ligadas por ilhas).
func marking(matrix: inout [[Int]], row: Int, column: Int) {
    
    let rowCount = matrix.count
    let columnCount = matrix[0].count
    
    // Verifica se a posição [row][column] está dentro da área da matriz.
    if (row < 0 || column < 0 || row >= rowCount || column >= columnCount || matrix[row][column] == 0) {
        return
    }
    
    // Zera a posição [row][column] e verifica se pode zerar as posições adjacentes.
    matrix[row][column] = 0
    marking(matrix:&matrix, row: (row + 1), column: column);
    marking(matrix:&matrix, row: (row - 1), column: column);
    marking(matrix:&matrix, row: row, column: (column + 1));
    marking(matrix:&matrix, row: row, column: (column - 1));
}

// Imprime resultado
print(numberOfIslands(matrix: &matrix))
