// SPDX-License-Identifier: MIT
pragma solidity 0.8.33;

import { Test, console2 as console } from "lib/forge-std/src/Test.sol";
import { DoublyLinkedList } from "../../contracts/linked-list/Doubly-Linked-List/DoublyLinkedList.sol";

contract Data is Test {
    DoublyLinkedList doublyLinkedList;

    function setUp() public virtual {
        doublyLinkedList = new DoublyLinkedList();
    }
}
