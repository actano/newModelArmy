{expect} = require 'chai'
# _ = require 'lodash'
seamless = require 'seamless-immutable'
immutable = require 'immutable'

minMaxCalculator = require '../min-max'
createTree = require '../node-factory'
records = require '../records'

describe.only 'min max algorithm', ->
    numberOfChildren = null
    maxDepth = null
    infoSize = null

    store = null

    # with convertion - server like
    # without convertion - client like

    # plain, mutable JS
    # immutable JS - Records
    # seamless Immutable

    # big additional data
    # little additional data

    # Tree structure: Read to writes
    # 1 - 1000
    # 1 - 1
    # 1000 - 1
    # More realistic: 4 - 1


    describe 'plain mutable JS', ->
        # values are overwritten by last defined values! Change that
        numberOfChildren = 2
        maxDepth = 2
        infoSize = 2

        beforeEach 'createData', ->
            store = createTree numberOfChildren, maxDepth, infoSize

        it 'should return correct min max values', ->
            rootId = store.rootId
            store = minMaxCalculator.calculateMinMaxMutable store, rootId
            verifyResult store, rootId

    describe 'seamless immutable', ->
        numberOfChildren = 2
        maxDepth = 2
        infoSize = 2

        beforeEach 'createData', ->
            store = seamless createTree numberOfChildren, maxDepth, infoSize

        it 'should return correct min max values', ->
            rootId = store.rootId
            store = minMaxCalculator.calculateMinMaxSeamless store, rootId
            verifyResult store, rootId

    describe 'immutable JS', ->
        numberOfChildren = 2
        maxDepth = 2
        infoSize = 2

        beforeEach 'createData', ->
            store = records.createStore createTree numberOfChildren, maxDepth, infoSize

        it 'should return correct min max values', ->
            rootId = store.rootId
            store = minMaxCalculator.calculateMinMaxImmutable store, rootId
            verifyResult store, rootId

    verifyResult = (store, nodeId) ->
        node = store.nodes[nodeId]
        # hack for immutableJS
        unless node?
            node = store.nodes.get nodeId

        endDate = node.dates.startDate + node.dates.duration

        expect(node.dates.startDate).to.equal -maxDepth
        expect(endDate).to.equal maxDepth + numberOfChildren - 1



