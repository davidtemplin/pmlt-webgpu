fn enqueue(global_path_index: u32, local_invocation_index: u32, queue_id: u32) {
    workgroup_queue_ballot[local_invocation_index] = queue_id;

    workgroupBarrier();

    if local_invocation_index >= QUEUE_COUNT {
        return;
    }

    if queue_id == NULL_QUEUE_ID {
        return;
    }

    var tally: u32 = 0;

    for (var i: u32 = 0; i < WORKGROUP_SIZE; i++) {
        let queue_index = workgroup_queue_ballot[i];
        tally = tally + u32(queue_index == local_invocation_index);
    }

    if tally == 0 {
        return;
    }

    var index = atomicAdd(&queue.count[local_invocation_index], tally);
    let last_index = index + tally - 1;

    for (var i: u32 = 0; i < WORKGROUP_SIZE; i++) {
        let queue_index = workgroup_queue_ballot[i];
        let id = global_path_index - local_invocation_index + i;
        let index_match = queue_index == local_invocation_index;
        queue.index[local_invocation_index][index] = choose_u32(index_match, id, queue.index[local_invocation_index][index]);
        index = index + u32(index_match && index < last_index);
    }
}