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

    uint256 private sizeChecker;
    uint256 private nonceChecker;

    uint256 private constant LOOPS = 5;

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
        sizeChecker++;
        nonceChecker++;

        assertFalse(doublyLinkedList.isEmpty(), "Head and Tail is empty");

        (NodeId headId, NodeId tailId, uint256 size, uint256 nonce) = doublyLinkedList.list();
        IDoublyLinkedList.Node memory headNode = doublyLinkedList.getNode(headId);
        IDoublyLinkedList.Node memory tailNode = doublyLinkedList.getNode(headId);

        NodeId id = DoublyLinkedListLib.computeNodeId(node.value, nonce - 1);
        _assertInitNode(id, headId, tailId, size, nonce, headNode, tailNode);
    }

    function test_insert_front() external {
        vm.prank(address(0xbabe));
        doublyLinkedList.insertFront(node.value);
        _increasSizeAndNonce();

        assertFalse(doublyLinkedList.isEmpty(), "Head and Tail is empty");

        (NodeId headId, NodeId tailId, uint256 size, uint256 nonce) = doublyLinkedList.list();
        IDoublyLinkedList.Node memory headNode = doublyLinkedList.getNode(headId);
        IDoublyLinkedList.Node memory tailNode = doublyLinkedList.getNode(headId);

        NodeId id = DoublyLinkedListLib.computeNodeId(node.value, nonce - 1);
        _assertInitNode(id, headId, tailId, size, nonce, headNode, tailNode);

        for (uint256 i = 0; i < LOOPS; i++) {
            // Second insert
            vm.prank(address(0xbabe));
            doublyLinkedList.insertFront(node.value);
            _increasSizeAndNonce();

            (headId, tailId, size, nonce) = doublyLinkedList.list();
            headNode = doublyLinkedList.getNode(headId);
            tailNode = doublyLinkedList.getNode(tailId);

            _assertHeadAndTail(headId, tailId, size, nonce, headNode, tailNode, nonceChecker - 1, 0);
        }
    }

    function test_insert_end() external {
        vm.prank(address(0xbabe));
        doublyLinkedList.insertEnd(node.value);
        _increasSizeAndNonce();

        assertFalse(doublyLinkedList.isEmpty(), "Head and Tail is empty");

        (NodeId headId, NodeId tailId, uint256 size, uint256 nonce) = doublyLinkedList.list();
        IDoublyLinkedList.Node memory headNode = doublyLinkedList.getNode(headId);
        IDoublyLinkedList.Node memory tailNode = doublyLinkedList.getNode(headId);

        NodeId id = DoublyLinkedListLib.computeNodeId(node.value, nonce - 1);
        _assertInitNode(id, headId, tailId, size, nonce, headNode, tailNode);

        for (uint256 i = 0; i < LOOPS; i++) {
            vm.prank(address(0xbabe));
            doublyLinkedList.insertEnd(node.value);
            _increasSizeAndNonce();

            (headId, tailId, size, nonce) = doublyLinkedList.list();
            headNode = doublyLinkedList.getNode(headId);
            tailNode = doublyLinkedList.getNode(tailId);

            _assertHeadAndTail(headId, tailId, size, nonce, headNode, tailNode, 0, nonceChecker - 1);
        }
    }

    function test_remove_by_value() external {
        vm.prank(address(0xbabe));
        doublyLinkedList.insertEnd(node.value);
        _increasSizeAndNonce();

        assertFalse(doublyLinkedList.isEmpty(), "Head and Tail is empty");

        (NodeId headId, NodeId tailId, uint256 size, uint256 nonce) = doublyLinkedList.list();
        IDoublyLinkedList.Node memory headNode = doublyLinkedList.getNode(headId);
        IDoublyLinkedList.Node memory tailNode = doublyLinkedList.getNode(headId);

        NodeId firstHeadId = headId;

        NodeId id = DoublyLinkedListLib.computeNodeId(node.value, nonce - 1);
        _assertInitNode(id, headId, tailId, size, nonce, headNode, tailNode);

        for (uint256 i = 0; i < LOOPS; i++) {
            vm.prank(address(0xbabe));
            doublyLinkedList.insertEnd(node.value);
            _increasSizeAndNonce();

            (headId, tailId, size, nonce) = doublyLinkedList.list();
            headNode = doublyLinkedList.getNode(headId);
            tailNode = doublyLinkedList.getNode(tailId);

            _assertHeadAndTail(headId, tailId, size, nonce, headNode, tailNode, 0, nonceChecker - 1);
        }

        vm.prank(address(0xbabe));
        doublyLinkedList.removeByValue(node.value);
        sizeChecker--;

        (headId, tailId, size, nonce) = doublyLinkedList.list();
        IDoublyLinkedList.Node memory delNode = doublyLinkedList.getNode(firstHeadId);

        assertEq(delNode.value, 0, "Deleted node value not 0");
        assertEq(NodeId.unwrap(delNode.prev), bytes32(0), "Deleted node prev not 0");
        assertEq(NodeId.unwrap(delNode.next), bytes32(0), "Deleted node next not 0");
        assertNotEq(NodeId.unwrap(headId), NodeId.unwrap(firstHeadId), "Head should have changed");
        assertEq(size, sizeChecker, "Incorrect size after removal");
    }

    function _increasSizeAndNonce() internal {
        sizeChecker++;
        nonceChecker++;
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
        assertEq(_size, sizeChecker, "Incorrect size");
        assertEq(_nonce, nonceChecker, "Incorrect nonce");
        assertEq(_headNode.value, node.value, "Not same node values");
        assertEq(NodeId.unwrap(_headNode.next), bytes32(0), "Next should be zero");
        assertEq(NodeId.unwrap(_headNode.prev), bytes32(0), "Prev should be zero");
        assertEq(NodeId.unwrap(_tailNode.next), bytes32(0), "Next should be zero");
        assertEq(NodeId.unwrap(_tailNode.prev), bytes32(0), "Prev should be zero");
    }

    function _assertHeadAndTail(
        NodeId _headId,
        NodeId _tailId,
        uint256 _size,
        uint256 _nonce,
        IDoublyLinkedList.Node memory _headNode,
        IDoublyLinkedList.Node memory _tailNode,
        uint256 _expectedHeadNonce,
        uint256 _expectedTailNonce
    )
        internal
        view
    {
        NodeId expectedHeadId = DoublyLinkedListLib.computeNodeId(node.value, _expectedHeadNonce);
        NodeId expectedTailId = DoublyLinkedListLib.computeNodeId(node.value, _expectedTailNonce);

        assertEq(NodeId.unwrap(_headId), NodeId.unwrap(expectedHeadId), "Head id mismatch");
        assertEq(NodeId.unwrap(_tailId), NodeId.unwrap(expectedTailId), "Tail id mismatch");
        assertEq(_size, sizeChecker, "Incorrect size");
        assertEq(_nonce, nonceChecker, "Incorrect nonce");
        assertEq(NodeId.unwrap(_headNode.prev), bytes32(0), "Head prev should be zero");
        assertTrue(NodeId.unwrap(_headNode.next) != bytes32(0), "Head next should not be zero");
        assertEq(NodeId.unwrap(_tailNode.next), bytes32(0), "Tail next should be zero");
        assertTrue(NodeId.unwrap(_tailNode.prev) != bytes32(0), "Tail prev should not be zero");
    }
}
