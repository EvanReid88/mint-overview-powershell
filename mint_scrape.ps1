$URL = 'https://www.mint.com/'
$Site = Invoke-WebRequest $URL

# Login Information
$USER = ''
$PASS = ''

$Driver = Start-SeFirefox
# TODO use chrome
# $ChromeDriver = New-Object OpenQA.Selenium.Chrome.ChromeDriver

Write-Output `n

Enter-SeUrl -Driver $Driver -Url 'https://www.mint.com/'

# click sign in button in upper right hand 
Find-SeElement -Driver $Driver -Timeout 2 -XPath '/html/body/div[1]/div/section[1]/header/div/div[3]/a[2]' | Invoke-SeClick

# enter username
$UserInput = Find-SeElement -Driver $Driver -Timeout 2 -XPath '//*[@id="ius-userid"]'
Send-SeKeys -Element $UserInput -Keys "$USER"

# enter password
$PasswordInput = Find-SeElement -Driver $Driver -Timeout 2 -XPath '//*[@id="ius-password"]'
Send-SeKeys -Element $PasswordInput -Keys "$PASS"

# click login page sign in button 
Find-SeElement -Driver $Driver -Timeout 2 -XPath '//*[@id="ius-sign-in-submit-btn"]' | Invoke-SeClick

# wait for goals dialog to show, and close
Find-SeElement -Driver $Driver -Timeout 20 -XPath '/html/body/div[8]/div/div[3]/div/div/button' | Invoke-SeClick

Start-Sleep -Milliseconds 1000
$Body = $Driver.FindElementsByCssSelector('#body-mint');
$NumPress = 12

# press down 10 times to bring accounts into view
while ($NumPress -gt 0) {
  $Body.SendKeys([OpenQA.Selenium.Keys]::Down)
  start-sleep -Milliseconds 100
  $NumPress--
}

# Open account sections if not currently open
$CashCaret = $Driver.FindElementsByCssSelector('#moduleAccounts-bank');
$CreditCaret = $Driver.FindElementsByCssSelector('#moduleAccounts-credit')
$InvestmentCaret = $Driver.FindElementsByCssSelector('#moduleAccounts-investment')

# TODO create methods
if (!($CashCaret.GetAttribute("class") -split " " -contains "open")) {
  $CashCaret.Click()
}

if (!($CreditCaret.GetAttribute("class") -split " " -contains "open")) {
  $CreditCaret.Click()
}

if (!($InvestmentCaret.GetAttribute("class") -split " " -contains "open")) {
  $InvestmentCaret.Click()
}

#TODO print account name, category, net worth
$CashAccounts = $Driver.FindElementsByClassName('accounts-data-li')
foreach ($account in $CashAccounts) {
  $accountName = $account.FindElementByClassName('accountName')
  $balance = $account.FindElementByClassName('balance')
  $output = $accountName.Text + ":       " + $balance.Text
  Write-Output $output
}

$Driver.Quit()
