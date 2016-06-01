_ = require 'lodash'
now = require 'performance-now'
cloneDeep = require 'lodash/cloneDeep'

calculateMinMaxMutable = (store, nodeId) ->
    calculateMinMax store, nodeId, updateMutable

calculateMinMaxWithCloning = (store, nodeId) ->
    node = loadClonedNode store, nodeId
    childrenIds = getChildrenIds store, node

    if childrenIds.length < 1
        return store

    for childId in childrenIds
        store = calculateMinMaxWithCloning store, childId

    start = now()
    children = loadClonedNodes store, childrenIds
    end = now()
    console.log 'plain JS clone nodes', end-start

    startDate = _.min children.map (node) -> node.dates.startDate
    endDate = _.max children.map (node) -> calculateEndDate node

    updateMutableForCloneAlgorithm(store, node, startDate, endDate)

updateMutableForCloneAlgorithm = (store, node, startDate, endDate) ->
    if node.dates.startDate > startDate
        node.dates.startDate = startDate

    if calculateEndDate(node) < endDate
        node.dates.duration = endDate - node.dates.startDate

    store.nodes[node.id] = node

    return store

loadClonedNodes = (store, ids) ->
    ids.map (id) -> loadClonedNode store, id

loadClonedNode = (store, id) ->
    start = now()
    res = cloneDeep store.nodes[id]
    end = now()
    console.log 'dclone', end-start
    return res

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
    start = now()
    if node.dates.startDate > startDate
        node.dates.startDate = startDate

    if calculateEndDate(node) < endDate
        node.dates.duration = endDate - node.dates.startDate

    end = now()
    console.log 'update plain JS', end-start
    
    return store


loadNode = (store, id) ->
    store.nodes[id]

loadNodes = (store, ids) ->
    ids.map (id) -> loadNode store, id

calculateEndDate = (node) ->
    node.dates.startDate + node.dates.duration

getChildrenIds = (store, parent) ->
    store.relations
        .filter (relation) -> relation.sourceId is parent.id
        .map (relation) -> relation.targetId


module.exports = {calculateMinMaxMutable, calculateMinMaxWithCloning}

