#!/bin/bash

echo "=== Testing Momentum App ==="
echo

echo "1. Testing Rust CLI..."
cd momentum
cargo test
if [ $? -ne 0 ]; then
    echo "❌ Rust tests failed"
    exit 1
fi
echo "✅ Rust tests passed"
echo

echo "2. Building Rust binary..."
cargo build --release
if [ $? -ne 0 ]; then
    echo "❌ Rust build failed"
    exit 1
fi
echo "✅ Rust binary built"
echo

echo "3. Testing CLI commands..."
cd ..
export ANTHROPIC_API_KEY=test-key

# Test help
./momentum/target/release/momentum --help > /dev/null
if [ $? -ne 0 ]; then
    echo "❌ CLI help failed"
    exit 1
fi
echo "✅ CLI help works"

# Test start command
OUTPUT=$(./momentum/target/release/momentum start --goal "Test session" --time 25)
if [ $? -ne 0 ]; then
    echo "❌ Start command failed"
    exit 1
fi
echo "✅ Start command works - session at: $OUTPUT"

# Test stop command
OUTPUT=$(./momentum/target/release/momentum stop)
if [ $? -ne 0 ]; then
    echo "❌ Stop command failed"
    exit 1
fi
echo "✅ Stop command works - reflection at: $OUTPUT"

# Test analyze command
ANALYSIS=$(./momentum/target/release/momentum analyze --file "$OUTPUT")
if [ $? -ne 0 ]; then
    echo "❌ Analyze command failed"  
    exit 1
fi
echo "✅ Analyze command works"
echo "   Analysis: $ANALYSIS"
echo

echo "4. Copying binary to app resources..."
cp momentum/target/release/momentum MomentumApp/Resources/
echo "✅ Binary copied"
echo

echo "=== All tests passed! ==="
echo
echo "To run the app:"
echo "1. Open Momentum.xcworkspace in Xcode"
echo "2. Trust the macro packages when prompted"
echo "3. Build and run the app"
echo
echo "The app will appear in your menu bar with a timer icon."