function Controller() {
    installer.autoRejectMessageBoxes();
    installer.installationFinished.connect(function() {
        gui.clickButton(buttons.NextButton, 3000);
    })
    installer.setMessageBoxAutomaticAnswer("cancelInstallation", QMessageBox.Yes);
}

Controller.prototype.WelcomePageCallback = function() {
    gui.clickButton(buttons.NextButton, 3000);
}

Controller.prototype.CredentialsPageCallback = function() {
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.IntroductionPageCallback = function() {
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.TargetDirectoryPageCallback = function()
{
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.ComponentSelectionPageCallback = function() {
    var widget = gui.currentPageWidget();
    widget.deselectAll();
    widget.selectComponent("qt.qt5.5123.qtcharts")
    widget.selectComponent("qt.qt5.5123.qtwebengine")
    widget.selectComponent("qt.qt5.5123.win32_msvc2017")
    widget.selectComponent("qt.qt5.5123.qtcharts.win32_msvc2017")
    widget.selectComponent("qt.qt5.5123.qtwebengine.win32_msvc2017")
    widget.selectComponent("qt.qt5.5123.win64_msvc2017_64")
    widget.selectComponent("qt.qt5.5123.qtcharts.win64_msvc2017_64")
    widget.selectComponent("qt.qt5.5123.qtwebengine.win64_msvc2017_64")
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.LicenseAgreementPageCallback = function() {
    gui.currentPageWidget().AcceptLicenseRadioButton.setChecked(true);
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.StartMenuDirectoryPageCallback = function() {
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.ReadyForInstallationPageCallback = function()
{
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.FinishedPageCallback = function() {
var checkBoxForm = gui.currentPageWidget().LaunchQtCreatorCheckBoxForm
if (checkBoxForm && checkBoxForm.launchQtCreatorCheckBox) {
    checkBoxForm.launchQtCreatorCheckBox.checked = false;
}
    gui.clickButton(buttons.FinishButton, 5000);
}