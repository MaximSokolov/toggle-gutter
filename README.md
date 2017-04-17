# Toggle Gutter

[![Build Status](https://travis-ci.org/MaximSokolov/toggle-gutter.svg?branch=master)](https://travis-ci.org/MaximSokolov/toggle-gutter)

Quickly toggle visability of Atom's gutters

![toggle-gutter](https://github.com/MaximSokolov/toggle-gutter/blob/master/img/toggle-gutter.gif?raw=true)

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
