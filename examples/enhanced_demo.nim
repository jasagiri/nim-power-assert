import ../src/power_assert

# 複雑な式での新しいフォーマットのテスト
proc testEnhancedFormat() =
  echo "Enhanced PowerAssert Format Test"
  echo "================================"
  
  setOutputFormat(PowerAssertJS)
  
  # 1. 単純な比較
  echo "\n1. Simple comparison:"
  echo "-------------------"
  let x = 10
  let y = 5
  proc isLess(a, b: int): bool = a < b
  try:
    powerAssert(isLess(x, y))
  except PowerAssertDefect as e:
    echo e.msg
  
  # 2. 文字列の比較
  echo "\n2. String comparison:"
  echo "--------------------"
  let name = "Alice"
  let expected = "Bob"
  proc isEqual(a, b: string): bool = a == b
  try:
    powerAssert(isEqual(name, expected))
  except PowerAssertDefect as e:
    echo e.msg
  
  # 3. 関数呼び出しを含む式
  echo "\n3. Function call expression:"
  echo "---------------------------"
  proc getLength(s: string): int = s.len
  proc isEven(n: int): bool = (n mod 2) == 0
  
  let text = "Hello"
  try:
    powerAssert(isEven(getLength(text)))
  except PowerAssertDefect as e:
    echo e.msg
  
  # 4. 配列アクセス
  echo "\n4. Array access:"
  echo "---------------"
  let numbers = @[1, 3, 5, 7, 9]
  let index = 2
  let target = 4
  proc arrayElementEquals(arr: seq[int], idx: int, val: int): bool = arr[idx] == val
  try:
    powerAssert(arrayElementEquals(numbers, index, target))
  except PowerAssertDefect as e:
    echo e.msg
  
  # 5. 複雑な算術式
  echo "\n5. Complex arithmetic:"
  echo "---------------------"
  let a = 10
  let b = 3
  let c = 2
  let result = a + b * c  # 算術演算を先に計算
  proc isGreater(x, y: int): bool = x > y
  try:
    powerAssert(isGreater(result, 20))
  except PowerAssertDefect as e:
    echo e.msg
  
  # 6. オブジェクトフィールドアクセス
  echo "\n6. Object field access:"
  echo "----------------------"
  type Person = object
    name: string
    age: int
  
  let person = Person(name: "Alice", age: 25)
  let minAge = 30
  let personAge = person.age  # フィールドアクセスを先に計算
  proc isAgeValid(age, minimum: int): bool = age >= minimum
  try:
    powerAssert(isAgeValid(personAge, minAge))
  except PowerAssertDefect as e:
    echo e.msg

when isMainModule:
  testEnhancedFormat()