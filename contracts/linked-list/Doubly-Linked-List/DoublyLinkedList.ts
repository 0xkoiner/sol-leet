// Doubly link list

class NodeD<T> {
    value: T;
    next: NodeD<T> | null;
    prev: NodeD<T> | null;

    constructor(value: T) {
        this.value = value;
        this.next = null;
        this.prev = null;
    }
}

class DoublyLinkedList<T> {
    head: NodeD<T> | null;
    tail: NodeD<T> | null;

    constructor() {
        this.head = null;
        this.tail = null;
    }

    public insertEnd(value: T) {
        const node = new NodeD(value);

        this.checkIsEmpty() ? (this.head = node, this.tail = node) :
            (this.tail!.next = node, node.prev = this.tail, this.tail = node);
    }

    public insertFront(value: T) {
        const node = new NodeD(value);

        this.checkIsEmpty() ? (this.head = node, this.tail = node) :
            (this.head!.prev = node, node.next = this.head, this.head = node);
    }

    public removeByValue(value: T) {
        let node = this.head;

        if (this.head?.value === value) {
            node = this.head!.next;
            node!.prev = null;
            return;
        } else if (this.tail?.value === value) {
            node = this.tail!.prev
            node!.next = null
            return;
        }

        while (node?.next !== null) {
            if (node?.value === value) {
                const prev = node.prev;
                const next = node.next;

                prev!.next = next;
                next!.prev = prev;

                break;
            }
            node = node!.next;
        }
    }

    public traverseForward(node: NodeD<T>) {
        while (node?.next !== null) {
            console.log(node.value);
            node = node.next;
        }
    }

    public traverseBackward(node: NodeD<T>) {
        while (node?.prev !== null) {
            console.log(node.value);
            node = node.prev;
        }
    }

    public checkIsEmpty(): boolean {
        return this.head === null && this.tail === null;
    }

    public size(): bigint {
        if (!this.checkIsEmpty()) {
            return 0n;
        }

        let node = this.head;
        let counter: bigint = 1n; 
        
        while(node?.next !== null) {
            node = node!.next;
            counter ++;
        }

        return counter;
    }
}