// SPDX-License-Identifier: MIT
pragma solidity 0.8.33;

import { NodeId } from "../library/DoublyLinkedListLib.sol";

interface IDoublyLinkedList {
    struct Node {
        uint256 value;
        NodeId prev;
        NodeId next;
    }

    function insertEnd(uint256 _value) external;

    function isEmpty() external view returns (bool);
}
