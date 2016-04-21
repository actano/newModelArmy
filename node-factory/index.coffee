uuid = require 'node-uuid'

module.exports = ->
    service = {}

    service.createTree = (numberOfChildren, depth, infoSize) ->
        nodes = {}
        relations = []

        createSubtree = (numberOfChildren, maxDepth, infoSizeInChars, parent, currentDepth, currentChildNumber) ->
            if (currentDepth is maxDepth)
                return

            node = service.createNode infoSizeInChars, currentDepth, currentChildNumber
            nodes[node.id] = node

            relation = service.createRelation parent.id, node.id
            relations.push relation

            for currentChildNumber in [1..numberOfChildren]
                createSubtree(numberOfChildren, maxDepth, infoSizeInChars, node, currentDepth + 1, currentChildNumber)

            return {rootId: node.id, nodes, relations}

        createSubtree numberOfChildren, depth, infoSize, {id: null}, 0, 0

     service.createNode = (infoSizeInChars, depth, childNumber) ->
        return {
            id: @createId()
            data:
                startDate: childNumber - depth
                duration: 2 * depth
            info: [
                note: @createString infoSizeInChars
                additionalNote: @createString infoSizeInChars
            ]
        }

    service.createRelation = (sourceId, targetId) ->
        return {
            id: @createId()
            sourceId: sourceId
            targetId: targetId
        }

    service.createId = -> uuid.v4()

    service.createString = (size) ->
        return uuid.v4() * size

    return service
