# Elgato Key Light Air Automation on Mac OS
Automate Elgato Key Light Air to switch on automatically when you join a Google Meet or Zoom call (or any app that in-fact uses a camera stream on a Mac OS) and switches it off when the stream ends.

I've found it a hassle to remember to switch my lights on and off as I join various video calls throughout the day.  This bash script (works for Mac OS Monterey 12.x) monitors the Mac OS stream log and runs a curl command to activate the lights.

###Monitoring camera stream on Mac OS 12.x (Monterey)###

`log stream --predicate 'subsystem == "com.apple.UVCExtension" and composedMessage contains "Post PowerLog"'`

essentially monitors the stream log on Mac OS and filters out any video capture on Mac OS 12.X (Monterey), for older versions of Mac OS, check out the good work at: https://gist.github.com/jptoto/3b2197dd652ef13bd7f3cab0f2152b19 for that.

###Turning the Engato Key Light Air On and Off###

`curl --location --request PUT 'http://<light IP address>:9123/elgato/lights' --header 'Content-Type: application/json' --data-raw '{"lights":[{"brightness":40,"temperature":162,"on":1}],"numberOfLights":1}'` 
  
credit: https://vninja.net/2020/12/04/automating-elgato-key-lights-from-touch-bar/

You need to change the local IP address of the lights based on your local setup in the script.  The rest of the key/value pairs to configure the light are self-expalantory.

_**Running the script and testing if everything works**_

You can run the script using Terminal, download the .sh file, edit it and run:

`sh autolights.sh`

and this will start to monitor your stream log.  Open any app that uses your web camera, maybe **Photo Booth** and see if your light(s) come on.  If they do not, check that you have entered the correct IP address for your light(s).  Easiest way to identify the IP address is to use the **Elgato Control Center** utility > **Key light settings** > and note the IP address for each light.

**_Executing the shell script automatically_**

If (like me) you prefer to run the bash script everytime you start-up up your Mac to avoid starting it manually, you can goto **Users and Groups** > **Login Items** tab > and plus in your bash script.  You can check the _Hide_ button won't show the terminal window.

May you see the light! 🔦 😆

Akbur Ghafoor

# Usage with launchd
Following [this StackOverflow answer](https://stackoverflow.com/questions/6442364/running-script-upon-login-in-mac-os-x/13372744#13372744)

- Update the `autolights.plist` file with the path to where you're copying the `autolights.sh` script.
- Use the provided `install.sh` script to "install" `autolights.sh` as a hidden file in your home folder.
- Log out, then in or run `launchctl start com.user.autolights` to activate
