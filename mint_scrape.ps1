$URL = 'https://www.mint.com/'
$Site = Invoke-WebRequest $URL

# Login Information
$USER = 'evanr777@protonmail.com'
$PASS = 'A2uqbg2x!'

$Driver = Start-SeFirefox -Headless
# TODO use chrome
# $ChromeDriver = New-Object OpenQA.Selenium.Chrome.ChromeDriver

Enter-SeUrl -Driver $Driver -Url 'https://www.mint.com/'

# todo wait
start-sleep -Milliseconds 1000

# click sign in button in upper right hand 
Find-SeElement -Driver $Driver -XPath '/html/body/div[1]/div/section[1]/header/div/div[3]/a[2]' | Invoke-SeClick

start-sleep -Milliseconds 1000

# enter username
$UserInput = Find-SeElement -Driver $Driver -XPath '//*[@id="ius-userid"]'
Send-SeKeys -Element $UserInput -Keys "$USER"

# enter password
$PasswordInput = Find-SeElement -Driver $Driver -XPath '//*[@id="ius-password"]'
Send-SeKeys -Element $PasswordInput -Keys "$PASS"

# click login page sign in button 
Find-SeElement -Driver $Driver -XPath '//*[@id="ius-sign-in-submit-btn"]' | Invoke-SeClick

start-sleep -Milliseconds 5000

#TODO print account name, category, net worth
# TODO zoom out
# TODO headless
$CashAccounts = $Driver.FindElementsByClassName('accounts-data-li')
foreach ($account in $CashAccounts) {
  $balance = $account.FindElementByClassName('balance')
  Write-Output $balance.Text
}
