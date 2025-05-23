#!/bin/sh
# Test coverage script for power_assert_nim on macOS
# Uses LLVM-based coverage which is compatible with Apple's Clang

set -e

# Get the project root directory
PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TESTS_DIR="${PROJECT_ROOT}/tests"
BUILD_DIR="${PROJECT_ROOT}/build/tests"
COVERAGE_DIR="${PROJECT_ROOT}/coverage"

# Create directories if they don't exist
mkdir -p "${BUILD_DIR}"
mkdir -p "${COVERAGE_DIR}"

echo "Running tests with LLVM-based coverage instrumentation..."

# Clean old coverage data
rm -rf "${COVERAGE_DIR}"/*
rm -f *.profraw *.profdata

# Coverage flags for LLVM (compatible with Apple Clang)
COVERAGE_FLAGS="--passC:-fprofile-instr-generate --passC:-fcoverage-mapping --passL:-fprofile-instr-generate"

# Run tests with coverage instrumentation
echo "Running test_power_assert.nim with coverage..."
LLVM_PROFILE_FILE="test_power_assert.profraw" nim c $COVERAGE_FLAGS -r -o:"${BUILD_DIR}/test_power_assert" "${TESTS_DIR}/test_power_assert.nim"

echo "Running test_operators.nim with coverage..."
LLVM_PROFILE_FILE="test_operators.profraw" nim c $COVERAGE_FLAGS -r -o:"${BUILD_DIR}/test_operators" "${TESTS_DIR}/test_operators.nim"

echo "Running test_custom_types.nim with coverage..."
LLVM_PROFILE_FILE="test_custom_types.profraw" nim c $COVERAGE_FLAGS -r -o:"${BUILD_DIR}/test_custom_types" "${TESTS_DIR}/test_custom_types.nim"

echo "Running test_helpers.nim with coverage..."
LLVM_PROFILE_FILE="test_helpers.profraw" nim c $COVERAGE_FLAGS -r -o:"${BUILD_DIR}/test_helpers" "${TESTS_DIR}/test_helpers.nim"

echo "Running test_enhanced_output.nim with coverage..."
LLVM_PROFILE_FILE="test_enhanced_output.profraw" nim c $COVERAGE_FLAGS -r -o:"${BUILD_DIR}/test_enhanced_output" "${TESTS_DIR}/test_enhanced_output.nim"

echo "Running test_edge_cases.nim with coverage..."
LLVM_PROFILE_FILE="test_edge_cases.profraw" nim c $COVERAGE_FLAGS -r -o:"${BUILD_DIR}/test_edge_cases" "${TESTS_DIR}/test_edge_cases.nim"

# Merge profile data
echo "Merging coverage data..."
if command -v llvm-profdata >/dev/null 2>&1; then
    llvm-profdata merge -sparse *.profraw -o merged.profdata
else
    echo "Warning: llvm-profdata not found. Coverage merge skipped."
fi

# Generate coverage report
echo "Generating coverage report..."
if command -v llvm-cov >/dev/null 2>&1 && [ -f merged.profdata ]; then
    # Create HTML report
    llvm-cov show "${BUILD_DIR}/test_power_assert" -instr-profile=merged.profdata -format=html -output-dir="${COVERAGE_DIR}" -sources="${PROJECT_ROOT}/src"
    
    # Create summary report
    llvm-cov report "${BUILD_DIR}/test_power_assert" -instr-profile=merged.profdata -sources="${PROJECT_ROOT}/src" > "${COVERAGE_DIR}/coverage_summary.txt"
    
    echo "Coverage report generated at: ${COVERAGE_DIR}"
    echo "Summary:"
    cat "${COVERAGE_DIR}/coverage_summary.txt"
else
    echo "Warning: llvm-cov not found or no profile data available. HTML report not generated."
fi

# Check if coverage should be opened in browser
if [ "${OPEN_COVERAGE}" = "true" ] && [ -f "${COVERAGE_DIR}/index.html" ]; then
    echo "Opening coverage report in default browser..."
    open "${COVERAGE_DIR}/index.html"
fi

# Clean up temporary files
rm -f *.profraw *.profdata

echo "Coverage reporting completed successfully."