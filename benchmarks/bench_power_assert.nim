# Benchmarks for power_assert

import times
import strutils  # For formatFloat
import ../src/power_assert

# Simple benchmarking helper
template benchmark(name: string, n: int, body: untyped) =
  let start = cpuTime()
  for i in 1..n:
    body
  let duration = cpuTime() - start
  echo name, ": ", formatFloat(duration * 1000, format = ffDecimal, precision = 3), " ms (", formatFloat(duration * 1000 / float(n), format = ffDecimal, precision = 6), " ms per iteration)"

# Benchmark the formatValue function
proc benchmarkFormatValue() =
  echo "Benchmarking formatValue function..."
  
  # Integer
  benchmark("formatValue(int)", 100_000):
    discard formatValue(42)
  
  # String
  benchmark("formatValue(string)", 100_000):
    discard formatValue("hello")
  
  # Sequence
  benchmark("formatValue(seq[int])", 10_000):
    discard formatValue(@[1, 2, 3, 4, 5])
  
  # Array
  benchmark("formatValue(array)", 10_000):
    discard formatValue([1, 2, 3, 4, 5])
  
  # Custom type
  type Person = object
    name: string
    age: int
  
  proc `$`(p: Person): string = p.name & " (age: " & $p.age & ")"
  
  benchmark("formatValue(custom type)", 10_000):
    discard formatValue(Person(name: "Test", age: 30))

# Benchmark successful assertions
proc benchmarkPassingAssertions() =
  echo "\nBenchmarking passing assertions..."
  
  let a = 10
  let b = 20
  
  benchmark("powerAssert(simple condition)", 10_000):
    try:
      powerAssert(a + b == 30)
    except:
      discard

# Benchmark failed assertions
proc benchmarkFailingAssertions() =
  echo "\nBenchmarking failing assertions..."
  
  let a = 10
  let b = 20
  
  benchmark("powerAssert(failing condition)", 1_000):
    try:
      # This assertion will fail, but we catch the exception
      powerAssert(a > b)
    except PowerAssertDefect:
      # Properly catch the specific exception type
      discard

when isMainModule:
  echo "PowerAssert for Nim - Benchmarks"
  echo "=============================="
  
  benchmarkFormatValue()
  benchmarkPassingAssertions()
  benchmarkFailingAssertions()
  
  echo "\nAll benchmarks completed"