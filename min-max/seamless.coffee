_ = require 'lodash'

calculateMinMax = (store, nodeId) ->
    node = loadNode store, nodeId
    childrenIds = getChildrenIds store, node

    if childrenIds.length < 1
        return store

    for childId in childrenIds
        store = calculateMinMax store, childId

    children = loadNodes store, childrenIds

    startDate = _.min children.map (node) -> node.dates.startDate
    endDate = _.max children.map (node) -> calculateEndDate node

    update(store, node, startDate, endDate)

update = (store, node, startDate, endDate) ->
    if node.dates.startDate > startDate
        store = store.setIn ['nodes', node.id, 'dates', 'startDate'], startDate

    if calculateEndDate(node) < endDate
        store = store.setIn ['nodes', node.id, 'dates', 'duration'], endDate - startDate

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

module.exports = {calculateMinMax}