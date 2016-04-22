Immutable = require 'immutable'

class Dates extends Immutable.Record {startDate: null, duration: null}

class Node extends Immutable.Record {id: null, dates: null, info: null}

class Relation extends Immutable.Record {id: null, sourceId: null, targetId: null}

class Store extends Immutable.Record {rootId: null, nodes: null, relations: null}

createNode = (obj) ->
    return new Node (
        id: obj.id,
        dates: new Dates(Immutable.fromJS(obj.dates)),
        info: Immutable.fromJS obj.info
    )

createStore = (obj) ->
    nodes = Immutable.Map()
    relations = Immutable.List()

    for key, value of obj.nodes
        nodes = nodes.set key, createNode value

    for relation in obj.relations
        relations = relations.push new Relation relation

    return new Store (
        rootId: obj.rootId
        nodes: nodes
        relations: relations
    )

module.exports = {Store, Relation, Node, Dates, createNode, createStore}