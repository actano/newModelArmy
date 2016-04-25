_ = require 'lodash'

calculateMinMaxMutable = (store, nodeId) ->
    calculateMinMax store, nodeId, updateMutable

calculateMinMaxSeamless = (store, nodeId) ->
    calculateMinMax store, nodeId, updateSeamless

calculateMinMaxWithCloning = (store, nodeId) ->
    node = loadClonedNode store, nodeId
    childrenIds = getChildrenIds store, node

    if childrenIds.length < 1
        return store

    for childId in childrenIds
        store = calculateMinMaxWithCloning store, childId

    children = loadClonedNodes store, childrenIds

    startDate = _.min children.map (node) -> node.dates.startDate
    endDate = _.max children.map (node) -> calculateEndDate node

    updateMutableForCloneAlgorithm(store, node, startDate, endDate)


calculateMinMaxImmutable = (store, nodeId) ->
    node = loadNodeIm store, nodeId
    childrenIds = getChildrenIds store, node

    if childrenIds.size < 1
        return store

    childrenIds.forEach (childId) ->
        store = calculateMinMaxImmutable store, childId

    children = loadNodesIm store, childrenIds

    startDate = children.map((node) -> node.dates.startDate).min()
    endDate = children.map((node) -> calculateEndDate node).max()

    updateSeamless(store, node, startDate, endDate)


calculateMinMax = (store, nodeId, updateFunction) ->
    node = loadNode store, nodeId
    childrenIds = getChildrenIds store, node

    if childrenIds.length < 1
        return store

    for childId in childrenIds
        store = calculateMinMax store, childId, updateFunction

    children = loadNodes store, childrenIds

    startDate = _.min children.map (node) -> node.dates.startDate
    endDate = _.max children.map (node) -> calculateEndDate node

    updateFunction(store, node, startDate, endDate)

updateMutable = (store, node, startDate, endDate) ->
    if node.dates.startDate > startDate
        node.dates.startDate = startDate

    if calculateEndDate(node) < endDate
        node.dates.duration = endDate - node.dates.startDate

    return store

updateMutableForCloneAlgorithm = (store, node, startDate, endDate) ->
    if node.dates.startDate > startDate
        node.dates.startDate = startDate

    if calculateEndDate(node) < endDate
        node.dates.duration = endDate - node.dates.startDate

    store.nodes[node.id] = node

    return store

updateSeamless = (store, node, startDate, endDate) ->
    if node.dates.startDate > startDate
        store = store.setIn ['nodes', node.id, 'dates', 'startDate'], startDate

    if calculateEndDate(node) < endDate
        store = store.setIn ['nodes', node.id, 'dates', 'duration'], endDate - startDate

    return store

calculateEndDate = (node) ->
    node.dates.startDate + node.dates.duration

loadClonedNode = (store, id) ->
#    node = Object.assign {}, store.nodes[id]
#
#    `
#    if (node == store.nodes[id]) {
#      throw new Error('node: no deep clone');
#    }
#
#    if (node.info == store.nodes[id].info) {
#        throw new Error('node.info: no deep clone');
#    }
#
#    if (node.info.note == store.nodes[id].info.note) {
#        throw new Error('node.info.note: no deep clone');
#    }
#    `

    node = _.cloneDeep store.nodes[id]

    return node

loadClonedNodes = (store, ids) ->
    ids.map (id) -> loadClonedNode store, id

loadNode = (store, id) ->
    store.nodes[id]

loadNodeIm = (store, id) ->
    store.nodes.get id

loadNodes = (store, ids) ->
    ids.map (id) -> loadNode store, id

loadNodesIm = (store, ids) ->
    ids.map (id) -> loadNodeIm store, id

getChildrenIds = (store, parent) ->
    store.relations
        .filter (relation) -> relation.sourceId is parent.id
        .map (relation) -> relation.targetId


module.exports = {calculateMinMaxMutable, calculateMinMaxSeamless, calculateMinMaxImmutable, calculateMinMaxWithCloning}

