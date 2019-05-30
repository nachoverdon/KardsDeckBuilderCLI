# Kards Deck Builder CLI

With this tool, you can generate a URL to the [Kards Deck Builder](https://kardsdeck.opengamela.com) web with the data from the exported deck from [Kards](https://www.kards.com/).

# How to use
* Create a deck using the Kards built-in deck builder and export it to the clipboard. To do this, go to the Kards main menu > Cards > click on a deck > on the upper left corner press the 'Copy Deck' button.
* Execute KDB. It will automatically copy the URL to your clipboard.

# Launch options
If you want to automatically open the URL on your default browser, use the `-o` flag.
```
kdb -o
```
If you don't want to automatically copy the URL to your clipboard, use the `-n` flag.
```
kdb -n
```
If instead of using the data from the clipboard you want to use a file, you can use the `-f` flag.
```
kdb -f mydeck.txt
```

You can combine several flags
```
kdb -onf
```
or
```
kdb -o -n -f
```


# Build

You'll need [Haxe](http://haxe.org)
```
    haxelib install tink_cli
    haxelib install linc_clipboard
    haxelib install openfl
```

Then just do, depending on your OS.
```
haxe windows.hxml
haxe linux.hxml
haxe mac.hxml
```
