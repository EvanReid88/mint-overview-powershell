# FUNCTIONS
Function Write-AccountInfo ($accountList, $accountType) {
  $AccountBalanceElement = $accountList.FindElementByClassName('balance')
  $AccountListElement = $accountList.FindElementsByClassName('accounts-data-li')
  $outputList = New-Object System.Collections.ArrayList

  foreach ($account in $AccountListElement) {
    $accountName = $account.FindElementByClassName('accountName')
    $balance = $account.FindElementByClassName('balance')
  
    $temp = New-Object System.Object
    $temp | Add-Member -MemberType NoteProperty -Name "Account Name" -Value $accountName.Text
    $temp | Add-Member -MemberType NoteProperty -Name "Balance" -Value $balance.Text
  
    $outputList.add($temp) | Out-Null
  }

  # Print account type title and total
  Write-Host -NoNewLine "$($accountType): $($AccountBalanceElement.Text)"
  # Print individual account information
  $outputList | Format-Table -Property *
}

Function Write-NetWorth($Driver) {
  $NetWorthElement = $Driver.FindElementByXPath('//*[@id="module-accounts"]/div/ul[2]/li[3]/span');
  Write-Host "Net Worth: $($NetWorthElement.Text)"
}


# SCRIPT
$URL = 'https://www.mint.com/'
$Site = Invoke-WebRequest $URL

# Login Information
$USER = ''
$PASS = ''

$Driver = Start-SeChrome
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

Start-Sleep -Milliseconds 300
$Body = $Driver.FindElementsByCssSelector('#body-mint');
$NumPress = 18

# press down 10 times to bring accounts into view
while ($NumPress -gt 0) {
  $Body.SendKeys([OpenQA.Selenium.Keys]::Down)
  start-sleep -Milliseconds 100
  $NumPress--
}

# Open account sections if not currently open
$CashList = $Driver.FindElementsByCssSelector('#moduleAccounts-bank');
$CreditList = $Driver.FindElementsByCssSelector('#moduleAccounts-credit')
$InvestmentList = $Driver.FindElementsByCssSelector('#moduleAccounts-investment')

# TODO create methods
if (!($CashList.GetAttribute("class") -split " " -contains "open")) {
  $CashList.Click()
}

if (!($CreditList.GetAttribute("class") -split " " -contains "open")) {
  $CreditList.Click()
}

if (!($InvestmentList.GetAttribute("class") -split " " -contains "open")) {
  $InvestmentList.Click()
}

$accountList = New-Object System.Collections.ArrayList

Write-NetWorth
#TODO print account name, category, net worth
Write-AccountInfo $CashList "Cash"
Write-AccountInfo $CreditList "Credit"
Write-AccountInfo $InvestmentList "Investments"

#$Driver.Quit()


