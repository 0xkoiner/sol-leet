// SPDX-License-Identifier: MIT
pragma solidity 0.8.33;

import { Data } from "../data/Data.t.sol";
import { console2 as console } from "lib/forge-std/src/console2.sol";
import { IDoublyLinkedList } from "contracts/linked-list/Doubly-Linked-List/interface/IDoublyLinkedList.sol";
import {
    DoublyLinkedListLib,
    NodeId
} from "../../contracts/linked-list/Doubly-Linked-List/library/DoublyLinkedListLib.sol";

contract TestLibrary is Data, IDoublyLinkedList {
    using DoublyLinkedListLib for *;

    Node private node;

    function setUp() public override {
        super.setUp();

        node.value = 101_010_101_010;
        node.prev = NodeId.wrap(keccak256("cafe"));
        node.next = NodeId.wrap(keccak256("babe"));
    }

    function test_compute_node_id() external view {
        bytes32 hash_a = keccak256(abi.encodePacked(node.value, node.prev, node.next));
        bytes32 hash_b = NodeId.unwrap(node.computeNodeId());

        assertEq(hash_a, hash_b, "Hashes isn't same");
    }

    function test_is_empty() external view { 
        bool res = doublyLinkedList.isEmpty();
        assertTrue(res, "Head and Tail isn't empty");
    }
}
