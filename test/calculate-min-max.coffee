{expect} = require 'chai'
memo = require 'memo-is'

# _ = require 'lodash'
seamless = require 'seamless-immutable'
immutable = require 'immutable'

minMaxCalculator = require '../min-max'
createTree = require '../node-factory'
records = require '../records'

describe.only 'min max algorithm', ->
    numberOfChildren = memo().is -> null
    maxDepth = memo().is -> null
    infoSize = memo().is -> null

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
        numberOfChildren.is -> 1
        maxDepth.is -> 1
        infoSize.is -> 1

        beforeEach 'createData', ->
            store = createTree numberOfChildren(), maxDepth(), infoSize()
            console.log 'relations length', store.relations.length

        it 'should return correct min max values', ->
            rootId = store.rootId
            store = minMaxCalculator.calculateMinMaxMutable store, rootId
            verifyResult store, rootId

    describe 'seamless immutable', ->
        numberOfChildren.is -> 2
        maxDepth.is -> 2
        infoSize.is -> 2

        beforeEach 'createData', ->
            store = seamless createTree numberOfChildren(), maxDepth(), infoSize()
            console.log 'relations length', store.relations.length

        it 'should return correct min max values', ->
            rootId = store.rootId
            store = minMaxCalculator.calculateMinMaxSeamless store, rootId
            verifyResult store, rootId

    describe 'immutable JS', ->
        numberOfChildren.is -> 3
        maxDepth.is -> 3
        infoSize.is -> 3

        beforeEach 'createData', ->
            store = records.createStore createTree numberOfChildren(), maxDepth(), infoSize()
            console.log 'relations length', store.relations.size

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



