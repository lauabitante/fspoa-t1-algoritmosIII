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
    
    for c in string.characters {
        if c != "\n" && c != " " {
            if hasReadColumns == false {
                var oldColumns = String(columns)
                oldColumns.append(c)
                columns = Int(String(oldColumns))!
                continue
            }
            if hasReadRows == false {
                var oldRows = String(rows)
                oldRows.append(c)
                rows = Int(String(oldRows))!
                continue
            }
            
            if columnsCounter == columns {
                columnsCounter = 0
                rowsCounter += 1
                matrix.append([])
            }
            matrix[rowsCounter].append(Int(String(c))!)
            columnsCounter += 1
        } else if c == " " {
            hasReadColumns = true
        } else if c == "\n" {
            hasReadRows = true
        }
        
    }
    return matrix
}


// Imprime matriz
func printMatrix(_ matrix: [[Int]]) {
    for row in 0..<matrix.count {
        var rowStr = "|"
        for column in matrix[row] {
            rowStr.append("\(column)|")
        }
        print(rowStr)
    }
}

let filePath = Bundle.main.path(forResource: "example_1", ofType: "txt")
let content: String = try! String(contentsOfFile: filePath!, encoding: .utf8)
let matrix = populateMatrix(withString: content)

printMatrix(matrix)
print("")

