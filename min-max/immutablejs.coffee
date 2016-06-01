_ = require 'lodash'
now = require 'performance-now'

calculateMinMax = (store, nodeId) ->
    node = loadNode store, nodeId
    childrenIds = getChildrenIds store, node

    if childrenIds.size < 1
        return store

    childrenIds.forEach (childId) ->
        store = calculateMinMax store, childId

    children = loadNodes store, childrenIds

    startDate = children.map((node) -> node.dates.startDate).min()
    endDate = children.map((node) -> calculateEndDate node).max()

    update(store, node, startDate, endDate)

update = (store, node, startDate, endDate) ->
    start = now()
    if node.dates.startDate > startDate
        store = store.setIn ['nodes', node.id, 'dates', 'startDate'], startDate

    if calculateEndDate(node) < endDate
        store = store.setIn ['nodes', node.id, 'dates', 'duration'], endDate - startDate

    end = now()
    console.log 'update immutableJS', end-start
    
    return store    

loadNodes = (store, ids) ->
    ids.map (id) -> loadNode store, id

loadNode = (store, id) ->
    store.nodes.get id

calculateEndDate = (node) ->
    node.dates.startDate + node.dates.duration

getChildrenIds = (store, parent) ->
    store.relations
        .filter (relation) -> relation.sourceId is parent.id
        .map (relation) -> relation.targetId

module.exports = {calculateMinMax}