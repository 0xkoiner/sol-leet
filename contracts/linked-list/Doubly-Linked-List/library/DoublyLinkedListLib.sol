// SPDX-License-Identifier: MIT
pragma solidity 0.8.33;

import { IDoublyLinkedList } from "../interface/IDoublyLinkedList.sol";

type NodeId is bytes32;

library DoublyLinkedListLib {
    NodeId constant DEFAULT = NodeId.wrap(0);

    struct List {
        NodeId headId;
        NodeId tailId;
        uint256 size;
        uint256 nonce;
        mapping(NodeId => IDoublyLinkedList.Node) nodes;
    }

    function computeNodeId(uint256 _value, uint256 _nonce) internal pure returns (NodeId nodeId) {
        assembly {
            mstore(0x00, _value)
            mstore(0x20, _nonce)
            nodeId := keccak256(0x00, 0x40)
        }
    }

    function initNode(List storage _list, uint256 _value, NodeId _newId) internal {
        _list.headId = _newId;
        _list.tailId = _newId;
        _list.nodes[_newId] = IDoublyLinkedList.Node(_value, NodeId.wrap(0), NodeId.wrap(0));
    }

    function isEmpty(NodeId _headId, NodeId _tailId) internal pure returns (bool result) {
        assembly {
            result := and(iszero(_headId), iszero(_tailId))
        }
    }
}
