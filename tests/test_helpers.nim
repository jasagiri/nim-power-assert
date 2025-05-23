import macros, strutils

# For testing purposes - exposes internal AST analysis functions
proc parseAndInstrument*(code: string): NimNode =
  ## Parse a code string and prepare it for PowerAssert processing
  let parsed = parseStmt(code)
  
  # Simplified version of the internal AST instrumentation
  # This is for testing purposes only
  var astResult = newStmtList()
  
  # Create some sample instrumentation to match what the real instrumentation would create
  # This is a mock-up for testing the AST structure
  if parsed.kind == nnkStmtList and parsed.len > 0:
    let expr = parsed[0]
    
    # Add some basic instrumentation patterns
    let tempVar = genSym(nskVar, "temp")
    astResult.add(newVarStmt(tempVar, expr))
    
    if expr.kind in {nnkInfix, nnkCall}:
      if expr.len >= 3:  # Binary operation
        let leftVal = genSym(nskLet, "leftVal")
        let rightVal = genSym(nskLet, "rightVal")
        astResult.add(newLetStmt(leftVal, expr[1]))
        astResult.add(newLetStmt(rightVal, expr[2]))
    
    astResult.add(newNimNode(nnkReturnStmt).add(tempVar))
  
  return astResult

proc containsNode*(node: NimNode, pred: proc(n: NimNode): bool): bool =
  ## Check if an AST contains a node that satisfies the given predicate
  if pred(node):
    return true
  for i in 0 ..< node.len:
    if containsNode(node[i], pred):
      return true
  return false

proc collectNodes*(node: NimNode, pred: proc(n: NimNode): bool): seq[NimNode] =
  ## Collect all nodes in an AST that satisfy the given predicate
  var results: seq[NimNode] = @[]
  if pred(node):
    results.add(node)
  for i in 0 ..< node.len:
    results.add(collectNodes(node[i], pred))
  return results

proc countNodes*(node: NimNode, pred: proc(n: NimNode): bool): int =
  ## Count all nodes in an AST that satisfy the given predicate
  if pred(node):
    result += 1
  for i in 0 ..< node.len:
    result += countNodes(node[i], pred)

proc dumpAst*(node: NimNode, indent = 0): string =
  ## Debug utility to dump an AST to a string with indentation
  var output = ""
  let spaces = repeat(" ", indent)
  output.add(spaces & $node.kind)
  
  if node.len > 0:
    output.add(":\n")
    for i in 0..<node.len:
      output.add(dumpAst(node[i], indent + 2))
      if i < node.len - 1:
        output.add("\n")
  else:
    if node.kind in {nnkIdent, nnkStrLit, nnkIntLit, nnkFloatLit}:
      output.add(": " & $node)
  
  return output