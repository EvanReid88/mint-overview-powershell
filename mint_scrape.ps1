$URL = 'https://www.mint.com/'
$Site = Invoke-WebRequest $URL

# Login Information
$USER = 'evanr777@protonmail.com'
$PASS = 'A2uqbg2x!'

$Driver = Start-SeFirefox
Enter-SeUrl -Driver $Driver -Url 'https://www.mint.com/'

# todo wait
start-sleep -Milliseconds 3000

# click sign in button in upper right hand 
Find-SeElement -Driver $Driver -XPath '/html/body/div[1]/div/section[1]/header/div/div[3]/a[2]' | Invoke-SeClick

start-sleep -Milliseconds 3000

# enter username
$UserInput = Find-SeElement -Driver $Driver -XPath '//*[@id="ius-userid"]'
Send-SeKeys -Element $UserInput -Keys "$USER"

# enter password
$PasswordInput = Find-SeElement -Driver $Driver -XPath '//*[@id="ius-password"]'
Send-SeKeys -Element $PasswordInput -Keys "$PASS"

# click login page sign in button 
Find-SeElement -Driver $Driver -XPath '//*[@id="ius-sign-in-submit-btn"]' | Invoke-SeClick

start-sleep -Milliseconds 10000

# $CashList = Find-SeElement -Driver $Driver -XPath '//*[@id="moduleAccounts-bank"]'
# $CashAccounts = Find-SeElement -TagName li -Element $CashList | Measure-Object
$CashAccounts = $Driver.FindElements([OpenQA.Selenium.By]::CssSelector('accounts-data-li'))

foreach ($account in $CashAccounts) {
  Write-Output 'test'
}
