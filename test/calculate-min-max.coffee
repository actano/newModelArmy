{expect} = require 'chai'
memo = require 'memo-is'

# _ = require 'lodash'
seamless = require 'seamless-immutable'
seamlessProduction = require 'seamless-immutable/seamless-immutable.production.min'
immutable = require 'immutable'

minMaxCalculator = require '../min-max'
createTree = require '../node-factory'
records = require '../records'

describe.skip 'min max algorithm', ->
    numberOfChildren = memo().is -> null
    maxDepth = memo().is -> null
    infoSize = memo().is -> null

    conversionFunction = memo().is -> null
    calculationFunction = memo().is -> null

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
    # 2 - 1
    # 1000 - 1
    # More realistic: 4 - 1

    describe 'check production mode for seamless', ->
        it 'should write mutable property \'mutable\'', ->
            seamlessObject = seamless {x: 'immutable'}
            seamlessObject.x = 'mutable'
            expect(seamlessObject.x).to.equal 'immutable'

        it 'should write mutable property \'mutable\'', ->
            seamlessObject = seamlessProduction {x: 'immutable'}
            seamlessObject.x = 'mutable'
            expect(seamlessObject.x).to.equal 'mutable'


    describe 'measure performance', ->
        beforeEach 'createData', ->
            store = createTree numberOfChildren(), maxDepth(), infoSize()
            #console.log 'relations length', store.relations.length

        describe 'with 1 child, depth 1000', ->
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

                        it 'only converts to seamlesss immutable', ->
                            store = seamlessProduction store
                            expect(store.set).to.exist

                        describe 'with conversion to immutable structure', ->
                            it 'should work', ->
                                runPerformanceTest()

                    describe 'development mode', ->
                        conversionFunction.is -> seamless

                        it 'only converts to seamlesss immutable', ->
                            store = seamless store
                            expect(store.set).to.exist

                        describe 'with conversion to immutable structure', ->
                            it 'should work', ->
                                runPerformanceTest()

                describe 'for immutableJS records', ->
                    conversionFunction.is -> records.createStore
                    calculationFunction.is -> minMaxCalculator.calculateMinMaxImmutable

                    it 'only converts to immutable record', ->
                        store = records.createStore store
                        expect(store.set).to.exist

                    describe 'with conversion to immutable structure', ->
                        it 'should work', ->
                            runPerformanceTest()


            describe 'and additional data with strings of size 1000 (it\'s about 72 kB per node)', ->
                infoSize.is -> 1000

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

                        it 'only converts to seamlesss immutable', ->
                            store = seamlessProduction store
                            expect(store.set).to.exist

                        describe 'with conversion to immutable structure', ->
                            it 'should work', ->
                                runPerformanceTest()

                    describe 'development mode', ->
                        conversionFunction.is -> seamless

                        it 'only converts to seamlesss immutable', ->
                            store = seamless store
                            expect(store.set).to.exist

                        describe 'with conversion to immutable structure', ->
                            it 'should work', ->
                                runPerformanceTest()

                describe 'for immutableJS records', ->
                    conversionFunction.is -> records.createStore
                    calculationFunction.is -> minMaxCalculator.calculateMinMaxImmutable

                    it 'only converts to immutable record', ->
                        store = records.createStore store
                        expect(store.set).to.exist

                    describe 'with conversion to immutable structure', ->
                        it 'should work', ->
                            runPerformanceTest()


            describe 'and additional data with strings of size 1000000 (it\'s about 72 MB per node)', ->
                infoSize.is -> 1000000

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

                        it 'only converts to seamlesss immutable', ->
                            store = seamlessProduction store
                            expect(store.set).to.exist

                        describe 'with conversion to immutable structure', ->
                            it 'should work', ->
                                runPerformanceTest()

                    describe 'development mode', ->
                        conversionFunction.is -> seamless

                        it 'only converts to seamlesss immutable', ->
                            store = seamless store
                            expect(store.set).to.exist

                        describe 'with conversion to immutable structure', ->
                            it 'should work', ->
                                runPerformanceTest()

                describe 'for immutableJS records', ->
                    conversionFunction.is -> records.createStore
                    calculationFunction.is -> minMaxCalculator.calculateMinMaxImmutable

                    it 'only converts to immutable record', ->
                        store = records.createStore store
                        expect(store.set).to.exist

                    describe 'with conversion to immutable structure', ->
                        it 'should work', ->
                            runPerformanceTest()

        describe 'with 1000 children, depth 1', ->
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

                        it 'only converts to seamlesss immutable', ->
                            store = seamlessProduction store
                            expect(store.set).to.exist

                        describe 'with conversion to immutable structure', ->
                            it 'should work', ->
                                runPerformanceTest()

                    describe 'development mode', ->
                        conversionFunction.is -> seamless

                        it 'only converts to seamlesss immutable', ->
                            store = seamless store
                            expect(store.set).to.exist

                        describe 'with conversion to immutable structure', ->
                            it 'should work', ->
                                runPerformanceTest()

                describe 'for immutableJS records', ->
                    conversionFunction.is -> records.createStore
                    calculationFunction.is -> minMaxCalculator.calculateMinMaxImmutable

                    it 'only converts to immutable record', ->
                        store = records.createStore store
                        expect(store.set).to.exist

                    describe 'with conversion to immutable structure', ->
                        it 'should work', ->
                            runPerformanceTest()


        describe 'with 2 children, depth 10', ->
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

                        it 'only converts to seamlesss immutable', ->
                            store = seamlessProduction store
                            expect(store.set).to.exist

                        describe 'with conversion to immutable structure', ->
                            it 'should work', ->
                                runPerformanceTest()

                    describe 'development mode', ->
                        conversionFunction.is -> seamless

                        it 'only converts to seamlesss immutable', ->
                            store = seamless store
                            expect(store.set).to.exist

                        describe 'with conversion to immutable structure', ->
                            it 'should work', ->
                                runPerformanceTest()

                describe 'for immutableJS records', ->
                    conversionFunction.is -> records.createStore
                    calculationFunction.is -> minMaxCalculator.calculateMinMaxImmutable

                    it 'only converts to immutable record', ->
                        store = records.createStore store
                        expect(store.set).to.exist

                    describe 'with conversion to immutable structure', ->
                        it 'should work', ->
                            runPerformanceTest()

    describe 'check basic functionality', ->
        describe 'plain mutable JS', ->
            numberOfChildren.is -> 1
            maxDepth.is -> 1
            infoSize.is -> 1

            beforeEach 'createData', ->
                store = createTree numberOfChildren(), maxDepth(), infoSize()
                #console.log 'relations length', store.relations.length

            it 'should return correct min max values', ->
                #console.log store
                rootId = store.rootId
                store = minMaxCalculator.calculateMinMaxMutable store, rootId
                verifyResult store, rootId

        describe 'seamless immutable', ->
            numberOfChildren.is -> 2
            maxDepth.is -> 2
            infoSize.is -> 2

            beforeEach 'createData', ->
                store = seamless createTree numberOfChildren(), maxDepth(), infoSize()
                #console.log 'relations length', store.relations.length

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
                #console.log 'relations length', store.relations.size

            it 'should return correct min max values', ->
                rootId = store.rootId
                store = minMaxCalculator.calculateMinMaxImmutable store, rootId
                verifyResult store, rootId


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
        rootId = store.rootId
        store = conversionFunction() store
        store = calculationFunction() store, rootId
        verifyResult store, rootId



