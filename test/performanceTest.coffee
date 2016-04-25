{expect} = require 'chai'
memo = require 'memo-is'
times = require 'lodash/times'

seamless = require 'seamless-immutable'
seamlessProduction = require 'seamless-immutable/seamless-immutable.production.min'
immutable = require 'immutable'

minMaxCalculator = require '../min-max'
createTree = require '../node-factory'
records = require '../records'

describe 'min max algorithm performance', ->
    numberOfRuns = 10
    numberOfChildren = memo().is -> null
    maxDepth = memo().is -> null
    infoSize = memo().is -> null

    conversionFunction = memo().is -> null
    calculationFunction = memo().is -> null

    store = null

    describe 'measure performance', ->
        beforeEach 'createData', ->
            store = createTree numberOfChildren(), maxDepth(), infoSize()

        describe 'with 1 child, depth 1000', ->
            console.log '-----'
            numberOfChildren.is -> 1
            maxDepth.is -> 1000

            describe 'and additional data with strings of size 1', ->
                infoSize.is -> 1

                describe 'for plain mutable JS', ->
                    conversionFunction.is -> identity

                    describe 'without cloning', ->
                        calculationFunction.is -> minMaxCalculator.calculateMinMaxMutable

                        it 'should work', ->

                            runPerformanceTest()

                    describe 'with cloning', ->
                        calculationFunction.is -> minMaxCalculator.calculateMinMaxWithCloning

                        it 'should work', ->
                            runPerformanceTest()

                describe 'for seamless immutable', ->
                    calculationFunction.is -> minMaxCalculator.calculateMinMaxSeamless

                    describe 'production mode', ->
                        conversionFunction.is -> seamlessProduction

                        it 'should work', ->
                            runPerformanceTest()

                    describe 'development mode', ->
                        conversionFunction.is -> seamless

                        it 'should work', ->
                            runPerformanceTest()

                describe 'for immutableJS records', ->
                    conversionFunction.is -> records.createStore
                    calculationFunction.is -> minMaxCalculator.calculateMinMaxImmutable

                    it 'should work', ->
                        runPerformanceTest()


        describe 'with 1000 children, depth 1', ->
            console.log '-----'
            numberOfChildren.is -> 1000
            maxDepth.is -> 1

            describe 'and additional data with strings of size 1', ->
                infoSize.is -> 1

                describe 'for plain mutable JS', ->
                    conversionFunction.is -> identity

                    describe 'without cloning', ->
                        calculationFunction.is -> minMaxCalculator.calculateMinMaxMutable

                        it 'should work', ->
                            runPerformanceTest()

                    describe 'with cloning', ->
                        calculationFunction.is -> minMaxCalculator.calculateMinMaxWithCloning

                        it 'should work', ->
                            runPerformanceTest()

                describe 'for seamless immutable', ->
                    calculationFunction.is -> minMaxCalculator.calculateMinMaxSeamless

                    describe 'production mode', ->
                        conversionFunction.is -> seamlessProduction

                        it 'should work', ->
                            runPerformanceTest()

                    describe 'development mode', ->
                        conversionFunction.is -> seamless

                        it 'should work', ->
                            runPerformanceTest()

                describe 'for immutableJS records', ->
                    conversionFunction.is -> records.createStore
                    calculationFunction.is -> minMaxCalculator.calculateMinMaxImmutable

                    it 'should work', ->
                        runPerformanceTest()

        describe 'with 2 children, depth 10', ->
            console.log '-----'
            numberOfChildren.is -> 2
            maxDepth.is -> 10

            describe 'and additional data with strings of size 1', ->
                infoSize.is -> 1

                describe 'for plain mutable JS', ->
                    conversionFunction.is -> identity

                    describe 'without cloning', ->
                        calculationFunction.is -> minMaxCalculator.calculateMinMaxMutable

                        it 'should work', ->
                            runPerformanceTest()

                    describe 'with cloning', ->
                        calculationFunction.is -> minMaxCalculator.calculateMinMaxWithCloning

                        it 'should work', ->
                            runPerformanceTest()

                describe 'for seamless immutable', ->
                    calculationFunction.is -> minMaxCalculator.calculateMinMaxSeamless

                    describe 'production mode', ->
                        conversionFunction.is -> seamlessProduction

                        it 'should work', ->
                            runPerformanceTest()

                    describe 'development mode', ->
                        conversionFunction.is -> seamless

                        it 'should work', ->
                            runPerformanceTest()

                describe 'for immutableJS records', ->
                    conversionFunction.is -> records.createStore
                    calculationFunction.is -> minMaxCalculator.calculateMinMaxImmutable

                    it 'should work', ->
                        runPerformanceTest()

    identity = (prop) -> prop

    verifyResult = (store, nodeId) ->
        node = store.nodes[nodeId]
        # hack for immutableJS
        unless node?
            node = store.nodes.get nodeId

        endDate = node.dates.startDate + node.dates.duration

        expect(node.dates.startDate).to.equal -maxDepth()
        expect(endDate).to.equal maxDepth() + numberOfChildren() - 1

    runPerformanceTest = ->
        res = []
        times numberOfRuns, ->
            start = Date.now()
            rootId = store.rootId
            myStore = conversionFunction() store
            myStore = calculationFunction() myStore, rootId
            res.push (Date.now() - start)
            verifyResult myStore, rootId

        res = res.toString().replace /,/g, '    '
        console.log '\nResult', res

