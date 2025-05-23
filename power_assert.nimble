# Package
version       = "0.0.0"
author        = "jasagiri"
description   = "PowerAssert for Nim - Enhanced assertion output"
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]

# Library configuration
# This is a library package, not a binary package
skipDirs      = @["tests", "examples", "benchmarks"]
skipFiles     = @["README.md", "README.ja.md"]

# Set the main file to build and output directory
bin = @["power_assert"]
binDir = "build/bin"

# Dependencies
requires "nim >= 1.6.0"

# Tasks
task buildLib, "Build the library files and documentation":
  # Create output directories
  exec "mkdir -p build/lib build/bin"

  # Compile the library files
  echo "Building power_assert library..."
  when defined(windows):
    exec "nim c --app:lib -d:release --out:build/lib/power_assert.dll src/power_assert.nim"
  else:
    exec "nim c --app:lib -d:release --out:build/lib/libpower_assert.so src/power_assert.nim"

  # Move any binary created in the root directory to build/bin
  echo "Moving binaries to build/bin directory..."
  when defined(windows):
    exec "cmd /c if exist power_assert.exe move power_assert.exe build\\bin\\"
  else:
    exec "[ -f ./power_assert ] && mv ./power_assert build/bin/ || true"

  # Also generate documentation
  echo "Generating documentation..."
  exec "mkdir -p build/doc"
  exec "nim doc --project --index:on --outdir:build/doc src/power_assert.nim"

  echo "Build completed successfully"

# Custom build task that ensures binaries go to build/bin directory
task build, "Build the package and ensure binaries go to build/bin":
  # Create bin directory first
  exec "mkdir -p build/bin"

  # Clean root directory of binaries first
  when defined(windows):
    exec "cmd /c if exist power_assert.exe del power_assert.exe"
  else:
    exec "rm -f ./power_assert"

  # Use nimble install with --nolinks to build without creating symlinks
  # This will use the binDir setting defined above
  exec "nimble install --nolinks"

  # Run the buildLib task for library files
  exec "nimble buildLib"

  # Verify binary placement and clean root if needed
  echo "Verifying binary placement..."
  when defined(windows):
    exec "cmd /c if exist power_assert.exe (echo Binary in root directory && move power_assert.exe build\\bin\\) else (echo Binary correctly placed in build/bin)"
  else:
    exec "if [ -f ./power_assert ]; then echo 'Binary in root directory' && mv ./power_assert build/bin/; else echo 'Binary correctly placed in build/bin'; fi"

task test, "Run tests":
  # Create build/tests directory if it doesn't exist
  exec "mkdir -p build/tests"

  # Main test files to run
  let mainTestFiles = [
    "test_power_assert.nim"
    # "test_operators.nim",      # TODO: Fix operator ambiguity issues
    # "test_custom_types.nim",   # TODO: Fix operator ambiguity issues  
    # "test_basic.nim"           # TODO: Fix operator ambiguity issues
  ]

  when defined(windows):
    for testFile in mainTestFiles:
      let outFile = testFile.replace(".nim", "")
      exec "nim c -r -o:build/tests/" & outFile & " tests/" & testFile
  else:
    for testFile in mainTestFiles:
      let outFile = testFile.replace(".nim", "")
      echo "Running test: tests/" & testFile
      exec "nim c -r -o:build/tests/" & outFile & " tests/" & testFile

task clean, "Clean build artifacts":
  # ビルド成果物を管理するための安全で賢いクリーンアップタスク
  # ドキュメントファイルは保持し、他のビルド成果物を選択的に削除する方式
  echo "Cleaning build artifacts..."

  when defined(windows):
    # Windows環境のための複数ステップクリーンアップ
    echo "Removing build artifacts (Windows)..."

    # バイナリおよび生成ファイルを含む特定のサブディレクトリを削除
    exec "cmd /c if exist build\\bin rmdir /s /q build\\bin"
    exec "cmd /c if exist build\\lib rmdir /s /q build\\lib"
    exec "cmd /c if exist build\\benchmarks rmdir /s /q build\\benchmarks"
    exec "cmd /c if exist build\\coverage rmdir /s /q build\\coverage"

    # テストバイナリを削除 (ファイルがロックされていてもエラーにならない)
    exec "cmd /c if exist build\\tests (del /f /q build\\tests\\*.exe build\\tests\\*.dll build\\tests\\*.o build\\tests\\test_* >nul 2>&1)"
    exec "cmd /c if exist build\\tests\\test_power_assert.exe del /f build\\tests\\test_power_assert.exe >nul 2>&1"
    exec "cmd /c if exist build\\tests\\test_operators.exe del /f build\\tests\\test_operators.exe >nul 2>&1"
    exec "cmd /c if exist build\\tests\\test_custom_types.exe del /f build\\tests\\test_custom_types.exe >nul 2>&1"
    exec "cmd /c if exist build\\tests\\test_basic.exe del /f build\\tests\\test_basic.exe >nul 2>&1"

    # ルートディレクトリのアーティファクトを削除
    exec "cmd /c if exist power_assert.exe del /f power_assert.exe"
    exec "cmd /c if exist tests\\test_power_assert del /f tests\\test_power_assert"
    exec "cmd /c if exist tests\\test_operators del /f tests\\test_operators"
    exec "cmd /c if exist tests\\test_custom_types del /f tests\\test_custom_types"
    exec "cmd /c if exist tests\\test_basic del /f tests\\test_basic"
    exec "cmd /c if exist nimcache rmdir /s /q nimcache"

    # ディレクトリ構造を作成（docディレクトリは維持したまま）
    echo "Ensuring build directory structure (Windows)..."
    exec "cmd /c if not exist build mkdir build"
    exec "cmd /c if not exist build\\bin mkdir build\\bin"
    exec "cmd /c if not exist build\\lib mkdir build\\lib"
    exec "cmd /c if not exist build\\tests mkdir build\\tests"
    exec "cmd /c if not exist build\\doc mkdir build\\doc"
    exec "cmd /c if not exist build\\benchmarks mkdir build\\benchmarks"
    exec "cmd /c if not exist build\\coverage mkdir build\\coverage"

    # 削除できなかったファイルの確認
    let windowsCheck = staticExec("cmd /c dir /b /s build\\*.exe build\\*.dll build\\*.o build\\tests\\test_* 2>nul")
    if windowsCheck.len > 0:
      echo "Note: Some files could not be removed but this will not affect normal operation."
      echo "These files will be replaced in the next build."

  else:
    # Unix/macOS環境のためのロバストなクリーンアップ
    echo "Removing build artifacts (Unix)..."

    # バイナリディレクトリなど特定の生成ディレクトリを削除
    # docディレクトリは明示的に除外し、各コマンドはエラーを無視
    exec "rm -rf ./build/bin ./build/lib ./build/benchmarks ./build/coverage ./build/nimcache 2>/dev/null || true"

    # テストバイナリを削除 - 複数の方法で徹底的に処理
    # 1. findで削除
    exec "find ./build/tests -type f -name 'test_*' -delete 2>/dev/null || true"
    # 2. ロックされているファイルのプロセスを終了（無害な場合のみ）
    exec "lsof ./build/tests/test_* 2>/dev/null | grep -v 'Chrome\\|Finder' | awk '{print $2}' | xargs -r kill -9 2>/dev/null || true"
    # 3. 個別に重要なファイルを削除
    exec "rm -f ./build/tests/test_power_assert ./build/tests/test_operators ./build/tests/test_custom_types ./build/tests/test_basic 2>/dev/null || true"

    # nimcacheディレクトリのクリーンアップ（ルートとbuild配下の両方）
    exec "rm -rf ./nimcache 2>/dev/null || true"
    exec "find ./build/nimcache -type f -name '*.o' -delete 2>/dev/null || true"
    exec "find ./build/nimcache -type f -name '*.c' -delete 2>/dev/null || true"
    exec "find ./build/nimcache -type f -name '*.json' -delete 2>/dev/null || true"

    # その他のクリーンアップ
    exec "find . -name '.DS_Store' -type f -delete 2>/dev/null || true"
    exec "rm -f ./power_assert 2>/dev/null || true"
    exec "find ./tests -type f -name 'test_*' -not -name '*.nim' -not -name '*.nims' -delete 2>/dev/null || true"

    # ディレクトリ構造を確保 (すべて存在しない場合のみ作成)
    echo "Ensuring build directory structure (Unix)..."
    exec "mkdir -p ./build/tests ./build/bin ./build/lib ./build/doc ./build/benchmarks ./build/coverage"

    # 残っているファイルをチェック (ドキュメントファイルを除外)
    let remainingFiles = staticExec("find ./build -type f -not -path '*/build/doc/*' | grep -v 'build/doc/' | wc -l").strip()
    if parseInt(remainingFiles) > 0:
      echo "Note: " & remainingFiles & " build artifacts couldn't be completely removed but this won't affect normal operation."
      echo "      New builds will override these files if needed."

  echo "Build directories have been reset and are ready for new builds"

task docs, "Generate documentation":
  # Create docs directory if it doesn't exist
  exec "mkdir -p build/doc"

  echo "Generating documentation..."

  # Run nim doc on the main module file directly
  when defined(windows):
    exec "nim doc --project --index:on --outdir:build/doc src/power_assert.nim"
  else:
    exec "nim doc --project --index:on --outdir:build/doc src/power_assert.nim"

  echo "Documentation generation completed successfully."

task bench, "Run benchmarks":
  # Create benchmarks directory if it doesn't exist
  exec "mkdir -p build/benchmarks"

  # Run benchmark directly
  when defined(windows):
    exec "nim c -r -o:build/benchmarks/bench_power_assert benchmarks/bench_power_assert.nim"
  else:
    exec "nim c -r -o:build/benchmarks/bench_power_assert benchmarks/bench_power_assert.nim"

task coverage, "Generate test coverage report":
  # Create coverage directory
  exec "mkdir -p build/coverage"

  echo "Generating coverage report..."

  # Check if we're on macOS with Apple Silicon, which has known issues with gcov
  let isAppleSilicon = gorgeEx("uname -sm").output.contains("Darwin arm64")
  let forceRun = existsEnv("FORCE_COVERAGE") or existsEnv("BYPASS_PLATFORM_CHECK")

  if isAppleSilicon and not forceRun:
    echo "⚠️ Detected macOS on Apple Silicon (M1/M2)"
    echo """
Coverage generation on Apple Silicon Macs has known compatibility issues.

Recommended alternatives:
1. Run a simplified test coverage without detailed reports:
   nim c -r --passC:-fprofile-arcs --passC:-ftest-coverage tests/test_power_assert.nim

2. Install and use LLVM tools (may still have compatibility issues):
   brew install llvm lcov
   export PATH="$(brew --prefix llvm)/bin:$PATH"

3. For the most reliable results, use Docker with a Linux container:
   docker run --rm -v $(pwd):/src -w /src nimlang/nim:latest \
     bash -c "apt-get update && apt-get install -y lcov && nimble coverage"

4. To bypass this warning and try anyway, run:
   BYPASS_PLATFORM_CHECK=1 nimble coverage
"""
    return

  if isAppleSilicon:
    echo "Note: Bypassing Apple Silicon compatibility warning. This may still fail."

  # Check for required tools
  var missingTools: seq[string] = @[]
  var installInstructions = ""

  when defined(windows):
    # Windows tool check
    try:
      let gcovOutput = staticExec("where gcov 2>&1")
      if not gcovOutput.contains("gcov"):
        missingTools.add("gcov")
        installInstructions.add("\n  - gcov: Install MinGW-w64 or use Windows Subsystem for Linux (WSL)")
    except:
      missingTools.add("gcov")
      installInstructions.add("\n  - gcov: Install MinGW-w64 or use Windows Subsystem for Linux (WSL)")
  else:
    # Unix tool check
    if staticExec("which gcov 2>/dev/null || echo notfound") == "notfound":
      missingTools.add("gcov")

    if staticExec("which lcov 2>/dev/null || echo notfound") == "notfound":
      missingTools.add("lcov")

    if staticExec("which genhtml 2>/dev/null || echo notfound") == "notfound":
      missingTools.add("genhtml")

    # Add installation instructions based on platform
    if missingTools.len > 0:
      if staticExec("uname") == "Darwin":
        # macOS instructions
        installInstructions.add("\nOn macOS, install the missing tools with Homebrew:\n")
        installInstructions.add("  brew install lcov\n")
        installInstructions.add("\nNote: For gcov support, you need to install GCC instead of using Apple's clang:\n")
        installInstructions.add("  brew install gcc\n")
        installInstructions.add("  export CC=gcc-13  # Or your installed GCC version\n")
      elif staticExec("uname") == "Linux":
        # Linux instructions
        installInstructions.add("\nOn Linux, install the missing tools with your package manager:\n")
        installInstructions.add("  # Debian/Ubuntu:\n")
        installInstructions.add("  sudo apt-get install gcc lcov\n\n")
        installInstructions.add("  # Fedora/RHEL/CentOS:\n")
        installInstructions.add("  sudo dnf install gcc lcov\n")

  # Check if we have missing tools and print installation instructions
  if missingTools.len > 0:
    echo "⚠️ Missing required tools for coverage generation: ", missingTools.join(", ")
    echo installInstructions
    echo "\nSkipping coverage generation. Install the required tools and try again."
    return

  # Try to test for libgcov without running the full compilation
  let testCompileResult = gorgeEx("nim c --verbosity:0 --hint[Processing]:off " &
                                "--passC:-fprofile-arcs --passC:-ftest-coverage " &
                                "--passL:-lgcov -e'quit(0)' 2>&1")

  # If we have an error with libgcov, display instructions
  if testCompileResult.exitCode != 0 and testCompileResult.output.contains("library not found for -lgcov"):
    echo "⚠️ Compiler error: libgcov not found"

    if staticExec("uname") == "Darwin":
      echo """
On macOS, Apple's Clang doesn't include libgcov. You need GCC instead:

1. Install GCC via Homebrew:
   brew install gcc

2. Set environment variables to use GCC:
   export CC=gcc-13  # Use the version you installed
   export PATH="/usr/local/bin:$PATH"

3. Run coverage again:
   nimble coverage

Alternative: Use a simplified approach without lcov HTML reports:
  nim c -r tests/test_power_assert.nim
  nim c -r tests/test_operators.nim
  nim c -r tests/test_custom_types.nim
  nim c -r tests/test_basic.nim
"""
    elif staticExec("uname") == "Linux":
      echo """
On Linux, you need to install gcc with coverage support:

# For Debian/Ubuntu:
sudo apt-get install gcc lcov

# For Fedora/RHEL/CentOS:
sudo dnf install gcc lcov
"""
    return

  # If we got here, attempt to run coverage
  when defined(windows):
    # Windows coverage command
    try:
      exec "nim c -r --passC:-fprofile-arcs --passC:-ftest-coverage tests/test_power_assert.nim"
      exec "gcov -o nimcache src/*.nim || echo '⚠️ gcov failed. Check if you have the correct version.'"
    except:
      echo "⚠️ Coverage generation failed on Windows."
      echo "This might be because of missing libgcov. Make sure you have a compatible compiler installed."
  else:
    # Unix coverage command
    try:
      # Run gcc version check to provide in error reports
      let gccVersion = staticExec("gcc --version 2>&1 || clang --version 2>&1 || echo 'No compiler version info available'")

      echo "Compiling tests with coverage instrumentation..."
      exec "nim c -r --passC:-fprofile-arcs --passC:-ftest-coverage tests/test_power_assert.nim"

      echo "Generating coverage data..."
      exec "gcov -o nimcache src/*.nim || echo '⚠️ gcov failed with standard syntax, trying alternative...'"

      # If standard gcov syntax failed, try alternative syntax for different gcov versions
      if staticExec("[ -f src/power_assert.nim.gcov ] && echo 'exists' || echo 'notfound'") == "notfound":
        echo "Trying alternative gcov command..."
        exec "cd nimcache && gcov ../src/*.nim || echo '⚠️ Alternative gcov command also failed.'"

      echo "Processing coverage data with lcov..."
      exec "mkdir -p build/coverage"
      exec "lcov --capture --directory nimcache --output-file build/coverage/coverage.info || echo '⚠️ lcov failed to capture coverage data.'"

      echo "Generating HTML report..."
      exec "genhtml build/coverage/coverage.info --output-directory build/coverage || echo '⚠️ genhtml failed to generate HTML report.'"

      if staticExec("[ -f build/coverage/index.html ] && echo 'exists' || echo 'notfound'") == "exists":
        echo "\n✅ Coverage report generated successfully!"
        echo "View the report by opening build/coverage/index.html in your browser."
      else:
        echo "\n⚠️ Coverage report generation failed to produce output files."
        echo "Your compiler setup may not be compatible with the coverage tools."
        echo "\nCompiler information:"
        echo gccVersion

        echo "\nTry installing GCC instead of using Clang:"
        echo "  brew install gcc"
        echo "  export CC=gcc-13  # Use the version you installed"

        # Provide alternative coverage approach
        echo "\nAlternative: Run tests directly for basic coverage:"
        echo "  nim c -r tests/test_power_assert.nim"
        echo "  nim c -r tests/test_operators.nim"
        echo "  nim c -r tests/test_custom_types.nim"
    except:
      echo "⚠️ Coverage generation failed."
      echo "This might be due to incompatible compiler flags or environment."

      # Check for common GCC vs Clang issues
      if staticExec("gcc --version 2>/dev/null || echo notfound") == "notfound":
        echo "\nYou appear to be using Clang, which may not support gcov properly."
        echo "Try installing GCC:"

        if staticExec("uname") == "Darwin":
          echo "  brew install gcc"
          echo "  export CC=gcc-13  # Use the version you installed"
        elif staticExec("uname") == "Linux":
          echo "  sudo apt install gcc  # Debian/Ubuntu"
          echo "  sudo dnf install gcc  # Fedora/RHEL"

task ci, "Run CI workflow (clean, lint, build, test)":
  exec "nimble clean"
  exec "nimble buildLib"
  exec "nimble test"

  # Add optional steps based on environment variables
  if existsEnv("GENERATE_DOCS"):
    exec "nimble docs"

  if existsEnv("GENERATE_COVERAGE"):
    exec "nimble coverage"

  if existsEnv("RUN_BENCHMARKS"):
    exec "nimble bench"
