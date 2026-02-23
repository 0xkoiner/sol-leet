// SPDX-License-Identifier: MIT
pragma solidity 0.8.33;

import { IDoublyLinkedList } from "../interface/IDoublyLinkedList.sol";

type NodeId is bytes32;

library DoublyLinkedListLib {
    NodeId constant DEFAULT = NodeId.wrap(0);

    function computeNodeId(IDoublyLinkedList.Node memory _node) internal pure returns (NodeId nodeId) {
        assembly {
            // _node is a memory pointer to the struct
            // struct layout: [value (0x00) | next (0x20) | prev (0x40)]
            nodeId := keccak256(_node, 0x60)
        }
    }

    function isEmpty(
        IDoublyLinkedList.Node storage _head,
        IDoublyLinkedList.Node storage _tail
    )
        internal
        view
        returns (bool result)
    {
        assembly {
            result := and(iszero(sload(add(_head.slot, 2))), iszero(sload(add(_tail.slot, 1))))
        }
    }
}
