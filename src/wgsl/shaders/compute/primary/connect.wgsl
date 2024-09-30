@compute
@workgroup_size(WORKGROUP_SIZE)
fn connect(@builtin(global_invocation_id) id: vec3u, @builtin(local_invocation_index) lid: u32) {
    // Determine the global path index (i)
    let global_invocation_index = id.x;
    let i = queue.index[CONNECT_QUEUE_ID][global_invocation_index];

    // Default to no queue
    var queue_id: u32 = NULL_QUEUE_ID;

    // Check bounds
    if i < atomicLoad(&queue.count[CONNECT_QUEUE_ID]) {
        // Context
        let path_length = path.length[i];
        let technique = get_technique(i);

        // Intersect
        let source = get_point(CAMERA, ULTIMATE, i);
        let destination = get_point(LIGHT, ULTIMATE, i);
        let direction = normalize(destination - source);
        let ray = Ray(source, direction);
        let intersection = intersect(ray);

        // Validate
        let valid = intersection.valid && approx_eq_vec3f(intersection.point, destination, 1e-6);

        // Determine queue
        queue_id = choose_u32(technique.camera == 1, POST_CONNECT_CAMERA_DIRECT_QUEUE_ID, queue_id);
        queue_id = choose_u32(technique.camera > 1, POST_CONNECT_CAMERA_INDIRECT_QUEUE_ID, queue_id);
        queue_id = choose_u32(valid, queue_id, NULL_QUEUE_ID);
    }

    // Enqueue
    enqueue(i, lid, queue_id);
}