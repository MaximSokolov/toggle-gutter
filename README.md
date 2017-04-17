# Toggle Gutter

[![Build Status](https://travis-ci.org/MaximSokolov/toggle-gutter.svg?branch=master)](https://travis-ci.org/MaximSokolov/toggle-gutter)

Quickly toggle visability of Atom's gutters

![toggle-gutter](https://cloud.githubusercontent.com/assets/2943616/25087971/83531bc2-237b-11e7-8b7c-19b3784c0b5d.gif)

## Installation

Install directly using the command line:

```
apm install toggle-gutter
```

Or go to __Settings__ > __Install__ > __Packages__ and search for `toggle-gutter`

## Commands

#### Toggle Gutter: Gutter

Toggles visability of container with all gutters

```cson
'atom-workspace':
  'ctrl-g ctrl-g': 'toggle-gutter:gutter'
```

#### Toggle Gutter: Line numbers

Toggles visability of `line-number` gutter

```cson
'atom-workspace':
  'ctrl-l ctrl-l': 'toggle-gutter:line-numbers'
```

#### Toggle Gutter: {Guter name}

Toggles visability of gutter with the given name. Gutter must be specified in the `gutters` list.

```cson
'atom-workspace':
  'ctrl-i': 'toggle-gutter:linter-ui-default'
```


### Contribution

Please report issues/bugs, feature requests, and suggestions for improvements to the [issue tracker](https://github.com/MaximSokolov/toggle-gutter/issues)

### License

This software is distributed under [MIT license](./LICENSE.md)
