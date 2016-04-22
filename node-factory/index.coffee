uuid = require 'node-uuid'
times = require 'lodash/times'

createTree = (numberOfChildren, maxDepth, infoSize) ->
    nodes = {}
    relations = []

    createSubtree = (parent, currentDepth) ->
        return if currentDepth > maxDepth

        times numberOfChildren, (childNumber) ->
            node = createNode infoSize, currentDepth, childNumber
            createRelation(parent.id, node.id)
            createSubtree(node, currentDepth + 1)

        {
            rootId: parent.id
            nodes
            relations
        }

    createNode = (infoSize, depth, childNumber) ->
        node = {
            id: createId()
            dates:
                startDate: childNumber - depth
                duration: 2 * depth
            info: [
                note: createString infoSize
                additionalNote: createString infoSize
            ]
        }

        nodes[node.id] = node
        return node

    createRelation = (sourceId, targetId) ->
        relation = {
            id: createId()
            sourceId: sourceId
            targetId: targetId
        }
        relations.push relation
        return relation

    createString = (size) -> createId().repeat size
    createId = uuid.v4

    root = createNode infoSize, 0, 0
    createSubtree(root, 1)

module.exports = createTree
