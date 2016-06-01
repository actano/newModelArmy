"use strict"

now = require 'performance-now'
deepFreeze = require 'deep-freeze'
cloneDeep = require 'lodash/cloneDeep'
update = require 'react-addons-update'

Immutable = (PRODUCTION_MODE = false) ->
    service = {}

    service.toImmutable = (obj) ->
        if PRODUCTION_MODE
            return obj

        return deepFreeze obj

    service.toJS = (obj) ->

    service.setIn = (obj, path, value) ->
        return _setIn obj, path.reverse(), value

    _setIn = (obj, path, value) ->
        if path.length == 1
            return _setValueAndClone obj, path.pop(), value

        first = path.pop()
        return _setValueAndClone obj, first, _setIn(obj[first], path, value)


    _setValueAndClone = (obj, property, value) ->
        res = Object.assign {}, obj
        res[property] = value
        return _freeze res

    _freeze = (obj) ->
        if PRODUCTION_MODE
            return obj

        return Object.freeze obj

    service.filter = (array, filterFunction) ->
        return _freeze array.filter filterFunction

    service.map = (array, mapFunction) ->
        return @toImmutable array.map mapFunction


    return service

module.exports = Immutable
    
        
    
    
