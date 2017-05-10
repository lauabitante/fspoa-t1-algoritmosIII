//: Playground - noun: a place where people can play
//
// Copyright (c) 2017 Laura Abitante
// Academic project
//
//

import UIKit
import XCTest

// MARK: - Exercício A

let fileNumber = "4"
let fileName = "example_\(fileNumber)"
let expectedTestResultFile = "result_\(fileNumber)"
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



// MARK: - Exercício B - Remoção e adição de ilhas

// Struct para guardar posições da matriz
struct Node<T> {
    let row: Int
    let column: Int
    let value: T
}

// Extrai os nós da matriz em um array
func extractNodes(fromMatrix matrix: [[Int]]) -> [Node<Int>] {
    var nodes: [Node<Int>] = []
    for row in 0..<matrix.count {
        for column in 0..<matrix[0].count {
            if matrix[row][column] == 1 {
                // Se a posição [row][column] tiver um número 1, 
                // cria um Node e adiciona na lista nodes
                let newNode = Node(row: row, column: column, value: 1)
                nodes.append(newNode)
            }
        }
    }
    return nodes // Devolve uma lista de Nodes
}


// Cria uma matriz vazia, dada a quantidade de linhas e colunas
func createEmptyMatrix(withRows rows:Int, columns: Int) -> [[Int]] {
    var matrix: [[Int]] = []
    for row in 0..<rows {
        matrix.append([]) // Cria uma nova linha
        for column in 0..<columns {
            matrix[row].append(0) // Cria uma nova coluna
            matrix[row][column] = 0
        }
    }
    return matrix
}

// Dada uma lista de Nodes e uma matriz, adiciona os nós na matriz.
func addIslands(_ islands:[Node<Int>], toMatrix matrix: [[Int]]) -> [[Int]] {
    // Copia a matriz, para não passá-la como referência
    var newMatrix = matrix
    
    // Varre o array de nós, adicionando-os na matriz de acordo com sua posição
    for node in islands {
        let row = node.row
        let column = node.column
        newMatrix[row][column] = node.value
    }
    return newMatrix
}

func printMatrix(_ matrix: [[Int]]) {
    for row in 0..<matrix.count {
        var rowStr = "|"
        for column in matrix[row] {
            rowStr.append("\(column)|")
        }
        print(rowStr)
    }
}

// Cria nova matriz pois a matriz original é zerada quando feita a contagem de ilhas
var matrix2 = populateMatrix(withString: content)

// Extrai os nós da matriz para um array de Nodes
let nodesArray = extractNodes(fromMatrix: matrix2)

// Cria uma nova matriz para a aplicar as ilhas existentes no array de Nodes
var newMatrix = createEmptyMatrix(withRows: matrix2.count, columns: matrix2[0].count)

// Popula a matriz vazia com os Nodes extraídos previamente
let populatedMatrix = addIslands(nodesArray, toMatrix: newMatrix)

// Descomentar linhas abaixo para imprimir as posições que contém 1 e a matriz populada com os nodes.
//print("\nPosições da matriz que contém 1:\n\n\(nodesArray)")
//print()
//print("\nMatriz populada a partir da lista de nodes: \n")
//printMatrix(populatedMatrix)
//print()

//print("Matriz:\n\(populatedMatrix)")
//print()


// MARK: - Testes

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
        
        let filePathNumber = Bundle.main.path(forResource: expectedTestResultFile, ofType: "txt")
        var contentFilePathNumber: String = try! String(contentsOfFile: filePathNumber!, encoding: .utf8)
        contentFilePathNumber = contentFilePathNumber.replacingOccurrences(of: "\n", with: "")
        
        // Caso a função numberOfIslands não retorne o resultado esperado, o teste acusará o erro.
        XCTAssert(numberOfIslands(matrix: &matrix) == Int(contentFilePathNumber)!, "Number of islands should be \(contentFilePathNumber)")
    }
}

// Descomentar linha abaixo para rodar os testes.
//print("\nTESTES:\n")
//MatrixTests.defaultTestSuite().run()