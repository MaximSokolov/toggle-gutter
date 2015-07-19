# [Toggle Gutter](https://atom.io/packages/toggle-gutter)

Easily hide Atom's line numbers

![toggle-gutter](https://raw.githubusercontent.com/MaximSokolov/toggle-gutter/master/img/toggle-gutter.gif)

## Installation

```
apm install toggle-gutter
```

## Commands

#### Toggle Gutter: Line numbers

Probably you want to disable __line number__ but keep __gutter__ because it shows much useful information like git diff, folding marks etc.

```cson
'atom-workspace':
  'ctrl-l ctrl-l': 'toggle-gutter:line-numbers'
```

#### Toggle Gutter: Gutter

Though you can disable gutter completely

```cson

'atom-workspace':
  'ctrl-g ctrl-g': 'toggle-gutter:gutter'
```
