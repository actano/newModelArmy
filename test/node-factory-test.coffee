{expect} = require 'chai'
factory = require('../node-factory')()

describe.skip 'create Node', ->

    it 'creates a node with data, relations and info when createNode()', ->
        newNode = factory.createNode(36, 3, 2)
        expect(newNode.id).to.exist
        expect(newNode.data).to.exist
        expect(newNode.info).to.exist

    it 'creates a relation object with source and target when createRelation()', ->
        newRelation = factory.createRelation('parent', 'child')
        expect(newRelation.sourceId).to.equal('parent')
        expect(newRelation.targetId).to.equal('child')

    it 'creates a tree when createTree()', ->
        result = factory.createTree(1, 1, 1)
        expect(result.rootId).to.exist
        expect(Object.keys(result.nodes)).to.have.length 1
        expect(result.relations).to.have.length 1
