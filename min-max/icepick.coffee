_ = require 'lodash'
{setIn, filter, map} = require 'icepick'

calculateMinMax = (store, nodeId) ->
    node = loadNode store, nodeId
    childrenIds = getChildrenIds store, node

    if childrenIds.length < 1
        return store

    for childId in childrenIds
        store = calculateMinMax store, childId

    children = loadNodes store, childrenIds

    startDate = _.min map ((node) -> node.dates.startDate), children
    endDate = _.max map ((node) -> calculateEndDate node), children

    update(store, node, startDate, endDate)

update = (store, node, startDate, endDate) ->
    if node.dates.startDate > startDate
        store = setIn store, ['nodes', node.id, 'dates', 'startDate'], startDate

    if calculateEndDate(node) < endDate
        store = setIn store, ['nodes', node.id, 'dates', 'duration'], endDate - startDate

    return store

loadNode = (store, id) ->
    store.nodes[id]

loadNodes = (store, ids) ->
    console.log 'frozen', Object.isFrozen ids
    res = ids.map (id) -> loadNode store, id
    console.log 'res', res
    return res

calculateEndDate = (node) ->
    node.dates.startDate + node.dates.duration

getChildrenIds = (store, parent) ->
        res = filter ((relation) -> relation.sourceId is parent.id), store.relations
        return map ((relation) -> relation.targetId), res

module.exports = {calculateMinMax}