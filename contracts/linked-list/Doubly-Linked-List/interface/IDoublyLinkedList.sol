// SPDX-License-Identifier: MIT
pragma solidity 0.8.33;

import { NodeId } from "../library/DoublyLinkedListLib.sol";

interface IDoublyLinkedList {
    struct Node {
        uint256 value;
        NodeId prev;
        NodeId next;
    }
}
