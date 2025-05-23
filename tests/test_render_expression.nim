import unittest except check
import ../src/power_assert
import std/tables
import std/strutils

suite "Render Expression Tests":
  test "Simple expression rendering":
    let exprStr = "a == b"
    var values: seq[ExpressionInfo] = @[
      ExpressionInfo(code: "a", value: "5", typeName: "int", column: 0),
      ExpressionInfo(code: "b", value: "10", typeName: "int", column: 5)
    ]
    
    let rendered = renderExpression(exprStr, values)
    check find(rendered, "a == b") >= 0
    check find(rendered, "^ 5 (int)") >= 0
    check find(rendered, "     ^ 10 (int)") >= 0
  
  test "Complex expression with nested operations":
    let exprStr = "(a + b) * c > d"
    var values: seq[ExpressionInfo] = @[
      ExpressionInfo(code: "a", value: "2", typeName: "int", column: 1),
      ExpressionInfo(code: "b", value: "3", typeName: "int", column: 5),
      ExpressionInfo(code: "c", value: "4", typeName: "int", column: 10),
      ExpressionInfo(code: "d", value: "20", typeName: "int", column: 14),
      ExpressionInfo(code: "a + b", value: "5", typeName: "int", column: 1),
      ExpressionInfo(code: "(a + b) * c", value: "20", typeName: "int", column: 0)
    ]
    
    let rendered = renderExpression(exprStr, values)
    check find(rendered, "(a + b) * c > d") >= 0
    check find(rendered, " ^ 2 (int)") >= 0
    check find(rendered, "     ^ 3 (int)") >= 0
    check find(rendered, "          ^ 4 (int)") >= 0
    check find(rendered, "              ^ 20 (int)") >= 0
    
    # Check for composite expressions section
    check find(rendered, "# Composite expressions:") >= 0
    check find(rendered, "a + b = 5 (int)") >= 0
    check find(rendered, "(a + b) * c = 20 (int)") >= 0
  
  test "Empty expression information":
    let exprStr = "x == y"
    var values: seq[ExpressionInfo] = @[]
    
    let rendered = renderExpression(exprStr, values)
    check rendered == "x == y\n\n"
  
  test "Expressions with same column position":
    let exprStr = "nested.expression.value == 10"
    var values: seq[ExpressionInfo] = @[
      ExpressionInfo(code: "nested", value: "obj", typeName: "Object", column: 0),
      ExpressionInfo(code: "nested.expression", value: "expr", typeName: "Expression", column: 0),
      ExpressionInfo(code: "nested.expression.value", value: "5", typeName: "int", column: 0),
      ExpressionInfo(code: "10", value: "10", typeName: "int", column: 26)
    ]
    
    let rendered = renderExpression(exprStr, values)
    check find(rendered, "^ obj (Object)") >= 0
    check find(rendered, "^ expr (Expression)") >= 0
    check find(rendered, "^ 5 (int)") >= 0
    check find(rendered, "                          ^ 10 (int)") >= 0
  
  test "Different value types in same expression":
    let exprStr = "a + b.value == c[i]"
    var values: seq[ExpressionInfo] = @[
      ExpressionInfo(code: "a", value: "5", typeName: "int", column: 0),
      ExpressionInfo(code: "b", value: "obj", typeName: "Object", column: 4),
      ExpressionInfo(code: "b.value", value: "10", typeName: "int", column: 4),
      ExpressionInfo(code: "c", value: "@[15, 20, 25]", typeName: "seq[int]", column: 14),
      ExpressionInfo(code: "i", value: "1", typeName: "int", column: 16),
      ExpressionInfo(code: "c[i]", value: "20", typeName: "int", column: 14),
      ExpressionInfo(code: "a + b.value", value: "15", typeName: "int", column: 0)
    ]
    
    let rendered = renderExpression(exprStr, values)
    check find(rendered, "^ 5 (int)") >= 0
    check find(rendered, "    ^ obj (Object)") >= 0
    check find(rendered, "    ^ 10 (int)") >= 0
    check find(rendered, "              ^ @[15, 20, 25] (seq[int])") >= 0
    check find(rendered, "                ^ 1 (int)") >= 0
    check find(rendered, "              ^ 20 (int)") >= 0
    
    # Check for composite expressions section
    check find(rendered, "# Composite expressions:") >= 0
    check find(rendered, "a + b.value = 15 (int)") >= 0
  
  test "Handling of multiple composite expressions":
    let exprStr = "(a + b) * (c - d) == e"
    var values: seq[ExpressionInfo] = @[
      ExpressionInfo(code: "a", value: "2", typeName: "int", column: 1),
      ExpressionInfo(code: "b", value: "3", typeName: "int", column: 5),
      ExpressionInfo(code: "c", value: "10", typeName: "int", column: 10),
      ExpressionInfo(code: "d", value: "5", typeName: "int", column: 14),
      ExpressionInfo(code: "e", value: "25", typeName: "int", column: 19),
      ExpressionInfo(code: "a + b", value: "5", typeName: "int", column: 1),
      ExpressionInfo(code: "c - d", value: "5", typeName: "int", column: 10),
      ExpressionInfo(code: "(a + b) * (c - d)", value: "25", typeName: "int", column: 0)
    ]
    
    let rendered = renderExpression(exprStr, values)
    # Check for all value pointers
    check find(rendered, " ^ 2 (int)") >= 0
    check find(rendered, "     ^ 3 (int)") >= 0
    check find(rendered, "          ^ 10 (int)") >= 0
    check find(rendered, "              ^ 5 (int)") >= 0
    check find(rendered, "                   ^ 25 (int)") >= 0
    
    # Check for all composite expressions
    check find(rendered, "# Composite expressions:") >= 0
    check find(rendered, "a + b = 5 (int)") >= 0
    check find(rendered, "c - d = 5 (int)") >= 0
    check find(rendered, "(a + b) * (c - d) = 25 (int)") >= 0