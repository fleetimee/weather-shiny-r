# Setup script for shinyapps.io account configuration
# Run this script first before deploying

cat("=== SHINYAPPS.IO ACCOUNT SETUP ===\n\n")
cat("Please follow these steps:\n\n")
cat("1. Go to https://www.shinyapps.io/ and create an account (if needed)\n")
cat("2. Log in to your shinyapps.io account\n")
cat("3. Go to Account -> Tokens\n")
cat("4. Copy the complete rsconnect::setAccountInfo() command\n")
cat("5. Paste and run it in this R session\n\n")

cat("The command will look like this:\n")
cat("rsconnect::setAccountInfo(name='your-username',\n")
cat("                         token='ABC123...',\n")
cat("                         secret='XYZ789...')\n\n")

cat("After running your token command, you can proceed with deployment.\n\n")

# Load rsconnect
library(rsconnect)

# Check current account status
accounts <- rsconnect::accounts()
if(nrow(accounts) > 0) {
  cat("✅ Account already configured:", accounts$name[1], "\n")
  cat("You can now run the deployment script!\n")
} else {
  cat("⏳ Waiting for account configuration...\n")
  cat("Run your token command above, then check again.\n")
}