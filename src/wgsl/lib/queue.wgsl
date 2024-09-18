// TODO: maybe use workgroup_id instead of global_invocation_id; let id = workgroup_index * WORKGROUP_SIZE + i;
fn enqueue(global_invocation_id: u32, local_invocation_id: u32, queue_id: u32) {
    workgroup_queue_ballot[local_invocation_id] = queue_id;

    workgroupBarrier();

    if local_invocation_id >= QUEUE_COUNT {
        return;
    }

    var tally: u32 = 0;

    for (var i: u32 = 0; i < WORKGROUP_SIZE; i++) {
        let queue_index = workgroup_queue_ballot[i];
        tally = tally + u32(queue_index == local_invocation_id);
    }

    if tally == 0 {
        return;
    }

    var index = atomicAdd(&queue_counts[local_invocation_id], tally);
    let last_index = index + tally - 1;

    for (var i: u32 = 0; i < WORKGROUP_SIZE; i++) {
        let queue_index = workgroup_queue_ballot[i];
        let id = global_invocation_id - local_invocation_id + i;
        let index_match = queue_index == local_invocation_id;
        queues[queue_index][index] = choose_u32(index_match, id, queues[queue_index][index]);
        index = index + u32(index_match && index < last_index);
    }
}