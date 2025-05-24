import macros
import strutils, strformat, typetraits, algorithm
import terminal
from tables import Table, initTable, `[]`, `[]=`, pairs

type
  PowerAssertDefect* = object of AssertionDefect
  
  ExpressionValue* = object
    expr*: string
    value*: string
    startPos*: int
    endPos*: int
  
  # カスタムフォーマッター用の型エイリアス
  CapturedValues* = Table[string, string]
  
  # フォーマットテンプレート設定
  OutputFormat* = enum
    PowerAssertJS,     # power-assert.js風の出力
    Compact,           # コンパクトな出力
    Detailed,          # 詳細な出力
    Classic,           # 従来の出力
    Custom             # カスタムフォーマット
  
  # テスト統計
  TestStats* = object
    passed*: int
    failed*: int
    skipped*: int
    total*: int
  
  # カスタムフォーマッター用の型定義
  FormatRenderer* = proc(exprStr: string, capturedValues: CapturedValues): string {.nimcall.}
  
  # カラー設定
  ColorScheme* = object
    errorTitle*: ForegroundColor
    expressionCode*: ForegroundColor
    indicator*: ForegroundColor
    values*: ForegroundColor
    types*: ForegroundColor
    compositeHeader*: ForegroundColor

var
  currentFormat* = PowerAssertJS  # デフォルトフォーマット
  globalStats* = TestStats()      # グローバル統計
  customRenderer*: FormatRenderer = nil  # カスタムフォーマッター
  colorsEnabled* = false  # カラー出力のフラグ
  colorScheme* = ColorScheme(
    errorTitle: fgRed,
    expressionCode: fgWhite,
    indicator: fgCyan,
    values: fgYellow,
    types: fgGreen,
    compositeHeader: fgMagenta
  )

proc splitCondition(cond: NimNode): tuple[left, right: NimNode, op: string] =
  ## 条件式を左辺と右辺に分割する
  if cond.kind == nnkInfix and cond[0].kind == nnkIdent:
    let op = $cond[0]
    case op
    of "==", "!=", "<", "<=", ">", ">=", "and", "or":
      return (cond[1], cond[2], op)
  return (cond, newLit(true), "bool")  # 単純な式の場合はbool評価

proc formatValue*[T](val: T): string =
  when val is string:
    result = "\"" & val & "\""
  elif val is char:
    result = "'" & $val & "'"
  elif val is bool:
    result = $val
  elif val is enum:
    result = $val
  elif val is SomeInteger:
    result = $val
  elif val is SomeFloat:
    result = $val
  elif val is seq:
    result = "@["
    for i, item in val:
      if i > 0: result.add(", ")
      result.add(formatValue(item))
    result.add("]")
  elif val is array:
    result = "["
    for i, item in val:
      if i > 0: result.add(", ")
      result.add(formatValue(item))
    result.add("]")
  elif compiles($val):
    result = $val
  else:
    result = "<" & val.type.name & ">"

proc detectExpressionPositions*(exprStr: string, capturedValues: CapturedValues): seq[ExpressionValue] =
  result = @[]
  for expr, value in capturedValues.pairs:
    if expr.len > 0 and (exprStr.startsWith(expr) or exprStr.endsWith(expr) or exprStr.contains(expr)):
      let startPos = exprStr.find(expr)
      let endPos = startPos + expr.len - 1
      result.add(ExpressionValue(expr: expr, value: value, startPos: startPos, endPos: endPos))
  result.sort(proc(x, y: ExpressionValue): int = cmp(x.expr.len, y.expr.len))

# power-assert.js風のフォーマット
proc renderPowerAssertJS(exprStr: string, capturedValues: CapturedValues): string =
  result = exprStr & "\n"
  
  # 値を取得してソート
  var expressions: seq[ExpressionValue] = @[]
  for expr, value in capturedValues.pairs:
    if expr != exprStr and expr.len > 0:
      let startPos = exprStr.find(expr)
      if startPos >= 0:
        expressions.add(ExpressionValue(
          expr: expr, 
          value: value, 
          startPos: startPos, 
          endPos: startPos + expr.len - 1
        ))
  
  # 位置でソート（開始位置で）
  expressions.sort(proc(x, y: ExpressionValue): int = cmp(x.startPos, y.startPos))
  
  # パイプライン行を作成
  if expressions.len > 0:
    # パイプライン文字を配置
    var pipeLine = " ".repeat(exprStr.len)
    for expr in expressions:
      if expr.startPos < pipeLine.len:
        pipeLine[expr.startPos] = '|'
    result.add(pipeLine & "\n")
    
    # 複数行で値を表示（重複を避けるため）
    var usedPositions = newSeq[bool](exprStr.len)
    
    # 短い値から配置していく（長い値が短い値を上書きしないよう）
    var sortedExprs = expressions
    sortedExprs.sort(proc(x, y: ExpressionValue): int = cmp(x.value.len, y.value.len))
    
    for expr in sortedExprs:
      let valueStartPos = expr.startPos
      if valueStartPos < exprStr.len:
        # この位置に値を配置できるかチェック
        var canPlace = true
        for j in 0..<expr.value.len:
          if valueStartPos + j >= exprStr.len or (valueStartPos + j < usedPositions.len and usedPositions[valueStartPos + j]):
            canPlace = false
            break
        
        if canPlace:
          # 値用の行を作成
          var valueLine = " ".repeat(exprStr.len)
          for j, ch in expr.value:
            if valueStartPos + j < valueLine.len:
              valueLine[valueStartPos + j] = ch
              if valueStartPos + j < usedPositions.len:
                usedPositions[valueStartPos + j] = true
          
          result.add(valueLine & "\n")
    
    # 表示できなかった値を最後に列挙
    var displayedExprs = newSeq[string]()
    for expr in expressions:
      let valueStartPos = expr.startPos
      var wasDisplayed = false
      if valueStartPos < exprStr.len:
        var canPlace = true
        for j in 0..<expr.value.len:
          if valueStartPos + j >= exprStr.len:
            canPlace = false
            break
        if canPlace:
          wasDisplayed = true
      
      if not wasDisplayed:
        displayedExprs.add(expr.expr & " = " & expr.value)
    
    if displayedExprs.len > 0:
      result.add("\n")
      for item in displayedExprs:
        result.add(item & "\n")

# コンパクトフォーマット
proc renderCompact(exprStr: string, capturedValues: CapturedValues): string =
  result = fmt"assert({exprStr}) failed"
  var values: seq[string] = @[]
  for expr, value in capturedValues.pairs:
    if expr != exprStr:
      values.add(fmt"{expr}={value}")
  if values.len > 0:
    result.add(" [" & values.join(", ") & "]")

# 詳細フォーマット
proc renderDetailed(exprStr: string, capturedValues: CapturedValues): string =
  result = "PowerAssert Failure Details:\n"
  result.add("═".repeat(50) & "\n")
  result.add(fmt"Expression: {exprStr}\n")
  result.add("Result: false\n")
  result.add("Values:\n")
  for expr, value in capturedValues.pairs:
    if expr != exprStr:
      result.add(fmt"  {expr:<20} = {value}\n")
  result.add("═".repeat(50))

# 従来フォーマット（現在の実装）
proc renderClassic(exprStr: string, capturedValues: CapturedValues): string =
  result = "Expression: " & exprStr & "\n\n"
  let exprValues = detectExpressionPositions(exprStr, capturedValues)
  
  for expr in exprValues:
    if expr.expr == exprStr:
      result.add("Result: " & expr.value & "\n\n")
      break
  
  result.add("Subexpression values:\n")
  for expr in exprValues:
    if expr.expr != exprStr:
      result.add(fmt"{expr.expr} => {expr.value}\n")
  
  result.add("\n" & exprStr & "\n")
  
  var pointers = newSeq[char](exprStr.len)
  for i in 0..<exprStr.len:
    pointers[i] = ' '
  
  for expr in exprValues:
    if expr.expr != exprStr and expr.expr.len <= 1:
      if expr.startPos >= 0 and expr.startPos < pointers.len:
        pointers[expr.startPos] = '^'
  
  result.add(pointers.join("") & "\n")

# メインのレンダリング関数
proc renderExpression(exprStr: string, capturedValues: CapturedValues): string =
  case currentFormat
  of PowerAssertJS:
    return renderPowerAssertJS(exprStr, capturedValues)
  of Compact:
    return renderCompact(exprStr, capturedValues)
  of Detailed:
    return renderDetailed(exprStr, capturedValues)
  of Classic:
    return renderClassic(exprStr, capturedValues)
  of Custom:
    if customRenderer != nil:
      return customRenderer(exprStr, capturedValues)
    else:
      return renderPowerAssertJS(exprStr, capturedValues)  # フォールバック


macro powerAssert*(condition: untyped, message: string = ""): untyped =
  let conditionStr = condition.repr
  var stmts = newStmtList()
  
  let valuesTable = genSym(nskVar, "values")
  stmts.add(quote do:
    var `valuesTable` = initTable[string, string]()
  )

  proc instrumentExpr(node: NimNode): NimNode =
    let nodeStr = node.repr
    if node.kind in {nnkIntLit..nnkFloat128Lit, nnkStrLit..nnkTripleStrLit, nnkCharLit}:
      let temp = genSym(nskLet, "temp")
      result = quote do:
        block:
          let `temp` = `node`
          `valuesTable`[`nodeStr`] = formatValue(`temp`)
          `temp`
    elif node.kind in {nnkIdent, nnkSym} and nodeStr notin ["==", "!=", "<", "<=", ">", ">=", "+", "-", "*", "/", "mod", "div", "and", "or", "not", "xor", "shl", "shr", "&", "in", "notin", "is", "isnot", "..", "$"]:
      # Only instrument non-operator identifiers/symbols
      let temp = genSym(nskLet, "temp")
      result = quote do:
        block:
          let `temp` = `node`
          `valuesTable`[`nodeStr`] = formatValue(`temp`)
          `temp`
    elif node.kind in {nnkInfix, nnkPrefix, nnkCall, nnkCommand, nnkDotExpr, nnkBracketExpr}:
      result = copyNimNode(node)
      for i in 0..<node.len:
        if node.kind == nnkDotExpr and i == 1:
          # Don't instrument the field name in dot expressions
          result.add(node[i])
        else:
          result.add(instrumentExpr(node[i]))
      let temp = genSym(nskLet, "temp")
      result = quote do:
        block:
          let `temp` = `result`
          `valuesTable`[`nodeStr`] = formatValue(`temp`)
          `temp`
    else:
      result = node

  let instrumentedCond = instrumentExpr(condition)

  stmts.add(quote do:
    let cond = `instrumentedCond`
    
    if not cond:
      var errorMsg = "PowerAssert: Assertion failed\n\n"
      errorMsg.add(renderExpression(`conditionStr`, `valuesTable`))
      if `message`.len > 0:
        errorMsg.add("\nMessage: " & `message` & "\n")
      raise newException(PowerAssertDefect, errorMsg)
  )
  result = stmts

template assert*(cond: untyped, msg: string = "") {.dirty.} =
  powerAssert(cond, msg)

template doAssert*(cond: untyped, msg: string = "") {.dirty.} =
  powerAssert(cond, msg)

template powerCheck*(condition: untyped, message: string = "") {.dirty.} =
  powerAssert(condition, message)

template require*(condition: untyped, message: string = "") {.dirty.} =
  powerAssert(condition, message)

template check*(condition: untyped, message: string = "") {.dirty.} =
  powerAssert(condition, message)

# フォーマット設定API
proc setOutputFormat*(format: OutputFormat) =
  ## 出力フォーマットを設定
  currentFormat = format

proc getOutputFormat*(): OutputFormat =
  ## 現在の出力フォーマットを取得
  return currentFormat

proc setCustomRenderer*(renderer: FormatRenderer) =
  ## カスタムフォーマッターを設定
  customRenderer = renderer
  currentFormat = Custom

proc clearCustomRenderer*() =
  ## カスタムフォーマッターをクリア
  customRenderer = nil
  currentFormat = PowerAssertJS

# テスト統計管理API
proc recordPassed*() =
  ## テスト成功を記録
  inc globalStats.passed
  inc globalStats.total

proc recordFailed*() =
  ## テスト失敗を記録
  inc globalStats.failed
  inc globalStats.total

proc recordSkipped*() =
  ## テストスキップを記録
  inc globalStats.skipped
  inc globalStats.total

proc getTestStats*(): TestStats =
  ## テスト統計を取得
  return globalStats

proc resetTestStats*() =
  ## テスト統計をリセット
  globalStats = TestStats()

proc printTestSummary*() =
  ## テスト統計サマリを出力
  let stats = getTestStats()
  echo ""
  echo "Test Summary:"
  echo "============="
  echo fmt"PASSED:  {stats.passed}"
  echo fmt"FAILED:  {stats.failed}" 
  echo fmt"SKIPPED: {stats.skipped}"
  echo fmt"TOTAL:   {stats.total}"
  echo ""
  
  if stats.failed > 0:
    echo fmt"❌ {stats.failed} test(s) failed"
  elif stats.total > 0:
    echo "✅ All tests passed!"
  else:
    echo "ℹ️  No tests were run"

# 統計付きアサーション
template powerAssertWithStats*(condition: untyped, message: string = ""): untyped =
  try:
    powerAssert(condition, message)
    recordPassed()
  except PowerAssertDefect:
    recordFailed()
    raise

template skipTest*(reason: string = "") =
  ## テストをスキップ
  recordSkipped()
  echo "SKIPPED: " & reason

# カラー関連のAPI
proc enableColors*(enable: bool) =
  ## カラー出力を有効/無効にする
  colorsEnabled = enable

proc isColorsEnabled*(): bool =
  ## カラー出力が有効かどうかを返す
  return colorsEnabled

proc setColorScheme*(errorTitle: ForegroundColor = fgRed,
                     expressionCode: ForegroundColor = fgWhite,
                     indicator: ForegroundColor = fgCyan,
                     values: ForegroundColor = fgYellow,
                     types: ForegroundColor = fgGreen,
                     compositeHeader: ForegroundColor = fgMagenta) =
  ## カラースキームを設定する
  colorScheme = ColorScheme(
    errorTitle: errorTitle,
    expressionCode: expressionCode,
    indicator: indicator,
    values: values,
    types: types,
    compositeHeader: compositeHeader
  )

proc getColorScheme*(): ColorScheme =
  ## 現在のカラースキームを取得する
  return colorScheme

# カスタムフォーマッター用のヘルパー関数
iterator capturedPairs*(values: CapturedValues): tuple[key, val: string] =
  ## Iterate over captured values without importing tables
  for k, v in pairs(values):
    yield (k, v)