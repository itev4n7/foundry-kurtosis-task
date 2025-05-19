#!/bin/bash

DEBUG=false

# Parse flags
for arg in "$@"; do
  case $arg in
    --debug)
      DEBUG=true
      ;;
  esac
done

# Stage 1 – Raw Precompile Invocation
echo
echo "-------------------------------------"
echo "     🏗️  Proceeding with stage 1     "
echo "-------------------------------------"
echo

echo "🔄 Running precompiled contract tests..."

if [ "$DEBUG" = true ]; then
  pnpm run test-precompile
else
  OUTPUT=$(pnpm run test-precompile --silent 2>&1)
  echo "$OUTPUT" > /tmp/test-precompile-output.log

  if echo "$OUTPUT" | grep -qE "fail|FAIL|✗"; then
    FAILED=$(grep -oE "[0-9]+ failed" /tmp/test-precompile-output.log | head -n1)
    echo -e "\033[1;31m❌ Tests failed\033[0m"
    echo -e "   \033[1;31m$FAILED\033[0m"
  else
    PASSED=$(grep -oE "[0-9]+ passed" /tmp/test-precompile-output.log | head -n1)
    echo -e "\033[1;32m✅ Tests passed\033[0m"
    echo -e "   \033[1;32m$PASSED\033[0m"
  fi

  LOCATION=$(echo "$OUTPUT" | grep -oE 'test/[^ ]+\.ts' | head -n1)
  echo "   📂 Location: $LOCATION"
fi

# Stage 2 – Contract Wrapper Deployment
echo
echo "-------------------------------------"
echo "     🏗️  Proceeding with stage 2     "
echo "-------------------------------------"
echo

# Load environment for local testing
source .env

echo "🔄 Deploying contract..."
DEPLOY_OUTPUT=$(forge script script/StorageHash.s.sol \
  --rpc-url kurtosis \
  --private-key $PRIVATE_KEY \
  --legacy \
  --json \
  --broadcast)

echo "$DEPLOY_OUTPUT" > /tmp/foundry-deploy-output.log

if [ "$DEBUG" = true ]; then
  echo "$DEPLOY_OUTPUT"
else
  CLEAN_DEPLOY_OUTPUT=$(echo "$DEPLOY_OUTPUT" | tail -n 2 | head -n 1)
  CONTRACT_ADDRESS=$(echo "$CLEAN_DEPLOY_OUTPUT" | jq -r '.contract_address')
  TX_HASH=$(echo "$CLEAN_DEPLOY_OUTPUT" | jq -r '.tx_hash')
  echo "🚀 Contract deployed at: $CONTRACT_ADDRESS"
  echo "🔗 Tx hash: $TX_HASH"
fi

echo

echo "🔄 Running post-deploy tests..."
if [ "$DEBUG" = true ]; then
  pnpm run test-post-deploy
else
  OUTPUT=$(pnpm run test-post-deploy --silent 2>&1)
  echo "$OUTPUT" > /tmp/test-post-deploy-output.log

  if echo "$OUTPUT" | grep -qE "fail|FAIL|✗"; then
    FAILED=$(grep -oE "[0-9]+ failed" /tmp/test-post-deploy-output.log | head -n1)
    echo -e "\033[1;31m❌ Tests failed\033[0m"
    echo -e "   \033[1;31m$FAILED\033[0m"
  else
    PASSED=$(grep -oE "[0-9]+ passed" /tmp/test-post-deploy-output.log | head -n1)
    echo -e "\033[1;32m✅ Tests passed\033[0m"
    echo -e "   \033[1;32m$PASSED\033[0m"
  fi

  LOCATION=$(echo "$OUTPUT" | grep -oE 'test/[^ ]+\.ts' | head -n1)
  echo "   📂 Location: $LOCATION"
fi

# Stage 3 – Post-deployment checks
echo
echo "-------------------------------------"
echo "     🏗️  Proceeding with stage 3    "
echo "-------------------------------------"
echo

echo "🔄 Running contract invocation tests..."

if [ "$DEBUG" = true ]; then
  pnpm run test-contract-invocation
else
  OUTPUT=$(pnpm run test-contract-invocation --silent 2>&1)
  echo "$OUTPUT" > /tmp/test-contract-invocation-output.log

  if echo "$OUTPUT" | grep -qE "fail|FAIL|✗"; then
    FAILED=$(grep -oE "[0-9]+ failed" /tmp/test-contract-invocation-output.log | head -n1)
    echo -e "\033[1;31m❌ Tests failed\033[0m"
    echo -e "   \033[1;31m$FAILED\033[0m"
  else
    PASSED=$(grep -oE "[0-9]+ passed" /tmp/test-contract-invocation-output.log | head -n1)
    echo -e "\033[1;32m✅ Tests passed\033[0m"
    echo -e "   \033[1;32m$PASSED\033[0m"
  fi

  LOCATION=$(echo "$OUTPUT" | grep -oE 'test/[^ ]+\.ts' | head -n1)
  echo "   📂 Location: $LOCATION"
fi

echo

# Save report
{
  echo "===== 🧪 Precompile Test Output ====="
  cat /tmp/test-precompile-output.log
  echo

  echo "===== 🧪 Foundry Deploy Output ====="
  cat /tmp/foundry-deploy-output.log
  echo

  echo "===== 🧪 Post-Deploy Test Output ====="
  cat /tmp/test-post-deploy-output.log
  echo

  echo "===== 🧪 Contract Invocation Output ====="
  cat /tmp/test-contract-invocation-output.log
  echo
} > scripts-report.txt

# Clean up the temp files
rm -f /tmp/test-precompile-output.log
rm -f /tmp/foundry-deploy-output.log
rm -f /tmp/test-post-deploy-output.log
rm -f /tmp/test-contract-invocation-output.log

echo -e "📦 Please check the logs in \033[4m./scripts-report.txt\033[0m for details."
