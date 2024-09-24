@compute
@workgroup_size(1)
fn dispatch() {
    for (var queue_id: u32 = 0; queue_id < QUEUE_COUNT; queue_id++) {
        let count = atomicLoad(&queue.count[queue_id]);
        let workgroup_count = u32(ceil(f32(count) / f32(WORKGROUP_SIZE)));
        dispatch_indirect_parameters[queue_id] = vec3u(workgroup_count, 1, 1);
    }
}