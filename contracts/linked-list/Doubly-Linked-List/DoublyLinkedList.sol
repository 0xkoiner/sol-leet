// SPDX-License-Identifier: MIT
pragma solidity 0.8.33;

import { IDoublyLinkedList } from "./interface/IDoublyLinkedList.sol";
import { DoublyLinkedListLib } from "./library/DoublyLinkedListLib.sol";

contract DoublyLinkedList is IDoublyLinkedList {
    using DoublyLinkedListLib for *;

    Node public head;
    Node public tail;

    function isEmpty() external view returns (bool) {
        return head.isEmpty(tail);
    }
}
