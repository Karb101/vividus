Description: Integration tests for mobile app steps

Meta:
    @epic vividus-plugin-mobile-app

Lifecycle:
Examples:
/data/tables/system/mobile_app/locators/${target-platform}.table


Scenario: Verify step: 'Given I start mobile application with capabilities:$capabilities'
Given I start mobile application with capabilities:
|name|value     |
|app |${app-url}|


Scenario: VerifyStep: 'When I execute javascript `$wcript` and save result to $scopes variable `$variableName`'
When I execute javascript `mobile: deviceInfo` and save result to scenario variable `deviceInfo`
Then `${deviceInfo}` matches `.*timeZone.*`

Scenario: Verify step: 'When I reinstall mobile application with bundle identifier `$bundleId`'
Meta:
    @requirementId 2073
When I tap on element located `accessibilityId(menuToggler)`
When I tap on element located `xpath(<menuInputXpath>)`
When I reinstall mobile application with bundle identifier `${main-app}`
When I wait until element located `xpath(<textElementXpath>)->filter.text(Home)` appears


Scenario: Validate coordinate/size dynamic variables, page source dynamic variable
Then `${source-code}` matches `.+Home.+`
When I change context to element located `xpath(<textElementXpath>)->filter.text(Home)`
Then `${context-height}`            is > `0`
Then `${context-width}`             is > `0`
Then `${context-x-coordinate}`      is > `0`
Then `${context-y-coordinate}`      is > `0`
When I reset context


Scenario: Verify steps: 'When I press $key key', 'Then number of $state elements found by `$locator` is $comparisonRule `$quantity`', 'When I press keys:$keys' and Text Part Filter and Text Filter
Then number of elements found by `xpath(<textElementXpath>)->filter.text(Home)` is equal to `1`
When I press Home key
Then number of elements found by `xpath(<textElementXpath>)->filter.text(Home)` is equal to `0`
When I activate application with bundle identifier `${main-app}`
When I wait until element located `xpath(<textElementXpath>)->filter.textPart(om)` appears
When I press keys:
|key |
|Home|
Then number of elements found by `xpath(<textElementXpath>)->filter.text(Home)` is equal to `0`
When I activate application with bundle identifier `${main-app}`
When I wait until element located `xpath(<textElementXpath>)->filter.textPart(om)` appears


Scenario: [Android] Verify step: 'When I change Appium session settings:$settings' and Id Locator
Meta:
    @targetPlatform android
Then number of elements found by `id(com.vividustestapp:id/action_bar_root)` is equal to `1`
Then number of elements found by `xpath(<menuButtonXpath>):a` is equal to `0`
When I change Appium session settings:
|name                  |value|
|allowInvisibleElements|true |
Then number of elements found by `xpath(<menuButtonXpath>):a` is equal to `1`
When I change Appium session settings:
|name                  |value|
|allowInvisibleElements|false|
Then number of elements found by `xpath(<menuButtonXpath>):a` is equal to `0`


Scenario: [iOS] Verify step: 'When I change Appium session settings:$settings' and Id Locator
Meta:
    @targetPlatform ios
Then number of elements found by `id(menuToggler)` is equal to `1`
Then number of elements found by `xpath(<menuButtonXpath>):a` is equal to `1`
When I change Appium session settings:
|name            |value|
|snapshotMaxDepth|1    |
Then number of elements found by `xpath(<menuButtonXpath>):a` is equal to `0`
When I change Appium session settings:
|name            |value     |
|snapshotMaxDepth|50        |
Then number of elements found by `xpath(<menuButtonXpath>):a` is equal to `1`


Scenario: Verify step: 'Then number of $state elements found by `$locator` is $comparisonRule `$quantity`' and Accessibility Id Locator
Then number of VISIBLE elements found by `accessibilityId(menuToggler):a` is equal to `1`


Scenario: Verify step: 'When I tap on element located `$locator` with duration `$duration`'
Then number of elements found by `xpath(<menuButtonXpath>)` is equal to `0`
When I tap on element located `accessibilityId(menuToggler)` with duration `PT0.5S`
Then number of elements found by `xpath(<menuButtonXpath>)` is equal to `1`


Scenario: Verify step: 'When I tap on element located `$locator`' and Attribute Filter
Then number of elements found by `accessibilityId(increment)` is equal to `0`
When I tap on element located `xpath(<menuButtonXpath>)->filter.attribute(${visibility-attribute})`
Then number of elements found by `accessibilityId(increment)->filter.attribute(${visibility-attribute}=true)` is equal to `1`


Scenario: Verify step: 'When I navigate back'
Meta:
    @targetPlatform android

!-- The step doesn't work with newer version of iOS due to absence of navigation controls on the screen
When I navigate back
Then number of elements found by `xpath(<menuButtonXpath>)` is equal to `0`


Scenario: Verify step: 'When I type text `$text`'
Meta:
    @targetPlatform android

When I tap on element located `accessibilityId(menuToggler)`
When I tap on element located `xpath(<menuInputXpath>)`
Then number of elements found by `xpath(<nameDisplayXpath>)` is equal to `0`
When I tap on element located `accessibilityId(nameInput)`
Given I initialize story variable `text` with value `#{generate(regexify '[a-z]{10}')}`
When I type text `${text}`
Then number of elements found by `xpath(<nameDisplayXpath>)` is equal to `1`
When I clear field located `accessibilityId(nameInput)`
Then number of elements found by `xpath(<nameDisplayXpath>)` is equal to `0`
When I navigate back


Scenario: Verify step: 'When I type `$text` in field located `$locator`'
Given I initialize story variable `text` with value `#{generate(regexify '[a-z]{10}')}`
When I tap on element located `accessibilityId(menuToggler)`
When I tap on element located `xpath(<menuInputXpath>)`
When I type `${text}` in field located `accessibilityId(nameInput)`
Then number of elements found by `xpath(<nameDisplayXpath>)` is equal to `1`


Scenario: Verify dynamic variable: 'clipboard-text'
When I tap on element located `accessibilityId(CopyTextToClipboardButton)`
Then `${clipboard-text}` is equal to `${text}`


Scenario: Verify step: 'When I clear field located `$locator`' and Appium XPath Locator
When I clear field located `accessibilityId(nameInput)`
Then number of elements found by `xpath(<nameInputXpath>)` is equal to `1`

!-- There should be no error when trying to clear an empty field
When I clear field located `accessibilityId(nameInput)`
Then number of elements found by `xpath(<nameInputXpath>)` is equal to `1`


Scenario: Verify step: 'When I type `$text` in field located `$locator` and keep keyboard opened'
Meta:
    @requirementId 1927
    @targetPlatform ios
!-- Typing on android emulator doesn't shows a keyboard.
Given I initialize story variable `text` with value `#{generate(regexify '[a-z]{10}')}`
When I type `${text}` in field located `accessibilityId(nameInput)` and keep keyboard opened
When I save `<textFieldValueAttribute>` attribute value of element located `accessibilityId(nameInput)` to scenario variable `typedText`
Then number of elements found by `xpath(<nameDisplayXpath>)` is equal to `1`
Then number of elements found by `<keyboardLocator>` is equal to `1`
Then `${text}` is equal to `${typedText}`
When I tap on element located `accessibilityId(Return)`
Then number of elements found by `<keyboardLocator>` is equal to `0`


Scenario: Verify step: 'When I clear field located `$locator` and keep keyboard open'
Meta:
    @requirementId 2617
    @targetPlatform ios
!-- Typing on android emulator doesn't shows a keyboard.
Then number of elements found by `xpath(<nameDisplayXpath>)` is equal to `1`
When I clear field located `accessibilityId(nameInput)` and keep keyboard open
Then number of elements found by `xpath(<nameDisplayXpath>)` is equal to `0`
Then number of elements found by `xpath(<nameInputXpath>)` is equal to `1`
Then number of elements found by `<keyboardLocator>` is equal to `1`
When I tap on element located `accessibilityId(Return)`
Then number of elements found by `<keyboardLocator>` is equal to `0`


Scenario: Verify step: 'When I wait until element located `$locator` disappears'
When I tap on element located `accessibilityId(menuToggler)`
When I tap on element located `xpath(<menuWaitXpath>)`
Then number of elements found by `accessibilityId(picture)` is equal to `1`
When I tap on element located `accessibilityId(hidePicture)`
When I wait until element located `accessibilityId(picture)` disappears
Then number of elements found by `accessibilityId(picture)` is equal to `0`


Scenario: Verify step: 'When I wait until element located `$locator` appears'
Then number of elements found by `accessibilityId(picture)` is equal to `0`
When I tap on element located `accessibilityId(showPicture)`
When I wait until element located `accessibilityId(picture)` appears
Then number of elements found by `accessibilityId(picture)` is equal to `1`


Scenario: Verify step: 'When I swipe $direction to element located `$locator` with duration $swipeDuration'
When I tap on element located `accessibilityId(menuToggler)`
When I tap on element located `xpath(<menuScrollViewXpath>)`
Then number of elements found by `accessibilityId(header)` is equal to `1`
Then number of elements found by `accessibilityId(footer)` is equal to `0`
When I swipe UP to element located `accessibilityId(footer)` with duration PT1S
Then number of elements found by `accessibilityId(header)` is equal to `0`
Then number of elements found by `accessibilityId(footer)` is equal to `1`
When I swipe DOWN to element located `accessibilityId(header)` with duration PT1S
Then number of elements found by `accessibilityId(header)` is equal to `1`
Then number of elements found by `accessibilityId(footer)` is equal to `0`


Scenario: [Android] Verify step: 'When I upload file `$filePath` to device'
Meta:
    @targetPlatform android
When I tap on element located `accessibilityId(menuToggler)`
When I tap on element located `xpath(//android.widget.TextView[@text='Image'])`
When I upload file `/data/mobile-upload-image.png` to device
When I tap on element located `accessibilityId(selectImage)`
When I wait until element located `xpath(//android.widget.TextView[@text='Pictures'])` appears
When I tap on element located `xpath(//android.widget.TextView[@text='Pictures'])`
When I tap on element located `xpath((//android.view.ViewGroup[contains(@content-desc, "Photo taken")])[1])`
Then number of elements found by `xpath(//android.widget.TextView[@text='228x228'])` is equal to `1`


Scenario: [iOS] Verify step: 'When I upload file `$filePath` to device' AND 'iosClassChain' locator AND 'iosNsPredicate' locator
Meta:
    @targetPlatform ios
When I tap on element located `accessibilityId(menuToggler)`
When I tap on element located `iosClassChain(**/XCUIElementTypeButton[$name == "Image"$])`
When I upload file `/data/mobile-upload-image.png` to device
When I tap on element located `iosNsPredicate(name == 'selectImage')`
When I wait until element located `accessibilityId(Photos)` appears
When I tap on element located `xpath((//XCUIElementTypeImage[contains(@name, "Photo")])[1])`
Then number of elements found by `xpath(//XCUIElementTypeStaticText[@value='228x228'])` is equal to `1`


Scenario: [Android] Verify step: 'When I delete file `$filePath` from device'
Meta:
    @targetPlatform android
When I delete file `/sdcard/Pictures/mobile-upload-image.png` from device
When I tap on element located `accessibilityId(selectImage)`
When I wait until element located `xpath(//android.widget.TextView[@text='Pictures'])` disappears


Scenario: [iOS] Verify step: 'When I delete file `$filePath` from device'
Meta:
    @targetPlatform ios
When I delete file `/Media/DCIM/100APPLE/IMG_0001.JPG` from device
!-- The validation is not possible for this scenario yet. To see the changes in "Camera roll" after deleting image, it
!-- is necessary to delete old photo database and restart device, which is not possible.


Scenario: Verify step: 'When I activate application with bundle identifier `$bundleId`'
When I activate application with bundle identifier `${browser-app}`
When I wait until element located `accessibilityId(menuToggler)` disappears
When I activate application with bundle identifier `${main-app}`
When I wait until element located `accessibilityId(menuToggler)` appears


Scenario: Verify step: 'When I terminate application with bundle identifier `$bundleId`'
Meta:
    @requirementId 2073
When I terminate application with bundle identifier `${main-app}`
When I wait until element located `accessibilityId(menuToggler)` disappears
When I activate application with bundle identifier `${main-app}`
When I wait until element located `accessibilityId(menuToggler)` appears


Scenario: Verify step: 'When I send mobile application to background for `$period` period'
When I tap on element located `accessibilityId(menuToggler)`
When I tap on element located `xpath(<menuScrollViewXpath>)`
Then number of elements found by `accessibilityId(header)` is equal to `1`
Then number of elements found by `accessibilityId(footer)` is equal to `0`
When I send mobile application to background for `PT-1S` period
Then number of elements found by `accessibilityId(header)` is equal to `0`
Then number of elements found by `accessibilityId(footer)` is equal to `0`
When I activate application with bundle identifier `${main-app}`
Then number of elements found by `accessibilityId(header)` is equal to `1`
Then number of elements found by `accessibilityId(footer)` is equal to `0`


Scenario: [iOS] Verify step: 'When I select $direction value with `$offset` offset in picker wheel located `$locator`'
Meta:
    @targetPlatform ios
When I tap on element located `accessibilityId(menuToggler)`
When I tap on element located `xpath(//XCUIElementTypeButton[@name="Date Picker"])`
When I change context to element located `accessibilityId(dateTimePicker)`
When I select next value with `0.1` offset in picker wheel located `xpath(//XCUIElementTypePickerWheel)->filter.index(1)`
When I select previous value with `0.1` offset in picker wheel located `xpath(//XCUIElementTypePickerWheel)->filter.index(2)`
When I select next value with `0.1` offset in picker wheel located `xpath(//XCUIElementTypePickerWheel)->filter.index(3)`
When I reset context
Then number of elements found by `accessibilityId(dateInput)->filter.textPart(1/10/2012)` is equal to `1`


Scenario: [Android] Verify steps: 'When I switch to native context', 'When I switch to web view with name that $comparisonRule `$value`'
Meta:
    @targetPlatform android
When I tap on element located `accessibilityId(menuToggler)`
When I tap on element located `xpath(//android.widget.TextView[@text='Web View'])`
When I wait until element located `xpath(//android.webkit.WebView[@focusable='true'])` appears
When I switch to web view with name that contains `vividustestapp`
Then number of elements found by `xpath(//*[@id='welcome-message'])` is equal to `1`
When I switch to native context
Then number of elements found by `xpath(//*[@id='welcome-message'])` is equal to `0`


Scenario: Verify step: 'When I swipe $direction to element located `$locator` with duration $swipeDuration'
When I tap on element located `accessibilityId(menuToggler)`
When I tap on element located `xpath(<carouselViewXpath>)`
Then number of elements found by `accessibilityId(<firstItemAccessibilityId>)` is = `1`
When I swipe LEFT to element located `accessibilityId(<secondItemAccessibilityId>)` with duration PT1S
Then number of elements found by `accessibilityId(<firstItemAccessibilityId>)` is = `0`
Then number of elements found by `accessibilityId(<secondItemAccessibilityId>)` is = `1`
When I swipe RIGHT to element located `accessibilityId(<firstItemAccessibilityId>)` with duration PT1S
Then number of elements found by `accessibilityId(<firstItemAccessibilityId>)` is = `1`
Then number of elements found by `accessibilityId(<secondItemAccessibilityId>)` is = `0`
When I change context to element located `xpath(<swipeableAreaXpath>)`
When I swipe LEFT to element located `accessibilityId(<secondItemAccessibilityId>)` with duration PT1S
Then number of elements found by `accessibilityId(<firstItemAccessibilityId>)` is = `0`
Then number of elements found by `accessibilityId(<secondItemAccessibilityId>)` is = `1`
When I swipe RIGHT to element located `accessibilityId(<firstItemAccessibilityId>)` with duration PT1S
Then number of elements found by `accessibilityId(<firstItemAccessibilityId>)` is = `1`
Then number of elements found by `accessibilityId(<secondItemAccessibilityId>)` is = `0`
When I reset context


Scenario: Verify step: 'When I execute javascript `$script` with arguments:$args' on iOS
Meta:
    @targetPlatform ios
When I execute javascript `mobile: swipe` with arguments:
|value                 |type  |
|{"direction" : "left"}|object|
Then number of elements found by `accessibilityId(<firstItemAccessibilityId>)` is = `0`
Then number of elements found by `accessibilityId(<secondItemAccessibilityId>)` is = `1`
When I execute javascript `mobile: swipe` with arguments:
|value                  |type  |
|{"direction" : "right"}|object|
Then number of elements found by `accessibilityId(<firstItemAccessibilityId>)` is = `1`
Then number of elements found by `accessibilityId(<secondItemAccessibilityId>)` is = `0`


Scenario: Verify step: 'When I execute javascript `$script` with arguments:$args' on Android
Meta:
    @targetPlatform android
When I change context to element located `xpath(//android.view.ViewGroup[./android.widget.TextView[@content-desc="<firstItemAccessibilityId>"]])`
Given I initialize scenario variable `x` with value `${context-x-coordinate}`
Given I initialize scenario variable `y` with value `${context-y-coordinate}`
Given I initialize scenario variable `width` with value `${context-width}`
Given I initialize scenario variable `height` with value `#{eval(${context-height} / 3 )}`
When I reset context
When I execute javascript `mobile: swipeGesture` with arguments:
|value                                                                                                                  |type  |
|{"left": ${x}, "top": ${y}, "width": ${width}, "height": ${height}, "direction": "left", "percent": 1.0, "speed" : 300}|object|
Then number of elements found by `accessibilityId(<firstItemAccessibilityId>)` is = `0`
Then number of elements found by `accessibilityId(<secondItemAccessibilityId>)` is = `1`
When I execute javascript `mobile: swipeGesture` with arguments:
|value                                                                                                                    |type  |
|{"left": ${x}, "top": ${y}, "width": ${width}, "height": ${height}, "direction": "right", "percent":  1.0, "speed" : 300}|object|
Then number of elements found by `accessibilityId(<firstItemAccessibilityId>)` is = `1`
Then number of elements found by `accessibilityId(<secondItemAccessibilityId>)` is = `0`


Scenario: Verify steps: "When I scan barcode from screen and save result to $scopes variable `$variableName`"
Meta:
    @requirementId 2112
When I tap on element located `accessibilityId(menuToggler)`
When I tap on element located `xpath(<menuQrCodeXpath>)`
When I wait until element located `xpath(<scrollableMenuXpath>)` disappears
When I scan barcode from screen and save result to scenario variable `qrCodeLink`
Then `${qrCodeLink}` is = `https://github.com/vividus-framework/vividus`

Scenario: Verify steps: "When I scan barcode from context and save result to $scopes variable `$variableName`"
Meta:
    @requirementId 2687
When I change context to element located `xpath(<qrCodeContainerXpath>)`
When I scan barcode from context and save result to scenario variable `qrCodeLink`
Then `${qrCodeLink}` is = `https://github.com/vividus-framework/vividus`
When I reset context

Scenario: Go to slider screen
When I tap on element located `accessibilityId(menuToggler)`
When I swipe UP to element located `xpath(<menuSliderXpath>)` with duration PT1S
When I tap on element located `xpath(<menuSliderXpath>)`
When I wait until element located `accessibilityId(zeroToHundredSlider)` appears


Scenario: Verify steps: "When I set value of Android slider located `$locator` to `$number`"
Meta:
    @targetPlatform android
When I set value of Android slider located `accessibilityId(<slider>)` to `<targetValue>`
When I save `text` attribute value of element located `accessibilityId(<slider>Position)` to scenario variable `sliderState`
Then `${sliderState}` is equal to `<actualValue>`
Examples:
|slider                    |targetValue|actualValue|
|zeroToHundredSlider       |77.0       |77.0       |
|zeroToHundredSlider       |13.0       |13.0       |
|negativeFiftyToFiftySlider|25.0       |-25.0      |
|negativeFiftyToFiftySlider|70.0       |20.0       |
|eighteenToSixtyFiveSlider |47.0       |65.0       |
|eighteenToSixtyFiveSlider |20.0       |38.0       |
|eighteenToSixtyFiveSlider |2.0        |20.0       |


Scenario: Verify steps: "When I set value of iOS slider located `$locator` to `$number`"
Meta:
    @targetPlatform ios
When I set value of iOS slider located `accessibilityId(<slider>)` to `<targetValue>` percents
When I save `value` attribute value of element located `accessibilityId(<slider>Position)` to scenario variable `sliderState`
Then `${sliderState}` is greater than or equal to `<leftLimitValue>`
Then `${sliderState}` is less than or equal to `<rightLimitValue>`
Examples:
|slider                    |targetValue|leftLimitValue|rightLimitValue|
|zeroToHundredSlider       |77         |74            |80             |
|zeroToHundredSlider       |13         |10            |16             |
|negativeFiftyToFiftySlider|25         |-28           |-22            |
|negativeFiftyToFiftySlider|70         |17            |23             |
|eighteenToSixtyFiveSlider |12         |20            |26             |
|eighteenToSixtyFiveSlider |80         |52            |58             |


Scenario: Verify step: 'When I long press $key key'
Meta:
    @targetPlatform android
When I wait until element located `accessibilityId(menuToggler)` appears
When I long press HOME key
When I wait until element located `accessibilityId(menuToggler)` disappears
When I activate application with bundle identifier `${main-app}`
When I wait until element located `accessibilityId(menuToggler)` appears


Scenario: Verify step: 'When I long press $key key'
Meta:
    @targetPlatform ios
    @requirementId 2087
When I wait until element located `accessibilityId(menuToggler)` appears
When I long press home key
When I wait until element located `accessibilityId(menuToggler)` disappears
When I activate application with bundle identifier `${main-app}`
When I wait until element located `accessibilityId(menuToggler)` appears

Scenario: Verify step: 'When I change device screen orientation to $orientation'
When I save `${size-attribute}` attribute value of element located `accessibilityId(menuToggler)` to scenario variable `portraitSize`
When I change device screen orientation to LANDSCAPE
When I save `${size-attribute}` attribute value of element located `accessibilityId(menuToggler)` to scenario variable `landscapeSize`
Then `${portraitSize}` is not equal to `${landscapeSize}`

Scenario: Verify step: 'When I close mobile application'
When I close mobile application
