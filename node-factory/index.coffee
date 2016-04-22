uuid = require 'node-uuid'
times = require 'lodash/times'

module.exports = ->
    service = {}

    service.createTree = (numberOfChildren, depth, infoSize) ->
        nodes = {}
        relations = []

        createSubtree = (numberOfChildren, maxDepth, infoSizeInChars, parent, currentDepth, currentChildNumber) ->
            return if currentDepth is maxDepth

            node = service.createNode infoSizeInChars, currentDepth, currentChildNumber
            nodes[node.id] = node

            relation = service.createRelation(parent.id, node.id)
            relations.push relation

            times numberOfChildren, (n) ->
                createSubtree(numberOfChildren, maxDepth, infoSizeInChars, node, currentDepth + 1, n)

            {
                rootId: node.id
                nodes
                relations
            }

        createSubtree(numberOfChildren, depth, infoSize, {id: null}, 0, 0)

     service.createNode = (infoSizeInChars, depth, childNumber) ->
        id: @createId()
        data:
            startDate: childNumber - depth
            duration: 2 * depth
        info: [
            note: @createString infoSizeInChars
            additionalNote: @createString infoSizeInChars
        ]

    service.createRelation = (sourceId, targetId) ->
        id: @createId()
        sourceId: sourceId
        targetId: targetId

    service.createId = uuid.v4
    service.createString = (size) -> service.createId * size

    return service
