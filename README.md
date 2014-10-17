Build Incrementer is an extremely lightweight and simple Mac OS X command line tool that increments Xcode project build numbers.

##Building The Tool##
You can build `Build Incrementer` yourself by downloading the project and building it in Xcode. Alternatively, you can use the precompiled binary provided.

##Using Precompiled Binary##
Once you've built the project or you chose to use the precompiled binary, navigate to `/usr/local/bin` and copy the binary file here. You can technically place the binary anywhere you like but I recommend this location.

##Installation##
1. Navigate to `/usr/local/bin` 
2. Copy the binary file here. You can technically place the binary anywhere you like but I recommend this location.
3. Open an Xcode project for which you'd like to use the `Build Incrementer`
4. Open the Scheme Editor, located in the top left of the Xcode project window
![](https://raw.githubusercontent.com/dbart01/Build-Incrementer/master/Help%20-%20Scheme%20Editor.png)
5. In the Scheme Editor, navigate to `Pre-actions` and click ` + ` in the lower left of the pane to add a new script action.
6. Execute the script, passing in the path to the `Info.plist` file
![](https://raw.githubusercontent.com/dbart01/Build-Incrementer/master/Help%20-%20Pre-Action.png)
```
/usr/local/bin/BuildIncrementer "$SOURCE_ROOT/$INFOPLIST_FILE"
```
##IMPORTANT##

Pay close attention to where it says `Provide build settings from`. In my case, the application name is `DrawPoint`. You __MUST__ select your app name here, otherwise `Build Incrementer` will not be passed the correct parameters and therefore will not work.
