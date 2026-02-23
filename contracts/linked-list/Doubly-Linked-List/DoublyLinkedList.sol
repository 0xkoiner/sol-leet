// SPDX-License-Identifier: MIT
pragma solidity 0.8.33;

import { IDoublyLinkedList } from "./interface/IDoublyLinkedList.sol";
import { DoublyLinkedListLib, NodeId } from "./library/DoublyLinkedListLib.sol";

contract DoublyLinkedList is IDoublyLinkedList {
    using DoublyLinkedListLib for *;

    /**
     *  NodeId headId;
     *  NodeId tailId;
     *  uint256 size;
     *  uint256 nonce;
     *  mapping(NodeId => IDoublyLinkedList.Node) nodes;
     */
    DoublyLinkedListLib.List public list;

    function insertEnd(uint256 _value) external {
        NodeId newId = DoublyLinkedListLib.computeNodeId(_value, list.nonce);
        list.nonce++;
        _insertEnd(_value, newId);
        list.size++;
    }

    function insertFront(uint256 _value) external {
        NodeId newId = DoublyLinkedListLib.computeNodeId(_value, list.nonce);
        list.nonce++;
        _insertFront(_value, newId);
        list.size++;
    }

    function removeByValue(uint256 _value) external {
        if (isEmpty()) return;

        if (list.checkHead(_value) ||  list.checkTail(_value)) return;

        NodeId currentId = list.nodes[list.headId].next;

        while (currentId != DoublyLinkedListLib.DEFAULT) {
            Node storage current = list.nodes[currentId];

            if (current.value == _value) {
                list.nodes[current.prev].next = current.next;
                list.nodes[current.next].prev = current.prev;

                delete list.nodes[currentId];
                list.size--;
                return;
            }

            currentId = current.next;
        }
    }

    function _insertEnd(uint256 _value, NodeId _newId) internal {
        if (isEmpty()) {
            list.initNode(_value, _newId);
        } else {
            list.nodes[list.tailId].next = _newId;
            list.nodes[_newId] = Node(_value, list.tailId, NodeId.wrap(0));
            list.tailId = _newId;

        }
    }

    function _insertFront(uint256 _value, NodeId _newId) internal {
        if (isEmpty()) {
            list.initNode(_value, _newId);
        } else {
            list.nodes[list.headId].prev = _newId;
            list.nodes[_newId] = Node(_value, NodeId.wrap(0), list.headId);
            list.headId = _newId;

        }
    }

    function getNode(NodeId _id) public view returns (Node memory) {
        return list.nodes[_id];
    }

    function isEmpty() public view returns (bool) {
        return DoublyLinkedListLib.isEmpty(list.headId, list.tailId);
    }
}
