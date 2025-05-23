import unittest except check, doAssert
import macros, strutils
import test_helpers
import ../src/power_assert except doAssert

# Use an internal module-specific assert to avoid naming conflicts
template testAssert(cond: untyped) =
  if not cond:
    raise newException(AssertionDefect, "Assertion failed")

suite "AST Transformation Tests":
  test "Instrumentation of numeric literals":
    let ast = parseAndInstrument("42")
    testAssert ast.containsNode(proc(n: NimNode): bool =
      n.kind == nnkVarSection and ($n[0][0]).startsWith("temp")
    )

  test "Instrumentation of variable references":
    let ast = parseAndInstrument("x")
    testAssert ast.containsNode(proc(n: NimNode): bool =
      n.kind == nnkVarSection and ($n[0][0]).startsWith("temp")
    )

  test "Instrumentation of binary expressions":
    let ast = parseAndInstrument("a + b")
    testAssert ast.containsNode(proc(n: NimNode): bool =
      n.kind == nnkLetSection and ($n[0][0]).startsWith("leftVal")
    )
    testAssert ast.containsNode(proc(n: NimNode): bool =
      n.kind == nnkLetSection and ($n[0][0]).startsWith("rightVal")
    )

  test "Instrumentation of complex expressions":
    let ast = parseAndInstrument("(a + b) * c - d")
    # Verify that each operation is properly instrumented
    testAssert ast.containsNode(proc(n: NimNode): bool =
      n.kind == nnkLetSection and ($n[0][0]).startsWith("leftVal")
    )
    testAssert ast.containsNode(proc(n: NimNode): bool =
      n.kind == nnkLetSection and ($n[0][0]).startsWith("rightVal")
    )
    testAssert ast.containsNode(proc(n: NimNode): bool =
      n.kind == nnkVarSection and ($n[0][0]).startsWith("temp")
    )
    
  test "Instrumentation of function calls":
    let ast = parseAndInstrument("foo(a, b)")
    testAssert ast.containsNode(proc(n: NimNode): bool =
      n.kind == nnkVarSection and ($n[0][0]).startsWith("temp")
    )
    
  test "Instrumentation of indexing operations":
    let ast = parseAndInstrument("arr[idx]")
    testAssert ast.containsNode(proc(n: NimNode): bool =
      n.kind == nnkVarSection and ($n[0][0]).startsWith("temp")
    )
    
  test "Instrumentation of field access":
    let ast = parseAndInstrument("obj.field")
    testAssert ast.containsNode(proc(n: NimNode): bool =
      n.kind == nnkVarSection and ($n[0][0]).startsWith("temp")
    )