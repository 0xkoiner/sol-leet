// SPDX-License-Identifier: MIT
pragma solidity 0.8.33;

import { Data } from "../data/Data.t.sol";
import { console2 as console } from "lib/forge-std/src/console2.sol";
import { IDoublyLinkedList } from "contracts/linked-list/Doubly-Linked-List/interface/IDoublyLinkedList.sol";
import {
    DoublyLinkedListLib,
    NodeId
} from "../../contracts/linked-list/Doubly-Linked-List/library/DoublyLinkedListLib.sol";

contract TestLibrary is Data {
    using DoublyLinkedListLib for *;

    IDoublyLinkedList.Node private node;

    function setUp() public override {
        super.setUp();

        node.value = 101_010_101_010;
        node.prev = NodeId.wrap(keccak256("cafe"));
        node.next = NodeId.wrap(keccak256("babe"));
    }

    function test_compute_node_id() external pure {
        uint256 value = 101_010_101_010;
        uint256 nonce = 1;

        bytes32 hash_a = keccak256(abi.encode(value, nonce));
        bytes32 hash_b = NodeId.unwrap(DoublyLinkedListLib.computeNodeId(value, nonce));

        assertEq(hash_a, hash_b, "Hashes isn't same");
    }

    function test_is_empty() external view {
        bool res = doublyLinkedList.isEmpty();
        assertTrue(res, "Head and Tail isn't empty");
    }

    function test_init_node_by_insert_end() external {
        vm.prank(address(0xbabe));
        doublyLinkedList.insertEnd(node.value);

        assertFalse(doublyLinkedList.isEmpty(), "Head and Tail is empty");

        (NodeId headId, NodeId tailId, uint256 size, uint256 nonce) = doublyLinkedList.list();
        IDoublyLinkedList.Node memory headNode = doublyLinkedList.getNode(headId);
        IDoublyLinkedList.Node memory tailNode = doublyLinkedList.getNode(headId);

        NodeId id = DoublyLinkedListLib.computeNodeId(node.value, nonce - 1);
        _assertInitNode(id, headId, tailId, size, nonce, headNode, tailNode);
    }

    function test_init_node_by_insert_front() external {
        vm.prank(address(0xbabe));
        doublyLinkedList.insertFront(node.value);

        assertFalse(doublyLinkedList.isEmpty(), "Head and Tail is empty");

        (NodeId headId, NodeId tailId, uint256 size, uint256 nonce) = doublyLinkedList.list();
        IDoublyLinkedList.Node memory headNode = doublyLinkedList.getNode(headId);
        IDoublyLinkedList.Node memory tailNode = doublyLinkedList.getNode(headId);

        NodeId id = DoublyLinkedListLib.computeNodeId(node.value, nonce - 1);
        _assertInitNode(id, headId, tailId, size, nonce, headNode, tailNode);
    }

    function _assertInitNode(
        NodeId _id,
        NodeId _headId,
        NodeId _tailId,
        uint256 _size,
        uint256 _nonce,
        IDoublyLinkedList.Node memory _headNode,
        IDoublyLinkedList.Node memory _tailNode
    )
        internal
        view
    {
        assertEq(NodeId.unwrap(_headId), NodeId.unwrap(_id), "Hashes isn't same");
        assertEq(NodeId.unwrap(_tailId), NodeId.unwrap(_id), "Hashes isn't same");
        assertEq(_size, 1, "Incorrect size");
        assertEq(_nonce, 1, "Incorrect nonce");
        assertEq(_headNode.value, node.value, "Not same node values");
        assertEq(NodeId.unwrap(_headNode.next), bytes32(0), "Next should be zero");
        assertEq(NodeId.unwrap(_headNode.prev), bytes32(0), "Prev should be zero");
        assertEq(NodeId.unwrap(_tailNode.next), bytes32(0), "Next should be zero");
        assertEq(NodeId.unwrap(_tailNode.prev), bytes32(0), "Prev should be zero");
    }
}
