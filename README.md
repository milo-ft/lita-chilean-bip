# lita-chilean-bip

 [![Build Status](https://travis-ci.org/milo-ft/lita-chilean-bip.png)](https://travis-ci.org/milo-ft/lita-chilean-bip)
 [![Code Climate](https://codeclimate.com/github/milo-ft/lita-chilean-bip.png)](https://codeclimate.com/github/milo-ft/lita-chilean-bip)
 [![Coverage Status](https://coveralls.io/repos/milo-ft/lita-chilean-bip/badge.png)](https://coveralls.io/r/milo-ft/lita-chilean-bip)

**lita-chilean-bip** is a [Lita](https://github.com/jimmycuadra/lita) handler for checking the BIP card balance.

## Installation

Add **lita-chilean-bip** to your Lita instance's Gemfile:

``` ruby
gem "lita-chilean-bip"
```

## Usage

To check your balance:
```
@bot bip <number>
```

Also you can store your number for future requests:

```
@bot my bip is <number>
```
then...
```
@bot bip
```

Requests are case-insensitive

## License

[MIT](http://opensource.org/licenses/MIT)
