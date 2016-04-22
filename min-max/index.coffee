store = {nodes, relations}

calculateMinMax = (store, nodeId) ->


calculateMinMax = (store, nodeId) ->
    node = store.nodes[nodeId]
    nodeSource = store.relations[sourceId]
    getChildren(store, nodeSource) if (nodeSource)
    return store

getChildren = (store, parent) ->
    childrelations = store.relations.filter (relation) -> relation.sourceid is parent.id
    return childRelations.map (relation) -> store.nodes[relation.targetId]
