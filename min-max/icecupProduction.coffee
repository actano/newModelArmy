Icecup = require '../icecup'
icecup = Icecup(true)
now = require 'performance-now'

calculateMinMax = (store, nodeId) ->
    node = loadNode store, nodeId
    childrenIds = getChildrenIds store, node

    if childrenIds.length < 1
        return store

    for childId in childrenIds
        store = calculateMinMax store, childId

    children = loadNodes store, childrenIds

    startDate = Math.min icecup.map children, (node) -> node.dates.startDate
    endDate = Math.max icecup.map children, (node) -> calculateEndDate node

    update(store, node, startDate, endDate)

update = (store, node, startDate, endDate) ->
    start = now()
    if node.dates.startDate > startDate
        store = icecup.setIn store, ['nodes', node.id, 'dates', 'startDate'], startDate

    if calculateEndDate(node) < endDate
        store = icecup.setIn store, ['nodes', node.id, 'dates', 'duration'], endDate - startDate

    end = now()
    console.log 'update icecup', end-start
        
    return store

loadNode = (store, id) ->
    store.nodes[id]

loadNodes = (store, ids) ->
    icecup.map ids, (id) -> loadNode store, id

calculateEndDate = (node) ->
    node.dates.startDate + node.dates.duration

getChildrenIds = (store, parent) ->
    res = icecup.filter store.relations, (relation) -> relation.sourceId is parent.id
    return icecup.map res, (relation) -> relation.targetId

module.exports = {calculateMinMax}