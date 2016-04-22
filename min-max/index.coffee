store = {nodes, relations}

calculateMinMax = (store, nodeId) ->


calculateMinMax = (store, nodeId) ->

    node = store.nodes[nodeId]



    return store

getChildren = (store, parent) ->
    childRelations = store.relations.filter (relation) -> relation.sourceId is parent.id
    return childRelations.map (relation) -> store.nodes[relation.targetId]
