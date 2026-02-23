// SPDX-License-Identifier: MIT
pragma solidity 0.8.33;

import {Test, console2 as console} from "lib/forge-std/src/Test.sol";
import {IDoublyLinkedList} from "contracts/linked-list/Doubly-Linked-List/interface/IDoublyLinkedList.sol";
import { DoublyLinkedListLib, NodeId } from "../../contracts/linked-list/Doubly-Linked-List/library/DoublyLinkedListLib.sol";

contract TestComputeNodeId is Test, IDoublyLinkedList {
    using DoublyLinkedListLib for *;

    Node private node;

    function setUp() public {
        node.value = 101010101010;
        node.prev = NodeId.wrap(keccak256("cafe"));
        node.next = NodeId.wrap(keccak256("babe"));
    }

    function test_compute_node_id() external {
        bytes32 hash_a = keccak256(abi.encodePacked(node.value, node.prev, node.next));
        bytes32 hash_b = NodeId.unwrap(node.computeNodeId());

        assertEq(hash_a, hash_b, "Hashes isn't same");
    }
}
