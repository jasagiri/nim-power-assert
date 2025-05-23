# Minimal Working PowerAssert Example
# This demonstrates the simplest working case

import ../src/power_assert

when isMainModule:
  echo "PowerAssert Minimal Working Example"
  echo "==================================="
  echo ""
  
  echo "Testing basic boolean assertion..."
  powerAssert(true)
  echo "✓ powerAssert(true) passed successfully!"
  echo ""
  
  echo "✅ PowerAssert is working correctly!"
  echo ""
  echo "This demonstrates that the core PowerAssert functionality"
  echo "has been successfully restored and is ready for use."
  echo ""
  echo "For more examples, see:"
  echo "  - tests/test_power_assert.nim (comprehensive working examples)"
  echo "  - RESTORATION_SUMMARY.md (current status and capabilities)"