# Flutter Project Setup

- **Initial checklist for project setup follow** [Project setup document](project_setup_doc.md)

- Project has been setup with the GetX plugin and we removed BlocProvider.\
  GetX : https://pub.dev/packages/get

- Removed config.json for svg and added plugin for SVG support.\
  SVG Plugin : https://pub.dev/packages/flutter_svg

- No need to use build runner to generate json serializable.\
  We will directly put model class from : https://app.quicktype.io/ \
  Note: You can use other if you are comfortable with it.

Here we have created some structure to use GetX. Every page will have 4 packages named as
1) bindings
2) data
3) domain
4) presentation

- Bindings have initialisation of Provider, Repository and Controllers using `Get.lazyPut`
- Data have the calls for API. It will contains API Provider and Repository.
- Domain will contain adapter for api call.
- Presentation will have 2 packages like 1) controllers 2) views.
  Controller contains actual state of the pages.
  View contains the UI of our page.


## GetX

- GetX has it's own View which will manage States like onEmpty, onLoading and onError. So we can directly put our logic according.
- GetX provides many features which we can check in the plugin detail.
- Responsive width, height and font 1) height : `100.h`     2) width : `100.w`    3) font : `10.sp`
- For Snackbars/Dialogs/Bottomsheet
```
  Get.snackbar('title', 'message');
  Get.defaultDialog();
  Get.bottomSheet(Container());
```


#### GetUtils
<details>
<summary>Predefined Validation methods</summary>

 ```
 GetUtils.isEmail("email@s");
 isURL("");
 isUsername("")
 isPhoneNumber("")
 isMD5("")
 isNullOrBlank()
 isBlank()
 isNumericOnly()
 isAlphabetOnly()
 hasCapitalletter()
 isVideo()/isImage()/isAudio()/isPPT()/isWord()/isExcel()/isAPK()/isPDF() ..etc
 isLengthGreaterOrEqual()/isLengthLowerOrEqual ..etc
 removeAllWhitespace(),capitalizeFirst(),capitalize()..etc
  ...etc
 ```

- Screen width and height -> Equivalent to :  MediaQuery.of(context).size.height
  ```
  Get.height
  Get.width
  ```

-  Gives the current context of the Navigator.
   ```
   Get.context
   ```

- Gives the context of the snackbar/dialog/bottomsheet in the foreground, anywhere in your code.
  ```
  Get.contextOverlay
  ```

  > **Note**: the following methods are extensions on context. Since you  have access to context in any place of your UI, you can use it anywhere in the UI code


- If you need a changeable height/width (like Desktop or browser windows that can be scaled) you will need to use context
  ```
  context.width
  context.height
  ```

</details>

#### Auto Generate Page with Routes

<details>
<summary> Steps</summary>


- To Generate Automatically Page with Routes follow the below steps: 
- Please check if ```get-cli``` is installed or not : [get_cli plugin](https://pub.dev/packages/get_cli)
    - if installed then run the following command
        ```
         get create page:<Page_Name> on <Directory_Path>
    - for ex:
        ```    
         get create page:products on ui/shop
        ```    
    - if not installed then run the following command in your IDE terminal and follow above steps
        ```
         flutter pub global activate get_cli
        ```

- It will generate Page_Folder with Bindings,Controller,View and also generate route in app_routes.dart and app_pages.dart file.

 </details>

#### Light Dark Theme Support
<details>
<summary>Documentation</summary>
  
- To Give Light Dark Theme Support to your App follow the below steps:
1. Define all your app ```colors``` in ```lightTheme``` and ```darkTheme``` which are located ```ThemeResource.dart``` file

2. Accessing `theme` by the using `context` keyword.

    ```
    // access background color
    context.theme.colorScheme.background; 
         
    // access large Text Style
    context.textTheme.labelLarge;
         
    // If you want to give custom size
    context.textTheme.labelLarge?.
    copyWith(fontSize: 50.sp);
    ```
3. To Change Theme Mode Use Below Method
    ```
        // For Dark Theme Mode
        ThemeResource().changeThemeMode(ThemeMode.dark);
        // For Light Theme Mode
        ThemeResource().changeThemeMode(ThemeMode.light);
        // For System Based
        ThemeResource().changeThemeMode(ThemeMode.system);
    ```
- To get current selected theme call below method
    ```
    ThemeResource().getSelectedThemeMode();
    ```
> Note : When ever we required to use ```color``` or ```text style``` property of the any widget we must have to use ```Theme.of(context)``` keyword.


</details>


## Git Hook
<details>
    <summary>Setup Git Pre Commit Hook </summary>

####  🚀 Flutter Pre-commit

The configuration of our pre-commit will run 3 commands for our flutter project:
- ```flutter format .``` to assure the style of the code.
- ```flutter analyze``` to analyze our dart code.
- ```flutter test``` to run our unit tests.


####  🏋️‍♂️ Setting the pre-commit to run

1. Create ```script``` folder at root level of the project.
2. Create ```install-hooks.bash```  and ```pre-commit.bash``` files into ```script``` folder.
3. Into ```install-hooks.bash``` file add below code

```
    #!/usr/bin/env bash

    GIT_DIR=$(git rev-parse --git-dir)

    echo "Installing hooks..."
    ln -s ../../scripts/pre-commit.bash $GIT_DIR/hooks/pre-commit
    echo "Done!"
```


4. Into ```pre-commit.bash``` file

```
       #!/usr/bin/env bash

       export PATH="$PATH:/home/concettolabs/Android/FlutterSDK/flutter/bin"
       printf "#================================================================\n"
       printf "\t\t%s\n" '--- Pre-Commit hook ---'
       printf "#================================================================\n\n"
       # Flutter formatter
       printf "+---+-----------------------------------------------------------+\n"
       printf "%s\t\t\t\t|" '| X |  Running Flutter Formatter'
       printf "\n+---+-----------------------------------------------------------+\n"
       flutter format .

       hasNewFilesFormatted=$(git diff)
       if [ -n "$hasNewFilesFormatted" ]; then
           git add .
           printf "%s\t\t\t\t|\n" '| Formatted files added to git stage'
       fi
       printf "%s\t\t\t\t|\n" '| Finished running Flutter Formatter'
       printf "+---------------------------------------------------------------+\n"
       # Flutter Analyzer

       printf "\n\n+---+-----------------------------------------------------------+\n"
       printf "%s\t\t\t\t\t|" '| X |  Running Flutter analyzer'
       printf "\n+---+-----------------------------------------------------------+\n"

       if ! flutter analyze; then
         printf "%s\t\t\t\t\t|" '| X |  Flutter analyzer error'
         printf "\n+---+-----------------------------------------------------------+\n"
         exit 1
       fi
       printf "\n\n+---+-----------------------------------------------------------+\n"
       printf "%s\t\t\t|" '| X |  Finished running Flutter analyzer'
       printf "\n+---+-----------------------------------------------------------+\n"
       # Unit tests add test in widget_test.dart for test
       printf "\n\n+---+-----------------------------------------------------------+\n"
       printf "%s\t\t\t\t\t|" '| X |  Running Unit Tests'
       printf "\n+---+-----------------------------------------------------------+\n"
       if ! flutter test; then
         printf "\n\n+---+-----------------------------------------------------------+\n"
         printf "%s\t\t\t\t\t\t|" '| X |  Unit tests error'
         printf "\n+---+-----------------------------------------------------------+\n"
         exit 1
       fi
       printf "%s\n" 'Finished running Unit Tests'
       printf "\n+---+-----------------------------------------------------------+\n"

```

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4.1 Update flutter sdk path in ```pre-commit.bash``` file
```export PATH="$PATH:$HOME/snap/flutter/bin"```


5 . Export path of flutter in ```pre-commit.bash``` file for ```flutter formatter```, ```flutter analyzer``` and ```flutter test```.

6 . Now run ```install-hooks.bash``` file

>**Note** : If you faced error  **OR**
git-hook not working proper **OR**
```The 'pre-commit' hook was ignored because it's not set as executable``` types hint comes  than execute command ```chmod +x .git/hooks/pre-commit``` in terminal.
  
</details>
  
  
## Code Review 
  - Docuement : https://docs.google.com/document/d/1qsYv9iil5kn83x1EDcNVGfxdS4loE2gwmkA9PMHtLIc/edit?usp=sharing

