//: Playground - noun: a place where people can play
//
// Laura Abitante
// Academic project - 2017
//
//

import UIKit
import XCTest

let fileName = "example_3"
let expectedNumberOfIslands = 3
let fileNameForReadingTest = "example_1" // Constante utilizada apenas para o teste de leitura de arquivo.


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
let filePath = Bundle.main.path(forResource: fileName, ofType: "txt")
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


// Classe de testes
class MatrixTests: XCTestCase {
    
    // Função para testar a leitura de uma única matriz. Nesse caso, o arquivo example_1.
    func test_ReadFile() {
        let filePath = Bundle.main.path(forResource: fileNameForReadingTest, ofType: "txt")
        let content: String = try! String(contentsOfFile: filePath!, encoding: .utf8)
        let matrix = populateMatrix(withString: content)
        
        XCTAssert(matrix[0][0] == 0, "[0][0] should be 0")
        XCTAssert(matrix[0][1] == 0, "[0][1] should be 0")
        XCTAssert(matrix[0][2] == 0, "[0][2] should be 0")
        XCTAssert(matrix[0][3] == 0, "[0][3] should be 0")
        
        XCTAssert(matrix[1][0] == 0, "[1][0] should be 0")
        XCTAssert(matrix[1][1] == 1, "[1][1] should be 1")
        XCTAssert(matrix[1][2] == 1, "[1][2] should be 1")
        XCTAssert(matrix[1][3] == 0, "[1][3] should be 0")
        
        XCTAssert(matrix[2][0] == 0, "[2][0] should be 0")
        XCTAssert(matrix[2][1] == 1, "[2][1] should be 1")
        XCTAssert(matrix[2][2] == 1, "[2][2] should be 1")
        XCTAssert(matrix[2][3] == 0, "[2][3] should be 0")
        
        XCTAssert(matrix[3][0] == 0, "[3][0] should be 0")
        XCTAssert(matrix[3][1] == 0, "[3][1] should be 0")
        XCTAssert(matrix[3][2] == 0, "[3][2] should be 0")
        XCTAssert(matrix[3][3] == 0, "[3][3] should be 0")
    }
    
    func test_NumberOfIslands() {
        let filePath = Bundle.main.path(forResource: fileName, ofType: "txt")
        let content: String = try! String(contentsOfFile: filePath!, encoding: .utf8)
        var matrix = populateMatrix(withString: content)
        
        // Caso a função numberOfIslands não retorne o resultado esperado, o teste acusará o erro.
        XCTAssert(numberOfIslands(matrix: &matrix) == expectedNumberOfIslands, "Number of islands should be \(expectedNumberOfIslands)")
    }
}

// Descomentar linha abaixo para rodar os testes.
// MatrixTests.defaultTestSuite().run()
