# FUNCTIONS

# WebDriver Functions
Function Write-AccountInfo ($AccountList, $AccountType) {
  $AccountBalanceElement = $AccountList.FindElementByClassName('balance')
  $AccountListElement = $AccountList.FindElementsByClassName('accounts-data-li')
  $OutputList = New-Object System.Collections.ArrayList

  foreach ($Account in $AccountListElement) {
    $AccountName = $Account.FindElementByClassName('accountName')
    $Balance = $Account.FindElementByClassName('balance')
  
    $temp = New-Object System.Object
    $temp | Add-Member -MemberType NoteProperty -Name "Account Name" -Value $AccountName.Text
    $temp | Add-Member -MemberType NoteProperty -Name "Balance" -Value $Balance.Text
  
    $OutputList.add($temp) | Out-Null
  }

  # print account type title and total
  Write-Host -NoNewLine "$($AccountType): $($AccountBalanceElement.Text)"
  # print individual account information
  $OutputList | Format-Table -Property *
}

Function Unlock-MintDashboard ($Driver) {
  # navigate to mint website
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
}

Function Format-MintDashboard ($Driver) {
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
}

Function Write-NetWorth($Driver) {
  $NetWorthElement = $Driver.FindElementByXPath('//*[@id="module-accounts"]/div/ul[2]/li[3]/span');
  Write-Host "Net Worth: $($NetWorthElement.Text)"
}

Function Open-AccountList($AccountList) {
  if (!($AccountList.GetAttribute("class") -split " " -contains "open")) {
    $AccountList.Click()
  }
}

# SCRIPT
$URL = 'https://www.mint.com/'
$Site = Invoke-WebRequest $URL

# Login Information
$USER = ''
$PASS = ''
$Driver = Start-SeChrome -Minimized

Unlock-MintDashboard $Driver
Format-MintDashboard $Driver

# TODO use enums to map account types to selectors
# TODO create const for selectors

# open account sections if not currently open
$CashList = $Driver.FindElementsByCssSelector('#moduleAccounts-bank')
$CreditList = $Driver.FindElementsByCssSelector('#moduleAccounts-credit')
$InvestmentList = $Driver.FindElementsByCssSelector('#moduleAccounts-investment')

# open account sections if not opened
Open-AccountList $CashList
Open-AccountList $CreditList
Open-AccountList $InvestmentList

# display Net Worth, Account Categories and Account Information
Write-Host `n
Write-NetWorth $Driver
Write-Host `n

Write-AccountInfo $CashList "Cash"
Write-AccountInfo $CreditList "Credit"
Write-AccountInfo $InvestmentList "Investments"

# close Browser
$Driver.Quit()


