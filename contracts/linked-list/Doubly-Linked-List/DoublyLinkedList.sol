// SPDX-License-Identifier: MIT
pragma solidity 0.8.33;

import { IDoublyLinkedList } from "./interface/IDoublyLinkedList.sol";

contract DoublyLinkedList is IDoublyLinkedList {
    Node public head;
    Node public tail;
}
