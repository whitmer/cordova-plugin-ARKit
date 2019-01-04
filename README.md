# cordova-plugin-ARKit

## Supported Platforms

- iOS

## Installation

    cordova plugin add https://github.com/taqtile-us/cordova-plugin-ARKit

Add the following lines into your config.xml in the platform tag.
```xml
<platform name="ios">
  <preference name="UseSwiftLanguageVersion" value="4.2" />
</platform>
```

## Methods

- cordova.plugins.arkit.addARView
- cordova.plugins.arkit.removeARView
- cordova.plugins.arkit.setListenerForArChanges
- cordova.plugins.arkit.reloadSession

### addARView

Insert the camera view under the WebView

```js
cordova.plugins.arkit.addARView();
```

### removeARView

Remove the camera view

```js
cordova.plugins.arkit.removeARView();
```

### setListenerForArChanges

Set listener for event from ARKit

##### Parameters

| Parameter        | Type       | Description                                |
| ---------------- | ---------- | ------------------------------------------ |
| `arHandler`      | `Function` | Is called after initializing an AR session |

##### Callback parameters

`arHandler`

| Parameter  | Type      | Description                         |
| ---------- | --------- | ----------------------------------- |
|   `str`    | `String`  | Line with camera change information. <br> Format: `positionX, positionY, positionZ, quatirionX, quatirionY, quatirionZ, quatirionW` |


```js
cordova.plugins.arkit.setListenerForArChanges((str) => {});
```

### reloadSession

Reload AR session

```js
cordova.plugins.arkit.reloadSession();
```
